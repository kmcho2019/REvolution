# T13 Replay Command

Run from `/workspace`:

```bash
uv run python scripts/analyze_t13_aurora_autoencoder.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T13_aurora_incremental_autoencoder_bd \
  --retention-fraction 0.5 \
  --random-seed 0 \
  --latent-dims 2 4 8
```

Focused validation:

```bash
uv run pytest tests/scripts/test_analyze_t13_aurora_autoencoder.py
uv run ruff check scripts/analyze_t13_aurora_autoencoder.py tests/scripts/test_analyze_t13_aurora_autoencoder.py
uv run python -m pyright scripts/analyze_t13_aurora_autoencoder.py tests/scripts/test_analyze_t13_aurora_autoencoder.py
uv tool run ty check scripts/analyze_t13_aurora_autoencoder.py tests/scripts/test_analyze_t13_aurora_autoencoder.py
```
