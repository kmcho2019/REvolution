# T74 Matched Artifacts Manifest

Run root:
`exp/useful_bd_push/t74_shape_density_front_slot_hybrid_20260624_010922_UTC/hard_tuning`

## Regeneration

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T74_shape_density_front_slot_hybrid_qd/matched_classic_comparison/tools/package_t74_matched_summary.py
```

The script copies compact tables/data from:

```text
exp/useful_bd_push/t74_shape_density_front_slot_hybrid_20260624_010922_UTC/hard_tuning/final_analysis
```

## Committed Artifacts

| Path | Purpose |
| --- | --- |
| `data/ppa_candidates.csv` | Raw valid-PPA candidate inventory for all compared backends. |
| `data/reference_ppa_metrics.csv` | Reference PPA table used for normalized metrics. |
| `data/best_candidate_by_backend_problem.csv` | Best candidate per backend/problem. |
| `tables/aggregate_backend_metrics.csv` | Aggregate HV/front metrics. |
| `tables/backend_problem_metrics.csv` | Per-backend, per-problem Pareto metrics. |
| `tables/t74_ppa_completeness.csv` | Headline/diagnostic comparison status. |
| `figures/t74_hv_delta_by_problem.png` | T74 minus classic HV by problem. |
| `figures/t74_valid_ppa_counts.png` | Classic versus T74 valid-PPA counts. |
| `figures/pareto_examples/` | Representative direct PPA-front panels. |
| `visualizations/qd_ppa_viewer/` | Phase 03.1 viewer bundle. |
