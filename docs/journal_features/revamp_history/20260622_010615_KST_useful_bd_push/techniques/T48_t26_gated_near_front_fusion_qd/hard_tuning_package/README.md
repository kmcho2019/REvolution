# T48 Gated-Fusion Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T48 root: `exp/useful_bd_push/t48_t26_gated_near_front_fusion_20260622_225714_UTC/hard_tuning/t26_gated_near_front_fusion_qd`

## Headline

- Claim status: `T0 diagnostic after review`.
- Mean HV delta: `-0.010183`.
- Mean HV-AUC delta: `-0.015628`.
- Mean best-score delta: `0.005662`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `3`.
- Two-parent gate accepts: `20`.
- Two-parent gate rejects: `3`.
- Two-parent fallbacks: `28`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 26 | 13 | 0.106717 | 0.087304 | 0.245296 | 538 | 61 |
| T48 gated QD | 26 | 13 | 0.096534 | 0.071676 | 0.250958 | 452 | 51 |

## Files

- `tables/t48_problem_seed_metrics.csv`
- `tables/t48_aggregate_metrics.csv`
- `tables/t48_comparison_deltas.csv`
- `tables/t48_validity_gates.csv`
- `tables/t48_gate_counters.csv`
- `data/t48_ppa_candidates.csv`
- `figures/t48_hv_delta_heatmap.png`
- `figures/t48_metric_delta_summary.png`
- `figures/t48_validity_funnel.png`
- `figures/t48_front_counts.png`
- `figures/t48_gate_counters.png`
- `figures/t48_direct_ppa_fronts_seed1001.png`
- `figures/t48_direct_ppa_fronts_seed1002.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. T48 improved over the T47 exact
T26 control but did not beat classic on the primary HV/HV-AUC evidence.
The reviewed decision is recorded in `../results_report.md`.
