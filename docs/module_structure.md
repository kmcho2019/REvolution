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
- `pdk/`: technology collateral used by the synthesis flow.
- `exp/`: default output directory for run artefacts (created at runtime).
- `Dockerfile`: reproducible environment for CI or local development.
- `pyproject.toml` / `uv.lock`: Python dependency definitions maintained by `uv`.

## `src/revolution/`

- `__init__.py`: package export surface, currently re-exports engine classes.
- `algorithm.py`: main evolutionary driver:
  - `Heuristic`, `EoHEngine`, `SingleShotEngine`, and `CVDPEngine`.
  - Strategy definitions, prompt orchestration, evaluation loop, reinforcement logic, and diff handling.
- `evaluation.py`: evaluation stack:
  - `VerilogEvaluator`: Icarus Verilog compilation/simulation.
  - `SynthesisEvaluator`: Yosys + OpenROAD PPA pipeline and post-synthesis regressions.
- `llm.py`: unified async LLM client with retry/backoff, token tracking, and JSON parsing helpers.
- `logging.py`: `EoHLogger` for JSONL generation logs, per-run summaries, and reward statistics.
- `prompt_store.py`: filesystem-backed prompt templating system with concatenated bundle support and tolerant `safe_format`.
- `utils.py`: utility helpers (e.g., `StreamRedirector` for redirecting worker stdout/stderr to files).

## `scripts/`

- `run_evolution.py`: CLI entry point for multi-problem evolutionary runs with multiprocessing.
- `run_one_shot.py`: CLI for n-shot baselines that reuse the evaluation stack without evolution.
- `run_test.sh`, `run_regression_test.sh`, `run_cvdp_test.sh`: shell wrappers for regression suites.
- `generate_*`, `plot_problem_pareto.py`, `evolutionary_report_generator.py`: reporting and visualisation utilities.
- `prompt_file_manager.py`: manage prompt bundle files and synchronise `data/prompts/`.
- `util/` and `ref/`: helper scripts, synthesis references, and datasets.

## `tests/`

- `tests/revolution/test_algorithm.py`: unit tests for selection logic, diff application, and state transitions.
- `tests/revolution/test_evaluation.py`: covers simulator/synthesiser wrappers using fixtures/mocks.
- `tests/revolution/test_llm.py`: ensures JSON parsing, retry loops, and prompt handling behave as expected.

## Generated artefacts

- `compile_results_gate_cutoff_50.md`, `log.txt`, and other markdown logs under the repository root are outputs produced by helper scripts.
- Additional problem-specific folders, tables, or plots are created beneath `exp/` during runs.
