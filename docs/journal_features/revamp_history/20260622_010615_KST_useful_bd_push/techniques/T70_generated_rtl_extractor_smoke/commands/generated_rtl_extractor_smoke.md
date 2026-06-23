# T70 Generated RTL Extractor Smoke Commands

All commands were run from `/workspace`.

## Storage Check

```bash
df -h /workspace /tmp /
df -ih /workspace
```

Observed `/workspace`: `27T` total, `23T` used, `3.5T` available, `87%`
used. The T70 local output directory is about `6.7M`.

## Run Smoke

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T70_generated_rtl_extractor_smoke/tools/run_t70_extractor_smoke.py
```

The runner rewrites:

`exp/verification/t70_generated_rtl_extractor_smoke`

It also regenerates:

- `tables/t70_candidate_manifest.csv`
- `tables/t70_extractor_results.csv`
- `tables/t70_extractor_summary.csv`
- `tables/t70_extractor_metrics.json`
- `figures/t70_generated_rtl_extractor_smoke.png`
- `figures/t70_extractor_richness_by_candidate.png`

## Validation Commands

```bash
uv run ruff check docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T70_generated_rtl_extractor_smoke/tools/run_t70_extractor_smoke.py

uv run python -m pyright docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T70_generated_rtl_extractor_smoke/tools/run_t70_extractor_smoke.py

uv tool run ty check docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T70_generated_rtl_extractor_smoke/tools/run_t70_extractor_smoke.py

python3 -m json.tool docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T70_generated_rtl_extractor_smoke/tables/t70_extractor_metrics.json

git diff --check
```
