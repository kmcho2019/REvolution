# KS-Triggered Adaptive Re-Binning

## Goal

Add statistically triggered adaptive re-binning to QD/MAP-Elites archive
geometries.

The archive should update its descriptor-space cell boundaries when recent
archiveable offspring no longer look like they are drawn from the same
descriptor distribution as the retained archive members. The first full
acceptance target is the current journal path:

- Feature 05 `single_thought_operator` prompt profile over the current
  candidate interface.
- `grid_quantile` archive geometry.
- `pareto_front` cell mode.

The feature should not be journal-only. It should live at the QD archive layer
and apply to every supported MAP-Elites archive geometry that can rebuild its
cell assignment from a replay set of archiveable members.

This document is part of the journal-methodology record. If implementation
choices change while Feature 07 is built, update this spec in the same change
set so the methodology remains faithful to the code.

## Current State

`grid_quantile` currently computes problem-specific quantile boundaries during
warmup and then freezes them for the rest of the run. Uniform `grid` archives
freeze configured bounds, and `cvt` archives freeze descriptor scaling plus
centroids after warmup. None of these archive geometries respond when evolution
discovers a new descriptor region after initialization.

Static bins are useful for reproducibility and interpretation, but they can
become stale:

- many recent successful candidates may crowd into a small number of cells.
- old empty regions may keep occupying archive resolution.
- parent selection may over-emphasize stale cells because cell coordinates no
  longer match the active search distribution.
- the final archive may understate diversity in the region where search is now
  productive.

Feature 07 adds a conservative drift trigger. It does not change candidate
evaluation, PPA scoring, Pareto objectives, or prompt construction. It only
changes the archive cell coordinate system when the retained archive and recent
archiveable offspring show distributional drift.

Feature 06 thought-only individuals and k-code evaluation are separate work.
Feature 07 must not implement Feature 06. It should be compatible with either
runtime representation by treating the archiveable unit consistently:

- before Feature 06 merges, the archiveable unit is the successful code
  candidate with valid PPA that the current QD archive attempts to insert.
- after Feature 06 merges, the archiveable unit is the successful thought
  representative selected by the thought evaluation layer, with descriptor
  values from its representative valid-PPA code sample.

The recent-window collector, re-bin replay pool, and artifact schema should use
that same archiveable unit abstraction. Feature 07 must not assume that the
runtime object is permanently a code-level candidate or permanently a
thought-level individual.

`scipy` is already a project dependency, so the first implementation can use
`scipy.stats.ks_2samp` without adding a new dependency.

## Methodology

The adaptive re-binning method has two parts:

1. Detect descriptor drift with per-axis two-sample Kolmogorov-Smirnov tests.
2. If drift is detected, rebuild the archive geometry and replay archiveable
   members into the new cells.

The trigger compares two empirical distributions for each descriptor axis:

- archive distribution: descriptor values from retained archive members.
- recent distribution: descriptor values from recent archiveable offspring.

The two-sample KS test returns a statistic and a p-value. The statistic is the
largest distance between the empirical cumulative distribution functions of the
two sample sets. A small p-value means the recent samples are unlikely to have
come from the same descriptor distribution as the archive samples.

The test is run independently for each configured descriptor axis. Because the
runtime tests more than one axis, the p-value threshold is Bonferroni-corrected:

```text
corrected_p_threshold = base_p_threshold / active_axis_count
```

For the journal descriptor profile with three active axes and
`base_p_threshold = 0.05`:

```text
corrected_p_threshold = 0.05 / 3 = 0.0167
```

Re-binning triggers when any tested axis has:

```text
ks_p_value < corrected_p_threshold
```

Bonferroni correction is intentionally conservative. It reduces false re-bin
events caused by testing multiple axes. A false re-bin is costly because it
moves cell coordinates, changes parent-selection pressure, and makes archive
history harder to read.

An active axis is a configured descriptor axis with finite values in both
sample sets. An axis may be tested even if the current archive geometry has
only one effective bin for that axis. The geometry may later collapse or
uncollapse during quantile recomputation.

## Sample Sets And Cadence

The KS test compares two concrete sample sets. Do not use the phrase "recent
archive members" in implementation code or reports because it conflates the
two sets.

Retained archive members are the archive contents after the current generation
has finished evaluation and after all archive insertions for that generation
have been attempted:

- for `scalar_elite`, this is the current elite retained in each occupied
  cell.
- for `pareto_front`, this is every current member retained in every occupied
  cell front after bounded-front insertion and crowding eviction.
- warmup-buffered `grid_quantile` samples are not retained archive members
  until archive initialization replays them into real cells.
- failed candidates, non-archiveable candidates, rejected insertion attempts,
  and previously evicted front members are not retained archive members.

Retained archive members are the archive-side KS baseline. They answer "what
does the active archive currently represent?" They are not necessarily the full
set replayed during a re-bin.

Recent samples are valid-PPA archiveable insertion attempts from the last
`qd_rebinning_recent_generations` completed generations, including the current
generation:

- before Feature 06, a recent sample is a successful archiveable code
  candidate with valid PPA.
- after Feature 06, a recent sample is a successful thought representative
  whose representative code sample has valid PPA.
- a recent sample remains in the recent window even if the archive later
  rejects it, replaces it as a scalar elite, or evicts it from a bounded
  Pareto front.

The trigger runs once at the end of each completed generation. The current
acceptance config is:

```yaml
qd_rebinning_kind: ks_triggered
qd_rebinning_recent_generations: 3
qd_rebinning_min_archive_members: 30
qd_rebinning_cooldown_generations: 3
qd_rebinning_base_p_threshold: 0.05
```

With this config, the runtime checks for drift after every completed
generation once the archive is initialized, unless it is still in cooldown or
has fewer than `30` retained archive members. The recent KS sample set contains
valid-PPA archiveable insertion attempts from the last `3` completed
generations. For example, the check at the end of generation `7` compares the
current retained archive distribution against recent samples from generations
`5`, `6`, and `7`. After a re-bin, the runtime skips KS checks for the next
`3` completed generations while the cooldown counter expires. The CVT smoke
uses the same defaults except
`qd_rebinning_min_archive_members: 10` so the smoke can exercise the path with
fewer evaluations.

## Runtime Algorithm

Run the trigger at generation boundaries, after all offspring in the generation
have been evaluated and archive insertion has been attempted. If a re-bin
happens, it happens before the next generation samples parents.

The intended generation-end flow is:

```text
for each completed generation:
    append archiveable offspring descriptors to recent window

    if qd_rebinning_kind == disabled:
        return

    assert qd_rebinning_kind == ks_triggered

    if archive is not initialized:
        return

    if cooldown is active:
        decrement cooldown and return

    archive_members = retained members from current archive
    if len(archive_members) < min_archive_members:
        return

    recent_samples = archiveable samples from recent_generations
    if recent_samples is empty:
        return

    run one KS test per active descriptor axis
    corrected = base_p_threshold / active_axis_count

    if all p_values >= corrected:
        record "no_rebin" drift check and return

    old_geometry = archive.describe_space()
    replay_members = archiveable re-bin replay set
    rebuild archive geometry from replay_members
    clear archive cells
    replay every replay member through normal archive insertion
    new_geometry = archive.describe_space()
    set cooldown to cooldown_generations
    record "rebin" event in archive history
```

Recent-window samples are the same archiveable unit that the archive attempts
to insert:

- current code-candidate QD modes record successful archiveable code
  candidates with valid PPA.
- thought-only QD modes record successful thought representatives, not every
  code sample in a k-code evaluation.

Archive samples are retained archive members:

- `scalar_elite` contributes one elite per occupied cell.
- `pareto_front` contributes every retained front member in every occupied
  cell.
- unknown cell modes fail immediately.

The re-bin replay set is all valid-PPA archiveable units retained in the
archiveable replay pool:

- current retained archive members.
- scalar-elite candidates that were previously replaced by a stronger scalar
  elite in the same old cell.
- Pareto-front candidates that were previously evicted by bounded per-cell
  Pareto-front capacity.

The replay pool is intentionally broader than the current active archive. In
`scalar_elite` mode, an old candidate can be replaced only because it shared a
cell with a better scalar elite. In `pareto_front` mode, a candidate can be
edged out by the old cell's Pareto-rank and NSGA-II crowding-distance
competition. After re-binning, those candidates may land in different cells
with different competitors and should be allowed to become active again if
normal archive insertion keeps them.

The replay pool still excludes failed candidates, non-archiveable candidates,
format-invalid candidates, and duplicate-objective insertion attempts that were
not displaced by archive capacity or replacement. The replay pool is not used
for the KS archive-distribution baseline; the KS archive baseline remains the
current retained archive members.

## Re-Binning Behavior

Re-binning means:

```text
recompute geometry from the re-bin replay set
clear archive cells
replay all replay members under the new geometry
rebuild each cell according to qd_cell_mode
```

The implementation must preserve:

- archive type.
- descriptor axes.
- replacement mode.
- objective names.
- maximum elites per cell.
- deterministic seeds used by the archive geometry.

The implementation must not preserve:

- old cell IDs.
- old quantile boundaries.
- old CVT scaler statistics.
- old per-cell front membership.

Old cell IDs are historical coordinates. They remain meaningful only inside the
history event that recorded them. After re-binning, parent selection and final
archive artifacts use the new coordinates.

Cell-mode rebuild behavior is exhaustive:

- `scalar_elite`: replay all valid-PPA replay members, then keep the best
  scalar elite per rebuilt cell.
- `pareto_front`: replay all valid-PPA replay members, then reconstruct
  bounded Pareto fronts with the configured PPA objectives, Pareto ranks, and
  NSGA-II crowding-distance eviction.
- any unknown cell mode: fail immediately.

Archive-geometry rebuild behavior is exhaustive:

- `grid_quantile`: recompute quantile boundaries from the replay set.
- `grid`: recompute per-axis bounds from the replay set and preserve the
  configured bin counts.
- `cvt`: refit the descriptor scaler from the replay set and regenerate
  centroids with the configured deterministic seed.
- any unknown archive geometry: fail immediately.

The first full acceptance path is `grid_quantile`. `cvt` support is validated
with a smoke run. Uniform `grid` support should follow the same archive-layer
contract when enabled.

## Quantile Rebuild And Collapse

For `grid_quantile`, the archive recomputes fresh quantile boundaries from the
re-bin replay set using the existing `GridQuantileArchive` quantile algorithm.
Do not introduce a new quantile or bin-splitting algorithm for Feature 07.

```text
axis_values = [member.descriptors[axis_index] for member in replay_members]
sorted_values = sorted(axis_values)
position = probability * (len(sorted_values) - 1)
lower_index = floor(position)
upper_index = ceil(position)
quantile = linear interpolation between lower_index and upper_index
boundaries = sorted unique [q25, q50, q75]
effective_bins = len(boundaries) + 1
```

This is the current `linear_interpolation_n_minus_1` method used by
`GridQuantileArchive.quantile_method`. Cell assignment after re-binning keeps
the existing rule: `bisect_right` over the frozen quantile boundaries. Boundary
values map to the higher bin, matching the current archive behavior.

If all values on an axis are identical, the boundary list is empty and the axis
has one effective bin:

```text
axis_values = [0, 0, 0, 0, 0]
boundaries = []
effective_bins = 1
```

This is quantile collapse. It is not a special-case fallback. It is the correct
MAP-Elites geometry for an axis with no retained diversity.

For example, combinational-only designs may all have `ff_depth = 0`. In that
case the FF-depth axis collapses to one bin instead of creating three or four
empty FF-depth regions. If later retained members include sequential designs
with nonzero FF depth, the next triggered re-bin may uncollapse the axis by
producing non-empty quantile boundaries.

Do not smooth old and new bin edges. The KS trigger already indicates
meaningful drift, and fresh quantile computation is simpler, more auditable,
and avoids adding an alpha parameter.

## Worked Example

Assume the journal descriptor profile has three axes:

```text
axis 0: logic_depth
axis 1: ff_depth
axis 2: width_log_est
```

The current retained archive members have descriptor values:

```text
logic_depth:   [2, 2, 3, 3, 4, 4, 5, 5]
ff_depth:      [0, 0, 0, 0, 0, 0, 0, 0]
width_log_est: [3, 3, 4, 4, 5, 5, 6, 6]
```

The last three generations produced archiveable thought representatives with:

```text
logic_depth:   [7, 8, 8, 9, 9, 10]
ff_depth:      [0, 0, 0, 0, 0, 0]
width_log_est: [4, 5, 5, 6, 6, 7]
```

Run one KS test per axis:

```text
logic_depth:   p = 0.004
ff_depth:      p = 1.000
width_log_est: p = 0.080
```

There are three active axes, so:

```text
corrected_p_threshold = 0.05 / 3 = 0.0167
```

`logic_depth` triggers because:

```text
0.004 < 0.0167
```

The archive then re-bins:

1. Collect the re-bin replay set.
2. Recompute quantile boundaries from that replay set.
3. Collapse `ff_depth` to one bin because all replay values are `0`.
4. Clear old cells.
5. Replay every replay member under the new boundaries.
6. Rebuild each cell's bounded Pareto front.
7. Record old geometry, new geometry, p-values, trigger axis, and counts.

If old geometry had an effective shape:

```text
logic_depth x ff_depth x width_log_est = 4 x 1 x 4
```

and replay members after drift produce:

```text
logic_depth x ff_depth x width_log_est = 4 x 1 x 3
```

then old cell IDs such as `1,0,3` are no longer used for parent selection.
Every replay member gets a new cell assignment under the rebuilt geometry.

If a candidate was previously displaced from an old crowded cell, it also gets
replayed. It becomes active again only if it survives normal insertion in its
new cell: scalar quality replacement for `scalar_elite`, or bounded
Pareto-front insertion for `pareto_front`.

## Configuration

The runtime config is a discriminated union using flat QD fields, matching the
current backend config style.

Disabled config:

```yaml
qd_rebinning_kind: disabled
```

KS-triggered config:

```yaml
qd_rebinning_kind: ks_triggered
qd_rebinning_recent_generations: 3
qd_rebinning_min_archive_members: 30
qd_rebinning_cooldown_generations: 3
qd_rebinning_base_p_threshold: 0.05
```

All `ks_triggered` fields are required. The implementation should assert:

- `qd_rebinning_recent_generations > 0`.
- `qd_rebinning_min_archive_members > 0`.
- `qd_rebinning_cooldown_generations > 0`.
- `0 < qd_rebinning_base_p_threshold < 1`.

Unknown `qd_rebinning_kind` values fail immediately. Do not add
archive-specific override fields in the first pass. The archive type already
determines how geometry is rebuilt.

## Artifacts And Reporting

Archive artifacts must make cell-coordinate changes auditable.

`archive_history.jsonl` records every drift check and every re-bin event. Each
event records:

- `event_kind`: `rebin_check` or `rebin`.
- archive type and cell mode.
- generation index.
- tested axes.
- KS statistics.
- p-values.
- corrected p-value threshold.
- trigger axes.
- warmup state.
- cooldown state.
- retained member count.
- replay member count.
- displaced replay member count.
- recent sample count.
- old geometry summary.
- new geometry summary for re-bin events.
- replay attempt count for re-bin events.
- final active member count after re-bin events.
- reactivated displaced member count for re-bin events.

`archive_space.json` records the current archive geometry, including:

- archive type.
- descriptor axes.
- current effective shape.
- current bin boundaries or CVT scaler/centroids.
- total re-bin count.
- last re-bin generation.
- collapsed axes.

`archive_summary.json` records:

- re-binning config kind.
- total re-bin count.
- last trigger axis list.
- last corrected threshold.
- archive coverage.
- QD score.
- best quality.
- occupied cells.

`descriptor_health.json` records both retained-archive and recent-window
descriptor summaries so the KS decision can be inspected after the run.

Reports should describe re-binning as a cell-coordinate change, not as a change
in candidate evaluation. PPA metrics, validation status, and prompt behavior
must remain comparable between adaptive-off and adaptive-on modes.

## Visualization Contract

Adaptive re-binning changes archive coordinates over time, so the linked QD/PPA
viewer must expose geometry history rather than pretending there was one fixed
archive grid for the whole run.

The viewer should support two archive-geometry perspectives:

- `native_timeline`: default. Each timeline step uses the archive geometry that
  was active at that generation. This shows how bins and cells actually changed
  during search.
- `final_fixed`: optional stable view. Every visible sample with descriptors is
  projected into the final archive geometry. This gives a fixed viewpoint for
  comparing generations, but it is a visualization projection and must not be
  treated as the runtime cell assignment.

The exported viewer dataset for adaptive runs must include:

- ordered archive geometry snapshots with `geometry_id`, generation,
  re-bin count, effective shape, axis boundaries, collapsed axes, and source
  hash.
- re-bin timeline markers with trigger axes, p-values, corrected threshold,
  old geometry id, and new geometry id.
- sample-level native cell ids with the geometry id used for assignment.
- sample-level final-fixed projected cell ids when descriptors are available.
- projection status for samples that cannot be projected because descriptors
  are missing.

The UI should make re-binning visible with:

- timeline markers at re-bin generations.
- an archive geometry perspective control ordered `native_timeline`,
  `final_fixed`.
- an axis/bin detail panel that reports the active geometry id, effective
  shape, collapsed axes, and quantile cutoffs for the selected timeline step.
- linked hover that works in both geometry perspectives.

Do not animate boundary morphing in the first pass. A discrete geometry change
at the re-bin timeline marker is easier to validate and easier to describe in
the paper.

## Full Hard-Subset Acceptance Run

Feature 07 acceptance uses the Feature 05-style hard-subset matrix, narrowed to
isolate adaptive re-binning.

### Matrix

```yaml
matrix_modes:
  - classic
  - grid_quantile_pareto_journal_bd_unified_rebin_off
  - grid_quantile_pareto_journal_bd_unified_rebin_on

modes:
  classic:
    search_mode: revolution
    seed: 42

  grid_quantile_pareto_journal_bd_unified_rebin_off:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 8
    qd_cell_mode: pareto_front
    qd_max_elites_per_cell: 5
    qd_objectives: ppa
    qd_two_parent_probability: 0.5
    qd_operator_kind: single_thought_operator
    qd_operator_one_parent_fraction: 0.5
    qd_operator_archive_context_size: 4
    qd_operator_two_parent_allow_intra_bin: true
    qd_rebinning_kind: disabled
    seed: 42

  grid_quantile_pareto_journal_bd_unified_rebin_on:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 8
    qd_cell_mode: pareto_front
    qd_max_elites_per_cell: 5
    qd_objectives: ppa
    qd_two_parent_probability: 0.5
    qd_operator_kind: single_thought_operator
    qd_operator_one_parent_fraction: 0.5
    qd_operator_archive_context_size: 4
    qd_operator_two_parent_allow_intra_bin: true
    qd_rebinning_kind: ks_triggered
    qd_rebinning_recent_generations: 3
    qd_rebinning_min_archive_members: 30
    qd_rebinning_cooldown_generations: 3
    qd_rebinning_base_p_threshold: 0.05
    seed: 42
```

The EoH prompt profile is not part of the Feature 07 hard gate. It may be run
as follow-up evidence, but acceptance uses the unified prompt profile so the
comparison isolates adaptive re-binning.

### Scratch Config

Create the run config under `exp/` and do not commit it unless explicitly
requested:

```bash
mkdir -p exp/journal_adaptive_rebinning_configs
cp data/configs/hard_iteration_subset.yaml \
  exp/journal_adaptive_rebinning_configs/hard_subset_adaptive_rebinning.yaml
```

Then edit `matrix_modes` and `modes` to match the matrix above.

### Local Smoke

Before launching the full hard-subset matrix, run a smoke on at most three
problems with total concurrent workers capped at `8`.

The smoke is acceptable when:

- all three modes complete without crash.
- adaptive-on records `qd_rebinning_kind = ks_triggered` in the manifest.
- adaptive-off records `qd_rebinning_kind = disabled` in the manifest.
- adaptive-on emits `archive_history.jsonl`, `archive_space.json`,
  `archive_summary.json`, and `descriptor_health.json`.
- at least one adaptive-on problem records a re-bin check event.

### Full Matrix

Run the full 13-problem matrix with the long-context vLLM endpoint:

```bash
PYTHON_BIN=/workspace/.venv/bin/python \
HARD_SUBSET_VLLM_HOST=host.docker.internal \
HARD_SUBSET_VLLM_PORT=8000 \
HARD_SUBSET_MIN_MODEL_LEN=128000 \
HARD_SUBSET_MAX_TOKENS=128000 \
HARD_SUBSET_DIFF_MAX_TOKENS=128000 \
HARD_SUBSET_POPULATION_SIZE=20 \
HARD_SUBSET_NUM_GENERATIONS=5 \
HARD_SUBSET_TOTAL_WORKER_SLOTS=8 \
HARD_SUBSET_MAX_ACTIVE_PROBLEMS=4 \
HARD_SUBSET_MAX_WORKERS_PER_PROBLEM=2 \
HARD_SUBSET_SAVE_PATH=exp/journal_adaptive_rebinning_hard_subset \
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config exp/journal_adaptive_rebinning_configs/hard_subset_adaptive_rebinning.yaml \
  --mode matrix
```

The manifest must show:

- `reported_max_model_len >= 128000`.
- `population_size=20`.
- `num_generations=5`.
- `total_worker_slots=8`.
- `max_active_problems=4`.
- `max_workers_per_problem=2`.
- `max_tokens=128000`.
- `diff_max_tokens=128000`.
- `seed=42`.
- all 13 hard-subset problems.
- adaptive-off mode has `qd_rebinning_kind=disabled`.
- adaptive-on mode has `qd_rebinning_kind=ks_triggered`.
- adaptive-on mode has `qd_rebinning_recent_generations=3`.
- adaptive-on mode has `qd_rebinning_min_archive_members=30`.
- adaptive-on mode has `qd_rebinning_cooldown_generations=3`.
- adaptive-on mode has `qd_rebinning_base_p_threshold=0.05`.

### Reports After The Run

```bash
RUN_ROOT="<printed save path from wrapper>"
CONFIG=exp/journal_adaptive_rebinning_configs/hard_subset_adaptive_rebinning.yaml

/workspace/.venv/bin/python scripts/backend_comparison_report.py \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_unified_rebin_off="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified_rebin_off" \
  --backend_run grid_quantile_pareto_journal_bd_unified_rebin_on="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified_rebin_on" \
  --output "${RUN_ROOT}/backend_comparison.md"

/workspace/.venv/bin/python scripts/report_final_analysis_bundle.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}"

/workspace/.venv/bin/python scripts/report_pareto_analysis.py \
  --subset-config "${CONFIG}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_unified_rebin_off="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified_rebin_off" \
  --backend_run grid_quantile_pareto_journal_bd_unified_rebin_on="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified_rebin_on" \
  --output-dir "${RUN_ROOT}/pareto_analysis"

/workspace/.venv/bin/python scripts/report_ppa_distribution.py \
  --subset-config "${CONFIG}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_unified_rebin_off="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified_rebin_off" \
  --backend_run grid_quantile_pareto_journal_bd_unified_rebin_on="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified_rebin_on" \
  --output-dir "${RUN_ROOT}/ppa_distribution"

/workspace/.venv/bin/python scripts/report_design_space_analysis.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}" \
  --feature-profile journal_logic_ff_width_3d
```

Export and validate the linked archive/PPA viewer:

```bash
/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root "${RUN_ROOT}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_pareto_journal_bd_unified_rebin_off="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified_rebin_off" \
  --backend_run grid_quantile_pareto_journal_bd_unified_rebin_on="${RUN_ROOT}/grid_quantile_pareto_journal_bd_unified_rebin_on" \
  --archive_source_backend grid_quantile_pareto_journal_bd_unified_rebin_on \
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
/workspace/.venv/bin/python scripts/validate_adaptive_rebinning_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config "${CONFIG}" \
  --classic-mode classic \
  --off-mode grid_quantile_pareto_journal_bd_unified_rebin_off \
  --on-mode grid_quantile_pareto_journal_bd_unified_rebin_on \
  --require-full-subset \
  --acceptance-hard-subset
```

The audit command must emit:

- `adaptive_rebinning_validation.json`.
- `adaptive_rebinning_validation.md`.
- non-zero exit status on any failed hard gate.

## Quantitative Acceptance Gates

The adaptive-on mode is accepted only when every hard gate passes. All paired
metric gates use per-problem aggregation, not raw candidate rows.

### Run-Level Gates

- `problem_count = 13`.
- `failure_count = 0`.
- `problem_invalid_count = 0`.
- `acceptance_error_count = 0`.
- `final_analysis/summary.json` exists and has an empty `skipped_sections`
  list.
- `final_analysis/hard_iteration_analysis/summary.json` covers all 13 problems
  for each mode.
- `final_analysis/pareto_analysis/summary.json` covers every backend/problem
  pair in the matrix.
- `final_analysis/ppa_distribution/summary.json` exists.
- `final_analysis/design_space_analysis/summary.json` has successful
  candidates and all 13 pairwise feature comparisons.
- `backend_comparison.md` reports valid designs, functionality rate,
  synthesis/PPA rate, average quality score, average PPA improvement, QD
  coverage, and QD score for every QD mode.
- The linked archive/PPA viewer exports `index.html` and the strict validator
  exits `0`.
- Adaptive-on viewer datasets include geometry snapshots, re-bin timeline
  markers, native cell ids, and final-fixed projected cell ids.
- Strict viewer validation proves that `native_timeline` changes active
  geometry across a re-bin event and `final_fixed` keeps the final geometry
  stable across timeline steps.

### Coverage Gates

- Adaptive-on must complete the same 13 problems as adaptive-off and classic.
- Adaptive-on must produce at least one valid PPA sample for every hard-subset
  problem where adaptive-off produced at least one valid PPA sample.
- Adaptive-on must produce at least one valid PPA sample for every hard-subset
  problem where classic produced at least one valid PPA sample.
- Valid PPA sample count is measured from generated candidate outcomes, not
  from archive CSV rows. Archive CSV rows measure retained archive members and
  must not be used as a proxy for generated valid samples.

### Variance-Envelope Gates

Adaptive-on is accepted on a metric when the paired per-problem delta
(`adaptive_on - adaptive_off`) satisfies:

```text
mean_delta >= -max(2 * standard_error(delta_by_problem), metric_floor)
```

Use these floors until a repeated-seed study replaces them:

```text
functional pass rate:        0.03
synthesis pass rate:         0.03
valid PPA sample count:      1 sample per problem
average quality score:       0.03
average PPA improvement:     0.06
QD coverage:                 0.05
QD score:                    5% of adaptive-off mean QD score
```

For QD score, compute the floor from paired adaptive-off problem values:

```text
metric_floor = 0.05 * mean(abs(adaptive_off_qd_score_by_problem))
```

If fewer than four paired non-empty problem values exist for a metric, use the
floor alone and require a written validation note. Cherry-picked reruns are not
accepted. If the declared final run fails a gate, a new full matrix must be
declared and validated from scratch.

### Per-Problem Degradation Report

The validator must include a per-problem degradation table. The table is a
hard artifact requirement even when aggregate gates pass.

For each problem, report adaptive-on minus adaptive-off deltas for:

- functionality pass rate.
- synthesis pass rate.
- valid PPA sample count.
- average quality score.
- average PPA improvement.
- archive coverage.
- QD score.
- occupied cells.
- total archive members.
- best archive quality.

The hard catastrophic gate is coverage loss: adaptive-on may not drop to zero
valid PPA samples on any problem where adaptive-off or classic has at least one
valid PPA sample. Other large per-problem drops are recorded for methodology
review and paper discussion; they do not fail acceptance unless they also fail
the variance-envelope gates.

### Re-Binning-Specific Gates

- Adaptive-on emits at least one `rebin_check` event for every initialized QD
  problem.
- If no problem triggers a `rebin` event, the validator must still pass only if
  every `rebin_check` event records p-values above the corrected threshold.
- If any problem triggers a `rebin` event:
  - `replay_attempt_count` equals the replay member count used for the
    rebuild.
  - every replay member is attempted exactly once during rebucketing.
  - final active membership is decided only by normal archive insertion in the
    rebuilt geometry.
  - displaced archiveable members may reactivate only by surviving normal
    insertion in the rebuilt geometry.
  - `reactivated_displaced_member_count` is reported.
  - cooldown starts immediately after the event.
  - the next re-bin for that problem occurs only after cooldown expires.
- Every `rebin` event records old geometry, new geometry, trigger axes,
  p-values, corrected threshold, retained member count, replay member count,
  replay attempt count, final active member count, displaced replay member
  count, and reactivated displaced member count.
- Quantile collapse is reported when an effective axis has one bin after
  rebuild.

## CVT Smoke And Visualization Guard

Feature 07 also requires a smaller non-journal smoke for the CVT archive path.
This is not a hard-subset performance acceptance run. It proves the generalized
archive-layer contract does not crash outside `grid_quantile`.

Smoke mode:

```yaml
matrix_modes:
  - cvt_size_control_rebin_on

modes:
  cvt_size_control_rebin_on:
    search_mode: revolution_qd
    qd_archive_type: cvt
    qd_descriptor_profile: size_control_3d
    qd_cell_mode: scalar_elite
    qd_rebinning_kind: ks_triggered
    qd_rebinning_recent_generations: 3
    qd_rebinning_min_archive_members: 10
    qd_rebinning_cooldown_generations: 3
    qd_rebinning_base_p_threshold: 0.05
    seed: 42
```

Run with at most three problems, low generations, and total concurrent workers
capped at `8`. The smoke passes when:

- the mode completes without runtime errors.
- CVT initialization still completes when enough archiveable samples exist.
- adaptive re-binning checks run after initialization.
- `archive_summary.json`, `archive_space.json`, `descriptor_health.json`, and
  `archive_history.jsonl` exist.
- the normal QD visualization outputs are generated.
- `scripts/export_qd_ppa_visualization.py` produces
  `visualization/qd_ppa_viewer/index.html`.
- `scripts/validate_qd_ppa_visualization.py --playwright --strict` exits `0`.

## Testing Plan

- Unit-test recent-window collection by generation.
- Unit-test KS trigger behavior with deterministic synthetic distributions.
- Unit-test Bonferroni threshold calculation for one, two, and three axes.
- Unit-test cooldown behavior.
- Unit-test `disabled`, `ks_triggered`, and unknown re-binning config kinds.
- Unit-test quantile recomputation from the re-bin replay set.
- Unit-test degenerate-axis quantile collapse.
- Unit-test scalar-elite reinsertion after re-binning.
- Unit-test Pareto-front reinsertion after re-binning.
- Unit-test that displaced scalar-elite members are replayed and may reactivate
  when the rebuilt geometry assigns them to a cell where they win scalar
  replacement.
- Unit-test that displaced Pareto-front members are replayed and may reactivate
  when the rebuilt geometry assigns them to a cell where they survive
  rank/crowding selection.
- Unit-test unknown archive type and unknown cell mode failures.
- Integration-test `grid_quantile` adaptive-on versus adaptive-off artifacts.
- Integration-test CVT adaptive-on smoke artifacts and viewer export.
- Integration-test adaptive viewer export with native-timeline and final-fixed
  geometry perspectives.
- Regression-test the strict acceptance validator with synthetic passing and
  failing summaries.

## Implementation Guidance

- Keep code extremely simple and skimmable.
- Minimize possible states by keeping argument lists short and required.
- Use discriminated unions for config objects with multiple shapes.
- Exhaustively handle archive types, cell modes, and config kinds.
- Fail on unknown types instead of adding defensive fallbacks.
- Use asserts when loading data that must exist.
- Do not make arguments optional when the caller must provide them.
- Remove changes that are not strictly required for Feature 07.
- Bias for fewer lines and early returns.
- Avoid clever code and excessive helper extraction.
- Pass overrides only when they are strictly necessary.

## Commit Guidance

- Keep commits atomic.
- Use Conventional Commit subjects.
- Capitalize the subject, use imperative mood, and do not end with a period.
- Keep the subject at 50 characters or less when practical.
- Separate subject and body with a blank line when a body is needed.
- Use the body to explain what changed and why, wrapped at 72 columns.
- After committing, inspect the commit message to catch visible `\n`, missing
  signoff when required, or other broken formatting.

## Completion Checklist

Target deadline: `2026-05-12`

- [ ] 7.1 Store recent archiveable-candidate descriptor windows.
- [ ] 7.2 Add KS test trigger with Bonferroni threshold and cooldown.
- [ ] 7.3 Store the re-bin replay pool, including inactive valid-PPA
  archiveable members displaced by scalar replacement or bounded-front
  capacity.
- [ ] 7.4 Rebuild supported archive geometries from the replay set, then replay
  all replay members.
- [ ] 7.5 Add archive-history, archive-space, descriptor-health, and summary
  reporting for re-binning decisions.
- [ ] 7.6 Add strict adaptive-rebinning validation for the unified hard-subset
  matrix.
- [ ] 7.7 Validate CVT size-control smoke and linked archive/PPA viewer export.
