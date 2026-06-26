# T18 Adaptive Emitter CVT BD Methodology

## Intent

Test whether archive-geometry adaptation plus role-separated emitters is a
better QD coupling strategy than another descriptor-only archive. The intended
T18 method was:

- a CVT or grid-quantile archive over a frozen descriptor;
- exploit emitters for high-quality occupied cells;
- explore emitters for under-covered archive regions;
- repair or front-preserving emitters for candidates that are valid but not
  retained by scalar hill climbing.

T18 is now evaluated as a retrospective synthesis, not a fresh live run. The
two measured packages below cover the main ingredients:

| Ingredient | Evidence package | What it tests |
| --- | --- | --- |
| Archive geometry adaptation | `T57_t51_adaptive_rebin_qd` | Adaptive grid-quantile rebinning while keeping the T51 descriptor and parent policy fixed. |
| Front-preserving emitter schedule | `T32_sr_raw_front_preserving_emitter_qd` | Lower champion pressure and small near-front/two-parent emitter exposure on the T26/T31 holdout line. |

## Inputs

- Candidate RTL and fixed benchmark metadata.
- A frozen descriptor or archive geometry, as used by the source packages.
- Candidate status history available at decision time.
- No final PPA, reference PPA, hypervolume, Pareto rank, or problem identity as
  descriptor inputs.

Emitter scheduling may use archive status and validity funnel history available
during search, but that usage must be logged and reported separately from the
descriptor.

## Retrospective Method

The retrospective asks three questions:

1. Did adaptive archive geometry actuate and improve headline PPA-front
   metrics?
2. Did a front-preserving emitter schedule retain useful PPA-front material
   without losing the best holdout quality signal?
3. Is a fresh adaptive-emitter/CVT live run materially different from T57/T32,
   or would it be another small archive/schedule tweak?

The answer is based on the measured tables and figures copied into this
package:

- `tables/t18_evidence_matrix.csv`
- `tables/t18_gate_decision.csv`
- `tables/t18_t57_rebinning_counters.csv`
- `figures/t18_t57_rebinning_counters.png`
- `figures/t18_t32_holdout_live_aggregate.png`

## Decision Rule

Do not run an exact T18 continuation unless both conditions hold:

- archive adaptation or emitter scheduling is materially different from T57/T32;
- the new mechanism has a pre-registered way to count per-emitter valid-PPA,
  local-front additions, global-front additions, and final-front contribution.

The current exact T18 line fails this rule.

## Future Variant Boundary

A future emitter lane should not be a generic CVT boundary or schedule nudge.
It should be source-level and mechanism-explicit: for example, direct-code
repair or front-rescue prompts that report whether rescued parents create
quality-productive front material per LLM call.
