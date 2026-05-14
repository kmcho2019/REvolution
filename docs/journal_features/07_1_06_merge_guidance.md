# Feature 07 / Feature 06 Merge Guidance

This handoff covers bringing `feat/journal-ks-adaptive-rebinning` up to date
with `wip/journal-extension-2026` after Feature 06 thought-only k-code was
merged through PR #9.

Current branch context at the time this guidance was written:

- Feature 07 branch: `feat/journal-ks-adaptive-rebinning`
- Target integration branch: `wip/journal-extension-2026`
- Target merge commit: `787dcd6358 Merge pull request #9 from
  kmcho2019/feat/journal-thought-only-k-code`
- Feature 06 branch merged into target: `feat/journal-thought-only-k-code`

The goal is not only to make the merge compile. The goal is to prove that
Feature 06 thought-only k-code and Feature 07 adaptive re-binning are compatible
and ready to merge into `wip/journal-extension-2026`.

## Merge Procedure

Start from a clean worktree.

```bash
git checkout feat/journal-ks-adaptive-rebinning
git fetch --all
git status --short --branch
git merge --no-ff wip/journal-extension-2026
```

Do not resolve conflicts with broad `ours` or `theirs` choices. Each conflict
must preserve both feature surfaces:

- Feature 06 owns thought-only representation, k-code evaluation,
  representative-code selection, thought prompts, thought-only validation, and
  `representation_kind` / `code_samples_per_thought` plumbing.
- Feature 07 owns KS-triggered adaptive re-binning, replay-pool semantics,
  re-bin event logging, grid-quantile and CVT geometry rebuilds,
  adaptive-rebin validation, and visualization compatibility.

After the merge, Feature 07 must treat Feature 06 thought representatives as
the archiveable unit. Do not record each k-code sample as a separate recent or
replay member. A thought-only archive member uses the representative valid-PPA
code sample for descriptors, objectives, quality, and artifact links.

## High-Risk Conflict Files

Review these files carefully when conflicts appear:

- `scripts/run_backend.py`
- `scripts/run_hard_iteration_qd_vllm.sh`
- `scripts/validate_qd_ppa_visualization.py`
- `src/revolution/backends/revolution_backend.py`
- `src/revolution/qd/engine.py`
- `src/revolution/qd/artifacts.py`
- `src/revolution/qd/ppa_visualization_export.py`
- `tests/revolution/test_ppa_visualization_export.py`
- `tests/revolution/test_revolution_backend.py`
- `tests/scripts/test_run_hard_iteration_qd_vllm.py`
- `tests/scripts/test_qd_ppa_visualization_scripts.py`

Expected Feature 06 additions include:

- `src/revolution/qd/thought_only.py`
- `scripts/validate_thought_only_k_code_run.py`
- `tests/revolution/test_thought_only_k_code.py`
- `tests/scripts/test_validate_thought_only_k_code_run.py`
- thought-only prompt files under `data/prompts/default/` and
  `data/prompts/journal_thought_only/`

Expected Feature 07 additions include:

- `scripts/validate_adaptive_rebinning_run.py`
- `tests/scripts/test_validate_adaptive_rebinning_run.py`
- adaptive rebin additions in `src/revolution/qd/archive.py`,
  `src/revolution/qd/engine.py`, `src/revolution/qd/types.py`,
  `src/revolution/qd/visualization.py`, and the QD visualization viewer/export
  path.

## Required Semantics After Merge

The merged code must support both current code-level QD and Feature 06
thought-only QD.

For current code-level QD:

- A recent sample is a successful archiveable code candidate with valid PPA.
- A replay member is a valid-PPA archiveable candidate, including candidates
  that were later rejected, replaced, or evicted by scalar or bounded Pareto
  insertion.

For thought-only QD:

- A recent sample is one successful thought representative.
- The representative must have a selected valid-PPA code sample.
- The representative code sample supplies descriptor values, PPA objectives,
  scalar quality, and artifact links.
- The k-code alternatives that were not selected as the representative must not
  appear as independent recent samples or replay members.
- A thought representative that was edged out by archive insertion can still be
  included in the replay pool and may reactivate only by surviving normal
  insertion in the rebuilt geometry.

For adaptive re-binning:

- The trigger runs after each completed generation, once the archive is
  initialized.
- Retained archive members are the KS archive baseline.
- Recent valid-PPA archiveable members from the configured recent window are the
  KS recent sample set.
- The trigger applies one KS test per active descriptor axis.
- The corrected threshold is `qd_rebinning_base_p_threshold / active_axis_count`.
- If any active axis has `p < corrected_threshold`, a re-bin fires.
- A re-bin rebuilds geometry from the full replay pool, clears current cells,
  replays every replay member exactly once through normal archive insertion,
  records old/new geometry, and starts cooldown.

## Documentation Updates

Update `docs/journal_features/07_ks_adaptive_rebinning.md` during conflict
resolution. It should no longer describe Feature 06 as future-only after this
merge. It must explicitly state:

- Feature 06 has landed in `wip/journal-extension-2026`.
- Feature 07 supports both code-level and thought-only archiveable units.
- In thought-only mode, recent/replay members are thought representatives, not
  individual k-code samples.
- Descriptor, objective, and quality values for thought-only rebinning come
  from the selected representative valid-PPA code sample.
- Rebin replay includes archiveable representatives that were previously
  displaced by scalar-elite replacement or bounded Pareto-front eviction.
- Rebin behavior must remain valid for `grid_quantile`, CVT, and applicable
  custom QD profiles.
- Visualization validation must cover rebin markers and geometry transitions.

Update `docs/journal_features/06_thought_only_k_code.md` only if necessary to
clarify the integration contract. Do not move Feature 07 behavior into the
Feature 06 spec.

## Unit Test Gate

Run the following before any real-eval validation. No failures are acceptable.

```bash
/workspace/.venv/bin/python -m pytest \
  tests/revolution/test_thought_only_k_code.py \
  tests/scripts/test_validate_thought_only_k_code_run.py \
  tests/revolution/test_qd_engine.py \
  tests/revolution/test_qd_archive.py \
  tests/revolution/test_ppa_visualization_export.py \
  tests/scripts/test_qd_ppa_visualization_scripts.py \
  tests/scripts/test_validate_adaptive_rebinning_run.py \
  tests/scripts/test_run_hard_iteration_qd_vllm.py \
  tests/scripts/test_validate_grid_quantile.py \
  -q
```

If this test set fails, fix the merge before running expensive validation.

## Strict Real-Eval Validation Gate

Use up to 16 workers for validation. Prefer high problem-level concurrency for
the hard-subset matrix so independent problems finish quickly:

```yaml
total_worker_slots: 16
max_active_problems: 13
max_workers_per_problem: 8
```

`max_active_problems` can be `13` or higher when the runner and available
backend capacity support it. The goal is to keep many hard-subset problems
active at once instead of serializing the suite behind a few long-running
designs. If a specific run needs more per-problem local parallelism, document
why and keep the total worker budget at or below `16`.

It is also acceptable to split the 16-worker budget across multiple config runs
at the same time when that reduces wall-clock time. For example, run two
independent validation configs with `8` workers each, or four smoke configs with
`4` workers each. Do not let the combined active workers across simultaneous
runs exceed the intended budget unless the user explicitly approves a larger
machine allocation. Record the split in the validation manifest so the run is
auditable.

Do not rerun expensive baseline results when valid baseline artifacts already
exist. Symlink or copy those run directories into the new validation root and
record the source path, source commit, and reason for reuse in a local manifest
or README. Do not silently mix old and new artifacts.

The validation matrix must include:

- Existing or reused `classic` baseline.
- Existing or reused Feature 07 code-level rebin-off baseline.
- Existing or reused Feature 06 thought-only rebin-off baseline, if available.
- Fresh merged-branch code-level `grid_quantile` rebin-on run.
- Fresh merged-branch thought-only `grid_quantile` rebin-on run.
- Fresh thought-only rebin-off run only if no valid Feature 06 baseline artifact
  exists.
- Fresh CVT smoke with adaptive rebin enabled.
- Fresh custom QD profile smoke, at minimum `size_control_3d`.
- Visualization export and validation for at least one run with rebin events.

The run is not complete until every configured problem finishes and all summary
artifacts are present.

## Quantitative Acceptance Criteria

The merged branch must satisfy all of the following:

- Feature 06 thought-only validator passes for thought-only runs.
- Feature 07 adaptive-rebin validator passes for rebin-on runs.
- Visualization validator passes and confirms rebin markers / geometry
  references.
- Adaptive-on emits at least one `rebin_check` event for every initialized QD
  problem.
- If a re-bin fires, the event records old geometry, new geometry, trigger
  axes, p-values, corrected threshold, retained member count, recent sample
  count, replay member count, replay attempt count, final active member count,
  displaced replay member count, reactivated displaced member count, and
  cooldown state.
- `replay_attempt_count == replay_member_count`.
- Cooldown is observed after every re-bin.
- Thought-only rebin recent/replay members are thought representatives, not
  individual k-code samples.
- Compared with the matching rebin-off and thought-only baselines, adaptive-on
  must not regress:
  - functionality pass rate;
  - synthesis pass rate;
  - number of valid PPA samples;
  - number of designs with at least one valid PPA sample;
  - average score improvement;
  - average PPA improvement;
  - archive occupied cells, coverage, and QD health.

If no live re-bin fires in the strict matrix, run a separate targeted
trigger-evidence smoke with aggressive parameters and document it separately.
Do not use the aggressive smoke as the main acceptance result.

## Commit Guidance

Keep commits atomic and reviewable:

1. Merge conflict resolution.
2. Code compatibility fixes.
3. Docs/spec updates.
4. Tests, validators, or config updates.
5. Validation evidence.

Use conventional commits. Subjects should be imperative, capitalized, concise,
and not end with a period. Bodies should explain what and why, not merely how.

After each commit, check for malformed messages:

```bash
git log --oneline -5
git show --stat --format=fuller HEAD
```

Before handoff, report:

- final branch and commit;
- resolved conflict summary;
- updated documentation paths;
- unit test command and result;
- validation run root;
- reused baseline artifact paths;
- final comparison report path;
- explicit pass/fail status for every quantitative acceptance criterion.
