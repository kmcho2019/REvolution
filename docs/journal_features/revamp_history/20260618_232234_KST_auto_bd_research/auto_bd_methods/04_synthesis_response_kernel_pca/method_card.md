# Synthesis-Response Kernel PCA QD

## 1. Motivation

The current tested Auto-BD methods are useful controls, but they still
use fixed hand-designed descriptor axes. This method tests a genuinely
AutoQD-inspired direction: learn the behavior space from hardware-native
synthesis responses while keeping PPA, fitness, and benchmark identity
out of the descriptor.

## 2. Core Idea

Describe each RTL candidate by a frozen projection of synthesis-response
features:

```text
RTL candidate
normal test/synthesis/PPA path
hardware-native raw feature vector
frozen scaler
fixed random nonlinear feature map
frozen PCA / whitening
MAP-Elites descriptor
```

The paper-facing idea is Synthesis-Response Kernel MAP-Elites: learn
descriptor axes from how Yosys transforms RTL, not from PPA labels or
arbitrary manual depth/count choices.

## 3. Input Artifacts

- RTL source: normal candidate source and ST-NOD sidecar source.
- Yosys JSON/netlist: final synthesis statistics and motif occupancy.
- Synthesis-stage dumps: ST-NOD stage snapshots, motif ratios, and
  per-stage cell-count deltas.
- OpenROAD artifacts: PPA objective only, never descriptor input.
- Other: optional cheap graph/pathlet stats only after the base vector is
  stable.

Forbidden direct inputs:

- PPA
- fitness
- hypervolume
- reference/golden PPA
- testbench pass percentage
- problem ID

## 4. Descriptor Extraction Algorithm

Planned raw feature vector:

```text
raw_features(candidate) =
    final Yosys stats
  + final motif occupancy
  + ST-NOD trajectory swings
  + per-stage motif ratios
  + per-stage cell-count deltas
```

Planned transform:

```text
z = (raw_features - mean_train) / std_train
h = relu(Wz + b)                 # sr_random_relu_pca_qd
bd = pca_k(h)
```

Controls:

- `sr_raw_pca_qd`: PCA on standardized raw synthesis-response features.
- `sr_rff_pca_qd`: random Fourier features before PCA.
- `sr_vq_codebook_qd`: codebook variant only after PCA variants are
  understood.
- `sr_contrastive_encoder_qd`: later neural/self-supervised variant only
  if simpler projected methods fail.

## 5. Descriptor Fitting Protocol

- Fitting kind: fixed offline.
- Training data: predeclared development or warmup candidates only.
- Validity filters: must be declared before fitting; held-out problems and
  final evaluation candidates are excluded.
- Frozen artifact hashes: feature schema hash, scaler hash, random-map
  hash, PCA component hash, and descriptor version.
- Rebinning policy: none during a fixed run; descriptors must be
  available at candidate insertion time.

Hard rule: if PCA or the random feature map is fitted after seeing the
full evaluation run, it is post-hoc visualization only and cannot be
claimed as the in-loop behavior descriptor.

Every candidate must log:

- `raw_feature_schema_version`
- `scaler_hash`
- `random_feature_map_hash`
- `pca_hash`
- `descriptor_version`
- `descriptor_vector`

## 6. Archive Integration

- Archive type: `grid_quantile`
- Internal descriptor dimensions: start with 3, allow 5 only as a
  predeclared ablation.
- Internal binning/cell policy: same grid-quantile/Pareto cell policy as
  landing Smooth-QD manual-BD.
- Common audit descriptor: required for all cross-method QD claims.
- Common audit binning: fixed by the centralized report.

## 7. Hyperparameters

First setting:

- Raw features: final stats, motif occupancy, ST-NOD trajectory, per-stage
  motif ratios, and per-stage cell-count deltas.
- Random features: 128 ReLU features for the main candidate.
- PCA dimensions: 3.
- Archive: `grid_quantile`.
- Cell mode: `pareto_front`.
- Objectives: PPA.

## 8. Expected Advantage

Manual BDs are low-capacity and weakly justified. Final-netlist
descriptors miss synthesis response. ST-NOD captures response but still
hand-picks axes. A fixed random nonlinear map plus PCA can approximate a
broader kernel over CAD-native behavior while staying simple, reproducible,
and free of PPA leakage.

## 9. Risks

- PCA may mostly rediscover cell count or benchmark identity.
- A post-hoc fit could create attractive but invalid plots.
- Fitting artifacts may be hard to reproduce if training data is not
  logged precisely.
- Extra modes could make descriptor plumbing messy if not isolated.
- Learned axes may be less interpretable than ST-NOD unless archive
  regions have motif/PPA-neutral explanations.

## 10. Implementation Status

Runtime-ready, not evaluated.

Implemented:

- PPA-free raw synthesis-response feature extraction.
- Fixed offline PCA fitting artifact builder.
- Development-seed fitting artifact for `sr_raw_pca_qd`.
- In-loop archive insertion with `sr_pca_0..2` descriptor axes.
- Run-matrix arm generation for `sr_raw_pca_qd`.

Not implemented:

- Random ReLU or random Fourier feature expansion.
- Seed-1/seed-3 SR-PCA evolution runs.

## 11. Experimental Setup

- Benchmark subset: start on the locked development/warmup data used to
  fit artifacts; evaluate only after artifacts are frozen.
- Seeds: seed-1 sanity, seed-3 screening, seed-5 final only if promoted.
- Model and endpoint: `openai/gpt-oss-120b` at
  `http://20.0.0.103:8000/v1`.
- Evaluation budget: follow `auto_bd_run_policy_lock.yaml`.
- Worker/thread policy: follow `auto_bd_run_policy_lock.yaml`.
- Synthesis/OpenROAD settings: same as landing Smooth-QD manual-BD.

## 12. Results

No SR-PCA evolution runs yet.

Frozen development fitting artifact:

- artifact:
  `fitting_artifacts/sr_raw_pca_dev_seed1001/sr_raw_pca_artifact.json`
- source data:
  `exp/auto_bd_research/development_preliminary_seed1/synthesis_trajectory_nod/seed_1001/standard_results`
- training candidates: 205 valid development candidates
- raw feature schema: `synthesis_response_raw_v1`
- descriptor version: `sr_raw_pca_v1`
- feature schema hash:
  `505c9fb648a6a2bd2dadca0e8f1ed30de567bd00df4d72fef2ec385ece47421a`
- scaler hash:
  `4d2b9bbe7cfb8841e11ead36c893f092693ddccc5e624312f1036687c927d5cf`
- PCA hash:
  `ef2bd4ee1d8532fb765a002aee01fc10d78bd88ce9f77ad8bf3afe722d127257`
- descriptor hash:
  `931edf18e9ec5e3a7b2b8d7996c603c64ec82619f6185ea44cf4803e6105ee1b`
- explained variance ratio:
  `[0.437099552626324, 0.22443819250404728, 0.1833523891094817]`

Required plots:

- fitness anytime curve
- strict HV anytime curve
- `ANHV@1.5` anytime curve
- per-problem Pareto fronts with method overlays
- PPA-front unique netlist count by method
- common-audit descriptor occupancy heatmap
- learned-BD scatter colored by area, power, timing, and fitness
- descriptor-axis correlations with PPA metrics
- problem-seed paired delta plot versus classic REvolution
- representative elites per learned-BD region

## 13. Accept / Reject Decision

Not evaluated.

## 14. Reason

The method cannot be accepted until it passes Gate 0, preserves repair
robustness, improves PPA/HV or diversity under common-audit reporting,
and proves the descriptor was fitted only from allowed data.
