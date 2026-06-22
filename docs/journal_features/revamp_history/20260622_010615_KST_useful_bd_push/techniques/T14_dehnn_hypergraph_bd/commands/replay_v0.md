# T14 Replay Command

Run from `/workspace`:

```bash
uv run python scripts/analyze_t14_dehnn_hypergraph.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T14_dehnn_hypergraph_bd \
  --retention-fraction 0.5 \
  --random-seed 0
```

Focused validation:

```bash
uv run pytest tests/scripts/test_analyze_t14_dehnn_hypergraph.py
uv run ruff check scripts/analyze_t14_dehnn_hypergraph.py tests/scripts/test_analyze_t14_dehnn_hypergraph.py
uv run python -m pyright scripts/analyze_t14_dehnn_hypergraph.py tests/scripts/test_analyze_t14_dehnn_hypergraph.py
uv tool run ty check scripts/analyze_t14_dehnn_hypergraph.py tests/scripts/test_analyze_t14_dehnn_hypergraph.py
```
