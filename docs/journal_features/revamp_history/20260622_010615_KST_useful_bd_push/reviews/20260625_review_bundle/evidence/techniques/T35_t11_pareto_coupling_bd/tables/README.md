# Tables

Primary result tables:

- `archive_comparison.csv`: replay aggregate metrics joined with raw
  area-power front metrics and lexical deltas.
- `ppa_comparison.csv`: replay aggregate metrics by representation.
- `ppa_front_metrics.csv`: selected front hits, selected front size, and
  unique PPA counts.
- `ppa_front_plot_points.csv`: raw points used to regenerate the PPA-front
  PNGs and `../visualizations/direct_ppa_pareto/points.json`.
- `selected_candidates.csv`: selected candidate rows for each representation.

Descriptor and diagnostic tables:

- `feature_manifest.csv`: inherited T11 structural feature scores and top-k
  flags.
- `cell_summary.csv`: T11 descriptor-cell occupancy under the T35 cell grid.
- `replay_rows.csv`: per-problem replay rows.
