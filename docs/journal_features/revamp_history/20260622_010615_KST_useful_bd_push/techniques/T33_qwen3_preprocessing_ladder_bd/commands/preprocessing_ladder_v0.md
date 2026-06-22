# T33 Preprocessing Ladder Commands

Status: T33a, T33b, and T33c commands are implemented and run.

## Preflight

```bash
git status --short --branch
uv run python -V
yosys -V
```

If Qwen dependencies do not fit the repo environment, create an isolated env:

```bash
uv venv exp/useful_bd_push/envs/t33_qwen3_preprocessing_ladder_bd_YYYYMMDD_HHMMSS_UTC
```

## Planned Run Shape

T33a source inventory:

```bash
uv run python scripts/package_t33_qwen_ladder_inventory.py \
  --qwen-dir exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC \
  --compiled-bundle-dir docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T33_qwen3_preprocessing_ladder_bd
```

T33b preprocessing-view cache:

```bash
uv run python scripts/generate_t33_qwen_preprocessing_views.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --output-root exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_YYYYMMDD_HHMMSS_UTC \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T33_qwen3_preprocessing_ladder_bd
```

T33c embedding cache, using the existing isolated Qwen env:

```bash
exp/diversity_check/encoder_envs/qwen3_probe/bin/python \
  scripts/embed_t33_qwen_preprocessing_views.py \
  --view-manifest docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T33_qwen3_preprocessing_ladder_bd/tables/t33_preprocessing_view_manifest.csv \
  --output-root exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_20260622_021639_UTC \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T33_qwen3_preprocessing_ladder_bd \
  --model-id Qwen/Qwen3-Embedding-0.6B \
  --batch-size 32 \
  --chunk-max-chars 4096
```

Next diagnostic run:

```bash
uv run python scripts/analyze_t33_qwen_embedding_diagnostics.py \
  --embedding-root exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_20260622_021639_UTC/embeddings \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T33_qwen3_preprocessing_ladder_bd
```

The next script should generate collapse diagnostics and replay tables. It must
not read PPA fields until the replay evaluation stage.

## Required Post-Run Checks

```bash
uv run python scripts/package_t33_qwen3_preprocessing_ladder.py \
  --run-root exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_YYYYMMDD_HHMMSS_UTC

git diff --check
```

If an HTML visualization is exported, validate it with the Phase 03.1 viewer
validator and inspect a screenshot before accepting the package.
