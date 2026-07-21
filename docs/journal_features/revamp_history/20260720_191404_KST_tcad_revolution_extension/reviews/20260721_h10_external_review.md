# H10 External Exact-Card Review

Verdict: `WARN`

- Reviewer: Claude Code, read-only `claude -p`
- Timeout: 600 seconds; completed normally
- Scope: H10 card, related work, premise, preliminary reviews, claims contract,
  Wave-2 addendum, and exact classic code paths

## Verified Strengths

- Terminal status genuinely disappears from ordinary parent memory while
  remaining authoritative for pool construction.
- The one-line mechanism is a natural one-factor reliability correction with
  no knob or fallback; 13/14 and novelty 1/2 are appropriate.
- The 4,800-row premise, 687/2,309 clear-failure mismatch, 215 functional
  score-10 count, and selected-parent joins reproduce.
- Classic hashes, matched controls, seeds, noninferiority surfaces, and resource
  envelopes align with the frozen contracts.
- A post-super transform can preserve critic calls/artifacts and emit exact
  hash/byte telemetry without changing the classic engine.

## Findings And Dispositions

| Finding | Disposition |
| --- | --- |
| Six-arm worksheet, terminal reporter, and gate-translation tests do not yet exist. | `ACCEPT`: H10 remains `PROPOSED`; these are mandatory before `READY`. |
| Reviewer inferred H10 cannot compose with legacy sibling `CVDPEngine`. | `REJECT`: active `run_backend.py` uses `CVDPEvaluator` as a service under the backend-selected H10 engine. The card now freezes and requires a test of that path. |
| `summary.json` reports 216 false score-10 failures while prose reports 215. | `ACCEPT`: 216 is all non-success statuses; 215 are functional failures and one is format. The generated premise README now states the scope. |
| Source ranges ended a few lines early. | `ACCEPT`: frozen card cites the complete status and feedback regions. |
| Raw `+1/+1` could satisfy the reviewed draft. | `SUPERSEDED`: later evidence review strengthened the gate to leave-one-problem-out positivity, at least `+2` per seed. |

## Closure Boundary

The external review conditionally accepts implementation planning but does not
authorize `READY` or live spend. Closure requires the immutable worksheet,
candidate-local reporter, distinguishing shared-gate tests, corrected premise
regeneration, and exact-card rereview.
