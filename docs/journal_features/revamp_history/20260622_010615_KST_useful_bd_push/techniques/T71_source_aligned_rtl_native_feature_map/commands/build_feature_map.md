# T71 Build Command

Storage check before building:

```bash
df -h /workspace
df -ih /workspace
```

Observed state on 2026-06-23:

```text
/workspace: 27T total, 23T used, 3.5T available, 87% used
/workspace inodes: 2.7G total, 62M used, 2.6G free, 3% used
```

Regenerate the T71 tables and figures:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T71_source_aligned_rtl_native_feature_map/tools/build_t71_feature_map.py
```

Validation commands used for this package:

```bash
uv run ruff check docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T71_source_aligned_rtl_native_feature_map/tools/build_t71_feature_map.py
uv run python -m pyright docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T71_source_aligned_rtl_native_feature_map/tools/build_t71_feature_map.py
uv tool run ty check docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T71_source_aligned_rtl_native_feature_map/tools/build_t71_feature_map.py
python3 -m json.tool docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T71_source_aligned_rtl_native_feature_map/tables/t71_metrics.json
git diff --check
```
