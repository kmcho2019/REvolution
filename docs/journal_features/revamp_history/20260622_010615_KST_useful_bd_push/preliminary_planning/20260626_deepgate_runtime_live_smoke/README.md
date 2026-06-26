# T93 DeepGate Runtime Live Smoke

This package records the first bounded live REvolution smoke for the
`deepgate_pooled_pc3` runtime descriptor profile from T92.

## Decision

T93 passes the runtime-insertion gate but not the screening or promotion gate.

The successful `4x1` `Prob045_alu` smoke produced one valid-PPA candidate,
initialized the QD archive, and stored finite DeepGate pooled descriptor
values in `archive_cells.csv`. That proves the live runtime path can use the
isolated official DeepGate model boundary.

It is still not matched HV evidence. DeepGate remains a category
representative, not a final full-RTLLM arm.

## Files

- [commands/run_deepgate_runtime_live_smoke.md](commands/run_deepgate_runtime_live_smoke.md)
- [logs/validation_log.md](logs/validation_log.md)
- [results_report.md](results_report.md)
- [tables/live_smoke_outcomes.csv](tables/live_smoke_outcomes.csv)
