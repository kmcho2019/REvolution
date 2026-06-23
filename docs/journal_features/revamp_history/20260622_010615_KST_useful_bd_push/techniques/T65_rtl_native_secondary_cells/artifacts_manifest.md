# T65 Artifacts Manifest

Generated: `2026-06-23T15:48:20Z`.

## Source Inputs

- T51 viewer datasets:
  `techniques/T51_code_thought_front_slot_qd/visualizations/qd_ppa_viewer/datasets/`
- T63 viewer datasets:
  `techniques/T63_fused_rtl_native_live_screen/visualizations/qd_ppa_viewer/datasets/`
- T64 viewer datasets:
  `techniques/T64_fused_operator_timing_live_screen/visualizations/qd_ppa_viewer/datasets/`
- T51 direct candidate CSV:
  `techniques/T51_code_thought_front_slot_qd/hard_tuning_package/data/t51_ppa_candidates.csv`
- T63 direct candidate CSV:
  `techniques/T63_fused_rtl_native_live_screen/hard_tuning_package/data/t63_ppa_candidates.csv`
- T64 direct candidate CSV:
  `techniques/T64_fused_operator_timing_live_screen/hard_tuning_package/data/t64_ppa_candidates.csv`

## Generated Tables

| Artifact | Rows | Purpose |
| --- | ---: | --- |
| `tables/secondary_rtl_features.csv` | 321 | Candidate-level RTL-native features and secondary cells. |
| `tables/secondary_cell_metrics.csv` | 12 | Aggregate method/profile secondary-cell metrics. |
| `tables/secondary_problem_metrics.csv` | 156 | Per-problem method/profile metrics. |
| `tables/secondary_deltas_vs_classic.csv` | 117 | Problem-paired deltas versus Classic. |
| `tables/secondary_delta_summary.csv` | 9 | Mean deltas and win/loss/tie counts. |

## Generated Figures

| Artifact | Purpose |
| --- | --- |
| `figures/secondary_cell_delta_summary.png` | Mean secondary-cell deltas versus Classic. |
| `figures/front_cell_heatmap.png` | Best-profile front-cell occupancy heatmap. |
| `figures/timing_risk_projection.png` | Descriptor projection with front markers. |
| `figures/visual_inspection_notes.md` | Manual figure-readability notes. |

## Hashes

| Artifact | SHA-256 |
| --- | --- |
| `scripts/package_t65_secondary_rtl_cells.py` | `2677577629631314ecea1a6bbc0b430877e152093710b628a9f97527f69eee86` |
| `tables/secondary_delta_summary.csv` | `3513cb01ff4004d7aad3b1f7d6f378b0ac76cde685712609c4415df8391b51ce` |
| `tables/secondary_cell_metrics.csv` | `14f14c3217f352cd3f35967fabf50c5124948337a2884f46447104be27f3d3b6` |
| `figures/secondary_cell_delta_summary.png` | `2a9611d59fb016e0293d6327f1d0ca5b818764f36690b80ddb1d34dc3774f50c` |
| `figures/front_cell_heatmap.png` | `2c15a15b774dc5226ba12b3456f0004a3cfcf2c243c1c99b31601f91ec4a9763` |
| `figures/timing_risk_projection.png` | `2dd1b04b0d69c2439ee5ea28a3018081835587a3fd30e0540a86018f89b364d1` |

## Validation

- `uv run pytest tests/scripts/test_package_t65_secondary_rtl_cells.py`
- `uv run ruff check scripts/package_t65_secondary_rtl_cells.py tests/scripts/test_package_t65_secondary_rtl_cells.py`
- Manual visual inspection with `view_image` for all three generated PNGs.
