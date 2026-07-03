# T11 MGVGA Contrastive BD Artifacts Manifest

Status: completed replay diagnostic.

## Command

```bash
uv run python scripts/analyze_t11_mgvga_contrastive.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv \
  --hypergraph-features-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T11_mgvga_contrastive_bd \
  --retention-fraction 0.5 \
  --random-seed 0
```

See `commands/replay_v0.md` for focused validation commands.

## Generated Tables

| Path | Rows Including Header | SHA256 |
| --- | ---: | --- |
| `tables/alignment_coverage.csv` | 6 | `447f53bd67b94ace5bb23edbc8299287bb9ce6ba7e99e932332ef2fc6f48a969` |
| `tables/archive_metrics.csv` | 9 | `467a0fc32e75303cbc618b5eefc24b1ee7ac90957831b6e8517e37f26913a13e` |
| `tables/collapse_diagnostics.csv` | 5 | `3faa3dabd321b5af3eeb09f73952f8ccae7551d876848495884820ceab99c584` |
| `tables/contrastive_training.csv` | 2 | `14c41091c613ef79a620bf17209f04d92e669e3f7be98c34f788939596fa0d73` |
| `tables/feature_manifest.csv` | 50 | `c82f14a0f70b0397efdc2017ce429ac10504d7ec0cc00ec03d6ef20587b7ca6c` |
| `tables/ppa_comparison.csv` | 9 | `e80e5fd90c9e1593a6b13fea4d12f339ad57ffa7d4cf7da4b7e2e45791aa03c7` |
| `tables/ppa_front_metrics.csv` | 9 | `4192485a67bd37bc5bdc9af6cbaea9aed9bfc8b83236ad61a89c10db6b0ed002` |
| `tables/ppa_front_plot_points.csv` | 61 | `1f808f6e493da04e3de9b95f92b5c4bc578696bf247b0b7204f6206fc58daad5` |
| `tables/replay_rows.csv` | 913 | `d73c37e4f3349fa06817e315f990c29afdacf36c3e70ef6e3029cfbd51b98440` |
| `tables/selected_candidates.csv` | 2729 | `9b578b6b3b390f7d24cf661cf4fdf5fc3e38ecf74d36f58d62416f514e1bc965` |

## Generated Figures

| Path | SHA256 |
| --- | --- |
| `figures/aligned_embedding_projection.png` | `8fb4705f43716144c5709ac7c7694ed8c41852340c3ccb7917c0499ab0ebe2e9` |
| `figures/contrastive_feature_scores.png` | `cfd27a3c00994181d9a762e44d151e111e56b1751922af4880e5837059972b03` |
| `figures/mgvga_contrastive_hypervolume.png` | `170a6f80d6932b92c721227a1922dc613bbe5932c6336c6f390c39fe852a273f` |
| `figures/mgvga_multi_problem_ppa_pareto_fronts.png` | `0832eb316bed16816f1ecd955cadb391d1a1490b0214d72c2908f6ac5bee0677` |
| `figures/mgvga_raw_area_power_pareto_front.png` | `20b1f5d404ffce36f1ace8261d3bf7d827032ba1afa6cf34c6539699402eb8c7` |
| `figures/source_graph_agreement.png` | `986d8f8c90983d638a687514eb66e620427a9e73ee75d5f58254e5129b84fa56` |

## Generated Visualizations

| Path | SHA256 |
| --- | --- |
| `visualizations/direct_ppa_pareto/index.html` | `2bb8fcbbc06a3bc81153637fbc8901ffa960221a26147b9d8c75ce5d0749094c` |
| `visualizations/direct_ppa_pareto/manifest.json` | `05be59c8a4c8b40b0debaa9f388e170e622db42c528fb079f9cd5ff91ea56f81` |
| `visualizations/direct_ppa_pareto/metrics.json` | `af8ab4d5ce73c6c7b5ce90b29fb94d86aada66ceb8279adedbfe1a7f68c1478d` |
| `visualizations/direct_ppa_pareto/points.json` | `54ef5064e6ad0d2ee213f3a8233e735b57d965b2444dc196c081225099bd3637` |
| `visualizations/direct_ppa_pareto/README.md` | `8edc54f3115a9ca98287267ab5026cc31edaae3ca8c208ba3b3d1a42a4325e1d` |
| `visualizations/direct_ppa_pareto/screenshot.png` | `dcef16a5f7762c3742b918ea60952a6f48982111eca1d2d46bf9ae9993f1c7a0` |

## Code

| Path | SHA256 |
| --- | --- |
| `scripts/analyze_t11_mgvga_contrastive.py` | `986eb2e0fb8077f83dcc005d1ae170085d26c0748841c270729c384a56fc15a9` |
| `tests/scripts/test_analyze_t11_mgvga_contrastive.py` | `0f247d535e9ecb1e0110ff2d40c46b8dc8a88faca9d5ccc6f6659e0c18ce3620` |

## Validation

- `uv run pytest tests/scripts/test_analyze_t11_mgvga_contrastive.py`
- `uv run ruff check scripts/analyze_t11_mgvga_contrastive.py tests/scripts/test_analyze_t11_mgvga_contrastive.py`
- `uv run python -m pyright scripts/analyze_t11_mgvga_contrastive.py tests/scripts/test_analyze_t11_mgvga_contrastive.py`
- `uv tool run ty check scripts/analyze_t11_mgvga_contrastive.py tests/scripts/test_analyze_t11_mgvga_contrastive.py`
- Playwright filesystem-opened `visualizations/direct_ppa_pareto/index.html`
  and saved `visualizations/direct_ppa_pareto/screenshot.png`.
