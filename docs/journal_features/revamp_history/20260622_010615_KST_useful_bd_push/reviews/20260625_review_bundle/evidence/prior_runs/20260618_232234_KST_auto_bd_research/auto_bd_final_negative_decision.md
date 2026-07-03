# Auto-BD Final Negative Decision

Status: no Auto-BD method is selected for the journal method under the
current evidence.

## Decision

Do not promote any tested Auto-BD method to seed-5 final evaluation or
held-out validation.

The correct result is a documented negative finding:

> Hardware-native automatic descriptors can organize RTL implementation
> archives differently, but the tested descriptor families do not meet
> the required repair/PPA robustness and uplift gates versus classic
> REvolution and the landing Smooth-QD manual-BD baseline.

## Evidence Summary

| Method | Highest tier | Gate 0 | Main failure |
| --- | --- | --- | --- |
| `random_descriptor_qd` | seed-3 control | pass | negative control, not meaningful BD |
| `simple_yosys_stat_bd` | seed-1 | pass | seed-1 robustness drop |
| `netlist_motif_occupancy` | seed-1 | pass | seed-1 robustness drop |
| `synthesis_trajectory_nod` | seed-3 | pass | seed-3 valid-PPA robustness drop |
| `synthesis_trajectory_motif_nod` | seed-1 | pass | seed-1 robustness drop |
| `sr_raw_pca_qd` | seed-1 | pass | no PPA/HV uplift |
| `sr_random_relu_pca_qd` | seed-3 | pass | weak HV gain, robustness/diversity miss |
| `sr_rff_pca_qd` | seed-1 | pass | no PPA quality gain |
| `sr_vq_codebook_qd` | seed-1 | pass | large robustness drop |

Seed-3 screening showed no clean final Auto-BD candidate:

- `synthesis_trajectory_nod` had the strongest common-audit QD score but
  averaged 40.51 percent valid PPA versus 47.12 percent for classic
  REvolution and 51.09 percent for landing manual-BD.
- `sr_random_relu_pca_qd` passed Gate 0 but averaged 40.73 percent valid
  PPA, mean HV improved only about 1.6 percent versus classic, and
  PPA-front unique netlists improved only about 7.4 percent, below the
  20 percent target.
- Landing Smooth-QD manual-BD remains stronger than the tested Auto-BD
  arms on valid-PPA rate and mean hypervolume in seed-3 screening.

The final VQ/codebook check did not recover the situation:

- Gate 0 passed on all 6 development problems.
- Valid PPA was 174/288 versus 209/288 for classic REvolution.
- Functionality, synthesis, OpenROAD, and valid-PPA rates dropped by
  15.62 percentage points versus classic.
- Mean best fitness, mean hypervolume, unique canonical netlists, motif
  signatures, common-audit occupied cells, and common-audit QD score all
  regressed versus classic.

## AURORA Scope Decision

Do not implement an AURORA-style encoder in this goal.

Rationale:

- The plan says to try neural encoders only after fixed vectors are
  stable. The fixed-vector substrate is mechanically stable, but the
  in-loop search results show repeated robustness regressions.
- A neural encoder over the same motif/trajectory substrate would add
  fitting, leakage, artifact, and backend complexity without an evidence
  backed mechanism for fixing the dominant failure: lower
  functionality/synthesis/OpenROAD/valid-PPA rates.
- The current journal threshold requires a method that preserves repair
  and PPA coverage first. More descriptor capacity is not enough when
  the archive pressure already appears to trade away robustness.

Future AURORA work should be a separate goal with a sharper hypothesis,
for example decoupling descriptor learning from parent selection or
using learned descriptors only for post-hoc archive analysis until a
repair-preserving insertion policy is demonstrated.

## Final Evaluation Scope

Because no Auto-BD method is selected:

- do not run seed-5 final evaluation;
- do not run held-out validation;
- do not run finalist-only stronger functional correctness audits;
- do not re-run PPA extraction for finalist elites;
- do not draft a positive final-method journal section.

These are not skipped success criteria. They are scoped out because the
selection gate failed before the final-evaluation stage.

## Paper-Facing Use

Use the evidence as a negative/ablation result:

- Manual BDs remain weakly justified, but replacing them with automatic
  descriptors is not automatically beneficial.
- ST-NOD is the most interesting hardware-native descriptor because it
  captures synthesis response and improves common-audit QD organization,
  but it does not preserve valid-PPA robustness enough to be the final
  method.
- Projected/kernel/codebook descriptors are useful controls showing that
  more descriptor capacity does not by itself solve RTL PPA evolution.

## Pointers

- Seed-1 central report: `auto_bd_seed1_centralized_report.md`
- Seed-3 screening report: `auto_bd_seed3_screening_report.md`
- VQ decision:
  `auto_bd_methods/07_vq_implementation_codebook/accept_reject.md`
- Promotion decisions: `auto_bd_seed1_promotion_decisions.md`
- Chronological evidence: `auto_bd_research_implementation_history.md`
