# T13 AURORA Autoencoder BD Results Report

Status: completed replay diagnostic.

Tier: mixed. `T1 near_classic_replay_lead` for the implementation-feature
input space; `T0 diagnostic` for the compressed AURORA/PCA/RFF bottlenecks.

## Method Summary

T13 revisits AURORA-style learned behavior descriptors using only
implementation-side structural inputs: RTL count features and the parsed
standard-cell graph features generated for T07. The replay fits frozen
linear-autoencoder/PCA bottlenecks, RFF nonlinear bottlenecks, and an
incremental PCA-4 refresh schedule from structural features only.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto rank, validity labels, problem id, corpus id, model, method, seed, and
candidate id. `tables/feature_manifest.csv` lists the included implementation
features; excluded fields are used only after descriptor selection for scoring
and diagnostics.

## Primary PPA Figures

The primary evidence is direct raw PPA-front geometry:

- `figures/aurora_multi_problem_ppa_pareto_fronts.png` shows four
  representative raw area-power Pareto panels with all-valid, lexical, random,
  and implementation-feature selections.
- `figures/aurora_raw_area_power_pareto_front.png` shows full-range and
  lower-left zoom panels for `Prob018_float_multi`.

The raw plotted points are committed in `tables/ppa_front_plot_points.csv`.

## Setup

- Candidate source:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- Graph feature source:
  `techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv`.
- Candidate rows: 768 total, 682 valid-PPA rows over 114 replay groups.
- Replay budget: keep 50% of candidates per `(corpus, method, seed, problem)`.
- Controls: lexical farthest-first, random, generation-prefix, and fitness-top.

## Results

| Representation | HV | HV Gain Vs Lexical | Pareto Size | Front Hits | Unique PPA |
| --- | ---: | ---: | ---: | ---: | ---: |
| `fitness_top` | 3.823248 | +3.28% | 300 | 122 | 159 |
| `t13_impl_z_farthest` | 3.740943 | +1.06% | 285 | 120 | 186 |
| `lexical_farthest` | 3.701827 | 0.00% | 283 | 122 | 183 |
| `t13_pca4_farthest` | 3.625712 | -2.06% | 287 | 118 | 184 |
| `t13_pca8_farthest` | 3.586182 | -3.12% | 289 | 118 | 185 |
| `t13_pca2_farthest` | 3.543777 | -4.27% | 288 | 116 | 184 |
| `t13_incremental_pca4_farthest` | 3.477730 | -6.05% | 290 | 118 | 182 |
| `t13_rff_pca2_farthest` | 3.491803 | -5.67% | 294 | 116 | 181 |
| `t13_rff_pca4_farthest` | 3.430103 | -7.34% | 292 | 118 | 183 |
| `t13_rff_pca8_farthest` | 3.384424 | -8.57% | 292 | 115 | 181 |
| `random` | 3.074167 | -16.96% | 303 | 107 | 166 |

The useful signal is not the compressed autoencoder bottleneck. The raw
standardized implementation-feature space beats lexical HV by `+1.06%`,
improves unique PPA points from `183` to `186`, and increases selected
area-power front points from `127` to `129`. It does not improve all-valid
front hits: lexical keeps `122`, while implementation features keep `120`.

The AURORA-style compression variants are diagnostic failures for this replay.
PCA, RFF-PCA, and incremental PCA all lose HV versus lexical, even when their
Pareto-size counts increase.

## Collapse Diagnostics

The compression variants reduce nearest-neighbor nuisance collapse more than
the raw implementation-feature space, but this does not convert to PPA utility.
For example, `t13_rff_pca2_farthest` has same-problem fraction `0.548177` and
same-corpus fraction `0.764323`, while losing `5.67%` HV versus lexical.
`t13_impl_z_farthest` keeps a high same-problem fraction (`0.867188`) but is
the only T13 representation with a positive HV delta.

## Visual Inspection

Manual inspection passed for:

- `aurora_multi_problem_ppa_pareto_fronts.png`;
- `aurora_raw_area_power_pareto_front.png`;
- `aurora_hypervolume.png`;
- `aurora_latent_projection.png`;
- `aurora_reconstruction_vs_hv.png`.

Notes are in `figures/visual_inspection_notes.md`.

## Conclusion

T13 does not validate AURORA-style compression as the missing BD. The fitted
PCA/RFF/incremental bottlenecks reduce some collapse metrics but lose HV and do
not improve front hits. The important result is that the uncompressed
implementation-feature vector is a stronger near-classic replay lead than T07:
it beats lexical HV by `+1.06%`, improves unique PPA points, and increases
selected area-power front count.

Next step: do not promote the autoencoder bottleneck. Reuse the
implementation-feature vector as an input to a local-Pareto archive or a
feature-selection/contrastive graph objective that preserves the HV signal
while explicitly improving direct front hits.
