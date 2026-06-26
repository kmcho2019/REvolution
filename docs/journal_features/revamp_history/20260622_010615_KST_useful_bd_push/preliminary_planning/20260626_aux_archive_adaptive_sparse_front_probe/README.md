# Auxiliary Archive Adaptive Sparse-Front Probe

Status: completed; diagnostic negative, not promoted.

This package tests the next QD candidate after fixed high-exploit auxiliary
archive failed seed replication. It keeps the same MasterRTL structural archive
descriptor, but uses the existing adaptive sparse-front parent selector:

- normal state: sample from global NSGA-II rank with a `0.90` champion lane;
- sparse-front state: cap the champion lane at `0.65` only when local archive
  fronts are thin.

## Decision

This live QD gate is complete and should not be promoted. It improved mean
Pareto points relative to fixed high-exploit auxiliary archive, but mean HV
fell to `0.0946` versus classic `0.1406` and fixed high-exploit `0.1339`.

## Files

- `preregistration.md`: frozen setup, metrics, and decision rule.
- `commands/run_adaptive_sparse_front_probe.md`: exact launch command.
- `logs/run_checkpoint.md`: preflight, completion, validation, and analysis
  caveat.
- `adaptive_sparse_front_probe_report.md`: result and decision.
- `tables/adaptive_sparse_front_aggregate.csv`: primary aggregate metrics.
- `tables/adaptive_sparse_front_trigger_counters.csv`: sparse-front trigger
  activity by problem.
