# T40 Results Report

Status: complete live control matrix.

Tier decision: `T0 mixed_control_no_promotion`.

T40 is the same-budget control matrix for the T39 sparse-warmup one-slot arm.
It keeps T39's subset, seed, model, budget, warmup threshold, parent schedule,
and operator settings fixed while adding classic, manual-BD, random, and full
local-Pareto controls. The frozen T39 arm is included as a reference, not
rerun.

Run root:
`exp/useful_bd_push/t40_sparse_warmup_control_matrix_20260622_070540_UTC/`

Frozen T39 reference:
`exp/useful_bd_push/t39_sparse_yield_warmup_qd_20260622_062937_UTC/`

## Terminology

- Valid PPA candidate: a generated candidate with passing functionality,
  synthesis, and recorded area/power/timing metrics.
- Best score: the REvolution scalar normalized PPA improvement score. It is
  useful quality evidence, but it is not the primary QD/front metric.
- Method front: nondominated candidates within one method and problem using
  raw area and raw power, where lower area and lower power are better.
- Pooled front: nondominated candidates across all compared methods for the
  same problem using raw area and raw power.

## Direct PPA Figure

The first report figure is the direct raw area-power PPA Pareto comparison:

- `figures/t40_raw_area_power_fronts.png`
- `visualizations/direct_ppa_pareto/index.html`

The plot uses raw area on x, raw power on y, no inverted axes, and explicit
lower-left-is-better labeling. Open circles mark each method's raw
area-power front. Black stars mark the pooled front across methods.

## Validation

All QD controls passed archive validation with zero failures:

| Arm | Valid | Failures | Max front size |
| --- | --- | ---: | ---: |
| Manual BD | `True` | 0 | 5 |
| Random one-slot | `True` | 0 | 2 |
| Graph full Pareto | `True` | 0 | 5 |

Classic has no QD archive validator because it has no archive.

## Result Summary

| Method | ALU best | Traffic best | Multi-pipe best |
| --- | ---: | ---: | ---: |
| Classic | 0.414136 | 0.420875 | 0.052795 |
| Manual BD | 0.405439 | 0.399899 | 0.071689 |
| Random one-slot | 0.402234 | 0.398741 | 0.027172 |
| Graph full Pareto | 0.402716 | 0.403063 | 0.052795 |
| T39 one-slot | 0.402072 | 0.403821 | 0.222285 |

Best-score deltas versus classic:

| Method | ALU | Traffic | Multi-pipe |
| --- | ---: | ---: | ---: |
| Manual BD | -2.10% | -4.98% | +35.79% |
| Random one-slot | -2.87% | -5.26% | -48.53% |
| Graph full Pareto | -2.76% | -4.23% | +0.00% |
| T39 one-slot | -2.91% | -4.05% | +321.04% |

Pooled raw area-power front hits:

| Method | ALU | Traffic | Multi-pipe |
| --- | ---: | ---: | ---: |
| Classic | 3 | 3 | 0 |
| Manual BD | 0 | 1 | 1 |
| Random one-slot | 0 | 0 | 0 |
| Graph full Pareto | 0 | 0 | 0 |
| T39 one-slot | 0 | 0 | 2 |

Valid PPA candidate counts:

| Method | ALU | Traffic | Multi-pipe |
| --- | ---: | ---: | ---: |
| Classic | 36 | 21 | 12 |
| Manual BD | 28 | 18 | 17 |
| Random one-slot | 14 | 11 | 16 |
| Graph full Pareto | 20 | 13 | 11 |
| T39 one-slot | 18 | 15 | 11 |

## Interpretation

T39 remains a real multi-pipe signal: it has the best multi-pipe score by a
large margin and contributes two pooled raw area-power front points. Manual BD
also contributes one multi-pipe pooled front point and one traffic-light pooled
front point.

That is not enough for a useful-QD promotion. Classic owns all three ALU
pooled front points, three traffic-light pooled front points, and the best
score on ALU and traffic-light. The full local-Pareto graph control matches
classic on multi-pipe best score but does not add pooled raw-front material.
The random one-slot control produces valid candidates but no pooled front
hits.

Conclusion: sparse warmup fixed the T38 archive-activation gap, but the T39
one-slot policy is not a general same-budget improvement. The next method
should not simply widen the local-Pareto lane. It should be per-design or
adaptive: keep classic/champion pressure on easier ALU and traffic-light
cases, and use the sparse-yield one-slot policy only where the archive would
otherwise fail to activate or where hard multi-pipe front recovery is the
explicit objective.

## Artifacts

- `tables/t40_problem_method_summary.csv`
- `tables/t40_candidate_ppa_points.csv`
- `tables/t40_method_manifest.csv`
- `tables/manual_sparse_pareto_qd_validation.md`
- `tables/random_sparse_elite_slot_qd_validation.md`
- `tables/graph_full_pareto_sparse_qd_validation.md`
- `figures/t40_raw_area_power_fronts.png`
- `figures/t40_front_count_summary.png`
- `visualizations/direct_ppa_pareto/index.html`
- `visualizations/direct_ppa_pareto/screenshot.png`
