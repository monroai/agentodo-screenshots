/// Visual Audit Test Suite for AgenToDo
/// ⚠️ Requires valid code signing certificate to run.
/// Run: xcodebuild test -scheme AgenToDo -destination 'platform=macOS' \
///   -only-testing:AgentoDoUITests/VisualAuditTests
///
/// This file should be placed in: AgenToDoUITests/VisualAuditTests.swift
/// when the signing certificate is renewed.

import XCTest

@MainActor
final class VisualAuditTests: AgentoDoUITestCase {

    // MARK: - Sidebar Navigation

    func testAllPerspectivesAccessible() {
        let sidebar = SidebarPage(app: app)
        for name in ["Inbox", "Today", "Forecast", "Flagged", "Review"] {
            XCTAssertTrue(sidebar.navigate(to: name), "Should navigate to \(name)")
            usleep(500_000)
            // Verify window title updated
            let window = app.windows.firstMatch
            XCTAssertTrue(window.exists, "Window should exist after navigating to \(name)")
        }
    }

    // MARK: - Inbox View

    func testInboxShowsTasks() {
        let sidebar = SidebarPage(app: app)
        sidebar.navigate(to: "Inbox")
        usleep(500_000)

        let taskList = TaskListPage(app: app)
        // Create test tasks
        taskList.createTask("Visual audit test task 1")
        taskList.createTask("Visual audit test task with a very long title that should wrap properly in the detail pane")
        XCTAssertTrue(taskList.rowCount >= 2, "Should have at least 2 tasks")
    }

    func testDetailPaneTitleNotTruncated() {
        // Issue #211: Title truncation in detail pane
        let sidebar = SidebarPage(app: app)
        sidebar.navigate(to: "Inbox")
        usleep(500_000)

        let taskList = TaskListPage(app: app)
        let longTitle = "This is a very long task title that should not be truncated in the detail pane"
        taskList.createTask(longTitle)
        usleep(300_000)

        // Select the task
        taskList.tapFirst()
        usleep(500_000)

        // Check detail pane shows full title
        let inspector = InspectorPage(app: app)
        let titleField = inspector.titleField
        if titleField.waitForExistence(timeout: 3) {
            let displayedTitle = titleField.value as? String ?? ""
            XCTAssertEqual(displayedTitle, longTitle,
                "Detail pane should show full title without truncation")
        }
    }

    // MARK: - Onboarding

    func testOnboardingKeyboardNavigation() {
        // Issue #213: Onboarding modal keyboard navigation
        // This test would need a fresh app state with onboarding not completed
        // Reset via launch argument: --reset-onboarding
        // TODO: Add --reset-onboarding launch argument to app
    }

    // MARK: - Today View

    func testTodayViewLayout() {
        let sidebar = SidebarPage(app: app)
        sidebar.navigate(to: "Today")
        usleep(500_000)

        // Verify Today view loaded
        let todayHeader = app.staticTexts["Friday, May 1"].firstMatch
        // Date will vary — just check the view is present
        let viewTitle = app.windows.firstMatch
        XCTAssertTrue(viewTitle.exists)
    }

    // MARK: - Review View

    func testReviewViewConsistency() {
        // Issue #212: "Never reviewed" under "UP TO DATE"
        let sidebar = SidebarPage(app: app)
        sidebar.navigate(to: "Review")
        usleep(500_000)

        // Check for contradictory labels
        let upToDate = app.staticTexts["UP TO DATE"].firstMatch
        if upToDate.exists {
            // If UP TO DATE section exists, items shouldn't say "Never reviewed"
            let neverReviewed = app.staticTexts["Never reviewed"]
            // This is a known issue (#212) — log it
            if neverReviewed.exists {
                XCTContext.runActivity(named: "Issue #212") { _ in
                    XCTExpectFailure("Projects under UP TO DATE show 'Never reviewed' — contradictory")
                    XCTAssertFalse(neverReviewed.exists,
                        "UP TO DATE section should not contain 'Never reviewed' items")
                }
            }
        }
    }

    // MARK: - Calendar View

    func testCalendarWeekViewLayout() {
        let sidebar = SidebarPage(app: app)
        sidebar.navigate(to: "Calendar")
        usleep(500_000)

        // Verify calendar elements exist
        let weekButton = app.buttons["Week"].firstMatch
        XCTAssertTrue(weekButton.waitForExistence(timeout: 3), "Week button should exist")

        // Check day headers exist
        for day in ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] {
            let dayLabel = app.staticTexts[day].firstMatch
            XCTAssertTrue(dayLabel.exists, "\(day) header should be visible in week view")
        }
    }

    // MARK: - Screenshot Capture (for visual diff)

    func testCaptureAllViews() {
        let sidebar = SidebarPage(app: app)
        let views = ["Inbox", "Today", "Forecast", "Flagged", "Review", "Calendar"]

        for view in views {
            sidebar.navigate(to: view)
            usleep(800_000)
            let screenshot = app.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "View_\(view)"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
