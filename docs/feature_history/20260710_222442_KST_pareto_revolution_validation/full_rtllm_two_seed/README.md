# Full RTLLM Two-Seed Closure

Status: frozen promotion gate failed on 2026-07-13 UTC. This is a negative
closure for descriptor-free global NSGA-II selection as the journal extension.

## Decision

The treatment passes only one of three required promotion conditions:

| Gate | Classic | Pareto | Result |
| --- | ---: | ---: | --- |
| Mean final HV46 | 0.104745 | 0.103991 | FAIL |
| Valid-PPA units / 92 | 65 | 65 | PASS |
| Functional-any-pass units / 92 | 75 | 74 | FAIL |

The final-HV gap is small (`-0.000755`, `99.280%` retention), but the rule is
explicit parity or better. HV-AUC cannot rescue final HV and also loses on
both seeds. Seeds 1003-1005, follow-up knobs, and treatment variants are not
authorized.

## Aggregate Metrics

| Metric | Classic | Pareto | Delta |
| --- | ---: | ---: | ---: |
| Mean final HV46 | 0.104745 | 0.103991 | -0.000755 |
| Mean HV-AUC46 | 0.090500 | 0.083317 | -0.007184 |
| Valid-PPA units / 92 | 65 | 65 | 0 |
| Valid-PPA samples | 2017 | 1978 | -39 |
| Functional-any-pass units / 92 | 75 | 74 | -1 |
| Functional-any-pass units / 100 | 83 | 82 | -1 |
| Reference-beating units / 92 | 51 | 53 | +2 |
| Positive-HV units / 92 | 42 | 44 | +2 |
| Mean Pareto points46 | 1.489130 | 1.586957 | +0.097826 |
| Mean score improvement46 | 27.770% | 24.881% | -2.889 pp |
| Evaluated candidates | 4800 | 4800 | 0 |
| LLM calls | 9602 | 9600 | -2 |
| Total tokens | 29723705 | 29812243 | +0.298% |
| Runtime | 9326.00 s | 9363.95 s | +0.407% |

Pareto retains more front material and slightly broadens weak reference-
beating and positive-HV coverage. It does not convert that diversity into
better final mean HV, trajectory quality, scalar score, candidate yield, or
functionality coverage.

## Seed Sensitivity

| Seed | Classic HV | Pareto HV | HV delta | Classic AUC | Pareto AUC | AUC delta |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1001 | 0.101013 | 0.098859 | -0.002154 | 0.085385 | 0.081920 | -0.003465 |
| 1002 | 0.108477 | 0.109122 | +0.000645 | 0.095615 | 0.084713 | -0.010903 |

The final-HV direction flips between seeds. Per-problem HV deltas have near-
zero cross-seed correlation: Spearman `rho=-0.130` (`p=0.390`) and Pearson
`r=0.029` (`p=0.850`). This is not a stable task-level mechanism win.

## Paired Analysis

- Across 92 design-seed units: 16 Pareto wins, 19 classic wins, and 57 ties.
- Across 46 two-seed problem means: 9 Pareto wins, 12 classic wins, and 25
  ties; exact sign-test `p=0.664`.
- Problem-cluster bootstrap mean-HV-delta 95% interval:
  `[-0.009652, +0.009801]` from 20,000 fixed-seed resamples.
- Wilcoxon signed-rank on problem means: statistic `325.0`, `p=0.526`.
- Paired t-test on problem means: `t=-0.150`, `p=0.882`.
- Valid-PPA discordance is one classic-only and one Pareto-only unit. Functional
  discordance is two classic-only and one Pareto-only unit.

These tests do not support an improvement claim. Two seeds are insufficient
for seed-level inference; the task-level tests are development diagnostics,
not paper-facing evidence.

## Mechanism Conclusion

Global Pareto rank/crowding is a clean and natural ablation, but replacing both
classic successful-parent and successful-survivor selection does not reliably
improve classic REvolution. The treatment broadens some delivered fronts while
reducing anytime HV, successful-candidate yield, and average scalar quality.
It is therefore not the primary TCAD extension candidate.

This closure does not show that all Pareto reporting or QD concepts are
useless. It shows that this exact descriptor-free selection replacement is not
a sufficient holistic improvement under the fixed `8 x 5` RTLLM budget.

## Artifacts

- Seed 1001 compact package: `../full_rtllm_seed1001/`
- Seed 1002 compact package: `../full_rtllm_seed1002/`
- Aggregate metrics: `aggregate_metrics.csv`
- Full per-problem map: `per_problem_hv.csv`
- Raw reports:
  `exp/pareto_revolution_validation/packages/full_rtllm_seed_1001/` and
  `exp/pareto_revolution_validation/packages/full_rtllm_seed_1002/`
