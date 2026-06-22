# T33 Tables

T33a source-inventory tables are committed. They are setup evidence only, not
embedding, replay, or PPA results.

Current tables:

- `t33_source_inventory.csv`: source paths, roles, bytes, and SHA256 hashes for
  the live prior Qwen directory plus the committed 20260621 Qwen bundle.
- `t33_prior_qwen_summary.csv`: key T06 source facts used to define the T33
  ladder and nuisance-axis gates.
- `t33_preprocessing_ladder_plan.csv`: the six planned preprocessing views,
  primary pooling rule, descriptor candidates, and leakage exclusions.

Required tables after the first run:

- `preprocessing_view_manifest.csv`
- `embedding_cache_manifest.csv`
- `pooling_ablation.csv`
- `collapse_diagnostics.csv`
- `nuisance_axis_diagnostics.csv`
- `replay_aggregate.csv`
- `qwen_ladder_vs_controls.csv`
- `ppa_front_metrics.csv`

Tables must include enough raw ids and hashes to regenerate all reported
figures and replay scores.
