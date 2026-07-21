# Wave 2 Admission And Gate Code Audit

- Date: 2026-07-21
- Mode: read-only independent code subagent
- Session: `019f830b-339c-7743-bfab-0b4cc9da2054`
- Final verdict: `PASS`

The reviewer edited no file. It reviewed the executable admission, accounting,
coverage-gate, and focused test surfaces over four fail-fix cycles.

## Rejections And Dispositions

| Finding | Disposition |
| --- | --- |
| Accounting was caller supplied and replayable rather than arm/evidence bound. | `ACCEPT`: bind candidate, worksheet hash, exact pending arm, capture time, accounting hash, and raw-evidence path/hash; reject reused accounting or evidence hashes. |
| Resource state was candidate-local and did not charge other Wave-2 candidates. | `ACCEPT`: use one append-only program ledger for candidate, wave, and post-H5 program projections. |
| Coverage margin and time were caller controlled; wall time lost precision. | `ACCEPT`: hard-code both development seeds and the one-design margin, use the process UTC clock, and retain exact decimal wall seconds. |
| Another candidate could start while the current candidate was pending or between arms. | `ACCEPT`: enforce contiguous candidate blocks and terminal transition rules in both admission and ledger replay. |
| Malformed YAML, decimals, timestamps, or paths could raise instead of returning `STOP`. | `ACCEPT`: strictly validate the accounting boundary; invalid input appends nothing and leaves the arm pending. |
| Timeout expiry had no representable accounting state. | `ACCEPT`: require `completed | timed_out`; charge timed-out spend and retire the candidate even when numeric totals fit. |
| Two concurrent commands could both validate before either append. | `ACCEPT`: hold `fcntl.LOCK_EX` across ledger read, all checks, and append; add a real four-process regression test. |

The reviewer also noted opaque tuple state and a mutable seed set. These were
cleaned with a frozen `LedgerPosition` record and immutable development-seed
set; neither became a separate public abstraction or knob.

## Final Verification

- Exact six-arm order, pair equality, frozen thresholds, program window, and
  current worksheet hash are executable invariants.
- Candidate, wave, and program spend include stopped arms and every prior
  Wave-2 candidate.
- Invalid accounting cannot erase spend, fabricate zero use, or advance the
  state machine.
- A timed-out arm is terminal and remains reloadable with its exact spend.
- Four concurrent candidate admissions produce exactly one `PASS`, three
  `STOP` results, and one admitted ledger event.
- Focused validation: 37 tests passed; Ruff, Pyright, and `ty` passed.

No code launch blocker remains. This pass does not admit any candidate; each
candidate still needs its own frozen worksheet, reporter integration test, and
prelaunch reviews.
