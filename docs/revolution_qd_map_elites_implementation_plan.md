# REvolution QD/MAP-Elites Implementation Plan

## Summary

Implement `revolution_qd` as a new REvolution search mode while keeping classic
`revolution` behavior unchanged. QD mode replaces the success-side flat pool
with an archive-backed success state and supports both `grid` and `cvt` archive
geometries through the same runner, logging, and reporting surfaces.

This document is the canonical living plan for the feature branch
`feat/revolution-qd-map-elites` in worktree
`/workspace/.worktrees/revolution-qd-map-elites`. It must be updated before and
after every implementation stage so that completed work, tests, smoke runs,
debt review notes, and commit evidence stay synchronized with the codebase.

## Research Intent Lock

- Keep REvolution's original repair-driven search loop intact for
  side-by-side comparison.
- Add `--search_mode {revolution,revolution_qd}` instead of forking the whole
  framework.
- In `revolution_qd`, the success-side source of truth is the archive only:
  `fail_pool`, `success_archive`, `success_view`.
- Support both `grid` and `cvt` archives as first-class modes. Implement and
  validate `grid` first, then `cvt`, but end with parity across CLI, config,
  logs, artifacts, and tests.
- Define `quality_score` in `quality_mode=ppa` exactly as the REvolution PPA
  fitness equation and maximize it.
- Preserve one-metric specialists by keeping `g_P`, `g_A`, and `g_T` available
  as separate descriptor axes.
- Keep descriptor selection experiment-friendly and configurable from CLI,
  config, and descriptor files.
- Keep generation mode flexible per phase and per benchmark so larger problems
  can prefer diff-heavy workflows when whole-mode context becomes impractical.

## Status

- Branch: `feat/revolution-qd-map-elites`
- Base branch: `wip/journal-extension-2026`
- Base commit: `447c012822`
- Current stage: `Stage 3`
- Current backend scope:
  - `RTLLM`
  - `VerilogEval-Spec-to-RTL`
  - `cvdp` 1.0.2 limited to `cid002` and `cid003`
  - `RealBench` module subsets
- Current backend status: Stage 3 grid-runtime path is live with benchmark-
  default phase-mode wiring and a bounded per-cell `success_view` reservoir;
  CVT, reporting parity, and benchmark-expansion stages remain pending

## Worktree Info

- Main workspace: `/workspace`
- Feature worktree: `/workspace/.worktrees/revolution-qd-map-elites`
- Created with:
  `git worktree add -b feat/revolution-qd-map-elites /workspace/.worktrees/revolution-qd-map-elites wip/journal-extension-2026`
- Note: the feature worktree starts from the committed state of
  `wip/journal-extension-2026`; unrelated untracked files in `/workspace` do not
  carry into the new worktree automatically.

## Decisions Locked

- Public mode switch:
  `--search_mode {revolution,revolution_qd}`
- Archive backends:
  `--qd_archive_type {grid,cvt}`
- Quality mode:
  `quality_mode = {ppa,functional_only}`
- Grid is implemented first because it is easier to debug and less prone to
  geometry bugs, but CVT is not a second-class feature at merge time.
- Default `quality_score` weights:
  - sequential circuits: `alpha=beta=gamma=1/3`
  - combinational circuits: `alpha=beta=1/2`, `gamma=0`
- QD budgeting uses the simple linear fill rule:
  `fail_share = 1 - min(1.0, occupied_cells / max(N_target, 1))`
- Phase generation modes are overridable via CLI/config:
  `qd_fail_generation_mode`, `qd_seed_generation_mode`,
  `qd_backfill_generation_mode`, `qd_refine_generation_mode`,
  `qd_crossover_generation_mode`
- Descriptor selection is configurable through preset profiles, explicit axis
  lists, and descriptor files.

## Original Plan Comparison Review

This section compares the current implementation state to the original QD/MAP-
Elites plan that seeded the branch. The goal is to make any divergence
explicit, evaluate whether it was appropriate, and keep the roadmap honest.

### High-level alignment

- `search_mode=revolution_qd` was added as planned and classic
  `search_mode=revolution` remains intact.
- `ProblemSpec`, `StructuralEvaluator`, the descriptor registry/config path,
  and the exact maximize-form REvolution PPA `quality_score` were all landed in
  line with the original design.
- `grid` was implemented before `cvt`, matching the original risk-reduction
  rollout.
- Descriptor selection is configurable through CLI, config, and descriptor
  profile files as intended.
- The simple linear fill-based scheduler was implemented exactly as planned.

### Explicit divergences and review

- Divergence: `QDEngine` currently lives in `src/revolution/qd/engine.py`
  instead of first refactoring `src/revolution/algorithm.py` into a richer set
  of shared helper seams.
  Review:
  This was an intentional short-term divergence. It reduced the risk of
  breaking classic REvolution while letting the grid runtime path land sooner.
  The tradeoff is some duplicated offspring-materialization and generation-loop
  logic. This is acceptable for the grid-first checkpoint, but it should be
  reduced before or during CVT integration so the branch does not accumulate
  engine-loop drift.

- Resolved divergence: `success_view` originally landed as an archive-elite
  view only, without the planned bounded per-cell recent-occupant reservoir.
  Review:
  This gap is now closed for the grid runtime path. The archive remains the
  success-side source of truth, while `success_view` now adds a bounded recent-
  occupant reservoir for parent sampling without creating a second flat success
  store.

- Divergence: grid binning currently uses uniform per-axis bounds `[-1, 1]`
  with derived bin counts, rather than a richer bin-spec path loaded from
  config/descriptor files.
  Review:
  This is appropriate for the first grid checkpoint because the current grid
  axes are normalized PPA gains (`g_A`, `g_P`, `g_T`), where `[-1, 1]` is a
  defensible debugging range. However, the original intent of configurable grid
  axes and bin specs still stands, especially once structural/physical axes are
  used in grid ablations.

- Divergence: descriptor extraction is currently a tested substrate and registry
  plus Yosys-like structural helpers, but not yet fully wired to machine-
  readable OpenROAD sidecars for physical descriptors.
  Review:
  This divergence is acceptable at the current stage because the active runtime
  grid path is using normalized PPA gain axes. It should not be treated as
  complete descriptor parity. Stage 4 or Stage 7 still needs actual physical-
  metric plumbing so descriptor experiments are not partly synthetic.

- Divergence: live RTLLM grid smokes were attempted but are currently blocked by
  long-running first-generation behavior on the shared vLLM endpoint rather
  than producing quick pass/fail evidence.
  Review:
  This is not a design divergence, but it does affect validation confidence.
  The blocked smoke does not disprove the runtime path, but it means the branch
  still lacks the intended end-to-end live validation evidence for Stage 3.

- Resolved divergence: the branch originally exposed per-phase generation-mode
  overrides in CLI/backend config before the QD runtime `auto` path actually
  consumed `ProblemSpec.phase_generation_defaults`.
  Review:
  This gap has now been closed for the current grid runtime path. Resolution
  order is now `explicit override -> ProblemSpec defaults -> local fallback`,
  which is materially closer to the original plan and makes benchmark-specific
  diff-policy experiments meaningful.

- Divergence: top-level and immediate docs were updated earlier than the
  original stage ordering would have required.
  Review:
  This divergence is appropriate and beneficial. The user explicitly requested
  that new features be reflected immediately in the nearest docs and the
  top-level repo map. The documentation now better matches actual branch state.

### Internal review conclusion

- The implementation is still aligned with the original research intent at the
  architectural level.
- The main acceptable divergence is tactical: the branch prioritized a working
  grid runtime path with limited duplication before doing the deeper engine
  seam refactor.
- The largest remaining risk is not conceptual drift but technical debt around
  duplicated generation-loop logic and incomplete runtime parity for CVT,
  reporting, and richer archive-parent semantics.

### Evidence basis for the review

- Strong evidence:
  parser/config, scoring, descriptor, archive, scheduler, and grid runtime
  selection paths are covered by focused unit tests and backend tests.
- Moderate evidence:
  top-level docs and immediate feature docs already reflect the current staged
  QD surface instead of describing CVT/runtime parity that has not landed yet.
- Weak evidence:
  live end-to-end vLLM smoke validation is still incomplete because the shared
  endpoint did not yield a fast first-generation success/failure result in the
  attempted Stage 3 grid smokes.

## Documentation Surface Review

The original plan required that new feature work be reflected both near the
implementation and in the top-level repo map. The current branch is aligned
with that requirement.

- `README.md` now exposes `revolution_qd`, grid-vs-CVT staging status, and a
  concrete example command for the grid runtime path.
- `GUIDELINES.md` now acts as a repo map that points readers to the right docs
  and source areas for high-level orientation before they dive into details.
- `docs/user_guide.md`, `docs/module_structure.md`,
  `docs/implementation_details.md`, and `docs/REvolution_specification.md` all
  mention the QD feature surface and the current grid-first, CVT-pending state.

Documentation risk to watch:

- These docs are directionally correct for the current branch, but they should
  be refreshed again when CVT lands and when reporting/artifact parity is
  added.

## Stage Tracker

### Stage 0: Worktree And Living Plan Bootstrap

- [x] Create feature worktree from `wip/journal-extension-2026`.
- [x] Query live vLLM `/v1/models` endpoint and record model metadata.
- [x] Create this canonical living plan document.
- [x] Review Stage 0 status and commit bootstrap docs-only change.

### Stage 1: Search Mode, ProblemSpec, Archive Interface, And Per-Phase Modes

- [x] Add `search_mode=revolution_qd` plumbing to runners and backend config.
- [x] Add QD config surface for archive type, quality mode, descriptor config,
      and phase generation-mode overrides.
- [x] Add `ProblemSpec` capability layer.
- [x] Add shared archive protocol / state types without altering classic mode.
- [x] Add regression and config-surface tests.
- [x] Update docs and plan with Stage 1 validation notes.
- [x] Commit Stage 1 with signed multi-line commit message.

### Stage 2: Exact Quality Score, Descriptor Registry, And Extraction Substrate

- [x] Add exact REvolution PPA `quality_score`.
- [x] Add `g_P`, `g_A`, `g_T` extraction and logging fields.
- [x] Add functional-only fallback ranking.
- [x] Add descriptor registry and descriptor profile config file.
- [x] Add configurable descriptor axes / descriptor file loading.
- [x] Add structural descriptor extraction (`seq_ratio`, `mux_ratio`,
      `ltp_noff`, etc.).
- [x] Add duplicate code hashing before expensive evaluation.
- [x] Add tests and a descriptor probe utility.
- [x] Update docs and plan with Stage 2 validation notes.
- [x] Commit Stage 2.

### Stage 3: Grid Backend First Implementation

- [x] Add `QDEngine` scaffolding.
- [x] Implement `GridArchive`.
- [x] Implement linear fill/improve scheduler.
- [x] Implement archive-backed success insertion/replacement.
- [x] Wire the first grid runtime path through `revolution_backend.py`.
- [x] Add grid-specific tests.
- [x] Refresh top-level and immediate QD docs for the grid-runtime checkpoint.
- [x] Wire `ProblemSpec.phase_generation_defaults` into QD runtime `auto`
      policy resolution.
- [x] Add bounded per-cell reservoir support so `success_view` matches the
      planned elite-plus-recent-occupant semantics.
- [ ] Add configurable grid-bin specification loading for structural/physical
      grid experiments.
- [ ] Refactor duplicated engine-loop seams shared by `EoHEngine` and
      `QDEngine`.
- [ ] Run RTLLM and VerilogEval grid smokes to a real completion state.
- [ ] Add a deterministic fast-smoke path so Stage 3 runtime validation does
      not depend only on slow long-context vLLM runs.
- [x] Update docs and plan with Stage 3 validation notes.
- [x] Commit Stage 3 checkpoints.

### Stage 4: CVT Backend With Parity Surface

- [ ] Implement CVT warm-up, scaler fit, frozen centroids, and reinsertion.
- [ ] Keep grid/CVT on equal footing in summary, artifacts, and tests.
- [ ] Add CVT-specific tests and parity tests.
- [ ] Run RTLLM and VerilogEval CVT smokes.
- [ ] Update docs and plan with Stage 4 validation notes.
- [ ] Commit Stage 4.

### Stage 5: QD Operators And Flexible Diff Usage

- [ ] Add `M-T` and `C-D` prompts and operator routing.
- [ ] Route whole/diff by explicit per-phase policy resolution.
- [ ] Add operator routing tests.
- [ ] Run targeted whole-heavy and diff-heavy smoke tests.
- [ ] Update docs and plan with Stage 5 validation notes.
- [ ] Commit Stage 5.

### Stage 6: CVDP And RealBench Module Capability Expansion

- [ ] Add `cvdp` `cid002` / `cid003` capability path.
- [ ] Add `RealBench` module-subset adapter and fixtures.
- [ ] Gate `quality_mode=ppa` vs `functional_only` per problem.
- [ ] Add tests and smokes or explicitly record blocked live smoke.
- [ ] Update docs and plan with Stage 6 validation notes.
- [ ] Commit Stage 6.

### Stage 7: Archive Logging, Reporting, Visualization, And Descriptor Study

- [ ] Emit `archive_history.jsonl`, `archive_cells.csv`,
      `archive_summary.json`, `qd_metrics.json`, and
      `grid_layout.json` or `centroids.json`.
- [ ] Add generation metrics, per-cell exports, and visualization outputs.
- [ ] Extend archive/report packaging.
- [ ] Add reporting and visualization tests.
- [ ] Run grid and CVT artifact-validation smokes.
- [ ] Update docs and plan with Stage 7 validation notes.
- [ ] Commit Stage 7.

### Stage 8: Full Regression, Docs, And Merge-Ready Cleanup

- [ ] Run full pytest suite.
- [ ] Run `ruff` on touched files.
- [ ] Run `pyright` on touched modules.
- [ ] Run final vLLM-backed smoke matrix.
- [ ] Perform code cleanliness and intent-alignment review.
- [ ] Update top-level docs and finalize this plan.
- [ ] Commit Stage 8.

## Exact TODO List

### Public Surface

- [x] Add `search_mode`
- [x] Add `qd_archive_type`
- [x] Add `qd_num_cells`
- [x] Add `qd_fill_target_fraction`
- [x] Add `qd_cell_reservoir`
- [x] Add `qd_neighbor_k`
- [x] Add `qd_cvt_warmup_successes`
- [x] Add `qd_quality_mode`
- [x] Add `qd_alpha`, `qd_beta`, `qd_gamma`
- [x] Add `qd_descriptor_profile`
- [x] Add `qd_descriptor_axes`
- [x] Add `qd_descriptor_file`
- [x] Add `qd_enable_descriptor_experiments`
- [x] Add `qd_descriptor_probe_budget`
- [x] Add `qd_grid_axes`
- [x] Add `qd_cvt_axes`
- [x] Add per-phase generation-mode overrides

### Core Runtime

- [x] Add `src/revolution/runtime/problem_spec.py`
- [x] Add `src/revolution/runtime/structural_evaluator.py`
- [x] Add `src/revolution/qd/types.py`
- [x] Add `src/revolution/qd/scoring.py`
- [x] Add `src/revolution/qd/descriptors.py`
- [x] Add `src/revolution/qd/archive.py`
- [x] Add `src/revolution/qd/scheduler.py`
- [ ] Add `src/revolution/qd/engine.py` follow-through cleanup for shared engine
      seams and reduced duplication
- [ ] Add `src/revolution/qd/visualization.py`
- [ ] Refactor `src/revolution/algorithm.py` for shared engine seams
- [x] Wire `ProblemSpec.phase_generation_defaults` into runtime `auto` phase
      resolution
- [x] Add bounded per-cell `success_view` reservoir support
- [ ] Add configurable grid-bin specification loading

### Descriptor Registry Candidates

- [x] Support structural descriptors:
  `seq_ratio`, `comb_ratio`, `mux_ratio`, `adder_ratio`, `ltp_noff`,
  `cell_count_log`
- [x] Support physical descriptors:
  `wirelength`, `utilization`, `cts_buffer_count`, `repair_buffer_count`,
  `hold_buffer_count`
- [x] Support PPA gain descriptors:
  `g_P`, `g_A`, `g_T`
- [x] Add initial preset profiles:
  `rtl_core`, `rtl_phys`, `rtl_phys_cts`, `hybrid_seq_default`,
  `hybrid_comb_default`, `hybrid_phys_seq`
- [x] Add descriptor probe script for extraction coverage and experiment logging
- [ ] Add machine-readable physical-metric sidecars for OpenROAD-backed
      descriptor extraction parity

### Reporting

- [ ] Add archive history JSONL
- [ ] Add archive cells CSV
- [ ] Add archive summary JSON
- [ ] Add QD metrics JSON
- [ ] Add grid layout / centroid output
- [ ] Add grid heatmaps and CVT projection plots

## Validation Log

### Stage 0

- Date: `2026-03-12`
- Worktree created successfully.
- vLLM preflight command:
  `curl -s http://host.docker.internal:8000/v1/models`
- Result:
  - `id=/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
  - `max_model_len=131072`
- Automated tests: not yet run
- Smoke tests: preflight only
- Commit:
  - `32ea6f39e6` `docs(qd): bootstrap living implementation plan and worktree log`

### Stage 1

- Date: `2026-03-12`
- Implemented:
  - runner/back-end `search_mode` scaffolding
  - QD parser/config surface for archive type, descriptor inputs, quality mode,
    and per-phase generation-mode overrides
  - new `ProblemSpec` capability layer
  - shared `QDArchive` protocol and insert-result types
  - `run_evolution.py` delegation to `run_backend.py` for QD-mode configs
  - guard rejecting `search_mode=revolution_qd` with
    `population_pool_mode=single`
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_defaults.py tests/revolution/test_problem_spec.py tests/scripts/test_run_backend.py tests/scripts/test_run_evolution.py`
  - Result: `26 passed in 1.50s`
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_backends_base.py tests/scripts/test_run_backend_ablation.py`
  - Result: `15 passed in 0.75s`
- Smoke tests:
  - no live backend run yet; Stage 1 is parser/config/capability scaffolding only
- Notes:
  - `run_backend.py` now annotates summary metadata with `search_mode`,
    `problem_spec`, and initial `qd_config` fields.
  - `run_evolution.py` stays as a legacy wrapper and forwards QD requests to
    `run_backend.py` instead of growing a second execution path.

### Stage 2

- Date: `2026-03-12`
- Implemented:
  - exact REvolution PPA `quality_score` helper using the maximize-form
    equation with automatic sequential/combinational defaults
  - explicit `g_P`, `g_A`, `g_T` gain extraction
  - functional-only fallback scoring for CVDP-style paths
  - `normalized_code_hash`, `partial_pass_fraction`, `repair_score`,
    `archiveable`, and `archive_rejection_reason` fields on evaluations
  - descriptor registry, descriptor profile YAML, and descriptor-axis
    resolution helpers
  - descriptor probe CLI utility
  - lightweight structural metric extraction for Yosys-like statistics
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_structural_evaluator.py tests/revolution/test_qd_scoring.py tests/revolution/test_qd_descriptors.py tests/scripts/test_qd_descriptor_probe.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_cvdp_evaluator.py`
  - Result: `24 passed in 0.73s`
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_defaults.py tests/revolution/test_problem_spec.py tests/revolution/test_structural_evaluator.py tests/revolution/test_qd_scoring.py tests/revolution/test_qd_descriptors.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_candidate_evaluator_parity.py tests/revolution/test_cvdp_evaluator.py tests/revolution/test_backends_base.py tests/scripts/test_run_backend.py tests/scripts/test_run_evolution.py tests/scripts/test_run_backend_ablation.py tests/scripts/test_qd_descriptor_probe.py`
  - Result: `71 passed in 1.23s`
- Smoke tests:
  - no live LLM/backend smoke yet; Stage 2 is evaluation/config substrate only
- Notes:
  - descriptor selection now supports preset profiles, explicit axis lists, and
    descriptor files
  - `run_backend.py` threads descriptor and quality settings into
    `CandidateEvaluator`
  - CVDP evaluator now emits functional-only quality metadata compatible with
    later archive insertion logic
- Commit:
  - `2268a7f81f` `feat(qd): add scoring and descriptor substrate`

### Stage 3

- Date: `2026-03-12`
- In-progress implementation:
  - added `GridArchive` with tested empty-cell insert, same-cell replacement,
    and edge-bin clamping semantics
  - added exact linear QD fail-share and fill/improve budget split helpers
  - added experimental `QDEngine` runtime wiring for `search_mode=revolution_qd`
    with archive-backed success-state handling on the grid path
  - updated README, GUIDELINES, and immediate implementation docs to reflect
    the new QD feature surface and repo navigation pointers
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_archive.py tests/revolution/test_qd_scheduler.py tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_scoring.py`
  - Result: `20 passed in 0.83s`
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_defaults.py tests/revolution/test_problem_spec.py tests/revolution/test_qd_scoring.py tests/revolution/test_qd_descriptors.py tests/revolution/test_structural_evaluator.py tests/revolution/test_qd_archive.py tests/revolution/test_qd_scheduler.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py tests/scripts/test_qd_descriptor_probe.py`
- Result: `51 passed in 1.01s`
- Smoke tests:
  - attempted live RTLLM smoke with `search_mode=revolution_qd`, `qd_archive_type=grid`,
    `population_size=1`, `num_generations=0`, vLLM endpoint
    `http://host.docker.internal:8000`
  - attempted once with `--max_tokens 128000` and once with `--max_tokens 4096`
  - both runs were manually stopped after stalling in the first end-to-end
    generation step without producing a quick failure signal; this is recorded
    as a blocked smoke rather than a pass
- Notes:
  - `revolution_backend.py` now selects `QDEngine` when
    `search_mode=revolution_qd`
  - current runtime support is grid-only; `cvt` remains staged work for Stage 4
  - top-level docs refreshed at this checkpoint:
    - `README.md`
    - `GUIDELINES.md`
    - `docs/user_guide.md`
    - `docs/module_structure.md`
    - `docs/implementation_details.md`
    - `docs/REvolution_specification.md`
  - phase-generation override flags are exposed and carried through runtime
    construction, and benchmark-specific `ProblemSpec` defaults are now applied
    in the `QDEngine` `auto` path with explicit overrides still taking
    precedence
  - focused runtime/default-wiring validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_problem_spec.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py`
    - Result: `31 passed in 1.57s`
  - focused reservoir/runtime sampling validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_qd_archive.py tests/revolution/test_revolution_backend.py tests/revolution/test_problem_spec.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py`
    - Result: `37 passed in 1.03s`
  - grid runtime now keeps a bounded per-cell reservoir for recent successful
    occupants, and `success_view` samples from archive elites plus that
    reservoir without making it a second source of truth
  - commit-message hygiene review for `447c012822..HEAD`:
    - checked `git log --format=%B`, `git show --pretty=fuller --no-patch`, and
      `sed -n 'l'` formatting output for each commit
    - initial review found duplicate sign-off footers on two branch commits
    - branch history was rewritten to remove the extra `Signed-off-by: Codex
      <codex@openai.com>` footer so each commit now carries exactly one
      repository-author sign-off
    - post-rewrite review found no malformed headers, raw `\\n`, spacing
      corruption, or remaining duplicate sign-off footers
    - prevention note added to `GUIDELINES.md`: when using `git commit -s`, do
      not manually add a second `Signed-off-by:` footer
  - first Stage 3 substrate commit:
    - `efbf9b48d0` `feat(qd): add grid archive and linear scheduler substrate`
  - second Stage 3 runtime/docs checkpoint commit:
    - `4a82690a1f` `feat(qd): wire grid runtime path and refresh docs`

## Debt Review

### Stage 0

- No code changes yet.
- Main architecture risk to watch:
  avoid duplicating success-state truth between archive and a flat pool.
- Main integration risk to watch:
  avoid forcing archive-specific logic deep into classic `revolution` paths
  where a clean `search_mode` split is sufficient.

### Stage 1

- Kept the classic `revolution` engine path intact.
- Avoided early engine forking by landing typed config/capability scaffolding
  before archive logic.
- The QD surface is broad, but still mostly passive; behavioral changes are
  limited to validation and metadata until Stage 3.
- Follow-up risk to watch:
  the large QD config surface should eventually be grouped into dedicated
  config objects once the execution path exists, otherwise `run_backend.py`
  argument plumbing will become noisy.

### Stage 2

- The descriptor registry is intentionally lightweight and declarative, which
  keeps experimentation easy and avoids prematurely over-abstracting archive
  logic before Stage 3.
- Structural extraction is currently based on Yosys-like payloads rather than
  a direct subprocess integration. That is sufficient for unit-tested substrate
  work now, but Stage 3 or 4 will need actual runtime wiring from synthesis
  artifacts.
- Candidate evaluation enrichment is centralized so later archive logic does
  not need to recompute code hashes, quality score aliases, or repair score.

### Stage 3

- The archive and scheduler substrate are intentionally separate from the
  existing engine until the runner can be wired without duplicating major
  portions of `EoHEngine`.
- Grid geometry is explicit and easy to test, which is the intended low-risk
  first step before CVT warm-up/freeze logic is introduced.
- The new `QDEngine` reuses a meaningful amount of existing prompt/eval code,
  but there is still duplicated offspring-materialization logic. That seam
  should be refactored once the grid runtime is stable enough to avoid
  spreading engine-loop duplication into CVT work.
- The current grid runtime does not yet expose a bounded per-cell reservoir or
  configurable grid-bin specification loading. The reservoir gap is now closed;
  configurable grid-bin loading is still deferred to keep the geometry logic
  smaller before CVT work lands.
- The `ProblemSpec` phase-default data model is now consumed by `QDEngine`, but
  the resolution logic still lives only in the QD engine rather than behind a
  shared reusable helper. That is acceptable for now, but it is still a seam
  to watch if classic and QD mode continue to diverge in prompt routing.
- Physical descriptor plumbing still lags the registry/config surface. That is
  acceptable for the current gain-axis-heavy grid checkpoint, but not for final
  paper-grade descriptor experiments.

## Intent Alignment Review

### Stage 0

- Current branch state matches intended starting point.
- Plan preserves both archive backends, configurable descriptors, and
  per-phase generation-mode flexibility.
- Grid-first implementation order is aligned with the debugging strategy while
  keeping CVT parity as an explicit requirement.

### Stage 1

- The implementation still matches the intended architecture:
  classic REvolution remains unchanged, while QD mode now has a typed entry
  surface instead of ad-hoc future flags.
- `ProblemSpec` captures benchmark defaults for descriptor profile, quality
  mode, and per-phase generation-mode preferences without hardcoding those
  choices directly into the backend runner.
- No success-side archive state has been introduced yet, so there is no risk
  of archive/pool source-of-truth drift at this stage.

### Stage 2

- The scoring implementation now matches the intended research framing:
  maximize weighted normalized PPA gains while also exposing the three gains
  independently for archive descriptors.
- Descriptor configuration remains open for empirical iteration, which matches
  the paper-oriented requirement to test new feature sets rather than locking
  into only `seq_ratio`, `mux_ratio`, and `ltp_noff`.
- The current implementation still stops short of archive behavior, so there is
  no divergence yet from the planned grid-first then CVT rollout.

### Stage 3

- The linear fail-share helper exactly matches the planned budgeting rule and
  reaches zero at the target fill fraction.
- The archive replacement semantics already match the intended MAP-Elites
  contract: empty-cell insert, occupied-cell replace only on higher quality.
- The branch still honors the intended “archive as success truth” direction,
  and `success_view` is now materially closer to the original plan because it
  combines archive elites with a small bounded per-cell reservoir rather than
  being elite-only.
- Benchmark-specific phase-generation defaults now affect runtime `auto`
  resolution, which brings the implemented diff-flexibility story materially
  closer to the original intent.
- The most important remaining work is broader live validation, richer
  QD-specific operators, CVT parity, and reducing `QDEngine` loop duplication
  before the architecture hardens further.

## Roadmap Extension

This roadmap extends the original stage list with the concrete findings from
implementation and testing so far.

### Stage 3 follow-through before Stage 4

- Add a deterministic local smoke mode for `revolution_qd` using mocked or
  low-budget runtime settings so the branch has a reliable end-to-end sanity
  check even when long-context vLLM runs are slow.
- Refactor the duplicated offspring-materialization / request bookkeeping seam
  shared by `EoHEngine` and `QDEngine` into reusable helpers.
- Add configurable grid-bin loading for structural/physical grid experiments.
- Add a small completion-oriented live smoke profile for the grid runtime
  separate from the paper-grade `128k` long-context smoke profile.

### Stage 4 revision

- Keep CVT as the next major milestone, but require a shared archive interface
  that can support both:
  - grid debug axes and fixed bins
  - CVT warm-up/freeze centroids over the full descriptor space
- Add parity tests that compare shared archive behavior across grid and CVT:
  insertion semantics, quality-based replacement, exported metadata shape, and
  summary compatibility.

### Stage 5 revision

- Add `M-T` and `C-D` only after the grid runtime and archive parent-view
  semantics are stable enough to measure them meaningfully.
- Include explicit tests for how per-phase generation-mode overrides interact
  with benchmark defaults from `ProblemSpec`.
- Revisit whether diff-capable backfill should be enabled by default on larger
  benchmarks only after the runtime is actually honoring those benchmark
  defaults.

### Stage 7 revision

- Logging/reporting should now include both algorithm evidence and research
  evidence:
  - archive occupancy and QD score
  - blocked vs passed smoke status
  - descriptor profile used
  - whether the run was `grid` or `cvt`
  - whether the run was `ppa` or `functional_only`

### Stage 8 revision

- The final branch review should explicitly compare the finished branch against
  this “Original Plan Comparison Review” section, not just against the running
  checklist, so the merge decision is based on both execution and intent.

## Commit Ledger

- `32ea6f39e6` `docs(qd): bootstrap living implementation plan and worktree log`
- `e91188281b` `feat(qd): add search mode and capability scaffolding`
- `2268a7f81f` `feat(qd): add scoring and descriptor substrate`
- `efbf9b48d0` `feat(qd): add grid archive and linear scheduler substrate`
- `98db8207e4` `docs(qd): record stage 3 substrate checkpoint`
- `4a82690a1f` `feat(qd): wire grid runtime path and refresh docs`
- `fae94e617c` `docs(qd): review plan alignment and extend roadmap`
- `6c987af52a` `feat(qd): honor problem defaults and add success reservoirs`
- Stage 3 remains in progress; live-smoke closure, engine-seam cleanup, and
  grid-bin/CVT/reporting work are still pending.

## Deferred Follow-Ups

- Formal-heavy RealBench support beyond module subsets.
- Benchmark-specific descriptor studies once the core archive pipeline is
  stable.
- Additional descriptors adopted only after probe evidence justifies them.

## Smoke Commands

- Preflight:
  `curl -s http://host.docker.internal:8000/v1/models`
- Planned grid smoke:
  `python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks RTLLM --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --max_tokens 128000`
- Planned CVT smoke:
  `python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --benchmarks RTLLM --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --max_tokens 128000`
- Planned diff-heavy smoke:
  `python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --benchmarks cvdp --qd_backfill_generation_mode diff --qd_refine_generation_mode diff --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --max_tokens 128000 --diff_max_tokens 128000`
