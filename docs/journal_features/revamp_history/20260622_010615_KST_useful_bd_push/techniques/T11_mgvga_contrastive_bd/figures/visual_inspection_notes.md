# Visual Inspection Notes

Date: 2026-06-22 UTC.

Inspected with local image viewer.

## `mgvga_multi_problem_ppa_pareto_fronts.png`

Pass. The figure uses conventional raw area and power axes, lower-left-better
annotations, all-valid fronts, and clear lexical/random/contrastive overlays.
It shows the remaining blocker: T11 adds useful spread in some panels but does
not visibly dominate lexical on all-valid front hits.

## `mgvga_raw_area_power_pareto_front.png`

Pass. The full-range and lower-left zoom panels are readable. On
`Prob018_float_multi`, the contrastive weighted selection keeps a broad
tradeoff but misses the lower-power lexical/random point.

## `visualizations/direct_ppa_pareto/index.html`

Pass. Playwright rendered the filesystem-openable viewer and saved
`visualizations/direct_ppa_pareto/screenshot.png`. The default view is a
straight raw area-power Pareto projection with conventional axes, a
lower-left-is-better annotation, visible nondominated outlines, and correct
summary cards (`120` T11 front hits versus `122` lexical front hits).

## `mgvga_contrastive_hypervolume.png`

Pass. The bar chart clearly shows top-64 and weighted contrastive descriptors
above lexical and top-16 below lexical.

## `contrastive_feature_scores.png`

Pass. The figure is readable and shows that high-scoring features are mostly
graph and hypergraph size/fanout features. This supports the caveat that the
HV gain may still be tied to structural scale axes.

## `aligned_embedding_projection.png`

Pass with caveat. The projection is readable and shows corpus structure. Use it
as descriptor-structure evidence only; PPA claims come from direct front
figures and replay tables.

## `source_graph_agreement.png`

Pass. The plot is readable and shows a broad RTL/graph norm relationship,
useful as a sanity check for the paired-view construction.
