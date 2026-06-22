# T44 Artifacts Manifest

Status: complete live screen; packaged 2026-06-22 UTC.

## Runtime Roots

- Smoke/preflight root:
  `exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_113144_UTC/`
- Full live root:
  `exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_114838_UTC/`
- Runtime outputs stay under `exp/`, not `/aux`.

## Committed Artifacts

- `methodology.md`
- `commands/live_screen_v0.md`
- `results_report.md`
- `tables/run_matrix.csv`
- `tables/smoke_summary.json`
- `tables/preflight_models_20260622_113144_UTC.json`
- `tables/preflight_models_20260622_114838_UTC.json`
- `tables/live_screen_v0_subset.yaml`
- `tables/t44_pareto_front_validation.{json,md}`
- `tables/t44_candidate_ppa_points.csv`
- `tables/t44_problem_method_summary.csv`
- `tables/t44_method_manifest.csv`
- `tables/README.md`
- `figures/t44_raw_area_power_fronts.png`
- `figures/t44_front_count_summary.png`
- `figures/README.md`
- `figures/visual_inspection_notes.md`
- `visualizations/direct_ppa_pareto/README.md`
- `visualizations/direct_ppa_pareto/index.html`
- `visualizations/direct_ppa_pareto/metrics.json`
- `visualizations/direct_ppa_pareto/screenshot.png`
- `visualizations/qd_ppa_viewer/README.md`
- `visualizations/qd_ppa_viewer/index.html`
- `visualizations/qd_ppa_viewer/manifest.json`
- `visualizations/qd_ppa_viewer/descriptor_cache.json`
- `visualizations/qd_ppa_viewer/datasets/*.json`
- `visualizations/qd_ppa_viewer/validation.{json,md}`
- `visualizations/qd_ppa_viewer/screenshot.png`
- `visualizations/qd_ppa_viewer_source/README.md`
- `visualizations/qd_ppa_viewer_source/final_analysis/...`

## Code Paths

- `src/revolution/graph_descriptor_evaluator.py`
- `src/revolution/qd/descriptors.py`
- `src/revolution/qd/ppa_visualization_viewer.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/package_t44_t11_runtime_graph_bridge.py`
- `scripts/validate_qd_ppa_visualization.py`
- `data/configs/qd_descriptor_profiles.yaml`
- `tests/revolution/test_graph_descriptor_evaluator.py`
- `tests/revolution/test_qd_descriptors.py`
- `tests/revolution/test_ppa_visualization_export.py`
- `tests/scripts/test_package_t44_t11_runtime_graph_bridge.py`
- `tests/scripts/test_qd_ppa_visualization_scripts.py`

## Hashes

| Artifact | SHA-256 |
| --- | --- |
| `figures/t44_raw_area_power_fronts.png` | `1e46eb619f063ab15eb5fcd4315a813f4f372980be31f88170280582e9ea0b97` |
| `figures/t44_front_count_summary.png` | `6c09e8ae606087fad05003f06f9a0578ff33762a279de3db1eccfd02e3768eef` |
| `tables/t44_candidate_ppa_points.csv` | `d920817048e5404a3a6ed37fe02c21c82a0966b2d509f578a061d7de06407ab6` |
| `tables/t44_problem_method_summary.csv` | `4123362b54d1314b755227d2b148e617fee94164e332d749426236ef6c271a94` |
| `tables/t44_pareto_front_validation.json` | `99c6e634498138f0e99eb274728a04b069c90bed65bf058ec1563872cace0557` |
| `visualizations/direct_ppa_pareto/index.html` | `1219d0b94f21d93339d088c495dd69c07cf318b754f6ee537442c3fa963779ad` |
| `visualizations/direct_ppa_pareto/metrics.json` | `d411692eaa3e670e19df5a6db103e3f44b1ce2d39b40b608c86292fae46567bc` |
| `visualizations/direct_ppa_pareto/screenshot.png` | `c5558743c24e9b014243412bbb7230df16fc2b3cc609c03042acf7b7f0854565` |
| `visualizations/qd_ppa_viewer/index.html` | `a28cedea3d712f0ff8d50b47c1c81574738b62de48d41e0ee0e52b4dbd4e0f26` |
| `visualizations/qd_ppa_viewer/manifest.json` | `8d224fa5359abbbedefc398c1f6826fd6fb06bf7e504cc771852c9d13b453bee` |
| `visualizations/qd_ppa_viewer/validation.json` | `95d9c4c523006c51a62a2ca46c794f454130127a7a1be1114660471002fd5003` |
| `visualizations/qd_ppa_viewer/screenshot.png` | `e2499da70bdca2d648314d529d8c0789503c9cc418c76de47d7037fded35a35d` |
| `visualizations/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/ppa_candidates.csv` | `203cf50780b263cedd3bfb8ee5f3f0470849874b84cdd41774131f82f27cd6aa` |
| `visualizations/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/reference_ppa_metrics.csv` | `95cb0211c644a6c32336d768025454a493e4417997096e03ae1796b82c358bd5` |
| `visualizations/qd_ppa_viewer_source/final_analysis/design_space_analysis/successful_candidates.csv` | `866957c22ed8936e491c0c58955dea6139a563ce1bb329e9325843d6f7307a2a` |

## Validation

- `curl --max-time 10 http://20.0.0.103:8000/v1/models`
- `uv run python scripts/validate_pareto_front_run.py --run-root exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_114838_UTC --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T44_t11_runtime_graph_bridge/tables/live_screen_v0_subset.yaml --classic-mode classic_revolution --pareto-qd-mode t11_runtime_top8_graph_qd --require-full-subset`
- `uv run python scripts/validate_qd_ppa_visualization.py --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T44_t11_runtime_graph_bridge/visualizations/qd_ppa_viewer --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T44_t11_runtime_graph_bridge/tables/live_screen_v0_subset.yaml --strict --playwright`

The final local validation commands for this commit are recorded in the parent
goal history after tests, lint, type checks, and `git diff --check` finish.
