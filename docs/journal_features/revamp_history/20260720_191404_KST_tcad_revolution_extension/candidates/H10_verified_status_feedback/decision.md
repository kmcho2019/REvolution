# H10 Candidate Decision

Current state: `SUITE_EVALUATED`.

## Outcome

`RETIRED`

Allowed outcomes: `PAPER_CANDIDATE`, `VIABLE`, `RETIRED`, `BLOCKED`.

## Frozen Hypothesis And Gates

`hypothesis_card.md` froze one additive terminal-status line for failed
candidates while preserving the critic, EoH operators, parent selection,
routing, UCB, evaluator, and candidate budget. The benefit endpoint was
distinct-design fail-origin valid-PPA repair breadth. It had to improve under
leave-one-problem-out deletion in each development seed. Final HV, HV-AUC, and
three coverage surfaces also had frozen noninferiority gates.

## Execution And Integrity

- The seed-42 smoke passed all eight technical gates before the full suite.
- Four fresh arms ran once in the frozen order over RTLLM-50 at seeds 1001 and
  1002. All 200 problem-arm units completed with 2,400 candidates per arm.
- The raw audit rehashed 96,651 sealed files and reproduced all headline
  metrics. The seven canonical report files also reproduced byte-for-byte.
- Across treatment units, all 4,800 activation records validated. Exactly
  2,744 failures received the fixed prefix, and all 1,571 failed-parent prompt
  uses matched their source feedback and lineage.
- Classic retained no H10 telemetry or prefix. The frozen classic engine and
  default configuration remained byte-identical.

## Full-Suite Results

| Metric | H10 minus classic | 95% problem-cluster CI | W/L/T |
| --- | ---: | --- | ---: |
| Repair breadth | 0.000000 | [-0.070000, +0.070000] | 7/7/86 |
| Final HV46 | -0.017569 | [-0.039532, -0.002707] | 13/24/28 |
| HV-AUC46 | -0.008203 | [-0.024888, +0.004789] | 13/28/24 |

At seed 1001, repair breadth changed from 16 to 15 and its minimum
leave-one-problem-out delta was -2. At seed 1002, breadth changed from 14 to 15
and its minimum deletion delta was 0. Both strict-positive breadth gates fail.

Coverage tied exactly in each seed and arm:

| Surface | Seed 1001 | Seed 1002 |
| --- | ---: | ---: |
| Verification-complete valid PPA, 46 tasks | 33 | 32 |
| RTL-simulation functionality, 46 tasks | 38 | 37 |
| RTL-simulation functionality, 50 tasks | 42 | 41 |

## Governing Gate Failures

H10 fails four frozen gates:

- repair-breadth leave-one-problem-out improvement in each seed;
- final-HV catastrophic ratio, observed at 0.887521 against a 0.90 floor;
- final-HV noninferiority, with its clustered interval wholly below zero;
- HV-AUC noninferiority.

Coverage, evidence, mechanism, candidate-budget, resource, and process gates
all pass. Passing those integrity gates cannot rescue failed efficacy gates.

## Resources

Smoke and full-suite discovery consumed 9,696 candidates, 19,393 model calls,
59,140,232 tokens, 5,134 synthesis starts, and 18,409.585 endpoint-arm seconds.
Every arm and per-problem cap passed. Resource skew was at most 0.0211 on any
registered arm-pair surface.

## Scientific Interpretation

The matched experiment rejects the frozen claim that exposing one authoritative
terminal-status line broadens distinct-design repair while preserving PPA
search at this model, budget, suite, and two development seeds. It does not
erase the classic-only observation that 687/2,309 clear-failure critic records
disagree with terminal status, and it does not reject verifier-grounded
feedback in other architectures.

Exact coverage parity is compatible with lower HV and AUC. Coverage is a binary
reachability surface and tied on every seed. HV and AUC measure the quality and
timing of the valid-PPA fronts within those reached problems. H10 produced
broad continuous-surface losses despite reaching the same number of designs.
The run does not identify a lower-level language-model cause for that shift.

## Follow-Up Boundary

Close the H10 family in this program. Wording, placement, prefix, payload, or
trigger variants would be parameter scans or more invasive feedback policies
without a new measured premise. Do not launch confirmation, holdout, or an H10
revision. A future feedback mechanism would require a distinct audited
weakness, architecture, related-work delta, and prospective premise.

## Allowed Claim

Allowed: under the frozen two-seed RTLLM development protocol, one additive
verified terminal-status line activated exactly but did not change mean repair
breadth or functionality coverage, and it failed final-HV and HV-AUC
noninferiority. The result retires this fixed mechanism at the tested scope.

Not allowed: H10 improves reliability, repair breadth, functionality, PPA,
feedback grounding in general, or the journal method. Two development seeds do
not establish universal harm or model-independent behavior.

## Evidence

- `full_suite_execution_commands.md`
- `implementation_history.md`
- `../../reviews/20260721_h10_full_suite_evidence_audit.md`
- `../../reviews/20260721_h10_scientific_interpretation.md`
- `../../../../../../../exp/tcad_revolution_extension/h10_verified_status_feedback/wave2/reports/full_suite/summary.json`
