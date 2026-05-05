# Pareto-Front Archive: Multiobjective MAP-Elites

## Goal

Replace one elite per cell with a bounded Pareto front per cell. This makes the
journal QD archive preserve behavior diversity across cells and PPA trade-off
diversity inside each cell.

## Current State

The current archive keeps one best candidate per cell using a scalar
`quality_score`. Reports can compute Pareto fronts after a run, but archive
replacement itself is not multiobjective.

The journal runtime should make multiobjective preservation native to the
archive.

The motivation is hardware-specific: power, area, and timing are a trade-off
surface, not one natural scalar. Weighted-sum fitness makes one preference
dominate the archive and can delete designs that would be optimal under another
PPA preference. PPA islands are deferred because they split budget and add
migration policy without solving balanced trade-off preservation inside one
behavior cell.

## Satisfactory End State

Phase 03 is complete only when all of these are true:

1. `qd_cell_mode` is a first-class discriminated archive-cell variant with
   exactly `scalar_elite` and `pareto_front` accepted values.
2. `scalar_elite` preserves the existing one-best-by-`quality_score` behavior
   for `grid`, `cvt`, and `grid_quantile`.
3. `pareto_front` stores a bounded non-dominated front per occupied behavior
   cell for `grid`, `cvt`, and `grid_quantile`.
4. Pareto replacement uses only active PPA objectives:
   `g_P`/`g_A` for combinational tasks and `g_P`/`g_A`/`g_T` for sequential
   tasks. `quality_score` is never consulted for Pareto dominance,
   duplicate rejection, or crowding eviction.
5. Parent sampling in `pareto_front` mode is uniform over occupied cells and
   then uniform over that cell's members.
6. All archive/report APIs make the distinction between occupied behavior
   cells, total archive members, and representative-per-cell legacy views
   explicit.
7. `archive_cells.csv` writes one row per archive member, while reports that
   discuss behavior-space coverage count distinct `cell_id` values.
8. `archive_summary.json`, `qd_metrics.json`, `archive_history.jsonl`,
   `archive_space.json`, and per-candidate `qd_archive_event.json` expose
   enough cell-mode, objective, and front-size data to audit every insertion.
9. A strict `scripts/validate_pareto_front_run.py` command exits `0` on the
   final hard-subset acceptance run and emits both JSON and Markdown reports.
10. Small-scale smoke validation exercises `pareto_front` mode on all three
    archive geometries: `grid`, `cvt`, and `grid_quantile`.
11. A full 13-problem live vLLM hard-subset matrix completes for classic,
    scalar grid-quantile, and Pareto grid-quantile modes with the quantitative
    gates in this document passing.

## Implementation Scope

Implement only the Phase 03 checklist from `overall_plan.md`:

- 3.1 Replace a single archive entry per cell with bounded front members.
- 3.2 Implement PPA-only dominance over active objectives, accounting for
  combinational designs.
- 3.3 Add NSGA-II crowding-distance eviction, preserve PPA extremes, parent
  sampling from fronts, and artifact/report updates.

Do not implement KS-triggered re-binning, two-tier fail-pool changes, adaptive
parent-source probability, the single thought-only mutation operator,
thought-only individuals, k-code evaluation, or success-rate-aware archive
dominance in this phase.

Phase 03 must build on the Phase 02 `grid_quantile` archive geometry. Keep
`grid`, `cvt`, and `grid_quantile` as archive geometry choices; Pareto fronts
are cell replacement behavior and must be configured independently from
geometry. The abstraction and focused tests must cover all three geometries.
The full live acceptance run is intentionally narrower: it validates only the
journal target path, `grid_quantile + journal_logic_ff_width_3d`.

## Current Repo Seams

Start from these files:

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

The current code has several scalar-elite assumptions that must be deliberately
resolved:

- `GridArchiveEntry` is one occupant for one cell.
- `QDArchive.entries()` currently means one entry per occupied cell.
- `QDEngine._sample_success_parents()` uses score-weighted sampling.
- `QDEngine._archive_qd_score()` sums one scalar quality per cell.
- `archive_cells.csv` and grid-quantile visualizations assume one CSV row per
  final cell.
- `scripts/run_hard_iteration_qd_vllm.sh` only forwards existing QD config
  fields.
- `RevolutionBackendConfig` and resolved run summaries do not yet record cell
  mode, max front size, or objective mode.

## Implementation Specification

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

## Configuration

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

## Artifact And Report Contract

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

## Testing Plan

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

## Live vLLM Validation

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

## Quantitative Acceptance Gates

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

## Completion Checklist

Target deadline: `2026-05-06`

- [ ] 3.1 Replace a single archive entry per cell with bounded front members.
- [ ] 3.2 Implement PPA-only dominance over active objectives, accounting for
  combinational designs.
- [ ] 3.3 Add NSGA-II crowding-distance eviction, preserve PPA extremes, parent
  sampling from fronts, and artifact/report updates.
