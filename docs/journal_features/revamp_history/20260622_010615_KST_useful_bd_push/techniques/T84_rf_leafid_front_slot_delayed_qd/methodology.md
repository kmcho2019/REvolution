# T84 Methodology

## Question

Can RF timing model-state descriptors help QD recover PPA-front breadth when
they are coupled to explicit local front-slot parent sampling?

## Rationale

T83 proved that RF leaf-ID model-state breadth can run in a live QD archive and
nearly match classic mean HV on one seed. It still failed promotion because it
lost Pareto points, reference-beating candidates, and RTLLM-only mean HV.

T84 changes the coupling, not the descriptor axes. It uses
`front_slot_lane_nsga2` so some post-activation parents come from non-elite
local front-slot archive members. This directly targets T83's front-breadth
failure.

## Descriptor Axes

The archive uses explicit axes:

1. `source_aligned_rf_timing_leaf_ids`
2. `source_aligned_masterrtl_branching`
3. `source_aligned_rtltimer_wire_density`

All three axes are PPA-free. They do not use final PPA, reference PPA, fitness,
hypervolume, Pareto rank, or test pass rate as behavior descriptor inputs.

## Search Surface

T84 keeps the T83 delayed archive activation surface and changes parent
selection:

| Setting | Value |
| --- | --- |
| Archive type | `grid_quantile` |
| Warmup successes | `4` |
| Cell mode | `elite_pareto_slot` |
| Max elites per cell | `2` |
| Fill target fraction | `0.10` |
| Improve backfill fraction | `0.05` |
| Archive activation generation | `3` |
| Parent selection after activation | `front_slot_lane_nsga2` |
| Front-slot lane fraction | `0.20` |
| Champion lane after activation | `0.80` |
| Two-parent probability | `0.0` |
| Operator | `single_thought_operator`, one-parent only |

## Promotion Gate

Promote only if the arm:

- preserves every classic-covered design in the frozen eight-design screen;
- avoids a large valid-PPA collapse;
- improves T83's mean Pareto points or mean reference-beating candidates;
- keeps mean HV close to classic or improves T83 mean HV;
- improves the no-`Prob135_m2014_q6b` robustness read relative to T83;
- does not hide descriptor collapse or duplicate/invalid candidates as useful
  diversity.

If it loses T83's HV signal without front-material recovery, retire this exact
front-slot coupling.
