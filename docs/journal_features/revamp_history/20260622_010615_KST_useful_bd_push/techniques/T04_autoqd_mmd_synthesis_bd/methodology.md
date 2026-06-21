# AutoQD MMD Synthesis BD Methodology

## Intent

Adapt AutoQD-style automatic descriptors to RTL by building random-feature
embeddings over non-PPA synthesis observations. The descriptor should discover
behavior axes without hand-picking the final two grid coordinates.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Non-PPA synthesis/event vectors from Yosys stage stats, motifs, pathlets, or
  operator provenance.
- A baseline corpus from prior runs and replay candidates.

Descriptor fitting excludes final PPA, reference PPA, fitness, hypervolume,
Pareto labels, and test pass outcomes.

## Preprocessing

1. Build a high-dimensional observation vector from stable structural and
   synthesis-transition features.
2. Robust-scale each feature using the baseline corpus.
3. Drop features with zero variance or missing values by assertion-backed
   schema checks.
4. Freeze the feature schema before live sampling.

## Descriptor

Approximate a Gaussian kernel over observation vectors with random Fourier
features:

1. sample `D` random frequencies from the fitted covariance scale;
2. compute cosine/sine features for each candidate;
3. estimate archive occupancy novelty using the distance between candidate
   features and occupied-cell summaries;
4. optionally score distributional spread by maximum mean discrepancy (MMD)
   against the classic baseline corpus.

The descriptor coordinates are the first two to eight fixed random-feature
axes or a frozen PCA projection over the random-feature matrix. Keep random
seeds in the manifest.

## Current Replay Scope

The completed `T04` package evaluates the historical `sr_rff_pca_qd` arm from
the 20260618 Auto-BD run. It is the random Fourier feature kernel-control arm
of the synthesis-response PCA family:

- raw feature schema: `synthesis_response_raw_v1`;
- descriptor version: `sr_rff_pca_v1`;
- training corpus: 205 valid candidates from the seed-1 ST-NOD development
  replay;
- random feature map: 128 RFF dimensions with seed `20260618`;
- archive used in the replay: grid-quantile over frozen PCA coordinates
  derived from the RFF-transformed synthesis-response feature matrix.

This package should be interpreted as an AutoQD-style automatic descriptor
diagnostic rather than a full MMD optimizer. The RFF map approximates a kernel
over implementation-response observations; MMD remains an analysis motivation,
not an in-loop objective or PPA proxy.

## Archive Mapping

Run a small sweep over:

- 2D grid using frozen random-feature PCA axes;
- CVT over 8, 16, and 32 random-feature dimensions.

The method is accepted for deeper live sampling only if replay diagnostics show
`T1 near_classic` or better under duplicate and validity accounting.

## Parent Selection Coupling

Use archive occupancy and replacement exactly as configured in the common QD
run. MMD may be reported as an analysis metric, but it must not replace PPA
fitness unless a separate ablation is recorded.

## Expected Outputs

- `tables/random_feature_schema.csv`
- `tables/mmd_diagnostics.csv`
- `figures/mmd_vs_hypervolume.png`
- `figures/random_feature_archive.png`
