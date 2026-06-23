# T52 Code-Thought Full-Pareto QD Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T52 Code-Thought Full-Pareto QD root: `exp/useful_bd_push/t52_code_thought_full_pareto_20260623_035857_UTC/hard_tuning/code_thought_full_pareto_qd`

## Headline

- Claim status: `T0 diagnostic_retired_full_pareto`.
- Mean HV delta: `-0.009099`.
- Mean HV-AUC delta: `-0.026228`.
- Mean best-score delta: `0.014333`.
- Classic-covered valid-PPA losses: `0`.
- Yield warning rows: `2` (`Prob098_circuit7` functionality and valid-PPA).
- Success-parent requests: `0`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T52 code-thought full-Pareto QD | 13 | 13 | 0.083502 | 0.055792 | 0.242261 | 254 | 24 |

## Files

- `tables/t52_problem_seed_metrics.csv`
- `tables/t52_aggregate_metrics.csv`
- `tables/t52_comparison_deltas.csv`
- `tables/t52_validity_gates.csv`
- `tables/t52_operator_counters.csv`
- `data/t52_ppa_candidates.csv`
- `figures/t52_hv_delta_heatmap.png`
- `figures/t52_metric_delta_summary.png`
- `figures/t52_validity_funnel.png`
- `figures/t52_front_counts.png`
- `figures/t52_operator_counters.png`
- `figures/t52_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic roots. It
is not a held-out RTLLM claim. The result retires this exact full-Pareto
widening because the small front-material recovery versus T51 costs too much
HV-AUC, best score, and Prob098 yield.
