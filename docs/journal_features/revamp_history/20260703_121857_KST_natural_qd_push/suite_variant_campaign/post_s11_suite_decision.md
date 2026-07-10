# Post-S11 Suite Decision

Date: 2026-07-10.

Scope: decide whether the suite-first reopen should launch another
full-RTLLM primary variant after S07, S23, and S11.

## Decision

Do not launch another primary full-suite variant from the current
registry. Pivot the suite-first reopen into the negative-map addendum.

S04 `compact8d_cvt_complete`, S05 `trio_cvt_complete`, and S06
`gt3d_complete` remain valid appendix-only options:

- S04 is a descriptor-health completion candidate, not a primary HV
  candidate. The existing two-seed read is `0.097600` HV, 93.4% of
  matched classic, and the arm is qualified by the documented
  `Prob050_square_wave` extraction failure at seed 1002.
- S05 is the paired CVT geometry control for S04. It is useful only if
  S04 is exercised for a descriptor-health appendix. A five-seed S04
  claim would also need S05 seeds 1003-1005, so the real cost is a paired
  six-run completion, not three isolated compact8d seeds.
- S06 is a coverage/semantics appendix option. Existing evidence gives
  the best coverage read but weak HV, so it does not address the primary
  PPA-HV gap.

Any further primary run needs a new mechanism card before launch. The
card must explain which existing failure class it should defeat and must
stay within the natural-extension criterion: one mechanism, at most two
knobs, no trigger/credit/stagnation logic, no operator changes, and the
standard EoH/code-individual/strict-ablation pins.

## Evidence

| Arm | Result | Cause class | Decision |
| --- | --- | --- | --- |
| S07 `capacity3` | Five-seed S07 `0.102481` HV / `0.088031` HV-AUC46 / `165/230` coverage vs classic `0.103802` / `0.086982` / `164/230`. | near-miss / final-HV gap | Secondary trajectory and coverage evidence, not a primary PPA-HV win. |
| S23 `journal_logic_width_2d` | Seed 1001 S23 `0.084403` HV / `0.076832` HV-AUC46 / `31/46` coverage vs classic `0.111401` / `0.090551` / `33/46`. | descriptor-collapse avoided but PPA-yield/front loss | Closed negative; blocks S31. |
| S11 `warmup12` | Seed 1001 S11 `0.095807` HV / `0.085702` HV-AUC46 / `33/46` coverage vs classic `0.111401` / `0.090551` / `33/46`. | mechanism-inert / final-HV loss | Closed negative; blocks S12. |
| S04/S05 CVT pair | Existing two-seed P3c compact8d/trio CVT results are 93.4%/93.3% of classic HV. | descriptor-health trade | Appendix-only unless the manuscript pays for a descriptor-health contract treatment. |
| S06 gt3d | Existing two-seed read has best coverage but 87.5% of classic HV. | coverage/HV trade | Coverage appendix only. |

## Audit Notes

A read-only sub-agent audit and a Claude CLI read-only audit on
2026-07-10 recommended the same posture: negative-map synthesis is the
best-aligned next action, while S04/S05/S06 are appendix-specific controls
rather than primary HV lanes. The Claude report is recorded at
`../reviews/claude_suite_campaign_post_s11_20260710.md`.

The current evidence does not exhaust the broader research space forever;
it exhausts the registered config-first suite-first queue as a primary
TCAD HV search. Continuing experimentation is still allowed, but only
after a qualitatively new mechanism card is recorded before launch.

## Next Action

Update the suite-first negative map and manuscript-facing synthesis with
S07/S23/S11:

- S07: compact per-cell Pareto retention is a strong near miss that
  improves HV-AUC and coverage but misses final HV.
- S23: descriptor collapse reduction alone is not enough; dropping the
  `ff_depth` axis is PPA-catastrophic.
- S11: more quantile warmup does not recover classic HV.

Do not launch long-running full-RTLLM work from this decision point.
