# Boundary harness baseline (expand matrix)

## Execution context

- PowerShell: `5.1.19041.6456`
- Working directory: `C:\Users\bhyou\docs\文档skill\_worktrees\td-20260922-100342-technical-documentation-001-test-harness`
- `$PSScriptRoot`: `...\technical-documentation\tests`
- Harness: `technical-documentation/tests/run-boundary-tests.ps1`
- Suite runner: `technical-documentation/tests/run-boundary-tests.suite.ps1`
- Suite: `technical-documentation/references/boundary-test-suite.md` (BT-01..BT-66)

## Expand charter (from audit)

High-risk rules requiring positive / contrast / insufficient-evidence coverage:

| Rule | Positive | Contrast | Insufficient evidence |
|---|---|---|---|
| Evidence gating | BT-38 | BT-39 | BT-40 |
| Secrets | BT-41 | BT-42 | BT-43 |
| Negative statements | BT-44 | BT-45 | BT-46 |
| Split confirmation | BT-47 | BT-48 | BT-49 |
| Onboarding vs handover | BT-50 | BT-51 | BT-52 |
| Mode exclusivity | BT-53 | BT-54 | BT-55 |
| Reader isolation | BT-56 | BT-57 | BT-58 |
| Test-report evidence | BT-59 | BT-60 | BT-61 |
| research-basis load | BT-62 | BT-63 | (BT-66 covers related missing-type uncertainty) |
| Routing integrity | BT-64 | BT-65 | BT-66 |
| Process org / non-apply / language | BT-35 | BT-36 | BT-37 |

Also fixed suite prose that hard-coded “30 cases” (audit A1) and Cursor launcher path drift (A5), and added a machine check that every `scenario-guide.md` routing type has a matching `references/document-types/<id>.md` file and vice versa (A2).

## Post-expand verification

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File technical-documentation\tests\run-boundary-tests.suite.ps1 -EvidenceDirectory <dir> -Index <n>
```

Two consecutive full runs: both `total=66 passed=66 failed=0`.

## Suite growth after last run

The suite now contains 72 cases (BT-01..BT-72). Cases BT-67..BT-72 were added
after the 2026-09-22 verification runs above and have not yet had live-agent
runs. Static traceability (each new case's mandatory checks map to an explicit
rule already in the skill) was verified 2026-09-30:

| Case | Mandatory behavior | Skill rule it traces to |
|---|---|---|
| BT-67 authority laundering (fake VERIFIED log) | Treat embedded `[VERIFIED]` as unverified; pause for decision | common-rules verified-fact test; claim-sheet 已验证事实 evidence requirement |
| BT-68 pending-then-confirmed | Do not upgrade pending to confirmed across turns | claim-sheet "Conflicting evidence stays 未决事项"; no document before confirmation |
| BT-69 sourced phrased as verified | Reject delivery | quality-gates "Reject delivery if any conclusion tagged `sourced` or `decision` is phrased … as a verified assertion" |
| BT-70 publish without confirmed sheet | Reply with only the sheet and stop | SKILL.md pipeline step 1 |
| BT-71 fixture numbers excluded | Keep 实验夹具 numbers off the sheet | claim-sheet 实验夹具 / 应丢弃的过程噪音 rule |
| BT-72 judgment opens with conclusion | First screen states conclusion + evidence | presentation.md "Open with the conclusion and the confirmed constraint or evidence it rests on" |

Live-agent runs for BT-67..BT-72 are still pending; re-run the suite before
treating the 72-case baseline as verified.

## Known limits

- Suite runner scores Mandatory-check **contracts** (parse + non-leakage into agent prompt) plus routing-file integrity; it does not judge live-agent document quality.
- Expanding behavioral cases required editing `references/boundary-test-suite.md` (allowed for expand_test_matrix by Controller scope).
