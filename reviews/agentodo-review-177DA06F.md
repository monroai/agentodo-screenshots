## AgenToDo macOS — UI/UX Review

### Per-Image Findings

**Image 1 — `agentodo_main.jpg` (Accessibility dialog over onboarding modal)**
- **Dual-modal collision.** The macOS "Accessibility Access" system dialog sits directly on top of the onboarding carousel modal. Two competing modal layers = user is paralyzed. The app triggered both contexts simultaneously with no orchestration.
- **Onboarding content is empty.** The visible carousel step shows only a pink sparkle animation — zero explanatory text, no heading, no description. The user is asked to hit "Next" with no idea what they're agreeing to or learning.
- **"Unable to open file" error banner** (top-right notification area). Something broke silently during this flow. No in-app handling or user-facing explanation.

**Image 2 — `agentodo_front.jpg` (Onboarding modal, dialog dismissed)**
- **Still no content in the carousel step.** Just the sparkle animation. Skip and Next are the only affordances — meaningless without context.
- **Pagination dots** use a red/pink pill for the active indicator and gray circles for inactive. The pill shape is non-standard for macOS and the color contrast between active (red) and the dark modal background is decent, but the dots are tiny and easy to miss.
- **"System Settings" tooltip** floating at the bottom of the screen, disconnected from anything clickable in the AgenToDo window. Looks like a leftover from the Accessibility dialog interaction — confusing artifact.
- **"Legacy Model" label** in the bottom-right input bar. This reads like a debug/internal label, not user-facing copy. Shipping "Legacy" in the UI signals something broken or deprecated — not the impression you want.

**Image 3 — `agentodo_after.jpg` (System Settings open alongside app)**
- **Three layers of UI competing:** System Settings (left), AgenToDo main window (middle), onboarding modal (center), and the notification banner (top-right). Total attention fragmentation.
- **Onboarding modal doesn't dismiss or pause** when the user navigates to System Settings. It just sits there, partially obscured. The flow should either auto-dismiss or at minimum wait/resume gracefully.
- **Left sidebar truncation.** Under "Recents": "Install and secure OpenClaw with Br…", "Enable FileVault…" — aggressive ellipsis. Sidebar width seems fixed with no resize affordance visible.

**Image 4 — `agentodo_hq.jpg` (Higher-res, same state as Image 2)**
- Confirms all Image 2 issues at higher fidelity.
- **Quick-action pills** ("Capture thoughts", "What now?", "Triage inbox", "Plan my day", "Focus now") below the input field are **clipped on the right edge** — "Focus now" is barely visible, suggesting horizontal overflow isn't handled. No scroll indicator.
- **"Triage" button** (top-right of the inbox panel) sits alone with no visual grouping — it looks orphaned.
- **Task priority badges** ("Personal" in red) are consistent but the badge text is small and could be mistaken for an error state given the red color.
- **"+ Ask Agent" button** in the empty detail panel — the plus icon combined with "Ask Agent" is ambiguous. Is it creating something or starting a conversation?
- **Dot navigation** — at this resolution, confirmed: 5 dots, second one active (red pill). But the modal is showing what appears to be step 2 with zero content. If step 1 also had no content, that's two empty steps.

**Image 5 — `agentodo_sm.jpg` (iTerm2 — blank beige screen)**
- **This is not AgenToDo.** It's iTerm2 with an empty beige terminal. Either a wrong screenshot or it's showing AgenToDo failed to launch/render entirely. If intentional, it points to a launch failure with zero feedback.

---

### Prioritized Punch List

| # | Severity | Issue | Location |
|---|----------|-------|----------|
| 1 | 🔴 Critical | **Onboarding carousel steps have no content** — just a sparkle animation, no text, no heading. User learns nothing. | Onboarding modal, center of screen |
| 2 | 🔴 Critical | **Dual-modal collision** — Accessibility Access dialog and onboarding modal fight for attention simultaneously. Need to sequence these: finish onboarding → then request permissions, or vice versa. | Modal layer stack |
| 3 | 🟠 High | **Onboarding triggers for an existing user with data** — inbox has 15 items, projects exist, tags populated. Either wrong trigger condition or re-trigger on update. | Onboarding flow logic |
| 4 | 🟠 High | **"Legacy Model" label in input bar** — reads as debug/internal text. Replace with the actual model name or remove entirely. | Bottom-right of message input bar |
| 5 | 🟠 High | **Quick-action pills overflow/clip** on the right edge — "Focus now" is barely visible, no scroll affordance. | Below input field, Inbox panel |
| 6 | 🟡 Medium | **Onboarding doesn't pause/dismiss when user leaves app** (e.g., to System Settings). Modal persists awkwardly behind other windows. | Onboarding modal lifecycle |
| 7 | 🟡 Medium | **"Unable to open file" system notification** fires during onboarding with no in-app handling or explanation. | macOS notification banner, top-right |
| 8 | 🟡 Medium | **"System Settings" orphan tooltip** at bottom of screen after dismissing Accessibility dialog. | Bottom of screen, below AgenToDo |
| 9 | 🟡 Medium | **Sidebar truncation** — Recent items aggressively ellipsized with no hover tooltip or resize handle visible. | Left sidebar, "Recents" section |
| 10 | 🟢 Low | **Pagination dot styling** — red pill + gray circles is non-standard macOS. Consider standard dot indicators. | Onboarding modal, bottom-center |
| 11 | 🟢 Low | **"+ Ask Agent" button copy** is ambiguous (create vs. converse?). | Right detail panel, empty state |
| 12 | 🟢 Low | **"Triage" button** looks visually orphaned — no grouping with nearby controls. | Top-right of inbox panel |

---

**Bottom line:** The onboarding flow is the biggest problem. Empty carousel steps, permission dialogs crashing the party mid-flow, and triggering for users who clearly aren't new — this is the first impression, and right now it's saying "we didn't finish this." Fix the onboarding sequencing and content before anything else ships.