# T75 Matched Comparison Results

Tier: `T0 positive_diagnostic_not_promoted`.

## Summary

T75 preserves all `13/13` reference-complete hard/tuning comparisons and has
`274` valid-PPA samples, above classic's `257` and T74's `237`. It improves
mean HV over T73 and T74, but it still trails classic:

| Method | Mean HV | HV wins | Mean Pareto points | Mean ref-beating | Valid-PPA samples |
| --- | ---: | ---: | ---: | ---: | ---: |
| Classic | 0.0926007600 | 8 | 2.31 | 3.54 | 257 |
| T73 | 0.0890223082 | 0 | 1.46 | 3.69 | 294 |
| T74 | 0.0851926237 | 1 | 1.62 | 3.15 | 237 |
| T75 | 0.0899974770 | 1 | 1.62 | 3.08 | 274 |

## What Improved

- Mean HV improves over T73 by `+0.0009751689`.
- Mean HV improves over T74 by `+0.0048048533`.
- T75 preserves every classic-covered design.
- T75 valid-PPA count is higher than classic (`274` versus `257`) and T74
  (`274` versus `237`).

## What Blocks Promotion

- Classic still wins the aggregate multi-objective comparison.
- T75 mean HV is below classic by `-0.0026032830`.
- T75 mean Pareto point count is `1.62` versus classic `2.31`.
- T75 mean reference-beating count is `3.08` versus classic `3.54`.
- The largest visible HV loss is `RTLLM/Prob041_traffic_light`, which dominates
  the aggregate even though T75 has positive deltas on ALU and gshare.

## Final-Analysis Caveat

The broad final-analysis command was interrupted in `design_space_analysis`
while recovering source-aligned features. Completed and committed sections:

- `backend_comparison`;
- `hard_iteration_analysis`;
- `pareto_analysis`;
- `evolutionary_reports`;
- `ppa_distribution`.

This package uses only completed PPA/Pareto outputs. The caveat is recorded in
`tables/t75_final_analysis_caveat.json`.

## Next Decision

Retire exact T75 as a direct front-slot fraction follow-up. The next step
should not be another small pressure tweak. Use the new roadmap:

- fixed-total-budget shape ablation to test whether `12 x 3` is too shallow;
- or a verification-gated MasterRTL pretrained tree-leaf/margin embedding lane.
