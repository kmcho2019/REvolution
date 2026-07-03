# Tables

Primary result tables:

- `ppa_comparison.csv`: replay aggregate metrics by representation.
- `ppa_front_metrics.csv`: raw area-power front counts, front hits, and unique
  PPA counts.
- `ppa_front_plot_points.csv`: raw points used to regenerate the primary PPA
  front figures.
- `selected_candidates.csv`: selected candidate rows for each representation.

Descriptor and diagnostic tables:

- `feature_manifest.csv`: descriptor input schema; no PPA, fitness, validity,
  problem, corpus, model, method, seed, or candidate-id fields are used.
- `split_manifest.csv`: stable train/validation/holdout split by problem.
- `autoencoder_training.csv`: PCA/RFF/incremental training diagnostics.
- `latent_diagnostics.csv`: pairwise and graph-size diagnostics.
- `collapse_diagnostics.csv`: nearest-neighbor problem/corpus/netlist/motif
  collapse checks.
- `archive_metrics.csv`: compact deltas versus lexical.
- `replay_rows.csv`: per-problem replay rows.
