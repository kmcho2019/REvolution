# T79 Visual Inspection Notes

## `t79_budget_subset_selection.png`

The figure is readable at desktop resolution. It plots prior classic valid-PPA
count against prior PPA variance, labels the eight frozen primary designs, and
shows deferred candidates in gray. The figure is a subset-selection visual, not
a performance result.

## `final_analysis/summary_mean_hypervolume.png`

The figure is readable and presentation-suitable. It uses short labels, grouped
Classic/QD bars, and direct QD-minus-classic HV annotations. It clearly shows
that QD loses matched classic at `12x3`, `8x5`, and `6x7`.

## `final_analysis/summary_yield_and_score.png`

The figure is readable and presentation-suitable. It shows the important
contrast that QD only improves synthesis yield at `12x3`, while classic leads
mean best score at every tested shape.

## `final_analysis/summary_archive_coverage_vs_hv_delta.png`

The figure is readable and presentation-suitable. It directly communicates that
larger QD archive coverage did not become positive mean-HV delta in T79.

## `final_analysis/pareto_fronts/*.png`

The copied per-problem Pareto figures are useful diagnostics, but several are
not presentation-ready because the legend can overlap the title or crowd the
top margin. Keep them in the package as raw visual evidence; use the compact
summary figures for slides unless the per-problem layout is regenerated.

## `visualizations/qd_ppa_viewer/{12x3,8x5,6x7}/screenshot.png`

The Phase 03.1 viewer renders nonblank compare-mode screenshots with archive
panes, PPA/Pareto panes, timeline controls, and compare controls visible.
Strict schema validation passed for all three shapes. Strict Playwright
interaction validation reported warnings because the validator expects the
built-in `RTLLM/Prob004_adder_8bit` problem and several hover checks assume
denser archive cells than this T79 subset provides.

## `visualizations/direct_ppa_pareto/index.html`

The static direct PPA/Pareto supplement is readable and points to the clean
aggregate summary figures plus raw per-problem Pareto diagnostics. It is a
reader-facing supplement, not a substitute for the Phase 03.1 viewer.
