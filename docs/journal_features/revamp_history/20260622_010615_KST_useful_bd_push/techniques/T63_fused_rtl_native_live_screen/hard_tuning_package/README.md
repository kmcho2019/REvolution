# T63 Fused RTL-Native Live Screen Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T63 Fused RTL-Native Live Screen root: `exp/useful_bd_push/t63_fused_rtl_native_20260623_133903_UTC/hard_tuning/fused_rtl_state_pipeline_qd`

## Headline

- Claim status: `T0 positive_mechanism_ablation_not_promoted`.
- Mean HV delta: `-0.003050`.
- Mean HV-AUC delta: `-0.007895`.
- Mean best-score delta: `0.040323`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `2` designs, `4` gate rows.
- Success-parent requests: `0`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T63 fused RTL-native QD | 13 | 13 | 0.089551 | 0.074125 | 0.268251 | 257 | 25 |

## Files

- `tables/t63_problem_seed_metrics.csv`
- `tables/t63_aggregate_metrics.csv`
- `tables/t63_comparison_deltas.csv`
- `tables/t63_validity_gates.csv`
- `tables/t63_operator_counters.csv`
- `data/t63_ppa_candidates.csv`
- `figures/t63_hv_delta_heatmap.png`
- `figures/t63_metric_delta_summary.png`
- `figures/t63_validity_funnel.png`
- `figures/t63_front_counts.png`
- `figures/t63_operator_counters.png`
- `figures/t63_direct_ppa_fronts_seed*.png`
- `tables/t63_ppa_completeness.csv`
- `tables/t63_vs_t51_deltas.csv`
- `../visualizations/direct_ppa_pareto/index.html`
- `../visualizations/qd_ppa_viewer/index.html`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. All 13 completeness rows are
reference-valid headline rows for this subset. Missing-reference designs in
future runs must be labeled `diagnostic_only` and excluded from headline
normalized HV, HV-AUC, and improvement claims.
