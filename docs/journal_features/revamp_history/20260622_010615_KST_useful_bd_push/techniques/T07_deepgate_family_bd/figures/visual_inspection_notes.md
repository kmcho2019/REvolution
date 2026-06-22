# Visual Inspection Notes

Date: 2026-06-22 UTC.

Inspected with local image viewer.

## `deepgate_multi_problem_ppa_pareto_fronts.png`

Pass. The figure uses conventional raw area and power axes, labels
lower-left-better direction, overlays all-valid fronts, and separates lexical,
random, and graph-combo selections with readable colors. This is the primary
visual evidence for T07. It shows that graph-combo sometimes tracks the
all-valid front, but does not visually dominate lexical across the panels.

## `deepgate_raw_area_power_pareto_front.png`

Pass. The one-problem full-range and lower-left zoom panels are readable and
make the `Prob018_float_multi` tradeoff visible. It should be read as a focused
zoom, not as the whole T07 front claim.

## `deepgate_surrogate_hypervolume.png`

Pass. The bar chart makes the small graph WL/combo HV edge over lexical easy
to read. It should not be used without the raw PPA-front plots because the
front-hit result is weaker.

## `deepgate_projection.png`

Pass with caveat. The PCA projection is readable and shows corpus/problem
structure and outliers. It is useful for diagnosing descriptor structure, not
for making the PPA claim.

## `graph_size_vs_embedding.png`

Pass with caveat. The scatter is legible and shows that high selected HV is
not simply monotonic in parsed graph size. It is a diagnostic plot only.
