# Visualization And Reporting Policy

Every technique must produce figures and reports that make the finding easy to
understand without reading raw CSV files. A result is not complete until the
images and conclusion have been inspected for clarity.

For live QD techniques, the concrete Phase 03.1 file contract lives in
`phase_03_1_visualization_contract.md`. This policy explains what to inspect
and report; the contract defines the mandatory viewer layout and commands.

## Figure Requirements

Each completed technique should include:

- validity funnel plot;
- direct raw PPA Pareto-front PNGs against classic and landing Smooth-QD,
  with area on x, power on y, conventional non-inverted axes, and lower-left
  marked as better;
- PPA/front comparison tables against classic and landing Smooth-QD;
- passive archive coverage or quality plot;
- duplicate/canonical-netlist accounting plot;
- method-specific diagnostic plot;
- one compact summary figure that supports the tier decision.

Live QD runs with archive artifacts must also include:

- hypervolume versus valid-PPA evaluations;
- QD score versus valid-PPA evaluations;
- coverage versus valid-PPA evaluations;
- archive heatmap or CVT projection at the final budget.
- a full Phase 03.1-compatible
  `visualizations/qd_ppa_viewer/` bundle:
  `index.html`, `manifest.json`, `datasets/*.json`, `validation.json`,
  `screenshot.png`, and `README.md`.
- a reader-facing `visualizations/direct_ppa_pareto/` bundle:
  `index.html`, `metrics.json`, `screenshot.png`, and `README.md`.

`visualizations/qd_ppa_viewer/` is the linked archive/PPA viewer from
`scripts/export_qd_ppa_visualization.py` and
`src/revolution/qd/ppa_visualization_viewer.py`. It supports the timeline,
compare mode, archive projection, raw/improvement/normalized coordinate modes,
native and raw-area-power PPA panes, 2D/3D-style rendering, validation hooks,
and schema files. The simpler `direct_ppa_pareto/index.html` wrapper is useful
for paper-readable raw PPA-front inspection, but it is not the Phase 03.1
viewer and must not be described as such.

The direct raw PPA Pareto-front PNG is a required primary figure, not an
optional diagnostic. Aggregate HV, mean best score, family-count bars,
BD/archive heatmaps, HTML viewers, and normalized improvement plots do not
substitute for this figure because they can hide the actual Pareto shape. At
minimum, include a straightforward raw area-power projection with conventional
axes, no inversion, and lower-left marked as better. If the reference design
stretches the scale, also include a candidate-only zoom on the same
conventional axes. A normalized improvement projection may be added where
higher is better on both axes. For sequential designs, explicitly note when
clock period is an active third objective and point readers to the HTML viewer
for the 3D PPA view.

For replay diagnostics that cover many problem groups, include more than a
single focus problem. The package should provide either a multi-problem raw
PPA-front panel or a clearly documented representative-set front figure, plus
the raw point table used to draw it. A one-problem zoom is a supporting figure,
not the only direct PPA-front evidence.

The direct raw PPA figure should be the first PPA/front figure linked from the
technique `figures/README.md` and the first figure discussed in
`results_report.md`. The committed tables must include enough candidate-level
raw area, power, problem, method, and rank-1-front columns to regenerate the
figure without rerunning the LLM.

Export every full viewer with `scripts/export_qd_ppa_visualization.py` after
generating the canonical source CSVs. Required inputs are:

- `final_analysis/ppa_distribution/data/ppa_candidates.csv`;
- `final_analysis/ppa_distribution/data/reference_ppa_metrics.csv`;
- `final_analysis/design_space_analysis/successful_candidates.csv` when
  classic candidates need descriptor recovery;
- the classic backend run directory;
- the QD backend run directory;
- QD archive artifacts such as `archive_space.json`, `archive_cells.csv`, and
  preferably `archive_history.jsonl`;
- descriptor values, or code paths sufficient to recover descriptor values and
  project classic candidates into the QD archive posthoc.

Use `classic` as the viewer technique key for the baseline while documenting
the source backend path, so the Phase 03.1 compare/validation conventions stay
consistent. A standard export should look like:

```bash
uv run python scripts/export_qd_ppa_visualization.py \
  --run-root docs/.../techniques/T##_slug/visualizations/qd_ppa_viewer_source \
  --backend_run classic=exp/.../classic_revolution/seed_1001 \
  --backend_run METHOD=exp/.../METHOD/seed_1001 \
  --archive_source_backend METHOD \
  --subset-config docs/.../techniques/T##_slug/tables/live_screen_v0_subset.yaml \
  --output-dir docs/.../techniques/T##_slug/visualizations/qd_ppa_viewer \
  --strict
```

Then validate it:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/.../techniques/T##_slug/visualizations/qd_ppa_viewer \
  --subset-config docs/.../techniques/T##_slug/tables/live_screen_v0_subset.yaml \
  --strict
```

Run the same validator with `--playwright` before marking a live QD package
complete when Playwright is available, then keep a compact
`visualizations/qd_ppa_viewer/screenshot.png` in the package. The optional
Playwright screenshot matrix can be regenerated locally and does not need to
be committed for every technique.

Record whether classic candidates are honestly projectable into the selected
archive coordinates. If projection fails, keep classic in the PPA/Pareto pane
and document why the archive pane is empty. Replay-only or archive-missing
techniques may omit the full viewer only with a documented reason in
`results_report.md` and `artifacts_manifest.md`. Every generated viewer must
expose a raw area-power front mode with conventional axes, lower-left-better
annotation, and per-technique nondominated front outlines. The native 3D PPA
view remains necessary for sequential timing, but it does not replace the raw
area-power projection.

## Visual Quality Checklist

Inspect generated PNGs with `view_image` or an equivalent local image viewer
before a technique is marked complete. Check:

- the figure has a direct title that states the comparison;
- axes are labeled with units or normalized metric definitions;
- PPA-front markers are visually distinct from non-front candidates;
- the direction of improvement is explicit on raw and normalized plots;
- classic, landing Smooth-QD, and the new method are visually distinguishable;
- colors are readable and not a single-hue blur;
- legends do not cover data;
- labels do not overlap or clip on normal desktop display;
- fonts are large enough to read in a manuscript draft;
- important deltas are annotated or visible without guessing;
- empty archives, invalid funnels, and duplicate collapse are shown honestly;
- the raw table path needed to regenerate the figure is named in the report.
- HTML screenshots are inspected when a viewer bundle is generated, and any
  Playwright caveat is recorded rather than silently ignored.

Reject or regenerate figures that are technically present but visually
confusing.

## Report Requirements

Each `results_report.md` must include:

- one-paragraph method summary;
- exact experimental setup and replay/live source;
- descriptor inputs and leakage exclusions;
- baseline comparators;
- tables and figure links;
- primary metric deltas;
- validity and duplicate accounting;
- conclusion with `T0`, `T1`, `T2`, or `T3` tier;
- why the conclusion follows from the evidence;
- limitations and next experiment.

Use precise terminology from `metrics_and_acceptance.md`. Avoid vague phrases
like "better diversity" without naming the metric.

## Central Report Requirements

The central comparison report must include:

- a glossary of terms;
- method leaderboard by primary QD/PPA metrics;
- per-problem table so aggregate wins cannot hide failures;
- subset selection evidence;
- representative figures for global PPA fronts and passive archive coverage;
- a concise answer to whether QD/MAP-Elites is useful, near-classic, or still
  only diagnostic;
- a clear next-step recommendation.

The conclusion should separate what was answered, what remains unanswered, and
which result is strong enough for a TCAD-style methodology or claims section.
