# T58 T51 T11-PCA4 Front-Slot QD Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T58 T51 T11-PCA4 Front-Slot QD root: `exp/useful_bd_push/t58_t51_t11_pca4_front_slot_20260623_093653_UTC/hard_tuning/t51_t11_pca4_front_slot_qd`

## Headline

- Claim status: `T0 diagnostic_no_promotion`.
- Mean HV delta: `-0.016348`.
- Mean HV-AUC delta: `-0.015787`.
- Mean best-score delta: `0.021823`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `0`.
- Success-parent requests: `0`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T58 T51 T11-PCA4 front-slot QD | 13 | 13 | 0.076253 | 0.066233 | 0.249751 | 266 | 22 |

## Files

- `tables/t58_problem_seed_metrics.csv`
- `tables/t58_aggregate_metrics.csv`
- `tables/t58_comparison_deltas.csv`
- `tables/t58_family_comparison_13_problem_subset.csv`
- `tables/t58_family_deltas_13_problem_subset.csv`
- `tables/t58_validity_gates.csv`
- `tables/t58_operator_counters.csv`
- `data/t58_ppa_candidates.csv`
- `figures/t58_hv_delta_heatmap.png`
- `figures/t58_metric_delta_summary.png`
- `figures/t58_validity_funnel.png`
- `figures/t58_front_counts.png`
- `figures/t58_operator_counters.png`
- `figures/t58_direct_ppa_fronts_seed*.png`
- `figures/t58_raw_area_power_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer if
T58 T51 T11-PCA4 Front-Slot QD advances to a larger archive-backed run.

## Decision

T58 improves aggregate best score and valid-PPA count, but loses classic on
HV, HV-AUC, PPA-front points, unique PPA points, and reference-beating
candidates. It also loses T51 on HV, HV-AUC, best score, unique PPA points,
and reference-beating candidates. Retire exact T58 as a primary archive
geometry before any seed `1002` spend.
