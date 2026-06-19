# VQ Implementation Codebook QD

## 1. Motivation

The fixed ST-NOD and projected SR-PCA variants are stable but have not
met the seed-3 final-method bar. This method tests a simple VQ-Elites
style adaptation: learn a discrete codebook over hardware-native
synthesis-response vectors, then use a fixed centroid layout as the
MAP-Elites descriptor.

## 2. Core Idea

```text
RTL candidate
normal test/synthesis/PPA path
PPA-free synthesis-response raw vector
frozen scaler
nearest frozen VQ centroid
centroid PCA-layout coordinates
MAP-Elites archive insertion
```

The behavior descriptor is the assigned codebook region, not PPA,
fitness, or benchmark identity.

## 3. Input Artifacts

- Final synthesized netlist: final cell/motif observations.
- ST-NOD stage dumps: trajectory swings, stage motif ratios, and stage
  cell-count deltas.
- OpenROAD artifacts: PPA objective only, never descriptor input.

Forbidden direct inputs:

- PPA
- fitness
- hypervolume
- reference/golden PPA
- testbench pass percentage
- problem ID

## 4. Descriptor Extraction Algorithm

```text
z = (raw_features - mean_train) / std_train
cluster = nearest_centroid(z)
bd = centroid_layout[cluster][0:3]
```

The first implementation uses 16 centroids and a 3D PCA layout fitted on
the centroids. Each codebook region records its most enriched raw-feature
axes so the regions can be inspected and labeled.

## 5. Fitting Protocol

- Fitting kind: fixed offline.
- Training data: predeclared development/warmup candidates only.
- Excluded data: held-out problems, main-screening candidates, and final
  evaluation candidates.
- Frozen hashes: feature schema, scaler, codebook, centroid layout, and
  descriptor.
- Rebinning: none during a fixed run.

Hard rule: post-hoc codebooks fitted after seeing evaluation candidates
are visualization only and cannot be claimed as in-loop behavior
descriptors.

## 6. Archive Integration

- Archive type: `grid_quantile`.
- Descriptor profile: `sr_vq_3d`.
- Cell mode: `pareto_front`.
- Objectives: PPA.
- Parent selection: `nsga2_global_rank`.

## 7. Implementation Status

Implemented:

- Frozen SR-VQ artifact type and deterministic codebook fitting.
- Runtime descriptor extraction through the existing synthesis-response
  path.
- Descriptor profile and method config.
- Development-seed fitting artifact.

Pending:

- Run seed-1 development sanity check.
- Generate report and accept/reject decision.

Frozen fitting artifact:

- artifact:
  `fitting_artifacts/sr_vq_codebook_dev_seed1001/sr_vq_codebook_artifact.json`
- source data:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`
- training candidates: 205 valid development candidates
- descriptor version: `sr_vq_codebook_v1`
- codebook size: 16
- k-means seed: `20260618`
- feature schema hash:
  `505c9fb648a6a2bd2dadca0e8f1ed30de567bd00df4d72fef2ec385ece47421a`
- scaler hash:
  `4d2b9bbe7cfb8841e11ead36c893f092693ddccc5e624312f1036687c927d5cf`
- codebook hash:
  `393ade44dc56ed7e99cdf563610c270ebc1619741183c2a1c7fb5655c828aa35`
- layout hash:
  `f7d9fe786f7c8e63a356f016f402750ced332bd212cb4472a1e8cd46bf6b407c`
- descriptor hash:
  `a1d9cf5abe52c98e432b35b684261429583dc6f9fed00452b4b633159e54d54b`

## 8. Acceptance Rule

Promote only if seed-1 passes Gate 0, avoids robustness regression, and
shows a practical PPA or diversity signal that justifies seed-3 compute.
If it only fragments the archive without PPA or common-audit value, reject
as a codebook ablation.
