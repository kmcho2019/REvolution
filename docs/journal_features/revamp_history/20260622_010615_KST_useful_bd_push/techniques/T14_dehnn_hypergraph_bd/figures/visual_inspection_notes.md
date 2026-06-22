# Visual Inspection Notes

Date: 2026-06-22 UTC.

Inspected with local image viewer.

## `hypergraph_multi_problem_ppa_pareto_fronts.png`

Pass. The figure uses conventional raw area and power axes, lower-left-better
annotations, all-valid fronts, and clear lexical/random/hypergraph-hybrid
overlays. It shows the main blocker: the hybrid often adds points but does
not visibly dominate lexical on the all-valid front.

## `hypergraph_raw_area_power_pareto_front.png`

Pass. The full-range and lower-left zoom panels are readable. On
`Prob018_float_multi`, the hypergraph-hybrid front differs from lexical but
does not recover the lower-power lexical/random point.

## `dehnn_hypervolume.png`

Pass. The bar chart clearly shows the hypergraph plus implementation hybrid
above lexical and the hypergraph-only variants below lexical.

## `hypergraph_projection.png`

Pass with caveat. The projection is readable and shows corpus structure, but it
is descriptor-space evidence only. PPA conclusions should come from the direct
front figures and replay tables.

## `fanout_entropy_vs_hypervolume.png`

Pass. The plot is readable and shows that high fanout entropy is not by itself
a reliable predictor of selected hypervolume.
