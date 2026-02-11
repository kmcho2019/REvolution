# Repository Guidelines

## Project Structure & Module Organization
- `src/revolution/`: core package (`algorithm.py`, `evaluation.py`, `llm.py`, `configuration.py`, logging, prompt management).
- `scripts/`: runnable entry points and utilities (`run_evolution.py`, `run_one_shot.py`, report/table/plot generators).
- `tests/revolution/` and `tests/scripts/`: unit tests for framework modules and script helpers.
- `data/bench/`: benchmark suites used by CLI runs (`RTLLM`, `VerilogEval-*`, `cvdp`).
- `data/prompts/`, `pdk/`, and `docs/`: prompt templates, synthesis assets, and project documentation.
- `exp/` is generated run output and is intentionally gitignored.

## Build, Test, and Development Commands
- `uv sync`: install pinned dependencies from `pyproject.toml` and `uv.lock` into `.venv`.
- `source .venv/bin/activate`: activate local environment for development.
- `pytest`: run all tests under `tests/`.
- `pytest --cov=src/revolution --cov-report=term-missing`: run tests with coverage details.
- `python scripts/run_evolution.py --help`: view all evolutionary run options.
- `python scripts/run_evolution.py --benchmarks RTLLM --model_name gpt-4.1-mini`: example multi-generation run.
- `python scripts/run_one_shot.py --benchmarks VerilogEval-Spec-to-RTL --num_samples 20`: example n-shot baseline run.

## Coding Style & Naming Conventions
- Target Python 3.11+, 4-space indentation, and UTF-8 text files.
- Match the existing typed style: add type hints for new public interfaces and docstrings for non-trivial logic.
- Use `snake_case` for modules/functions/variables, `PascalCase` for classes, and `UPPER_SNAKE_CASE` for constants.
- Keep framework logic in `src/revolution/`; keep operational wrappers and reporting scripts in `scripts/`.

## Testing Guidelines
- Testing framework: `pytest` (configured in `pyproject.toml` with `tests/` as test root).
- Name files `test_<module>.py` and test functions `test_<behavior>`.
- Prefer fixtures/mocks for external binaries (`iverilog`, `yosys`, `openroad`) instead of hard runtime dependencies in unit tests.
- Add script-focused tests under `tests/scripts/` when CLI/report behavior changes.

## Commit & Pull Request Guidelines
- Follow the repository’s Conventional Commit pattern: `feat(scope): ...`, `fix(scope): ...`, `docs: ...`, `test(scope): ...`, `chore(scope): ...`.
- Use clear scopes (for example: `gen0`, `llm`, `devcontainer`, `reporting`).
- PRs should include: purpose of change, impacted configs/commands, test evidence, and relevant output paths (for example `exp/<model>/...`) when experiment flow is affected.
