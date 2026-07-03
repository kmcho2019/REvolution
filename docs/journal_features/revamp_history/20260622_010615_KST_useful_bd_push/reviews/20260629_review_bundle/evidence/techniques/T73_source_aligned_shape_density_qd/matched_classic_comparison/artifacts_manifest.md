# T73 Matched Comparison Artifacts

## Committed Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Local navigation and headline result. |
| `results_report.md` | Human-readable conclusion and terminology. |
| `tables/aggregate_backend_metrics.csv` | Aggregate Pareto metrics by backend and benchmark. |
| `tables/backend_problem_metrics.csv` | Per-problem Pareto metrics. |
| `tables/t73_ppa_completeness.csv` | Reference/PPA completeness gate table. |
| `tables/backend_comparison.md` | Detailed final-analysis comparison report. |
| `tables/pareto_report.md` | Detailed Pareto report. |
| `tables/final_analysis_summary.json` | Final-analysis summary JSON. |
| `tables/pareto_summary.json` | Pareto-analysis summary JSON. |
| `data/ppa_candidates.csv` | Candidate-level PPA rows used by the figures. |
| `data/reference_ppa_metrics.csv` | Reference PPA rows used by normalized metrics. |
| `data/best_candidate_by_backend_problem.csv` | Best candidate by backend and problem. |
| `figures/t73_hv_delta_by_problem.png` | Primary per-problem HV-delta figure. |
| `figures/t73_valid_ppa_counts.png` | Valid-PPA sample count comparison. |
| `figures/pareto_examples/*.png` | Representative raw PPA/Pareto panels. |
| `figures/visual_inspection_notes.md` | Manual visual inspection notes. |
| `tools/package_t73_matched_summary.py` | Regenerates compact tables and figures. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1 viewer bundle for classic versus T73. |

## Regeneration

The final-analysis scratch bundle was generated with:

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic_revolution=exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001 \
  --backend_run source_aligned_shape_density_qd=exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning/source_aligned_shape_density_qd/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/tables/hard_tuning_subset.yaml \
  --output-dir exp/useful_bd_push/t73_matched_classic_comparison_20260624_001300_UTC/final_analysis
```

The compact package can be regenerated with:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T73_source_aligned_shape_density_qd/matched_classic_comparison/tools/package_t73_matched_summary.py
```

The full final-analysis scratch output is intentionally not committed:

```text
exp/useful_bd_push/t73_matched_classic_comparison_20260624_001300_UTC/final_analysis
```

Keep it under `exp/`; do not move it to `/aux` or commit the full scratch
bundle.
