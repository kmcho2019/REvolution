# Phase 03.1: Linked Pareto / Archive Visualization

## Goal

Add a reproducible, interactive visualization workflow for comparing classic
RTL evolution against MAP-Elites / QD runs in both archive space and PPA space.

The first target is a static-data HTML viewer generated from completed run
artifacts. It should make the final Phase 03 hard-subset run inspectable
without rerunning experiments:

```text
exp/journal_pareto_front_hard_subset/20260506_040658
```

The viewer must answer, per problem:

1. where each technique's successful candidates land in the QD archive;
2. how candidates distribute in raw PPA and reference-normalized improvement
   space;
3. which candidates are on Pareto rank 0, rank 1, rank 2, and later fronts;
4. how archive occupancy and PPA/Pareto fronts differ between two techniques.

The main comparison target is:

```text
classic
grid_quantile_journal_bd
grid_quantile_pareto_journal_bd
```

The implementation should support one technique alone, classic alone, one QD
technique alone, classic versus one QD technique, and any two named techniques
present in the run root.

## Branch

Work branch:

```text
feat/journal-pareto-visualization
```

Base branch:

```text
wip/journal-extension-2026
```

## Current State

Phase 02 already generates per-problem grid-quantile visualizations for QD
runs:

- `grid_quantile_occupancy_evolution.html`
- `grid_quantile_evolution_data.json`
- `grid_quantile_visualization_manifest.json`
- `grid_quantile_frames/`
- `grid_quantile_slides/`

The current implementation lives mainly in:

```text
src/revolution/qd/visualization.py
scripts/render_grid_quantile_visualizations.py
scripts/validate_grid_quantile_visualizations.py
```

That viewer is useful for one QD archive, but it does not yet solve the new
comparison problem:

- it is generated only for QD/grid-quantile problem directories;
- classic has no native archive, so it is not shown in archive space;
- the HTML does not link archive cells to PPA/Pareto points;
- PPA/Pareto views are still static report figures;
- comparison is spread across `pareto_analysis`, `ppa_distribution`, and
  archive artifacts instead of one interactive per-problem view.

The existing analysis reports already provide useful raw material:

```text
scripts/report_pareto_analysis.py
scripts/report_ppa_distribution.py
src/revolution/qd/pareto_analysis.py
src/revolution/qd/successful_candidate_catalog.py
```

The final Phase 03 hard run provides the data needed for first validation:

```text
final_analysis/ppa_distribution/data/ppa_candidates.csv
final_analysis/ppa_distribution/data/reference_ppa_metrics.csv
final_analysis/pareto_analysis/backend_problem_metrics.csv
<qd_backend>/<model>/<benchmark>/<problem>/archive_space.json
<qd_backend>/<model>/<benchmark>/<problem>/archive_cells.csv
<qd_backend>/<model>/<benchmark>/<problem>/archive_history.jsonl
<qd_backend>/<model>/<benchmark>/<problem>/qd_metrics.json
<pareto_qd_backend>/<model>/<benchmark>/<problem>/global_pareto_archive.csv
```

The demo/spec resources for this phase are:

```text
docs/journal_features/03_1_pareto_visualization_resources/
  ppa_archive_linked_view_timeline_demo_20260506_1631_v4.html
  rtl_qd_ppa_visualization_porting_spec_v2_20260506_1633.md
```

The demo is a design reference, not production code. It currently uses
synthetic data and CDN-hosted Three.js/fonts. The repo feature must be generated
from real artifacts. CDN-backed output is acceptable for fast visual iteration,
but strict validation and archival outputs must be reproducible with local or
inline assets.

## Demo And Phase 02 Parity Requirements

The new viewer should keep the useful interaction model from the demo while
also preserving the inspection and validation strengths of the existing
Phase 02 grid-quantile viewer.

Demo features that must carry over:

- top-level mode selector for `single` versus `compare`;
- selectable technique chips or equivalent technique controls;
- two archive panes plus one shared PPA/Pareto pane in compare mode;
- one archive pane plus one PPA/Pareto pane in single mode;
- archive perspective-lock control in compare mode;
- archive auto-rotate control;
- reset control that restores cameras and clears exploded-layer state;
- per-archive exploded z-layer control;
- play/pause, previous, next, and final-stable-snapshot timeline controls;
- timeline speed slider with visible speed readout;
- timeline readout that includes generation/final state and visible sample
  counters;
- sample-universe control with `all_ppa_valid` as the default and final
  archive/global-Pareto views available as overlays or filters;
- PPA color segmented control with at least `fitness`, `technique`, and
  `rank`;
- PPA coordinate-mode control ordered as `raw`, `improvement`, `normalized`,
  with `raw` selected by default;
- PPA rank segmented control with `all`, `rank 0`, `rank <= 1`, and
  `rank <= 2`;
- Pareto rank-scope control with `per_technique` and `pooled_visible`, default
  `per_technique`;
- per-technique stats cards plus a delta card for the two selected techniques;
- in compare mode, each selected technique's stats card must show both its
  own rank-0 count and its pooled-visible rank-0 contribution count;
- hypervolume stats for each technique plus pooled-visible hypervolume for
  the selected compare pair;
- scatter legend that updates with the active color mode;
- archive layer mini-panels with hoverable cells;
- archive-cell and PPA-point linked tooltips;
- responsive stacked layout for narrow panes.

Phase 02 grid-quantile viewer features that must carry over even if the demo
does not emphasize them:

- real axis names instead of generic BD labels;
- explicit journal archive axis layout:
  `logic_depth` on x, `comb_width_log` on y, and `ff_depth` on vertical z;
- explicit PPA axis layout:
  `area` on x, `power` on depth/z, and effective clock period on vertical y
  for sequential problems;
- visible quantile cutoffs and effective bin intervals for archive axes;
- collapsible archive-axis/bin detail panel;
- in-scene or in-pane boundary tick labels for frozen quantile boundaries;
- fitness/color legend using the same scale as archive cells;
- z-slice/layer panel that remains visible in narrow VS Code preview panes;
- orientation cue in the layer panel;
- sample markers anchored to archive cells, not only filled-cell heatmaps;
- collapsed-axis handling for 2D effective archives;
- clean final frame/state with no change highlight;
- source artifact hashes or mtimes for reproducibility checks;
- validation that rejects stale outputs;
- validation that rejects blank screenshots/frames by pixel variance;
- no hidden required panels in strict viewer checks.

## Non-Goals

Do not rerun LLM experiments for this phase.

Do not change archive insertion, QD parent selection, Pareto replacement,
descriptor extraction semantics, or scoring semantics.

Do not make classic evolution use MAP-Elites during optimization. Classic
archive views are posthoc projections into a QD archive coordinate system.

Do not add a server requirement. The primary artifact is static HTML plus JSON
that can be opened from the filesystem or served by any static file server.

Do not require full hard-run validation for `grid` or `cvt`. They are required
to work at focused smoke scale, while the full acceptance dataset remains
`grid_quantile` because it is the journal hard-run geometry and has frozen
quantile boundaries.

Do not implement failed-candidate overlays in Phase 03.1. Acceptance scope is
PPA-valid candidates only.

## Architecture

Implement this as an exporter plus a viewer bundle.

Recommended files:

```text
scripts/export_qd_ppa_visualization.py
scripts/validate_qd_ppa_visualization.py
src/revolution/qd/ppa_visualization_export.py
src/revolution/qd/ppa_visualization_metrics.py
src/revolution/qd/ppa_visualization_viewer.py
tests/revolution/test_ppa_visualization_export.py
tests/revolution/test_ppa_visualization_metrics.py
tests/scripts/test_export_qd_ppa_visualization.py
tests/scripts/test_validate_qd_ppa_visualization.py
```

Keep the code simple. The exporter should produce static JSON and copy or write
one static HTML viewer. Avoid a frontend build system for the first pass unless
the repository already has one by the time this phase is implemented.

The first production shape can be:

```text
<run_root>/visualization/qd_ppa_viewer/
  index.html
  manifest.json
  datasets/
    <benchmark>__<problem>.json
  assets/
    viewer.js          # optional; may be embedded into index.html
    viewer.css         # optional; may be embedded into index.html
  validation.json
  validation.md
```

If JavaScript/CSS are separate files, they must be local files in the generated
bundle for strict validation. CDN-backed assets are allowed only in explicit
non-strict development exports.

## Asset Modes

Support one explicit asset mode:

```text
--asset-mode cdn
--asset-mode local
--asset-mode inline
```

Rules:

- `cdn` may reference pinned CDN URLs for Three.js, fonts, or similar viewer
  dependencies. It is for rapid UI iteration and closer demo parity.
- `local` copies pinned vendor assets into the generated viewer bundle and
  references them by relative path.
- `inline` embeds the required JavaScript and CSS directly into `index.html`.
- strict validation must reject `cdn` unless the validator receives an explicit
  `--allow-cdn` flag.
- final acceptance artifacts must use `local` or `inline`.
- Python dependencies belong in `uv`/project metadata when needed by the
  exporter. Browser dependencies should be vendored or embedded, not installed
  through `uv`.

Recommended first implementation:

```text
development default: --asset-mode cdn
strict default:      --asset-mode inline
```

This keeps the first viewer easy to build while preserving a reproducible path
for paper artifacts and regression tests.

## Data Contract

### Manifest

Write one top-level manifest:

```json
{
  "schema_version": "qd_ppa_viewer.v1",
  "run_root": "...",
  "created_at": "2026-05-06T00:00:00Z",
  "archive_source_backend": "grid_quantile_pareto_journal_bd",
  "problems": [
    {
      "problem_key": "RTLLM/Prob015_multi_pipe_8bit",
      "benchmark": "RTLLM",
      "problem": "Prob015_multi_pipe_8bit",
      "circuit_type": "sequential",
      "dataset_path": "datasets/RTLLM__Prob015_multi_pipe_8bit.json",
      "techniques": [
        "classic",
        "grid_quantile_journal_bd",
        "grid_quantile_pareto_journal_bd"
      ]
    }
  ]
}
```

### Per-Problem Dataset

Each dataset must be one JSON object:

```json
{
  "schema_version": "qd_ppa_problem.v1",
  "benchmark": "RTLLM",
  "problem": "Prob015_multi_pipe_8bit",
  "circuit_type": "sequential",
  "steps": [0, 1, 2, 3, 4, 5, "final"],
  "archive_definition": {},
  "reference_ppa": {},
  "techniques": {},
  "samples": [],
  "cell_summaries_by_step": {},
  "technique_stats_by_step": {}
}
```

Required `sample` fields:

```text
sample_id
technique
generation
status
is_final_archive_member
mode_global_pareto_member
viewer_pooled_pareto_member
candidate_dir
code_file_path
area
power
eff_clk_period
ref_area
ref_power
ref_eff_clk_period
g_A
g_P
g_T
mean_improvement
descriptor_values
descriptor_tuple
archive_cell_id
archive_indices
pareto_rank_by_step
pareto_rank_final
local_archive_member
local_cell_pareto_rank
quality_score
```

Use `null` only for values that are truly absent, such as
`eff_clk_period` for combinational problems. Required structural fields such as
`sample_id`, `technique`, `generation`, and `status` must not be optional.
For Phase 03.1 acceptance, exported samples must be PPA-valid. The schema may
leave room for future failure overlays, but failed candidates are out of scope.

### PPA Axes

Sequential raw PPA view:

```text
world_x = area
world_z = power
world_y = effective clock period
```

Lower raw values are better for all three metrics. The viewer may invert the
vertical visual direction so lower effective clock period appears higher, but
tooltips and axis labels must show the true raw value.

Combinational raw PPA view:

```text
world_x = area
world_y = power
```

Do not fabricate `eff_clk_period` for combinational dominance. If a visual 3D
slab is used for layout consistency, record the slab axis as display-only.

Reference-normalized improvement view:

```text
g_A = (ref_area - area) / ref_area
g_P = (ref_power - power) / ref_power
g_T = (ref_eff_clk_period - eff_clk_period) / ref_eff_clk_period
```

For combinational problems, active improvement objectives are `g_P` and `g_A`.
For sequential problems, active improvement objectives are `g_P`, `g_A`, and
`g_T`.

### Pareto Ranks

Viewer Pareto ranks are computed in PPA space, not BD archive space.

Use raw PPA minimization or the equivalent reference-improvement maximization.
The default implementation should compute ranks by maximizing active gains
because those fields already exist in the run artifacts.

Pareto rank computation is independent of the active display coordinate mode.
The coordinate toggle changes point positions, axis labels, and tooltip display
values; it must not change which samples are rank 0.

Fixed active objective semantics:

- combinational: minimize raw `area` and `power`, equivalently maximize `g_A`
  and `g_P`;
- sequential: minimize raw `area`, `power`, and `eff_clk_period`,
  equivalently maximize `g_A`, `g_P`, and `g_T`.

Rank numbering:

```text
rank 0 = nondominated front
rank 1 = next front after removing rank 0
rank 2 = next front after removing rank 0 and rank 1
```

Compute ranks:

- per technique by default;
- pooled across the selected visible techniques when explicitly requested;
- per generation step;
- for the selected visible sample set;
- and for the final stable snapshot.

Rank scope must be explicit:

```text
--rank-scope per_technique
--rank-scope pooled_visible
```

Rules:

- default viewer rank scope is `per_technique`;
- `per_technique` computes fronts independently for each technique;
- `pooled_visible` computes fronts after pooling all visible samples from the
  selected techniques at the current step;
- compare-mode stats must expose both per-technique rank-0 counts and each
  technique's contribution to the pooled-visible rank-0 front.

Do not confuse these viewer ranks with Phase 03 local archive
`pareto_rank`, which is one-based inside a single archive cell.

### Hypervolume

Hypervolume uses the same fixed active PPA objective semantics as Pareto ranks.
It must be independent of the display coordinate mode.

Compute:

- per-technique hypervolume for each technique stats card;
- pooled-visible hypervolume for the selected compare pair.

For 2D combinational problems, prefer exact rectangle-union hypervolume. For
3D sequential problems, use an exact method if it stays simple; otherwise use
deterministic Monte Carlo and record:

```text
hypervolume_method
hypervolume_seed
hypervolume_sample_count
hypervolume_reference_point
```

The reference point must be explicit in each dataset. For improvement-space
objectives, the default reference point is the zero-improvement reference
design unless the exporter receives a different configured point.

## Classic Projection Into Archive Space

Classic runs do not have a native QD archive. For visualization, project
classic samples into a fixed archive defined by a selected QD backend.

The archive source must be selectable because future visualization cases may
compare different techniques, descriptor profiles, archive geometries, or seed
families. For the current Phase 03 hard-run data, default to the updated Pareto
QD run:

```text
--archive_source_backend grid_quantile_pareto_journal_bd
```

The exporter must:

1. load `archive_space.json` from the archive source backend for the same
   benchmark/problem;
2. use that archive's frozen quantile boundaries and axis order;
3. load successful classic candidates from existing run artifacts;
4. compute or load the required descriptor values for those candidates;
5. map classic descriptors into the QD archive with the same binning rule;
6. mark every classic archive cell as `projection_type: "posthoc"`;
7. never write projected classic cells back into the original run directory.

For Phase 03.1, classic projection is required for
`journal_logic_ff_width_3d` with `grid_quantile`, `grid`, and `cvt` archive
sources.

Archive projection rules:

- `grid_quantile`: use frozen quantile boundaries from `archive_space.json`
  and the source archive's documented `bisect_right` assignment rule.
- `grid`: use fixed `lower_bound`, `upper_bound`, `bins`, and interval data
  from `archive_space.json`; assign comma-separated bin indices in archive axis
  order.
- `cvt`: require initialized CVT geometry; use scaler means/stds and centroids
  from `archive_space.json`; assign the nearest centroid in frozen normalized
  descriptor space.

If the selected `cvt` or `grid_quantile` archive source is not initialized,
the exporter must fail in strict mode with a clear message. Non-strict export
may keep PPA/Pareto views and mark archive projection as unavailable.

Descriptor sources, in priority order:

1. `qd_archive_event.json` descriptor payloads for QD candidates;
2. `archive_cells.csv` `descriptors_json` for final QD archive members;
3. existing `code_synthesis_report.metrics.json` and descriptor registry
   recomputation for classic candidates;
4. final-analysis candidate CSVs for PPA-only points when descriptor projection
   is not available.

If a successful classic candidate cannot be projected because required
descriptor values are unavailable, include it in the PPA view and mark:

```text
archive_projection_status = "missing_descriptors"
```

Samples with `archive_projection_status="missing_descriptors"` must be excluded
from archive occupancy counts, archive cell summaries, and archive-cell hover
sets. They remain visible in PPA/Pareto views and still participate in PPA
rank/hypervolume calculations when they have valid active PPA objectives.

Do not synthesize fake descriptor values, do not use zero-filled descriptor
tuples, and do not infer archive cells from PPA values.

The validation target is that at least 95 percent of PPA-valid classic samples
in the Phase 03 hard run can be projected for problems whose QD archive source
has initialized grid-quantile boundaries.

## Viewer Requirements

### Renderer Fidelity Requirement

The first implementation attempt proved that a data-correct but flat 2D canvas
viewer is not sufficient for this phase. The accepted viewer must transfer the
visual and interaction intent of the demo:

```text
docs/journal_features/03_1_pareto_visualization_resources/
ppa_archive_linked_view_timeline_demo_20260506_1631_v4.html
```

and must not regress the already useful grid-quantile occupancy viewer style:

```text
grid_quantile_occupancy_evolution.html
```

The exporter/data contract can remain, but the viewer renderer must be treated
as a proper 3D interactive visualization, not a placeholder chart. In
particular:

- sequential PPA views must be rendered as a real 3D scene with perspective
  camera controls;
- 3D archive views must render cells, occupied cells, and sample markers in a
  real 3D archive coordinate system;
- layer explosion must move actual archive layers in 3D, not apply a small 2D
  screen-space offset;
- perspective lock must synchronize real archive camera state between compare
  panes while keeping the PPA camera independent;
- auto-rotate must visibly rotate the 3D scene;
- archive-cell hover and layer-panel hover must highlight the corresponding
  PPA samples;
- PPA-point hover must highlight the corresponding archive cell when projected;
- validation must inspect browser scene/debug state and interaction effects,
  not only look for text tokens or nonblank screenshots.

Use a renderer structure close to the demo. A pinned Three.js asset is the
preferred first target because it provides the required camera, raycast, and
scene primitives without a custom frontend build. Strict artifacts should be
self-contained with local or inline assets. A CDN-backed artifact is acceptable
only as a separate opt-in demo mode.

Reference screenshots captured for visual comparison:

```text
exp/visualization_reference_screenshots/demo_v4_1440x1000.png
exp/visualization_reference_screenshots/existing_grid_quantile_prob098_1440x1000.png
exp/visualization_reference_screenshots/existing_grid_quantile_prob135_1440x1000.png
exp/visualization_reference_screenshots/existing_grid_quantile_prob151_1440x1000.png
exp/visualization_reference_screenshots/current_qd_ppa_index_1440x1000.png
```

The accepted viewer should be visually closer to the demo and existing
grid-quantile screenshots than the current flat `index.html`: the visualization
panes should dominate the first viewport, the archive and PPA scenes should
carry the meaning, and configuration text should not compete with the data.

Use `Prob135_m2014_q6b` as the stronger grid-quantile reference because it has
a 3 x 3 x 1 effective archive with visible occupied cell volumes, quantile
labels, sample markers, axes, and z-slice panel:

```text
exp/journal_pareto_front_hard_subset/20260506_040658/
grid_quantile_pareto_journal_bd/openai-gpt-oss-120b/
VerilogEval-Spec-to-RTL/Prob135_m2014_q6b/
grid_quantile_occupancy_evolution.html
```

The accepted archive pane for the linked viewer does not need to be pixel
identical to that file, but it must preserve the same information density and
spatial clarity: visible archive geometry, readable axes, quantile/bin
landmarks, occupied cell volumes or markers, sample markers, layer panel, and
current generation/final-state context.

Use `Prob151_review2015_fsm` as the required full-3D grid-quantile reference
because none of the three journal BD axes collapse:

```text
exp/journal_pareto_front_hard_subset/20260506_040658/
grid_quantile_pareto_journal_bd/openai-gpt-oss-120b/
VerilogEval-Spec-to-RTL/Prob151_review2015_fsm/
grid_quantile_occupancy_evolution.html
```

Its source viewer reports:

```text
visualization_mode = 3d
effective_shape = [3, 4, 4]
render_shape = [3, 4, 4]
collapsed_axes = []
slice_count = 4
```

The linked viewer must include a matching exported problem state and render it
as a real 3D archive scene. This is the hard gate for proving that the archive
renderer handles non-collapsed 3D grid-quantile archives, not only 2D slabs or
nearly collapsed examples.

### Required Validation Example Matrix

Final validation must exercise multiple representative problems, not just one
happy-path dataset. At minimum, the Playwright validation and visual parity
report must include these named cases:

| Case | Required problem | Required proof |
| --- | --- | --- |
| Sequential 3D PPA | `RTLLM/Prob015_multi_pipe_8bit` or another sequential RTLLM problem with valid timing data | PPA pane renders a real 3D point cloud with area, effective clock period, and power on distinct axes. |
| Sequential full-3D archive | `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` | Archive pane renders non-collapsed `grid_quantile` geometry with all three journal BD axes active and four `ff_depth` slices. |
| Combinational 2D PPA | `RTLLM/Prob004_adder_8bit` or another combinational RTLLM problem | PPA pane renders a 2D scatter using area and power only; `eff_clk_period` is not required or fabricated. |
| Combinational projected archive | `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` | Archive pane renders the 3 x 3 x 1 grid-quantile slab with collapsed `ff_depth` clearly labeled and full bin details available through expansion. |

The validator may choose additional examples from the manifest, but it must
not replace the matrix above with a single sequential or single combinational
case. The final visual parity report must include screenshots and browser
debug metadata for every row in this matrix.

### Control Density And Advanced Details

The current generated `index.html` exposes too many raw settings at once. The
accepted viewer must keep the default UI focused on the main inspection task
and move precise configuration details into collapsed panels.

Default visible controls:

- problem selector;
- single/compare segmented control;
- technique selector or pair selector;
- compact timeline controls: play/pause, previous, next, final snapshot,
  generation slider, speed;
- compact camera/action controls with icon buttons and tooltips: perspective
  lock, auto-rotate, explode layers, reset;
- PPA coordinate segmented control: `raw`, `improvement`, `normalized`;
- PPA color and rank-filter segmented controls in the PPA pane header or
  adjacent compact toolbar.

Default collapsed controls/details:

- rank scope;
- sample universe;
- final-membership overlay source;
- hypervolume method and reference point;
- asset mode;
- source file hashes/mtimes;
- full archive axis definitions;
- grid-quantile cutoffs and bin intervals;
- projection diagnostics and missing-descriptor counts;
- validation/debug metadata.

The default desktop header should fit in at most two compact rows at
`1440 x 1000`, and the main visual panes should start without requiring the
user to scroll. At least 70 percent of the first viewport height should be
visualization panes, not controls or expanded config text.

Use collapsible `Details` or `Advanced` panels for precise settings. These
panels must preserve all information needed for auditability, but they should
be closed by default. Per-pane axis/bin details may expose a small summary by
default and reveal full cutoffs/intervals only after expansion.

### Modes

The viewer must support:

- `single`: one selected technique archive plus PPA/Pareto view;
- `compare`: two selected technique archives plus one shared PPA/Pareto view.

Default compare layout:

```text
left: first technique archive
middle: second technique archive
right: shared PPA/Pareto distribution
```

Single layout:

```text
left: selected technique archive
right: PPA/Pareto distribution
```

Narrow screens may stack panes vertically.

### Technique Selection

The viewer must allow:

- classic only;
- `grid_quantile_journal_bd` only;
- `grid_quantile_pareto_journal_bd` only;
- classic versus `grid_quantile_journal_bd`;
- classic versus `grid_quantile_pareto_journal_bd`;
- `grid_quantile_journal_bd` versus `grid_quantile_pareto_journal_bd`;
- any two techniques present in the exported dataset.

Use technique labels from the manifest, not hard-coded UI-only names.

### Archive View

For each archive pane:

- render grid cells from `archive_definition` in a true archive scene;
- show occupied cells for the selected technique and step;
- show individual samples in or near their assigned cells;
- distinguish native QD archive members from classic posthoc projections;
- color by selectable mode:
  - technique;
  - best `quality_score`;
  - sample count;
  - Pareto rank;
  - mean improvement;
- show a layer/slice panel for 3D archives;
- collapse cleanly to 2D when one descriptor axis has one effective bin.

Archive geometry rendering:

- `grid` and `grid_quantile` render as regular cells using the source archive
  axes and cell boundaries. Three active axes must render as a 3D lattice or
  3D cell stack. One or two active axes may render as a 2D slab, but the viewer
  must label which axes collapsed.
- `cvt` with one, two, or three descriptor dimensions renders true centroid
  cells/points in descriptor space. Samples should be shown at or near their
  assigned centroid, and hover semantics use centroid id.
- `cvt` with more than three descriptor dimensions may use a projected
  grid-like display or dimensionality reduction. The viewer must clearly label
  this as a projection, record the projection method in the dataset, and show a
  visible disclaimer that distances/cell positions are approximate display
  coordinates rather than the true CVT geometry.

Journal BD axis layout:

```text
display_x = logic_depth
display_y = comb_width_log
display_z = ff_depth
```

If the renderer uses Three.js, the implementation may map `display_z` to the
Three.js vertical coordinate:

```text
scene_x = logic_depth
scene_y = ff_depth
scene_z = comb_width_log
```

User-facing labels, legends, debug metadata, and screenshots must still present
the archive axes as `X = logic_depth`, `Y = comb_width_log`, and
`Z = ff_depth`, matching the existing grid-quantile viewer. In PPA space,
effective clock period is vertical.

Archive view parity requirements from the existing grid-quantile viewer:

- show quantile cutoffs and bin intervals for every grid-quantile axis;
- show collapsed axes explicitly instead of silently dropping them;
- show z/layer mini-panels for 3D archives, even in compare mode;
- show current generation/final-state context;
- show occupancy, sample count, rank-0 count, and hover sample membership;
- preserve readable axis labels and legends at desktop and narrow widths;
- avoid rendering a blank or mostly empty archive pane when the source archive
  has initialized cells.

### PPA / Pareto View

The PPA view must support:

- raw PPA coordinates;
- normalized PPA values;
- reference-improvement coordinates;
- default coordinate mode `raw`;
- visible coordinate toggle order: `raw`, `improvement`, `normalized`;
- rank filters: all, rank 0 only, rank <= 1, rank <= 2;
- technique filters;
- final stable snapshot;
- generation timeline playback;
- reference design marker;
- rank 0 front highlighting per technique;
- optional rank 1, rank 2, ... front highlighting.

For sequential problems, use a proper 3D scene. For combinational problems,
use a 2D scatter view by default.

Sequential raw PPA coordinates:

```text
world_x = area
world_y = eff_clk_period
world_z = power
```

Lower raw values are better for all three metrics. The viewer may invert the
visual direction for `eff_clk_period` so better timing appears higher, but the
axis label and tooltip must show the raw value. The point must still have a
real z coordinate from power.

Sequential improvement coordinates:

```text
world_x = g_A
world_y = g_T
world_z = g_P
```

Combinational raw PPA coordinates:

```text
world_x = area
world_y = power
```

Combinational improvement coordinates:

```text
world_x = g_A
world_y = g_P
```

The coordinate toggle changes only point positions and labels. Pareto ranks,
rank-0 highlighting, and hypervolume must continue to use the fixed active
objective semantics defined above.

Rank-0 rendering should be visually obvious without inventing a misleading
surface. For 2D, draw a front polyline when the ordering is unambiguous. For
3D, render rank-0 points larger and brighter, optionally with nearest-neighbor
or objective-sorted guide lines. Do not draw a smooth Pareto surface unless the
surface is explicitly computed and labeled as an interpolation.

### Linked Interaction

Hovering an archive cell must:

- highlight that cell in the archive pane;
- highlight all samples assigned to that cell;
- highlight the same samples in the PPA/Pareto view;
- show cell summary: technique, cell id, sample count, best PPA, best
  improvement, best quality score, and rank-0 sample count.

Hovering a PPA point must:

- highlight the point;
- highlight its archive cell if projected;
- show sample details: id, technique, generation, strategy, raw PPA, gains,
  Pareto rank, archive cell, candidate path.

Clicking a point should pin the tooltip or open a compact sample details panel.
Pinned details are useful but not required for the first acceptance gate.

Hover linking must be implemented with actual hit testing:

- archive panes use 3D raycasting or equivalent cell hit detection;
- PPA panes use 3D raycasting for sequential views and 2D hit testing for
  combinational views;
- layer mini-panel hover maps to the same cell id and sample ids as archive
  cell hover;
- compare mode highlights the same sample ids across both archive panes and
  the shared PPA pane when those samples are visible.

### Timeline

The viewer must expose:

- generation slider;
- play/pause;
- previous/next generation;
- jump to final stable snapshot;
- playback speed control.

Timeline sample universe:

```text
--sample-universe all_ppa_valid
--sample-universe final_archive_members
--sample-universe viewer_pooled_pareto_members
```

Rules:

- default timeline sample universe is `all_ppa_valid`;
- `all_ppa_valid` shows every candidate with valid active PPA objectives up to
  the current step;
- final archive membership and viewer-pooled Pareto membership should be
  available as overlays or filters, not as the default sample universe;
- `viewer_pooled_pareto_member` is computed by the exporter across selected
  visible techniques and should be the default Pareto-membership overlay;
- `mode_global_pareto_member` comes only from a run's own
  `global_pareto_archive.csv` when that artifact exists;
- preserve `mode_global_pareto_member` as a separate badge for Phase 03 Pareto
  QD runs that emitted a global archive;
- classic has no native final archive membership unless projected by the
  exporter, so the UI must label classic archive membership as posthoc.

The final stable snapshot is distinct from the last generation step and should
prefer final archive/global-Pareto membership when available.

For QD techniques, archive occupancy over time should come from
`archive_history.jsonl` and candidate archive events. For classic, build a
posthoc projected occupancy timeline from candidate generation numbers.

### Timeline Fidelity

Phase 03.1 does not require bit-for-bit replay of every archive insertion,
replacement, and culling event. It must provide analytically useful generation
filtering:

- PPA/Pareto points are filtered by generation using
  `final_analysis/ppa_distribution/data/ppa_candidates.csv` or equivalent
  candidate records;
- classic posthoc archive occupancy is built from projected PPA-valid
  candidates whose generation is less than or equal to the selected step;
- QD archive panes use `archive_history.jsonl` for aggregate counters;
- QD archive panes may use `qd_archive_event.json`, `archive_cells.csv`, and
  candidate generation numbers to place visible samples where available;
- final stable state must agree with final archive/global-Pareto artifacts.

Exact event replay is deferred unless it is cheap to implement cleanly.
Adaptive rebinning will likely require true replay because the archive
coordinate system may change over time; Phase 03.1 should keep the data schema
able to store replay frames later without making replay a current hard gate.

## Renderer V2 Implementation Plan

Do not try to rescue the flat canvas renderer with small patches. Keep the
exporter, schema, PPA rank, hypervolume, and projection work, but replace the
viewer rendering layer with a real scene-based implementation.

Recommended implementation order:

1. Move viewer JavaScript and CSS out of the Python string template into
   versioned viewer assets copied or inlined by the exporter.
2. Add a pinned Three.js asset path for `local` and `inline` strict exports.
   Keep CDN support only behind `--asset-mode cdn --allow-cdn`.
3. Add a small browser debug API:

   ```text
   window.__QD_PPA_VIEWER_DEBUG__
   ```

   The debug API must expose selected problem, selected techniques, scene
   dimensionality, camera state, visible sample count, z/depth ranges,
   highlighted sample ids, highlighted cell id, and whether perspective lock,
   auto-rotate, and exploded layers are active.
4. Build `ArchiveScene` for grid and grid-quantile sources:
   - true 3D cells for three active axes;
   - true 2D slab for one or two active axes;
   - occupied-cell mesh/material updates by technique, generation, and color
     mode;
   - sample markers placed inside or near assigned cells;
   - axis labels, quantile cutoff labels, collapsed-axis labels, and layer
     mini-panels.
5. Build `ArchiveScene` for CVT sources:
   - true centroid rendering for one, two, or three descriptor dimensions;
   - projected rendering with visible disclaimer for more than three
     dimensions.
6. Build `PpaScene`:
   - 3D point cloud for sequential raw/improvement/normalized coordinates;
   - 2D scatter for combinational coordinates;
   - rank-0 emphasis, technique coloring, fitness coloring, and final-member
     overlays;
   - independent camera from the archive panes.
7. Build interaction controllers:
   - archive-cell raycast hover to PPA highlight;
   - PPA-point raycast hover to archive-cell highlight;
   - layer mini-panel hover using the same cell-id mapping;
   - click-to-pin details if it stays simple.
8. Build camera controls:
   - archive compare perspective lock;
   - independent PPA camera;
   - auto-rotate for archive scenes;
   - reset that restores cameras and exploded layers without changing problem
     or technique selection.
9. Harden Playwright validation so the current flat canvas renderer fails
   strict validation for sequential PPA and 3D archive datasets.
10. Regenerate the Phase 03 hard-run viewer and inspect the required
    screenshots before considering the goal complete.

Avoid adding a frontend build system in the first V2 unless it materially
simplifies the code. A small set of static JS/CSS assets is enough for this
phase and keeps the exported viewer reproducible.

## Known Problems To Fix Before Relaunch

Do not start another acceptance run until these are addressed:

1. The current viewer renderer is structurally incapable of passing the demo
   goal because it is a flat 2D canvas implementation.
2. The current validation accepts superficial evidence: text tokens, nonblank
   screenshots, and control presence. It does not prove real 3D scenes,
   camera behavior, raycast hover behavior, visual parity, or UI density.
3. The current UI exposes implementation settings as the default experience.
   It needs a cleaner default state with advanced details collapsed.
4. Archive and PPA cameras are not real stateful objects, so perspective lock,
   reset, and auto-rotate cannot be meaningfully validated.
5. Archive hover, PPA hover, and layer-panel hover are not linked through a
   shared sample/cell identity model.
6. Sequential PPA points do not have a real power/depth coordinate in the
   renderer.
7. Existing grid-quantile visual semantics are not preserved: axis arrows,
   quantile landmarks, occupied volume rendering, z-slice panel, frame context,
   and visual hierarchy are all weaker than the baseline.
8. The validation script does not currently fail when a required 3D view is
   rendered as flat 2D.

The next implementation attempt should first make validation fail on the
current unacceptable viewer, then implement the V2 renderer until those
validation failures pass.

## Asset Policy

The no-CDN requirement is not too strong for the signed-off strict artifact.
The final accepted viewer must be reproducible offline from the experiment
directory, so strict mode must use `local` or `inline` assets and must not load
network fonts, CDN JavaScript, or remote stylesheets.

CDN-backed mode is still useful for a development/demo artifact when it keeps
the implementation close to the original demo or speeds iteration. It is
allowed only when explicitly requested:

```text
--asset-mode cdn --allow-cdn
```

Acceptance policy:

- strict hard-run validation must pass with `--asset-mode local` or
  `--asset-mode inline`;
- a CDN-only implementation cannot be signed off;
- a CDN demo screenshot may be produced as an auxiliary comparison artifact,
  but it does not replace the strict offline viewer;
- the validator must fail strict mode if `index.html` references `http://`,
  `https://`, network fonts, or CDN scripts.

## Exporter CLI

Required command:

```bash
/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root exp/journal_pareto_front_hard_subset/20260506_040658 \
  --backend_run classic=exp/journal_pareto_front_hard_subset/20260506_040658/classic \
  --backend_run grid_quantile_journal_bd=exp/journal_pareto_front_hard_subset/20260506_040658/grid_quantile_journal_bd \
  --backend_run grid_quantile_pareto_journal_bd=exp/journal_pareto_front_hard_subset/20260506_040658/grid_quantile_pareto_journal_bd \
  --archive_source_backend grid_quantile_pareto_journal_bd \
  --output-dir exp/journal_pareto_front_hard_subset/20260506_040658/visualization/qd_ppa_viewer
```

Useful options:

```text
--subset-config PATH
--problem BENCHMARK/PROBLEM
--archive_source_backend NAME
--asset-mode cdn|local|inline
--allow-cdn
--rank-scope per_technique|pooled_visible
--sample-universe all_ppa_valid|final_archive_members|viewer_pooled_pareto_members
--include_classic_projection
--technique NAME
--compare NAME_A=PATH NAME_B=PATH
--max-points-per-problem N
--strict
```

Use explicit names. Avoid ambiguous booleans such as `--visualize_classic`
when the actual behavior is posthoc projection into a selected archive.

## Required Outputs

For a run-level export:

```text
visualization/qd_ppa_viewer/index.html
visualization/qd_ppa_viewer/manifest.json
visualization/qd_ppa_viewer/datasets/<benchmark>__<problem>.json
visualization/qd_ppa_viewer/validation.json
visualization/qd_ppa_viewer/validation.md
```

Optional first-pass helper outputs:

```text
visualization/qd_ppa_viewer/screenshots/
visualization/qd_ppa_viewer/problem_index.csv
visualization/qd_ppa_viewer/export_summary.json
visualization/qd_ppa_viewer/viewer_frames/
visualization/qd_ppa_viewer/viewer_slides/
```

Do not write visualization outputs into individual problem run directories
unless explicitly regenerating the older Phase 02 grid-quantile viewer.

If frame export is implemented, use one frame per exported timeline step plus
one clean final frame. If slide export is implemented, include at least:

- first visible generation;
- first initialized archive state for QD techniques;
- mid-run state;
- final stable state;
- rank-0-only PPA view.

## Validation

Add:

```text
scripts/validate_qd_ppa_visualization.py
```

The validator must fail with nonzero exit status when a required invariant is
broken.

Required checks:

1. `manifest.json` exists and has schema `qd_ppa_viewer.v1`.
2. Every manifest problem has an existing dataset file.
3. Every dataset has schema `qd_ppa_problem.v1`.
4. Every selected problem from the subset config appears in the manifest.
5. Every dataset has at least one PPA-valid sample for each exported
   technique that solved that problem.
6. Every sample has required identity, technique, generation, status, and PPA
   fields.
7. Every accepted dataset sample is PPA-valid; failed-candidate overlays are
   not required and should not be counted in acceptance metrics.
8. Sequential datasets have active PPA metrics `area`, `power`, and
   `eff_clk_period`.
9. Combinational datasets have active PPA metrics `area` and `power`, and do
   not require `eff_clk_period` for Pareto ranking.
10. Pareto ranks are contiguous starting at `0` for every technique/step with
   visible samples.
11. Every rank-0 sample is nondominated by visible same-technique samples.
12. Pooled-visible rank 0 samples are nondominated by the pooled selected
    visible sample set.
13. Switching PPA coordinate mode does not change rank assignments for the same
    visible sample set.
14. Hypervolume is finite and nonnegative for every technique/step with
    visible rank-0 samples.
15. Pooled-visible hypervolume is finite and nonnegative in compare mode when
    the selected pooled front is nonempty.
16. Hypervolume metadata records method, reference point, and deterministic
    Monte Carlo seed/sample count when Monte Carlo is used.
17. Switching PPA coordinate mode does not change hypervolume values for the
    same visible sample set.
18. Archive source boundaries in each dataset match the source
    `archive_space.json` hash.
19. `grid`, `grid_quantile`, and initialized `cvt` projection rules match the
    source archive assignment semantics.
20. CVT datasets with three or fewer descriptor dimensions render true centroid
    coordinates rather than regular grid cells.
21. CVT datasets with more than three descriptor dimensions record projection
    method metadata and show a visible projection disclaimer.
22. QD native final archive cells in the dataset match source
    `archive_cells.csv`.
23. Timeline generation filtering for PPA points matches candidate generation
    values from `ppa_candidates.csv` or equivalent candidate records.
24. Final stable state agrees with final archive/global-Pareto artifacts.
25. Classic projected cells use the selected QD archive boundaries and are
    marked `projection_type: "posthoc"`.
26. At least 95 percent of PPA-valid classic samples are projected for
    initialized grid-quantile problems in the Phase 03 hard run.
27. Classic samples with missing descriptors remain in PPA/Pareto samples,
    are marked `archive_projection_status="missing_descriptors"`, and do not
    contribute to archive occupancy counts.
28. `index.html` references no `http://`, `https://`, CDN, or network font
    assets in strict mode unless `--allow-cdn` was explicitly passed.
29. The HTML contains the required controls: problem selector, technique
    selectors, single/compare mode, timeline slider, final snapshot button,
    raw/normalized/improvement toggle, rank-scope toggle, sample-universe
    toggle, rank filter, and hover-linking hooks.
30. The timeline sample universe defaults to `all_ppa_valid`.
31. Final archive membership and viewer-pooled Pareto membership are available
    as overlays or filters and are not the default sample universe.
32. `mode_global_pareto_member` is populated only from a run's own
    `global_pareto_archive.csv` and is visually distinct from
    `viewer_pooled_pareto_member`.
33. The PPA coordinate toggle defaults to `raw` and is ordered
    `raw`, `improvement`, `normalized`.
34. Source hashes or mtimes are recorded for the CSV/JSON artifacts used by
    the exporter.
35. Compare mode exposes archive perspective locking and keeps the PPA camera
    independent.
36. Viewer reset restores archive and PPA cameras and clears exploded-layer
    state without changing the selected problem or technique pair.
37. Archive layer panels remain visible in single and compare mode.
38. Quantile cutoffs and effective bin intervals are available through a
    collapsed-by-default archive axis/bin detail panel for grid-quantile
    datasets.
39. Per-technique stats and selected-technique delta stats are present for
    compare mode.
40. Compare-mode stats show both per-technique rank-0 count and pooled-visible
    rank-0 contribution count for each selected technique.
41. Compare-mode stats show per-technique hypervolume and pooled-visible
    hypervolume for the selected pair.
42. Sequential PPA panes expose browser debug metadata confirming a 3D scene,
    perspective camera, and nonzero z-coordinate range for visible samples.
43. Grid/grid-quantile archive panes with three active axes expose browser
    debug metadata confirming a 3D archive scene, perspective camera, and
    nonzero depth or layer range for rendered cells.
44. Exploded layers change actual archive-layer object positions by a nonzero
    amount in scene coordinates.
45. Auto-rotate changes the archive camera or root scene transform and produces
    a visually different screenshot after a deterministic short wait.
46. Perspective lock makes archive A and B camera state equal in compare mode
    and leaves the PPA camera state unchanged.
47. Archive-cell hover changes the highlighted archive cell id and highlights
    at least one matching PPA sample when that cell has projected samples.
48. PPA-point hover changes the highlighted sample id and highlights the
    projected archive cell when projection is available.
49. Layer mini-panel hover maps to the same archive cell id and sample ids as
    archive-scene hover.
50. Strict validation fails if the viewer falls back to a flat 2D canvas for a
    sequential PPA dataset or a 3D grid/grid-quantile archive dataset.
51. At `1440 x 1000`, the default header and toolbar occupy at most two compact
    rows and the main visual panes are visible without scrolling.
52. Advanced/configuration panels are closed by default and can be opened to
    inspect rank scope, sample universe, overlay source, hypervolume method,
    source hashes, axis cutoffs, projection diagnostics, and debug metadata.
53. Per-pane axis/bin details are summarized by default and full cutoffs or
    intervals are hidden until expansion.
54. The validator has a negative fixture or mode proving that the current flat
    2D canvas viewer fails required 3D checks before the V2 renderer is
    accepted.
55. The strict viewer becomes ready in Playwright within 10 seconds on the
    Phase 03 hard-run bundle and every required interaction test completes
    without uncaught browser errors.
56. The viewer emits no console errors during strict Playwright validation.
57. The default accepted artifact is offline reproducible: strict validation
    fails on any network request or remote asset reference.
58. A visual parity report is generated with side-by-side screenshots for the
    demo, `Prob135_m2014_q6b` existing 2D-projected grid-quantile baseline,
    `Prob151_review2015_fsm` existing full-3D grid-quantile baseline, and the
    new viewer states listed below.
59. The exported hard-run viewer includes `Prob151_review2015_fsm`, and browser
    debug metadata confirms a non-collapsed 3D archive scene with all three
    archive axes active, `effective_shape=[3,4,4]` or equivalent source-derived
    shape, and four visible z/layer slices.
60. The final Playwright validation covers the required validation example
    matrix: sequential 3D PPA, sequential full-3D archive, combinational 2D
    PPA, and combinational projected archive.

Use Playwright for viewer smoke tests when available. The first acceptance gate
requires at least one desktop screenshot for:

- single classic;
- single QD;
- classic versus QD compare;
- compare mode with locked archive perspective;
- combinational 2D PPA view;
- sequential 3D PPA view;
- rank-0-only filter.
- pooled-visible rank-scope mode.
- exploded archive layers.
- archive-cell hover linked to PPA samples.
- PPA-point hover linked to archive cell.
- default collapsed advanced/settings state.
- expanded advanced/settings state.
- baseline comparison: demo reference, existing `Prob135_m2014_q6b`
  grid-quantile viewer, existing `Prob151_review2015_fsm` full-3D
  grid-quantile viewer, and new linked viewer archive/PPA panes.
- `Prob151_review2015_fsm` full-3D archive view in the linked viewer.
- `RTLLM/Prob015_multi_pipe_8bit` or equivalent sequential 3D PPA view.
- `RTLLM/Prob004_adder_8bit` or equivalent combinational 2D PPA view.
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b` combinational projected archive
  view in the linked viewer.

Screenshots must be nonblank by pixel variance and must show the expected pane
count for the selected mode. Sequential 3D and 3D archive screenshots must also
show depth cues, perspective axis framing, and visible point or cell variation
along the third axis.

The validator must record the screenshot paths and the browser debug metadata
used to justify each screenshot. A screenshot without matching debug metadata
is not sufficient for sign-off.

## Tests

Focused unit tests:

- grid-quantile bin assignment matches `bisect_right` source behavior;
- fixed-grid bin assignment matches archive lower/upper bounds and interval
  inclusivity;
- CVT assignment uses frozen scaler parameters and nearest centroid;
- CVT <=3D renders true centroid coordinates;
- CVT >3D projection records method metadata and visible disclaimer text;
- uninitialized CVT/grid-quantile archive sources fail strict export clearly;
- classic projection uses QD archive boundaries, not classic-derived
  boundaries;
- boundary values map to the documented bin;
- PPA coordinate mode defaults to `raw` and exposes `raw`, `improvement`, and
  `normalized` in that order;
- timeline sample universe defaults to `all_ppa_valid`;
- final archive and viewer-pooled Pareto membership can be overlaid without
  changing the default timeline universe;
- mode-global Pareto membership from `global_pareto_archive.csv` is exposed as
  a separate badge when present;
- Pareto rank assignments are unchanged when switching display coordinate
  modes for the same visible samples;
- sequential active objectives are `g_P`, `g_A`, `g_T`;
- combinational active objectives are `g_P`, `g_A`;
- Pareto rank 0/1/2 computation on toy 2D and 3D samples;
- rank scope defaults to `per_technique`;
- pooled-visible rank scope computes a joint front across selected
  techniques;
- hypervolume is finite and monotonic on simple improving fronts;
- per-technique and pooled-visible hypervolume use fixed active objectives,
  independent of display coordinate mode;
- 2D hypervolume exact rectangle-union path is covered when implemented;
- 3D deterministic Monte Carlo records seed, sample count, method, and
  reference point when used;
- missing descriptors keep PPA samples visible but mark archive projection as
  unavailable;
- missing descriptor samples are excluded from archive occupancy and cell
  hover sets;
- descriptor values are never fabricated for projection;
- final stable snapshot includes final archive/global-Pareto markers.
- generation filtering uses candidate generation values and does not require
  exact archive event replay;
- final stable snapshot agrees with final archive/global-Pareto artifacts;
- reset behavior keeps selected problem/techniques while restoring cameras.
- perspective locking changes only archive cameras, not the PPA camera.
- layer-panel hover maps to the same samples as archive-cell hover.
- quantile boundary labels are exported from `archive_space.json` without
  recomputing boundaries.
- viewer debug state reports sequential PPA scenes as 3D with perspective
  camera metadata and nonzero z-coordinate range.
- viewer debug state reports 3D archive scenes with perspective camera
  metadata and nonzero cell depth or layer range.
- Playwright interaction tests prove auto-rotate, perspective lock, reset,
  exploded layers, archive-cell hover, layer-panel hover, and PPA-point hover
  change the expected scene or highlight state.
- the validator rejects the current flat 2D canvas placeholder for sequential
  PPA and 3D archive datasets.
- default UI density is covered by a Playwright screenshot and DOM assertions
  that advanced/settings panels are closed by default.
- expanded advanced/settings panels expose rank scope, sample universe,
  overlay source, hypervolume method, source hashes, axis cutoffs, projection
  diagnostics, and debug metadata.
- strict Playwright validation has a negative test that fails the old flat
  canvas implementation for sequential 3D PPA and 3D/layer-capable archive
  cases.
- console errors, unhandled promise rejections, failed asset loads, or network
  requests in strict mode fail validation.
- visual parity screenshots are generated for the demo, the existing
  `Prob135_m2014_q6b` grid-quantile viewer, the existing
  `Prob151_review2015_fsm` full-3D grid-quantile viewer, and the new linked
  viewer.
- `Prob151_review2015_fsm` is validated as a non-collapsed 3D archive case:
  all three archive axes are active, no source axis is collapsed, the linked
  viewer renders a real 3D archive scene, and the layer panel exposes four
  `ff_depth` slices.
- the required validation example matrix is present in the final report:
  sequential 3D PPA, sequential full-3D archive, combinational 2D PPA, and
  combinational projected archive. Each row includes a screenshot, browser
  debug metadata, selected problem key, circuit type, active PPA objectives,
  and selected techniques.

Script tests:

```bash
/workspace/.venv/bin/python -m pytest \
  tests/revolution/test_ppa_visualization_export.py \
  tests/revolution/test_ppa_visualization_metrics.py \
  tests/scripts/test_export_qd_ppa_visualization.py \
  tests/scripts/test_validate_qd_ppa_visualization.py \
  -q
```

Existing regression tests to keep green:

```bash
/workspace/.venv/bin/python -m pytest \
  tests/revolution/test_pareto_analysis.py \
  tests/scripts/test_backend_comparison_report.py \
  tests/scripts/test_validate_grid_quantile.py \
  tests/scripts/test_validate_grid_quantile_visualizations.py \
  -q
```

Lint/type checks on touched files:

```bash
/workspace/.venv/bin/ruff check \
  scripts/export_qd_ppa_visualization.py \
  scripts/validate_qd_ppa_visualization.py \
  src/revolution/qd/ppa_visualization_export.py \
  src/revolution/qd/ppa_visualization_metrics.py \
  src/revolution/qd/ppa_visualization_viewer.py \
  tests/revolution/test_ppa_visualization_export.py \
  tests/revolution/test_ppa_visualization_metrics.py \
  tests/scripts/test_export_qd_ppa_visualization.py \
  tests/scripts/test_validate_qd_ppa_visualization.py

/workspace/.venv/bin/python -m pyright \
  src/revolution/qd/ppa_visualization_export.py \
  src/revolution/qd/ppa_visualization_metrics.py \
  src/revolution/qd/ppa_visualization_viewer.py
```

If script-level Pyright has known import-environment noise, document it
explicitly and keep source modules clean.

## Acceptance Run

Use the already generated Phase 03 hard run:

```bash
RUN_ROOT=exp/journal_pareto_front_hard_subset/20260506_040658

/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root "${RUN_ROOT}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_journal_bd="${RUN_ROOT}/grid_quantile_journal_bd" \
  --backend_run grid_quantile_pareto_journal_bd="${RUN_ROOT}/grid_quantile_pareto_journal_bd" \
  --archive_source_backend grid_quantile_pareto_journal_bd \
  --subset-config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml \
  --output-dir "${RUN_ROOT}/visualization/qd_ppa_viewer" \
  --asset-mode local \
  --strict

/workspace/.venv/bin/python scripts/validate_qd_ppa_visualization.py \
  --viewer-root "${RUN_ROOT}/visualization/qd_ppa_viewer" \
  --subset-config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml \
  --strict
```

Acceptance criteria:

- exporter exits `0`;
- validator exits `0`;
- all 13 hard-subset problems appear in `manifest.json`;
- every problem has `classic`, `grid_quantile_journal_bd`, and
  `grid_quantile_pareto_journal_bd` samples when those modes solved the
  problem;
- accepted samples are PPA-valid only;
- at least one sequential problem renders a real 3D PPA view with area,
  effective clock period, and power on distinct axes;
- at least one combinational problem renders a 2D PPA view;
- at least one 3D or layer-capable archive view renders real 3D archive cells
  or layers rather than a screen-space 2D offset;
- `Prob151_review2015_fsm` renders as a non-collapsed 3D grid-quantile archive
  with all three journal BD axes active and four `ff_depth` slices;
- PPA coordinate mode defaults to `raw`, with `improvement` and `normalized`
  available in that order;
- timeline sample universe defaults to `all_ppa_valid`, with final archive and
  viewer-pooled Pareto membership available as overlays or filters;
- mode-global Pareto membership from `global_pareto_archive.csv` is shown as a
  separate badge when present;
- classic projection coverage is at least 95 percent for initialized
  grid-quantile problems;
- rank-0 highlighting exists for every technique with at least one visible
  PPA-valid sample;
- `per_technique` is the default rank scope and `pooled_visible` is available
  in the viewer;
- compare-mode stats show both per-technique rank-0 count and pooled-visible
  rank-0 contribution count for each selected technique;
- compare-mode stats show per-technique hypervolume and pooled-visible
  hypervolume for the selected pair;
- side-by-side archive/PPA hover linking works in a Playwright smoke;
- final accepted HTML has no network dependencies unless a separate
  non-strict CDN demo artifact is being inspected;
- compare-mode perspective lock synchronizes archive cameras only;
- reset clears camera/explode state but preserves selected problem and
  techniques;
- auto-rotate, exploded layers, archive-cell hover, layer-panel hover, and
  PPA-point hover are verified with Playwright against exported hard-run data;
- strict validation fails when scene/debug metadata says a required 3D pane is
  rendered by the flat 2D fallback;
- strict validation includes a negative check demonstrating that the old flat
  canvas implementation fails the required 3D scene and interaction gates;
- default UI shows the main visualization panes without scrolling at
  `1440 x 1000`, with advanced/configuration details collapsed;
- quantile cutoffs and effective bin intervals are available through expanded
  grid-quantile archive details;
- a visual parity report exists under the viewer output directory and includes
  the demo screenshot, the existing `Prob135_m2014_q6b` grid-quantile
  screenshot, the existing `Prob151_review2015_fsm` full-3D grid-quantile
  screenshot, and the new linked viewer screenshots;
- the final report includes the required validation example matrix with
  sequential 3D PPA, sequential full-3D archive, combinational 2D PPA, and
  combinational projected archive rows;
- strict validation records zero browser console errors, failed asset loads,
  unhandled promise rejections, or network requests;
- strict validation uses local or inline assets. CDN mode may be generated only
  as an auxiliary non-strict demo artifact;
- docs and user guide mention how to export, validate, and open the viewer.

## Non-Grid-Quantile Smoke

`grid` and `cvt` support must be validated at smoke scale, not with the full
13-problem hard run. Use at most four simultaneous workers.

Smoke requirements:

- run a small `grid` QD mode and a small `cvt` QD mode on two or three
  hard-subset problems;
- use `journal_logic_ff_width_3d`;
- use two generations or fewer unless debugging requires more;
- include a matching classic run or reuse a compatible classic run for
  projection;
- export viewer datasets with `--archive_source_backend` set to the `grid`
  run and then the `cvt` run;
- validate both viewer bundles in strict mode;
- require at least one projected classic sample and one native QD sample in
  each smoke viewer dataset.

Suggested smoke shape:

```bash
SMOKE_ROOT=exp/journal_pareto_visualization_geometry_smoke

# Generate or select small classic, grid, and cvt runs under SMOKE_ROOT.
# Keep total worker slots, active problems, and workers per problem <= 4.

/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root "${SMOKE_ROOT}" \
  --backend_run classic="${SMOKE_ROOT}/classic" \
  --backend_run grid_journal_bd="${SMOKE_ROOT}/grid_journal_bd" \
  --archive_source_backend grid_journal_bd \
  --output-dir "${SMOKE_ROOT}/visualization/grid_viewer" \
  --strict

/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root "${SMOKE_ROOT}" \
  --backend_run classic="${SMOKE_ROOT}/classic" \
  --backend_run cvt_journal_bd="${SMOKE_ROOT}/cvt_journal_bd" \
  --archive_source_backend cvt_journal_bd \
  --output-dir "${SMOKE_ROOT}/visualization/cvt_viewer" \
  --strict
```

The full pass gate remains the existing Phase 03 grid-quantile hard-run data.
The `grid` and `cvt` smoke gates prove the abstraction is not hard-coded to
grid-quantile.

## Documentation Updates

Update:

```text
docs/journal_features/03_1_pareto_visualization.md
docs/qd_map_elites_guide.md
docs/module_structure.md
docs/user_guide.md
```

Document:

- the exporter command;
- the validator command;
- the output directory layout;
- the meaning of classic posthoc archive projection;
- the difference between local Phase 03 archive rank and viewer PPA Pareto
  rank;
- raw PPA versus reference-improvement coordinates;
- sequential 3D versus combinational 2D behavior.

## Implementation Record

As of the Phase 03.1 viewer implementation commit, the accepted hard-run bundle
is:

```text
exp/journal_pareto_front_hard_subset/20260506_040658/visualization/qd_ppa_viewer
```

Strict validation uses the offline/local viewer artifact and Playwright:

```bash
RUN_ROOT=exp/journal_pareto_front_hard_subset/20260506_040658

/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root "${RUN_ROOT}" \
  --backend_run classic="${RUN_ROOT}/classic" \
  --backend_run grid_quantile_journal_bd="${RUN_ROOT}/grid_quantile_journal_bd" \
  --backend_run grid_quantile_pareto_journal_bd="${RUN_ROOT}/grid_quantile_pareto_journal_bd" \
  --archive_source_backend grid_quantile_pareto_journal_bd \
  --subset-config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml \
  --output-dir "${RUN_ROOT}/visualization/qd_ppa_viewer" \
  --asset-mode local \
  --strict

/workspace/.venv/bin/python scripts/validate_qd_ppa_visualization.py \
  --viewer-root "${RUN_ROOT}/visualization/qd_ppa_viewer" \
  --subset-config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml \
  --strict \
  --playwright
```

The strict validator now requires `window.__QD_PPA_VIEWER_DEBUG__`, scene
dimensionality metadata, camera state, linked hover hooks, and viewport
screenshots. It also includes a negative flat-viewer regression test: a
2D-only `getContext('2d')` HTML page without the scene/debug contract fails
strict validation.

The current hard-run validation artifacts are:

```text
validation.json
validation.md
visual_parity_report.md
screenshots/
```

`visual_parity_report.md` must include the demo reference screenshot, the
existing `Prob135_m2014_q6b` and `Prob151_review2015_fsm` grid-quantile
baseline screenshots, and the required linked-viewer matrix screenshots:
sequential 3D PPA, sequential full-3D archive, combinational 2D PPA, and
combinational projected archive.

## Completion Checklist

The earlier flat implementation attempt should be considered an exporter and
data schema scaffold, not an accepted viewer implementation. A Phase 03.1
viewer is not accepted unless strict Playwright validation rejects that flat
2D-only contract and passes the real scene/debug checks above.

- [ ] 3.1.1 Define exporter data schema and metric helpers.
- [ ] 3.1.2 Export real per-problem datasets from final-analysis and run
  artifacts.
- [ ] 3.1.3 Project classic candidates into selected `grid_quantile`, `grid`,
  and initialized `cvt` archive sources.
- [ ] 3.1.4 Compute PPA Pareto ranks and hypervolume per technique and step.
- [ ] 3.1.5 Build HTML viewer with single/compare modes, real 3D scene
  rendering, and explicit `cdn`/`local`/`inline` asset modes.
- [ ] 3.1.6 Add linked archive-cell, layer-panel, and PPA-point hover behavior.
- [ ] 3.1.7 Add raw/improvement/normalized coordinate toggle, rank-scope
  toggle, sample-universe toggle, final-membership overlays, and rank filters.
- [ ] 3.1.8 Add perspective lock, auto-rotate, reset, exploded layers, layer
  mini-panels, scatter legends, real 3D PPA/archive rendering, and compare
  delta stats.
- [ ] 3.1.9 Add validation script and Playwright smoke checks that reject flat
  2D placeholders for required 3D views.
- [ ] 3.1.10 Export and validate the Phase 03 hard-run viewer.
- [ ] 3.1.11 Run and validate small `grid` and `cvt` geometry smokes.
- [ ] 3.1.12 Update docs, docstrings, and user-facing guide entries.

## Implementation Rules

Follow the same engineering constraints as Phase 03:

1. Keep code simple and skimmable.
2. Use required typed fields in exporter data models.
3. Use discriminated unions for view modes and archive source types.
4. Fail on unknown technique, archive type, circuit type, or metric mode.
5. Use asserts for required loaded data.
6. Do not make required values optional.
7. Keep argument counts low.
8. Avoid broad defensive fallbacks.
9. Keep helper count modest.
10. Do not add unrelated visualization rewrites.

## Commit Guidance

Use atomic signed commits:

```bash
git commit -s
```

Good possible commits:

```text
docs(qd): Plan linked PPA visualization
feat(qd): Export PPA visualization data
feat(qd): Add linked archive viewer
test(qd): Validate PPA visualization export
docs(qd): Document PPA visualization workflow
```

After each commit, check:

```bash
git log --format=%B -n 1 HEAD
git show --pretty=fuller --no-patch HEAD
git log --format=%B -n 1 HEAD | rg '\\n' && echo "BAD: raw newline text found"
git log --format=%B -n 1 HEAD | rg -c '^Signed-off-by:'
```

There should be no raw `\n` text and exactly one `Signed-off-by:` footer.
