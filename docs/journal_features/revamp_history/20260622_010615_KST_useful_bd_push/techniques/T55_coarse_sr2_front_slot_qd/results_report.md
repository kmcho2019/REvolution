# T55 Coarse SR2 Front-Slot QD Result Report

Status: `T0 positive_mechanism_ablation_not_promoted`.

## Question

T55 tested whether T54 failed because the three-axis SR-PCA grid was too
sparse for `elite_pareto_slot` to create useful non-elite local-front slots.
The method kept T54 fixed except for the descriptor axes: it used
`--qd_descriptor_axes sr_pca_0 sr_pca_1`, producing a coarser two-axis
grid-quantile archive.

## Primary Result

| Metric | Classic | T55 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.092601 | 0.086189 | -0.006412 |
| Mean HV-AUC | 0.082020 | 0.072307 | -0.009713 |
| Mean best score | 0.227928 | 0.264068 | 0.036140 |
| Valid PPA | 257 | 233 | -24 |
| PPA front points | 30 | 23 | -7 |
| Unique PPA points | 87 | 72 | -15 |
| Reference-beating candidates | 46 | 36 | -10 |

T55 preserved every classic-covered valid-PPA design and recorded no 50 percent
yield warning under the current denominator gate. It is therefore not a
coverage failure.

The method still does not advance as a useful-QD candidate. It improves best
score and improves the front-slot mechanism relative to T54, but classic still
wins mean HV, HV-AUC, valid-PPA count, front points, unique PPA points, and
reference-beating candidates.

## Family Comparison

| Comparison | HV Delta | HV-AUC Delta | Best Delta | Valid PPA Delta | Front Delta |
| --- | ---: | ---: | ---: | ---: | ---: |
| T55 - classic | -0.006412 | -0.009713 | 0.036140 | -24 | -7 |
| T55 - T51 | -0.003063 | -0.013147 | -0.029412 | -33 | 2 |
| T55 - T52 | 0.002687 | 0.016515 | 0.021807 | -21 | -1 |
| T55 - T53 | 0.000396 | 0.001296 | -0.026367 | -6 | 1 |
| T55 - T54 | 0.010297 | 0.009554 | 0.001041 | -20 | 2 |

T55 is a positive mechanism ablation because it improves T54's slot activity
and recovers some HV/front material: front-slot hits rise from `4` to `9`,
front points rise from `21` to `23`, and yield warnings fall from `2` to `0`.
That is not enough to beat T51's stronger valid-PPA and HV-AUC behavior or
classic's broader PPA front.

## Visual Artifacts

- Direct PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- Direct PPA screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`.
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Phase 03.1 screenshot:
  `visualizations/qd_ppa_viewer/screenshot.png`.
- Phase 03.1 caveat:
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.

Strict Phase 03.1 schema validation passes. The viewer generator was patched
to display two-axis archive geometry by padding only the rendering shape and
cell IDs; the exported datasets still report the honest two-axis archive
(`sr_pca_0`, `sr_pca_1`). The optional Playwright smoke produced screenshots
but still fails deeper compare/hover assertions, so the viewer is accepted
with that caveat.

## Conclusion

Coarsening the SR-PCA archive helps the specific T54 slot-creation mechanism,
but it does not create a promotable QD result. The immediate T51 through T55
lineage has now tested one-slot retention, full local Pareto retention,
sparse-front trigger pressure, fixed front-slot parent pressure, and coarser
cell geometry. None beats classic on the primary front/HV evidence.

The next method should not be another small T51-family parent-pressure tweak.
Use T55 as evidence that slot creation can be improved, then move to a clearer
mechanism change: a T51-control geometry ablation, exact T11 runtime
projection, or a learned/auxiliary archive lane with explicit front-yield
protection.
