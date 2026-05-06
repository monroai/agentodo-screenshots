# MEMORY.md — Monro's Long-Term Memory

## Rules
- **QUIET HOURS: 23:00–08:00 Europe/Kiev — DO NOT message Oleksandr.** No exceptions unless he initiates or something is genuinely urgent. Background work (testing, filing issues) is fine — just don't send messages.
- If Oleksandr says "don't bother me until morning" — that means ZERO outbound messages until he writes first.

## Who I Am
- **Monro** — UI/UX Tester @ MacPaw, AgenToDo team
- GitHub: `monroai`
- Report to: Oleksandr Kosovan (CEO, MacPaw)
- Style: Steve Jobs-level quality bar. Ship nothing mediocre.

## AgenToDo Project
- **Repo:** `MacPaw/AgenToDo` — path: `/Users/angelo/Code/AgenToDo`
- **Platforms:** macOS 26 (Tahoe), iOS 26
- **Build:** XcodeGen → xcodebuild
- **Screenshots repo:** `monroai/agentodo-screenshots` (for issue attachments)
- **DEVELOPER_DIR:** `/Applications/Xcode.app/Contents/Developer` (not CommandLineTools)
- **Scheme name:** `AgenToDo` (capital T D)
- **DerivedData app:** `~/Library/Developer/Xcode/DerivedData/AgenToDo-*/Build/Products/Debug/AgentToDo.app`
- **Test runner:** `./scripts/run_tests.sh --ui` (handles signing, build, report)
- **xcresulttool:** `/Applications/Xcode.app/Contents/Developer/usr/bin/xcresulttool`
- **Ad-hoc build:** `CODE_SIGN_IDENTITY=- CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO` (but UI tests NEED real signing)

## Issue History
- **May 1:** First review cycle — filed #234–#243, #248. Then evening session: #270–#293, #305–#335, #357–#398, #406–#416
- **May 2 morning:** Post-53-commit update — filed #419–#440 (22 issues)
- **May 2 deep session:** Filed ~100 issues (#501–#666) across 6 batches: agentic, location, settings, context menus/detail/search, UI test failures, attachments/widgets/import
- **May 2 post-fix session:** 356 commits of fixes applied. Filed 30 more issues (regressions, performance, new bugs). Some fixes verified, #419 sidebar off-by-one STILL broken.
- **May 3 overnight session:** Filed 40 issues (#892–#931) on iCloud sync, daemon, CLI. Found sync state stored in wrong directory, conflict resolution data loss, CLI quickadd not resolving tags/projects, daemon XPC sink leak.
- **May 4 review:** 1,536 commits of fixes. Verified sidebar off-by-one finally fixed, perf improvements, perspective fixes. Found #890 still broken (Settings Escape). 297 of ~400 issues now closed.
- **Grand total:** ~400 issues filed, 297 closed

### Verified Fixes (May 2 evening)
- ✅ #572 — Note onChange debounced at 600ms (was per-keystroke)
- ✅ #584 — "With notes" search chip is now a proper filter token pill
- ✅ #593 — UI test targets opted out of Swift 6 strict concurrency
- ✅ #571 — Title edits routed through TaskService for undo/sync
- ✅ #567 — "Show Onboarding Again" deferred to next launch
- ✅ #568 — Connection test result cleared on AI provider switch
- ✅ Task detail panel works — shows all fields correctly

### Verified Fixes (May 4 — Post-1536-Commit Review)
- ✅ #419/#800/#852 — **Sidebar off-by-one FINALLY FIXED** — the zombie bug that survived 356 commits. Navigation works correctly for all perspectives.
- ✅ #850 — Nuclear Reset crash fixed (clear selection before reset)
- ✅ #832 — Quick Entry focus trap fixed
- ✅ #831 — Cmd+W correctly closes secondary windows
- ✅ #570 — Sync tab timer 1s→30s
- ✅ #607 — Space-to-complete restored
- ✅ #804/#805 — Full-table fetches eliminated, 6 views now use predicated queries
- ✅ #823 — ContentView split from 2100→1389 lines
- ✅ #816 — Forecast O(n×m)→O(n+m) dictionary lookup
- ✅ #807/#808 — Timer cleanup (polling replaced by event-driven)
- ✅ #932–#939 — CLI quickadd/perspectives all fixed
- ✅ #915 — Daemon NSLock→serial queue
- ✅ #940/#941 — Waiting On/Review correctly filter (verified visually)
- ✅ #946/#947 — JSON key naming fixed

### Still Open (May 4)
- ❌ #890 — Settings Escape — was fixed (PR #1025, closed May 4)
- ❌ ~~Cmd+K command bar~~ — WRONG. Cmd+K = Clean Up, not command bar. ⌘E = command bar. Fixed in PR #999.
- ❌ ~80 open issues remain, mostly P2/P3 UI polish/CLI/sync/enhancement

### Incorrectly Filed (May 4 evening — LESSON LEARNED)
- #1040, #1044, #1047 — sidebar navigation (already fixed in #800/#852) — CLOSED
- #1041 — badge count (already fixed in #809/#1008) — CLOSED
- #1046 — keyboard shortcuts (related to fixed nav) — CLOSED
- #1043 — selection state persist (related to fixed nav) — CLOSED
- #1079 — Cmd+K command bar (Cmd+K is Clean Up, not command bar) — CLOSED
- #869, #829 — MacPaw 🐾 branding (it's their logo!) — CLOSED
- #815 — shortcuts blocked in Settings (by design) — CLOSED

### Historical Critical Patterns (RESOLVED)
1. ~~Sidebar off-by-one~~ — **FIXED May 4**
2. ~~ContentView 12 unfiltered fetches~~ — **FIXED** (targeted fetches)
3. ~~6 views with unfiltered @Query~~ — **FIXED** (predicated queries)
4. ~~Multiple unnecessary timers~~ — **FIXED** (event-driven + idle pause)

## Hard Lessons

### From Oleksandr's Feedback (May 1)
1. **ALWAYS attach screenshots** — no exceptions. Every. Single. Issue.
2. **Verify which app you're looking at** — filed #241 about Claude's sidebar.
3. **Know standard UI patterns** — #218 was just a current time indicator.
4. **Don't assume setup context** — #234 onboarding wasn't bugged, data was pre-loaded.
5. **"Different" ≠ "wrong"** — #243 pagination was intentional design.
6. **Question the premise first** — "should this exist?" before "this is missing."
7. **File issues as you go** — don't batch. Session can hang, context lost.

### From Testing Experience (May 2)
8. **Run existing tests FIRST** — the UI test suite immediately revealed the background-thread violation that explains most cascading failures. Visual testing found ~100 issues, but running tests would have identified the root cause much sooner.
9. **Code review catches more than screenshots** — on a Mac mini without display/mouse, deep code review found threading violations, race conditions, dedup logic bugs, missing validation that visual testing never would.
10. **Visual testing catches what tests never will** — SF fallback coordinates, quiet hours silently suppressing notifications, attachment markers leaking into plain text, missing cancel buttons, off-by-one navigation. Oleksandr confirmed: "We actually did great by testing visually, you discovered tons of new bugs!"
11. **Batch filing with subagents is efficient** — 20 issues per subagent, pre-written descriptions, ~3 minutes per batch. Much faster than one at a time.
12. **The signing cert expires periodically** — always check `security find-identity -v -p codesigning` before test sessions needing real signing.
13. **Swift 6 + XCTest don't mix** — keep test targets in Swift 5 mode. Production code can stay fully Swift 6.
14. **"Fixed" doesn't mean fixed** — always verify. #419 survived 356 commits. Trust screenshots over commit messages.
15. **Performance bugs hide behind feature bugs** — 12 unfiltered fetches in ContentView were invisible until I specifically scanned for `FetchDescriptor<TodoTask>()` patterns.

### From Oleksandr's Feedback (May 5) — Round 1
16. **🐾 MacPaw branding is the LOGO** — the paw/"by MacPaw" in the sidebar is their company signature. NEVER file it as a bug. It's intentional branding.
17. **CHECK CLOSED ISSUES BEFORE RE-FILING** — I filed #1040/#1044/#1047 (sidebar nav), #1041 (badge counts), #1046 (keyboard shortcuts) as new issues when they were ALREADY FIXED and closed (#800/#852/#809). Always check closed issues with comments before filing a duplicate.
18. **BUILD FRESH BEFORE TESTING** — many of my May 4 evening issues were filed against a stale build. The fixes were already merged. Always `git pull && xcodegen generate && build` before a new test session.
19. **READ PROJECT DOCS** — Cmd+K is Clean Up (not command bar). ⌘E is command bar. The AGENTS.md was updated in PR #999. Always check latest docs before assuming functionality is broken.
20. **"By design" means CLOSE IT** — #815 (shortcuts blocked in Settings), #565 (Nuclear Reset no undo), #812 (chat bubble glitch), #847 (voice feedback exists) — all closed by Oleksandr. Don't re-file "by design" decisions.
21. **Don't reopen closed issues without verifying the fix is actually broken** — Oleksandr closed issues for a reason. If something looks wrong, first check the closed issue comments, then build fresh, then test. Only file new if confirmed regression.

### From Oleksandr's Feedback (May 5) — Round 2
22. **SCREENSHOTS MANDATORY — CALLED OUT AGAIN** — Issues #1073, #1077, #1081, #1084-1086, #1088-1090 were all filed without screenshots. Oleksandr caught it immediately. This is the SECOND time. NO MORE EXCUSES. Screenshot → push to repo → reference in issue body. Every. Single. Time.
23. **INCLUDE SYSTEM/BUILD INFO** — Intel Mac mini + older macOS renders differently than Apple Silicon + Tahoe. Every issue needs: hardware, OS version, build type, Xcode version, screen resolution. Devs can't reproduce without knowing the platform.

## Issue Quality Bar
- One issue = one clear fix. If the fix isn't obvious, rewrite.
- Root cause > symptom. Attach file + line number.
- Would this ship at Apple? That's the bar.
- Simplify, don't add. Remove clutter over adding features.
- **🚨 SCREENSHOTS ARE MANDATORY — NO EXCEPTIONS 🚨** — Every issue MUST have at least one screenshot attached BEFORE filing. Push to `monroai/agentodo-screenshots` repo first, then reference in the issue body. If you can't screenshot it, say "code review only" explicitly. Oleksandr has called this out TWICE (May 1 and May 5). DO NOT FILE WITHOUT SCREENSHOTS.
- **🚨 SYSTEM INFO IS MANDATORY 🚨** — Every issue MUST include system/build details: Hardware (Intel/AS), macOS version, app build type (ad-hoc/signed), Xcode version, screen resolution. On Intel + older OS the app renders differently — devs need this context.
- **CHECK CLOSED ISSUES FIRST** — search for related closed issues before filing. Read Oleksandr's comments.
- **BUILD FRESH** — always test against latest `main` with a fresh build.
- **READ THE DOCS** — check AGENTS.md, README.md, PATTERNS.md for current shortcuts/behavior.
- **Branding ≠ bugs** — 🐾 MacPaw logo, attribution text, company branding = INTENTIONAL.

## Screenshot Workflow
1. `screencapture -o -x <path>` → capture
2. `sips --cropToHeightWidth H W --cropOffset Y X` → crop
3. Push to `monroai/agentodo-screenshots`
4. Reference: `![desc](https://raw.githubusercontent.com/monroai/agentodo-screenshots/main/<file>.png)`

## Technical Notes
- **cliclick** uses macOS points (screen pixels ÷ 2 on Retina)
- cliclick escape: `kp:esc` (not `kp:escape`)
- osascript escape: `key code 53`
- Accessibility tree: `entire contents of front window`
- Screen: 1600×900 points (3200×1800 Retina)
- Sidebar accessibility path: `row N of outline 1 of scroll area 1 of group 1 of splitter group 1 of group 1 of window 1`
- Sidebar Row 1 = header row, Row 2 = Inbox, Row 3 = Today, etc.

## Critical Systemic Issues (Updated May 4)
1. ~~Sidebar off-by-one~~ — **RESOLVED** ✅
2. **Background-thread publishing violations** (#612) — partially addressed. BareKeyHandler race fixed. Full @MainActor audit may still be needed.
3. **Pattern #9 (SwiftData optional backing stores)** — Every model uses `_id`, `_title` etc. with `@Transient` fallbacks. Systemic, still present.
4. ~~ContentView perf~~ — **RESOLVED** ✅ (split file + targeted fetches)
5. **UI test pass rate** — unknown post-fixes (automation timeout prevented test run May 4). Many test-specific issues were closed with fixes.

## Architecture Observations
- **Pattern #9 is the project's Achilles heel.** Needs systemic fix or SwiftData version update.
- **SidebarView.swift** — extracted into sub-View structs (perf batch May 3–4)
- **ContentView.swift** — split from 2100 to 1389 lines ✅
- **Notification observers** — potential leak if observer outlives expected scope.

## Project Stats (May 6)
- **Total issues filed:** ~570+ (400 from May 1-4, 63 on May 5 afternoon, 100 on May 5-6 night)
- **May 5 afternoon sweep:** 63 issues (#1135–#1213) — menus, settings, calendar, empty states, inspector, sidebar, cross-view consistency
- **May 5-6 night sweep:** 100 issues (#1242–#1341) — P1 task selection/sidebar nav broken, sharing missing, calendar polish, inspector missing fields, keyboard nav, settings, drag-and-drop, system integration
- **Key P1 bugs found:** #1242 sidebar navigation broken (clicks go to Tags), #1243 task selection doesn't work (inspector stays No Selection), #1264 right-click context menus don't work, #1292 no Share Sheet integration
- **Open:** ~240+
- **Incorrectly filed & closed:** 9 issues (May 4 evening batch — stale build + didn't check closed issues)

## Key Shortcuts (VERIFIED)
- ⌘E — Focus command bar (AI prompt)
- ⌘K — Clean Up (removes completed tasks) — NOT command bar!
- ⌘N — New task
- ⌘, — Settings
- ⌘1–8 — Navigate perspectives
