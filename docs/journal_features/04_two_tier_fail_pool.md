# Two-Tier Archive And Fail Pool

## Goal

Keep failed ideas alive as an explicit parent source in the journal QD runtime.

Hard problems often need failed ideas to evolve into success. The journal path
should therefore keep two adaptive parent sources:

- success archive: archiveable successful candidates in the current runtime,
  and later archiveable thought evaluations with at least one successful code
  sample.
- fail pool: failed or otherwise non-archiveable candidates in the current
  runtime, and later all-fail thought evaluations.

This preserves the conference version's useful fail-success separation while
keeping the journal operator simple and thought-centric. The first
implementation should align the existing `fail_pool`, `success_archive`, and
`success_view` semantics rather than force the full thought-only/k-code data
model before Feature 06 lands.

## Current State

The current engine already implements most of the intended two-tier shape:

- `fail_pool` preserves failed `Heuristic` candidates instead of discarding
  them.
- `success_archive` stores archiveable successful candidates.
- `success_view` exposes archive members plus bounded successful reservoir
  candidates as success-side parents.
- `journal_logic_ff_width_3d` is an archive-only descriptor profile: it changes
  archive placement and reporting, but keeps classic parent operators so pass
  counts remain comparable.
- `grid_quantile` warmup already adapts parent allocation using fail/success
  pool sizes and protects success-side budget so quantile warmup can complete.
- initialized QD scheduling already adapts fail-side budget to archive fill.

The gap is mostly semantic and reporting clarity. Fail handling is still
implemented over code-level `Heuristic` candidates and legacy strategy prompts.
That is acceptable for Feature 04 as long as the failed candidate's thought is
treated as the retained failed idea. Typed thought evaluations, k-code success
rates, and prompt-only thought mutation belong to Features 05 and 06.

## Current Journal BD Pareto Runtime Path

The current target profile for this feature is:

```text
--search_mode revolution_qd
--qd_archive_type grid_quantile
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_cell_mode pareto_front
--qd_max_elites_per_cell 5
--qd_objectives ppa
```

In this mode, the genotype-like runtime object is still `Heuristic`. A
`Heuristic` carries the generated thought, generated RTL code, feedback text,
evaluation status, score, PPA metrics, descriptor payloads, and artifact paths
together. The journal BD profile changes descriptor extraction and archive
placement, but not yet the representation.

One generation currently proceeds as follows:

1. `QDEngine.evolve_one_generation()` calls `_split_generation_budget()` to
   divide the offspring budget into `seed_budget`, `fail_budget`,
   `backfill_budget`, and `refine_budget`.
2. `seed_budget` requests are generated from the problem description with no
   parent.
3. `fail_budget` requests sample one parent from `fail_pool`, choose a legacy
   fail-side strategy such as `M-F` or `M-E`, and generate a new candidate.
4. `backfill_budget + refine_budget` requests sample success parents from the
   archive-facing success view. In `pareto_front` mode, success parent
   selection is already MAP-Elites-like: sample an occupied behavior cell, then
   select a member by local Pareto-rank/crowding tournament.
5. Generated candidates are evaluated by the existing candidate evaluator.
6. Successful, archiveable candidates are inserted into `success_archive`.
7. Failed or non-archiveable candidates are inserted into `fail_pool`.
8. `success_pool` is refreshed from `_success_view()`, which exposes archive
   members plus a bounded reservoir of recent successful candidates.

For `journal_logic_ff_width_3d`, `_uses_descriptor_guided_generation()` is
false. This intentionally prevents descriptor-targeted operators such as
`M-T` and `C-D` from becoming part of the journal BD comparison path before
the single thought operator lands. Success-side generation still uses the
classic operators (`M-S`, `M-E`, `M-R`, `M-I`, `C-F`) for pass-count
comparability.

## Budget Allocation Methodology

`_split_generation_budget()` is the current implementation point for adaptive
parent-source allocation. It runs once per generation before any new offspring
prompts are built. The split decides how many requests use each parent source;
it does not evaluate candidates and it does not insert anything into the
archive.

The current runtime terms are:

- `fail_pool`: retained non-success `Heuristic` candidates. A candidate enters
  this pool when its evaluated status is not `success`, including syntax,
  functionality, synthesis/PPA, diff, or format failures. `_update_fail_pool()`
  sorts retained failures by status and generation and caps the pool at
  `population_size`.
- `success_archive`: the QD archive containing successful archiveable
  candidates. In `scalar_elite` mode it holds one representative per occupied
  cell. In `pareto_front` mode it may hold up to
  `qd_max_elites_per_cell` members per occupied cell.
- `success_reservoir`: a bounded side reservoir of recent successful
  candidates. It preserves success-side parents that are useful but are not
  necessarily current archive members. During `grid_quantile` warmup,
  successful candidates buffered as `warmup:N` entries can appear here before
  real quantile cells exist.
- `success_pool`: the success-side parent view returned by `_success_view()`.
  It is `success_archive` members plus non-duplicate `success_reservoir`
  candidates. It is not identical to `success_archive`.
- `seed`: a fresh generation from the problem description with no parent.

`QDBudgetSplit` contains:

- `phase`: `warmup`, `fill`, or `improve`.
- `fail_share`: the effective fraction of offspring assigned to failed ideas.
- `coverage_fail_share`: initialized archive-fill fail share before the
  `p_fail` cap. It is absent during warmup because there is no stable cell
  geometry yet.
- `fail_share_cap`: initialized `p_fail` cap used for the budget decision. It
  is absent during warmup.
- `fail_budget`: offspring generated from `fail_pool`.
- `success_budget`: all non-fail offspring after `fail_budget` is removed.
  Depending on phase, this becomes seed, backfill, or refine budget.
- `seed_budget`: fresh problem-description generations.
- `backfill_budget`: success-parent generations intended to improve archive
  coverage.
- `refine_budget`: success-parent generations intended to improve existing
  archive regions.

There are two active scheduling regimes: uninitialized `grid_quantile` warmup
and initialized archive scheduling.

### Archive Initialization

`grid_quantile` cannot assign stable behavior cells immediately. It first
collects successful archiveable candidates into a warmup buffer so it can infer
descriptor quantile boundaries from real designs.

Initialization proceeds as follows:

1. `GridQuantileArchive` starts with `initialized = false`, `num_cells = 0`,
   and an empty warmup buffer.
2. Every successful archiveable candidate is converted to an `ArchiveMember`
   and inserted into the archive.
3. While uninitialized, insertion appends the member to `_warmup_buffer` and
   returns a synthetic cell id such as `warmup:1`. The candidate is not yet in a
   real behavior cell.
4. Warmup normally completes when both conditions are true:
   - `warmup_buffer_size >= qd_grid_quantile_warmup_successes`;
   - enough descriptor axes have non-collapsed 25/50/75 percent quantile
     boundaries. For the current archive this means at least
     `min(2, len(axes))` active axes.
5. On initialization, the archive freezes per-axis quantile boundaries from the
   warmup records, computes `effective_bins = len(boundaries) + 1` per axis,
   sets `num_cells = product(effective_bins)`, and replays every warmup record
   into the initialized archive.
6. After initialization, `_split_generation_budget()` stops using warmup pool
   sizing and switches to archive-fill scheduling.

At run finalization, the archive can also initialize from the warmup buffer
when the configured warmup count was reached. This is an artifact/reporting
fallback, not the normal per-generation scheduling transition.

### Authoritative Budget Pseudo-Code

The pseudo-code below is the intended Feature 04 behavior. `use_p_fail_cap`
is shown only to compare the old initialized scheduler against Feature 04.
The implemented runtime always enables the cap after archive initialization.

```text
function split_generation_budget(use_p_fail_cap):
    lambda = max(0, int(num_offspring_lambda))

    if archive_type == grid_quantile and archive.initialized == false:
        return split_warmup_budget(lambda)

    return split_initialized_budget(lambda, use_p_fail_cap)
```

Warmup is identical with and without the `p_fail` cap. It uses pool sizes
because there is no stable cell geometry yet:

```text
function split_warmup_budget(lambda):
    total_pool = fail_pool_size + success_pool_size

    if total_pool == 0:
        return QDBudgetSplit(
            phase = warmup,
            total_budget = lambda,
            target_cells = qd_grid_quantile_warmup_successes,
            occupied_cells = warmup_buffer_size,
            fail_share = 0.0,
            coverage_fail_share = null,
            fail_share_cap = null,
            fail_budget = 0,
            success_budget = lambda,
            seed_budget = lambda,
            backfill_budget = 0,
            refine_budget = 0,
        )

    fail_budget = round(lambda * fail_pool_size / total_pool)
    success_budget = lambda - fail_budget

    if fail_pool_size > 0 and success_pool_size > 0:
        success_budget = max(success_budget, lambda // 2)
        fail_budget = lambda - success_budget

    return QDBudgetSplit(
        phase = warmup,
        total_budget = lambda,
        target_cells = qd_grid_quantile_warmup_successes,
        occupied_cells = warmup_buffer_size,
        fail_share = fail_budget / max(lambda, 1),
        coverage_fail_share = null,
        fail_share_cap = null,
        fail_budget = fail_budget,
        success_budget = success_budget,
        seed_budget = 0,
        backfill_budget = 0,
        refine_budget = success_budget,
    )
```

The mixed-pool guard is important for `grid_quantile`: the run needs enough
archiveable successes to compute stable 25/50/75 percent quantile boundaries.
Without the guard, a large fail pool could starve the successful warmup samples
required to initialize the archive.

Initialized scheduling first computes fail-side share. The only difference
between the old path and Feature 04 is the `p_fail` cap:

```text
function initialized_fail_share(use_p_fail_cap):
    target_cells = ceil(qd_fill_target_fraction * num_cells)
    target_cells = max(1, target_cells)

    fill_ratio = occupied_cells / target_cells
    fill_ratio = clamp(fill_ratio, 0.0, 1.0)
    coverage_fail_share = 1.0 - fill_ratio

    if use_p_fail_cap == false:
        return coverage_fail_share, null, coverage_fail_share

    total_parent_mass = fail_pool_size + archive_member_count
    if total_parent_mass == 0:
        p_fail = 0.0
    else:
        p_fail = fail_pool_size / total_parent_mass

    p_fail = clamp(p_fail, 0.0, 1.0)
    effective_fail_share = min(coverage_fail_share, p_fail)
    return coverage_fail_share, p_fail, effective_fail_share
```

Then the initialized path routes fail, seed, backfill, and refine budgets:

```text
function split_initialized_budget(lambda, use_p_fail_cap):
    target_cells = ceil(qd_fill_target_fraction * num_cells)
    target_cells = max(1, target_cells)

    coverage_fail_share, fail_share_cap, effective_fail_share =
        initialized_fail_share(use_p_fail_cap)
    fail_budget = round(lambda * effective_fail_share)

    if fail_pool_size == 0:
        fail_budget = 0

    success_budget = max(0, lambda - fail_budget)

    if occupied_cells == 0:
        # Generic initialized-scheduler fallback. This is not expected after
        # normal grid_quantile warmup because warmup records are replayed into
        # real archive cells when the archive initializes.
        return QDBudgetSplit(
            phase = fill,
            total_budget = lambda,
            target_cells = target_cells,
            occupied_cells = occupied_cells,
            fail_share = effective_fail_share,
            coverage_fail_share = coverage_fail_share,
            fail_share_cap = fail_share_cap,
            fail_budget = fail_budget,
            success_budget = success_budget,
            seed_budget = success_budget,
            backfill_budget = 0,
            refine_budget = 0,
        )

    if occupied_cells < target_cells:
        seed_budget = ceil(0.25 * success_budget)
        backfill_budget = max(0, success_budget - seed_budget)

        return QDBudgetSplit(
            phase = fill,
            total_budget = lambda,
            target_cells = target_cells,
            occupied_cells = occupied_cells,
            fail_share = effective_fail_share,
            coverage_fail_share = coverage_fail_share,
            fail_share_cap = fail_share_cap,
            fail_budget = fail_budget,
            success_budget = success_budget,
            seed_budget = seed_budget,
            backfill_budget = backfill_budget,
            refine_budget = 0,
        )

    if empty_cells_remaining == true and success_budget > 0:
        backfill_budget = max(1, round(0.20 * success_budget))
    else:
        backfill_budget = 0

    refine_budget = max(0, success_budget - backfill_budget)

    return QDBudgetSplit(
        phase = improve,
        total_budget = lambda,
        target_cells = target_cells,
        occupied_cells = occupied_cells,
        fail_share = effective_fail_share,
        coverage_fail_share = coverage_fail_share,
        fail_share_cap = fail_share_cap,
        fail_budget = fail_budget,
        success_budget = success_budget,
        seed_budget = 0,
        backfill_budget = backfill_budget,
        refine_budget = refine_budget,
    )
```

Stage behavior summary:

- `warmup`: this is the uninitialized `grid_quantile` state. There are no real
  archive cells yet, so `occupied_cells`, `target_cells`, and `p_fail` are not
  used for scheduling. If both pools are empty, every request is a fresh seed
  request because there are no parents to sample. Once either pool exists,
  budget is split by `fail_pool_size / (fail_pool_size + success_pool_size)`.
  If both fail and success pools are non-empty, the success side is forced to
  receive at least half of `lambda`; this keeps warmup from becoming
  fail-only and gives the archive enough successful samples to freeze quantile
  boundaries.
- `fill`, initialized scheduler with an empty archive: this is a generic
  fallback in `split_qd_budget()`, not the expected journal `grid_quantile`
  post-warmup path. It can occur for archive types that do not have
  `grid_quantile` warmup, or in a run that reaches initialized scheduling
  before any successful archive insertion. In the normal journal
  `grid_quantile` path, initialization replays warmup records into real cells,
  so the first initialized generation should enter partially occupied `fill`
  or `improve`, not this empty-archive fallback. When this branch is used, the
  scheduler computes `coverage_fail_share` and caps it by
  `p_fail`, but every non-fail request becomes `seed_budget` because there are
  no archive parents to backfill or refine from.
- `fill`, partially occupied archive: this is initialized scheduling with
  `0 < occupied_cells < target_cells`. The scheduler first computes
  `fail_budget`; without Feature 04 this is coverage-only, and with Feature 04
  it is `min(coverage_fail_share, p_fail)`. The remaining `success_budget` is
  split into exploration and archive-parent work: `ceil(25%)` becomes fresh
  `seed_budget`, and the rest becomes `backfill_budget` from success/archive
  parents. `refine_budget` stays zero in this phase.
- `improve`: this starts once `occupied_cells >= target_cells`. At that point
  the clipped coverage formula gives `coverage_fail_share = 0`, so the
  `p_fail` cap cannot increase fail allocation and `fail_budget` is zero in
  normal operation. No fresh seed requests are scheduled. The generation mostly
  refines existing archive regions; if the archive still has empty cells, up
  to `20%` of `success_budget` is reserved as `backfill_budget`, and the
  remainder becomes `refine_budget`.

### `p_fail` Cap Semantics

`p_fail` is the fail/archive population-ratio signal:

```text
p_fail = fail_pool_size / (fail_pool_size + archive_member_count)
```

`archive_member_count` means total local archive members across all archive
cells. In `pareto_front` mode it can be greater than occupied-cell count
because each cell can hold up to `qd_max_elites_per_cell` members. It is not
global Pareto-front size.

```text
occupied_cells = 4
members_per_cell = 5
archive_member_count = 20
```

Feature 04 combines coverage and `p_fail` conservatively:

```text
effective_fail_share = min(coverage_fail_share, p_fail)
```

This makes the existing coverage schedule the upper bound. The `p_fail` cap
can reduce fail-side allocation when successful archive population mass is
large, but it cannot increase fail-side allocation above the current
coverage-based schedule.

### Checked Worked Examples

These examples are the expected outputs for the documented cases.

Warmup, no parents yet:

```text
lambda = 20
fail_pool_size = 0
success_pool_size = 0

phase = warmup
fail_budget = 0
success_budget = 20
seed_budget = 20
backfill_budget = 0
refine_budget = 0
```

Warmup, mixed fail-heavy pools:

```text
lambda = 20
fail_pool_size = 19
success_pool_size = 1

raw fail_budget = round(20 * 19 / 20) = 19
raw success_budget = 1
guarded success_budget = max(1, 20 // 2) = 10
guarded fail_budget = 10

phase = warmup
fail_budget = 10
success_budget = 10
seed_budget = 0
backfill_budget = 0
refine_budget = 10
```

Historical initialized fill without the `p_fail` cap:

```text
lambda = 20
num_cells = 64
qd_fill_target_fraction = 0.25
target_cells = 16
occupied_cells = 4
fail_pool_size = 4
archive_member_count = 20

coverage_fail_share = 1 - 4 / 16 = 0.75
effective_fail_share = 0.75

phase = fill
fail_budget = round(20 * 0.75) = 15
success_budget = 5
seed_budget = ceil(0.25 * 5) = 2
backfill_budget = 3
refine_budget = 0
```

The same initialized fill case with the Feature 04 cap:

```text
lambda = 20
num_cells = 64
qd_fill_target_fraction = 0.25
target_cells = 16
occupied_cells = 4
fail_pool_size = 4
archive_member_count = 20

coverage_fail_share = 1 - 4 / 16 = 0.75
p_fail = 4 / (4 + 20) = 0.1667
effective_fail_share = min(0.75, 0.1667) = 0.1667

phase = fill
fail_budget = round(20 * 0.1667) = 3
success_budget = 17
seed_budget = ceil(0.25 * 17) = 5
backfill_budget = 12
refine_budget = 0
```

Initialized fill where the cap is looser than coverage:

```text
lambda = 20
target_cells = 16
occupied_cells = 12
fail_pool_size = 20
archive_member_count = 20

coverage_fail_share = 1 - 12 / 16 = 0.25
p_fail = 0.50
effective_fail_share = min(0.25, 0.50) = 0.25

phase = fill
fail_budget = 5
success_budget = 15
seed_budget = ceil(0.25 * 15) = 4
backfill_budget = 11
refine_budget = 0
```

Initialized improve, with or without the cap:

```text
lambda = 20
num_cells = 64
qd_fill_target_fraction = 0.25
target_cells = 16
occupied_cells = 20
empty_cells_remaining = true
fail_pool_size = 20
archive_member_count = 20

coverage_fail_share = 0.0
p_fail = 0.50
effective_fail_share = 0.0

phase = improve
fail_budget = 0
success_budget = 20
seed_budget = 0
backfill_budget = round(0.20 * 20) = 4
refine_budget = 16
```

Sampling flow difference for the initialized fill examples above:

```text
without Feature 04:
  15 fail-pool parent requests
  2 seed requests
  3 archive/success-parent requests

with Feature 04:
  3 fail-pool parent requests
  5 seed requests
  12 archive/success-parent requests
```

The requests are materialized the same way in both versions:

```text
fail-pool parent request:
  sample one parent from 4 retained failed candidates
  use fail-side strategy such as M-F or M-E

seed request:
  generate from the problem description with no parent

archive/success-parent request:
  sample occupied archive cells
  choose Pareto-front members by local rank/crowding tournament
  use success-side strategy such as M-S, M-E, M-R, M-I, or C-F
```

The flow changes only in budget allocation. Parent pools, prompt builders,
candidate evaluation, success insertion, and fail-pool retention are otherwise
the same. The fail pool remains an explicit parent source, but once the local
Pareto archive contains many successful members, the scheduler no longer acts
as if four occupied cells are the whole success-side population.

## Failure Layers

The first implementation should use the following routing rules:

| Layer | Meaning | Journal routing |
| --- | --- | --- |
| A | Parsed thought is empty or structurally invalid. | Reject only when the parser can prove it; otherwise keep current format-failure handling. |
| B | Current candidate fails syntax, simulation, synthesis, or archiveability. Later: all k code samples fail. | Insert the candidate/thought into the fail pool. |
| C | Current candidate succeeds and is archiveable. Later: at least one k-code sample succeeds. | Insert into the success archive. Later record `success_rate < 1.0` for partial successes. |
| D | Simulation succeeds but synthesis/PPA fails. | Count as non-archiveable and keep in fail pool unless another representative sample succeeds after Feature 06. |

Layer A should stay narrow. Do not add an LLM judge or fuzzy nonsense detector
for the first pass.

## Implementation Specification

Feature 04 should be a minimal first pass over the current code-level runtime.
It should not introduce the full thought-only/k-code representation yet.

Current behavior to preserve:

- Keep the existing code-level `Heuristic` storage until Feature 06 introduces
  `ThoughtEvaluation`.
- Treat every retained failed `Heuristic.thought` as a failed idea that may be
  selected as a future parent.
- Store archiveable successful candidates in `success_archive`.
- Store failed or non-archiveable candidates in `fail_pool`.
- Keep fail-pool eviction simple and bounded by the existing population target
  unless a separate size multiplier is added.

New behavior to add in Feature 04:

1. Keep adaptive parent allocation phase-aware.
   - During `grid_quantile` warmup, preserve the existing fail/success
     pool-size split and success-budget guard.
   - After archive initialization, keep the existing archive-fill scheduler as
     the primary schedule and cap its fail share by the fail/archive population
     ratio.

2. Compute the initialized fail share as:

   ```text
   target_cells = ceil(qd_fill_target_fraction * num_cells)
   coverage_fail_share = 1 - occupied_cells / target_cells
   p_fail = fail_pool_size / (fail_pool_size + archive_member_count)
   effective_fail_share = min(coverage_fail_share, p_fail)
   fail_budget = round(lambda * effective_fail_share)
   ```

   If `fail_pool_size = 0`, `fail_budget` remains `0`. If
   `archive_member_count = 0` and the fail pool is non-empty, `p_fail = 1.0`,
   so the current coverage schedule is unchanged.

3. Recompute the remaining generation budget using the existing phase rules:
   - If archive is empty, `success_budget` becomes `seed_budget`.
   - If archive is in fill phase, `25%` of success budget becomes seed budget
     and the rest becomes backfill budget.
   - If archive is in improve phase, up to `20%` of success budget becomes
     backfill budget when empty cells remain, and the rest becomes refine
     budget.

4. Add explicit parent-source accounting so generation artifacts can
   distinguish `archive`, `fail_pool`, and `seed`. Existing internal
   `origin_pool=success_pool` can remain for compatibility, but journal-facing
   reports should present that source as `archive`.

5. Report both occupied-cell coverage and total archive member count. In
   `pareto_front` mode, total archive member count means all members across all
   cell fronts, not occupied cell count. Generation snapshots should keep the
   budget-time `coverage_fail_share`, `p_fail` cap, and effective fail share
   so later archive/fail-pool updates do not rewrite the scheduling decision.

6. Keep the scope limited to scheduling and reporting. Do not add new prompt
   inputs, new failure summaries, or a new thought-evaluation schema in Feature
   04.

The following stricter behavior is deferred until Features 05 and 06:

- replacing `Heuristic` with typed thought evaluations;
- removing all legacy strategy-bandit routing from the journal path;
- guaranteeing fail-pool prompts contain only parent thoughts and abstract
  failure facts.

Once thought-only evaluation lands, the pure source probability can become:

```text
p_fail = fail_pool_size / (fail_pool_size + archive_member_count)
```

Until then, the hybrid `min(coverage_fail_share, p_fail)` rule keeps failed
ideas alive early, shifts budget as the archive matures, incorporates the
pool-size formula, and preserves the current hard-subset validation behavior as
much as possible.

## Expected Runtime Impact

The hybrid rule changes initialized generations only. Warmup remains
unchanged. In the normal schedule, the only phase where the cap changes budget
is initialized `fill`: `warmup` ignores archive geometry, and `improve` already
has `coverage_fail_share = 0`.

The change is intentionally asymmetric:

- If the historical coverage schedule gives a lower fail share than `p_fail`,
  the coverage schedule wins.
- If `p_fail` is lower than the historical coverage schedule, fail-side budget
  is reduced.
- The pool-ratio formula therefore cannot make the run more fail-heavy than the
  current implementation after archive initialization.

The main practical effect is that a mature local Pareto archive with many
members can pull effort toward archive improvement earlier than occupied-cell
coverage alone would. The fail pool remains useful, but it no longer receives a
large budget solely because the archive has few occupied cells when those cells
already contain many successful Pareto members. The checked worked examples in
the budget section are the source of truth for the arithmetic.

## Satisfactory End State

Feature 04 is complete only when all of these are true:

1. The current code-level `Heuristic` runtime is preserved. This feature treats
   a failed `Heuristic.thought` as the retained failed idea, but does not
   introduce `ThoughtEvaluation` or k-code thought sampling.
2. `success_archive` and `fail_pool` are the two journal parent sources exposed
   in artifacts and reports. Fresh generations remain a separate `seed` source.
3. `grid_quantile` warmup behavior is unchanged, including the success-budget
   guard that prevents a large fail pool from starving archive initialization.
4. After archive initialization, `_split_generation_budget()` keeps the
   existing archive-fill schedule as the upper bound and caps fail allocation
   with `fail_pool_size / (fail_pool_size + archive_member_count)`.
5. The cap can reduce initialized fail budget but can never increase it above
   the existing coverage schedule.
6. In `pareto_front` mode, `archive_member_count` is the number of local
   archive members across all cell fronts. It is not occupied-cell count.
7. If the fail pool is empty, initialized fail budget is zero.
8. If the archive has no members and the fail pool is non-empty, the cap is
   `1.0`, so the existing archive-fill schedule is preserved.
9. Existing phase routing remains intact: empty archives use seed budget, fill
   phase uses seed plus backfill, and improve phase uses backfill plus refine.
10. No new prompt semantics, feedback summaries, LLM judges, or descriptor
    targeting are added for Feature 04.
11. Generation artifacts expose source counts for `archive`, `fail_pool`, and
    `seed`. Legacy internal names such as `success_pool` may exist only as
    compatibility details.
12. Summary artifacts expose fail-pool size, occupied cells,
    `total_archive_members`, effective fail share, and the cap signal used for
    initialized scheduling.
13. Scalar archive modes and non-journal QD paths remain behaviorally
    unchanged except for shared report fields that are explicitly compatible.
14. Unknown archive geometry, cell mode, objective mode, or source labels fail
    immediately in validation.
15. A strict hard-subset validator exits `0` only when the implementation meets
    the quantitative gates below.

## Current Repo Surfaces

The intended code impact is small:

- `src/revolution/qd/scheduler.py`: keep the archive-fill formula in one place
  and add only the fail-share cap needed by initialized scheduling.
- `src/revolution/qd/engine.py`: compute the cap from existing runtime state,
  using `len(fail_pool)` and the number of archive members returned by the
  archive-facing member iterator.
- `src/revolution/qd/archive.py`: no replacement-policy change is required.
  Feature 03 already owns Pareto-front insertion, rank, crowding, and global
  archive behavior.
- `src/revolution/qd/artifacts.py` and summary/report code: expose source
  counts, fail-pool size, occupied cells, and total Pareto archive members.
- `scripts/run_backend.py` and `src/revolution/backends/revolution_backend.py`:
  only pass through existing QD settings. Do not add a new public
  `two_tier_fail_pool` mode.
- `scripts/run_hard_iteration_qd_vllm.sh`: use existing config-defined
  `matrix_modes`; the Feature 04 target is the normal
  `grid_quantile_pareto_journal_bd` matrix entry after this feature lands.
- `scripts/backend_comparison_report.py`,
  `scripts/report_final_analysis_bundle.py`,
  `scripts/report_pareto_analysis.py`,
  `scripts/report_ppa_distribution.py`, and
  `scripts/report_design_space_analysis.py`: consume existing final-analysis
  surfaces and add Feature 04 fields only where they clarify QD source
  behavior.
- `scripts/validate_pareto_front_run.py` or a narrow
  `scripts/validate_two_tier_fail_pool_run.py`: enforce the acceptance gates.
- `scripts/export_qd_ppa_visualization.py` and
  `scripts/validate_qd_ppa_visualization.py`: verify that the Phase 03.1
  archive/PPA viewer still works for the Feature 04 target run.
- `tests/revolution/test_qd_scheduler.py` and
  `tests/revolution/test_qd_engine.py`: cover the scheduling change directly.
- `tests/scripts/`: cover any new reporting or validator fields.

The preferred implementation passes one scalar cap into the scheduler rather
than passing several pool counts through multiple layers. The engine already
knows the archive and fail-pool state; the scheduler only needs the effective
cap value.

## Configuration

No new required configuration is needed for the minimal Feature 04 pass. Reuse
the existing QD controls:

- `population_size` bounds the retained fail pool in the current code-level
  runtime.
- `qd_fill_target_fraction` controls initialized archive-fill adaptation.
- `qd_grid_quantile_warmup_successes` controls the warmup phase where success
  parents must not be starved.

After Feature 06, the thought-level runtime may add:

```yaml
fail_pool:
  max_size_multiplier: 2
  source_selection: adaptive_size_ratio
```

`max_size_multiplier` would be relative to the target thought population size.
`source_selection` would have one supported value in the first thought-level
implementation.

## Artifacts And Reporting

- Generation logs should record parent source as `archive`, `fail_pool`, or
  `seed`. Existing legacy `origin_pool=success_pool` may remain internally, but
  journal reports should present the source as `archive`.
- Summary files should record fail-pool size, occupied cells, total archive
  member count, budget/generation counts, and observed source-selection rates.
- `thought_evaluation.json` and success-rate distributions are deferred to
  Feature 06.
- Prompt snapshots that prove absence of code and individual feedback are
  deferred to the single thought operator and thought-only prompt work. Feature
  04 should not add new code/log feedback surfaces.

## Testing Plan

- Unit-test existing warmup allocation keeps both fail and success ideas active
  when both pools exist.
- Unit-test initialized archive-fill allocation still adapts fail budget to
  archive maturity when the pool-ratio cap is looser than coverage.
- Unit-test the pool-ratio cap reduces initialized fail budget when
  `p_fail < coverage_fail_share`.
- Unit-test fail-pool insertion and eviction preserve failed ideas.
- Unit-test reporting uses total Pareto member count where required.
- Regression-test journal summaries expose `archive`, `fail_pool`, and `seed`
  parent-source counts.
- Defer prompt-content regression and all-fail/partial-success thought routing
  tests to Features 05 and 06.

## Validation Loop

Follow this loop before accepting the implementation:

1. Run the existing focused QD scheduler and QD engine tests before editing and
   record the baseline.
2. Add scheduler tests for the initialized cap: cap reduces fail budget,
   cannot increase fail budget, and preserves the existing schedule when the
   cap is looser than coverage.
3. Add engine tests proving `pareto_front` uses total archive members, not
   occupied cells, when computing the cap.
4. Add reporting tests for `archive`, `fail_pool`, and `seed` source counts.
5. Add artifact tests for fail-pool size, occupied cells,
   `total_archive_members`, effective fail share, and cap value.
6. Run ruff on touched source, tests, and scripts.
7. Run pyright on touched source and scripts, or document unrelated existing
   type debt.
8. Run a small deterministic smoke for `grid_quantile_journal_bd` and
   `grid_quantile_pareto_journal_bd`, with total concurrent workers capped at
   `16`.
9. Run the full fixed-seed hard-subset matrix below.
10. Generate the final-analysis bundle, Pareto analysis, PPA distribution,
    design-space analysis, Feature 03.1 visualization, and strict validation
    reports.
11. Accept the feature only if every quantitative gate below passes.

## Required Tests

Add focused tests for:

- `QDEngine._split_generation_budget()` preserves existing `grid_quantile`
  warmup splits when both fail and success pools exist.
- initialized archive-fill allocation is unchanged when `p_fail` is `1.0`.
- initialized archive-fill allocation is unchanged when `p_fail` is higher
  than `coverage_fail_share`.
- initialized archive-fill allocation is reduced when `p_fail` is lower than
  `coverage_fail_share`.
- `fail_share` reported in `QDBudgetSplit` equals the effective capped share.
- empty fail pool produces zero initialized fail budget.
- non-empty fail pool plus empty archive members preserves the current
  coverage schedule.
- `pareto_front` cap computation uses total archive members across all cell
  fronts.
- a cell with five Pareto members counts as five archive members, not one.
- scalar archive behavior and existing `grid_quantile` warmup behavior remain
  unchanged.
- source accounting maps success-parent generation to journal-facing
  `archive`, fail-parent generation to `fail_pool`, and fresh generation to
  `seed`.
- per-generation source counts sum to the number of generated candidates.
- summary artifacts expose fail-pool size, occupied cells,
  `total_archive_members`, effective fail share, and cap value.
- validators fail on unknown parent-source labels.
- prompt-content, all-fail thought routing, partial-success thought routing,
  and thought-level success-rate tests are deferred to Features 05 and 06.

## Full Hard-Subset Acceptance Run

Feature 04 uses the same acceptance style as the Phase 03 Pareto-front run,
but keeps the implementation target narrower. The final gate is a full
13-problem hard-subset matrix with the live vLLM backend, long-context token
settings, generated comparison reports, the Phase 03.1 linked visualization,
and a strict validation artifact. Smoke and validation runs may use up to
`16` workers at a time, but must not exceed that server-resource ceiling.

Create a scratch config under `exp/`; do not commit it unless explicitly
requested:

```bash
mkdir -p exp/journal_two_tier_fail_pool_configs
cp data/configs/hard_iteration_subset.yaml \
  exp/journal_two_tier_fail_pool_configs/hard_subset_two_tier_fail_pool.yaml
```

Set the matrix to include classic, the existing structural QD control, the
scalar journal-BD control, and the journal-BD Pareto target that carries
Feature 04:

```yaml
matrix_modes:
  - classic
  - grid_struct
  - grid_quantile_journal_bd
  - grid_quantile_pareto_journal_bd

modes:
  classic:
    search_mode: revolution
    seed: 42
  grid_struct:
    search_mode: revolution_qd
    qd_archive_type: grid
    qd_descriptor_profile: implemented_structural_compact_3d
    seed: 42
  grid_quantile_journal_bd:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 8
    qd_cell_mode: scalar_elite
    qd_max_elites_per_cell: 1
    qd_objectives: ppa
    seed: 42
  grid_quantile_pareto_journal_bd:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 8
    qd_cell_mode: pareto_front
    qd_max_elites_per_cell: 5
    qd_objectives: ppa
    qd_two_parent_probability: 0.5
    seed: 42
```

Do not add a separate public mode for Feature 04. If an old pre-Feature-04
branch is available, it may be run as an analysis control with a distinct
backend label, but the committed runtime should expose only the normal
`grid_quantile_pareto_journal_bd` target.

Run the full hard subset:

```bash
PYTHON_BIN=/workspace/.venv/bin/python \
HARD_SUBSET_VLLM_HOST=host.docker.internal \
HARD_SUBSET_VLLM_PORT=8000 \
HARD_SUBSET_MIN_MODEL_LEN=128000 \
HARD_SUBSET_MAX_TOKENS=128000 \
HARD_SUBSET_DIFF_MAX_TOKENS=128000 \
HARD_SUBSET_POPULATION_SIZE=20 \
HARD_SUBSET_NUM_GENERATIONS=5 \
HARD_SUBSET_TOTAL_WORKER_SLOTS=16 \
HARD_SUBSET_MAX_ACTIVE_PROBLEMS=4 \
HARD_SUBSET_MAX_WORKERS_PER_PROBLEM=4 \
HARD_SUBSET_SAVE_PATH=exp/journal_two_tier_fail_pool_hard_subset \
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config exp/journal_two_tier_fail_pool_configs/hard_subset_two_tier_fail_pool.yaml \
  --mode matrix
```

The manifest must show:

- `reported_max_model_len >= 128000`.
- `population_size=20`.
- `num_generations=5`.
- `total_worker_slots=16`.
- `max_active_problems=4`.
- `max_workers_per_problem=4`.
- `max_tokens=128000`.
- `diff_max_tokens=128000`.
- `seed=42`.
- all 13 hard-subset problems.
- `mode.grid_quantile_journal_bd.qd_cell_mode=scalar_elite`.
- `mode.grid_quantile_pareto_journal_bd.qd_cell_mode=pareto_front`.
- `mode.grid_quantile_pareto_journal_bd.qd_max_elites_per_cell=5`.
- `mode.grid_quantile_pareto_journal_bd.qd_objectives=ppa`.
- `mode.grid_quantile_pareto_journal_bd.qd_two_parent_probability=0.5`.

After the run, generate the report family:

```bash
RUN_ROOT="<printed save path from wrapper>"
CONFIG=exp/journal_two_tier_fail_pool_configs/hard_subset_two_tier_fail_pool.yaml

/workspace/.venv/bin/python scripts/backend_comparison_report.py \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_struct="${RUN_ROOT}/grid_struct" \
  --backend_run grid_quantile_journal_bd="${RUN_ROOT}/grid_quantile_journal_bd" \
  --backend_run grid_quantile_pareto_journal_bd="${RUN_ROOT}/grid_quantile_pareto_journal_bd" \
  --output "${RUN_ROOT}/backend_comparison.md"

/workspace/.venv/bin/python scripts/report_final_analysis_bundle.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}"

/workspace/.venv/bin/python scripts/report_pareto_analysis.py \
  --subset-config "${CONFIG}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_struct="${RUN_ROOT}/grid_struct" \
  --backend_run grid_quantile_journal_bd="${RUN_ROOT}/grid_quantile_journal_bd" \
  --backend_run grid_quantile_pareto_journal_bd="${RUN_ROOT}/grid_quantile_pareto_journal_bd" \
  --output-dir "${RUN_ROOT}/pareto_analysis"

/workspace/.venv/bin/python scripts/report_ppa_distribution.py \
  --subset-config "${CONFIG}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_struct="${RUN_ROOT}/grid_struct" \
  --backend_run grid_quantile_journal_bd="${RUN_ROOT}/grid_quantile_journal_bd" \
  --backend_run grid_quantile_pareto_journal_bd="${RUN_ROOT}/grid_quantile_pareto_journal_bd" \
  --output-dir "${RUN_ROOT}/ppa_distribution"

/workspace/.venv/bin/python scripts/report_design_space_analysis.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}" \
  --feature-profile journal_logic_ff_width_3d
```

Export and validate the linked archive/PPA visualization introduced in
Feature 03.1:

```bash
/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root "${RUN_ROOT}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_journal_bd="${RUN_ROOT}/grid_quantile_journal_bd" \
  --backend_run grid_quantile_pareto_journal_bd="${RUN_ROOT}/grid_quantile_pareto_journal_bd" \
  --archive_source_backend grid_quantile_pareto_journal_bd \
  --output-dir "${RUN_ROOT}/visualization/qd_ppa_viewer" \
  --subset-config "${CONFIG}" \
  --asset-mode local \
  --strict

/workspace/.venv/bin/python scripts/validate_qd_ppa_visualization.py \
  --viewer-root "${RUN_ROOT}/visualization/qd_ppa_viewer" \
  --subset-config "${CONFIG}" \
  --playwright \
  --strict
```

Add or extend a strict audit command:

```bash
/workspace/.venv/bin/python scripts/validate_two_tier_fail_pool_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}" \
  --classic-mode classic \
  --structural-qd-mode grid_struct \
  --scalar-journal-mode grid_quantile_journal_bd \
  --pareto-journal-mode grid_quantile_pareto_journal_bd \
  --require-full-subset \
  --acceptance-hard-subset
```

The audit command must emit:

- `two_tier_fail_pool_validation.json`.
- `two_tier_fail_pool_validation.md`.
- non-zero exit status on any failed hard gate.

## Quantitative Acceptance Gates

The full hard-subset run is satisfactory only if every hard gate passes:

- `problem_count=13`.
- `failure_count=0`.
- `problem_invalid_count=0`.
- `acceptance_error_count=0`.
- `final_analysis/summary.json` exists.
- `final_analysis/summary.json` has an empty `skipped_sections` list.
- `final_analysis/hard_iteration_analysis/summary.json` covers all 13
  problems.
- `final_analysis/pareto_analysis/summary.json` covers every backend/problem
  pair in the matrix.
- `final_analysis/ppa_distribution/summary.json` exists.
- `final_analysis/design_space_analysis/summary.json` has successful
  candidates and all 13 pairwise feature comparisons.
- `backend_comparison.md` reports valid designs, functionality rate,
  synthesis/PPA rate, average quality score, and average PPA improvement for
  every backend.
- The linked archive/PPA viewer exports successfully and the strict validator
  exits `0`.

Primary performance gates are regression guards:

- `grid_quantile_pareto_journal_bd` must complete the same 13 problems as
  `classic`, `grid_struct`, and `grid_quantile_journal_bd`.
- Functional any-pass count must not be worse than classic by more than one
  problem.
- Synthesis/PPA any-pass count must not be worse than classic by more than one
  problem.
- Functional rate must be within the variance envelope of classic and not more
  than 10 percentage points lower than the scalar journal-BD control.
- Synthesis/PPA rate must be within the variance envelope of classic and not
  more than 10 percentage points lower than the scalar journal-BD control.
- Average quality score must be within the variance envelope of classic and
  not below both QD controls.
- Average PPA improvement over reference must be within the variance envelope
  of classic and not below both QD controls.
- If a classic problem has at least one functional and synthesis/PPA-valid
  design, the Pareto journal target should also have one unless the final
  validator explains the one-problem tolerance case.

The variance envelope must be computed over per-problem values, not raw
candidate rows. This prevents a backend that emits many candidates for one
problem from dominating the acceptance decision. The validator should compute
paired target-minus-classic deltas and accept a metric when:

```text
mean_delta >= -max(2 * standard_error(delta_by_problem), metric_floor)
```

Use these floors until a repeated-seed study replaces them:

```text
any-pass counts: 1 problem
functionality rate: 0.10
synthesis/PPA rate: 0.10
average quality score: 0.05
average PPA improvement: 0.05
```

If fewer than four paired non-empty problem values exist for a metric, use the
floor only and require a written validation note. Do not accept the feature on
a cherry-picked rerun. If the declared final run fails a gate, the feature
remains open unless a new full matrix is declared and validated from scratch.

Feature-specific gates:

- Warmup-generation budget splits match pre-Feature-04 behavior.
- Initialized generations record both `coverage_fail_share` and
  `p_fail_cap`.
- For every initialized generation,
  `effective_fail_share <= coverage_fail_share`.
- For every initialized generation with nonzero fail and archive populations,
  `effective_fail_share <= p_fail_cap`.
- Source counts for `archive`, `fail_pool`, and `seed` sum to generated
  candidate count for each generation.
- `archive_member_count >= occupied_cells` in `pareto_front` mode.
- `archive_cells.csv` row count equals `archive_summary.json`
  `total_archive_members` for the Pareto journal target.
- At least one hard-subset problem reaches initialized archive scheduling after
  warmup, so the cap is exercised in the acceptance run.
- No prompt artifact introduced by Feature 04 includes a new code-bearing
  fail-pool prompt path.

The validation report must include a "Deferred From Feature 04" section
listing:

- thought-only individuals;
- k-code thought evaluation;
- all-fail versus partial-success thought routing;
- success-rate-aware archive dominance;
- prompt-only thought mutation;
- removing legacy strategy-bandit operators from the journal path.

## Implementation Rules

Apply these rules while implementing this feature:

1. Write simple, skimmable code.
2. Minimize possible states by narrowing state and reducing argument count.
3. Use discriminated unions for archive geometry, cell mode, objective mode,
   and parent-source labels where new typed surfaces are needed.
4. Exhaustively handle every multi-type object; fail on unknown variants.
5. Do not write defensive fallback code for values that should exist.
6. Use asserts when loading required data.
7. Remove changes not required for Feature 04.
8. Bias toward fewer lines of code.
9. Avoid clever code.
10. Do not split logic into tiny helpers when it makes generation flow harder
    to read.
11. Prefer early returns.
12. Use asserts instead of broad try/except/defaults for expected values.
13. Do not pass overrides unless strictly necessary.
14. Do not make required arguments optional.

Concretely for Feature 04:

- Add no new public QD mode.
- Add no new required config.
- Add no new prompt semantics.
- Do not pass fail-pool size and archive-member count through every scheduler
  layer. Compute the cap in the engine and pass the scheduler one scalar.
- Keep `_split_generation_budget()` as the single place where generation
  budget routing is decided.
- Keep existing archive coverage as the upper bound with
  `min(coverage_fail_share, p_fail)`.
- Prefer explicit source labels `archive`, `fail_pool`, and `seed` in reports.
- Fail validation on unknown source labels rather than silently grouping them.

## Commit Guidance

Use atomic commits with `git commit -s`.

Good possible commits:

```text
feat(qd): Cap fail-pool parent share
test(qd): Cover two-tier fail scheduling
docs(qd): Specify fail-pool acceptance
```

Commit message rules:

1. Separate subject from body with a blank line.
2. Keep the subject concise, ideally under 50 characters.
3. Capitalize the subject text after the type/scope.
4. Do not end the subject with a period.
5. Use imperative mood.
6. Wrap body text at 72 characters.
7. Explain what and why, not line-by-line how.

After each commit, immediately check:

```bash
git log --format=%B -n 1 HEAD
git show --pretty=fuller --no-patch HEAD
git log --format=%B -n 1 HEAD | rg '\\n' && echo "BAD: raw newline text found"
git log --format=%B -n 1 HEAD | rg -c '^Signed-off-by:'
```

There should be no raw `\n` text and exactly one `Signed-off-by:` footer.

## Completion Checklist

Target deadline: `2026-05-07`

- [x] 4.1 Make success archive and fail pool the two explicit parent sources.
- [x] 4.2 Verify adaptive parent allocation preserves failed ideas while the
  archive matures.
- [x] 4.3 Add explicit parent-source reporting for `archive`, `fail_pool`, and
  `seed`.
- [x] 4.4 Run strict hard-subset acceptance against `classic`, `grid_struct`,
  scalar journal BD, and Pareto journal BD.
- [x] 4.5 Validate the Feature 03.1 archive/PPA visualization on the accepted
  run.
