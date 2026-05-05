# Phase 02: Static Quantile Grid Binning

## Goal

Add the first journal MAP-Elites archive geometry for
`journal_logic_ff_width_3d`:

- archive kind: `grid_quantile`.
- descriptor axes: `logic_depth`, `ff_depth`, `comb_width_log`.
- intended bins: `4` per axis.
- bin boundaries: frozen 25/50/75 percent quantiles from fully archiveable
  warmup successes.
- effective bins: duplicate quantile boundaries collapse into fewer bins.

`grid_quantile` is a separate selectable archive option beside `grid` and
`cvt`. Unlike configurable `grid`, this mode is intentionally narrow:
four intended bins per axis and quantile-derived boundaries. It is tailored for
the journal behavior-descriptor experiments, especially
`journal_logic_ff_width_3d`, but should work for any descriptor profile with a
small axis count. Phase 02 acceptance, however, is only for
`journal_logic_ff_width_3d`. Quantiles are computed independently per problem
run, not globally across the hard subset. Once a problem's warmup quantiles are
computed, boundaries stay fixed for the rest of that problem run. KS triggers,
re-binning, Pareto fronts, thought-only individuals, k-code evaluation, and
fail-pool changes stay out of scope until later phases.

## Current State

Phase 01 added the journal descriptor profile
`journal_logic_ff_width_3d`. The current archive choices are:

- `grid`: fixed bounds and fixed uniform bins.
- `cvt`: warmup samples, frozen scaling, and nearest-centroid assignment.

Fixed global grid bounds are not a good journal default because descriptor
ranges vary by benchmark. A small adder and a larger multiplier can have very
different natural `logic_depth` and `comb_width_log` ranges. `ff_depth` can
also collapse to `0` for combinational problems. The Phase 02 archive should
therefore compute problem-local quantile splits while keeping a simple
one-elite-per-cell MAP-Elites archive.

## Satisfactory End State

Phase 02 is complete only when all of these are true:

1. `grid_quantile` is a first-class archive variant everywhere `grid` and
   `cvt` are selectable.
2. The archive initializes from fully archiveable code candidates,
   computes frozen quantile boundaries once, reinserts the warmup candidates,
   and then behaves like a normal one-elite-per-cell MAP-Elites archive.
3. Cell IDs use effective bins, not intended bins. If `ff_depth` collapses to
   one bin, a 3-axis journal archive with two non-collapsed axes reports and
   behaves as a 4 x 1 x 4 grid with `16` effective cells.
4. Artifacts record intended bins, effective bins, quantile boundaries,
   initialization state, warmup sample count, and collapsed axes clearly enough
   to audit every `qd_archive_event.json` assignment.
5. Static binning is proven by run artifacts: after initialization, quantile
   boundaries never change inside a run.
6. A full hard-subset live vLLM matrix run completes for classic and
   `grid_quantile_journal_bd`, and the grid-quantile run passes the quantitative
   audit gates in this document. The validation command must exit `0`; manual
   inspection alone is not sufficient. Problems that do not reach warmup are
   reported as `warmup_limited`, which is a partial state rather than a hard
   failure or a complete grid-quantile success.
7. Visualization artifacts are generated from the real hard-subset grid-quantile
   run, not from synthetic demo data, and automated checks prove they are
   non-empty, stage-aligned, and dimensionally consistent with the archive.

## Implementation Scope

### Archive Behavior

Add `GridQuantileArchive` as a simple sibling of `GridArchive` and
`CVTArchive` in `src/revolution/qd/archive.py`.

Required state:

- `axes`: descriptor names in archive order.
- `intended_bins_per_axis`: constant `4`, not user-configurable.
- `warmup_successes`: required positive integer.
- `warmup_buffer`: fully archiveable candidates buffered before
  initialization.
- `initialized`: false until quantiles are frozen.
- `quantile_boundaries`: tuple of sorted unique boundaries per axis.
- `effective_bins`: `len(unique_boundaries) + 1` per axis.
- `entries`: one `GridArchiveEntry` elite per effective cell. Reuse the
  existing one-elite storage shape; Phase 03 owns any Pareto-front cell model.

Required behavior:

1. Before initialization, every fully archiveable candidate is appended to the
   warmup buffer and returns an insert result with decision `warmup_buffered`,
   `inserted: false`, and `assignment.initialized: false`. This means the
   candidate has not been assigned to a cell yet because the boundaries do not
   exist; it does not mean the candidate is rejected.
2. Initialize only during the deterministic post-evaluation archive-insertion
   pass, never from asynchronous worker completion order. Process successful
   candidates in stable generation/materialization order.
   `warmup_successes` is the minimum warmup size. Once at least that many
   samples exist, freeze the grid at the first deterministic insertion point
   where the buffered descriptors produce the minimum active geometry:
   `min(2, axis_count)` axes with more than one effective bin. This prevents a
   static grid from freezing on the first descriptor-identical successes when
   the same generation/run already contains enough diversity to validate the
   intended 2D/3D journal behavior. If run end arrives without that active
   geometry, initialize from the available warmup buffer as a
   `run_finalization_fallback` when at least `warmup_successes` samples exist;
   that archive is reported as `initialized_but_degenerate` when fewer than
   two journal axes remain active. Do not choose warmup samples by quality.
   Every warmup sample participates in quantile calculation and replay, but
   not every warmup sample is guaranteed to survive as a final elite because
   multiple samples can map to the same effective cell and normal one-elite
   replacement keeps only the best quality per cell. If the freeze point is
   reached partway through a completed generation batch, candidates after the
   warmup slice in that same deterministic insertion order are inserted
   normally into the frozen grid.
3. After initialization, assign candidates with the frozen boundaries and apply
   the same `filled_empty`, `replaced_elite`, and `not_inserted` semantics as
   `GridArchive`. Replacement uses only the existing scalar `quality_score`.
   Do not add PPA-specific tie-breaks in Phase 02. If the new score equals the
   current elite score, keep the existing elite for deterministic behavior.
   Cell IDs use the existing grid format: comma-separated bin indices in axis
   order, such as `0,2,3`. Valid index ranges are defined by effective bins,
   not intended bins.
4. Boundary inclusivity must be explicit and tested:
   - values below the first boundary go to bin `0`.
   - a value equal to a boundary goes to the higher bin.
   - values above the last boundary go to the final bin.
   - implementation should use `bisect_right(quantile_boundaries, value)`.
5. Duplicate quantile boundaries are dropped. Boundaries equal to the warmup
   axis minimum or maximum are kept; they still define outer bins for future
   candidates that fall outside the warmup range. If all warmup values for an
   axis are equal, that axis has zero boundaries and one effective bin.
6. `num_cells` is `0` before initialization and the product of effective bins
   once initialized. Pending reports must still expose `intended_num_cells`,
   but pending `coverage` is `0.0` because effective geometry does not exist
   yet.
7. Unknown archive types must raise an error. Do not silently fall back to
   `grid` or `cvt`.
8. Quantile boundaries are scoped to one problem archive. Do not share or reuse
   boundaries across problems inside the same hard-subset run.

Warmup eligibility is intentionally strict: a candidate may define quantile
boundaries only if it passes the existing archiveability gate, including final
functionality, synthesis, and valid final PPA. Candidates that fail those gates
must continue through the existing fail-pool path; Phase 02 does not change
fail-pool behavior.

Parent selection must not use archive cells before initialization because no
cell geometry exists yet. During warmup, retain warmup-buffered successes as
selectable success parents even when the optional cell reservoir is disabled.
If both fail and success parents exist before initialization, reserve at least
half of the offspring budget for success-parent refinement so the run can
finish collecting the required archiveable warmup samples instead of starving
the not-yet-materialized archive. After `grid_quantile` initializes, use
archive elites only where the current initialized-QD parent selection path
already uses them. Do not add a broader parent-source policy in this phase.

Do not change journal-profile operators in Phase 02. `journal_logic_ff_width_3d`
remains archive-only as in Phase 01; descriptor-targeted QD operators are not
introduced for this profile in this phase.

Do not redesign parent-source probabilities in Phase 02. MAP-Elites should
ultimately lean on archive elites, but early fail/success reservoir sampling
and adaptive parent-source policy belong to Phase 04 two-tier fail-pool work.
For Phase 02, preserve the current journal-profile parent-pool behavior while
changing only archive geometry and reporting.

### Quantile Calculation

Keep the quantile helper local and small. Use pure Python unless the touched
code already requires NumPy for this path.

For a sorted list with `n` values, compute q25/q50/q75 by linear
interpolation at sorted positions `p * (n - 1)` for
`p in {0.25, 0.5, 0.75}`. For a non-integer position, interpolate between the
floor and ceiling sorted samples. For an integer position, use that sorted
sample directly.

After interpolation, keep sorted unique boundaries. Do not drop a boundary only
because it equals the warmup axis minimum or maximum. Effective bins are
`len(unique_boundaries) + 1`.

The implementation must record this in `describe_space()` as:

```json
"quantile_method": "linear_interpolation_n_minus_1"
```

Do not mix methods between archive behavior and validation scripts.

### Configuration And CLI

Expose these user-facing flags:

```text
--qd_archive_type grid_quantile
--qd_grid_quantile_warmup_successes 20
```

The journal profile used for this phase is:

```text
--qd_descriptor_profile journal_logic_ff_width_3d
```

Do not reuse CVT-specific names for grid-quantile settings. `warmup_successes`
is required for reproducible journal experiments. If a CLI default is provided
for convenience, the resolved value must still be written to artifacts.

Use `20` for normal journal runs unless the run is explicitly bounded to force
initialization quickly. The hard-subset acceptance run uses `8`.

Do not expose a bin-count override. `grid_quantile` always means four intended
quantile bins per axis. If a run needs configurable fixed bins, use `grid`.

`grid_quantile` should accept descriptor profiles beyond
`journal_logic_ff_width_3d`, but Phase 02 implementation acceptance and live
validation are scoped to `journal_logic_ff_width_3d`.

Expected config shape:

```yaml
modes:
  grid_quantile_journal_bd:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 20
```

Use mode name `grid_quantile_journal_bd` in hard-subset configs and reports.
Do not shorten it to `quantile_journal_bd`; the explicit prefix keeps the mode
aligned with `qd_archive_type=grid_quantile` and avoids confusion with later
adaptive re-binning phases.

### Artifact Contract

`archive_space.json` must include:

- `archive_type: "grid_quantile"`.
- `descriptor_profile`.
- `descriptor_axes`.
- problem identifier or problem-local artifact path.
- `assignment_rule`.
- `cell_id_format`.
- `initialized`.
- `intended_bins_per_axis: 4`.
- `intended_num_cells`.
- `num_cells`: `0` before initialization; after initialization, equal to the
  product of effective bins.
- per-axis:
  - `name`.
  - `intended_bins`.
  - `effective_bins`.
  - `quantile_boundaries`.
  - `collapsed`.
  - `intervals`.
- `warmup_successes`.
- `minimum_active_axes`.
- `warmup_buffer_size`.
- `warmup_buffer_samples`: compact descriptor evidence for pending warmup
  candidates that have reached the archiveability gate but have not yet frozen
  boundaries. Each row must include the same candidate ID, descriptor tuple,
  quality score, PPA metrics, candidate ordering fields, candidate directory
  basename, and `sample_role: "quantile_warmup_buffered"`.
- `initialization_sample_count`.
- `quantile_boundaries_hash`: SHA-256 hash of the canonical boundary payload.
- `warmup_initialization_samples`: the exact fully archiveable samples used to
  freeze quantile boundaries. Each row must include candidate ID, descriptor
  tuple, quality score, `ppa_metrics`, `score_components` such as
  `g_P`/`g_A`/`g_T` when available, `generation_candidate_index`,
  `archive_insertion_index`, candidate directory basename, and a marker such
  as `sample_role: "quantile_warmup_initialization"`.
- `warmup_replay_results`: aggregate insertion outcomes for the replayed
  warmup samples after boundaries are frozen. This records which warmup samples
  filled cells, replaced earlier warmup elites, or did not survive same-cell
  competition. Each row must include `candidate_id`, `descriptor_tuple`,
  `quality_score`, `ppa_metrics`, `score_components` such as
  `g_P`/`g_A`/`g_T` when available, `cell_id`, `decision`, `inserted`,
  `replaced`, `previous_candidate_id`, `generation_candidate_index`,
  `archive_insertion_index`, candidate directory basename, and
  `sample_role: "quantile_warmup_replay"`. Keep this compact replay evidence
  in `archive_space.json`.
- `quantile_method`.

`archive_space_report.md` must explain:

- whether the archive is pending or initialized.
- intended geometry versus effective geometry.
- collapsed axes, especially `ff_depth`.
- boundary inclusivity.
- the exact cell-count derivation.

`archive_summary.json` and `qd_metrics.json` must include:

- `archive_type: "grid_quantile"`.
- `initialized`.
- `warmup_successes`.
- `warmup_buffer_size`.
- `initialization_sample_count`.
- `intended_num_cells`.
- effective `num_cells`.
- `occupied_cells`.
- `coverage`: `0.0` before initialization; after initialization, computed as
  `occupied_cells / num_cells`.

Keep `archive_summary.json` counters-only. Do not duplicate
`warmup_initialization_samples` or `warmup_replay_results` there.

Write `grid_quantile_layout.json` as the legacy/discovery layout artifact for
this archive type. Do not overload `grid_layout.json` or `centroids.json`.
`archive_space.json` remains the authoritative artifact for quantile geometry,
warmup samples, and replay evidence.

`archive_history.jsonl` must include warmup-pending snapshots before
initialization, not only post-init snapshots. Pending snapshots must include at
least `initialized: false`, `warmup_buffer_size`, `warmup_successes`,
`intended_num_cells`, `num_cells: 0`, and `coverage: 0.0`.
Post-init snapshots must include a compact geometry digest: `initialized:
true`, effective shape, collapsed axes, and a stable hash of the frozen
quantile boundaries. Full boundaries stay in `archive_space.json`. Compute the
boundary hash as SHA-256 over canonical JSON with sorted keys and compact
separators. The hashed payload must include axis names and boundary arrays.

`archive_cells.csv` must use effective cell IDs only. Row count must equal
`occupied_cells` in the final summary.

Every successful candidate with `qd_archive_event.json` must include:

- descriptor values for all three journal axes.
- `generation_candidate_index`.
- `archive_insertion_index`.
- candidate directory basename for human inspection.
- `assignment.archive_type: "grid_quantile"`.
- `assignment.initialized`.
- `assignment.indices` after initialization.
- per-axis assignment details with value, bin index, boundaries, and
  inclusivity.
- the frozen `archive_space.json` reference path.

Warmup-buffered candidates should still emit candidate archive events. During
warmup those events must show `decision: "warmup_buffered"`, `inserted: false`,
and `assignment.initialized: false`. After initialization, do not write a
second per-candidate event for those same files unless the artifact layout
explicitly supports multiple events per candidate. Record their replay outcomes
in `warmup_replay_results` instead.

Ordering fields must be explicit. `archive_insertion_index` is a global
per-problem sequence, starting at `1`, assigned only to fully archiveable
candidates considered by the archive. `generation_candidate_index` is the
within-generation materialization order used for human inspection and should
match the visible `sampleN` directory convention where possible.
`generation_candidate_index` applies to all generated candidates, including
failures. Failed candidates do not receive an `archive_insertion_index`; they
remain in the existing fail-pool and failure-reporting paths. Ordering is never
global across problems. Each problem owns its own archive and its own
`archive_insertion_index`, so parallel active problems do not affect archive
ordering or validation.

## Visualization System

The visualization system is part of Phase 02 because the archive is intended to
be inspected during evolution, not only at final state. The demo file
`docs/journal_features/02_quantile_binning_visualization.html` is a visual
reference only. The production visualizations must be generated from real
grid-quantile artifacts.

### Second-Iteration Visualization Goal

The first committed visualization attempt is not sufficient. It emits a static
HTML frame viewer plus flat PNGs, and the frames are too close to final-state
archive plots to explain the MAP-Elites process. The second iteration must be a
real archive evolution viewer with feature parity with the demo's core ideas,
using real run artifacts rather than synthetic samples.

The updated goal is:

- show the archive as an evolving MAP-Elites grid, not only as a final
  projection.
- show both occupied bins and individual archiveable samples as visible
  dots/spheres.
- expose run-state counters in the view: generation, occupied-cell coverage,
  best fitness/quality, archive mean quality, and cumulative archiveable
  sample count.
- include play/pause, reset, a timeline slider, and a visible frame label.
- include z-slice mini-grids so a viewer can inspect each `ff_depth` layer.
- use a consistent journal-BD axis layout:
  - x axis: `logic_depth`.
  - y/depth axis: `comb_width_log`.
  - z/vertical axis: `ff_depth`.
- when `ff_depth` collapses in combinational cases, render the active
  `logic_depth` x `comb_width_log` plane and record that `ff_depth` is the
  collapsed z axis.
- when all three journal axes are active, render a true interactive 3D archive
  with cell outlines, filled-cell quality coloring, and sample dots.
- make animation progress mechanically checkable. Validation must prove that
  the frame count matches `archive_history.jsonl`, that occupied-cell and
  sample-count sequences match the run state, and that at least one state
  change is visible when the history contains multiple snapshots.

The implementation should use a self-contained browser artifact if possible.
The strict no-CDN rule may be relaxed during exploratory implementation, but
the preferred Phase 02 artifact remains offline and reproducible. If Three.js
or another browser library is adopted, vendor it into the repo or generated
artifact bundle rather than relying on a network CDN for validation.

### Interactive Viewer Specification

`grid_quantile_occupancy_evolution.html` must be a self-contained archive
viewer, not a static PNG selector. It should be visually close to
`docs/journal_features/02_quantile_binning_visualization.html` while remaining
offline-reproducible.

Required viewer behavior:

- Render the archive as the main full-window object. The stats panel must stay
  compact enough that it does not obscure the grid in normal desktop views.
  It must default to a small state and provide an in-view control to expand or
  shrink the panel.
- Use a fixed journal axis layout for `journal_logic_ff_width_3d`:
  `logic_depth` on x, `comb_width_log` on y, and `ff_depth` on vertical z.
- Draw color-coded in-scene axis marks and a matching axis legend with the real
  descriptor names. The legend must explicitly show which behavior descriptor
  maps to x, y, and z.
- Draw a fitness legend using the same color scale used for filled archive
  cells. Filled cells are colored by the current elite `quality_score`.
- Support timeline play/pause independently from camera motion.
- Support manual camera inspection with horizontal and vertical pointer drag,
  plus wheel zoom. Horizontal drag changes yaw; vertical drag changes pitch.
  Do not clamp pitch to a narrow demo angle; viewers must be able to inspect
  the archive from above, below, and oblique perspectives.
- Enable a slow natural camera spin by default and include a button to toggle
  that spin without changing the archive timeline frame.
- Render all effective z slices in a lower-corner mini-grid panel. Collapsed
  z axes still render one explicit slice. Each slice must be shown as a
  separate labeled layer using the same fitness color scale as the main grid.
- Show archiveable samples as 3D-positioned markers with a short guide line or
  equivalent depth cue, not as flat unanchored circles.
- Preserve 2D collapsed views by rendering the two active axes in the main
  grid while keeping collapsed axes visible in metadata and labels.
- Append one clean final viewer frame after the last history snapshot. This
  frame repeats the final archive state with no newly changed cell outlines or
  current-sample emphasis, so exported animations end on a publication-ready
  final state.

### Inputs

Visualization generation must read only run artifacts:

- `archive_history.jsonl`.
- `archive_space.json`.
- `archive_cells.csv`.
- per-candidate `qd_archive_event.json` files when point-level placement is
  needed.
- `archive_summary.json` or `qd_metrics.json` for final counters.

The renderer must not require access to in-memory archive objects.
Validation artifacts must be offline-reproducible. The interactive HTML must
not depend on CDN-hosted scripts, fonts, or stylesheets. If Three.js or another
browser library is used, vendor it locally into the artifact bundle or embed the
needed JavaScript directly in the generated HTML.

### Required Outputs

For each grid-quantile problem directory in the hard-subset run, generate:

- `grid_quantile_occupancy_evolution.html`: interactive browser view with a
  timeline slider, play/pause control, natural-spin toggle, compact stats
  panel with a size toggle, color-coded BD-axis legend, fitness legend, and
  z-slice layer mini-grids.
- `grid_quantile_occupancy_evolution.webm`: exportable animation. If WebM
  encoding is unavailable in the environment, emit the full PNG frame sequence
  and record an explicit encoder-unavailable validation warning.
- `grid_quantile_frames/`: one PNG frame per archive-history snapshot plus one
  clean final frame. Phase 02 validation must not downsample the history
  timeline.
  Warmup-pending snapshots must render as explicit pending-initialization
  frames, not as fake empty grids.
- `grid_quantile_slides/`: a small ordered set of PNG diagrams for the paper or
  talk:
  - warmup pending.
  - initialization/frozen quantiles.
  - first post-init archive state.
  - mid-run state.
  - final state.
- `grid_quantile_visualization_manifest.json`: source paths, generated files,
  active axes, effective shape, frame count, encoder used, timeline counters,
  final rendered cells, axis layout, and validation checks. It must record
  source artifact mtimes or content hashes for `archive_history.jsonl`,
  `archive_space.json`, and `archive_cells.csv`.
- `grid_quantile_evolution_data.json`: compact replay data used by the HTML
  renderer. It must include one frame per `archive_history.jsonl` snapshot,
  frame-level counters, filled cells, changed cells, and archiveable sample
  points.

### Dimensional Rules

Render from effective bins. Phase 02 visualization support is required only for
journal-style 2D or 3D effective archives:

- three active axes: show a 3D 4 x 4 x 4-style cube when all three axes have
  more than one effective bin. Render the true effective shape, such as
  `4 x 3 x 4`, rather than padding to the intended `4 x 4 x 4` shape.
- two active axes: show a 2D grid when exactly one axis collapses to one
  effective bin. This is the expected combinational case when `ff_depth`
  collapses.
  Preserve collapsed axes in metadata and labels, but render the active 2D
  plane using the two non-collapsed axes. For the common combinational case,
  the manifest should record `collapsed_axes: ["ff_depth"]` and
  `rendered_axes: ["logic_depth", "comb_width_log"]`.

For other descriptor profiles:

- one effective active axis, zero active axes, or more than three active axes
  may still run through the archive.
- the Phase 02 bin-occupancy visualizer may skip those profiles with a clear
  manifest status and reason.
- generic history plots may still be emitted, but the interactive bin
  visualization is not required to work outside 2D/3D effective archives.

The manifest must record both intended shape and effective shape,
`collapsed_axes`, and `rendered_axes`. The title and axis labels must use real
descriptor names, not generic BD1/BD2/BD3 labels.
Filled cells must use the current elite `quality_score` as the main color
encoding. Newly filled or replaced cells in a frame may be emphasized with
opacity, outline, pulse, or another non-color cue, but generation-change
highlighting must not replace the quality color scale.

### Visualization Validation Gates

Add an automated validation command, preferably
`scripts/validate_grid_quantile_visualizations.py`, that checks every generated
visualization directory.

Required checks:

1. `archive_history.jsonl` has at least one warmup-pending snapshot and at
   least one snapshot after initialization for initialized problems.
2. PNG frame count equals the full `archive_history.jsonl` length plus one
   clean final frame. The clean final frame must be marked in
   `grid_quantile_evolution_data.json`, repeat the final archive state, and
   have no changed-cell highlight list.
3. Final frame occupied-cell count in the manifest equals final
   `archive_summary.json.occupied_cells`.
4. Effective shape in the manifest equals the effective bins in
   `archive_space.json`.
5. For supported journal visualizations, 3D versus 2D mode matches the number
   of non-collapsed axes. Other descriptor dimensionalities must be skipped
   with an explicit manifest reason.
6. Every generated PNG has non-zero dimensions and file size greater than
   `10 KiB`.
7. Pixel variance for every generated PNG is greater than `0.0001` so blank or
   all-white frames fail validation.
8. The animation file exists and is greater than `100 KiB`, or the manifest
   records an explicit encoder-unavailable warning and every full-timeline PNG
   frame passes validation. Failing to produce both a valid video and valid
   frames is a hard failure.
9. The final visualization state agrees with `archive_cells.csv`: every final
   occupied cell listed in the CSV is represented in the manifest.
10. Interactive HTML is self-contained or references only local generated
    assets. CDN or network-only dependencies fail validation.
11. Visualization outputs are fresh relative to their source artifacts. The
    manifest source mtimes or hashes must match current `archive_history.jsonl`,
    `archive_space.json`, and `archive_cells.csv`, and generated outputs must
    not predate those sources.

Use Playwright or a lightweight image reader for the checks. The hard-subset
acceptance run must fail if these checks fail.

## Testing Plan

### Focused Unit Tests

Add or extend tests in `tests/revolution/test_qd_archive.py` for:

- quantile boundary calculation with the documented method.
- duplicate quantile collapse.
- one effective bin when all warmup samples on an axis are equal.
- cell assignment below, at, between, and above boundaries.
- dimensionality errors.
- warmup buffering before initialization.
- initialization from warmup samples.
- warmup reinsertion and elite replacement after initialization.
- `describe_space()` intended/effective bins and collapsed-axis payload.
- `describe_assignment()` payload before and after initialization.

### Engine And CLI Tests

Add or extend:

- `tests/revolution/test_qd_engine.py`:
  - engine constructs `GridQuantileArchive` for
    `qd_archive_type="grid_quantile"`.
  - journal descriptor axes are selected from
    `journal_logic_ff_width_3d`.
  - archive history snapshots expose initialized/pending state.
  - summary and archive-space artifacts are written for `grid_quantile`.
- `tests/scripts/test_run_backend.py`:
  - CLI parses grid-quantile flags.
  - backend args propagate grid-quantile settings.
  - unsupported archive type still fails.
- hard-subset wrapper tests:
  - `scripts/run_hard_iteration_qd_vllm.sh` passes through `qd_archive_type`.
  - it passes through `qd_descriptor_profile`.
  - it passes through `qd_grid_quantile_warmup_successes`.
- artifact/report tests:
  - `archive_space_report.md` mentions collapsed axes and boundary
    inclusivity.
  - `archive_cells.csv` row count equals occupied cells.
  - per-candidate `qd_archive_event.json` assignment matches frozen
    boundaries.
- visualization tests:
  - synthetic 4 x 4 x 4 history fixture renders 3D outputs.
  - synthetic 4 x 1 x 4 history fixture renders 2D outputs.
  - non-journal dimensionality is skipped with an explicit manifest reason.
  - validation fails on a blank frame, wrong frame count, wrong effective
    shape, and missing final occupied cell.

### Required Local Verification

Before implementation changes:

```bash
cd /workspace/.worktrees/journal-quantile-binning
source /workspace/.venv/bin/activate

/workspace/.venv/bin/python -m pytest \
  tests/revolution/test_qd_archive.py \
  tests/revolution/test_qd_engine.py \
  -q
```

After implementation:

```bash
/workspace/.venv/bin/python -m pytest \
  tests/revolution/test_qd_archive.py \
  tests/revolution/test_qd_engine.py \
  tests/revolution/test_qd_descriptors.py \
  tests/scripts/test_run_backend.py \
  -q
```

If visualization scripts are added:

```bash
/workspace/.venv/bin/python -m pytest \
  tests/scripts/test_validate_grid_quantile_visualizations.py \
  tests/scripts/test_render_grid_quantile_visualizations.py \
  -q
```

Run lint/type checks on touched Python files:

```bash
/workspace/.venv/bin/ruff check \
  src/revolution/qd/archive.py \
  src/revolution/qd/engine.py \
  src/revolution/qd/artifacts.py \
  src/revolution/qd/visualization.py \
  scripts/run_backend.py \
  tests/revolution/test_qd_archive.py \
  tests/revolution/test_qd_engine.py \
  tests/scripts/test_run_backend.py

/workspace/.venv/bin/python -m pyright \
  src/revolution/qd/archive.py \
  src/revolution/qd/engine.py \
  src/revolution/qd/artifacts.py \
  scripts/run_backend.py
```

If `scripts/run_hard_iteration_qd_vllm.sh` is touched:

```bash
bash -n scripts/run_hard_iteration_qd_vllm.sh
```

## Live vLLM Validation

### Preflight

Confirm the live vLLM server and model:

```bash
curl http://host.docker.internal:8000/v1/models

MODEL_ID="$(curl -sS http://host.docker.internal:8000/v1/models | \
  /workspace/.venv/bin/python -c 'import json,sys; print(json.load(sys.stdin)["data"][0]["id"])')"

echo "${MODEL_ID}"
```

This is a reasoning-model setup. For real tuning traces, keep:

- `max_model_len >= 128000`.
- `--max_tokens 128000`.
- `--diff_max_tokens 128000`.
- `--vllm_min_model_len 128000`.

Do not use tiny token caps to judge grid-quantile behavior.

### Direct Smoke

Run one direct classic smoke and one direct grid-quantile smoke on a small hard
subset. This smoke proves CLI wiring, archive initialization, and artifact
emission, but it is not the final acceptance gate. The smoke intentionally uses
`qd_grid_quantile_warmup_successes 4` so a one-generation run can initialize
quickly when the smoke samples have enough descriptor diversity. A
descriptor-identical smoke may remain warmup-pending or finish as
`initialized_but_degenerate`; that is acceptable for smoke only if artifacts
and validators make the state explicit.

Classic:

```bash
RUN_ROOT="exp/journal_quantile_binning_smoke_$(date +%Y%m%d_%H%M%S)"

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
```

Grid quantile:

```bash
/workspace/.venv/bin/python scripts/run_backend.py \
  --backend revolution \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile journal_logic_ff_width_3d \
  --qd_grid_quantile_warmup_successes 4 \
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
  --save_path "${RUN_ROOT}/grid_quantile_journal_bd" \
  --no-backend_subdir \
  --seed 42
```

Smoke pass gates:

- both commands exit `0`.
- grid-quantile `archive_summary.json` has `archive_type == "grid_quantile"`.
- grid-quantile archive initializes after warmup on at least one smoke problem.
- grid-quantile `archive_space.json` records quantile boundaries and effective bins.
- collapsed axes are visible when present.
- post-init candidates can fill or replace cells.
- `archive_history.jsonl` has at least two snapshots.
- at least one grid-quantile problem emits visualization outputs or a clear
  validation warning explaining why no initialized archive existed.

### Full Hard-Subset Acceptance Run

Create a scratch config under `exp/`; do not commit it unless explicitly
requested:

```bash
mkdir -p exp/journal_quantile_binning_configs
cp data/configs/hard_iteration_subset.yaml \
  exp/journal_quantile_binning_configs/hard_subset_grid_quantile.yaml
```

Set the matrix to:

```yaml
matrix_modes:
  - classic
  - grid_quantile_journal_bd

modes:
  classic:
    search_mode: revolution
    seed: 42
  grid_quantile_journal_bd:
    search_mode: revolution_qd
    qd_archive_type: grid_quantile
    qd_descriptor_profile: journal_logic_ff_width_3d
    qd_grid_quantile_warmup_successes: 8
    seed: 42
```

The Phase 02 acceptance matrix is classic versus `grid_quantile_journal_bd`
only. CVT journal runs may be useful as optional context, but they are not part
of the hard acceptance gate.

One full hard-subset run with the configured seed is sufficient for Phase 02
acceptance. This phase validates archive correctness and artifacts, not
multi-seed search-performance claims. Deterministic unit and integration tests
must cover archive math and visualization checks; multi-seed search validation
is deferred. The acceptance seed is `42`, and the validation report must record
the seed used by both modes.

The full hard-subset acceptance run uses `8` warmup successes and
`HARD_SUBSET_NUM_GENERATIONS=5`, meaning `Gen0` plus generations `1` through
`5`. Larger journal runs should raise warmup back to `20` unless the goal is
specifically to stress early initialization.

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
HARD_SUBSET_SAVE_PATH=exp/journal_quantile_binning_hard_subset \
bash scripts/run_hard_iteration_qd_vllm.sh \
  --config exp/journal_quantile_binning_configs/hard_subset_grid_quantile.yaml \
  --mode matrix
```

The acceptance run uses four total worker slots, up to four active problems,
and up to four workers per problem. Resolved worker settings must be recorded
in `grid_quantile_validation.json` and `grid_quantile_validation.md`.

After the run:

```bash
RUN_ROOT="<printed save path from wrapper>"

/workspace/.venv/bin/python scripts/backend_comparison_report.py \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_journal_bd="${RUN_ROOT}/grid_quantile_journal_bd" \
  --output "${RUN_ROOT}/backend_comparison.md"

/workspace/.venv/bin/python scripts/report_final_analysis_bundle.py \
  --run-root "${RUN_ROOT}" \
  --subset-config exp/journal_quantile_binning_configs/hard_subset_grid_quantile.yaml

/workspace/.venv/bin/python scripts/report_design_space_analysis.py \
  --run-root "${RUN_ROOT}" \
  --subset-config exp/journal_quantile_binning_configs/hard_subset_grid_quantile.yaml \
  --feature-profile journal_logic_ff_width_3d
```

Add a strict audit command, preferably:

```bash
/workspace/.venv/bin/python scripts/validate_grid_quantile_run.py \
  --run-root "${RUN_ROOT}" \
  --subset-config exp/journal_quantile_binning_configs/hard_subset_grid_quantile.yaml \
  --classic-mode classic \
  --grid-quantile-mode grid_quantile_journal_bd \
  --require-full-subset \
  --require-visualizations \
  --acceptance-hard-subset
```

The audit command must emit:

- `grid_quantile_validation.json`.
- `grid_quantile_validation.md`.
- non-zero exit status on any failed hard gate.

The validation report must lead with a per-problem acceptance table containing:

- problem name.
- classic fully successful final-PPA sample count.
- grid-quantile fully archiveable sample count.
- grid-quantile validation state.
- intended shape.
- effective shape.
- collapsed axes.
- visualization status.
- notes for warmup-limited, degenerate, skipped visualization, or invalid
  checks.

The validation report must also record resolved run settings, including seed,
population size, generation count, `total_worker_slots`, `max_active_problems`,
and `max_workers_per_problem`. For Phase 02 acceptance, validation must fail if
the resolved worker settings do not match `total_worker_slots=4`,
`max_active_problems=4`, and `max_workers_per_problem=4`.

The validation report must include a "Deferred From Phase 02" section listing:

- KS-triggered re-binning.
- Pareto-front archive cells.
- thought-only individuals and k-code evaluation.
- fail-pool and parent-source probability redesign.
- descriptor-targeted operators for `journal_logic_ff_width_3d`.
- configurable `grid_quantile` bin count.

## Quantitative Acceptance Gates

The full hard-subset run is satisfactory only if every hard gate passes.
Warmup-limited problems are allowed, but they must be counted and reported
separately from initialized grid-quantile successes. Degenerate initialized
archives are also allowed, but they must be reported separately because they do
not prove the intended 2D/3D diversity behavior.

For the current 13-problem hard subset, the aggregate warmup-limited allowance
is:

```text
allowed_warmup_limited = min(classic_below_warmup_count, 3)
```

`classic_below_warmup_count` is the number of classic problem runs with fewer
than the grid-quantile warmup target of fully successful final-PPA samples. If
classic produces at least `8` fully successful final-PPA samples for every
problem, grid-quantile must initialize on every problem. If classic has two
problems below that threshold, grid-quantile may have at most two
`warmup_limited` problems. If classic has four or more, grid-quantile may have
at most three. Any additional non-initialized grid-quantile problem is
`invalid`, not `warmup_limited`.

The aggregate degenerate-initialized allowance is:

```text
allowed_initialized_but_degenerate = 2
```

At most two of the 13 hard-subset problems may end as
`initialized_but_degenerate`. Any additional degenerate initialized problem is
an acceptance failure because the run no longer validates the intended 2D/3D
journal diversity and visualization behavior.

Every grid-quantile problem must end in exactly one validation state:

- `initialized`: reached `warmup_successes`, froze quantile boundaries,
  produced post-init archive geometry, and has at least two active effective
  axes for the journal profile.
- `initialized_but_degenerate`: reached `warmup_successes` and has valid
  frozen quantile geometry, but fewer than two journal axes have more than one
  effective bin. This is valid archive behavior, but it is not counted as a
  complete 2D/3D diversity or visualization success.
- `warmup_limited`: produced fewer than `warmup_successes` fully archiveable
  candidates by run end. This is not a hard failure, but it is not counted as a
  complete grid-quantile archive success.
- `invalid`: violated an archive, artifact, assignment, or reporting
  invariant. This is a hard failure.

### Run-Level Gates

- The wrapper exits `0`.
- The wrapper passes through `qd_archive_type`, `qd_descriptor_profile`, and
  `qd_grid_quantile_warmup_successes` to `run_backend.py`.
- Both classic and grid-quantile modes produce one problem report directory for
  every problem in `hard_iteration_subset.yaml`.
- Resolved run config/artifacts prove both modes ran with seed `42`; missing
  or mismatched seed pass-through is `invalid`.
- `backend_comparison.md`, `final_analysis/`, and design-space analysis are
  generated.
- The grid-quantile mode has no uncaught archive/config exceptions.
- The grid-quantile run uses `journal_logic_ff_width_3d` for every QD problem.
- Every grid-quantile problem emits `descriptor_health.json` and
  `descriptor_health_report.md`.
- `invalid` problem count is `0`.
- `warmup_limited` problem count is no greater than
  `min(classic_below_warmup_count, 3)`.
- `initialized_but_degenerate` problem count is no greater than `2`.

### Classic Comparison Gates

These gates are meant to catch broken archive behavior, not to claim a search
win.

- Grid-quantile design-level functionality pass count is at least `90%` of classic
  and no more than one problem below classic when classic solves at least ten
  problems.
- Grid-quantile synthesis/PPA-valid problem count is at least `90%` of classic and
  no more than one problem below classic when classic solves at least ten
  problems.
- For every problem where classic has at least one synthesis/PPA-valid
  candidate, grid-quantile must end as `initialized`,
  `initialized_but_degenerate`, or `warmup_limited`.
- If classic solves all `13` current hard-subset problems, grid-quantile must solve
  at least `12` at both functionality and synthesis/PPA levels.
- Grid-quantile may be worse than classic on best score mean in this phase, but
  worse score must be reported with archive health metrics rather than ignored.

### Archive Geometry Gates

For every grid-quantile problem:

- `archive_summary.json.archive_type == "grid_quantile"`.
- `archive_space.json.archive_type == "grid_quantile"`.
- `archive_space.json.descriptor_profile == "journal_logic_ff_width_3d"`.
- `descriptor_axes == ["logic_depth", "ff_depth", "comb_width_log"]`.
- every fully archiveable grid-quantile candidate has finite descriptor values
  for `logic_depth`, `ff_depth`, and `comb_width_log`; missing or non-finite
  journal descriptors are `invalid`.
- quantile boundaries are problem-local and are not reused across problem
  directories.
- `intended_bins_per_axis == 4`.
- `intended_num_cells == 64`.
- If at least `warmup_successes` fully archiveable successes exist, the archive
  is initialized by run end. If the minimum active geometry is not reached,
  initialization happens as a `run_finalization_fallback` and may be reported
  as `initialized_but_degenerate`.
- If initialized:
  - `initialization_sample_count >= warmup_successes`.
  - `initialization_sample_count == len(warmup_initialization_samples)`.
  - `warmup_buffer_size == 0`.
  - every axis has sorted unique `quantile_boundaries`.
  - quantile boundaries recomputed from `warmup_initialization_samples` with
    `linear_interpolation_n_minus_1` and duplicate-only collapse exactly match
    `archive_space.json`.
  - warmup replay recomputed from `warmup_replay_results` in stored warmup
    order, using frozen boundaries and scalar `quality_score`, exactly matches
    recorded `cell_id`, `decision`, `inserted`, `replaced`, and the final elite
    set produced by warmup replay.
  - `effective_bins == len(quantile_boundaries) + 1` for every axis.
  - `num_cells == product(effective_bins)`.
  - `coverage == occupied_cells / num_cells`.
  - `occupied_cells <= num_cells`.
  - boundary hashes in all post-init `archive_history.jsonl` snapshots match
    the quantile boundaries recorded in `archive_space.json`.
  - top-level `archive_space.json.quantile_boundaries_hash` matches the same
    recomputed canonical boundary hash.
- If not initialized:
  - total fully archiveable successes must be less than `warmup_successes`.
    A run with at least `warmup_successes` successes but insufficient active
    geometry must initialize through `run_finalization_fallback` and be
    reported as `initialized_but_degenerate`, not left pending.
  - validation report must mark the problem as `warmup_limited`, not
    `initialized`.
  - the report must show the exact archiveable-success count and the configured
    warmup target.

### Stage-By-Stage Evolution Gates

For every initialized grid-quantile problem:

- `archive_history.jsonl` includes any warmup-pending snapshots emitted before
  initialization and at least one snapshot per completed generation.
- `initialized` changes from false to true at most once.
- After initialization, `initialized` never returns to false.
- After initialization, `occupied_cells` is non-decreasing.
- After initialization, `coverage` is non-decreasing.
- After initialization, `best_quality` is non-decreasing when present.
- No post-init event has decision `warmup_buffered`.
- Every post-init `qd_archive_event.json.cell_id` equals
  `assignment.cell_id`.
- Every post-init assignment recomputed from `descriptor_tuple` and frozen
  boundaries matches the recorded `cell_id`.
- `archive_cells.csv` row count equals final `occupied_cells`.
- Every final `archive_cells.csv.cell_id` is unique and within the effective
  bin ranges.
- Every final `archive_cells.csv.cell_id` recomputed from that row's
  descriptor tuple and frozen boundaries matches the recorded final cell ID.
- At least one of these must happen after initialization on every problem with
  post-init archiveable successes:
  - a new cell is filled, or
  - an existing elite is replaced, or
  - a non-inserted same-cell candidate is recorded with a valid assignment.

### Visualization Gates

For every initialized grid-quantile problem:

- visualization manifest exists.
- frame count equals the selected history snapshot count.
- final visualization occupied cells match final `archive_cells.csv`.
- 3D/2D mode matches effective non-collapsed axes for the journal profile.
- all PNG frames pass file-size and pixel-variance checks.
- animation exists, or an encoder-unavailable warning is recorded and the full
  PNG frame sequence is valid.

Across the full hard-subset validation run:

- if the initialized journal archives naturally include both 3D effective
  archives and collapsed 2D effective archives, at least one valid live
  visualization of each kind is required.
- if the hard subset does not naturally produce one of those dimensional cases,
  the missing case must be covered by a deterministic synthetic visualization
  test fixture.

For every supported visualization:

- the manifest records `visualization_version >= 2`.
- `axis_layout.z == "ff_depth"` for `journal_logic_ff_width_3d`.
- `cell_count_sequence` exactly matches `archive_history.jsonl.occupied_cells`.
- `sample_count_sequence` is monotonically nondecreasing.
- the manifest records `animation_checks.has_state_progression == true` when
  the history has more than one frame.
- `final_cell_ids` exactly matches `archive_cells.csv`.
- the HTML includes the statistics panel, z-slice panel, timeline controls,
  and embedded/offline timeline data.

For every `initialized_but_degenerate` problem:

- visualization validation must emit a clear skipped status with the effective
  bin shape and the reason that fewer than two axes are active.

For every warmup-limited problem:

- visualization validation must emit a clear skipped status with the exact
  reason and the archiveable success count.

## Documentation Updates

Update these documents with the implementation:

- `docs/journal_features/02_quantile_binning.md`.
- `docs/qd_map_elites_guide.md`.
- `docs/module_structure.md` if new scripts/classes/modules are added.
- `docs/user_guide.md` for user-facing CLI flags and visualization commands.

Comments and docstrings should explain only non-obvious behavior:

- quantile collapse.
- boundary inclusivity.
- warmup initialization and reinsertion.
- why boundaries are static until Phase 07.

## Completion Checklist

Target deadline: `2026-05-04`

- [x] 2.1 Add `GridQuantileArchive` with static quantile initialization,
  duplicate-boundary collapse, effective cell IDs, and one-elite replacement.
- [x] 2.2 Wire `grid_quantile` through archive type unions, QD engine
  construction, run_backend CLI, configs, artifacts, and reports.
- [x] 2.3 Add focused unit, engine, CLI, artifact, and visualization tests.
- [x] 2.4 Generate grid-quantile visualizations from real archive artifacts,
  including 3D 4 x 4 x 4 and collapsed-axis 2D views.
- [x] 2.5 Add strict run and visualization validation scripts.
- [x] 2.6 Pass local tests, lint, and type checks on touched files.
- [x] 2.7 Pass direct live vLLM smoke.
- [x] 2.8 Pass full hard-subset live vLLM matrix validation against classic
  with the validation command exiting `0`.
- [x] 2.9 Record final validation artifacts and stage log in this document.

## Stage Log

Use this section during implementation so Phase 02 can be audited without
reconstructing it from commits.

### Stage 1: Archive Variant

- Implemented initial `GridQuantileArchive` with static four-bin quantile
  initialization, duplicate-boundary collapse, effective cell IDs, warmup
  replay metadata, and scalar `quality_score` replacement.

### Stage 2: Engine, CLI, And Artifacts

- Implemented initial `grid_quantile` engine/backend/CLI wiring,
  `grid_quantile_layout.json`, warmup/replay artifact payloads, compact history
  geometry digest, and hard-subset wrapper pass-through for
  `qd_grid_quantile_warmup_successes`.

### Stage 3: Visualization Outputs

- Implemented initial offline grid-quantile HTML, PNG frame sequence, slide
  PNGs, and visualization manifest with source artifact hashes. WebM export is
  represented by an explicit encoder-unavailable warning when no encoder path
  is configured.

### Stage 4: Local Verification

- Passed focused local verification:
  - `tests/revolution/test_qd_archive.py`
  - `tests/revolution/test_qd_engine.py`
  - `tests/revolution/test_qd_descriptors.py`
  - `tests/revolution/test_revolution_backend.py`
  - `tests/scripts/test_run_backend.py`
  - `tests/scripts/test_run_hard_iteration_qd_vllm.py`
  - `tests/scripts/test_validate_grid_quantile.py`
  - `tests/scripts/test_archive_baseline.py`
- Passed `ruff check` on touched Python files.
- Passed `pyright` on touched QD/backend/validation files plus
  `src/revolution/algorithm.py`, with the existing `tqdm` source-resolution
  warning in `scripts/run_backend.py`.

### Stage 5: Live Smoke

- Completed direct live vLLM smoke at
  `exp/journal_quantile_binning_smoke_20260504_161939`.
- The official warmup-4 smoke completed for classic and
  `grid_quantile_journal_bd`. Both grid-quantile smoke problems were
  `warmup_limited` because they produced 3/4 and 2/4 archiveable warmup
  candidates; visualization validation passed for the pending-state artifacts.
- A bounded one-problem init check with `qd_grid_quantile_warmup_successes=2`
  initialized successfully and passed validation as
  `initialized_but_degenerate`, proving frozen-boundary and replay artifacts on
  a live run.

### Stage 6: Full Hard-Subset Validation

- The first required 13-problem hard-subset matrix completed at
  `exp/journal_quantile_binning_hard_subset/20260504_165151` with population
  20, generations 5, seed 42, and worker settings 4/4/4.
- That first matrix proved the wrapper/report/visualization path but failed
  acceptance with `initialized_but_degenerate_count=5`, above the cap of `2`.
  This drove two implementation fixes: duplicate-only boundary collapse and a
  delayed freeze until at least `min(2, axis_count)` axes are active, with
  run-finalization fallback for genuinely degenerate archives.
- A second full matrix at
  `exp/journal_quantile_binning_hard_subset_duplicate_only/20260504_223434`
  reduced degenerate archives to one but failed acceptance because
  `Prob153_gshare` ended `warmup_limited` with 7/8 archiveable samples while
  classic had enough successful final-PPA samples. This exposed pre-init
  parent starvation.
- Targeted `Prob153_gshare` probes showed the fix: warmup-buffered candidates
  must be selectable success parents from the initial rebuild path, and
  pending `grid_quantile` runs must reserve at least half of the offspring
  budget for success-parent refinement when both pools are non-empty. The
  passing probe was
  `exp/journal_quantile_binning_prob153_probe_20260505_015736`, where
  `Prob153_gshare` initialized with 8 warmup samples and ended with 8 occupied
  cells.
- The final required 13-problem hard-subset matrix completed at
  `exp/journal_quantile_binning_hard_subset_final/20260505_022158` with
  population 20, generations 5, seed 42, and worker settings 4/4/4. Classic
  and `grid_quantile_journal_bd` both completed all 13 problems. Grid-quantile
  used `qd_archive_type=grid_quantile`,
  `qd_descriptor_profile=journal_logic_ff_width_3d`, and
  `qd_grid_quantile_warmup_successes=8`.
- Generated final validation artifacts:
  - `hard_iteration_backend_comparison.md`
  - `backend_comparison.md`
  - `final_analysis/`
  - `design_space_analysis/`
  - `grid_quantile_visualization_validation.json`
  - `grid_quantile_validation.json`
  - `grid_quantile_validation.md`
- Visualization validation passed with exit code `0`.
- Full grid-quantile acceptance validation passed with exit code `0`:
  `problem_count=13`, `failure_count=0`, `problem_invalid_count=0`,
  `acceptance_error_count=0`, `warmup_limited_count=0`,
  `initialized_but_degenerate_count=1`, and
  `allowed_initialized_but_degenerate=2`.

## Final Planning Notes

No blocking clarifications remain for implementation. The exact implementation
details that remain, such as internal helper names and file-level factoring,
should be resolved while coding and tests are written.

The classic-comparison gates are intentionally framed as correctness and
regression checks, not search-performance claims. The default animation target
is WebM when an encoder is available; valid full PNG frames plus an explicit
encoder-unavailable warning are sufficient in environments without video
encoding. The HTML demo is a reference for interaction and clarity, not a
pixel-identical requirement.
