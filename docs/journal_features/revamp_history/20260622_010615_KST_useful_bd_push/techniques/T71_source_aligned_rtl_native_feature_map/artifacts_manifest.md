# T71 Artifacts Manifest

Generated from `tools/build_t71_feature_map.py`.

## Source Input

| Path | Role |
| --- | --- |
| `../T70_generated_rtl_extractor_smoke/tables/t70_extractor_results.csv` | Source-aligned MasterRTL/RTL-Timer extractor metrics for 19 generated candidates. |

## Committed Package Artifacts

| Path | Purpose |
| --- | --- |
| `tables/t71_source_aligned_feature_table.csv` | One row per candidate with raw extractor counts, derived diagnostics, and archive-cell assignment. |
| `tables/t71_archive_cells.csv` | One row per occupied cell with candidate, problem, and feature-range membership. |
| `tables/t71_feature_summary.csv` | Min, median, max, unique-count, and meaning for each diagnostic feature. |
| `tables/t71_metrics.json` | Compact machine-readable package metrics and leakage exclusions. |
| `figures/t71_descriptor_scatter.png` | Source-aligned descriptor scatter for operator scale versus state/timing. |
| `figures/t71_archive_cell_heatmap.png` | Candidate count per proposed archive cell. |
| `tools/build_t71_feature_map.py` | Deterministic table and figure builder. |

## Storage Note

T71 does not copy the T70 raw extractor logs or generated SOG/BOG files. It
uses the committed T70 CSV and writes only compact package-local CSV, JSON,
PNG, and Markdown files. No new bulk artifact directory is required under
`exp/` or `/aux`.

## Regeneration

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T71_source_aligned_rtl_native_feature_map/tools/build_t71_feature_map.py
```
