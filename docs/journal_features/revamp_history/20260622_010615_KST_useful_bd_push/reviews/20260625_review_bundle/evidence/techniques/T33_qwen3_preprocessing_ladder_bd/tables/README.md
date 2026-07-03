# T33 Tables

T33a source-inventory, T33b preprocessing-view, T33c embedding-cache, T33d
collapse-diagnostic, and T33e replay/PPA-front tables are committed.

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
- `t33_replay_rows.csv`: per-problem replay metrics for lexical, random,
  generation-prefix, fitness-top, and six T33 Qwen descriptor selections.
- `t33_replay_aggregate.csv`: aggregate selected-HV, Pareto-size, best-fitness,
  and duplicate-accounting metrics by representation.
- `t33_selected_candidates.csv`: selected candidate ids and PPA/hash fields used
  to regenerate direct PPA-front accounting.
- `t33_ppa_front_metrics.csv`: direct area-power front counts, all-valid front
  hits, and unique PPA counts by representation.
- `t33_qwen_ladder_vs_controls.csv`: long-form deltas versus lexical and random
  controls for the primary replay metrics.

Tables must include enough raw ids and hashes to regenerate all reported
figures and replay scores.
