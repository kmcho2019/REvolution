# Methodology

## Question

Can the validated T81 MasterRTL RF timing-state signal run through the live
descriptor registry without changing project-wide dependencies or using PPA
as a descriptor input?

## Implementation

T82 adds one descriptor profile:

```yaml
source_aligned_rf_timing_state_3d:
  - source_aligned_rf_timing_leaf_rows
  - source_aligned_rf_timing_path_count
  - source_aligned_masterrtl_branching
```

The first two axes are RF timing model-state counts transformed with `log1p`
by the descriptor registry. The third axis is the existing source-aligned raw
MasterRTL branching feature.

## Dependency Boundary

The main uv environment does not load the RF pickle. The live evaluator calls
`scripts/extract_masterrtl_rf_timing_metrics.py` through:

`exp/useful_bd_push/envs/masterrtl_rf_timing/bin/python`

That isolated environment is pinned to the sklearn/numpy stack used by T81:

- `scikit-learn==1.3.0`
- `numpy==1.26.4`
- `networkx`
- `joblib`

## Anti-Gaming Boundary

The hook uses only source RTL lowered through Yosys/MasterRTL, upstream
MasterRTL timing-path features, and the saved MasterRTL RF timing model. It
does not use final PPA, reference PPA, fitness, hypervolume, Pareto rank,
functional pass rate, or synthesis pass rate as descriptor inputs.

## No-Path Behavior

Candidates without timing split points receive explicit RF timing metrics:

- path count `0`;
- leaf rows `0`;
- leaf IDs `0`;
- no-path flag `1`.

The current profile does not use the no-path flag as an archive axis, but the
metric is emitted for diagnostics and collapse checks.
