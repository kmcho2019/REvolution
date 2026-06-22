# T36 T11 Bounded Front-Lane BD Artifacts Manifest

Status: completed replay diagnostic.

## Command

```bash
uv run python scripts/analyze_t36_t11_bounded_front_lane.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv \
  --hypergraph-features-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T36_t11_bounded_front_lane_bd \
  --retention-fraction 0.5 \
  --random-seed 0 \
  --cell-bins 2
```

## Generated Tables

| Path | Rows Including Header | SHA256 |
| --- | ---: | --- |
| `tables/archive_comparison.csv` | 16 | `df42cb4a07f2780cbb452d5201c9eab8ecbcf3f5eb6303446753faa0a17266e5` |
| `tables/feature_manifest.csv` | 50 | `c82f14a0f70b0397efdc2017ce429ac10504d7ec0cc00ec03d6ef20587b7ca6c` |
| `tables/lane_summary.csv` | 685 | `e7442e5cfa0900496729e7b0aaea20a0547cce0a8de9f7ed8949d3811e954cc4` |
| `tables/ppa_comparison.csv` | 16 | `bb1c4005b4856efc21c421ab5322fc35dcbf2e5c86d8d18f0ecbb81b5eb8a6e3` |
| `tables/ppa_front_metrics.csv` | 16 | `a65b7db9b12042cf9175919f45572233b44189a6486d24a091fbeb555a1d6b16` |
| `tables/ppa_front_plot_points.csv` | 109 | `b2f41e09e6b5101f7a287e09e32ba2b83eb4669cdcb2969c18a826f72809cdda` |
| `tables/replay_rows.csv` | 1711 | `5e628c90b8093abd20f225ba5a86846cca2610552c6bf373ac689dfe6d1e13e9` |
| `tables/selected_candidates.csv` | 5116 | `929d58ad6d75a54599e7a7f074dac431b5e2485af0593f80c3256d926cded3da` |

## Generated Figures

| Path | SHA256 |
| --- | --- |
| `figures/t36_front_hits.png` | `104e0d021fbba74441373f021b7ffe978567370f53f8953fdec3129519a165e3` |
| `figures/t36_hypervolume.png` | `202cc402ca4f0174f4ea188b4d443f53240ed25cd2896cbde62b4d1872b0f7d8` |
| `figures/t36_multi_problem_ppa_pareto_fronts.png` | `5d63e67c007d106cb51071f72e5cc6cdb6386d6a39059be0a70c0576b9f6fa46` |
| `figures/t36_raw_area_power_pareto_front.png` | `8bce1894d26eee715d81b40533789a2bbab4f01d1f293f331d760d84ecd2c63b` |

## Generated Visualizations

| Path | SHA256 |
| --- | --- |
| `visualizations/direct_ppa_pareto/index.html` | `02e851e3287535aa878874d701b3f4416c6d01cf8d1bda1ada1e95b26b00fe59` |
| `visualizations/direct_ppa_pareto/manifest.json` | `c76034ce20124ba8279fcced82732e5c66b36152b4185ff73873c738ef456a6f` |
| `visualizations/direct_ppa_pareto/metrics.json` | `11a7c9df7b0db6b6bcca31b15fa5853173e442cef300a31bea3c5b78e57d6db5` |
| `visualizations/direct_ppa_pareto/points.json` | `b01afc1ac8b59e89621354688fb0d61fb4bc4556be95b670a80d4fb80bd0d5cd` |
| `visualizations/direct_ppa_pareto/README.md` | `ddca79c8dbd6bf75d287c0b89f79f4a23de31d4696bb2d48037fbb9cd43287b5` |
| `visualizations/direct_ppa_pareto/screenshot.png` | `03182efa196d2033ee8b3a0f74336ea4539aa2b6f51b417fceb2b353a9f10c85` |

## Code

| Path | SHA256 |
| --- | --- |
| `scripts/analyze_t36_t11_bounded_front_lane.py` | `053817fb985e131485bbf453cecceb5210454ba6aecea91aaf321857e78aada4` |
| `tests/scripts/test_analyze_t36_t11_bounded_front_lane.py` | `96d432673248bef4701f315bb28051d23393c98101a1952403019ca23d577ad3` |

## Validation

- `uv run pytest tests/scripts/test_analyze_t36_t11_bounded_front_lane.py`
- `uv run ruff check scripts/analyze_t36_t11_bounded_front_lane.py tests/scripts/test_analyze_t36_t11_bounded_front_lane.py`
- `uv run python -m pyright scripts/analyze_t36_t11_bounded_front_lane.py tests/scripts/test_analyze_t36_t11_bounded_front_lane.py`
- `uv tool run ty check scripts/analyze_t36_t11_bounded_front_lane.py tests/scripts/test_analyze_t36_t11_bounded_front_lane.py`
- Playwright filesystem-opened `visualizations/direct_ppa_pareto/index.html`
  and saved `visualizations/direct_ppa_pareto/screenshot.png`.
