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
- Current backend status: Stage 0 bootstrap in progress

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
- [ ] Commit Stage 1 with signed multi-line commit message.

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

- [ ] Add `QDEngine` scaffolding.
- [x] Implement `GridArchive`.
- [x] Implement linear fill/improve scheduler.
- [ ] Implement success archive insertion/replacement and `success_view`.
- [x] Add grid-specific tests.
- [ ] Run RTLLM and VerilogEval grid smokes.
- [x] Update docs and plan with Stage 3 validation notes.
- [x] Commit Stage 3.

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
- [ ] Add `src/revolution/qd/archive.py`
- [ ] Add `src/revolution/qd/scheduler.py`
- [ ] Add `src/revolution/qd/visualization.py`
- [ ] Refactor `src/revolution/algorithm.py` for shared engine seams

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
- Automated tests:
  - `/workspace/.venv/bin/python -m pytest tests/revolution/test_qd_archive.py tests/revolution/test_qd_scheduler.py tests/revolution/test_qd_descriptors.py tests/revolution/test_qd_scoring.py`
  - Result: `20 passed in 0.83s`
- Smoke tests:
  - none yet; runtime engine wiring is still pending
- Notes:
  - this is the first Stage 3 checkpoint only; the backend is not yet running
    `revolution_qd` through the grid archive end-to-end
  - first Stage 3 substrate commit:
    - `efbf9b48d0` `feat(qd): add grid archive and linear scheduler substrate`

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
- The remaining work is engine integration, parent-view semantics, and live
  smoke validation.

## Commit Ledger

- `32ea6f39e6` `docs(qd): bootstrap living implementation plan and worktree log`
- `e91188281b` `feat(qd): add search mode and capability scaffolding`
- `2268a7f81f` `feat(qd): add scoring and descriptor substrate`
- `efbf9b48d0` `feat(qd): add grid archive and linear scheduler substrate`
- Stage 3 remains in progress; runtime engine wiring and smokes are still pending.

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
