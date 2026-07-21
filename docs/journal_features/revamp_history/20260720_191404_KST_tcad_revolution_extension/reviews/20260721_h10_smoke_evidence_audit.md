# H10 Smoke Raw-Evidence Audit

Date: 2026-07-21

Auditor: independent read-only session
`019f84d7-6a53-7f53-959b-28d647050fe1`.

Verdict: `PASS_FOR_SMOKE_VALIDATION`.

## Findings

No blocking or integrity finding was identified.

- All 529 classic and 600 treatment manifest entries reproduce current file
  bytes. Accounting and ledger hashes match both evidence manifests.
- Each arm contains all three frozen problems and exactly 48 candidates. The
  independently reconstructed calls, tokens, synthesis starts, and wall time
  match canonical accounting and remain within the frozen caps.
- Ledger order is exactly classic admit/completed then treatment
  admit/completed. Worksheet and implementation identities remain constant.
- Classic contains no H10 telemetry or terminal-status prefix. Treatment has
  48 activation rows: all 14 failures received the exact prefix and all 34
  successes retained unchanged feedback. Eight use rows exactly reproduce the
  eight failed-parent serializations.
- `unit_failures.yaml` is empty and sealed into the treatment manifest.
- All six arm/problem rows, paired repair rows, leave-one-out values,
  concentration rows, resource totals, config hashes, and eight smoke gates
  reproduce from raw candidate and generation artifacts.
- No covered raw file is newer than its arm seal. All 45 implementation-bound
  files match current `HEAD` and runtime commit
  `ed5863c5fa578a0a5a2ffb73d1aebef44e67f8e8`. The classic engine retains its
  frozen SHA-256.

## Resources

| Arm | Candidates | Calls | Tokens | Synthesis | Wall seconds |
| --- | ---: | ---: | ---: | ---: | ---: |
| Classic | 48 | 96 | 235,981 | 29 | 145.752 |
| Treatment | 48 | 96 | 238,752 | 35 | 144.513 |

## Scope

This one-seed, three-problem, one-generation run validates execution,
activation, isolation, accounting, and evidence integrity. It does not test
efficacy or generalization. Treatment reached the synthesis cap exactly, which
is a valid smoke pass and a disclosed suite-execution risk.
