# VQ-Elites Codebook BD Methodology

## Intent

Use a codebook over structural implementation vectors as the BD archive. This
tests whether vector-quantized behavior cells are easier to populate than
hand-chosen grids while still avoiding PPA leakage.

## Inputs

- Candidate RTL and fixed benchmark metadata.
- Non-PPA feature vectors from Yosys stats, motifs, pathlets, stage deltas, or
  Qwen/graph embeddings after leakage checks.
- Frozen baseline and replay corpus for codebook fitting.

Do not use final PPA, reference PPA, fitness, hypervolume, Pareto labels, or
test pass labels for codebook fitting.

## Preprocessing

1. Build a candidate feature matrix with one row per unique canonical netlist.
2. Robust-scale features within benchmark.
3. Fit MiniBatchKMeans, FAISS k-means, or a small VQ model on the baseline
   corpus only.
4. Store codebook centroids, feature schema, and scaling parameters.
5. Assign duplicate netlists to the same canonical row for reporting.

## Descriptor

Each candidate is mapped to:

- nearest codebook id;
- residual norm to the centroid;
- optional residual direction from the first two frozen residual-PCA axes;
- codebook occupancy count and entropy for analysis only.

For a 2D grid, use codebook id bucketed on one axis and residual norm bucketed
on the other. For CVT-style archives, use centroid coordinates and residual
features directly.

## Current Replay Scope

The completed `T05` package evaluates the historical `sr_vq_codebook_qd` arm
from the 20260618 Auto-BD run. It is the fixed VQ-Elites-style codebook arm of
the synthesis-response family:

- descriptor version: `sr_vq_codebook_v1`;
- training corpus: 205 valid candidates from the seed-1 ST-NOD development
  replay;
- codebook size: 16 centroids;
- k-means seed: `20260618`;
- archive used in the replay: grid-quantile over fixed centroid-layout
  coordinates from the frozen codebook artifact.

This package evaluates the codebook as an in-loop descriptor, not as a
post-hoc visualization. The codebook fitting excludes final PPA, reference
PPA, fitness, hypervolume, Pareto labels, and test outcomes.

## Archive Mapping

Evaluate codebook sizes 16, 32, 64, and 128 only if data volume supports them.
Reject codebooks where most cells are empty in baseline replay or where a few
duplicate families dominate occupancy.

## Parent Selection Coupling

Parent sampling may prefer underfilled codebook cells, but replacement remains
quality based. Codebook novelty alone is not an optimization claim.

## Expected Outputs

- `tables/codebook_centroids.csv`
- `tables/codebook_assignment.csv`
- `tables/duplicate_by_code.csv`
- `figures/codebook_occupancy.png`
- `figures/residual_norm_vs_ppa.png`
