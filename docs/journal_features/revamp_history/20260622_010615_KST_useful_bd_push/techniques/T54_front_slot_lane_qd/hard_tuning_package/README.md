# T54 Front-Slot Lane QD Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T54 Front-Slot Lane QD root: `exp/useful_bd_push/t54_front_slot_lane_20260623_054428_UTC/hard_tuning/code_thought_front_slot_lane_qd`

## Headline

- Claim status: `T0 diagnostic_not_promoted`.
- Mean HV delta: `-0.016709`.
- Mean HV-AUC delta: `-0.019267`.
- Mean best-score delta: `0.035099`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `2`.
- Success-parent requests: `0`.
- front slot lane parent requests: `12`.
- front slot lane parent hits: `4`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T54 front-slot lane QD | 13 | 13 | 0.075892 | 0.062753 | 0.263027 | 253 | 21 |

## Family Comparison

| Comparison | HV Delta | HV-AUC Delta | Best Delta | Valid PPA Delta | Front Delta |
| --- | ---: | ---: | ---: | ---: | ---: |
| T54 - classic | -0.016709 | -0.019267 | 0.035099 | -4 | -9 |
| T54 - T51 | -0.013360 | -0.022701 | -0.030453 | -13 | 0 |
| T54 - T52 | -0.007610 | 0.006961 | 0.020766 | -1 | -3 |
| T54 - T53 | -0.009901 | -0.008258 | -0.027408 | 14 | -1 |

## Files

- `tables/t54_problem_seed_metrics.csv`
- `tables/t54_aggregate_metrics.csv`
- `tables/t54_comparison_deltas.csv`
- `tables/t54_family_comparison_13_problem_subset.csv`
- `tables/t54_family_deltas_13_problem_subset.csv`
- `tables/t54_validity_gates.csv`
- `tables/t54_operator_counters.csv`
- `data/t54_ppa_candidates.csv`
- `figures/t54_hv_delta_heatmap.png`
- `figures/t54_metric_delta_summary.png`
- `figures/t54_validity_funnel.png`
- `figures/t54_front_counts.png`
- `figures/t54_operator_counters.png`
- `figures/t54_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; the full Phase 03.1 viewer lives at
`../visualizations/qd_ppa_viewer/` with a documented Playwright caveat.
