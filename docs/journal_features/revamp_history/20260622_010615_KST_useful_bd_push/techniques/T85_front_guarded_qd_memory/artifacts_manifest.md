# T85 Artifacts Manifest

## Implemented Source

- `src/revolution/qd/engine.py`: adds `front_guarded_memory` scheduler,
  primary-pool separation, memory cell credit, memory lane request routing,
  and summary metrics.
- `src/revolution/backends/revolution_backend.py`: carries FG-QDM config into
  the QD engine and run summaries.
- `scripts/run_backend.py`: exposes FG-QDM CLI flags.
- `src/revolution/algorithm.py`: records `qd_memory_*` prompt metadata on
  candidate prompt snapshots.

## Tests

- `tests/revolution/test_qd_engine.py`: Stage 0 primary-pool and memory-credit
  tests.
- `tests/scripts/test_run_backend.py`: CLI parser coverage.

## Planned Runtime Artifacts

Live run artifacts should be written under:

`exp/useful_bd_push/front_guarded_qd_memory_<timestamp>/`

Do not place new run artifacts under `/aux`.

Expected per-problem artifacts include `archive_cells.csv`,
`archive_history.jsonl`, `archive_summary.json`, `qd_metrics.json`,
`global_pareto_archive.csv`, candidate prompt snapshots with `qd_memory_*`
fields, and final backend summaries.
