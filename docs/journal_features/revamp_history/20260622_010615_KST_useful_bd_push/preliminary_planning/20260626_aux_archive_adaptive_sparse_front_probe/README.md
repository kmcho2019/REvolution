# Auxiliary Archive Adaptive Sparse-Front Probe

Status: preregistered.

This package tests the next QD candidate after fixed high-exploit auxiliary
archive failed seed replication. It keeps the same MasterRTL structural archive
descriptor, but uses the existing adaptive sparse-front parent selector:

- normal state: sample from global NSGA-II rank with a `0.90` champion lane;
- sparse-front state: cap the champion lane at `0.65` only when local archive
  fronts are thin.

## Decision

This is the next live QD gate before any full RTLLM spend. It should only be
promoted if it clearly improves the frozen eight-design screen versus the
matched seed `1001` classic baseline and does not rely on
`Prob135_m2014_q6b`.

## Files

- `preregistration.md`: frozen setup, metrics, and decision rule.
- `commands/run_adaptive_sparse_front_probe.md`: exact launch command.
