# T33 Tables

T33a source-inventory and T33b preprocessing-view manifest tables are
committed. They are setup evidence only, not embedding, replay, or PPA results.

Current tables:

- `t33_source_inventory.csv`: source paths, roles, bytes, and SHA256 hashes for
  the live prior Qwen directory plus the committed 20260621 Qwen bundle.
- `t33_prior_qwen_summary.csv`: key T06 source facts used to define the T33
  ladder and nuisance-axis gates.
- `t33_preprocessing_ladder_plan.csv`: the six planned preprocessing views,
  primary pooling rule, descriptor candidates, and leakage exclusions.
- `t33_preprocessing_cache_manifest.csv`: source candidate hash, ignored output
  root, candidate count, and generated view count.
- `t33_preprocessing_view_manifest.csv`: one row per generated candidate/view
  file with source path, output path, byte-scale counts, and SHA256.
- `t33_preprocessing_view_summary.csv`: compact size summary per view.

Required tables after the first run:

- `t33_embedding_cache_manifest.csv`
- `t33_pooling_ablation.csv`
- `t33_collapse_diagnostics.csv`
- `t33_nuisance_axis_diagnostics.csv`
- `t33_replay_aggregate.csv`
- `t33_qwen_ladder_vs_controls.csv`
- `t33_ppa_front_metrics.csv`

Tables must include enough raw ids and hashes to regenerate all reported
figures and replay scores.
