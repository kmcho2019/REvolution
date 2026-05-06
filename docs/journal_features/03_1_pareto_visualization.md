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

## Non-Goals

Do not rerun LLM experiments for this phase.

Do not change archive insertion, QD parent selection, Pareto replacement,
descriptor extraction semantics, or scoring semantics.

Do not make classic evolution use MAP-Elites during optimization. Classic
archive views are posthoc projections into a QD archive coordinate system.

Do not add a server requirement. The primary artifact is static HTML plus JSON
that can be opened from the filesystem or served by any static file server.

Do not require CVT support in the first accepted implementation. The first
target is `grid_quantile` because it is the journal hard-run geometry and has
frozen quantile boundaries.

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
  "archive_source_backend": "grid_quantile_journal_bd",
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
global_pareto_member
local_archive_member
local_cell_pareto_rank
quality_score
```

Use `null` only for values that are truly absent, such as
`eff_clk_period` for combinational problems. Required structural fields such as
`sample_id`, `technique`, `generation`, and `status` must not be optional.

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

Rank numbering:

```text
rank 0 = nondominated front
rank 1 = next front after removing rank 0
rank 2 = next front after removing rank 0 and rank 1
```

Compute ranks:

- per technique;
- per generation step;
- for the selected visible sample set;
- and for the final stable snapshot.

Do not confuse these viewer ranks with Phase 03 local archive
`pareto_rank`, which is one-based inside a single archive cell.

## Classic Projection Into Archive Space

Classic runs do not have a native QD archive. For visualization, project
classic samples into a fixed archive defined by a selected QD backend.

Default archive source:

```text
--archive_source_backend grid_quantile_journal_bd
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
`journal_logic_ff_width_3d` and `grid_quantile` archives.

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

The validation target is that at least 95 percent of PPA-valid classic samples
in the Phase 03 hard run can be projected for problems whose QD archive source
has initialized grid-quantile boundaries.

## Viewer Requirements

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

- render grid cells from `archive_definition`;
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

Journal BD axis layout:

```text
world_x = logic_depth
world_y = comb_width_log
world_z = ff_depth
```

This keeps `ff_depth` vertical in the archive view. In PPA space,
effective clock period is vertical.

### PPA / Pareto View

The PPA view must support:

- raw PPA coordinates;
- normalized PPA values;
- reference-improvement coordinates;
- rank filters: all, rank 0 only, rank <= 1, rank <= 2;
- technique filters;
- final stable snapshot;
- generation timeline playback;
- reference design marker;
- rank 0 front highlighting per technique;
- optional rank 1, rank 2, ... front highlighting.

For sequential problems, use a proper 3D scene. For combinational problems,
use a 2D scatter view by default.

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

### Timeline

The viewer must expose:

- generation slider;
- play/pause;
- previous/next generation;
- jump to final stable snapshot;
- playback speed control.

The final stable snapshot is distinct from the last generation step and should
prefer final archive/global-Pareto membership when available.

For QD techniques, archive occupancy over time should come from
`archive_history.jsonl` and candidate archive events. For classic, build a
posthoc projected occupancy timeline from candidate generation numbers.

## Exporter CLI

Required command:

```bash
/workspace/.venv/bin/python scripts/export_qd_ppa_visualization.py \
  --run-root exp/journal_pareto_front_hard_subset/20260506_040658 \
  --backend_run classic=exp/journal_pareto_front_hard_subset/20260506_040658/classic \
  --backend_run grid_quantile_journal_bd=exp/journal_pareto_front_hard_subset/20260506_040658/grid_quantile_journal_bd \
  --backend_run grid_quantile_pareto_journal_bd=exp/journal_pareto_front_hard_subset/20260506_040658/grid_quantile_pareto_journal_bd \
  --archive_source_backend grid_quantile_journal_bd \
  --output-dir exp/journal_pareto_front_hard_subset/20260506_040658/visualization/qd_ppa_viewer
```

Useful options:

```text
--subset-config PATH
--problem BENCHMARK/PROBLEM
--archive_source_backend NAME
--asset-mode cdn|local|inline
--allow-cdn
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
```

Do not write visualization outputs into individual problem run directories
unless explicitly regenerating the older Phase 02 grid-quantile viewer.

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
7. Sequential datasets have active PPA metrics `area`, `power`, and
   `eff_clk_period`.
8. Combinational datasets have active PPA metrics `area` and `power`, and do
   not require `eff_clk_period` for Pareto ranking.
9. Pareto ranks are contiguous starting at `0` for every technique/step with
   visible samples.
10. Every rank-0 sample is nondominated by visible same-technique samples.
11. Hypervolume is finite and nonnegative for every technique/step with
    visible rank-0 samples.
12. Archive source boundaries in each dataset match the source
    `archive_space.json` hash.
13. QD native final archive cells in the dataset match source
    `archive_cells.csv`.
14. Classic projected cells use the selected QD archive boundaries and are
    marked `projection_type: "posthoc"`.
15. At least 95 percent of PPA-valid classic samples are projected for
    initialized grid-quantile problems in the Phase 03 hard run.
16. `index.html` references no `http://`, `https://`, CDN, or network font
    assets in strict mode unless `--allow-cdn` was explicitly passed.
17. The HTML contains the required controls: problem selector, technique
    selectors, single/compare mode, timeline slider, final snapshot button,
    raw/normalized/improvement toggle, rank filter, and hover-linking hooks.
18. Source hashes or mtimes are recorded for the CSV/JSON artifacts used by
    the exporter.

Use Playwright for viewer smoke tests when available. The first acceptance gate
requires at least one desktop screenshot for:

- single classic;
- single QD;
- classic versus QD compare;
- combinational 2D PPA view;
- sequential 3D PPA view;
- rank-0-only filter.

Screenshots must be nonblank by pixel variance and must show the expected pane
count for the selected mode.

## Tests

Focused unit tests:

- grid-quantile bin assignment matches `bisect_right` source behavior;
- classic projection uses QD archive boundaries, not classic-derived
  boundaries;
- boundary values map to the documented bin;
- sequential active objectives are `g_P`, `g_A`, `g_T`;
- combinational active objectives are `g_P`, `g_A`;
- Pareto rank 0/1/2 computation on toy 2D and 3D samples;
- hypervolume is finite and monotonic on simple improving fronts;
- missing descriptors keep PPA samples visible but mark archive projection as
  unavailable;
- final stable snapshot includes final archive/global-Pareto markers.

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
  --archive_source_backend grid_quantile_journal_bd \
  --subset-config exp/journal_pareto_front_configs/hard_subset_pareto_front.yaml \
  --output-dir "${RUN_ROOT}/visualization/qd_ppa_viewer" \
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
- at least one sequential problem renders a 3D PPA view;
- at least one combinational problem renders a 2D PPA view;
- classic projection coverage is at least 95 percent for initialized
  grid-quantile problems;
- rank-0 highlighting exists for every technique with at least one visible
  PPA-valid sample;
- side-by-side archive/PPA hover linking works in a Playwright smoke;
- final accepted HTML has no network dependencies unless a separate
  non-strict CDN demo artifact is being inspected;
- docs and user guide mention how to export, validate, and open the viewer.

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

## Completion Checklist

- [ ] 3.1.1 Define exporter data schema and metric helpers.
- [ ] 3.1.2 Export real per-problem datasets from final-analysis and run
  artifacts.
- [ ] 3.1.3 Project classic candidates into the selected QD grid-quantile
  archive.
- [ ] 3.1.4 Compute PPA Pareto ranks and hypervolume per technique and step.
- [ ] 3.1.5 Build HTML viewer with single/compare modes and explicit
  `cdn`/`local`/`inline` asset modes.
- [ ] 3.1.6 Add linked archive-cell and PPA-point hover behavior.
- [ ] 3.1.7 Add raw/normalized/improvement coordinate toggle and rank filters.
- [ ] 3.1.8 Add validation script and Playwright smoke checks.
- [ ] 3.1.9 Export and validate the Phase 03 hard-run viewer.
- [ ] 3.1.10 Update docs, docstrings, and user-facing guide entries.

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
