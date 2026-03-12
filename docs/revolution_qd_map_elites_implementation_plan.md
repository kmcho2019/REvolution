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
- Current stage: `Stage 8`
- Current backend scope:
  - `RTLLM`
  - `VerilogEval-Spec-to-RTL`
  - `cvdp` 1.0.2 limited to `cid002` and `cid003`
  - `RealBench` module subsets
- Current backend status: grid and initial CVT runtime paths are live with
  archive-backed success-state handling, benchmark-default phase-mode wiring, a
  bounded per-cell `success_view` reservoir, configurable grid-axis bin
  loading, frozen-scaler CVT warm-up, and initial archive-state artifact
  emission; QD operator routing, QD-aware report/archive packaging, and
  archive-history visualization are now live, and Stage 6 benchmark capability
  scaffolding for `cvdp` plus fixture-backed `RealBench` modules is now landed;
  engine seam cleanup and completion-grade live validation still remain pending

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
- Grid axis bins and bounds can be loaded from `qd_descriptor_file` under
  `grid_axes:`; unspecified axes still fall back to derived defaults.
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
- There is a separate remote GitHub branch named `realbench` intended to carry
  fuller RealBench benchmark integration plus analysis capability. It is not
  merged into `wip/journal-extension-2026` yet, so this branch keeps only the
  manifest-based Stage 6 adapter/fixture path for now.

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

- Resolved divergence: grid binning originally used only fallback bounds and
  derived bin counts instead of allowing explicit per-axis bin specs from
  config.
  Review:
  The grid runtime now accepts per-axis `grid_axes:` entries from
  `qd_descriptor_file` so structural and physical grid experiments do not have
  to rely on the old uniform fallback. This is still a lightweight config
  scheme, but it closes the main usability gap without introducing a second
  parallel config mechanism.

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
  top-level docs and immediate feature docs now reflect the current staged QD
  surface, including initial CVT runtime support and the remaining reporting/
  smoke gaps.
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
  mention the QD feature surface and now describe the current grid-plus-initial-
  CVT state instead of the older grid-only checkpoint.

Documentation risk to watch:

- These docs are directionally correct for the current branch, but they should
  be refreshed again when reporting/artifact parity, visualization outputs, and
  richer QD operator routing are added.

## Validation Workflow

- This worktree currently has no checked-in `.github/workflows/` CI definition,
  so branch validation is tracked through the local proxy checklist below.
- Required local checklist for QD feature work:
  - `pytest`
  - `ruff check` on touched files or the intentionally scoped tree
  - `python -m pyright` on touched source modules
  - vLLM `/v1/models` preflight
  - at least one bounded runtime smoke for changed LLM-backed behavior
- When repo-wide lint or typecheck debt outside the feature scope prevents a
  clean global pass, record the scoped pass result and the broader blocking debt
  explicitly instead of leaving the validation state ambiguous.

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
- [x] Add configurable grid-bin specification loading for structural/physical
      grid experiments.
- [x] Refactor the shared offspring-materialization seam duplicated between
      `EoHEngine` and `QDEngine`.
- [x] Run RTLLM and VerilogEval grid smokes to a real completion state.
- [x] Add a deterministic fast-smoke path so Stage 3 runtime validation does
      not depend only on slow long-context vLLM runs.
- [x] Update docs and plan with Stage 3 validation notes.
- [x] Commit Stage 3 checkpoints.

### Stage 4: CVT Backend With Parity Surface

- [x] Implement CVT warm-up, scaler fit, frozen centroids, and reinsertion.
- [x] Keep grid/CVT on equal footing in summary, artifacts, and tests.
- [x] Add CVT-specific tests and parity tests.
- [x] Run RTLLM and VerilogEval CVT smokes.
- [x] Update docs and plan with Stage 4 validation notes.
- [x] Commit Stage 4.

### Stage 5: QD Operators And Flexible Diff Usage

- [x] Add `M-T` and `C-D` prompts and operator routing.
- [x] Route whole/diff by explicit per-phase policy resolution.
- [x] Add operator routing tests.
- [x] Run targeted whole-heavy and diff-heavy smoke tests.
- [x] Update docs and plan with Stage 5 validation notes.
- [x] Commit Stage 5.

### Stage 6: CVDP And RealBench Module Capability Expansion

- [x] Add `cvdp` `cid002` / `cid003` capability path.
- [x] Add `RealBench` module-subset adapter and fixtures.
- [x] Gate `quality_mode=ppa` vs `functional_only` per problem.
- [x] Add tests and smokes or explicitly record blocked live smoke.
- [x] Update docs and plan with Stage 6 validation notes.
- [x] Commit Stage 6.

### Stage 7: Archive Logging, Reporting, Visualization, And Descriptor Study

- [x] Emit `archive_history.jsonl`, `archive_cells.csv`,
      `archive_summary.json`, `qd_metrics.json`, and
      `grid_layout.json` or `centroids.json`.
- [x] Add generation metrics and per-cell exports.
- [x] Add visualization outputs.
- [x] Extend archive/report packaging.
- [x] Add reporting tests.
- [x] Add visualization tests.
- [x] Run grid and CVT artifact-validation smokes.
- [x] Update docs and plan with Stage 7 validation notes.
- [x] Commit Stage 7.

### Stage 8: Full Regression, Docs, And Merge-Ready Cleanup

- [x] Run full pytest suite.
- [x] Run `ruff` on touched files and record broader repo lint debt status.
- [x] Run `pyright` on touched modules and record broader repo type-debt status.
- [x] Run `ty` on touched modules and record broader type-debt status.
- [x] Run final vLLM-backed smoke matrix and record blocked/passed status.
- [x] Perform code cleanliness and intent-alignment review.
- [x] Update top-level docs and finalize this plan incrementally as new stages
      land.
- [x] Commit Stage 8 checkpoints.

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
- [x] Add `src/revolution/qd/engine.py` follow-through cleanup for shared engine
      seams and reduced duplication
- [x] Add `src/revolution/qd/visualization.py`
- [x] Refactor `src/revolution/algorithm.py` for shared engine seams
- [x] Wire `ProblemSpec.phase_generation_defaults` into runtime `auto` phase
      resolution
- [x] Add bounded per-cell `success_view` reservoir support
- [x] Add configurable grid-bin specification loading

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
- [x] Add machine-readable physical-metric sidecars for OpenROAD-backed
      descriptor extraction parity

### Reporting

- [x] Add archive history JSONL
- [x] Add archive cells CSV
- [x] Add archive summary JSON
- [x] Add QD metrics JSON
- [x] Add grid layout / centroid output
- [x] Add grid heatmaps and CVT projection plots

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
  - this checkpoint was still grid-only; later Stage 4 work removes that
    limitation and adds initial CVT runtime support
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
  - focused grid-bin configuration validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py`
    - Result: `39 passed in 1.09s`
  - full regression rerun after Stage 3 follow-through and lint/type fixes:
    - `/workspace/.venv/bin/python -m pytest`
    - Result: `308 passed in 2.72s`
  - branch-scoped lint validation:
    - `/workspace/.venv/bin/ruff check src/revolution/algorithm.py src/revolution/backends/revolution_backend.py src/revolution/qd src/revolution/runtime tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_problem_spec.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py scripts/run_backend.py scripts/run_evolution.py`
    - Result: `All checks passed!`
  - source-scoped type validation:
    - `/workspace/.venv/bin/python -m pyright src/revolution/backends/revolution_backend.py src/revolution/qd src/revolution/runtime/problem_spec.py`
    - Result: `0 errors, 1 warning`
    - Warning detail:
      - `src/revolution/qd/descriptors.py`: `yaml` could not be resolved from source by pyright
  - broader typecheck observation:
    - `/workspace/.venv/bin/python -m pyright src/revolution scripts/run_backend.py scripts/run_evolution.py`
    - Result: blocked by pre-existing repo-wide type debt outside the current
      QD branch surface, plus environment/source-resolution warnings for some
      third-party modules
  - grid runtime now keeps a bounded per-cell reservoir for recent successful
    occupants, and `success_view` samples from archive elites plus that
    reservoir without making it a second source of truth
  - grid runtime now loads per-axis bin/bounds settings from
    `qd_descriptor_file` `grid_axes:` entries when present, with derived
    fallbacks for unspecified axes
  - live vLLM smoke evidence:
    - preflight command:
      - `curl -s http://host.docker.internal:8000/v1/models`
    - runtime smoke command:
      - `timeout 180s bash -lc 'OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --temperature 0.3 --top_p 0.95 --max_tokens 2048 --save_path /workspace/.tmp_qd_smokes/grid_smoke --no-backend_subdir'`
    - result:
      - vLLM preflight succeeded and the run started
      - the runtime smoke timed out after `180s` without a completion signal
      - smoke remains blocked, not passed
  - deterministic fast-smoke path:
    - added `scripts/run_backend_qd_smoke_vllm.sh`
    - added dry-run coverage in
      `tests/scripts/test_run_backend_qd_smoke_vllm.py`
    - the harness fixes the smoke surface to small deterministic budgets
      instead of relying only on ad hoc long-context commands
  - shared engine-seam cleanup:
    - moved offspring materialization into the shared
      `EoHEngine._materialize_offspring_batch()` helper
    - `QDEngine` now reuses that helper instead of carrying its own near-copy
      of the diff/format/materialization path
  - focused seam-cleanup validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `101 passed in 7.30s`
    - `/workspace/.venv/bin/ruff check src/revolution/algorithm.py src/revolution/qd/engine.py tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `All checks passed!`
  - reduced-budget grid smoke retry:
    - `VLLM_HOST=host.docker.internal VLLM_PORT=8000 SMOKE_TIMEOUT_S=180 SMOKE_MAX_TOKENS=256 bash scripts/run_backend_qd_smoke_vllm.sh --archive grid --suite verilogeval --policy whole-heavy`
    - result:
      - vLLM preflight succeeded
      - the run entered the problem loop
      - the bounded whole-heavy grid smoke still timed out without completion
  - Stage 3 seam-cleanup checkpoint commit:
    - `7777665902` `refactor(qd): share offspring materialization across engines`
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

### Stage 4

- Date: `2026-03-12`
- In-progress implementation:
  - added `CVTArchive` with warm-up buffering, frozen z-score scaling, relaxed
    centroid generation, warm-up reinsertion, and nearest-centroid replacement
    semantics
  - removed the `grid only` runtime guard from `QDEngine` and switched archive
    construction to backend selection (`grid` or `cvt`)
  - threaded `qd_cvt_axes`, `qd_cvt_warmup_successes`,
    `qd_descriptor_profile`, and `qd_descriptor_axes` through the revolution
    backend into `QDEngine`
  - generalized descriptor extraction in `QDEngine` so CVT axes can draw from
    gains plus any structural/physical metrics already attached to a candidate
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_archive.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py`
  - Result: `39 passed in 0.99s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `312 passed in 2.80s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd/archive.py src/revolution/qd/engine.py src/revolution/qd/__init__.py src/revolution/backends/revolution_backend.py src/revolution/algorithm.py tests/revolution/test_qd_archive.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd/archive.py src/revolution/qd/engine.py src/revolution/backends/revolution_backend.py`
  - Result: `0 errors, 0 warnings`
- Smoke tests:
  - preflight command:
    - `curl -s http://host.docker.internal:8000/v1/models`
  - CVT runtime smoke command:
    - `timeout 180s bash -lc 'OPENAI_API_KEY=${OPENAI_API_KEY:-vllm-local-placeholder} /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --qd_cvt_axes g_A g_T --qd_cvt_warmup_successes 1 --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --vllm_min_model_len 128000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --population_size 1 --num_generations 0 --num_workers 1 --temperature 0.3 --top_p 0.95 --max_tokens 1024 --save_path /workspace/.tmp_qd_smokes/cvt_smoke --no-backend_subdir'`
  - result:
    - vLLM preflight succeeded and the CVT run started
    - the runtime smoke timed out after `180s` without a completion signal
    - CVT smoke remains blocked, not passed
- Notes:
  - CVT runtime support is now real, but archive-reporting parity is still not
    implemented
  - the current runtime can reliably use gain axes in both grid and CVT mode;
    richer structural/physical axes still depend on evaluator-side metric
    plumbing that is not fully wired through the legacy `EoHEngine` path yet
  - this stage reduces a major config/runtime mismatch, but it does not close
    the remaining duplicated generation-loop seam between `EoHEngine` and
    `QDEngine`
  - first Stage 4 runtime/docs checkpoint commit:
    - `c03242b784` `feat(qd): add initial cvt archive runtime support`

### Stage 7

- Date: `2026-03-12`
- Expanded implementation checkpoint:
  - added engine-level archive artifact emission for both grid and CVT runs:
    `archive_history.jsonl`, `archive_cells.csv`, `archive_summary.json`,
    `qd_metrics.json`, and `grid_layout.json` or `centroids.json`
  - archive history now records per-generation occupancy, coverage, QD score,
    best/mean quality, replacement counts, and gain aggregates
  - added `src/revolution/qd/visualization.py` and runtime-emitted QD plots:
    `coverage_vs_generation.png`, `best_quality_vs_generation.png`,
    `qd_score_vs_generation.png`, plus final grid heatmaps or CVT projection
    plots
  - updated `scripts/backend_comparison_report.py` to ignore
    `archive_summary.json` as a per-problem summary and render a dedicated QD
    archive metrics section instead
  - updated `scripts/archive_baseline.py` to preserve QD sidecars and QD plots
    in archived summary payloads so `candidate_core` archives keep archive-state
    evidence
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_qd_archive.py tests/revolution/test_revolution_backend.py tests/scripts/test_archive_baseline.py tests/scripts/test_backend_comparison_report.py`
  - Result: `40 passed in 9.27s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `319 passed in 9.12s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd src/revolution/backends/revolution_backend.py scripts/backend_comparison_report.py scripts/archive_baseline.py tests/revolution/test_qd_engine.py tests/scripts/test_backend_comparison_report.py tests/scripts/test_archive_baseline.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd src/revolution/backends/revolution_backend.py scripts/backend_comparison_report.py scripts/archive_baseline.py`
  - Result: `0 errors, 1 warning`
    - `src/revolution/qd/descriptors.py`: `yaml` could not be resolved from source by pyright
- Smoke tests:
  - grid smoke command:
    - `timeout 240s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --qd_grid_axes g_A g_T --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --max_tokens 128000 --population_size 1 --num_generations 0 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --save_path /tmp/revolution_qd_smoke_stage7 --seed 42`
  - grid result:
    - vLLM preflight succeeded and the run entered the problem loop
    - the smoke timed out after `240s` without producing a completion signal
    - partial logs/config snapshots were written under `/tmp/revolution_qd_smoke_stage7`
  - CVT smoke command:
    - `timeout 120s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --qd_cvt_axes g_A g_P --qd_num_cells 4 --qd_cvt_warmup_successes 1 --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --max_tokens 128000 --population_size 1 --num_generations 0 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --save_path /tmp/revolution_qd_smoke_stage7_cvt --seed 42`
  - CVT result:
    - vLLM preflight succeeded and the run entered the problem loop
    - the smoke timed out after `120s` without producing a completion signal
    - partial logs/config snapshots were written under `/tmp/revolution_qd_smoke_stage7_cvt`
- Notes:
  - Stage 7 is no longer just engine-local artifact emission; report/archive
    packaging and first-pass visualization outputs are now wired through the
    runtime and script layer
  - the remaining Stage 7 gap is mostly deeper visualization coverage and
    downstream analysis polish, not basic artifact/report discovery anymore
  - live smoke evidence is still blocked rather than passed; the bounded runs
    reach vLLM preflight and enter the runner but do not complete within the
    timeout budget
  - broader repo-wide `pyright` remains red outside the touched QD/reporting
    surface; current failures are still pre-existing in
    `run_evolution.py`, `algorithm.py`, `candidate_evaluator.py`, `llm.py`,
    and other older modules, so the local validation checklist continues to use
    touched-module typechecks plus an explicit repo-debt note
  - Stage 7 reporting/visualization parity checkpoint commit:
    - `013972bfe4` `feat(qd): add reporting and visualization parity for qd runs`

### Stage 5

- Date: `2026-03-12`
- Partial implementation checkpoint:
  - added `M-T` prompt builders and prompt templates for targeted descriptor
    mutation on the success-side fill/backfill path
  - added `C-D` prompt builders and prompt templates for diverse two-parent
    archive fusion on the success-side fill/backfill path
  - fill/backfill operator routing now selects from `M-T`, `M-E`, and `C-D`
    instead of collapsing all backfill into `M-E`
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/revolution/test_defaults.py tests/scripts/test_run_backend.py tests/revolution/test_prompt_store.py`
  - Result: `40 passed in 1.00s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `317 passed in 2.69s`
  - `/workspace/.venv/bin/ruff check src/revolution/qd/engine.py src/revolution/algorithm.py tests/revolution/test_qd_engine.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/qd/engine.py`
  - Result: `0 errors, 0 warnings`
- Notes:
  - the new operators are currently localized in `QDEngine` rather than pushed
    into the classic engine, which keeps the QD-specific surface contained but
    preserves the existing engine-seam debt
  - whole/diff execution already follows explicit per-phase mode resolution in
    the QD runtime, but targeted live smoke evidence for the new operators is
    still missing
  - Stage 5 operator checkpoint commit:
    - `7cb58e1240` `feat(qd): add targeted and diverse qd operators`

### Stage 6

- Date: `2026-03-12`
- Partial implementation checkpoint:
  - enabled `revolution` in the backend registry for the existing JSONL-backed
    `cvdp` path used by `scripts/run_backend.py`
  - added `src/revolution/runtime/realbench_adapter.py` with a manifest-based
    RealBench module adapter:
    `module_manifest.json` -> problem discovery -> `ProblemContext` /
    `ProblemSpec`
  - added `--realbench_root` and `--realbench_subset module` to
    `scripts/run_backend.py`
  - fixed a legacy `EoHEngine` initialization assumption so JSONL-backed tasks
    can use `ProblemSpec.prompt_text` and `ProblemSpec.benchmark_root` instead
    of requiring on-disk `<problem>_prompt.txt` files
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_problem_spec.py tests/revolution/test_cvdp_evaluator.py tests/revolution/test_realbench_adapter.py tests/scripts/test_run_backend.py`
  - Result: `27 passed in 0.98s`
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py tests/revolution/test_realbench_adapter.py tests/revolution/test_problem_spec.py tests/scripts/test_run_backend.py`
  - Result: `39 passed in 7.03s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `319 passed in 9.12s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `324 passed in 10.80s`
  - `/workspace/.venv/bin/ruff check src/revolution/runtime/realbench_adapter.py src/revolution/runtime/__init__.py src/revolution/backends/registry.py scripts/run_backend.py tests/revolution/test_realbench_adapter.py tests/scripts/test_run_backend.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/ruff check src/revolution/runtime/realbench_adapter.py src/revolution/runtime/__init__.py src/revolution/backends/registry.py scripts/run_backend.py src/revolution/algorithm.py tests/revolution/test_realbench_adapter.py tests/revolution/test_qd_engine.py tests/scripts/test_run_backend.py`
  - Result: `All checks passed!`
  - `/workspace/.venv/bin/python -m pyright src/revolution/runtime/realbench_adapter.py src/revolution/runtime/__init__.py src/revolution/backends/registry.py`
  - Result: `0 errors, 0 warnings`
  - `/workspace/.venv/bin/python -m pyright src/revolution/algorithm.py src/revolution/runtime/realbench_adapter.py src/revolution/backends/registry.py src/revolution/runtime/__init__.py`
  - Result: broader pre-existing `algorithm.py` type debt remains; no new
    Stage 6-specific adapter errors were introduced
  - `/workspace/.venv/bin/python -m pyright src/revolution/runtime/realbench_adapter.py src/revolution/runtime/__init__.py src/revolution/backends/registry.py scripts/run_backend.py`
  - Result: `0 errors, 1 warning` (`tqdm` source-resolution warning only)
- Smoke tests:
  - CVDP smoke command:
    - `timeout 120s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks cvdp --problems cvdp_copilot_16qam_mapper_0001 --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --max_tokens 128000 --population_size 1 --num_generations 0 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --save_path /tmp/revolution_qd_stage6_cvdp --seed 42`
  - Retry smoke command:
    - `timeout 150s /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type grid --benchmarks cvdp --problems cvdp_copilot_16qam_mapper_0001 --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --max_tokens 128000 --population_size 1 --num_generations 0 --candidate_workers 0 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --save_path /tmp/revolution_qd_stage6_cvdp_retry --seed 42`
  - CVDP smoke result:
    - initial run exposed a real bug in `EoHEngine.load_problem_description()`
      for JSONL-backed tasks
    - after the fix, the run passed vLLM preflight, entered the problem loop,
      and timed out after `120s` without a completion signal
    - the retry reproduced the same behavior with a `150s` timeout
    - this is now a blocked live smoke, not an initialization failure
  - RealBench smoke result:
    - no checked-in dataset exists under `data/bench/RealBench`
    - Stage 6 therefore validates RealBench through adapter fixtures only
- Notes:
  - Stage 6 is now real at the capability layer rather than only planned:
    the runner can discover `cvdp` for `revolution` and can discover
    manifest-backed RealBench module tasks
  - RealBench runtime support is still not completion-grade because the branch
    lacks a checked-in dataset and the legacy engine still assumes benchmark
    layouts more often than the manifest adapter would prefer
  - the `ProblemSpec.prompt_text` / `benchmark_root` initialization fix is
    useful beyond Stage 6 because it reduces one class of path-coupling debt
    between the classic engine and non-file-backed benchmark formats
  - code documentation and typing review:
    - the new public adapter helpers in
      `src/revolution/runtime/realbench_adapter.py` have explicit type hints
      and short docstrings
    - Stage 6 did not eliminate older `algorithm.py` type debt, so the branch
      still relies on scoped pyright passes plus explicit debt tracking rather
      than a clean repo-wide typecheck
  - Stage 6 feature checkpoint commit:
    - `a7ca6aeedd` `feat(qd): add cvdp and realbench capability scaffolding`
  - commit-hygiene note:
    - the first stored version of the Stage 6 feature commit had literal `\\n`
      escapes in the body because the commit message was passed incorrectly
    - the commit was amended immediately, and the branch rule remains:
      always inspect `git log --format=%B` and `sed -n 'l'` before proceeding
  - RealBench integration note:
    - a separate remote GitHub branch named `realbench` is intended to carry
      fuller RealBench benchmark integration plus analysis capability
    - that branch is not merged into `wip/journal-extension-2026` yet, so the
      Stage 6 path in this branch intentionally stays at the manifest-based
      adapter plus fixture-validation level

### Stage 8

- Date: `2026-03-12`
- Incremental cleanup / validation checkpoint:
  - added `scripts/run_backend_qd_smoke_vllm.sh` as the repeatable QD smoke
    harness for `grid` / `cvt`, `rtllm` / `verilogeval`, and
    `whole-heavy` / `diff-heavy` policy shapes
  - updated `README.md`, `GUIDELINES.md`, `docs/user_guide.md`, and
    `docs/module_structure.md` so the new smoke harness and current benchmark
    status are discoverable from the top-level docs
  - cleaned stale living-plan checkboxes for already-landed reporting and
    visualization outputs
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/scripts/test_run_backend_qd_smoke_vllm.py tests/scripts/test_run_backend.py tests/revolution/test_realbench_adapter.py tests/revolution/test_qd_engine.py`
  - Result: `37 passed in 7.11s`
  - `/workspace/.venv/bin/python -m pytest`
  - Result: `325 passed in 9.08s`
  - `/workspace/.venv/bin/ruff check tests/scripts/test_run_backend_qd_smoke_vllm.py`
  - Result: `All checks passed!`
  - attempted broad lint command on markdown/shell files:
    - Result: invalid signal; `ruff` was pointed at non-Python files and
      produced parser noise
    - follow-up action: keep `ruff` scoped to Python paths and record shell/doc
      validation separately
- Smoke tests:
  - dry-run matrix command:
    - `VLLM_HOST=host.docker.internal VLLM_PORT=8000 bash scripts/run_backend_qd_smoke_vllm.sh --archive matrix --suite verilogeval --policy diff-heavy --dry-run`
  - dry-run result:
    - printed stable `grid` and `cvt` commands using
      `/workspace/.venv/bin/python`
    - confirmed fixed archive-mode, benchmark, and diff-heavy policy wiring
  - bounded live matrix command:
    - `VLLM_HOST=host.docker.internal VLLM_PORT=8000 SMOKE_TIMEOUT_S=60 bash scripts/run_backend_qd_smoke_vllm.sh --archive matrix --suite verilogeval --policy diff-heavy`
  - bounded live matrix result:
    - vLLM preflight succeeded for both archive modes
    - grid entered the runner and timed out under the harness timeout
    - CVT entered the runner and timed out under the harness timeout
    - the final smoke matrix was executed and is now repeatable, but it still
      remains blocked rather than passed
- Review notes:
  - code cleanliness:
    - the new smoke harness removes some validation sprawl by centralizing the
      live QD smoke surface into one maintained script instead of more ad hoc
      shell history
    - the main remaining architectural debt is still the duplicated
      `EoHEngine` / `QDEngine` loop seam, not the smoke tooling
  - intent alignment:
    - the branch is now more aligned with the original plan's validation story
      because the smoke matrix is explicit and reproducible
    - the branch still cannot claim completion-grade live validation because
      the bounded grid/CVT matrix does not finish on the shared endpoint yet
  - Stage 8 feature checkpoint commit:
    - `5c669d1c1f` `feat(qd): add repeatable vllm smoke harness`

### Stage 3/4/5/8 follow-through

- Date: `2026-03-12`
- Regression fix discovered by live experimentation:
  - larger VerilogEval comparison runs exposed a classic-mode bug where
    `EoHEngine` was incorrectly selecting QD-only success strategies and could
    crash with `KeyError: 'M-T'`
  - fixed by splitting classic success strategies from QD success strategies
    and restoring the full QD set inside `QDEngine`
  - focused validation after the fix:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `103 passed in 7.35s`
    - `/workspace/.venv/bin/ruff check src/revolution/algorithm.py src/revolution/qd/engine.py tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `All checks passed!`
- Completion-grade live smokes now pass for both archive backends and both
  benchmark suites under bounded accelerated settings:
  - VerilogEval grid:
    `Prob001_zero`, `population_size=1`, `num_generations=0`,
    `evaluation_mode=search_accelerated`, `accelerated_synthesis_top_k=1`,
    `max_tokens=128`, completed in `53.85s`
  - VerilogEval CVT: same budget, completed in `70.51s`
  - RTLLM grid:
    `Prob001_accu`, same budget, completed in `70.52s`
  - RTLLM CVT: same budget, completed in `127.21s`
- Targeted phase-routing smokes also now complete:
  - grid whole-heavy on `VerilogEval-Spec-to-RTL/Prob001_zero` with
    `population_size=1`, `num_generations=1`, `max_tokens=128`,
    completed in `273.61s`
  - CVT diff-heavy on the same problem with `population_size=1`,
    `num_generations=1`, `max_tokens=128`, completed in `331.56s`
- Larger short-budget comparative runs completed for both suites:
  - RTLLM `Prob045_alu`: classic, grid, and CVT all completed in roughly
    `285-290s`
  - VerilogEval `Prob030_popcount255`: classic, grid, and CVT all completed in
    roughly `404-406s`
- Empirical findings from those larger runs:
  - all three modes failed on both larger problems under the short-budget
    setting (`population_size=1`, `num_generations=1`, `max_tokens=256`)
  - in both QD modes the archive remained empty (`occupied_cells=0`,
    `coverage=0.0`, `qd_score=0`) even though archive artifacts were emitted
  - the dominant blockers were prompt/response robustness rather than archive
    semantics:
    - empty Gen1 completions from the shared vLLM endpoint
    - truncated whole-mode JSON/code payloads on larger VerilogEval prompts
    - feedback responses that did not contain a parsable JSON object
  - conclusion: the branch is now completion-grade for smoke validation, but
    the short-budget experiments are not evidence of meaningful QD search
    performance on harder problems
- Practical implication for future runs:
  - keep the low-budget smoke profile for CI-like reachability checks
  - use materially larger completion budgets than `128-256` tokens for harder
    RTLLM/VerilogEval experiments if archive occupancy is the goal
- Additional typecheck evidence:
  - `/workspace/.venv/bin/python -m pyright src/revolution/algorithm.py src/revolution/qd/engine.py`
  - Result: existing `algorithm.py` type debt remains on heterogeneous
    synthesis-result dictionaries, optional prompt-override containers, and
    generic strategy bookkeeping
  - `uv tool run ty check src/revolution/algorithm.py src/revolution/qd/engine.py tests/revolution/test_algorithm.py`
  - result: the new strategy split does not introduce a targeted `ty` failure,
    but `algorithm.py` still has substantial pre-existing `ty` diagnostics
    around heterogeneous synthesis-result dictionaries, optional override
    containers, and generic strategy bookkeeping
  - `uv tool run ty` also surfaces transient environment-resolution issues for
    some third-party and test imports when run from the tool sandbox
- OpenROAD metrics sidecar follow-through:
  - `src/revolution/evaluation.py` now emits `physical_metrics` and
    `metrics_sidecar_path` from the legacy synthesis evaluator
  - the sidecar is written as `<report_base>_synthesis_report.metrics.json`
    beside the existing `.rpt` and `.ppa` files
  - current guaranteed coverage is lightweight but real:
    - `utilization` is parsed from the OpenROAD report text when present
    - regex hooks for `wirelength`, `cts_buffer_count`,
      `repair_buffer_count`, and `hold_buffer_count` now exist and will emit
      values if the report contains those metrics
  - focused validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_evaluation.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_candidate_evaluator_parity.py`
    - Result: `43 passed in 1.82s`
    - `/workspace/.venv/bin/ruff check src/revolution/evaluation.py tests/revolution/test_evaluation.py`
    - Result: `All checks passed!`
    - `/workspace/.venv/bin/python -m pyright src/revolution/evaluation.py`
    - Result: `0 errors, 0 warnings`
- Shared-engine seam follow-through:
  - `src/revolution/algorithm.py` now owns shared helpers for:
    - logger initialization
    - generation-stat logging and LLM usage reset
    - run-summary finalization
  - `src/revolution/qd/engine.py` now reuses those helpers instead of carrying
    separate near-copy logger/finalization code
  - the generation policies still remain intentionally separate between classic
    REvolution and `revolution_qd`; the cleanup goal here was to remove shared
    plumbing duplication without forcing the two generation loops into one
    abstraction
  - focused validation:
    - `/workspace/.venv/bin/python -m pytest tests/revolution/test_algorithm.py tests/revolution/test_qd_engine.py tests/revolution/test_revolution_backend.py tests/scripts/test_run_backend.py`
    - Result: `103 passed in 7.28s`
    - `/workspace/.venv/bin/ruff check src/revolution/algorithm.py src/revolution/qd/engine.py tests/revolution/test_algorithm.py`
    - Result: `All checks passed!`
    - `/workspace/.venv/bin/python -m pyright src/revolution/algorithm.py src/revolution/qd/engine.py`
    - Result: still blocked by older `algorithm.py` typing debt, but the seam
      extraction itself did not add a new failure class

### Moderate-budget RTLLM / VerilogEval experiment follow-through

- Date: `2026-03-12`
- Experiment goal:
  - move beyond reachability smokes and test whether classic `revolution`,
    `revolution_qd --qd_archive_type grid`, and
    `revolution_qd --qd_archive_type cvt` can produce successful candidates and
    non-empty archives on relatively larger PPA-relevant tasks
- Experimental command shape:
  - model:
    `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b`
  - common settings:
    `population_size=8`, `num_generations=3`, `num_workers=2`,
    `evaluation_mode=search_accelerated`, `accelerated_synthesis_top_k=1`,
    `temperature=0.4`, `top_p=0.95`, `max_tokens=1024`,
    `diff_max_tokens=1024`, `--seed 42`
  - RTLLM problem set:
    `Prob043_RAM`, `Prob045_alu`
  - VerilogEval problem set:
    `Prob153_gshare`, `Prob156_review2015_fancytimer`
  - QD axes:
    - RTLLM grid/CVT: `g_A`, `g_T`
    - VerilogEval grid/CVT: `g_A`, `g_P`
- Current experiment evidence captured from `/tmp/qd_midbatch/...` artifacts:
  - RTLLM `Prob043_RAM`:
    - classic:
      - `3` generation-log rows observed
      - max observed `best_score=0.2366190815`
      - total successful candidates observed: `4`
    - grid:
      - `2` generation-log rows observed
      - archive summary:
        `occupied_cells=1`, `coverage=0.0625`, `qd_score=0.2366190815`
      - total successful candidates observed: `6`
      - generated plots are non-empty and readable:
        `coverage_vs_generation.png`, `best_quality_vs_generation.png`,
        `qd_score_vs_generation.png`, `grid_occupancy_heatmap.png`,
        `grid_quality_heatmap.png`, `grid_g_P_heatmap.png`,
        `grid_g_A_heatmap.png`, `grid_g_T_heatmap.png`
    - CVT:
      - `2` generation-log rows observed
      - archive summary:
        `occupied_cells=2`, `coverage=0.125`, `qd_score=0.4633680699`
      - archive cells show one initial elite and one Gen1 `M-E` occupant in a
        second centroid cell
      - generated plots are non-empty and readable:
        `coverage_vs_generation.png`, `best_quality_vs_generation.png`,
        `qd_score_vs_generation.png`, `cvt_quality_projection.png`,
        `cvt_g_P_projection.png`, `cvt_g_A_projection.png`,
        `cvt_g_T_projection.png`
  - RTLLM `Prob045_alu`:
    - classic, grid, and CVT all remained dominated by `failed_format`
    - observed archive occupancy stayed at `0` for both QD modes
    - no meaningful visualization content was produced beyond empty/default
      archive outputs
  - VerilogEval `Prob153_gshare` and `Prob156_review2015_fancytimer`:
    - classic, grid, and CVT were all dominated by `failed_format` already in
      Gen0 under the `1024`-token budget
    - observed archive occupancy stayed at `0` for both QD modes
    - no useful plots were generated because no successful occupants reached
      the archive
- Key empirical conclusions:
  - QD-style evolution is working mechanically on at least one larger RTLLM
    task:
    `Prob043_RAM` produced successful archive fill under both grid and CVT, and
    CVT filled more cells (`2`) than grid (`1`) under the same short budget
  - QD is not yet robust on harder arithmetic / control-heavy tasks at this
    budget:
    `Prob045_alu`, `Prob153_gshare`, and `Prob156_review2015_fancytimer` all
    collapsed before the archive could meaningfully populate
  - the dominant blocker is response-format robustness, not archive geometry:
    representative `code_format_error.json` files show truncated/unclosed JSON
    envelopes and incomplete `code` payloads from the model
  - whole-mode prompt size plus `max_tokens=1024` is not enough for the larger
    VerilogEval tasks and is marginal even for larger RTLLM problems
- Implementation issues exposed by the experiments:
  - QD artifact drift:
    - before the fix, `archive_history.jsonl` stayed empty after a successful
      initial population because only evolved generations appended snapshots
    - before the fix, `qd_metrics.json` omitted the top-level occupancy/quality
      fields and only stored `history` plus `visualization_files`
    - fixed in `src/revolution/qd/engine.py` by recording an initial snapshot
      immediately after `initialize_population()` and by promoting the latest
      headline archive metrics into `qd_metrics.json`
    - focused validation after the fix:
      - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_engine.py`
      - Result: `17 passed in 9.88s`
      - `/workspace/.venv/bin/ruff check src/revolution/qd/engine.py tests/revolution/test_qd_engine.py`
      - Result: `All checks passed!`
      - `uv tool run ty check src/revolution/qd/engine.py`
      - Result: `All checks passed!`
  - runner shutdown debt:
    - interrupting long `run_backend.py` multiprocessing runs still leaves a
      noisy `KeyboardInterrupt` / pool-cleanup traceback
    - this does not invalidate experiment artifacts, but it should be treated
      as runner cleanup debt rather than ideal behavior
- Practical recommendations based on the experiment:
  - keep the `population_size=1`, `num_generations<=1`, `max_tokens=128`
    profile for CI-like reachability checks
  - for meaningful RTLLM / VerilogEval QD experiments on larger designs,
    increase `max_tokens` well beyond `1024` and consider diff-heavy defaults
    where the benchmark/problem size justifies them
  - use `Prob043_RAM` as the current positive regression example for archive
    fill and `Prob045_alu` plus `Prob153_gshare` as robustness regressions for
    prompt/response format stability

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
- The current grid runtime now exposes both a bounded per-cell reservoir and a
  lightweight grid-bin specification loading path. The remaining gap is not
  configurability itself, but broader archive parity, reporting, and CVT
  geometry support.
  - The `ProblemSpec` phase-default data model is now consumed by `QDEngine`, but
  the resolution logic still lives only in the QD engine rather than behind a
  shared reusable helper. That is acceptable for now, but it is still a seam
  to watch if classic and QD mode continue to diverge in prompt routing.
- New QD helpers added in this branch now have type hints and short docstrings
  for the public descriptor/grid-spec surface, but the broader repo still has
  uneven docstring/type coverage in older modules.
- Physical descriptor plumbing is now better grounded because the legacy
  synthesis evaluator emits a machine-readable metrics sidecar and returns
  `physical_metrics`. The remaining gap is metric richness, not total absence:
  utilization is reliable now, while deeper OpenROAD metrics still depend on
  what the report text exposes.
- The Stage 3 smoke gate is now satisfied. Minimal accelerated grid runs on
  RTLLM and VerilogEval complete end-to-end; the remaining Stage 3 debt is
  architectural cleanup, not runtime reachability.

### Stage 4

- CVT archive logic now lives behind the same archive-selection surface as
  grid, which removes an obvious config/runtime mismatch from the branch.
- The CVT implementation deliberately keeps scaling frozen after warm-up. That
  matches the original intent and avoids archive-geometry drift.
- The main remaining debt is still architectural rather than geometric:
  `QDEngine` duplicates request/materialization flow that should eventually be
  shared with `EoHEngine`.
- Descriptor richness remains partly aspirational in the runtime path. The
  archive can consume structural or physical axes, but the legacy engine path
  still surfaces gains more reliably than deeper synthesis-derived metrics.
- The Stage 4 smoke gate is now satisfied under bounded accelerated settings.
  The remaining Stage 4 gap is usefulness on harder runs, not basic CVT
  execution.

### Stage 7

- The engine now emits the baseline archive-state files without requiring the
  reporting scripts to infer archive shape from legacy summaries.
- The reporting and archive-packaging scripts now consume the new files as
  first-class inputs, which closes the earlier `archive_summary.json`
  double-counting bug and prevents `candidate_core` archives from silently
  dropping QD sidecars or plots.
- The new visualization module is intentionally lightweight and runtime-local.
  That is a good first step, but it adds another place where plotting logic now
  exists, so future cleanup should decide whether QD-specific visualization
  stays engine-local or gets moved behind a broader reporting interface.
- The largest remaining debt is still the `EoHEngine` / `QDEngine` seam rather
  than artifact plumbing.

### Stage 5

- The new QD operators are intentionally implemented inside `QDEngine` to keep
  QD-specific prompt logic from spreading further into the legacy engine.
- This is a pragmatic debt tradeoff: the branch gains the missing operator
  semantics now, but the duplicated engine/prompt seam remains and still needs
  cleanup before the architecture is considered clean.
- The Stage 5 whole-heavy and diff-heavy smoke requirement is now satisfied,
  but those runs should be treated as routing validation rather than evidence
  of QD quality improvement because the archives stayed empty under short
  token budgets.

### Stage 6

- The new RealBench adapter is intentionally manifest-based and lightweight.
  That keeps the branch independent of a vendored dataset, but it also means
  some benchmark semantics now live in a side manifest contract that must stay
  documented if the dataset is added later.
- The `ProblemSpec.prompt_text` / `benchmark_root` initialization fix reduces a
  real engine-coupling bug for JSONL-backed tasks, but it also highlights the
  broader seam debt: `EoHEngine` still assumes standard benchmark layouts in
  several deeper paths besides prompt loading.
- `revolution` now supports the `cvdp` discovery path, which matches the plan,
  but the live smoke still times out before giving strong end-to-end evidence.
- The Stage 6 code itself is documented and typed at the public-helper level,
  but the branch still does not have uniform docstring/type coverage in the
  older engine modules, especially around `algorithm.py`.

### Stage 8

- The new smoke harness is a cleanup win because it replaces scattered
  one-off smoke commands with one script and one dry-run test.
- The branch still carries the bigger unresolved debt:
  `QDEngine` still duplicates some higher-level request-bookkeeping and
  generation-loop behavior, even though the lower-level offspring
  materialization seam is now shared with `EoHEngine`.
- Validation debt is now explicit rather than vague: the matrix is runnable and
  reproducible.
- The completion-grade bounded smoke gap is now closed.
- The remaining validation gap is quality-oriented: on harder RTLLM and
  VerilogEval problems with short budgets, classic, grid, and CVT all still
  fail before generating successful archive occupants.

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
- Grid experiments are now materially closer to the original intent because
  structural and physical axes can carry explicit bin/bounds settings from the
  descriptor config file instead of relying only on uniform gain-axis defaults.
- The most important remaining work is broader live validation, richer
  QD-specific operators, CVT parity, and reducing `QDEngine` loop duplication
  before the architecture hardens further.

### Stage 4

- The branch is now closer to the original intent because both `grid` and
  `cvt` exist as real runtime archive choices instead of one being config-only.
- The CVT warm-up/freeze implementation is aligned with the original plan's
  requirement to avoid moving cell boundaries throughout the run.
- The branch still has an intent gap around descriptor realism: the design
  allows structural/physical axes, but the end-to-end runtime still needs
  better evaluator-side metric plumbing before those axes are equally strong in
  live runs.
- The remaining divergence is therefore acceptable but explicit: CVT geometry
  is implemented, while reporting parity and richer descriptor/evaluator
  integration remain staged follow-through.

### Stage 7

- The branch now partially satisfies the original “archive evolution as a
  first-class output” goal because raw archive-state files are emitted from the
  runtime itself.
- The branch is now much closer to the original intent because downstream
  consumption has caught up: comparison reports, baseline archives, and runtime
  plots now treat the QD sidecars as primary artifacts.
- The remaining intent gap is validation and breadth rather than core design:
  the new outputs exist, but the branch still needs successful live smoke
  completion, broader benchmark coverage, and deeper visualization/reporting
  polish before the feature can be called complete.

### Stage 5

- The branch is now materially closer to the original intent because fill-phase
  QD search no longer relies only on generic exploration; it has explicit
  targeted mutation and diverse fusion operators.
- The remaining intent gap is validation, not architecture: the operators are
  present and routed, but the branch still lacks live smoke evidence showing
  them behaving well on long-context runs.

### Stage 6

- The branch is now closer to the original benchmark-scope intent because
  `revolution_qd` can participate in the existing `cvdp` subset path and a
  concrete RealBench module adapter contract exists.
- The RealBench part is still intentionally partial: fixture-backed adapter
  coverage exists, but no checked-in dataset means the branch cannot yet claim
  live RealBench execution evidence.
- The CVDP smoke progression is meaningful: the branch moved from an immediate
  prompt-path crash to a live run that reaches the problem loop before timing
  out. That is still not completion-grade, but it is an appropriate direction
  of travel rather than a divergence from the original plan.

### Stage 8

- The validation workflow is now closer to the original intent because there is
  a concrete repeatable QD smoke matrix rather than only hand-written example
  commands in the plan.
- The remaining gap is practical rather than conceptual: the smoke matrix runs
  against the real shared vLLM endpoint, but the jobs still time out before the
  branch can claim completion-grade live success evidence.

## Roadmap Extension

This roadmap extends the original stage list with the concrete findings from
implementation and testing so far.

### Stage 3 follow-through before Stage 4

- Continue reducing the remaining request-bookkeeping / generation-loop seam
  still duplicated between `EoHEngine` and `QDEngine` now that offspring
  materialization is shared.
- Keep the small completion-oriented live smoke profile for the grid runtime
  separate from the paper-grade `128k` long-context smoke profile.
- Reduce branch-local pyright noise further where fixes are low-risk, while
  keeping broader pre-existing repo-wide type debt explicitly tracked instead of
  hiding it behind narrow command scopes.
- Use the larger `RTLLM/Prob045_alu` and
  `VerilogEval-Spec-to-RTL/Prob030_popcount255` short-budget runs as the
  branch's current regression pair for prompt/runtime robustness.

### Stage 4 revision

- Initial CVT runtime support is now landed. The next Stage 4 follow-through is
  parity work:
  - shared reporting/artifact emission across grid and CVT
  - archive metadata export for centroids/scaler state
  - better success-side evidence on harder runs, not just completion evidence
- Keep parity tests that compare shared archive behavior across grid and CVT:
  insertion semantics, quality-based replacement, exported metadata shape, and
  summary compatibility.
- Moderate-budget evidence now shows that CVT can out-fill grid on
  `RTLLM/Prob043_RAM` under the same short budget (`2` occupied cells vs `1`),
  so CVT should remain in the default paper path rather than being treated as a
  visualization-only backend.

### Stage 5 revision

- Add `M-T` and `C-D` only after the grid runtime and archive parent-view
  semantics are stable enough to measure them meaningfully.
- Include explicit tests for how per-phase generation-mode overrides interact
  with benchmark defaults from `ProblemSpec`.
- Revisit whether diff-capable backfill should be enabled by default on larger
  benchmarks only after the runtime is actually honoring those benchmark
  defaults.
- Treat low-budget operator smokes as routing validation only. Do not use them
  as evidence of archive or PPA improvement until longer-budget runs produce
  successful candidates.
- The moderate-budget experiments reinforce that recommendation: larger
  VerilogEval control/FSM tasks still fail mostly at the response-format layer
  before operator choice matters, so prompt/output robustness is the next
  limiting factor there.

### Stage 7 revision

- Logging/reporting should now include both algorithm evidence and research
  evidence:
  - archive occupancy and QD score
  - blocked vs passed smoke status
  - descriptor profile used
  - whether the run was `grid` or `cvt`
  - whether the run was `ppa` or `functional_only`
- The next Stage 7 follow-through should focus on:
  - adding more complete visualization coverage for per-metric archive views
  - deciding whether QD plot generation should remain runtime-local or move
    into a reusable reporting layer
  - ensuring archive packaging and comparison reports can surface the new plot
    files without manual inspection

### Stage 8 revision

- The final branch review should explicitly compare the finished branch against
  this “Original Plan Comparison Review” section, not just against the running
  checklist, so the merge decision is based on both execution and intent.
- Add `ty` to the merge-readiness checklist alongside `pytest`, `ruff`, and
  focused `pyright`, with any remaining diagnostics explicitly separated into
  QD-branch debt, older repo-wide debt, and transient tool-environment import
  issues.
- Keep a documented “research-budget” recommendation beside the smoke
  checklist:
  `max_tokens=1024` is enough to find archive-fill signal on some RTLLM tasks
  (`Prob043_RAM`), but it is not enough to draw negative conclusions on larger
  arithmetic or VerilogEval control problems because response truncation
  dominates before archive search can express itself.

## Commit Ledger

- `675d2fbc4d` `fix(qd): record initial archive snapshots and experiment findings`
- `32ea6f39e6` `docs(qd): bootstrap living implementation plan and worktree log`
- `e91188281b` `feat(qd): add search mode and capability scaffolding`
- `2268a7f81f` `feat(qd): add scoring and descriptor substrate`
- `efbf9b48d0` `feat(qd): add grid archive and linear scheduler substrate`
- `98db8207e4` `docs(qd): record stage 3 substrate checkpoint`
- `4a82690a1f` `feat(qd): wire grid runtime path and refresh docs`
- `fae94e617c` `docs(qd): review plan alignment and extend roadmap`
- `6c987af52a` `feat(qd): honor problem defaults and add success reservoirs`
- `dc62a11c2b` `docs(qd): document single sign-off commit rule`
- `d5a7176628` `feat(qd): add configurable grid-axis bin loading`
- `ed3e933f61` `chore(qd): record validation status and clean branch typing`
- `c03242b784` `feat(qd): add initial cvt archive runtime support`
- `855472eb70` `docs(qd): record stage 4 cvt checkpoint`
- `013972bfe4` `feat(qd): add reporting and visualization parity for qd runs`
- `8b0393d10e` `feat(qd): emit archive-state artifacts for qd runs`
- `7cb58e1240` `feat(qd): add targeted and diverse qd operators`
- `a7ca6aeedd` `feat(qd): add cvdp and realbench capability scaffolding`
- `3947e578df` `docs(qd): record stage 6 capability checkpoint`
- `5c669d1c1f` `feat(qd): add repeatable vllm smoke harness`
- `7777665902` `refactor(qd): share offspring materialization across engines`
- Bounded grid/CVT smoke closure is now complete.
- The main remaining debt is engine-seam cleanup and broader `algorithm.py`
  type cleanup rather than basic runtime reachability.

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
- Repeatable QD smoke harness:
  `bash scripts/run_backend_qd_smoke_vllm.sh --archive matrix --suite verilogeval --policy diff-heavy`
