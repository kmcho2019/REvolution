# Executive Summary

## Decision In One Paragraph

The natural-QD push did not deliver the intended main TCAD result. It did
establish that QD is meaningful: Smooth-QD V2 wins on the small screen,
global NSGA-II selection has a demonstrated benefit on the earlier
13-problem tuning ablation, and S07 improves
full-suite search trajectory and coverage. Yet no operator-fair QD variant
beats classic on five-seed full-suite final HV, descriptor health does not
track PPA quality, and capacity4 fails the direct S07 interpolation test.
The strongest next step is to remove the descriptor grid while retaining the
demonstrated Pareto mechanism. The higher-upside follow-up is to apply that
method to verified RTL seeds so large designs start inside the feasible
region.

## Conference Baseline And Journal Need

The ASP-DAC paper contributes a Thought/Code/Feedback individual, a
dual-population evolutionary loop, six prompt operators, adaptive UCB-style
operator selection, and a scalar weighted PPA fitness. The journal effort was
motivated by five weaknesses:

1. weighted PPA scalarization hides Pareto tradeoffs;
2. the operator set appears hand chosen;
3. the operator-selection bandit lacks a clean ablation;
4. the evidence is concentrated on small single-module benchmarks; and
5. the search has no explicit design-space diversity mechanism.

## Best Full-Suite Results

Full RTLLM, 46 reference-complete designs, 8x5 budget, seeds 1001-1005:

| Arm | Mean HV | HV-AUC46 | Coverage | Honest status |
| --- | ---: | ---: | ---: | --- |
| classic REvolution | 0.103802 | 0.086982 | 164/230 | Baseline to beat |
| Smooth-QD V2 | 0.098801 | 0.087428 | 166/230 | AUC/coverage positive, final-HV negative |
| N03b front-slot | 0.100587 | 0.089186 | 163/230 | Best earlier AUC, lower coverage |
| S03 slot-2 retention | 0.100278 | 0.085114 | 163/230 | V2 HV recovery only |
| S07 capacity3 | 0.102481 | 0.088031 | 165/230 | Strongest QD near miss |

S07 is 1.3% below classic final HV, 1.2% above classic HV-AUC46, and one
problem-seed ahead on coverage. Its five seed-paired final-HV delta is
`-0.001322`; three seeds lose and two win. This is useful evidence, but not a
robust headline performance improvement.

## What The Campaign Actually Established

- Operator fairness matters. Earlier single-thought QD negatives were not
  valid evidence against QD; corrected EoH-operator runs recovered much of
  the gap.
- Global NSGA-II parent selection is the one QD-side mechanism with a clean
  demonstrated benefit over its direct predecessor on the earlier
  13-problem tuning ablation. Its component effect has not been isolated on
  full RTLLM.
- Behavioral descriptors affect archive health and functionality more than
  final PPA HV. Better collapse statistics can coincide with much worse HV.
- Compact per-cell retention can improve anytime trajectory and coverage,
  but capacity is not monotonic and does not recover final-HV dominance.
- Small-screen rankings transfer weakly to full RTLLM. Future method triage
  should use the screen only for runtime and extraction debugging.
- At large RealBench scale, from-scratch generation is capability-bound. The
  evaluator and PPA flow work, but the model does not produce valid large
  modules from prose.

## Recommended Direction

Primary immediate candidate:

> Pareto REvolution keeps the conference dual populations, EoH operators,
> feedback, and direct-code refinement, but replaces scalar success-pool
> survivor and parent selection with global NSGA-II rank and crowding. A
> separate external Pareto archive records the engineer-facing deliverable.

Strategic scale candidate:

> Seeded Pareto optimization starts from a verified RTL implementation and
> evolves interface-preserving patches under functional or formal checks.
> This moves large designs from an infeasible generation problem into the
> PPA optimization regime REvolution was designed to address.

QD/MAP-Elites remains valuable as supporting characterization and as an
optional deliverable analysis, not as the active primary search pressure.
