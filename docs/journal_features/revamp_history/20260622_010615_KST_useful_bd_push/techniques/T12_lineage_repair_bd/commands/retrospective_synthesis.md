# T12 Retrospective Synthesis Commands

No new live LLM run was launched for T12. The package reuses measured lineage
and repair-emitter evidence from T31, T49, T51, and T59.

```bash
cp docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T31_sr_raw_fail_feedback_repair_qd/figures/t31_holdout_live_aggregate.png \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T12_lineage_repair_bd/figures/t12_t31_holdout_live_aggregate.png

cp docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T49_thought_k_role_separated_repair_qd/hard_tuning_package/figures/t49_metric_delta_summary.png \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T12_lineage_repair_bd/figures/t12_t49_metric_delta_summary.png

cp docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T51_code_thought_front_slot_qd/hard_tuning_package/figures/t51_metric_delta_summary.png \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T12_lineage_repair_bd/figures/t12_t51_metric_delta_summary.png

cp docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T59_t51_feedback_front_slot_qd/hard_tuning_package/figures/t59_metric_delta_summary.png \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T12_lineage_repair_bd/figures/t12_t59_metric_delta_summary.png
```

Validation:

```bash
cd docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push
sha256sum -c techniques/T12_lineage_repair_bd/tables/t12_source_hashes.sha256
git diff --check
```
