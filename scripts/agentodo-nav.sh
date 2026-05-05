#!/bin/bash
# AgenToDo UI Navigation Helper
# Usage: agentodo-nav.sh <action> [args]
#   navigate <view_name>  - Click sidebar item by name (Inbox, Today, Forecast, etc.)
#   click-task <index>    - Click task at index (1-based) in current list
#   screenshot [name]     - Take screenshot, save as JPEG for analysis
#   window-title          - Get current window title
#   list-sidebar          - List all sidebar items
#   select-row <n>        - Click sidebar row by number

ACTION="$1"
shift

WORKSPACE="/Users/angelo/.openclaw/workspace"
PROCESS="AgentToDo"

screenshot() {
    local name="${1:-screenshot}"
    osascript -e "tell application \"$PROCESS\" to activate"
    sleep 0.5
    screencapture -x "$WORKSPACE/${name}.png"
    sips -s format jpeg -s formatOptions 50 -Z 1200 "$WORKSPACE/${name}.png" --out "$WORKSPACE/${name}.jpg" 2>/dev/null
    echo "$WORKSPACE/${name}.jpg"
}

case "$ACTION" in
    navigate)
        VIEW_NAME="$1"
        osascript -e "
tell application \"$PROCESS\" to activate
delay 0.3
tell application \"System Events\"
    tell process \"$PROCESS\"
        tell outline 1 of scroll area 1 of group 1 of splitter group 1 of group 1 of window 1
            set rowCount to count of rows
            repeat with i from 1 to rowCount
                try
                    set rowTexts to value of every static text of UI element 1 of row i
                    repeat with t in rowTexts
                        if t as text is \"$VIEW_NAME\" then
                            select row i
                            return \"Navigated to $VIEW_NAME (row \" & i & \")\"
                        end if
                    end repeat
                end try
            end repeat
        end tell
    end tell
end tell
return \"View not found: $VIEW_NAME\"
"
        ;;

    click-task)
        INDEX="$1"
        osascript -e "
tell application \"System Events\"
    tell process \"$PROCESS\"
        tell group 2 of splitter group 1 of group 1 of window 1
            -- Task list is in the content area
            tell splitter group 1
                tell group 1
                    -- Try to find task rows in scroll areas
                    set taskRow to row $INDEX of table 1 of scroll area 1
                    perform action \"AXPress\" of taskRow
                    return \"Clicked task $INDEX\"
                end tell
            end tell
        end tell
    end tell
end tell
" 2>&1 || echo "Task click via table failed, trying alternative..."
        ;;

    screenshot)
        screenshot "${1:-agentodo}"
        ;;

    window-title)
        osascript -e "
tell application \"System Events\"
    tell process \"$PROCESS\"
        return name of window 1
    end tell
end tell
"
        ;;

    list-sidebar)
        osascript -e "
tell application \"System Events\"
    tell process \"$PROCESS\"
        tell outline 1 of scroll area 1 of group 1 of splitter group 1 of group 1 of window 1
            set rowCount to count of rows
            set output to \"\"
            repeat with i from 1 to rowCount
                try
                    set rowTexts to value of every static text of UI element 1 of row i
                    set output to output & \"Row \" & i & \": \" & (rowTexts as text) & \"\n\"
                on error
                    set output to output & \"Row \" & i & \": (group/separator)\n\"
                end try
            end repeat
            return output
        end tell
    end tell
end tell
"
        ;;

    select-row)
        ROW="$1"
        osascript -e "
tell application \"$PROCESS\" to activate
delay 0.2
tell application \"System Events\"
    tell process \"$PROCESS\"
        tell outline 1 of scroll area 1 of group 1 of splitter group 1 of group 1 of window 1
            select row $ROW
        end tell
    end tell
end tell
"
        ;;

    *)
        echo "Usage: agentodo-nav.sh <action> [args]"
        echo "Actions: navigate, click-task, screenshot, window-title, list-sidebar, select-row"
        ;;
esac
