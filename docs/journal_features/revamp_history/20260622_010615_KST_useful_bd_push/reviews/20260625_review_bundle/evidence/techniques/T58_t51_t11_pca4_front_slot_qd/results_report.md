# T58 T51 T11-PCA4 Front-Slot QD Result Report

Status: `T0 diagnostic_no_promotion`.

T58 ran the full 13-problem hard/tuning surface at seed `1001`. It preserves
classic-covered valid-PPA coverage and improves aggregate valid-PPA count and
best score, but it loses the QD-facing PPA-front metrics versus classic and
T51. Do not spend seed `1002` on exact T58.

## Headline Metrics

| Metric | Classic | T58 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.092601 | 0.076253 | -0.016348 |
| Mean HV-AUC | 0.082020 | 0.066233 | -0.015787 |
| Mean best score | 0.227928 | 0.249751 | +0.021823 |
| Valid PPA samples | 257 | 266 | +9 |
| PPA-front points | 30 | 22 | -8 |
| Unique PPA points | 87 | 71 | -16 |
| Reference-beating candidates | 46 | 34 | -12 |

T58 passes the relaxed coverage gate: every design where classic produced at
least one valid functional PPA result also has a T58 valid PPA result. The gate
table marks `Prob151_review2015_fsm` as `small_n`, not as a failure, because
classic has only two valid PPA samples.

## Family Comparison

The 13-problem family table is
`hard_tuning_package/tables/t58_family_comparison_13_problem_subset.csv`.

| Comparison | HV | HV-AUC | Best | Valid PPA | Front | Unique PPA | Ref-beating | Archive members |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| T58 - classic | -0.016348 | -0.015787 | +0.021823 | +9 | -8 | -16 | -12 | +70 |
| T58 - T51 | -0.012999 | -0.019221 | -0.043729 | 0 | +1 | -4 | -9 | +3 |
| T58 - T57 | +0.000442 | -0.004188 | -0.011977 | +21 | -1 | -4 | -5 | -1 |

The learned T11-PCA4 archive geometry did not rescue the T51 front-breadth
blocker. It improves over T57 mainly by restoring valid-yield, not by creating
better PPA fronts. It also loses T51's HV-AUC and best-score recovery.

The pre-registered gate nominally allowed "two of six" T51 improvements,
including front points and active archive members. T58 technically has `+1`
front point and `+3` active archive members versus T51, but those are not
promotion evidence. The front-point gain is one sample on a 13-problem screen,
while the archive-member count compares different archive geometries
(`sr_pca_3d` for T51 versus four-dimensional `t11_runtime_pca4_graph` for
T58). The geometry-independent signals, HV, HV-AUC, best score, unique PPA
points, and reference-beating candidates, all regress versus T51.

T46 was a three-problem live screen, so it is not a direct 13-problem
comparator. On the shared `Prob015`, `Prob041`, and `Prob045` RTLLM problems,
T58 has more valid PPA samples than T46 PCA4 (`44` versus `37`) and higher
mean best score (`0.297560` versus `0.276800`), but fewer area-power/front
points (`5` versus `6`) and far fewer than classic on the matched T58 surface
(`12`). The T51 emitter improves the graph-projection yield story, not the
front-breadth story.

## Visualizations

- Direct PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- Direct PPA screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`.
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Full viewer screenshot:
  `visualizations/qd_ppa_viewer/screenshot.png`.
- Strict viewer validation:
  `visualizations/qd_ppa_viewer/validation.md`.
- Playwright caveat:
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.

Manual screenshot inspection found both HTML bundles readable and nonblank. The
direct supplement makes the negative HV/HV-AUC/front signal clear. The full
viewer renders the classic and T58 archive panes plus the PPA/Pareto pane;
Playwright caveats are limited to automated rank-guide interaction checks.

## Conclusion

T58 answers a narrow mechanism question: frozen T11 PCA4 graph coordinates do
not become a useful primary archive geometry merely because the stronger T51
code-individual front-slot emitter is used. The graph projection can coexist
with T51's yield path, but it does not broaden the PPA Pareto front enough to
support the QD/MAP-Elites claim.

Retire exact T58 as a promotion path. The next push should stop primary
graph-coordinate archive tests unless the graph signal is moved into a
secondary/archive-reporting lane or a trained encoder objective. For live
optimization, prioritize a front-yield protected emitter that keeps T51's
valid-yield behavior while explicitly improving front creation.
