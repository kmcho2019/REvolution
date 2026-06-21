# T28 T26 Family Audit Results Report

Status: completed canonical/family audit package.

## Summary

T28 shows that T26's valid-PPA candidates are mostly distinct implementation
families, so the T26 HV/HV-AUC signal is not an obvious duplicate artifact.
However, T28 also confirms the T27 caveat: T26 has fewer unique front families
than classic and SR raw. This supports continuing T26 as a narrow
best-quality/HV lead, but it blocks any broad `T2 useful_qd` claim until
holdout behavior or a front-recovery variant improves the family-front result.

## Compared Methods

| Method | Source |
| --- | --- |
| Classic REvolution | T24 live matrix |
| Landing Smooth-QD manual BD | T24 live matrix |
| Random descriptor QD | T24 live matrix |
| SR raw PCA QD | T24 live matrix |
| Guarded SR raw Pareto QD | T25 live result |
| Conservative exploit SR raw QD | T26 live result |

Primary tables:

- `tables/family_candidate_rows.csv`
- `tables/family_problem_metrics.csv`
- `tables/family_aggregate_metrics.csv`
- `tables/family_comparison_deltas.csv`

Primary figures:

- `figures/family_aggregate_counts.png`
- `figures/family_problem_front_counts.png`
- `figures/ppa_pareto_fronts_area_power.png`
- `figures/ppa_pareto_fronts_improvement.png`

Interactive visualization:

- `visualizations/qd_ppa_viewer/index.html`
- `visualizations/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/`

## Aggregate Results

| Method | Valid PPA | Front candidates | Unique families | Front families | Front netlists | Ref-beating families | Valid family ratio | Front family ratio |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 66 | 24 | 55 | 19 | 21 | 36 | 0.833333 | 0.791667 |
| Manual BD | 63 | 12 | 56 | 9 | 11 | 39 | 0.888889 | 0.750000 |
| Random | 37 | 7 | 32 | 7 | 7 | 17 | 0.864865 | 1.000000 |
| SR raw | 49 | 16 | 44 | 16 | 16 | 23 | 0.897959 | 1.000000 |
| Guarded SR raw | 41 | 10 | 37 | 10 | 10 | 23 | 0.902439 | 1.000000 |
| Conservative exploit | 57 | 10 | 52 | 9 | 9 | 37 | 0.912281 | 0.900000 |

## Key Deltas

Against classic, T26 has fewer total unique families (-3, -5.45%), fewer
front families (-10, -52.63%), and fewer front netlists (-12, -57.14%).
It has one more reference-beating family (+2.78%) and a higher valid-family
ratio (+9.47% relative).

Against random descriptor QD, T26 has more total unique families (+20,
+62.50%), more front families (+2, +28.57%), more front netlists (+2,
+28.57%), and more reference-beating families (+20, +117.65%).

Against SR raw, T26 has more valid unique families (+8, +18.18%) and more
reference-beating families (+14, +60.87%), but fewer front families (-7,
-43.75%) and fewer front netlists (-7, -43.75%).

Against manual BD, T26 ties front families at 9 but has fewer front netlists
(9 versus 11). T26 keeps a higher front-family ratio, but the absolute front
family count is not better.

## Interpretation

T28 resolves one concern and sharpens another. It resolves the concern that
T26's live HV/HV-AUC improvement is only duplicate code: T26 has the best
valid-family ratio among the compared methods and only 5 family duplicates
among 57 valid-PPA candidates. It also has 37 reference-beating families, one
more than classic and fourteen more than SR raw.

The blocker is front-family coverage. T26 has 9 front families, compared with
classic's 19 and SR raw's 16. That means the conservative-exploit schedule is
not merely losing PPA-front points because of duplicate accounting; it is
really putting fewer distinct implementation families on the front.

The new direct PPA-front figures make the same point visually. T26 pushes
strong points into the ALU and multi-pipe PPA front, but the multi-pipe plot
also shows fewer distinct rank-1 front markers than classic and SR raw. The
HTML viewer adds a per-problem raw/improvement/normalized PPA view and a
native T26 SR-PCA archive view. Classic is intentionally shown in PPA space
only, because the SR-PCA archive coordinates are native to T26 and are not an
honest post-hoc descriptor basis for classic candidates.

## Tier Decision

T28 keeps T26 at `T1 near_classic validation_candidate`. It strengthens the
case that T26 is worth validating because the valid candidates are not mostly
duplicates. It does not support `T2 useful_qd` because the family-front deficit
is real and large.

## Next Experiment

The next package should be a holdout or front-recovery validation. Two paths
are justified:

- `T29_t26_holdout_audit`: rerun or audit T26 on the holdout subset with the
  same family metrics, then decide whether the HV/HV-AUC signal survives.
- `T29_sr_raw_exploit_front_recovery`: keep the T26 champion lane but add a
  fixed SR-raw exploration quota or repair emitter to recover front families.

Do not restart with unrelated descriptors until the T26 holdout/front-recovery
question is answered.
