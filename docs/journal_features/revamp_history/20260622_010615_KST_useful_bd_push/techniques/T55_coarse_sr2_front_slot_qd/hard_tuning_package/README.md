# T55 Coarse SR2 Front-Slot QD Hard/Tuning Probe Package

Classic root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution`
T55 Coarse SR2 Front-Slot QD root: `exp/useful_bd_push/t55_coarse_sr2_front_slot_20260623_064153_UTC/hard_tuning/code_thought_coarse_sr2_front_slot_qd`

## Headline

- Claim status: `T0 positive_mechanism_ablation_not_promoted`.
- Mean HV delta: `-0.006412`.
- Mean HV-AUC delta: `-0.009713`.
- Mean best-score delta: `0.036140`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `0`.
- Success-parent requests: `0`.
- front slot lane parent requests: `15`.
- front slot lane parent hits: `9`.
- Two-parent attempts: `0`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 13 | 13 | 0.092601 | 0.082020 | 0.227928 | 257 | 30 |
| T55 coarse SR2 front-slot QD | 13 | 13 | 0.086189 | 0.072307 | 0.264068 | 233 | 23 |

## Family Comparison

| Comparison | HV Delta | HV-AUC Delta | Best Delta | Valid PPA Delta | Front Delta |
| --- | ---: | ---: | ---: | ---: | ---: |
| T55 - classic | -0.006412 | -0.009713 | 0.036140 | -24 | -7 |
| T55 - T51 | -0.003063 | -0.013147 | -0.029412 | -33 | 2 |
| T55 - T52 | 0.002687 | 0.016515 | 0.021807 | -21 | -1 |
| T55 - T53 | 0.000396 | 0.001296 | -0.026367 | -6 | 1 |
| T55 - T54 | 0.010297 | 0.009554 | 0.001041 | -20 | 2 |

## Files

- `tables/t55_problem_seed_metrics.csv`
- `tables/t55_aggregate_metrics.csv`
- `tables/t55_comparison_deltas.csv`
- `tables/t55_family_comparison_13_problem_subset.csv`
- `tables/t55_family_deltas_13_problem_subset.csv`
- `tables/t55_validity_gates.csv`
- `tables/t55_operator_counters.csv`
- `data/t55_ppa_candidates.csv`
- `figures/t55_hv_delta_heatmap.png`
- `figures/t55_metric_delta_summary.png`
- `figures/t55_validity_funnel.png`
- `figures/t55_front_counts.png`
- `figures/t55_operator_counters.png`
- `figures/t55_direct_ppa_fronts_seed*.png`

## Discipline

This package compares a hard/tuning screen against the T47 classic
roots. It is not a held-out RTLLM claim. The direct PPA-front plots are
reader-facing supplements; the full Phase 03.1 viewer lives at
`../visualizations/qd_ppa_viewer/` with a documented Playwright caveat.
