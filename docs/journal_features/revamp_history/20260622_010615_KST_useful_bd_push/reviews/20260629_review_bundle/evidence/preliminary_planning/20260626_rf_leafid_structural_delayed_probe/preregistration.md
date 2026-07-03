# Preregistration

## Arm

`masterrtl_rf_leafid_structural_delayed_8x5`

## Descriptor Axes

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

## Rationale

T82's exact RF timing-state screen is valid but negative. The primary
descriptor-health issue is axis collapse in `source_aligned_rf_timing_path_count`.
T83 keeps the verified RF timing model path but uses `leaf_ids`, which has
stronger non-collapse evidence, as a secondary coordinate beside
source-aligned RTL structure.

T83 also uses delayed archive activation because it was the strongest recent
archive-pressure timing clue and avoids spending early generations on archive
pressure before valid regions have formed.

## Fixed Settings

| Setting | Value |
| --- | --- |
| Run root | `exp/useful_bd_push/prelim_rf_leafid_structural_delayed_20260626_052350_UTC/live` |
| Budget | `8x5` |
| Seed | `1001` |
| Archive activation generation | `3` |
| Parent selection | `nsga2_global_rank` |
| Champion lane | `0.90` |
| Fill target | `0.10` |
| Improve backfill | `0.05` |
| Two-parent probability | `0.0` |
| Token budget | `128000` max/diff tokens |

## Metrics

Primary metrics:

- reference-complete paired mean HV;
- per-problem HV delta versus classic;
- mean Pareto points;
- mean reference-beating candidates;
- valid-PPA coverage and comparison completeness.

Diagnostics:

- descriptor-health collapsed axes;
- archive members and occupied cells;
- repeat aggregate with `Prob135_m2014_q6b` removed if needed;
- visual inspection of the generated summary figure and selected front plots.

## Decision Rule

Do not promote unless the result is within the registered `1-2%` mean-HV
tolerance versus classic or has a strong front-material counter-signal without
covered-design loss. If it clearly loses, retire this exact geometry and move
to a different coupling, not another RF axis reshuffle.
