# T62 Fused RTL-Native Audit Commands

## Package

```bash
uv run python scripts/package_fused_rtl_native_bd_audit.py \
  --sog-features docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T15_masterrtl_sog_bd/tables/sog_features.csv \
  --timing-features docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T61_rtl_timer_problem_local_bd/tables/rtl_timer_features.csv \
  --ppa-completeness docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T15_masterrtl_sog_bd/tables/ppa_completeness.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T62_fused_rtl_native_bd
```

Output summary:

```text
feature_schema_sha256=c01a648df36ec14f19834df203904044767ea32177d904e4dc3deb3d0c4f8c89
candidate_count=670
profiles=operator_timing,state_pipeline,complexity_entropy
best_profile=operator_timing
```

## Validation

```bash
uv run pytest tests/scripts/test_package_fused_rtl_native_bd_audit.py
uv run ruff check scripts/package_fused_rtl_native_bd_audit.py tests/scripts/test_package_fused_rtl_native_bd_audit.py
uv tool run ty check scripts/package_fused_rtl_native_bd_audit.py tests/scripts/test_package_fused_rtl_native_bd_audit.py
uv run pyright scripts/package_fused_rtl_native_bd_audit.py tests/scripts/test_package_fused_rtl_native_bd_audit.py
git diff --check
```
