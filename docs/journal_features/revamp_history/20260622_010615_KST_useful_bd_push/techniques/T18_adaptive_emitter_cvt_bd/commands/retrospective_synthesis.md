# T18 Retrospective Synthesis Commands

No new live LLM run was launched for T18. This package reuses measured
evidence from T57 and T32 to avoid spending on a method whose two main
ingredients already failed promotion gates.

```bash
cp \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T57_t51_adaptive_rebin_qd/hard_tuning_package/figures/t57_rebinning_counters.png \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T18_adaptive_emitter_cvt_bd/figures/t18_t57_rebinning_counters.png

cp \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T32_sr_raw_front_preserving_emitter_qd/figures/t32_holdout_live_aggregate.png \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T18_adaptive_emitter_cvt_bd/figures/t18_t32_holdout_live_aggregate.png

cp \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T57_t51_adaptive_rebin_qd/hard_tuning_package/tables/t57_rebinning_counters.csv \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T18_adaptive_emitter_cvt_bd/tables/t18_t57_rebinning_counters.csv

sha256sum \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T57_t51_adaptive_rebin_qd/results_report.md \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T32_sr_raw_front_preserving_emitter_qd/results_report.md \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T18_adaptive_emitter_cvt_bd/figures/t18_t57_rebinning_counters.png \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T18_adaptive_emitter_cvt_bd/figures/t18_t32_holdout_live_aggregate.png \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T18_adaptive_emitter_cvt_bd/tables/t18_t57_rebinning_counters.csv
```

Validation:

```bash
git diff --check
```
