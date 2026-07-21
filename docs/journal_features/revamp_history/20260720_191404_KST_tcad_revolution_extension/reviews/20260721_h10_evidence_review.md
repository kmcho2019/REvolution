# H10 Preliminary Evidence Review

Verdict: `ACCEPT_PRELIMINARY`

- Reviewer session: `019f836d-c828-78e0-b1b5-231a10cab5f0`
- Mode: independent read-only
- Scope: two fresh H5 matched-classic full-suite controls

## Reproduced Evidence

| Status | Mismatch / total |
| --- | ---: |
| `failed_format` | 1/3 |
| `failed_syntax` | 416/926 |
| `failed_functionality` | 270/1,380 |
| `success` | 4/2,067 |

The functionality mismatches contain 55 score-0 and 215 score-10 records.
Another 424 synthesis-stage failures are undefined by the critic's 0/1-9/10
rubric and are not labeled compliant or mismatched. The strict missing-testbench
phrase audit returned zero; a prior 366 broad-regex count was false and is
withdrawn.

Selected failed-parent valid-PPA outcomes were 49/972 for score-contract
compliant parents, 16/415 for mismatches, and 8/271 for undefined synthesis
statuses. Seed and operator strata are mixed. Parent stage, problem, operator,
adaptive allocation, and repeated selection confound the join.

## Disposition

Use the 29.75% clear-failure disagreement only as outcome-independent premise
evidence. Do not gate on score, recognized mismatch, or a selected-parent
denominator. A fixed failure-only treatment and an unconditional fixed-budget
repair endpoint are defensible. The exact design-breadth endpoint and terminal
reporter remain subject to closure review.

## Exact-Card Review Round 1

Verdict: `BLOCK_FOR_READY`; the endpoint family remains accepted.

The reviewer rejected raw `+1/+1` because one problem cluster could determine
the result. The required minimum is leave-one-problem-out positivity in each
seed, which implies at least `+2` breadth per seed. The reviewer also required
an unconditional all-50 denominator, exhaustive classic/treatment missing
states, exact 200-row output, candidate and parent joins, 2,400/2,000 accounting,
problem-level W/L/T and intervals, concentration summaries, and shared-gate
translation tests.

The card incorporates these rules and discloses that candidate selection and
benchmark membership used classic-only evidence while the breadth endpoint was
informed by the already closed H5 concentration failure. The integer minimum is
derived from one-cluster deletion, not H5's treatment magnitude. Exact reporter
and worksheet artifacts remain open before `READY`.
