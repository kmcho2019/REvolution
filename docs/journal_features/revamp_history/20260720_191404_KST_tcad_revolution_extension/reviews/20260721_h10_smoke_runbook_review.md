# H10 Smoke Runbook Review

Verdict: `BLOCK_FOR_RUNBOOK`

- Reviewer session: `019f84a0-18a3-74b1-a899-efd67ae2d6df`
- Scope: `smoke_execution_commands.md`, admission sequencing, exact roots and
  modes, timeout, sealing, accounting, and report placement.
- Boundary: no ledger event or H10 evidence root existed.

## Blocking Finding

The first draft said each admission/accounting command must print `PASS`, but
did not assert it. `tcad_candidate_admission.py` prints `STOP` and still exits
zero. Consequently `set -euo pipefail` could not stop classic launch after
denied classic admission, treatment launch after a failed classic record, or
reporting after a failed treatment record.

## Alignments That Passed

- Worksheet, run-config, report-manifest, seed, roots, modes, candidate/resource
  caps, and 161-second timeouts matched their frozen identities.
- Accounting used the exact admission schema and reporter-derived counts.
- Each arm sealed its exact tree; only treatment included
  `unit_failures.yaml`.
- Logs/accounting were outside arm roots and report output was outside the raw
  stage root.
- No full-suite command was present, and the current ledger allowed only
  `smoke_classic`.

## Correction

All four state transitions now capture stdout, require exact equality with
`PASS`, and print the accepted status only after the assertion. Runbook status
remained `REREVIEW_PENDING` until the closure below.

## Closure Rereview

Verdict: `PASS_FOR_RUNBOOK`

- Exact `PASS` guards now cover classic admission, classic record, treatment
  admission, and treatment record under `set -euo pipefail`.
- A zero-exit `STOP` exits at its guard before the next arm. A nonzero command
  propagates out of command substitution. Only accepted `PASS` is printed.
- Each arm is sealed and accounted before the next state transition; logs and
  accounting remain outside arm roots, and reporting uses a sibling tree.
- Bash syntax validation passed for all 11 shell fences. All four embedded
  Python heredocs compile.
- No full-suite command exists, and the explicit post-smoke prohibition remains.

The runbook may freeze before admission. This is not an admission, smoke, or
performance verdict.
