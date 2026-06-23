# T57 T51 Adaptive-Rebin QD Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T57 T51 Adaptive-Rebin QD root: `exp/useful_bd_push/t57_t51_adaptive_rebin_20260623_083945_UTC/hard_tuning/t51_adaptive_rebin_qd`

## Headline

- Claim status: `blocked`.
- Mean HV delta: `-0.016790`.
- Mean HV-AUC delta: `-0.011599`.
- Mean best-score delta: `0.033800`.
- Classic-covered valid-PPA losses: `1`.
- Yield warnings: `2`.
- total rebin count: `0`.
- rebin recent sample count: `70`.
- rebin replay member count: `245`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T57 T51 adaptive-rebin QD | 13 | 13 | 0.075811 | 0.070421 | 0.261728 | 245 | 23 |

## Files

- `tables/t57_problem_seed_metrics.csv`
- `tables/t57_aggregate_metrics.csv`
- `tables/t57_comparison_deltas.csv`
- `tables/t57_validity_gates.csv`
- `tables/t57_rebinning_counters.csv`
- `data/t57_ppa_candidates.csv`
- `figures/t57_hv_delta_heatmap.png`
- `figures/t57_metric_delta_summary.png`
- `figures/t57_validity_funnel.png`
- `figures/t57_front_counts.png`
- `figures/t57_rebinning_counters.png`
- `figures/t57_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer if
T57 T51 Adaptive-Rebin QD advances to a larger archive-backed run.
