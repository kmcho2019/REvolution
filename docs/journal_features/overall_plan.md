# REvolution Journal Extension Overall Plan

## Purpose

This document is the implementation hub for the REvolution journal extension.
It tracks the transition from the ASP-DAC 2026 conference code to a journal
version with a cleaner thought-centric QD/MAP-Elites runtime, modular behavior
descriptors, multiobjective archives, and ablation-friendly configuration.

The current `revolution_qd` path is an experimental draft. It can be refactored
in place. Classic `search_mode=revolution` remains the conference-version
baseline for comparisons, but the current QD internals do not need a
compatibility layer.

This plan is based on the current state of the
`/workspace/.worktrees/qd-theory-grounded-descriptors` worktree on branch
`feat/qd-theory-grounded-descriptors`. The journal features should build on
that branch's descriptor registry, graph/testability descriptor work,
hard-subset analysis harnesses, QD artifact/reporting surfaces, and existing
grid/CVT archive draft rather than on the older main checkout alone.

Initial target: `2026-05-12`

## Journal Design Locks

These decisions come from the journal-extension brainstorm and should stay
stable while the first implementation lands.

- The evolvable object is a thought-level hardware design idea. Code is an
  evaluation sample, not the genotype. This avoids code anchoring, surface-form
  duplicates, and code-specific feedback becoming the mutation target.
- k-code evaluation estimates thought quality by sampling multiple RTL
  realizations from the same thought. The first implementation uses the best
  successful code as the representative artifact and records success rate for
  analysis.
- MAP-Elites supplies the diversity pressure. Parent selection in the journal
  path should be uniform over behavior cells and then uniform over Pareto-front
  members, not fitness-proportional.
- PPA scalar quality remains useful for legacy comparison, representative-code
  selection, and post-hoc reports. It should not drive multiobjective archive
  replacement after Pareto-front archive support lands.
- RTL design diversity is defined as architecture depth, temporal scheduling
  depth, and spatial allocation width. The descriptor trio maps those concepts
  to `logic_depth`, `ff_depth`, and `comb_width_log`.
- The first archive geometry is a quantile adaptive grid. KS-triggered
  re-binning is deliberately later because it needs stable answers for recent
  samples, archive members, and Pareto-front rebuild semantics.
- The journal operator is a single thought-generation prompt with one or two
  parent thoughts. The prompt must not include parent code, individual feedback,
  or code-level error logs.

## Deferred Or Out Of Scope For This Pass

- Learned or encoder-based descriptors inspired by AURORA, VQ-Elites, or
  AutoQD are deferred. The first pass should leave a clean descriptor-profile
  seam, not implement learned behavior spaces.
- CVT and high-dimensional learned behavior spaces are deferred for journal
  ablations after the 3D adaptive grid is stable.
- Failure-pattern summaries are allowed as a future descriptive context, but
  the first two-tier fail-pool implementation should work without an LLM summary
  loop.
- PPA islands are deferred. Pareto fronts per cell are the first
  multiobjective mechanism because they preserve PPA trade-offs without
  splitting budget across islands.

## Current Code Seams

- `src/revolution/qd/descriptors.py` owns descriptor profiles, descriptor
  registry resolution, and descriptor requirements.
- `src/revolution/runtime/candidate_evaluator.py` already collects structural,
  RTL, dynamic, graph, physical, score-component, and descriptor-value payloads.
- `src/revolution/qd/archive.py` has fixed `GridArchive` behavior, CVT warmup
  behavior, and `grid_quantile` as the static quantile archive for Phase 02.
- `src/revolution/qd/engine.py` currently owns QD strategy routing, archive
  insertion, success/fail pools, and artifact snapshots. The journal path should
  simplify this rather than preserve every experimental QD mode.
- `src/revolution/algorithm.py` still models `Heuristic` as thought, code,
  feedback, status, score, and artifacts together. Thought-only work should
  introduce a narrower journal runtime object rather than expanding
  `Heuristic`.
- `src/revolution/qd/artifacts.py`, `src/revolution/qd/visualization.py`, and
  report scripts currently assume one archive entry per cell in several places.
  Pareto-front work must update those assumptions.

## Feature Specs

| Feature | Status | Deadline | Spec | Notes |
| --- | --- | --- | --- | --- |
| BD trio: logic depth, FF depth, width | Planned | 2026-05-03 | [01_bd_trio.md](01_bd_trio.md) | First because it is mostly additive and gives the archive stable axes. |
| Initial QD binning: static quantile grid | Planned | 2026-05-04 | [02_quantile_binning.md](02_quantile_binning.md) | Adds the first journal archive geometry before dynamic re-binning. |
| Pareto-front archive / multiobjective MAP-Elites | Planned | 2026-05-06 | [03_pareto_front_archive.md](03_pareto_front_archive.md) | Replaces one elite per cell with bounded PPA fronts. |
| Two-tier archive + fail handling | Planned | 2026-05-07 | [04_two_tier_fail_pool.md](04_two_tier_fail_pool.md) | Makes success archive and fail pool explicit parent sources. |
| Single thought mutation operator | Planned | 2026-05-08 | [05_single_mutation_operator.md](05_single_mutation_operator.md) | Removes QD strategy-bandit routing from the journal path. |
| Thought-only individuals + k-code evaluation | Planned | 2026-05-10 | [06_thought_only_k_code.md](06_thought_only_k_code.md) | Splits thought evolution from code sampling. |
| KS-triggered re-binning + reporting polish | Planned | 2026-05-12 | [07_ks_adaptive_rebinning.md](07_ks_adaptive_rebinning.md) | Last because it depends on stable thought/archive semantics. |

## Core Feature Checklist

Initial target: 2026-05-12

- [ ] 1. BD trio: logic depth, FF depth, width - target 2026-05-03
- [ ] 2. Initial QD binning: static quantile grid - target 2026-05-04
- [ ] 3. Pareto-front archive / multiobjective MAP-Elites - target 2026-05-06
- [ ] 4. Two-tier archive + fail handling - target 2026-05-07
- [ ] 5. Single thought mutation operator - target 2026-05-08
- [ ] 6. Thought-only individuals + k-code evaluation - target 2026-05-10
- [ ] 7. KS-triggered re-binning + reporting polish - target 2026-05-12

## Roadmap And ETA

### 1. BD = Logic Depth x FF Depth x Width

Target deadline: `2026-05-03`

- [ ] 1.1 Add exact descriptor names and config profile
  `journal_logic_ff_width_3d`.
- [ ] 1.2 Implement post-synthesis graph extraction for `logic_depth`,
  `ff_depth`, and `comb_width_log`.
- [ ] 1.3 Wire descriptors into `CandidateEvaluator`, QD descriptor registry,
  descriptor probe, and focused tests.

### 2. QD/MAP-Elites Binning, Initial Quantile Grid

Target deadline: `2026-05-04`

- [ ] 2.1 Add new `grid_quantile` mode with fixed 25/50/75 quantile
  boundaries and four intended bins per axis.
- [ ] 2.2 Initialize bin edges from initial warmup successful descriptor samples
  using per-axis quantiles.
- [ ] 2.3 Support quantile collapse, such as a combinational design producing
  one effective FF-depth bin, and test assignment/rebuild behavior.

KS-triggered re-binning is delayed until thought-only individuals, k-code
evaluation, and Pareto-front archive semantics are implemented.

### 3. Pareto-Front Per Cell, Multiobjective MAP-Elites

Target deadline: `2026-05-06`

- [ ] 3.1 Replace a single archive entry per cell with bounded front members.
- [ ] 3.2 Implement PPA-only dominance over active objectives, accounting for
  combinational designs.
- [ ] 3.3 Add NSGA-II crowding-distance eviction, preserve PPA extremes, parent
  sampling from fronts, and artifact/report updates.

### 4. Two-Tier Archive And Fail Pool

Target deadline: `2026-05-07`

- [ ] 4.1 Make success archive and fail pool the two explicit parent sources.
- [ ] 4.2 Implement adaptive source probability from pool sizes.

### 5. Single Mutation Operator

Target deadline: `2026-05-08`

- [ ] 5.1 Remove QD strategy-bandit routing from `revolution_qd`.
- [ ] 5.2 Add one prompt path for generating a new design strategy with one or
  two parent thoughts.
- [ ] 5.3 Verify prompts contain no parent code and no individual feedback.

### 6. Thought-Only Individuals And k Codes Per Thought

Target deadline: `2026-05-10`

- [ ] 6.1 Add simple typed runtime objects for thought individuals, code
  samples, and thought evaluations.
- [ ] 6.2 Split thought generation from code generation.
- [ ] 6.3 Generate `k=4` code samples per thought and evaluate each sample with
  the existing evaluator.
- [ ] 6.4 Aggregate thought evaluation: best successful code chooses BD/code
  artifact, success rate is recorded, and all-fail thoughts enter the fail
  pool.

### 7. KS-Triggered Re-Binning And Final Integration

Target deadline: `2026-05-12`

- [ ] 7.1 Store recent offspring descriptor windows.
- [ ] 7.2 Add KS test trigger with Bonferroni threshold and cooldown.
- [ ] 7.3 Rebuild quantile bins from archive members only, then reinsert all
  Pareto members.
- [ ] 7.4 Finish docs, config snapshots, report updates, and full validation.

## Testing Policy

- Run focused `pytest` for each feature spec before marking its checklist
  complete.
- Run `ruff check` on touched files.
- Run `python -m pyright` on touched source modules.
- Run final full `pytest` before merging the journal runtime change set.
- Run one bounded QD smoke after runtime work lands.
- Record blocked smoke results explicitly when model, vLLM, EDA, or benchmark
  endpoints are unavailable.

## Final Validation Checklist

- [ ] Focused tests passed for all seven feature specs.
- [ ] Full `pytest` passed, or remaining failures are documented as pre-existing
  and unrelated.
- [ ] `ruff check` passed on touched files.
- [ ] `python -m pyright` passed on touched source modules, or existing type
  debt is documented.
- [ ] Bounded QD smoke completed, or the blocker is documented with endpoint
  status.
- [ ] User-facing docs and run-config examples are updated.
- [ ] Archive/report artifacts are documented and manually spot-checked.

## Implementation Rules

- Keep code simple, skimmable, and direct.
- Minimize possible states by reducing argument count and narrowing state.
- Use discriminated unions for archive, config, and operator variants.
- Exhaustively handle objects with multiple possible types; fail on unknown
  type.
- Do not write defensive fallback code when the types say a value exists.
- Use asserts when loading required data.
- Make required parameters required; do not make them optional unless the
  feature truly needs absence as a valid state.
- Remove changes and surfaces that are not strictly required.
- Bias toward fewer lines of code.
- Avoid complex or clever code.
- Do not break code into too many tiny functions when it makes the flow harder
  to read.
- Prefer early returns.
- Use asserts instead of try/except or default values when a value is expected
  to exist.
- Never pass overrides except where strictly necessary.
- Remove old QD surfaces that are no longer needed.
- Avoid compatibility layers for the current experimental QD draft.
