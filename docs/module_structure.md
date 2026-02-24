# Module Structure

## Top-level layout

- `src/`: Python package source code.
  - `revolution/`: core evolutionary framework (see below).
  - `eor.egg-info/`: packaging metadata produced by the build system.
- `scripts/`: executable helpers for running experiments, tests, report generation, data prep, and visualisations.
- `tests/`: unit tests organised under `tests/revolution/`.
- `data/`: benchmark assets.
  - `bench/`: VerilogEval, RTLLM, and CVDP problem definitions, reference designs, and synthesis metadata.
  - `prompts/`: prompt templates grouped by profile for `PromptStore`.
  - `configs/`: YAML templates demonstrating `--config` usage for the main scripts.
- `pdk/`: technology collateral used by the synthesis flow.
- `exp/`: default output directory for run artefacts (created at runtime).
- `Dockerfile`: reproducible environment for CI or local development.
- `pyproject.toml` / `uv.lock`: Python dependency definitions maintained by `uv`.

## `src/revolution/`

- `__init__.py`: package export surface, re-exports engines plus backend/runtime abstractions.
- `algorithm.py`: main evolutionary driver (`Heuristic`, `EoHEngine`, `SingleShotEngine`, `CVDPEngine`) with strategy and diff orchestration.
- `backends/base.py`: backend interface (`EvolutionBackend`) and shared context/service dataclasses.
- `backends/revolution_backend.py`: adapter around existing `EoHEngine` behavior.
- `backends/funsearch_backend.py`: FunSearch-style RTL backend (islands, signature clusters, reset/reseed, budgeted loop).
- `runtime/problem_context.py`: benchmark/problem path and metadata resolution.
- `runtime/candidate_evaluator.py`: backend-agnostic format/syntax/functionality/synthesis/PPA evaluation orchestration with `strict_ablation` and `search_accelerated` modes.
- `runtime/run_artifacts.py`: shared generation-log/summary writer plus legacy summary key alias support.
- `evaluation.py`: evaluation stack (`VerilogEvaluator`, `SynthesisEvaluator`).
- `llm.py`: unified async LLM client with retry/backoff, token tracking, and JSON parsing helpers.
- `logging.py`: `EoHLogger` for JSONL generation logs, per-run summaries, and reward statistics.
- `prompt_store.py`: filesystem-backed prompt templating system with concatenated bundle support and tolerant `safe_format`.
- `vllm_preflight.py`: lightweight `/v1/models` preflight helpers for vLLM connectivity and `max_model_len` checks.
- `configuration.py`: helpers for loading CLI config files (including legacy snapshot compatibility), validating options, and recording runnable snapshot + metadata-sidecar files.
- `utils.py`: utility helpers (for example `StreamRedirector`).

## `scripts/`

- `run_evolution.py`: CLI entry point for multi-problem evolutionary runs with multiprocessing.
- `run_backend.py`: canonical backend-selectable runner (`--backend revolution|funsearch`).
- `run_funsearch.py`: convenience wrapper for `run_backend.py --backend funsearch`.
- `run_backend_ablation.py`: ablation sweep orchestrator across both backends with multi-seed support, strict fairness checks, and configurable budget-axis normalization (`candidate_evaluations`, `llm_calls`, `dual_gate`).
- `backend_comparison_report.py`: side-by-side + aggregate backend report generator across experiment roots with pass/fail emoji status, any-pass design counts, solved-only score/PPA summaries, PPA regression counts, and budget/fairness diagnostics.
- `run_one_shot.py`: CLI for n-shot baselines that reuse the evaluation stack without evolution.
- `archive_baseline.py`: archive utility for run roots and ablation roots with manifest/index metadata, copied run configs, and compressed raw artifacts.
- `run_diff_mode_benchmark.py`: whole-vs-diff benchmark harness with hard-task selection, aggregate token/runtime comparisons, and diff failure catalog generation.
- `run_diff_mode_diagnostics.py`: repeated real-LLM diff stress harness producing strict-parse/apply failure catalogs across curated edge cases.
- `run_test.sh`, `run_regression_test.sh`, `run_cvdp_test.sh`: shell wrappers for regression suites.
- `generate_*`, `plot_problem_pareto.py`, `evolutionary_report_generator.py`: reporting and visualisation utilities.
- `prompt_file_manager.py`: manage prompt bundle files and synchronise `data/prompts/`.
- `util/` and `ref/`: helper scripts, synthesis references, and datasets.

## `tests/`

- `tests/revolution/test_algorithm.py`: unit tests for selection logic, diff application, and state transitions.
- `tests/revolution/test_evaluation.py`: covers simulator/synthesiser wrappers using fixtures/mocks.
- `tests/revolution/test_llm.py`: ensures JSON parsing, retry loops, and prompt handling behave as expected.
- `tests/revolution/test_vllm_preflight.py`: validates vLLM preflight URL handling, metadata parsing, and warning logic.
- `tests/scripts/test_run_diff_mode_benchmark.py`: validates hard-task selection and aggregate reporting helpers for whole-vs-diff benchmarks.
- `tests/scripts/test_run_diff_mode_diagnostics.py`: validates diagnostics skip behavior and result aggregation paths.

## Generated artefacts

- `compile_results_gate_cutoff_50.md`, `log.txt`, and other markdown logs under the repository root are outputs produced by helper scripts.
- Additional problem-specific folders, tables, or plots are created beneath `exp/` during runs.
