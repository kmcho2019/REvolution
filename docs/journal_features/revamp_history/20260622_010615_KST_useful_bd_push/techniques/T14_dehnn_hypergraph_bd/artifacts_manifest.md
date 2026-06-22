# T14 DE-HNN Hypergraph BD Artifacts Manifest

Status: completed replay diagnostic.

## Command

```bash
uv run python scripts/analyze_t14_dehnn_hypergraph.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T14_dehnn_hypergraph_bd \
  --retention-fraction 0.5 \
  --random-seed 0
```

See `commands/replay_v0.md` for focused validation commands.

## Generated Tables

| Path | Rows Including Header | SHA256 |
| --- | ---: | --- |
| `tables/archive_metrics.csv` | 9 | `441aecbd042395b7712a296c2b61e20f145d4681d31d270f6bf0eac56c4fa7e9` |
| `tables/collapse_diagnostics.csv` | 5 | `9a92ba5c2a81c1f8e40f0ebb4e32deca9173b218cd5a4e0efb5f09111d18e150` |
| `tables/extraction_funnel.csv` | 6 | `e589ce89e05624dfe0411a58a5e97df01a7714160d3c9806e5581756a8ff5fa6` |
| `tables/hypergraph_features.csv` | 769 | `ce79d3e7049c656dddd1c34f76d77599c66393fb32209b3fa14cccfc717f68e9` |
| `tables/implementation_feature_manifest.csv` | 37 | `375655c885e65d5f3ce3feb78da70da26c163e6930bc0f7c40e41b3adf6e54e7` |
| `tables/ppa_comparison.csv` | 9 | `d9f7b77025eb9528379ac931bc7af9f2c9262bee914acc966f0efef2c6932002` |
| `tables/ppa_front_metrics.csv` | 9 | `09acd7538fffaacbcc762cccd4884af41223fad6c3273c3cd3fd494913aa07ca` |
| `tables/ppa_front_plot_points.csv` | 61 | `9633cbd0694cb7ab9a068dfa6025886a53692e1d2317236c445f470c4f3dcb7a` |
| `tables/replay_rows.csv` | 913 | `42ab7e56b24e0178dba776e38e998d5a40650d5a117109a1cfca69b2ee6d74a0` |
| `tables/selected_candidates.csv` | 2729 | `ea983eb5978b773f07259b9bafef8ed4f71030b45a6a97140b67da678401be9b` |

## Generated Figures

| Path | SHA256 |
| --- | --- |
| `figures/dehnn_hypervolume.png` | `b39ff12778b1344601f58bcada4680783fc85b2c0af6725e5bacea29643dfce9` |
| `figures/fanout_entropy_vs_hypervolume.png` | `3925916c3edef0da9bb5abc752f7a040ecf7d471d809306a053b0b2385479a7e` |
| `figures/hypergraph_multi_problem_ppa_pareto_fronts.png` | `6b4b3af668654be7a70ff22427001f04c9940d27a22a17f81f239b6e860b3647` |
| `figures/hypergraph_projection.png` | `89c31182c8c2f29ac7056b4ff6a0c4ad5b13a49cc6b9d7fb64fdfcd892967fc0` |
| `figures/hypergraph_raw_area_power_pareto_front.png` | `ac037d2ca3e7d5baa77c34a7ec5b9d1c355c4a91dfa98fdbad16177f0ba85d6a` |

## Code

| Path | SHA256 |
| --- | --- |
| `scripts/analyze_t14_dehnn_hypergraph.py` | `ba0571f758f43443ab4220f6532fb86bacccfaffc8faea1bc82f6ee7d0fbb59b` |
| `tests/scripts/test_analyze_t14_dehnn_hypergraph.py` | `06bf2f08e3fb6534797c246d314c3b15895997552e734d6951886f05e5ce4832` |

## Validation

- `uv run pytest tests/scripts/test_analyze_t14_dehnn_hypergraph.py`
- `uv run ruff check scripts/analyze_t14_dehnn_hypergraph.py tests/scripts/test_analyze_t14_dehnn_hypergraph.py`
- `uv run python -m pyright scripts/analyze_t14_dehnn_hypergraph.py tests/scripts/test_analyze_t14_dehnn_hypergraph.py`
- `uv tool run ty check scripts/analyze_t14_dehnn_hypergraph.py tests/scripts/test_analyze_t14_dehnn_hypergraph.py`
