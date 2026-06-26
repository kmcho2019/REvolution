# T83 Methodology

## Question

Can MasterRTL RF timing model-state information help QD when it is used as a
secondary model-state coordinate beside less-collapsed source-aligned
structural axes and the best recent delayed archive schedule?

## Rationale

T82 proved the RF timing runtime path is real, but exact
`source_aligned_rf_timing_state_3d` failed the frozen `8x5` screen. Its
`source_aligned_rf_timing_path_count` axis collapsed on most problems, and
some problems also collapsed `source_aligned_rf_timing_leaf_rows`.

T83 changes two things:

- replace the collapsed RF path-count axis with
  `source_aligned_rf_timing_leaf_ids`, a log-scaled model-state breadth signal
  with non-collapse evidence in T81 and T82;
- combine the RF model-state axis with source-aligned MasterRTL/RTLTimer
  structure and delayed archive activation.

This is not another fixed RF geometry rerun. It tests whether pretrained
timing-state information is useful as a hardware-aware secondary archive tag.

## Descriptor Axes

The archive uses explicit axes, not a new profile name:

1. `source_aligned_rf_timing_leaf_ids`
2. `source_aligned_masterrtl_branching`
3. `source_aligned_rtltimer_wire_density`

All three axes are PPA-free. They do not use final PPA, reference PPA, fitness,
hypervolume, Pareto rank, or test pass rate as behavior descriptor inputs.

## Search Surface

T83 reuses the delayed archive activation surface because it is the best recent
timing clue and is closer to classic than sparse-front or stagnation-triggered
activation.

| Setting | Value |
| --- | --- |
| Archive type | `grid_quantile` |
| Warmup successes | `4` |
| Cell mode | `elite_pareto_slot` |
| Max elites per cell | `2` |
| Fill target fraction | `0.10` |
| Improve backfill fraction | `0.05` |
| Archive activation generation | `3` |
| Parent selection after activation | `nsga2_global_rank` |
| Champion lane after activation | `0.90` |
| Two-parent probability | `0.0` |
| Operator | `single_thought_operator`, one-parent only |

## Promotion Gate

Promote only if the arm:

- preserves every classic-covered design in the frozen eight-design screen;
- avoids a large valid-PPA collapse;
- reaches classic mean HV within the registered `1-2%` tolerance or improves a
  primary front metric enough to justify a follow-up;
- improves at least one front-material metric without depending on
  `Prob135_m2014_q6b`;
- does not hide descriptor collapse or duplicate/invalid candidates as useful
  diversity.

If it loses clearly, retire this exact RF leaf-ID structural delayed geometry.
