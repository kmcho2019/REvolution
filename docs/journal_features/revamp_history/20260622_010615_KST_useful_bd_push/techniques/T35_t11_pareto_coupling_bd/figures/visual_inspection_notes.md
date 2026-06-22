# Visual Inspection Notes

Date: 2026-06-22 UTC.

Inspected with local image viewer and Playwright.

## `t35_multi_problem_ppa_pareto_fronts.png`

Pass with caveat. The figure uses conventional raw area and power axes,
lower-left-better annotations, all-valid front outlines, and visible
lexical/T11/T35 overlays. Several T35 arms overlap exactly in the selected
points, so the legend is dense, but the front geometry is understandable.

## `t35_raw_area_power_pareto_front.png`

Pass. The full-range and zoom panels are readable. On `Prob018_float_multi`,
the front-seeded arm visibly recovers the lower-left front segment, while the
T11 top-64 arm keeps a broader but less front-preserving tradeoff.

## `t35_hypervolume.png`

Pass. The bar chart clearly shows the front-seeded upper bound above lexical
and the cell-local Pareto variants below lexical.

## `t35_front_hits.png`

Pass. The bar chart makes the central tradeoff visible: cell-local Pareto
variants beat lexical on front hits, but the hypervolume figure blocks
promotion.

## `visualizations/direct_ppa_pareto/index.html`

Pass. Playwright rendered the filesystem-openable viewer and saved
`visualizations/direct_ppa_pareto/screenshot.png`. The summary cards show the
front-seeded upper bound (`132` hits) versus lexical (`122` hits), and the SVG
is nonblank with conventional raw area-power axes.
