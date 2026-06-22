# T33 Tables

T33a source-inventory, T33b preprocessing-view, T33c embedding-cache, and T33d
collapse-diagnostic tables are committed. They are not replay or PPA results.

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
- `t33_embedding_cache_manifest.csv`: one row per view with Qwen model id,
  matrix shape, chunk count, output path, SHA256, and encode seconds.
- `t33_embedding_chunk_summary.csv`: chunk counts and chunk-size summaries per
  view.
- `t33_collapse_diagnostics.csv`: per-view nearest-neighbor collapse metrics
  and deltas versus T06.
- `t33_nearest_neighbors.csv`: one row per candidate/view nearest-neighbor
  pair with same-problem/corpus/hash/style flags.
- `t33_view_stability.csv`: pairwise cosine stability between preprocessing
  views for the same candidate.

Required tables after the first run:

- `t33_nuisance_axis_diagnostics.csv`
- `t33_replay_aggregate.csv`
- `t33_qwen_ladder_vs_controls.csv`
- `t33_ppa_front_metrics.csv`

Tables must include enough raw ids and hashes to regenerate all reported
figures and replay scores.
