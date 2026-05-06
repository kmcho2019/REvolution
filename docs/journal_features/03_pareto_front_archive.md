# Pareto-Front Archive: MO-MAP-Elites

## Active Goal

Replace the current Phase 03 `pareto_front` behavior with the updated
LLM-driven MO-MAP-Elites architecture:

1. each occupied behavior cell stores up to `K` local members;
2. local insertion uses NSGA-II non-dominated rank plus crowding distance;
3. parent selection samples an occupied cell uniformly, then uses a local
   crowded tournament;
4. one-parent and two-parent success operators are selected with a configurable
   probability;
5. a read-only per-problem global Pareto archive tracks every archiveable PPA
   point observed during the run.

`qd_cell_mode` remains a small discriminated union:

```text
qd_cell_mode = scalar_elite | pareto_front
```

Do not add a public compatibility mode for the earlier non-dominated-only
Phase 03 behavior. The updated `pareto_front` mode replaces that behavior
directly. Historical Phase 03 artifacts can be recognized by the absence of
the new local rank, crowding, parent-arity, and global-archive fields.

The journal target mode is:

```text
--search_mode revolution_qd
--qd_archive_type grid_quantile
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_cell_mode pareto_front
--qd_max_elites_per_cell 5
--qd_objectives ppa
--qd_two_parent_probability 0.5
--qd_grid_quantile_warmup_successes 8
```

The original 75/25 one-parent/two-parent idea is reproduced with:

```text
--qd_two_parent_probability 0.25
```

## Motivation

Power, area, and timing are a trade-off surface, not one natural scalar.
Weighted-sum archive replacement can delete designs that are useful under a
different PPA preference. The archive should preserve both behavior diversity
across MAP-Elites cells and PPA trade-off diversity inside each cell.

Phase 03 already proved the cell-mode abstraction across `grid`, `cvt`, and
`grid_quantile`, but it kept only mutually non-dominated members per cell.
The updated goal is stricter: keep a bounded local NSGA-II population per cell,
retain lower-rank dominated members while capacity allows, and expose a
separate global Pareto frontier for final analysis.

## Implementation Scope

Implement only the updated Phase 03 archive and selection work:

- replace non-dominated-only `pareto_front` insertion with local NSGA-II cell
  insertion;
- compute objectives once at the archive boundary and pass a required
  `ArchiveMember.objectives` dict into all archive logic;
- add transient rank/crowding views for insertion, parent selection, artifacts,
  and validation;
- add local crowded tournament parent selection;
- add configurable one-parent/two-parent operator selection;
- add a read-only per-problem global Pareto archive;
- update artifacts, reports, docs, docstrings, and validators.

Do not implement KS-triggered re-binning, two-tier fail-pool changes,
thought-only individuals, k-code evaluation, success-rate-aware dominance,
global-archive parent selection, or new prompt semantics in this phase.

Keep archive geometry orthogonal to cell behavior. `grid`, `cvt`, and
`grid_quantile` remain archive geometry choices. `scalar_elite` and
`pareto_front` remain cell behavior choices. Focused tests and tiny live smokes
must exercise the updated `pareto_front` behavior on all three geometries. The
full hard acceptance run intentionally targets only:

```text
grid_quantile + journal_logic_ff_width_3d
```

## Satisfactory End State

The updated Phase 03 goal is complete only when all of these are true:

1. `scalar_elite` preserves existing one-best-by-`quality_score` behavior for
   `grid`, `cvt`, and `grid_quantile`.
2. Updated `pareto_front` works for `grid`, `cvt`, and `grid_quantile`.
3. Every local cell stores at most `qd_max_elites_per_cell` members.
4. Local insertion computes one-based Pareto ranks over active PPA objectives
   inside the target cell.
5. Dominated same-cell members may remain while capacity allows and are
   emitted with `pareto_rank > 1`.
6. Exact duplicate active-objective tuples in the same cell are rejected,
   keeping the earlier member.
7. Overflow culling removes one member from the worst local rank; ties inside
   that rank use standard NSGA-II crowding distance, then newest insertion
   order, then candidate id.
8. Parent selection is uniform over occupied cells, then a binary crowded
   tournament without replacement inside the selected cell.
9. Tournament comparison uses lower `pareto_rank`, then higher
   `crowding_distance`, then older insertion order, then candidate id.
10. Two-parent selection uses two distinct occupied cells when at least two
    occupied cells exist.
11. Two-parent requests fall back to one-parent generation when fewer than two
    occupied cells exist, and the fallback count is reported separately.
12. `qd_two_parent_probability` is a concrete typed config value with default
    `0.5`; downstream code never receives `None`.
13. Operator arity is sampled per candidate using the existing seeded run RNG.
14. Existing prompt semantics are preserved; this phase wires parent arity and
    parent inputs, not new PPA-targeted prompts.
15. The per-problem global Pareto archive is enabled implicitly by
    `qd_cell_mode=pareto_front`.
16. The global archive considers every archiveable candidate with functional
    pass, synthesis/PPA pass, and complete active objectives, including
    `grid_quantile` warm-up successes and candidates later rejected or culled
    by the local cell archive.
17. The global archive rejects exact duplicate active-objective tuples,
    keeping the earliest archiveable candidate.
18. The global archive is never a parent source in this phase.
19. `archive_cells.csv` writes one row per local archive member and includes
    rank, crowding, parent arity, and local insertion metadata.
20. Separate global archive artifacts expose the per-problem global PPA front.
21. A strict validator exits `0` on the final hard-subset acceptance run and
    emits JSON plus Markdown reports.

## Data Model

Keep `ArchiveMember` small and immutable. Do not store mutable
`pareto_rank` or `crowding_distance` directly on the member unless the archive
has a clear invalidation rule. The recommended implementation is:

```text
ArchiveMember
ArchiveCellStats
RankedArchiveMember
GlobalParetoArchive
```

`ArchiveMember` should continue to hold stable candidate data:

- `candidate_id`
- `descriptors`
- `quality_score`
- `objectives`
- `payload`
- `insertion_index`

`RankedArchiveMember` should be a transient view used during insertion,
parent selection, artifact writing, and validation:

- `member`
- `pareto_rank`
- `crowding_distance`

`ArchiveCellStats` should be recomputed from the current cell members. With
`K=5`, recomputing rank and crowding on demand is simpler and safer than
maintaining cached mutable state.

`ArchiveMember.objectives` is required. The engine computes active objectives
once at the archive boundary and passes the completed dict into both local and
global archive logic. Missing active objectives are errors: combinational tasks
require `g_P` and `g_A`; sequential tasks require `g_P`, `g_A`, and `g_T`.

`quality_score` remains available for legacy reports, post-hoc comparison, and
representative-per-cell visualizations. It must not affect local rank,
dominance, duplicate rejection, culling, tournament selection, or global
Pareto insertion.

`entries()` or any representative-per-cell compatibility API should continue
to choose the highest-`quality_score` member only for legacy scalar views.
New archive logic and reports that need complete data must use explicit member
iterators.

## Local NSGA-II Cell Insertion

For updated `pareto_front`, insertion into a target behavior cell is:

1. validate that the member has all active objectives;
2. append the new member to the cell's temporary member list;
3. reject exact duplicate active-objective tuples in the same cell, keeping the
   earlier member;
4. compute local non-dominated fronts over the temporary cell members;
5. assign `pareto_rank=1` to the first front, `pareto_rank=2` to the second,
   and so on;
6. if cell size is at most `qd_max_elites_per_cell`, keep all members;
7. if cell size exceeds capacity, identify the worst rank present;
8. compute crowding distance only within that worst-rank group;
9. evict the member with lowest crowding distance in that group;
10. break exact eviction ties deterministically by newest insertion order, then
    candidate id.

Local ranks are one-based: `pareto_rank=1` is the best local front. Dominated
members are not discarded just because they are dominated. They remain in the
cell until capacity forces culling.

Use standard NSGA-II crowding distance:

- compute crowding within one rank group at a time;
- sort by each active objective;
- assign infinite distance to boundary members for each objective;
- add normalized neighbor gaps for interior members;
- ignore zero-span objectives.

For parent tournaments and artifact writing, recompute rank and crowding for
the selected/current cell on demand from current members. Do not cache mutable
rank state on archive members.

## Parent Selection

For updated `pareto_front`, success-parent selection is:

1. uniformly sample one occupied behavior cell;
2. if the cell has one member, return that member;
3. sample two distinct candidates from that cell for a binary tournament;
4. choose the candidate with lower `pareto_rank`;
5. if ranks tie, choose the candidate with higher `crowding_distance`;
6. if both tie exactly, choose deterministically by older insertion order, then
   candidate id.

For two-parent operators:

1. sample Bin A and choose Parent 1 by local tournament;
2. sample Bin B and choose Parent 2 by local tournament;
3. require `Bin A != Bin B` when at least two occupied cells exist;
4. if fewer than two occupied cells exist, downgrade that request to a
   one-parent operator and record the fallback in `qd_metrics.json` and the
   per-generation history.

Do not select parents from the global Pareto archive in the updated Phase 03
target. The global archive is read-only for final extraction and analysis.

## Operator Mix

Use one configuration value to keep the state space small:

```text
--qd_two_parent_probability 0.5
```

Rules:

- valid range is `0.0 <= qd_two_parent_probability <= 1.0`;
- one-parent probability is `1.0 - qd_two_parent_probability`;
- default is `0.5`;
- the original 75/25 architecture is expressed as
  `qd_two_parent_probability=0.25`;
- the value applies only to updated `pareto_front` QD success-parent
  generation; scalar behavior remains unchanged;
- the value is sampled once per candidate reproduction attempt;
- sampling uses the existing seeded run RNG;
- the selected parent arity must be recorded per generated candidate;
- fallback from two-parent to one-parent must be counted separately from the
  configured probability.

Do not add both `qd_one_parent_probability` and
`qd_two_parent_probability`; a single probability is easier to validate and
cannot drift out of normalization.

## Global Pareto Archive

Add a separate flat archive per benchmark/problem run. Do not compare PPA
points across different problems in the runtime archive. Cross-problem analysis
belongs in reports with explicit normalization.

The global archive is enabled implicitly by `qd_cell_mode=pareto_front`. Do not
add `qd_global_archive_mode` unless a later phase proves it is necessary.

An archiveable candidate must have:

- functional verification pass;
- synthesis/PPA extraction pass;
- complete active objectives for the problem circuit type.

Functionality-only candidates without complete PPA metrics must not enter the
global archive because dominance cannot be evaluated for them.

Global archive update is independent of local cell insertion:

1. build an `ArchiveMember` for every archiveable candidate;
2. update the local MAP-Elites cell archive and the global Pareto archive from
   the same member at the archive boundary;
3. reject exact duplicate active-objective tuples globally, keeping the
   earliest member;
4. discard the new member globally if an existing global member dominates it;
5. insert it globally if it is non-dominated by all existing global members;
6. remove any existing global members dominated by the inserted member.

The member should be considered for the global archive even if local cell
insertion later culls it. The global archive is the final absolute PPA
frontier observed during the run, while the MAP-Elites grid remains the parent
source and behavior-diversity mechanism. `grid_quantile` warm-up successes
enter the global archive as soon as they are archiveable, even before quantile
cells are initialized.

Required global archive artifacts:

- `global_pareto_archive.csv`
- `global_pareto_summary.json`
- `global_pareto_history.jsonl`

Each global archive row should include:

- `candidate_id`
- `benchmark`
- `problem`
- `generation`
- `strategy`
- `parent_arity`
- `code_file_path`
- `quality_score`
- active PPA objective columns
- `objectives_json`
- `descriptors_json`

Global rows should not require `cell_id`; the global archive is independent of
local geometry. Local insertion decisions belong in local archive events and
summaries, not as required global-row fields.

`archive_summary.json`, `qd_metrics.json`, and `archive_history.jsonl` keep
existing local archive fields unchanged and add compact global fields such as
`global_pareto_size` and global objective names. Do not redefine
`total_archive_members`; it remains the local MAP-Elites archive member count.

Each candidate's `qd_archive_event.json` should include compact global update
metadata:

- `global_archive_inserted`
- `global_archive_reject_reason`
- `global_archive_removed_count`
- `global_archive_size`

Do not dump the full global archive into every candidate event.

## Artifact Contract

`archive_cells.csv` writes one row per local archive member. Rows must include:

- `cell_id`
- `member_index`
- `cell_member_count`
- `pareto_rank`
- `crowding_distance`
- `candidate_id`
- `quality_score`
- `generation`
- `strategy`
- `parent_arity`
- `code_file_path`
- active PPA objective columns
- `objectives_json`
- `descriptors_json`
- `parent_ids_json`
- `local_insert_decision`

Per-candidate `qd_archive_event.json` records the post-insert local view for
the candidate. If insertion accepted the member and it survived culling, record
its final rank and crowding distance. If culling occurred, record the evicted
candidate id and reason. If the candidate was locally rejected, record the
rejection reason and current cell stats.

Reports that discuss behavior-space coverage count distinct `cell_id` values.
Reports that discuss archive size use local `total_archive_members`. Reports
that discuss final global PPA trade-offs use `global_pareto_size` and
`global_pareto_archive.csv`.

## Validation Loop

Follow this loop before accepting the implementation:

1. run the Phase 03 focused tests before editing and record the baseline;
2. add unit tests for local rank assignment and crowded culling;
3. add unit tests for global Pareto archive insertion and deletion;
4. add unit tests for binary crowded tournament parent selection;
5. add deterministic tests for `qd_two_parent_probability` at `0.0`, `0.5`,
   and `1.0`;
6. add artifact tests for local ranks, crowding distances, parent arity, and
   global archive rows;
7. run local small-scale smoke for `grid`, `cvt`, and `grid_quantile`;
8. run a live smoke comparing classic and updated `pareto_front`;
9. run a fixed-seed 13-problem hard-subset matrix for classic and
   `grid_quantile_pareto_journal_bd`;
10. run a strict validator and only accept the goal if every quantitative gate
    below passes.

## Required Tests

Add focused tests for:

- local non-dominated sorting with two or more fronts;
- dominated same-cell members being retained when capacity allows;
- overflow culling from the worst rank;
- crowding-distance culling preserving objective extremes within the culled
  rank;
- duplicate active-objective tuple rejection;
- `K=5` capacity enforcement;
- parent tournament prefers lower rank;
- parent tournament uses higher crowding distance when ranks tie;
- parent tournament deterministic tie-break;
- one-parent/two-parent arity selection for probabilities `0.0`, `0.5`, and
  `1.0`;
- two-parent fallback when fewer than two occupied cells exist;
- two-parent selection uses distinct cells when at least two occupied cells
  exist;
- generated candidate lineage records one parent id for one-parent generation
  and two distinct parent ids for two-parent generation;
- global archive rejects dominated candidates;
- global archive removes members dominated by a new candidate;
- global archive considers candidates that are culled locally;
- global archive considers `grid_quantile` warm-up successes;
- global archive rejects exact duplicate active-objective tuples, keeping the
  earlier member;
- artifact rows include `pareto_rank`, `crowding_distance`, `parent_arity`,
  and global archive fields;
- all three geometries support updated `pareto_front`;
- CLI/backend/wrapper config passes through
  `qd_two_parent_probability`;
- scalar archive behavior and Phase 02 grid-quantile behavior remain
  unchanged.

## Quantitative Acceptance Gates

The updated Phase 03 goal is complete only when all gates pass:

- focused tests pass;
- ruff passes on touched files;
- pyright passes on touched source files, or unrelated existing type debt is
  documented;
- `bash -n scripts/run_hard_iteration_qd_vllm.sh` passes;
- tiny live Pareto smoke passes for `grid`, `cvt`, and `grid_quantile`;
- full fixed-seed 13-problem hard-subset validation passes for
  `grid_quantile_pareto_journal_bd`;
- validator exits `0`;
- `failure_count=0`;
- `problem_invalid_count=0`;
- `acceptance_error_count=0`;
- every local cell has `member_count <= qd_max_elites_per_cell`;
- every local cell row has `pareto_rank >= 1`;
- deterministic synthetic tests show retained local members with
  `pareto_rank > 1`;
- local culling removes only from the worst rank present before culling;
- global Pareto archive members are pairwise non-dominated;
- global Pareto archive rows have complete active objectives and no duplicate
  active-objective tuples;
- `global_pareto_archive.csv` row count equals
  `global_pareto_summary.json.total_global_pareto_members`;
- if a mode has any archiveable candidates, its global archive is nonempty;
- configured `qd_two_parent_probability=0.5` produces observed two-parent
  attempts within 5 percentage points of 50% on runs with at least 100
  success-parent attempts and at least two occupied cells;
- two-parent fallback count is reported separately and is not counted as a
  probability miss;
- for every hard-subset problem solved by classic, updated
  `grid_quantile_pareto_journal_bd` also has at least one candidate with
  functional verification pass and synthesis/PPA extraction pass in the same
  fixed-seed final run.

Do not accept the goal on a cherry-picked rerun. If per-problem parity fails
against classic in the declared final run, the goal remains open.

## Resolved Design Decisions

| Question | Decision |
|:---|:---|
| Should the updated target add `nsga2_cell`? | No. Replace `pareto_front` semantics directly. |
| Should old non-dominated-only behavior remain public? | No. Keep it only as historical context. |
| How are old and new artifacts distinguished? | Infer from explicit rank/crowding/global fields; do not add version bloat. |
| Store rank/crowding on `ArchiveMember`? | No. Compute transient ranked views. |
| May dominated same-cell members remain? | Yes, until capacity forces culling. |
| Same-cell duplicate active objectives? | Keep the first member. |
| Global duplicate active objectives? | Keep the first archiveable member. |
| Global archive scope? | Per benchmark/problem run. |
| Global archive parent source? | Never in this phase. |
| Global archive config? | Implied by `qd_cell_mode=pareto_front`; no extra mode flag. |
| Archiveable candidate definition? | Functional pass, synthesis/PPA pass, complete active objectives. |
| `grid_quantile` warm-up global handling? | Warm-up successes enter the global archive once archiveable. |
| Operator default? | 50/50 via `qd_two_parent_probability=0.5`. |
| Original 75/25 setting? | `qd_two_parent_probability=0.25`. |
| Operator scope? | Updated `pareto_front` QD only; scalar behavior unchanged. |
| Operator sampling unit? | Per candidate reproduction attempt. |
| RNG source? | Existing seeded run RNG. |
| Prompt scope? | Keep existing prompt semantics. |
| Two-parent cells? | Distinct cells when at least two occupied cells exist. |
| Two-parent fallback? | Fall back to one-parent and count separately. |
| Tournament sampling? | Two distinct members without replacement when possible. |
| Representative-per-cell view? | Highest `quality_score` for legacy reports only. |
| Hard validation matrix? | Classic plus `grid_quantile_pareto_journal_bd`. |
| Solved definition for parity? | Functional verification plus synthesis/PPA extraction. |
| Parity policy? | One fixed declared seed; per-problem parity against classic. |
| Local `pareto_rank > 1` evidence? | Required in deterministic synthetic tests, not forced in live runs. |

## Current Repo Seams For Updated Target

Start from the current Phase 03 implementation in these files:

```text
src/revolution/qd/archive.py
src/revolution/qd/types.py
src/revolution/qd/engine.py
src/revolution/qd/artifacts.py
src/revolution/qd/visualization.py
src/revolution/qd/pareto_analysis.py
src/revolution/backends/revolution_backend.py
scripts/run_backend.py
scripts/run_hard_iteration_qd_vllm.sh
scripts/backend_comparison_report.py
scripts/report_hard_iteration_analysis.py
scripts/report_qd_feature_space.py
scripts/validate_grid_quantile_run.py
scripts/validate_pareto_front_run.py
tests/revolution/test_qd_archive.py
tests/revolution/test_qd_engine.py
tests/revolution/test_pareto_analysis.py
tests/scripts/test_backend_comparison_report.py
```

Useful search:

```bash
rg -n "GridArchiveEntry|quality_score|entries\\(|insert\\(|archive_cells|pareto|g_P|g_A|g_T|qd_score|occupied_cells" \
  src/revolution/qd src/revolution/backends scripts tests
```

The current Phase 03 code already resolved the original one-elite-per-cell
assumption for `pareto_front`. The updated target has different seams:

- `QDCellMode` currently accepts only `scalar_elite` and `pareto_front`.
- `_insert_pareto` keeps only mutually non-dominated members; it does not keep
  lower-rank dominated members in a cell.
- Archive members do not expose transient `pareto_rank` or
  `crowding_distance` views.
- `QDEngine._sample_success_parents()` uses uniform cell/member sampling for
  `pareto_front`; it does not run a local crowded tournament.
- The success-operator scheduler still uses existing strategy selection; it
  does not have `qd_two_parent_probability`.
- There is no separate `GlobalParetoArchive`.
- `archive_cells.csv`, `archive_summary.json`, `qd_metrics.json`, and
  per-candidate events do not yet expose local rank, crowding distance,
  parent arity, or global archive decisions.
- `scripts/run_hard_iteration_qd_vllm.sh`, `RevolutionBackendConfig`, and
  resolved run summaries do not yet forward or record
  `qd_two_parent_probability`.

## Historical Completed Phase 03 Record

The sections below describe the completed non-dominated-only Phase 03
implementation and its validation record. Keep them as context for what has
already landed, but treat the active target above as the source of truth for
the next implementation goal.

## Phase 03 Implementation Specification

### Archive Model

Use a small explicit archive member representation. Keep the archive insertion
surface narrow by constructing this object once at the engine/archive boundary,
then passing the object through front logic instead of passing parallel
candidate/objective/descriptor arguments.

Required fields:

- `candidate_id`
- `descriptors`
- `quality_score`
- `objectives`
- `payload`
- insertion order or stable archive member id

`objectives` must be required for every archive insertion in Phase 03, even in
`scalar_elite` mode. Scalar mode stores the objective payload for reports but
continues to compare by `quality_score`. Do not make objectives optional and
then branch around absence in normal archive code.

Add an explicit flat member iterator, for example:

```python
archive.members() -> list[tuple[str, ArchiveMember]]
```

For scalar archives this returns one member per occupied cell with
`member_index=0`. For Pareto-front archives it returns every member in every
front. Stable member ids should come from candidate id or archive insertion
order; `member_index` is a deterministic per-snapshot CSV/report index within
the current cell front.

Do not leave ambiguous call sites using `entries()` when they need every archive
member. During Phase 03 either:

- keep `entries()` as an explicit representative-per-cell legacy API and add a
  clearer `representative_entries()` name for new code; or
- migrate internal callers to `members()` and reserve `entries()` only for
  scalar archives.

Every remaining `entries()` call site after the patch must be intentional and
covered by tests or a short code comment. The representative for a Pareto cell,
when one is unavoidable for legacy scalar reports or visualizations, should be
the highest `quality_score` member in that cell. This representative rule must
not affect dominance, insertion, or parent sampling.

Existing archive rebuild/finalization paths must reinsert every archive member,
not only representatives. `grid_quantile` warm-up replay and run-finalization
fallback must reconstruct fronts with the same dominance and crowding rules.
KS-triggered dynamic re-binning remains Phase 07 and must not be added here.

Good implementation shape:

```text
ArchiveMember
ArchiveCellMode = Literal["scalar_elite", "pareto_front"]
QDObjectiveMode = Literal["ppa"]
active_objective_names(circuit_type)
dominates(left, right, objective_names)
insert_member(front, member, max_elites_per_cell, objective_names)
```

Keep helper count small. The goal is to make the control flow easy to read in
`insert`, not to build a generic multiobjective framework.

### Dominance

Use PPA-only dominance for archive replacement.

Active objectives are:

- sequential tasks: maximize `g_P`, `g_A`, and `g_T`
- combinational tasks: maximize `g_P` and `g_A`

Determine task type from `ProblemSpec.circuit_type` when available. Legacy
fallbacks based on reference `eff_clk_period` are acceptable only for existing
test harnesses that do not construct a `ProblemSpec`; production journal runs
must record the resolved circuit type and objective names.

A member dominates another member when it is greater than or equal on every
active objective and strictly greater on at least one active objective.

Insertion rules:

- If a new member is dominated by any existing member in the cell, discard it.
- If the new member dominates existing members, remove those members.
- If the new member is non-dominated, insert it.
- If the active objective tuple exactly matches an existing member in the same
  cell, treat it as a duplicate and keep the existing member. This keeps bounded
  fronts from filling with identical PPA points and does not use
  `quality_score` for Pareto replacement.

Missing active objectives are errors. Combinational tasks must not require
`g_T`; sequential tasks must fail clearly if `g_T` cannot be computed.

Scalar `quality_score` must not be used for Pareto replacement. It remains
available for legacy baseline comparisons, representative ordering when a
scalar is unavoidable, future representative-code selection in k-code
evaluation, and post-hoc reporting.

### Front Bounding

Bound each Pareto cell by `max_elites_per_cell`.

When a front exceeds the limit, use NSGA-II crowding distance over the active
objectives:

- Normalize each objective by that objective's min/max range within the cell
  front.
- Assign infinite distance to boundary members for every active objective so
  PPA extremes are preserved.
- Sum normalized neighbor gaps for interior members.
- Evict the member with the lowest finite crowding distance.
- Break exact eviction ties deterministically by newest insertion order, then
  candidate id.

The implementation must be deterministic under a fixed seed.

### Parent Sampling

Parent sampling for the journal Pareto mode must be:

1. uniformly sample one occupied behavior cell;
2. uniformly sample one member from that cell's front.

Do not weight Pareto-front parent sampling by `quality_score`. Existing scalar
archive modes may keep current behavior unless the code is simpler with a
single uniform archive-sampling path, but `pareto_front` must be tested
directly.

## Phase 03 Configuration

Add an explicit cell-mode config surface:

```text
--qd_cell_mode scalar_elite
--qd_cell_mode pareto_front
--qd_max_elites_per_cell 5
--qd_objectives ppa
```

Recommended defaults:

```text
qd_cell_mode=scalar_elite
qd_max_elites_per_cell=1
qd_objectives=ppa
```

The journal Phase 03 target mode is:

```text
--search_mode revolution_qd
--qd_archive_type grid_quantile
--qd_descriptor_profile journal_logic_ff_width_3d
--qd_cell_mode pareto_front
--qd_max_elites_per_cell 5
--qd_objectives ppa
--qd_grid_quantile_warmup_successes 8
```

`qd_cell_mode` and `qd_objectives` must be discriminated unions. Unknown values
must fail at argument parsing or engine construction. `qd_max_elites_per_cell`
must be positive in `pareto_front` mode.

`qd_objectives` is intentionally fixed to `ppa` for the first journal
implementation. Success rate from future k-code evaluation is stored for
analysis but does not participate in Phase 03 dominance.

Do not add a `qd_grid_quantile_bins_per_axis` flag in Phase 03. Phase 02 fixed
the journal `grid_quantile` geometry to four intended bins per axis; configurable
quantile bin count remains deferred.

Pass the new config through all runtime surfaces:

- `scripts/run_backend.py`
- `RevolutionBackendConfig`
- `QDEngine`
- resolved `*_revolution_config.yaml`
- summary `backend_details.qd_config`
- `scripts/run_hard_iteration_qd_vllm.sh`
- hard-subset manifest keys
- relevant tests for defaults and backend config wiring

## Phase 03 Artifact And Report Contract

- `archive_cells.csv` writes one row per Pareto member.
- Per-member rows include:
  - `cell_id`
  - `member_index`
  - `front_size`
  - `candidate_id`
  - `quality_score`
  - `g_P`
  - `g_A`
  - `g_T` when active or available
  - `objectives_json`
  - `descriptors_json`
  - `parent_ids_json`
- `archive_summary.json` records:
  - `archive_type`
  - `cell_mode`
  - `occupied_cells`
  - `total_archive_members`
  - `mean_front_size`
  - `max_front_size`
  - `max_elites_per_cell`
  - `objective_names`
  - legacy scalar quality fields when available
- `qd_metrics.json` and `archive_history.jsonl` record front statistics per
  generation:
  - `occupied_cells`
  - `total_archive_members`
  - `mean_front_size`
  - `max_front_size`
  - `new_archive_members`
  - `evicted_archive_members`
  - `dominated_rejections`

For backwards-compatible report fields:

- `coverage` remains `occupied_cells / num_cells`.
- `qd_score` remains a legacy scalar representative score for comparing with
  existing reports. It should sum one representative `quality_score` per
  occupied cell, not drive archive replacement.
- Add explicit member-based fields rather than overloading `occupied_cells` or
  `qd_score`.

Existing Pareto analysis, hard-iteration analysis, feature-space reports, and
backend comparison reports must not assume one row per cell when they read
`archive_cells.csv`. Reports that present cell coverage should count distinct
`cell_id`; reports that present archive size should use `total_archive_members`.

Grid-quantile visualization may continue to show one representative per cell,
but its manifest and validation must distinguish representative cell count from
front member row count.

## Phase 03 Testing Plan

### Baseline Before Editing

Run this before implementation changes:

```bash
/workspace/.venv/bin/python -m pytest \
  tests/revolution/test_qd_archive.py \
  tests/revolution/test_qd_engine.py \
  tests/revolution/test_pareto_analysis.py \
  -q
```

Current baseline in this worktree:

```text
54 passed
```

### Required Unit And Integration Tests

Add focused tests for:

- dominance with sequential objectives: `g_P`, `g_A`, `g_T`
- dominance with combinational objectives: `g_P`, `g_A`
- missing sequential `g_T` fails clearly
- combinational tasks do not require `g_T`
- dominated insertion is discarded
- dominant insertion removes dominated members
- non-dominated insertion keeps multiple members
- exact active-objective duplicates do not consume front capacity
- cell fronts respect `max_elites_per_cell`
- crowding-distance eviction preserves objective extremes
- parent sampling can sample any member in a front
- `scalar_elite` mode preserves existing scalar replacement behavior
- `grid`, `cvt`, and `grid_quantile` geometry still work with
  `scalar_elite`
- `grid`, `cvt`, and `grid_quantile` geometry can store Pareto fronts
- `grid_quantile` warm-up replay and finalization rebuild Pareto fronts
- `archive_cells.csv` writes one row per front member
- `archive_summary.json`, `qd_metrics.json`, and `archive_history.jsonl`
  report front stats
- backend config and CLI pass through `qd_cell_mode`,
  `qd_max_elites_per_cell`, and `qd_objectives`
- hard-subset wrapper forwards and records the new config fields
- reports count distinct cells separately from total front members

Focused test command:

```bash
/workspace/.venv/bin/python -m pytest \
  tests/revolution/test_qd_archive.py \
  tests/revolution/test_qd_engine.py \
  tests/revolution/test_pareto_analysis.py \
  tests/revolution/test_revolution_backend.py \
  tests/revolution/test_defaults.py \
  tests/scripts/test_backend_comparison_report.py \
  -q
```

Add validator tests for the new `scripts/validate_pareto_front_run.py` script,
including a synthetic multi-member cell and a deliberately dominated member
that must fail validation.

After focused tests pass, run lint and type checks on touched files:

```bash
/workspace/.venv/bin/ruff check \
  src/revolution/qd/archive.py \
  src/revolution/qd/types.py \
  src/revolution/qd/engine.py \
  src/revolution/qd/artifacts.py \
  src/revolution/qd/visualization.py \
  src/revolution/qd/pareto_analysis.py \
  src/revolution/backends/revolution_backend.py \
  scripts/run_backend.py \
  scripts/run_hard_iteration_qd_vllm.sh \
  scripts/validate_pareto_front_run.py \
  tests/revolution/test_qd_archive.py \
  tests/revolution/test_qd_engine.py \
  tests/revolution/test_pareto_analysis.py

/workspace/.venv/bin/python -m pyright \
  src/revolution/qd/archive.py \
  src/revolution/qd/types.py \
  src/revolution/qd/engine.py \
  src/revolution/qd/artifacts.py \
  src/revolution/qd/visualization.py \
  src/revolution/qd/pareto_analysis.py \
  src/revolution/backends/revolution_backend.py
```

If `pyright` reports unrelated import/environment noise, record the exact
failure and why it is unrelated.

If `scripts/run_hard_iteration_qd_vllm.sh` is touched:

```bash
bash -n scripts/run_hard_iteration_qd_vllm.sh
```

### Documentation Tests

Update these docs in the implementation commit series:

```text
docs/journal_features/03_pareto_front_archive.md
docs/qd_map_elites_guide.md
docs/module_structure.md
docs/user_guide.md
```

Docstrings or comments should clarify only non-obvious behavior:

- dominance semantics
- active objective selection
- crowding-distance eviction
- representative versus all-member archive APIs
- one row per Pareto member in artifacts

## Phase 03 Live vLLM Validation

### Preflight

Before live testing, verify the served model and record the model id:

```bash
curl http://host.docker.internal:8000/v1/models

MODEL_ID="$(curl -sS http://host.docker.internal:8000/v1/models | \
  /workspace/.venv/bin/python -c 'import json,sys; print(json.load(sys.stdin)["data"][0]["id"])')"

echo "${MODEL_ID}"
```

This is a reasoning-model validation path. Do not use tiny context settings to
judge Phase 03 behavior. Live QD validation should keep:

```text
max_model_len >= 128000
--max_tokens 128000
--diff_max_tokens 128000
--vllm_min_model_len 128000
```

### Direct Smoke

After unit tests pass, run a small classic baseline and a Pareto-front QD smoke
matrix over all three archive geometries. The smoke verifies wiring and
artifacts; it is not a performance claim.

```bash
RUN_ROOT="exp/journal_pareto_front_smoke_$(date +%Y%m%d_%H%M%S)"

/workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --search_mode revolution \
  --benchmarks RTLLM \
  --problems Prob004_adder_8bit Prob015_multi_pipe_8bit \
  --api_backend vllm \
  --vllm_host host.docker.internal \
  --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name "${MODEL_ID}" \
  --population_size 4 \
  --num_generations 1 \
  --total_worker_slots 1 \
  --max_active_problems 1 \
  --max_workers_per_problem 1 \
  --evaluation_mode search_accelerated \
  --accelerated_synthesis_top_k 1 \
  --temperature 1.0 \
  --top_p 1.0 \
  --max_tokens 128000 \
  --diff_max_tokens 128000 \
  --save_path "${RUN_ROOT}/classic" \
  --no-backend_subdir \
  --seed 42

for ARCHIVE_TYPE in grid cvt grid_quantile; do
  EXTRA_ARGS=()
  if [[ "${ARCHIVE_TYPE}" == "cvt" ]]; then
    EXTRA_ARGS+=("--qd_cvt_warmup_successes" "4")
  fi
  if [[ "${ARCHIVE_TYPE}" == "grid_quantile" ]]; then
    EXTRA_ARGS+=("--qd_grid_quantile_warmup_successes" "4")
  fi

  /workspace/.venv/bin/python scripts/run_backend.py \
    --backend revolution \
    --search_mode revolution_qd \
    --qd_archive_type "${ARCHIVE_TYPE}" \
    --qd_descriptor_profile journal_logic_ff_width_3d \
    --qd_cell_mode pareto_front \
    --qd_max_elites_per_cell 5 \
    --qd_objectives ppa \
    --qd_num_cells 16 \
    "${EXTRA_ARGS[@]}" \
    --benchmarks RTLLM \
    --problems Prob004_adder_8bit Prob015_multi_pipe_8bit \
    --api_backend vllm \
    --vllm_host host.docker.internal \
    --vllm_port 8000 \
    --vllm_min_model_len 128000 \
    --model_name "${MODEL_ID}" \
    --population_size 4 \
    --num_generations 1 \
    --total_worker_slots 1 \
    --max_active_problems 1 \
    --max_workers_per_problem 1 \
    --evaluation_mode search_accelerated \
    --accelerated_synthesis_top_k 1 \
    --temperature 1.0 \
    --top_p 1.0 \
    --max_tokens 128000 \
    --diff_max_tokens 128000 \
    --save_path "${RUN_ROOT}/${ARCHIVE_TYPE}_pareto" \
    --no-backend_subdir \
    --seed 42
done

/workspace/.venv/bin/python scripts/backend_comparison_report.py \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_pareto="${RUN_ROOT}/grid_pareto" \
  --backend_run cvt_pareto="${RUN_ROOT}/cvt_pareto" \
  --backend_run grid_quantile_pareto="${RUN_ROOT}/grid_quantile_pareto" \
  --output "${RUN_ROOT}/backend_comparison.md"
```

Smoke success criteria:

- classic and all three Pareto QD smoke runs complete;
- `grid`, `cvt`, and `grid_quantile` all accept `qd_cell_mode=pareto_front`;
- each QD archive initializes or records a valid warm-up/finalization state;
- each QD run writes `archive_cells.csv` with one row per Pareto member;
- each QD run writes `archive_summary.json`, `qd_metrics.json`, and
  `archive_history.jsonl` with front statistics;
- live smoke does not need `max_front_size > 1`, but synthetic/unit tests must
  prove multi-member fronts;
- no Pareto smoke mode collapses to all failures when classic produces
  successes.

### Full Hard-Subset Acceptance Run

Phase 03 should use the same acceptance style as the Phase 02 final
grid-quantile run at:

```text
exp/journal_quantile_binning_hard_subset_final/20260505_022158
```

This is intentionally stronger than the all-geometry smoke. The final gate is a
full 13-problem hard-subset matrix with the live vLLM backend, long-context
token settings, generated comparison reports, and a strict validation artifact.
Hard acceptance is scoped to the journal target path:
`grid_quantile + journal_logic_ff_width_3d`. `grid` and `cvt` Pareto-front
coverage are required in focused tests and smoke runs, but they are not part of
the full hard-subset acceptance matrix.

Create a scratch config under `exp/`; do not commit it unless explicitly
requested:

```bash
mkdir -p exp/journal_pareto_front_configs
cp data/configs/hard_iteration_subset.yaml \
  exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml
```

Set the matrix to include the classic baseline, the Phase 02 scalar
grid-quantile control, and the new Pareto-front mode:

```yaml
matrix_modes:
  - classic
  - grid_quantile_journal_bd
  - grid_quantile_pareto_journal_bd

modes:
  classic:
    search_mode: revolution
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
    seed: 42
```

`qd_cell_mode` should be a discriminated union. Unknown values must fail. The
exact implemented names may differ if the codebase has a better local naming
pattern, but the final docs and validation manifest must record the resolved
cell mode, max front size, and objective set for each mode.

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
HARD_SUBSET_TOTAL_WORKER_SLOTS=4 \
HARD_SUBSET_MAX_ACTIVE_PROBLEMS=4 \
HARD_SUBSET_MAX_WORKERS_PER_PROBLEM=4 \
HARD_SUBSET_SAVE_PATH=exp/journal_pareto_front_hard_subset \
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml \
  --mode matrix
```

The manifest must show:

- `reported_max_model_len >= 128000`.
- `population_size=20`.
- `num_generations=5`.
- `total_worker_slots=4`.
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

After the run, generate the same report family as Phase 02:

```bash
RUN_ROOT="<printed save path from wrapper>"

/workspace/.venv/bin/python scripts/backend_comparison_report.py \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_journal_bd="${RUN_ROOT}/grid_quantile_journal_bd" \
  --backend_run grid_quantile_pareto_journal_bd="${RUN_ROOT}/grid_quantile_pareto_journal_bd" \
  --output "${RUN_ROOT}/backend_comparison.md"

/workspace/.venv/bin/python scripts/report_final_analysis_bundle.py \
  --run-root "${RUN_ROOT}" \
  --subset-config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml

/workspace/.venv/bin/python scripts/report_pareto_analysis.py \
  --subset-config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_journal_bd="${RUN_ROOT}/grid_quantile_journal_bd" \
  --backend_run grid_quantile_pareto_journal_bd="${RUN_ROOT}/grid_quantile_pareto_journal_bd" \
  --output-dir "${RUN_ROOT}/pareto_analysis"

/workspace/.venv/bin/python scripts/report_design_space_analysis.py \
  --run-root "${RUN_ROOT}" \
  --subset-config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml \
  --feature-profile journal_logic_ff_width_3d
```

Add a strict Pareto-front audit command, mirroring
`scripts/validate_grid_quantile_run.py`:

```bash
/workspace/.venv/bin/python scripts/validate_pareto_front_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml \
  --classic-mode classic \
  --scalar-qd-mode grid_quantile_journal_bd \
  --pareto-qd-mode grid_quantile_pareto_journal_bd \
  --require-full-subset \
  --acceptance-hard-subset
```

The audit command must emit:

- `pareto_front_validation.json`.
- `pareto_front_validation.md`.
- non-zero exit status on any failed hard gate.

The validation report must lead with a per-problem acceptance table containing:

- problem name and circuit type.
- classic final successful PPA sample count.
- scalar grid-quantile archiveable sample count.
- Pareto grid-quantile archiveable sample count.
- Pareto archive validation state.
- occupied cells.
- total archive members.
- mean and max front size.
- objective names.
- non-trivial-front status.
- notes for warmup-limited, degenerate, missing-artifact, dominated-member, or
  performance-regression checks.

The validation report must also record resolved settings for every mode,
including seed, population size, generation count, token limits,
`reported_max_model_len`, `total_worker_slots`, `max_active_problems`,
`max_workers_per_problem`, `qd_cell_mode`, `qd_max_elites_per_cell`, and
`qd_objectives`. For Phase 03 acceptance, validation must fail if the resolved
worker or token settings do not match this document.

## Phase 03 Quantitative Acceptance Gates

The full hard-subset run is satisfactory only if every hard gate passes:

- `problem_count=13`.
- `failure_count=0`.
- `problem_invalid_count=0`.
- `acceptance_error_count=0`.
- `final_analysis/summary.json` exists with no skipped sections.
- `final_analysis/hard_iteration_analysis/summary.json` covers all 13
  problems.
- `final_analysis/pareto_analysis/summary.json` covers every backend/problem
  pair in the matrix.
- `final_analysis/design_space_analysis/summary.json` has successful
  candidates and all 13 pairwise feature comparisons.
- `final_analysis/ppa_distribution/summary.json` exists.
- `final_analysis/feature_analysis/summary.json` exists.
- `final_analysis/summary.json` has an empty `skipped_sections` list.

Each Pareto QD problem must emit the standard QD artifacts:

- `archive_history.jsonl`.
- `archive_cells.csv`.
- `archive_summary.json`.
- `archive_space.json`.
- `descriptor_health.json`.
- per-candidate `qd_archive_event.json`.

The Pareto validation script must check archive-specific invariants:

- `archive_cells.csv` writes one row per Pareto member, not one row per cell.
- `archive_summary.json` records `total_archive_members`,
  `mean_front_size`, `max_front_size`, `max_elites_per_cell`, and
  `objective_names`.
- `total_archive_members >= occupied_cells`.
- `archive_cells.csv` row count equals `total_archive_members`.
- distinct `archive_cells.csv.cell_id` count equals `occupied_cells`.
- `max_front_size <= max_elites_per_cell`.
- every row has `member_index < front_size`.
- every cell's row count equals that row's `front_size`.
- every member in one cell is non-dominated by every other member in that cell.
- combinational problems use `g_P` and `g_A`; sequential problems use `g_P`,
  `g_A`, and `g_T`.
- cells at the front-size limit preserve objective extremes after crowding
  eviction.
- parent sampling audit proves no front member is unreachable in synthetic
  tests.
- at least one full hard-subset run shows a non-trivial front:
  `max_front_size > 1` for at least one Pareto QD problem.

Performance gates are regression guards, not paper claims:

- Pareto QD must complete the same 13 problems as classic and scalar
  grid-quantile unless a blocked problem is explicitly diagnosed.
- Functional and synthesis any-pass counts must not be worse than classic by
  more than one problem.
- Functional and synthesis pass@1 means must not be more than 10 percentage
  points below both classic and scalar grid-quantile.
- Mean Pareto points should be at least the scalar grid-quantile control.
- Mean hypervolume should not regress more than 10% from the scalar
  grid-quantile control without a written analysis in the validation report.

The validation report must include a "Deferred From Phase 03" section listing:

- KS-triggered re-binning.
- two-tier fail pool and adaptive parent-source probability.
- single thought mutation operator.
- thought-only individuals and k-code evaluation.
- success-rate-aware archive analysis.
- configurable `grid_quantile` bin count.

## Implementation Rules

Apply these rules while implementing this phase:

1. Write simple, skimmable code.
2. Minimize possible states by narrowing state and reducing argument count.
3. Use discriminated unions for archive geometry, cell mode, and objective
   mode.
4. Exhaustively handle every multi-type object; fail on unknown variants.
5. Do not write defensive fallback code for values that should exist.
6. Use asserts when loading required data.
7. Remove changes not required for Phase 03.
8. Bias toward fewer lines of code.
9. Avoid clever code.
10. Do not split logic into tiny helpers when it makes the archive flow harder
    to read.
11. Prefer early returns.
12. Use asserts instead of broad try/except/defaults for expected values.
13. Do not pass overrides unless strictly necessary.
14. Do not make required arguments optional.

Concretely for Phase 03:

- Prefer one small `ArchiveMember` object over adding several new positional
  arguments to `insert`.
- Prefer `Literal` aliases for `QDCellMode` and `QDObjectiveMode`.
- Unknown `qd_cell_mode`, `qd_objectives`, or `qd_archive_type` values must
  raise immediately.
- Do not add compatibility shims for old experimental QD draft behavior unless
  a report or validator still needs a documented representative view.
- Keep `quality_score` as a reporting field and representative-ordering field,
  not as a hidden Pareto tie-break.

## Commit Guidance

Use atomic commits with `git commit -s`.

Good possible commits:

```text
feat(qd): Add Pareto cell fronts
test(qd): Cover Pareto archive insertion
docs(qd): Document Pareto archive mode
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

## Phase 03 Completion Checklist

Target deadline: `2026-05-06`

- [x] 3.1 Replace a single archive entry per cell with bounded front members.
- [x] 3.2 Implement PPA-only dominance over active objectives, accounting for
  combinational designs.
- [x] 3.3 Add NSGA-II crowding-distance eviction, preserve PPA extremes, parent
  sampling from fronts, and artifact/report updates.

## Implementation And Validation Log

### Stage 1: Archive Cell Mode

- Implemented `QDCellMode = Literal["scalar_elite", "pareto_front"]` and
  `QDObjectiveMode = Literal["ppa"]`.
- Added a small required `ArchiveMember.objectives` payload. The engine now
  computes active PPA objectives once at the archive boundary and passes that
  member object into the archive.
- Kept archive geometry separate from cell replacement behavior:
  `grid`, `cvt`, and `grid_quantile` all accept `scalar_elite` and
  `pareto_front`.

### Stage 2: Pareto Replacement

- Implemented maximize-form PPA dominance over `g_P`/`g_A` for combinational
  tasks and `g_P`/`g_A`/`g_T` for sequential tasks.
- Pareto replacement does not use `quality_score`; scalar mode still uses it
  for the legacy representative behavior.
- Added dominated rejection, duplicate-objective rejection, dominant-member
  removal, and bounded front eviction by crowding distance while preserving
  active-objective extremes.
- Parent sampling in Pareto mode is uniform over occupied cells, then uniform
  over members in the selected cell.

### Stage 3: Artifacts And Reports

- `archive.entries()` remains the representative-per-cell legacy view.
- `archive.members()` is the one-row-per-member view used by final archive
  artifacts, summaries, and parent sampling.
- `archive_cells.csv` now emits `cell_id`, `member_index`, `front_size`,
  `candidate_id`, `quality_score`, `g_P`, `g_A`, `g_T`, `objectives_json`,
  and `descriptors_json` for every archive member.
- `archive_summary.json`, `qd_metrics.json`, `archive_history.jsonl`,
  `archive_space.json`, and `qd_archive_event.json` include cell-mode,
  objective-name, total-member, and front-size data.
- Added `scripts/validate_pareto_front_run.py` for Phase 03 acceptance.

### Stage 4: Local Verification

- Passed the focused and regression test suite:
  - `tests/revolution/test_qd_archive.py`
  - `tests/revolution/test_qd_engine.py`
  - `tests/revolution/test_pareto_analysis.py`
  - `tests/revolution/test_revolution_backend.py`
  - `tests/revolution/test_defaults.py`
  - `tests/scripts/test_backend_comparison_report.py`
  - `tests/scripts/test_validate_pareto_front_run.py`
  - `tests/scripts/test_validate_grid_quantile.py`
  - `tests/scripts/test_run_hard_iteration_qd_vllm.py`
- Passed `ruff check` on touched Python files.
- Passed `pyright` on touched QD source files.
- Passed `bash -n scripts/run_hard_iteration_qd_vllm.sh`.

### Stage 5: Small Geometry Smokes

- Completed small Pareto smoke coverage for all archive geometries:
  `grid`, `cvt`, and `grid_quantile`.
- Direct archive smoke verified all three geometries can store Pareto members
  and report front stats.
- Live vLLM smoke completed for all three geometry modes at
  `exp/journal_pareto_front_smoke_20260505_135343`; the smoke verified CLI and
  artifact initialization paths. The smoke was not used as a performance claim.

### Stage 6: Full Hard-Subset Acceptance

- Completed the full 13-problem hard-subset matrix at
  `exp/journal_pareto_front_hard_subset/20260505_135953`.
- The matrix included:
  - `classic`
  - `grid_quantile_journal_bd`
  - `grid_quantile_pareto_journal_bd`
- The hard acceptance target was
  `grid_quantile + journal_logic_ff_width_3d` with
  `qd_cell_mode=pareto_front`, `qd_max_elites_per_cell=5`, and
  `qd_objectives=ppa`.
- Generated final reports:
  - `hard_iteration_backend_comparison.md`
  - `final_analysis/`
  - `pareto_analysis/`
  - `design_space_analysis/`
  - `pareto_front_validation.json`
  - `pareto_front_validation.md`
- Full Pareto-front acceptance validation passed with exit code `0`:
  `valid=true`, `failure_count=0`, `problem_invalid_count=0`,
  `acceptance_error_count=0`, and `max_front_size_seen=5`.
- The validator checked that `archive_cells.csv` row counts equal
  `total_archive_members`, distinct `cell_id` counts equal `occupied_cells`,
  every same-cell member pair is mutually non-dominated, and
  `max_front_size <= qd_max_elites_per_cell`.
