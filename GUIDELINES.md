# Repository Guidelines

## Repo Map
- Start with [README.md](/workspace/.worktrees/revolution-qd-map-elites/README.md) for the project overview, environment setup, and primary run commands.
- Use [docs/user_guide.md](/workspace/.worktrees/revolution-qd-map-elites/docs/user_guide.md) for CLI usage, benchmark workflows, and validation guidance.
- Use [docs/module_structure.md](/workspace/.worktrees/revolution-qd-map-elites/docs/module_structure.md) for a file-by-file breakdown of the codebase.
- Use [docs/implementation_details.md](/workspace/.worktrees/revolution-qd-map-elites/docs/implementation_details.md) for subsystem-level architecture details.
- Use [docs/qd_map_elites_guide.md](/workspace/.worktrees/revolution-qd-map-elites/docs/qd_map_elites_guide.md) for the QD/MAP-Elites runtime flow, descriptor extraction paths, archive artifact layout, and generation/run traces.
- Use [docs/REvolution_specification.md](/workspace/.worktrees/revolution-qd-map-elites/docs/REvolution_specification.md) for the paper-plus-implementation specification view.
- Use [docs/revolution_qd_map_elites_implementation_plan.md](/workspace/.worktrees/revolution-qd-map-elites/docs/revolution_qd_map_elites_implementation_plan.md) for the current QD/MAP-Elites feature status and staged roadmap.

## Project Structure & Module Organization
- `src/revolution/`: core package. Start with `algorithm.py` for classic REvolution, `backends/` for runner adapters, `runtime/` for evaluation/problem abstractions, and `qd/` for the new archive/scoring/scheduler substrate.
- `scripts/`: runnable entry points and utilities. `run_backend.py` is the canonical runner, `run_evolution.py` is the legacy REvolution entry point, and `run_backend_ablation.py` is the fairness-controlled sweep runner.
- `tests/revolution/` and `tests/scripts/`: unit tests for framework modules and script helpers. The closest matching `test_<module>.py` file is usually the fastest way to see intended behavior.
- `data/bench/`: benchmark suites used by CLI runs (`RTLLM`, `VerilogEval-*`, `cvdp`).
- `data/prompts/`: prompt templates grouped by profile and strategy/mode.
- `data/configs/`: reusable config examples, including QD descriptor profile configuration.
- `pdk/`: synthesis assets used by the OpenROAD flow.
- `docs/`: project documentation and implementation notes.
- `exp/`: generated run output and intentionally gitignored.

## Build, Test, and Development Commands
- `uv sync`: install pinned dependencies from `pyproject.toml` and `uv.lock` into `.venv`.
- `source .venv/bin/activate`: activate local environment for development.
- `pytest`: run all tests under `tests/`.
- `pytest --cov=src/revolution --cov-report=term-missing`: run tests with coverage details.
- `python scripts/run_backend.py --help`: canonical backend-selectable runner help.
- `bash scripts/run_backend_qd_smoke_vllm.sh --dry-run`: inspect the repeatable
  QD smoke matrix before running live grid/CVT validation.
- `python scripts/run_evolution.py --help`: view all evolutionary run options.
- `python scripts/run_evolution.py --benchmarks RTLLM --model_name gpt-4.1-mini`: example multi-generation run.
- `python scripts/run_one_shot.py --benchmarks VerilogEval-Spec-to-RTL --num_samples 20`: example n-shot baseline run.
- `python scripts/qd_descriptor_probe.py --archive_type grid --circuit_type sequential`: inspect the current QD descriptor-axis selection and requirements.

## Coding Style & Naming Conventions
- Target Python 3.11+, 4-space indentation, and UTF-8 text files.
- Match the existing typed style: add type hints for new public interfaces and docstrings for non-trivial logic.
- Use `snake_case` for modules/functions/variables, `PascalCase` for classes, and `UPPER_SNAKE_CASE` for constants.
- Keep framework logic in `src/revolution/`; keep operational wrappers and reporting scripts in `scripts/`.
- When adding a new feature area, update the nearest detailed doc in `docs/` and also reflect the new entry points in `README.md` and this file so readers can find the right follow-on material quickly.

## Testing Guidelines
- Testing framework: `pytest` (configured in `pyproject.toml` with `tests/` as test root).
- Name files `test_<module>.py` and test functions `test_<behavior>`.
- Prefer fixtures/mocks for external binaries (`iverilog`, `yosys`, `openroad`) instead of hard runtime dependencies in unit tests.
- Add script-focused tests under `tests/scripts/` when CLI/report behavior changes.

## Local Validation Checklist
- This worktree does not currently contain a checked-in `.github/workflows/` CI definition, so pre-push validation should use the local repo proxy checklist instead.
- Run `pytest` for the full test suite.
- Run `ruff check` at least on touched files; use a broader tree only when cleaning legacy lint debt intentionally.
- Run `python -m pyright` on the touched source modules. If repo-wide pyright still has pre-existing debt, record that explicitly instead of silently skipping typecheck.
- Run `uv tool run ty check <touched modules>` when type-cleanliness is part of
  the change review; record whether diagnostics are branch-local debt,
  older repo-wide debt, or tool-environment import resolution noise.
- For LLM-backed runtime changes, run a vLLM preflight (`curl http://<host>:<port>/v1/models`) and at least one bounded smoke command.
- Record blocked smoke results explicitly when the model endpoint is reachable but the run does not complete in a reasonable timeout.

## Commit & Pull Request Guidelines
- Follow the repository’s Conventional Commit pattern: `feat(scope): ...`, `fix(scope): ...`, `docs: ...`, `test(scope): ...`, `chore(scope): ...`.
- Use clear scopes (for example: `gen0`, `llm`, `devcontainer`, `reporting`).
- Prefer concise, imperative subjects and keep the first line under ~72 characters when possible.
- Keep commit structure clean: `<type>(<scope>): <subject>` on line 1, one blank line, wrapped body text, optional labeled sections (`Tests:`, `Docs:`), and optional footers (`Signed-off-by:`).
- In commit bodies, explain what changed and why; use short wrapped paragraphs or simple `- ` bullets for grouped changes.
- When using `git commit -s`, do not manually add another `Signed-off-by:` line
  in the message body. Each commit should end with exactly one sign-off footer
  for the repository author identity.
- Preferred message template:
```text
feat(reporting): add reproducible experiment archiving for run outputs

Implement a repo-native archive utility for experiment tracking and
reproducibility.

Tests:
- add tests/scripts/test_archive_baseline.py
- validate single-run and ablation archive behavior

Docs:
- update README.md and docs/user_guide.md

Signed-off-by: Name <email>
```
- Avoid malformed headers or spacing issues (for example `feat (reporting)`, missing `:`, double spaces, or inconsistent scope casing).
- Before push/PR, review every new commit message:
- Check message body exactly as stored: `git log --format=%B -n 1 <commit>`.
- Check rendered commit metadata and spacing: `git show --pretty=fuller --no-patch <commit>`.
- Check for malformed content: raw `\n`, missing blank lines, trailing spaces, bad indentation, or malformed `type(scope): subject`.
- If reviewing a branch, run the same checks for each commit in `<base>..HEAD`.
- PRs should include: purpose of change, impacted configs/commands, test evidence, and relevant output paths (for example `exp/<model>/...`) when experiment flow is affected.
