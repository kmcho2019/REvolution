# T62 Artifacts Manifest

## Method Docs

| Path | Purpose |
| --- | --- |
| `methodology.md` | Descriptor construction, source tables, and promotion bar. |
| `results_report.md` | Main result, completeness caveat, and follow-up decision. |
| `commands/fused_rtl_native_audit.md` | Reproduction command and validation commands. |

## Tables

| Path | Purpose |
| --- | --- |
| `tables/fused_rtl_features.csv` | Joined T15/T61 candidate features plus fused cell labels. |
| `tables/profile_archive_metrics.csv` | Pooled method/profile occupied and front-cell counts. |
| `tables/profile_problem_metrics.csv` | Per-problem method/profile occupied and front-cell counts. |
| `tables/profile_comparison_deltas.csv` | Per-problem exact-T26-minus-classic cell deltas. |
| `tables/profile_delta_summary.csv` | Problem-balanced summary used by the result report. |
| `tables/ppa_completeness.csv` | Copied RTLLM PPA completeness table. |
| `tables/README.md` | Short table guide. |

## Figures

| Path | Purpose |
| --- | --- |
| `figures/profile_cell_delta_summary.png` | Front-cell and occupied-cell deltas for the three fused profiles. |
| `figures/best_profile_archive_heatmap.png` | Classic versus exact T26 front counts for the selected profile. |
| `figures/visual_inspection_notes.md` | Manual visual-read notes and leakage check. |
| `figures/README.md` | Short figure guide. |
