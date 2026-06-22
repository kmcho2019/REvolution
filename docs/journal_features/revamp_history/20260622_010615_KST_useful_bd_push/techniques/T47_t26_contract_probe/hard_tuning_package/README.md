# T47 Contract Probe Package

Run root: `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning`

## Headline

- Claim status: `diagnostic_pending_review`.
- Mean HV delta: `-0.015483`.
- Mean HV-AUC delta: `-0.018435`.
- Mean best-score delta: `0.024728`.
- Classic-covered valid-PPA losses: `0`.
- Yield warnings: `4`.
- Small-n labels: `4`.

## Aggregate Metrics

| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 26 | 13 | 0.106717 | 0.087304 | 0.245296 | 538 | 61 |
| Exact T26 QD | 26 | 13 | 0.091234 | 0.068869 | 0.270024 | 428 | 53 |

## Files

- `tables/t47_problem_seed_metrics.csv`
- `tables/t47_aggregate_metrics.csv`
- `tables/t47_comparison_deltas.csv`
- `tables/t47_validity_gates.csv`
- `data/t47_ppa_candidates.csv`
- `figures/t47_hv_delta_heatmap.png`
- `figures/t47_metric_delta_summary.png`
- `figures/t47_validity_funnel.png`
- `figures/t47_front_counts.png`

## Discipline

This is a hard/tuning screen, not a held-out claim. Use it to decide
whether exact T26 deserves a held-out launch or whether a narrow T26.1
variant is needed. Do not assign T1 or higher from this package alone.
