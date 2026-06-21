# T27 T26 Live QD Audit Results Report

Status: completed live audit package.

## Summary

T27 audits the completed T26 conservative-exploit SR raw run against the T24
and T25 live controls. The audit supports keeping T26 as the current live lead:
T26 beats classic on mean live PPA hypervolume, hypervolume AUC, and best
score, and it strongly beats the random descriptor control. The result is still
not a final useful-BD claim because T26 loses front-point count versus classic
and SR raw, and the live logs do not prove canonical implementation-family
novelty.

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

- `tables/live_qd_problem_metrics.csv`
- `tables/live_qd_aggregate_metrics.csv`
- `tables/live_qd_comparison_deltas.csv`

Primary figures:

- `figures/live_qd_problem_metrics.png`
- `figures/live_qd_aggregate_metrics.png`

## Aggregate Results

| Method | Mean HV | HV AUC | Best | Valid PPA | PPA-front points | Unique PPA points | Active Pareto members |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 0.160241 | 0.122837 | 0.341634 | 66 | 18 | 53 | n/a |
| Manual BD | 0.181459 | 0.153877 | 0.297425 | 63 | 9 | 56 | 9 |
| Random | 0.112776 | 0.077037 | 0.277994 | 37 | 7 | 31 | 7 |
| SR raw | 0.147152 | 0.127593 | 0.295832 | 49 | 16 | 44 | 16 |
| Guarded SR raw | 0.141203 | 0.119673 | 0.285091 | 41 | 10 | 37 | 10 |
| Conservative exploit | 0.178862 | 0.144485 | 0.351947 | 57 | 9 | 53 | 9 |

## Key Deltas

Against classic, T26 improves mean live hypervolume by 11.62%, hypervolume AUC
by 17.62%, and mean best score by 3.02%. It loses 9 valid-PPA samples
(-13.64%), loses 9 PPA-front points (-50.00%), ties unique PPA points, and
increases mean front nearest-neighbor spread by 29.23%.

Against random descriptor QD, T26 improves mean hypervolume by 58.60%,
hypervolume AUC by 87.55%, mean best score by 26.60%, valid-PPA count by
54.05%, PPA-front points by 28.57%, unique PPA points by 70.97%, and active
global Pareto members by 28.57%.

Against SR raw, T26 improves mean hypervolume by 21.55%, hypervolume AUC by
13.24%, mean best score by 18.97%, valid-PPA count by 16.33%, and unique PPA
points by 20.45%. The tradeoff is front material: T26 has 9 active global
Pareto members versus SR raw's 16, and 9 PPA-front points versus SR raw's 16.

Against manual BD, T26 is close on final mean hypervolume (-1.43%) but trails
HV AUC (-6.10%). It improves mean best score by 18.33%, ties active Pareto
members and PPA-front points, and loses 3 unique PPA points.

## Interpretation

T27 changes the T26 read from "best-score-only active lead" to a broader live
audit lead. T26 no longer looks like a narrow scalar-quality recovery: it also
beats classic on live HV and HV-AUC, and it beats random on every audited
aggregate metric.

The audit also shows why a promotion claim would be premature. Classic and SR
raw retain more PPA-front points, and SR raw retains more active global Pareto
members. That means the conservative exploit policy recovers quality and
hypervolume, but it may be collapsing some front material that the pure SR raw
archive found.

## Tier Decision

T27 supports T26 as a `T1 near_classic validation_candidate` for the next
confirmation step, not as a final positive claim. The evidence is strong enough
to continue the SR raw conservative-exploit lane because T26 beats classic on
mean live HV, HV-AUC, and best score while preserving all classic-covered
designs from the T26 live result.

It is not `T2 useful_qd` yet because the audit does not provide canonical
duplicate accounting, common passive archive scoring, holdout behavior, or
multi-seed confidence.

## Next Experiment

The next package should be a holdout and canonical-family audit before another
descriptor reset. Required checks:

- canonical netlist or motif-family duplicate accounting;
- common passive descriptor archive over the same candidate pool;
- holdout screen using the frozen holdout subset;
- comparison against classic, manual BD, random, SR raw, and T26;
- explicit decision on whether to branch to repair emitters.
