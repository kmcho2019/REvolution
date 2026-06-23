# T67 Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T67 root: `exp/useful_bd_push/t67_rtl_native_seeded_thought_20260623_170935_UTC/hard_tuning/rtl_native_seeded_thought_qd`

## Headline

- Claim status: `blocked`.
- Mean HV delta: `-0.000860`.
- Mean HV-AUC delta: `0.000070`.
- Mean best-score delta: `-0.001362`.
- Classic-covered valid-PPA losses: `1`.
- Yield warnings: `2`.
- generated thought count: `40`.
- generated code sample count: `120`.
- Success-parent requests: `0`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T67 RTL-native seeded thought QD | 13 | 13 | 0.091741 | 0.082090 | 0.226566 | 304 | 18 |

## Files

- `tables/t67_problem_seed_metrics.csv`
- `tables/t67_aggregate_metrics.csv`
- `tables/t67_comparison_deltas.csv`
- `tables/t67_validity_gates.csv`
- `tables/t67_thought_seed_counters.csv`
- `data/t67_ppa_candidates.csv`
- `figures/t67_hv_delta_heatmap.png`
- `figures/t67_metric_delta_summary.png`
- `figures/t67_validity_funnel.png`
- `figures/t67_front_counts.png`
- `figures/t67_thought_seed_counters.png`
- `figures/t67_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer if
T67 advances to a larger archive-backed run.
