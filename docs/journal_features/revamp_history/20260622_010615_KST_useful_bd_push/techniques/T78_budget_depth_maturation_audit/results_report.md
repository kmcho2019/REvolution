# T78 Results Report

## Tier Decision

`T0_budget_hypothesis_support_not_live_ablation`.

T78 supports the hypothesis that `12 x 3` may be too shallow for QD archive
maturation. It does not promote a QD technique and does not change any
headline classic-vs-QD claim.

## Key Results

| Metric | Value |
| --- | ---: |
| Problems audited | `13` |
| Archives active in generation `2` or later | `9/13` |
| Active-late fraction | `0.6923` |
| Mean occupied cells, gen `0` to gen `3` | `1.54` to `5.15` |
| Mean archive members, gen `0` to gen `3` | `1.62` to `6.23` |
| Mean coverage, gen `0` to gen `3` | `0.0794` to `0.2265` |
| Front-slot requests, gen `1` to gen `3` | `17` to `77` |
| Front-slot hits, gen `1` to gen `3` | `1` to `18` |

The archived T75 run is still filling cells and replacing archive members late
in the run. That is the expected signature of a mechanism that may need more
depth before the archive can convert diversity into PPA-front material.

## Caveats

The audit is not enough to conclude that deeper QD wins. It only uses existing
`12 x 3` logs and does not compare equal-candidate shapes.

`Prob151_review2015_fsm` is an explicit weak case: the final T75 archive is
empty for that problem in this audit. Any budget-shape run must retain
per-problem reporting so this kind of failure cannot be hidden by aggregate
curves.

Classic still remains a strong small-budget hill climber. T75's final
generation-level best-score and synthesis means exceed classic in this
evolutionary report, but the already packaged Pareto analysis still says
classic wins mean HV, Pareto breadth, and reference-beating count. T78 does
not override that.

## Roadmap Decision

Run the fixed-total-budget ablation before making a budget-shape claim:

| Shape | Candidate Budget | Role |
| --- | ---: | --- |
| `12 x 3` | `48` | current baseline |
| `8 x 5` | `48` | balanced depth |
| `6 x 7` | `48` | deeper archive test |
| `4 x 11` | `48` | deep control |
| `16 x 2` | `48` | wide control |

The decision question is whether deeper budgets help QD more than classic
under the same candidate budget. The design subset should be frozen before
outcomes are read, reference-complete, and selected for medium validity plus
PPA-front variance.
