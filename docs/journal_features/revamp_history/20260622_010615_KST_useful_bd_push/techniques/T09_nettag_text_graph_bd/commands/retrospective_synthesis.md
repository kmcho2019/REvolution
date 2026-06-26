# T09 Retrospective Synthesis Commands

No new live vLLM run was launched for T09. This package closes the NetTAG-style
text-graph scaffold using measured Qwen text/netlist, T11/T36 graph, T58 live
graph-coordinate, and T96 RF/DeepGate hybrid evidence.

Source reports inspected:

```bash
sed -n '1,220p' \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T33_qwen3_preprocessing_ladder_bd/results_report.md
sed -n '1,220p' \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T36_t11_bounded_front_lane_bd/results_report.md
sed -n '1,220p' \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T58_t51_t11_pca4_front_slot_qd/results_report.md
sed -n '1,190p' \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/results_report.md
```

Copied evidence figures:

```bash
cp .../T33_qwen3_preprocessing_ladder_bd/figures/t33_hypervolume_by_view.png \
  .../T09_nettag_text_graph_bd/figures/t09_t33_qwen_hypervolume_by_view.png
cp .../T33_qwen3_preprocessing_ladder_bd/figures/t33_duplicate_and_motif_counts.png \
  .../T09_nettag_text_graph_bd/figures/t09_t33_duplicate_motif_counts.png
cp .../T36_t11_bounded_front_lane_bd/figures/t36_hypervolume.png \
  .../T09_nettag_text_graph_bd/figures/t09_t36_graph_hypervolume.png
cp .../T58_t51_t11_pca4_front_slot_qd/hard_tuning_package/figures/t58_metric_delta_summary.png \
  .../T09_nettag_text_graph_bd/figures/t09_t58_live_graph_metric_delta.png
```

Hash validation:

```bash
sha256sum -c \
  docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T09_nettag_text_graph_bd/tables/t09_source_hashes.sha256
```
