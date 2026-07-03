# T72 Matched Comparison Artifacts

## Committed Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Local navigation and headline result. |
| `results_report.md` | Human-readable conclusion and terminology. |
| `tables/aggregate_backend_metrics.csv` | Aggregate Pareto metrics by backend and benchmark. |
| `tables/backend_problem_metrics.csv` | Per-problem Pareto metrics. |
| `tables/t72_ppa_completeness.csv` | Reference/PPA completeness gate table. |
| `tables/backend_comparison.md` | Final-analysis backend comparison report. |
| `tables/pareto_report.md` | Final-analysis Pareto report. |
| `tables/final_analysis_summary.json` | Final-analysis summary JSON. |
| `tables/pareto_summary.json` | Pareto-analysis summary JSON. |
| `data/ppa_candidates.csv` | Candidate-level PPA rows used by the figures. |
| `data/reference_ppa_metrics.csv` | Reference PPA rows used by normalized metrics. |
| `data/best_candidate_by_backend_problem.csv` | Best candidate by backend and problem. |
| `figures/t72_hv_delta_by_problem.png` | Primary per-problem HV-delta figure. |
| `figures/t72_valid_ppa_counts.png` | Valid-PPA sample count comparison. |
| `figures/pareto_examples/*.png` | Representative raw PPA/Pareto examples. |
| `figures/visual_inspection_notes.md` | Manual visual inspection notes. |
| `tools/plot_t72_matched_summary.py` | Regenerates the two compact summary PNGs. |
| `visualizations/README.md` | Phase 03.1 viewer status and caveat. |

## Regeneration

The compact summary figures can be regenerated with:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/matched_classic_comparison/tools/plot_t72_matched_summary.py
```

The full final-analysis scratch output is intentionally not committed:

```text
exp/useful_bd_push/t72_matched_classic_comparison_20260623_213900_UTC/final_analysis
```

That directory includes larger generated reports and the attempted matched
Phase 03.1 export. Keep it under `exp/`; do not move it to `/aux` or commit
the full bundle.
