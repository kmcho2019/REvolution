# T56 Coarse SR2 T51-Control QD Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T56 Coarse SR2 T51-Control QD root: `exp/useful_bd_push/t56_coarse_sr2_t51_control_20260623_074326_UTC/hard_tuning/code_thought_coarse_sr2_t51_control_qd`

## Headline

- Claim status: `T0 diagnostic_retire_coarse_sr2_geometry`.
- Mean HV delta: `-0.010545`.
- Mean HV-AUC delta: `-0.012925`.
- Mean best-score delta: `0.040697`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `4`.
- Success-parent requests: `0`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T56 coarse SR2 T51-control QD | 13 | 13 | 0.082056 | 0.069095 | 0.268625 | 231 | 22 |

## Files

- `tables/t56_problem_seed_metrics.csv`
- `tables/t56_aggregate_metrics.csv`
- `tables/t56_comparison_deltas.csv`
- `tables/t56_validity_gates.csv`
- `tables/t56_operator_counters.csv`
- `tables/t56_family_comparison_13_problem_subset.csv`
- `tables/t56_family_deltas_13_problem_subset.csv`
- `data/t56_ppa_candidates.csv`
- `figures/t56_hv_delta_heatmap.png`
- `figures/t56_metric_delta_summary.png`
- `figures/t56_validity_funnel.png`
- `figures/t56_front_counts.png`
- `figures/t56_operator_counters.png`
- `figures/t56_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; they do not replace the Phase 03.1 viewer.

The full Phase 03.1 viewer exists at
`../visualizations/qd_ppa_viewer/index.html`. It projects classic candidates
into T56's two-axis archive coordinates for visual comparison only. Strict
schema validation passes; the optional Playwright smoke caveat is recorded in
`../visualizations/qd_ppa_viewer/playwright_caveat.md`.
