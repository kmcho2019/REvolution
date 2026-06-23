# T59 T51 Feedback Front-Slot QD Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T59 T51 Feedback Front-Slot QD root: `exp/useful_bd_push/t59_t51_feedback_front_slot_20260623_110249_UTC/hard_tuning/t51_feedback_front_slot_qd`

## Headline

- Claim status: `T0 diagnostic_no_promotion`.
- Mean HV delta: `-0.005882`.
- Mean HV-AUC delta: `-0.002960`.
- Mean best-score delta: `0.059826`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `2` gate rows from one problem, `Prob153_gshare`.
- Success-parent requests: `0`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T59 T51 feedback front-slot QD | 13 | 13 | 0.086719 | 0.079060 | 0.287754 | 241 | 20 |

## Files

- `tables/t59_problem_seed_metrics.csv`
- `tables/t59_aggregate_metrics.csv`
- `tables/t59_comparison_deltas.csv`
- `tables/t59_validity_gates.csv`
- `tables/t59_operator_counters.csv`
- `data/t59_ppa_candidates.csv`
- `figures/t59_hv_delta_heatmap.png`
- `figures/t59_metric_delta_summary.png`
- `figures/t59_validity_funnel.png`
- `figures/t59_front_counts.png`
- `figures/t59_operator_counters.png`
- `figures/t59_raw_area_power_fronts_seed1001.png`
- `figures/t59_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic roots. It is
not a held-out RTLLM claim. The direct PPA-front plots are reader-facing
supplements; they do not replace the Phase 03.1 viewer.
