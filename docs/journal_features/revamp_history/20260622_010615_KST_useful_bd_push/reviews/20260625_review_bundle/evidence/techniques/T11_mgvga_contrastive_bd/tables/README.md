# Tables

Primary result tables:

- `ppa_comparison.csv`: replay aggregate metrics by representation.
- `ppa_front_metrics.csv`: raw area-power front counts, front hits, and unique
  PPA counts.
- `ppa_front_plot_points.csv`: raw points used to regenerate the primary PPA
  front figures and `../visualizations/direct_ppa_pareto/points.json`.
- `selected_candidates.csv`: selected candidate rows for each representation.

Descriptor and diagnostic tables:

- `feature_manifest.csv`: structural feature schema, contrastive scores, and
  top-k selection flags.
- `alignment_coverage.csv`: structural duplicate-key coverage and missing-key
  counts.
- `contrastive_training.csv`: self-supervised positive/negative pair counts
  and score summary.
- `collapse_diagnostics.csv`: nearest-neighbor problem/corpus/netlist/motif
  collapse checks.
- `archive_metrics.csv`: compact deltas versus lexical.
- `replay_rows.csv`: per-problem replay rows.
