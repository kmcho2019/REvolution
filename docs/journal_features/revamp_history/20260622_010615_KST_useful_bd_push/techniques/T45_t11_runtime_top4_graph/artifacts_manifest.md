# T45 Artifacts Manifest

Status: complete live screen; packaged 2026-06-22 UTC.

## Runtime Roots

- Full live root:
  `exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_172949_UTC/`
- Runtime outputs stay under `exp/`, not `/aux`.

## Committed Artifacts

- `methodology.md`
- `commands/live_screen_v0.md`
- `results_report.md`
- `tables/run_matrix.csv`
- `tables/preflight_models_20260622_172949_UTC.json`
- `tables/live_screen_v0_subset.yaml`
- `tables/t45_pareto_front_validation.{json,md}`
- `tables/t45_candidate_ppa_points.csv`
- `tables/t45_problem_method_summary.csv`
- `tables/t45_method_manifest.csv`
- `tables/README.md`
- `figures/t45_raw_area_power_fronts.png`
- `figures/t45_front_count_summary.png`
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

- `data/configs/qd_descriptor_profiles.yaml`
- `src/revolution/graph_descriptor_evaluator.py`
- `src/revolution/qd/descriptors.py`
- `src/revolution/qd/ppa_visualization_export.py`
- `src/revolution/qd/ppa_visualization_viewer.py`
- `scripts/package_t45_t11_runtime_top4_graph.py`
- `scripts/export_qd_ppa_visualization.py`
- `scripts/validate_qd_ppa_visualization.py`
- `tests/revolution/test_qd_descriptors.py`
- `tests/scripts/test_package_t45_t11_runtime_top4_graph.py`

## Hashes

| Artifact | SHA-256 |
| --- | --- |
| `figures/t45_raw_area_power_fronts.png` | `70b036c87490da48508227d73f87c26a181e9a24982844bcbc08371015125e1e` |
| `figures/t45_front_count_summary.png` | `a8627f4b5f7ef3f253f470b352a1ac89cbdf2ce3d7808fa83a2facbb697573bc` |
| `tables/t45_candidate_ppa_points.csv` | `ff9c422bd9d78f1434b0db41137eb4b764904482fc58d48165603cf830357db5` |
| `tables/t45_problem_method_summary.csv` | `711df27580302cf95a69f0f44ba2f41abd15b4efbfc26fd5489e8bdfd6f4b002` |
| `tables/t45_pareto_front_validation.json` | `0460900a94193be6879d2345405a85e5f32ef22375fa15017933874afe991c57` |
| `visualizations/direct_ppa_pareto/index.html` | `f28075e73a36422dda1ac78c35c9b4af5038b88641ba09ae2cc745cf60b3662c` |
| `visualizations/direct_ppa_pareto/metrics.json` | `865b76b2a8732bdf08baec80c8681b17e1754d227ed5d6a22d7e67225d22e35d` |
| `visualizations/direct_ppa_pareto/screenshot.png` | `9ebc81cac709776703b493154d4b3d3861349e27dc558e4c6ea7050d48ea0099` |
| `visualizations/qd_ppa_viewer/index.html` | `9d4aa32b365cf412aed5c1676de560097d4b79d1b4ccf9251ab26c55e1656fc8` |
| `visualizations/qd_ppa_viewer/manifest.json` | `278cdfdf9d651367ec8ea8dcd9c372504f1d363089feec5671a6cf4ae1c405e1` |
| `visualizations/qd_ppa_viewer/validation.json` | `95d9c4c523006c51a62a2ca46c794f454130127a7a1be1114660471002fd5003` |
| `visualizations/qd_ppa_viewer/screenshot.png` | `86de5279f4347be379f89133bce99c06a37aad08d44a39106ddc778227275d9a` |
| `visualizations/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/ppa_candidates.csv` | `894fe5704d7a3d15b999063976f641870982a1b06271566b2023f65dd10c1e50` |
| `visualizations/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/reference_ppa_metrics.csv` | `62f3d7c5667e2ec923dd201812f1850e6a855f04841473a71c9d444ba6a0ca84` |
| `visualizations/qd_ppa_viewer_source/final_analysis/design_space_analysis/successful_candidates.csv` | `e901fca34e6a74e333508b78d5d30d965de364e31fc6f2cb965e830a9756eb51` |

## Validation

- `curl --max-time 10 http://20.0.0.103:8000/v1/models`
- `uv run python scripts/validate_pareto_front_run.py --run-root exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_172949_UTC --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph/tables/live_screen_v0_subset.yaml --classic-mode classic_revolution --pareto-qd-mode t11_runtime_top4_graph_qd --require-full-subset`
- `uv run python scripts/package_t45_t11_runtime_top4_graph.py --t45-run-root exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_172949_UTC --t44-run-root exp/useful_bd_push/t44_t11_runtime_graph_bridge_20260622_114838_UTC --t43-run-root exp/useful_bd_push/t43_staged_sparse_yield_gate_qd_20260622_102415_UTC --t39-run-root exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph`
- `uv run python scripts/export_qd_ppa_visualization.py --run-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph/visualizations/qd_ppa_viewer_source --backend_run classic=exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_172949_UTC/classic_revolution/seed_1001 --backend_run t11_runtime_top4_graph_qd=exp/useful_bd_push/t45_t11_runtime_top4_graph_20260622_172949_UTC/t11_runtime_top4_graph_qd/seed_1001 --archive_source_backend t11_runtime_top4_graph_qd --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph/tables/live_screen_v0_subset.yaml --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph/visualizations/qd_ppa_viewer --strict`
- `uv run python scripts/validate_qd_ppa_visualization.py --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph/visualizations/qd_ppa_viewer --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T45_t11_runtime_top4_graph/tables/live_screen_v0_subset.yaml --strict --playwright`

Additional local validation before commit:

- `uv run pytest tests/scripts/test_package_t45_t11_runtime_top4_graph.py tests/revolution/test_qd_descriptors.py -q`
- `uv run ruff check scripts/package_t45_t11_runtime_top4_graph.py tests/scripts/test_package_t45_t11_runtime_top4_graph.py`
- `uv tool run ty check scripts/package_t45_t11_runtime_top4_graph.py tests/scripts/test_package_t45_t11_runtime_top4_graph.py`
- `git diff --check`
