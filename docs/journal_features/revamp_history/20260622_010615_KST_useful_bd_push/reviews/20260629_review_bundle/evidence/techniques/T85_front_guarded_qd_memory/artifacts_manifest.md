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

## Runtime Artifacts

Live run artifacts are written under:

`exp/useful_bd_push/front_guarded_qd_memory_<timestamp>/`

Do not place new run artifacts under `/aux`.

Completed roots:

- First smoke:
  `exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_12x3/seed_1001/openai_gpt-oss-120b`
- Warmup-4 smoke:
  `exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_warmup4_12x3/seed_1001/openai_gpt-oss-120b`
- Warmup-4 Pareto/HV analysis:
  `../../preliminary_planning/20260626_front_guarded_qd_memory_probe/analysis/warmup4_pareto_analysis/`
- Warmup-4 PPA distribution figures:
  `../../preliminary_planning/20260626_front_guarded_qd_memory_probe/analysis/warmup4_ppa_distribution/`

Expected per-problem artifacts include `archive_cells.csv`,
`archive_history.jsonl`, `archive_summary.json`, `qd_metrics.json`,
`global_pareto_archive.csv`, candidate prompt snapshots with `qd_memory_*`
fields, and final backend summaries.

## Technique-Level Package

- `results_report.md`: completed smoke report and promotion decision.
- `tables/warmup4_aggregate_backend_metrics.csv`: warmup-4 aggregate metrics.
- `tables/warmup4_backend_problem_metrics.csv`: warmup-4 per-problem metrics.
- `figures/warmup4_prob045_gain_power_vs_area.png`: representative raw PPA
  front figure.
- `figures/warmup4_prob015_gain_power_vs_effective_clock_period.png`:
  representative sequential front figure.
- `figures/visual_inspection_notes.md`: manual read of the copied figures.
