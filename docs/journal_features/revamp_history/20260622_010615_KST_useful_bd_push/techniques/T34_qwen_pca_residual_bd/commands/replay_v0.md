# T34 Replay Commands

Status: planned.

```bash
uv run python scripts/analyze_t34_qwen_pca_residual.py \
  --embedding-manifest docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T33_qwen3_preprocessing_ladder_bd/tables/t33_embedding_cache_manifest.csv \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T34_qwen_pca_residual_bd \
  --retention-fraction 0.5 \
  --random-seed 0
```

Validation after implementation:

```bash
uv run pytest tests/scripts/test_analyze_t34_qwen_pca_residual.py
uv run ruff check scripts/analyze_t34_qwen_pca_residual.py tests/scripts/test_analyze_t34_qwen_pca_residual.py
uv run python -m pyright scripts/analyze_t34_qwen_pca_residual.py tests/scripts/test_analyze_t34_qwen_pca_residual.py
uv tool run ty check scripts/analyze_t34_qwen_pca_residual.py tests/scripts/test_analyze_t34_qwen_pca_residual.py
git diff --check
```
