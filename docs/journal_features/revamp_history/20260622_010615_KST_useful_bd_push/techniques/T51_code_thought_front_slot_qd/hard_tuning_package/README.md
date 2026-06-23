# T51 Code-Thought Front-Slot QD Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T51 Code-Thought Front-Slot QD root: `exp/useful_bd_push/t51_code_thought_front_slot_20260623_030540_UTC/hard_tuning/code_thought_front_slot_qd`

## Headline

- Claim status: `positive_ablation_not_promoted`.
- Mean HV delta: `-0.003349`.
- Mean HV-AUC delta: `0.003434`.
- Mean best-score delta: `0.065552`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `0`.
- Success-parent requests: `0`.
- Two-parent attempts: `0`.
- Matched 12-problem T50 comparison: T51 improves generated candidates,
  valid-PPA count, mean HV, mean HV-AUC, unique PPA points, and
  reference-beating count; it still loses raw PPA-front points.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T51 code-thought front-slot QD | 13 | 13 | 0.089252 | 0.085454 | 0.293480 | 266 | 21 |

## Files

- `tables/t51_problem_seed_metrics.csv`
- `tables/t51_aggregate_metrics.csv`
- `tables/t51_comparison_deltas.csv`
- `tables/t51_validity_gates.csv`
- `tables/t51_operator_counters.csv`
- `tables/t51_family_comparison_12_problem_subset.csv`
- `tables/t51_family_deltas_12_problem_subset.csv`
- `data/t51_ppa_candidates.csv`
- `validation/pareto_front_validation.md`
- `validation/single_thought_operator_validation.md`
- `figures/t51_hv_delta_heatmap.png`
- `figures/t51_metric_delta_summary.png`
- `figures/t51_validity_funnel.png`
- `figures/t51_front_counts.png`
- `figures/t51_operator_counters.png`
- `figures/t51_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer if
T51 Code-Thought Front-Slot QD advances to a larger archive-backed run.

The Phase 03.1 viewer is exported separately under
`../visualizations/qd_ppa_viewer/`. Non-strict viewer validation passes.
Strict validation fails because classic candidates have no honest SR-PCA
archive projection.
