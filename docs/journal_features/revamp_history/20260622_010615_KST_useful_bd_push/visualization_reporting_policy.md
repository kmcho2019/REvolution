# Visualization And Reporting Policy

Every technique must produce figures and reports that make the finding easy to
understand without reading raw CSV files. A result is not complete until the
images and conclusion have been inspected for clarity.

## Figure Requirements

Each completed technique should include:

- validity funnel plot;
- PPA/front comparison against classic and landing Smooth-QD;
- passive archive coverage or quality plot;
- duplicate/canonical-netlist accounting plot;
- method-specific diagnostic plot;
- one compact summary figure that supports the tier decision.

When applicable, live runs should also include:

- hypervolume versus valid-PPA evaluations;
- QD score versus valid-PPA evaluations;
- coverage versus valid-PPA evaluations;
- archive heatmap or CVT projection at the final budget.

## Visual Quality Checklist

Inspect generated PNGs with `view_image` or an equivalent local image viewer
before a technique is marked complete. Check:

- the figure has a direct title that states the comparison;
- axes are labeled with units or normalized metric definitions;
- classic, landing Smooth-QD, and the new method are visually distinguishable;
- colors are readable and not a single-hue blur;
- legends do not cover data;
- labels do not overlap or clip on normal desktop display;
- fonts are large enough to read in a manuscript draft;
- important deltas are annotated or visible without guessing;
- empty archives, invalid funnels, and duplicate collapse are shown honestly;
- the raw table path needed to regenerate the figure is named in the report.

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
