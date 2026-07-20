# Repository Guidelines

## Where Things Are

The repo map, where-to-look-by-task index, project structure, canonical
entry points, command reference, and output/artifact orientation live in
[README.md](README.md) ("Repository Guide" section). This file keeps only
practices: the journal-revamp onboarding order below, coding style and
simplicity rules, testing, local validation, and commit standards.

## Journal Revamp Onboarding

- Journal-revamp onboarding (read in this order when implementing the TCAD goal):
  [docs/journal_features/revamp_ruminations_20260612.md](docs/journal_features/revamp_ruminations_20260612.md) is the original intent;
  [docs/journal_features/journal_narrative.md](docs/journal_features/journal_narrative.md) is the ACCEPTED claims contract (gates/branch rules frozen — it wins on any conflict);
  [docs/journal_features/13_findings_dashboard.md](docs/journal_features/13_findings_dashboard.md) is the START-HERE current-state view (topic-indexed findings F1–F7/M1–M7, result tables, open decisions, navigation map — refresh its tables as runs land);
  [docs/journal_features/14_narrative_posture_assessment.md](docs/journal_features/14_narrative_posture_assessment.md) is the strategic read (are we passing reviewer muster, the Branch-C/B-scoped reality, the operator-simplification spine, and the RealBench storyline-deciding experiment);
  [docs/journal_features/revamp_history/20260710_222442_KST_pareto_revolution_validation/README.md](docs/journal_features/revamp_history/20260710_222442_KST_pareto_revolution_validation/README.md) is the completed descriptor-free Pareto selection experiment; keep its logic isolated and the classic engine byte-identical;
  [docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/README.md](docs/journal_features/revamp_history/20260720_191404_KST_tcad_revolution_extension/README.md) is the proposed next-goal program scaffold; resolve its intake blockers before activation;
  in `docs/journal_features/revamp_history/20260612_005012_KST_journal_revamp/`: `goal_template.md` is the v2 objective, `journal_revamp_plan.md` the P1–P5 execution plan, `journal_revamp_implementation_todo.md` the phase-grouped checklist (sign-off requires every item checked and spot-verified), `journal_revamp_adversarial_prompt.md` the sign-off process, `journal_revamp_implementation_history.md` the chronological evidence log (append-only; doc 13 is its topic-indexed complement), `rerun_ledger.jsonl` the run ledger; `*_v1_initial.md` files are archived originals.
  Locked artifacts live in `data/configs/` (seed manifest, subsets, probe); revise only by version bump with recorded rationale.

## Coding Style & Naming Conventions
- Target Python 3.11+, 4-space indentation, and UTF-8 text files.
- Match the existing typed style: add type hints for new public interfaces and docstrings for non-trivial logic.
- Use `snake_case` for modules/functions/variables, `PascalCase` for classes, and `UPPER_SNAKE_CASE` for constants.
- Keep framework logic in `src/revolution/`; keep operational wrappers and reporting scripts in `scripts/`.
- When adding a new feature area, update the nearest detailed doc in `docs/` and also reflect the new entry points in `README.md` and this file so readers can find the right follow-on material quickly.
- Prefer extending existing report/artifact paths before inventing new top-level scripts or sidecar formats.
- For QD changes, keep grid and CVT behavior aligned where possible: shared config semantics, shared artifact naming, and shared reporting surfaces.

### Implementation Simplicity Rules
1. Write extremely simple, "skimmable" code.
2. Minimize possible states: fewer arguments; remove or narrow any state.
3. Use discriminated unions to reduce the states code can be in.
4. Exhaustively handle multi-type objects; fail on unknown types.
5. Don't write defensive code (+ fall-back, excessive back-compat); trust the types.
6. Assert when loading data; be opinionated about parameters — nothing optional unless strictly required.
7. Remove any changes that are not strictly required.
8. Bias for fewer lines of code; no complex or clever code.
9. Don't split into too many functions; early returns are great.
10. Use asserts instead of try/except or defaults when something must exist.
11. Never pass overrides unless strictly necessary; keep argument counts low; required arguments are never optional.
12. Use Google Python docstring format for public modules/classes/functions and non-obvious helpers; add concise comments only where they make intent easier to skim and maintain.

## Testing Guidelines
- Testing framework: `pytest` (configured in `pyproject.toml` with `tests/` as test root).
- Name files `test_<module>.py` and test functions `test_<behavior>`.
- Prefer fixtures/mocks for external binaries (`iverilog`, `yosys`, `openroad`) instead of hard runtime dependencies in unit tests.
- Add script-focused tests under `tests/scripts/` when CLI/report behavior changes.
- If a change touches archive artifacts, descriptor selection, or report packaging, add or update the closest matching QD test under `tests/revolution/` and `tests/scripts/`.

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
- For reasoning-model vLLM experiments on the shared large-context endpoint, treat low token budgets as invalid research settings. Use `--max_tokens 128000` and `--diff_max_tokens 128000` unless the run is explicitly a tiny debugging smoke.

## Commit & Pull Request Guidelines
- Follow the repository’s Conventional Commit pattern: `feat(scope): ...`, `fix(scope): ...`, `docs: ...`, `test(scope): ...`, `chore(scope): ...`.
- Use clear scopes (for example: `gen0`, `llm`, `devcontainer`, `reporting`).
- Prefer concise, imperative subjects and keep the first line under ~72 characters when possible.
- Keep commit structure clean: `<type>(<scope>): <subject>` on line 1, one blank line, wrapped body text, optional labeled sections (`Tests:`, `Docs:`), and optional footers (`Signed-off-by:`).
- In commit bodies, explain what changed and why; use short wrapped paragraphs or simple `- ` bullets for grouped changes.
- When using `git commit -s`, do not manually add another `Signed-off-by:` line
  in the message body. Each commit should end with exactly one sign-off footer
  for the repository author identity.
- Use signed multi-line commits going forward; never single-line for new work:
```bash
git commit -s -m "docs: add completion goal" \
  -m "Explain why agents must use docs/specs.md before handoff." \
  -m "Keep the body wrapped so terminal git output stays readable."
```
- The "Golden Seven": blank line between subject and body; subject ≤ 50 chars, capitalized, no trailing period, imperative mood ("If applied, this commit will <subject>"); body wrapped at 72 chars; body explains what and why, not how (context, why this solution, side effects/breaking changes).
- Keep commits atomic: one logical change per commit — an "and" in the subject means split it.
- Immediately after committing, inspect the stored message (`git log --format=%B -n 1`) and confirm: no raw `\n` text, no malformed/missing `Signed-off-by`, proper `type(scope): subject` form.
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
