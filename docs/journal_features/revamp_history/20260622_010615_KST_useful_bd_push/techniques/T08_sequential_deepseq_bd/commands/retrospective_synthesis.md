# T08 Retrospective Synthesis Commands

No new live vLLM run was launched for T08. This package closes the original
DeepSeq-style scaffold using measured RTL-native sequential proxy evidence
from T63, T67, T72, T73, and T75.

The source reports were inspected with:

```bash
sed -n '1,220p' \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T63_fused_rtl_native_live_screen/results_report.md
sed -n '1,220p' \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T67_rtl_native_seeded_thought_qd/results_report.md
sed -n '1,220p' \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T72_source_aligned_rtl_cell_qd/results_report.md
sed -n '1,220p' \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T73_source_aligned_shape_density_qd/results_report.md
sed -n '1,220p' \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T75_shape_density_front_pressure_qd/results_report.md
```

The copied evidence figures are source-controlled derivatives of the existing
method packages:

```bash
cp .../T63_fused_rtl_native_live_screen/hard_tuning_package/figures/t63_metric_delta_summary.png \
  .../T08_sequential_deepseq_bd/figures/t08_t63_state_pipeline_metric_delta.png
cp .../T67_rtl_native_seeded_thought_qd/hard_tuning_package/figures/t67_metric_delta_summary.png \
  .../T08_sequential_deepseq_bd/figures/t08_t67_seeded_thought_metric_delta.png
cp .../T73_source_aligned_shape_density_qd/figures/t73_descriptor_occupancy_audit.png \
  .../T08_sequential_deepseq_bd/figures/t08_t73_shape_density_occupancy.png
cp .../T75_shape_density_front_pressure_qd/matched_classic_comparison/figures/t75_hv_delta_by_problem.png \
  .../T08_sequential_deepseq_bd/figures/t08_t75_hv_delta_by_problem.png
```

Hash validation:

```bash
sha256sum -c \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T08_sequential_deepseq_bd/tables/t08_source_hashes.sha256
```
