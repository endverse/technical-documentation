# Rules architecture changes — technical-documentation

- runId: 20260922-111606-technical-documentation-001
- role: td_architect
- baseline: worktree matched main HEAD (LF/CRLF only) before edits
- scope: `references/` only (no `SKILL.md`, `tests/`, `automation/`, or other worktree touched)

## Change map (each change → finding / test)

### C1 — Authoritative case count + source of truth
- **File:** `references/boundary-test-suite.md` (Local runner section)
- **What:** Replaced "Run all 30 baseline cases" with a runner-is-authoritative note; the runner discovers every `### BT-NN` block at run time, current range BT-01..BT-37. Removed the hard-coded "30".
- **Why:** Fixes A1 (P1) — prose "30" undercounted the 34 defined cases, letting an operator silently skip BT-31..BT-34. Also fixes A3 (P2) — no doc stated the authoritative count or that the runner is source of truth.
- **Verified against:** runner parses `^### (BT-\d+)` (`tests/run-boundary-tests.ps1:46`) and selects all matched blocks, confirming discovery is dynamic.

### C2 — Cursor path doc/runner reconciliation
- **File:** `references/boundary-test-suite.md` (Cursor paragraph)
- **What:** Changed cited Cursor path from `agent.cmd` to the runner default `%LOCALAPPDATA%\cursor-agent\cursor-agent.ps1`, noted the `.cmd` wrapper corrupts multi-line prompts, and mentioned `-CursorAgentPath` override.
- **Why:** Fixes A5 (P2) — doc/runner drift. Runner default is `cursor-agent\cursor-agent.ps1` (`tests/run-boundary-tests.ps1:19`) with the `.cmd`-corruption comment (`:17-18`).

### C3 — Install-path vs working-tree note
- **File:** `references/boundary-test-suite.md` (after the CaseId example)
- **What:** Added a note that the `.claude\skills` / `.cursor\skills` paths assume an installed copy, and that running against the working tree uses the in-tree runner path, which resolves the suite relative to its own folder.
- **Why:** Fixes A4 (P2) — copy-paste commands assumed an installed copy that may not match the audited tree; no reconciliation existed. Runner resolves suite via `Split-Path -Parent $PSScriptRoot` (`tests/run-boundary-tests.ps1:31-32`), so no install is required.

### C4 — New coverage cases BT-35..BT-37
- **File:** `references/boundary-test-suite.md` (Cases section, before Recording template)
- **What:** Added three baseline cases:
  - **BT-35** process-organization mode (classify without producing a document).
  - **BT-36** skill non-invocation on an unrelated coding request.
  - **BT-37** default output language is Chinese.
- **Why:** Fixes A6 (P2) — process-organization mode (`SKILL.md:12`) was untested. Also closes Section-4 coverage gaps: skill-non-invocation (`SKILL.md:8`) and language default (`common-rules.md:12`).
- **Regression guard:** cases are additive; existing BT-01..BT-34 wording untouched, preserving the contrast pairs listed in audit Section 5.

### C5 — Routing integrity invariant
- **File:** `references/scenario-guide.md` (new section after the routing table)
- **What:** Documented the 1:1 invariant between the 11 routing rows and the 11 files in `references/document-types/`, with the maintenance rule to update row + file together.
- **Why:** Addresses A2 (P1) at the rule layer. A machine check belongs in `tests/` (out of this worker's scope); the invariant is stated so it is enforceable and a renamed/removed type is a defined defect. Verified all 11 files present via glob.

### C6 — Research-basis version/owner/verification line
- **File:** `references/research-basis.md`
- **What:** Added a line noting sources are rationale-only, to consult the current published edition, with owner and last-reviewed date (2026-09-22).
- **Why:** Fixes A7 (P2) — cited standards lacked version/date/owner per `common-rules.md:15`. Low risk, rationale-only doc; no normative wording added.

## Not changed (deliberate)
- A2 machine check itself: requires editing `tests/`, outside td_architect scope. Left as a documented invariant + Controller follow-up.
- Duplicate reader-isolation wording (audit Section 3): layered by design, no conflict; no change to avoid drift risk.
- `SKILL.md`: no finding required an entry-file change; case count lives in the suite, not SKILL.md.
