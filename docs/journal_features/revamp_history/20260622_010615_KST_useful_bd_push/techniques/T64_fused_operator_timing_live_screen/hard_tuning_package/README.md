# T64 Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T64 root: `exp/useful_bd_push/t64_fused_operator_timing_20260623_144117_UTC/hard_tuning/fused_rtl_operator_timing_qd`

## Headline

- Claim status: `T0 diagnostic_yield_archive_ablation_not_promoted`.
- Mean HV delta: `-0.008029`.
- Mean HV-AUC delta: `-0.009270`.
- Mean best-score delta: `-0.000898`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `0`.
- Success-parent requests: `0`.
- Two-parent attempts: `0`.
- Two-parent fallbacks: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T64 operator/timing QD | 13 | 13 | 0.084572 | 0.072750 | 0.227030 | 283 | 23 |

## Files

- `tables/t64_problem_seed_metrics.csv`
- `tables/t64_aggregate_metrics.csv`
- `tables/t64_comparison_deltas.csv`
- `tables/t64_validity_gates.csv`
- `tables/t64_operator_counters.csv`
- `data/t64_ppa_candidates.csv`
- `figures/t64_hv_delta_heatmap.png`
- `figures/t64_metric_delta_summary.png`
- `figures/t64_validity_funnel.png`
- `figures/t64_front_counts.png`
- `figures/t64_operator_counters.png`
- `figures/t64_direct_ppa_fronts_seed*.png`
- `tables/t64_ppa_completeness.csv`
- `../visualizations/direct_ppa_pareto/index.html`
- `../visualizations/qd_ppa_viewer/index.html`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer. T64 does
not advance to seed `1002` as an exact primary archive geometry.
