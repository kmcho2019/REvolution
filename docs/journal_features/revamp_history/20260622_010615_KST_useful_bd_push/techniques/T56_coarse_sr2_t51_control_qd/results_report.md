# T56 Coarse SR2 T51-Control QD Result Report

Status: `T0 diagnostic_retire_coarse_sr2_geometry`.

## Question

T56 tested whether T55's coarse two-axis SR-PCA archive geometry was useful on
its own. The method kept T51 fixed except for `--qd_descriptor_axes sr_pca_0
sr_pca_1`; it removed T55's fixed front-slot parent lane and kept normal
`nsga2_global_rank` parent selection.

## Primary Result

| Metric | Classic | T56 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.092601 | 0.082056 | -0.010545 |
| Mean HV-AUC | 0.082020 | 0.069095 | -0.012925 |
| Mean best score | 0.227928 | 0.268625 | 0.040697 |
| Valid PPA | 257 | 231 | -26 |
| PPA front points | 30 | 22 | -8 |
| Unique PPA points | 87 | 66 | -21 |
| Reference-beating candidates | 46 | 35 | -11 |

T56 preserved every classic-covered valid-PPA design, so it is not a design
coverage failure. It still records four denominator-gated yield warnings and
loses the main QD evidence: mean HV, HV-AUC, valid-PPA count, front points,
unique PPA points, and reference-beating candidates.

## Family Comparison

| Comparison | HV Delta | HV-AUC Delta | Best Delta | Valid PPA Delta | Front Delta |
| --- | ---: | ---: | ---: | ---: | ---: |
| T56 - classic | -0.010545 | -0.012925 | 0.040697 | -26 | -8 |
| T56 - T51 | -0.007196 | -0.016359 | -0.024855 | -35 | 1 |
| T56 - T52 | -0.001446 | 0.013303 | 0.026364 | -23 | -2 |
| T56 - T53 | -0.003737 | -0.001916 | -0.021810 | -8 | 0 |
| T56 - T54 | 0.006164 | 0.006342 | 0.005598 | -22 | 1 |
| T56 - T55 | -0.004133 | -0.003212 | 0.004557 | -2 | -1 |

The direct isolation answer is negative. Coarse SR2 geometry improves over T54
only because T54 was the weakest parent-lane configuration in this local
lineage. It does not improve T51 and does not preserve T55's small slot/front
mechanism gain strongly enough to justify another coarse-geometry run.

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

Strict Phase 03.1 schema validation passes. The optional Playwright smoke
produces screenshots but reports compare and hover warnings, so the viewer is
accepted with the documented caveat.

## Conclusion

T56 retires coarse SR2 archive geometry as a primary live path. The current
T51 through T56 sequence has now tested code-individual recovery, one local
front slot, full local-Pareto retention, sparse front triggers, fixed front
parent lanes, coarser slot geometry, and geometry isolation. None produces a
promotable same-budget QD result against classic.

The next method should change mechanism rather than keep tuning this geometry:
exact T11 runtime projection, learned auxiliary archive lanes, or a new
front-yield protected emitter are better candidates than T56 seed `1002`.
