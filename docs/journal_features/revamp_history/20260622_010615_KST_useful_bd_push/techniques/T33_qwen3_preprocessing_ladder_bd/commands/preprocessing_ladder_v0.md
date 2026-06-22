# T33 Preprocessing Ladder Commands

Status: planned command contract. Fill exact script paths after implementation.

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

```bash
uv run python scripts/run_qwen3_preprocessing_ladder.py \
  --source exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC \
  --output exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_YYYYMMDD_HHMMSS_UTC
```

The eventual script should generate all six preprocessing views, embedding
manifests, collapse diagnostics, replay tables, and raw PPA-front figures. It
must not read PPA fields until the evaluation stage.

## Required Post-Run Checks

```bash
uv run python scripts/package_t33_qwen3_preprocessing_ladder.py \
  --run-root exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_YYYYMMDD_HHMMSS_UTC

git diff --check
```

If an HTML visualization is exported, validate it with the Phase 03.1 viewer
validator and inspect a screenshot before accepting the package.
