# AURORA Incremental Autoencoder BD Methodology

## Intent

Revisit AURORA-style learned behavior descriptors with stricter controls than
the prior linear autoencoder diagnostic. The method should learn behavior axes
from implementation-only vectors and update them at fixed checkpoints without
moving the target after seeing PPA outcomes.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Non-PPA implementation vectors: Yosys stats, motifs, stage deltas, SOG
  features, fixed functional sketches, and lineage-independent graph summaries.
- Frozen train/validation/holdout split by problem and source model.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and functional pass/fail labels.

## Preprocessing

1. Build one feature row per unique canonical netlist.
2. Robust-scale features with train split statistics.
3. Keep schema and split manifests frozen before fitting.
4. Record missing features as validity/reporting fields, not silent zeros.

## Descriptor

Train three variants:

- frozen linear autoencoder or PCA baseline;
- shallow nonlinear autoencoder with 2D, 4D, and 8D bottlenecks;
- incremental AURORA-style autoencoder refit at pre-registered evaluation
  milestones using only candidates generated up to that milestone.

For incremental variants, archive coordinates for already-generated candidates
must be recomputed only at registered refresh points. Keep a stable passive
archive so moving coordinates do not inflate coverage claims.

## Archive Mapping

Use the bottleneck coordinates directly for 2D grid runs. Use CVT for 4D/8D
latents. Always report a passive archive with frozen coordinates for fair
comparison against classic and non-incremental variants.

## Collapse And Leakage Checks

Report latent variance, pairwise distance histograms, reconstruction error,
duplicate-netlist alignment, graph-size correlation, identifier sensitivity if
text features are present, and holdout metric deltas.

## Expected Outputs

- `tables/autoencoder_training.csv`
- `tables/latent_diagnostics.csv`
- `tables/archive_metrics.csv`
- `tables/ppa_comparison.csv`
- `tables/ppa_front_metrics.csv`
- `tables/ppa_front_plot_points.csv`
- `figures/aurora_multi_problem_ppa_pareto_fronts.png`
- `figures/aurora_raw_area_power_pareto_front.png`
- `figures/aurora_latent_projection.png`
- `figures/aurora_reconstruction_vs_hv.png`

## Completed Replay Route

The completed bounded replay uses the T07 parsed graph manifest plus RTL count
features as implementation-only inputs. It fits frozen PCA bottlenecks,
RFF-PCA nonlinear bottlenecks, and an incremental PCA-4 refresh schedule using
stable problem splits. PPA, fitness, validity labels, problem id, corpus,
model, method, seed, and candidate id are excluded from descriptor fitting and
recorded in `tables/feature_manifest.csv` as forbidden inputs.

Generated primary artifacts:

- `tables/feature_manifest.csv`;
- `tables/autoencoder_training.csv`;
- `tables/ppa_comparison.csv`;
- `tables/ppa_front_metrics.csv`;
- `tables/ppa_front_plot_points.csv`;
- `figures/aurora_multi_problem_ppa_pareto_fronts.png`;
- `figures/aurora_raw_area_power_pareto_front.png`.

The completed result distinguishes the raw implementation-feature input space
from the compressed bottlenecks. The input space is a near-classic replay lead;
the compressed AURORA-style bottlenecks are diagnostic failures on HV.
