# T75 Matched Package Manifest

## Source Run

```text
exp/useful_bd_push/t75_shape_density_front_pressure_20260624_024005_UTC/hard_tuning
```

## Source Analysis

```text
exp/useful_bd_push/t75_shape_density_front_pressure_20260624_024005_UTC/hard_tuning/final_analysis
```

The final-analysis command was interrupted in `design_space_analysis` after the
PPA and Pareto sections completed. The caveat is in
`tables/t75_final_analysis_caveat.json`.

## Regeneration

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T75_shape_density_front_pressure_qd/matched_classic_comparison/tools/package_t75_matched_summary.py
```

## Committed Data

| Path | Source |
| --- | --- |
| `data/ppa_candidates.csv` | `final_analysis/ppa_distribution/data/ppa_candidates.csv` |
| `data/reference_ppa_metrics.csv` | `final_analysis/ppa_distribution/data/reference_ppa_metrics.csv` |
| `data/best_candidate_by_backend_problem.csv` | `final_analysis/ppa_distribution/data/best_candidate_by_backend_problem.csv` |
| `tables/aggregate_backend_metrics.csv` | `final_analysis/pareto_analysis/aggregate_backend_metrics.csv` |
| `tables/backend_problem_metrics.csv` | `final_analysis/pareto_analysis/backend_problem_metrics.csv` |
| `tables/t75_ppa_completeness.csv` | generated from committed data |
| `tables/t75_direct_comparisons.csv` | generated from committed Pareto table |
