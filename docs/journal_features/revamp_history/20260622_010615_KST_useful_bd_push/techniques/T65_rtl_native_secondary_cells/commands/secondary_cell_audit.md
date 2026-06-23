# T65 Secondary-Cell Audit Command

```bash
uv run python scripts/package_t65_secondary_rtl_cells.py \
  --dataset-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T51_code_thought_front_slot_qd/visualizations/qd_ppa_viewer/datasets \
  --dataset-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/visualizations/qd_ppa_viewer/datasets \
  --dataset-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T64_fused_operator_timing_live_screen/visualizations/qd_ppa_viewer/datasets \
  --candidate-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T51_code_thought_front_slot_qd/hard_tuning_package/data/t51_ppa_candidates.csv \
  --candidate-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/hard_tuning_package/data/t63_ppa_candidates.csv \
  --candidate-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T64_fused_operator_timing_live_screen/hard_tuning_package/data/t64_ppa_candidates.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T65_rtl_native_secondary_cells
```

Output:

```text
feature_schema_sha256=2261b8c73a08f92ffdcc787a1855547203d2335e8417591fe6eea66814962da4
candidate_count=321
profiles=timing_risk,operator_timing,control_pipeline
best_profile=control_pipeline
output_dir=docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T65_rtl_native_secondary_cells
```
