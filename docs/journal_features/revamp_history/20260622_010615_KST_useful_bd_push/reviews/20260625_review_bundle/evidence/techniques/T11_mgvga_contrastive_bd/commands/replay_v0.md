# T11 Replay Command

Run from `/workspace`:

```bash
uv run python scripts/analyze_t11_mgvga_contrastive.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv \
  --hypergraph-features-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T11_mgvga_contrastive_bd \
  --retention-fraction 0.5 \
  --random-seed 0
```

The replay regenerates `tables/ppa_front_plot_points.csv`, the raw PPA-front
PNGs in `figures/`, and the filesystem-openable direct PPA viewer at
`visualizations/direct_ppa_pareto/index.html`.

Focused validation:

```bash
uv run pytest tests/scripts/test_analyze_t11_mgvga_contrastive.py
uv run ruff check scripts/analyze_t11_mgvga_contrastive.py tests/scripts/test_analyze_t11_mgvga_contrastive.py
uv run python -m pyright scripts/analyze_t11_mgvga_contrastive.py tests/scripts/test_analyze_t11_mgvga_contrastive.py
uv tool run ty check scripts/analyze_t11_mgvga_contrastive.py tests/scripts/test_analyze_t11_mgvga_contrastive.py
```
