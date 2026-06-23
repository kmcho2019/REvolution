# T66 Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T66 root: `exp/useful_bd_push/t66_rtl_native_front_guarded_parent_20260623_160756_UTC/hard_tuning/rtl_native_front_guarded_parent_qd`

## Headline

- Claim status: `T0 diagnostic_yield_positive_front_negative_not_promoted`.
- Mean HV delta: `-0.011308`.
- Mean HV-AUC delta: `-0.010577`.
- Mean best-score delta: `0.050092`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `2` problem-level warnings (`4` metric rows).
- Success-parent requests: `0`.
- front slot lane parent requests: `15`.
- front slot lane parent hits: `12`.
- Two-parent attempts: `0`.
- Two-parent fallbacks: `0`.
- Two-parent gate attempts: `0`.
- Two-parent gate accepts: `0`.
- Two-parent gate rejects: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T66 RTL-native guarded parent QD | 13 | 13 | 0.081293 | 0.071443 | 0.278020 | 260 | 20 |

## Files

- `tables/t66_problem_seed_metrics.csv`
- `tables/t66_aggregate_metrics.csv`
- `tables/t66_comparison_deltas.csv`
- `tables/t66_validity_gates.csv`
- `tables/t66_ppa_completeness.csv`
- `tables/t66_problem_manifest.csv`
- `tables/t66_reference_ppa_metrics.csv`
- `tables/t66_parent_gate_counters.csv`
- `data/t66_ppa_candidates.csv`
- `figures/t66_hv_delta_heatmap.png`
- `figures/t66_metric_delta_summary.png`
- `figures/t66_validity_funnel.png`
- `figures/t66_front_counts.png`
- `figures/t66_parent_gate_counters.png`
- `figures/t66_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer if
T66 advances to a larger archive-backed run.
