# T85 Results Report

Status: completed smoke; not promoted.

## Definition

FG-QDM means front-guarded QD memory. It keeps a classic-style primary success
pool as the main optimizer and uses the QD archive only as passive memory for
valid-PPA implementation families. The first T85 descriptor is `sr_pca_3d`, so
this is a search-policy test, not a new descriptor test.

## Runs

| Run | Root | Read |
| --- | --- | --- |
| First smoke | `exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_12x3/seed_1001/openai_gpt-oss-120b` | Mechanism fired on `Prob045_alu`, but `Prob015_multi_pipe_8bit` never initialized the grid under warmup `8`. |
| Warmup-4 smoke | `exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_warmup4_12x3/seed_1001/openai_gpt-oss-120b` | Coverage fixed, but classic wins the headline mean-HV comparison. |

## Warmup-4 Metrics

| Backend | Problems | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Read |
| --- | ---: | ---: | ---: | ---: | --- |
| `classic` | 3 | 0.190331 | 3.00 | 17.33 | Wins `2/3`, ties `Prob015` at zero HV. |
| `fg_qdm_sr_memory_warmup4_12x3` | 3 | 0.137536 | 2.00 | 9.00 | Loses mean HV and front material. |

Per-problem metrics are in
[tables/warmup4_backend_problem_metrics.csv](tables/warmup4_backend_problem_metrics.csv).

## Interpretation

The warmup-4 rerun proves the scheduler is live enough to exercise memory lanes
on all three smoke problems. It does not prove useful QD behavior. The memory
lanes produce valid-PPA children, but they do not contribute global-front
material in the warmup-4 run, and the PPA front is weaker than classic on the
two nonzero-HV problems.

The negative result is not a generic rejection of front-guarded memory. It is a
rejection of exact `sr_pca_3d` FG-QDM at the three-problem `12x3` smoke gate.
T86 has now run the required random-memory control and random memory slightly
beats SR memory on this smoke, so exact `sr_pca_3d` memory is not earning its
budget.

## Visual Inspection

Two figures were inspected manually:

- [figures/warmup4_prob045_gain_power_vs_area.png](figures/warmup4_prob045_gain_power_vs_area.png)
- [figures/warmup4_prob015_gain_power_vs_effective_clock_period.png](figures/warmup4_prob015_gain_power_vs_effective_clock_period.png)

`Prob045_alu` clearly shows that FG-QDM has more Pareto points in the formal
table, but classic reaches a stronger area-gain region at similar power gain.
`Prob015_multi_pipe_8bit` shows why the scalar-score improvement is not a
promotion signal: FG-QDM is narrower and timing-negative, while classic keeps
broader tradeoff material.

## Tier

`T0_smoke_negative_not_promoted`.

Do not run the frozen eight-design screen or full RTLLM with exact `sr_pca_3d`
FG-QDM. Continue only through a materially different control or descriptor
swap.
