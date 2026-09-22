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

## Known limits

- Suite runner scores Mandatory-check **contracts** (parse + non-leakage into agent prompt) plus routing-file integrity; it does not judge live-agent document quality.
- Expanding behavioral cases required editing `references/boundary-test-suite.md` (allowed for expand_test_matrix by Controller scope).
