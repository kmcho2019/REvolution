# Visualization And Reporting Policy

Every technique must produce figures and reports that make the finding easy to
understand without reading raw CSV files. A result is not complete until the
images and conclusion have been inspected for clarity.

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

When applicable, live runs should also include:

- hypervolume versus valid-PPA evaluations;
- QD score versus valid-PPA evaluations;
- coverage versus valid-PPA evaluations;
- archive heatmap or CVT projection at the final budget.
- a local `visualizations/qd_ppa_viewer/index.html` bundle, generated with the
  Phase 03.1 viewer when the run artifacts can be adapted to that schema.

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

The direct raw PPA figure should be the first PPA/front figure linked from the
technique `figures/README.md` and the first figure discussed in
`results_report.md`. The committed tables must include enough candidate-level
raw area, power, problem, method, and rank-1-front columns to regenerate the
figure without rerunning the LLM.

The HTML viewer should use the existing `scripts/export_qd_ppa_visualization.py`
schema when possible. If a scoped live-run adapter is needed, keep the adapter
data under the technique directory or `exp/`, never under `/aux`. Record
whether Classic is honestly projectable into the selected archive coordinates;
if it is not, keep Classic in the PPA/Pareto pane and document why the archive
pane is empty.

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
