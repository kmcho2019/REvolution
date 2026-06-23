# T49 Thought-K Repair Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T49 Thought-K Repair root: `exp/useful_bd_push/t49_thought_k_role_separated_repair_20260623_003408_UTC/hard_tuning/thought_k_role_separated_repair_qd`

## Headline

- Claim status: `mixed_diagnostic`.
- Mean HV delta: `-0.005704`.
- Mean HV-AUC delta: `0.001127`.
- Mean best-score delta: `0.067203`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `6`.
- generated thought count: `30`.
- generated code sample count: `90`.
- Success-parent requests: `0`.
- Two-parent attempts: `0`.
- Direct PPA supplement:
  `../visualizations/direct_ppa_pareto/index.html`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T49 thought repair QD | 13 | 13 | 0.086897 | 0.083147 | 0.295131 | 231 | 20 |

## Files

- `tables/t49_problem_seed_metrics.csv`
- `tables/t49_aggregate_metrics.csv`
- `tables/t49_comparison_deltas.csv`
- `tables/t49_validity_gates.csv`
- `tables/t49_operator_counters.csv`
- `data/t49_ppa_candidates.csv`
- `figures/t49_hv_delta_heatmap.png`
- `figures/t49_metric_delta_summary.png`
- `figures/t49_validity_funnel.png`
- `figures/t49_front_counts.png`
- `figures/t49_operator_counters.png`
- `figures/t49_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer if
T49 Thought-K Repair advances to a larger archive-backed run.
