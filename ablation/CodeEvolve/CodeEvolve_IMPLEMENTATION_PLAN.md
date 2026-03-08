# CodeEvolve Backend Implementation Plan

## Summary

Implement a native `codeevolve` backend inside REvolution for backend ablation studies.
Phase 1 targets `RTLLM` and `VerilogEval-Spec-to-RTL` only, keeps the vendored
`science-codeevolve` tree read-only, and integrates through the existing
backend, ablation, reporting, and archive workflows.

## Status

- In progress
- Branch: `feat/CodEvolve-ablation-backend`
- Canonical path: `/workspace/ablation/CodeEvolve/CodeEvolve_IMPLEMENTATION_PLAN.md`

## Decision Log

- Use a native REvolution backend, not a subprocess wrapper around the vendored CLI.
- Keep the canonical directory casing as `CodeEvolve`.
- Phase 1 scope is `RTLLM` plus `VerilogEval-Spec-to-RTL`.
- Preserve CodeEvolve mechanics where they fit REvolution's single-problem runner:
  islands, separate prompt/solution populations, exploration/exploitation,
  inspiration-based crossover, meta-prompting, ancestor-depth exploitation,
  migration, and optional exploration scheduling.
- Treat the vendored `science-codeevolve` repo as the reference source of truth
  for semantics, but not as a runtime dependency because it targets Python
  `>=3.13.5` and assumes a different problem packaging model.

## Completed

- [x] repo/backend/ablation architecture audited
- [x] integration mode fixed to native backend
- [x] phase-1 scope fixed to RTLLM + VerilogEval
- [x] canonical naming fixed to CodeEvolve
- [x] implementation branch created
- [x] create CodeEvolve notes crosswalk
- [x] register backend metadata layer
- [x] register CLI surfaces
- [x] implement native backend
- [x] add CodeEvolve prompt profile and default config template
- [x] integrate ablation runner and archive detection
- [x] add tests
- [ ] update docs and examples

## Next

- Update backend-facing docs, usage examples, and limitations.
- Phase-2 follow-up: extend the task adapter beyond single-file RTL problems.
- Phase-2 follow-up: evaluate whether checkpoint/resume is worth adding for long ablation sweeps.

## Fidelity Deviations

- No direct use of the vendored CodeEvolve CLI or multiprocessing island workers.
- No checkpoint/resume in v1.
- No MAP-Elites, embeddings, or copied sandbox codebases in v1.
- No Python `input/src/init_program.py` problem packaging; REvolution RTL
  benchmarks will use a native task adapter.
- Diff editing will use REvolution's existing single-file JSON diff contract and
  diff applier instead of CodeEvolve's raw SEARCH/REPLACE text flow.
- Multi-file codebase tasks are deferred.

## Validation Log

- Planning pass complete against current repository state.
- Added central backend metadata registry with prompt-profile and CVDP capability
  helpers for later runner/archive integration.
- Added the native `CodeEvolveBackend`, prompt profile, and `run_backend.py`
  parser/build support for `codeevolve`.
- Refactored `run_backend_ablation.py` around a backend-command registry,
  added CodeEvolve fairness scheduling, generalized archive ablation detection,
  and extended `run_evolution.py` delegation for `codeevolve_` configs.
- Added backend, runner, ablation, archive, comparison-report, and delegation
  coverage for the new `codeevolve` path.
- Validation complete:
  - `.venv/bin/python -m pytest tests/revolution/test_codeevolve_backend.py tests/scripts/test_run_backend.py tests/scripts/test_run_backend_ablation.py tests/scripts/test_archive_baseline.py tests/scripts/test_backend_comparison_report.py tests/scripts/test_run_evolution.py`
  - `.venv/bin/python -m pytest`
  - `.venv/bin/python -m ruff check src/revolution/backends/codeevolve_backend.py scripts/run_backend.py scripts/run_backend_ablation.py scripts/archive_baseline.py tests/revolution/test_codeevolve_backend.py tests/scripts/test_run_backend.py tests/scripts/test_run_backend_ablation.py tests/scripts/test_archive_baseline.py`
  - `.venv/bin/python -m pyright src/revolution/backends/codeevolve_backend.py scripts/run_backend.py scripts/run_backend_ablation.py scripts/archive_baseline.py`
- Pyright reports zero errors for the touched files; the remaining
  `reportMissingModuleSource` warning for `tqdm` is pre-existing environment
  resolution noise in `scripts/run_backend.py`, not a CodeEvolve typing error.
