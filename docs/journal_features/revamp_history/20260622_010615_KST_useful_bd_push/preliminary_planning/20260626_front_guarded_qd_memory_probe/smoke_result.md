# T85 FG-QDM Three-Problem Smoke Result

## Run

- Timestamp: `2026-06-26T07:19:24Z`
- Run root: `exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_12x3/seed_1001/openai_gpt-oss-120b`
- Model: `openai/gpt-oss-120b`
- Endpoint preflight: passed, `max_model_len=131072`
- Budget: `population_size=12`, `num_generations=3`, seed `1001`
- Problems: `Prob045_alu`, `Prob041_traffic_light`, `Prob015_multi_pipe_8bit`
- Descriptor: `sr_pca_3d`
- Runtime: `687.24` seconds

This smoke is a mechanism check, not a matched classic-vs-QD performance
claim. It should not be used as evidence that T85 beats classic.

## Summary

| Problem | Backend Summary | Best Score | Success Pool | Archive Members | Occupied Cells | Global Pareto | Memory Refine Calls | Front Rescue Calls | Memory Valid PPA | Memory Global-Front Adds |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `Prob045_alu` | success | 0.401605 | 12 | 13 | 10 | 3 | 4 | 2 | 2 | 1 |
| `Prob041_traffic_light` | success | 0.341137 | 12 | 11 | 9 | 2 | 2 | 0 | 1 | 0 |
| `Prob015_multi_pipe_8bit` | failed | n/a | 7 | 0 | 0 | 2 | 0 | 0 | 0 | 0 |

## Existing Classic Comparator Read

An existing same-seed `12x3` classic run from T79 covers the same three
problems:
`exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live/classic_revolution_12x3/seed_1001/openai_gpt-oss-120b`.

| Problem | Classic Summary Score | T85 Summary Score | Read |
| --- | ---: | ---: | --- |
| `Prob045_alu` | 0.416550 | 0.401605 | Classic higher. |
| `Prob041_traffic_light` | 0.420875 | 0.341137 | Classic higher. |
| `Prob015_multi_pipe_8bit` | 0.061050 | failed | Classic covered the design; T85 did not. |

This comparator is enough to block T85 promotion after the first smoke. It is
not enough to retire T85 because the run also showed that the `8`-success
grid-quantile warmup can prevent memory activation on lower-yield designs.

## Interpretation

The implementation ran end to end and produced archive/PPA artifacts for all
three problems. The memory mechanism fired on `Prob045_alu` and
`Prob041_traffic_light`; `Prob045_alu` is the first useful signal because a
front-rescue call produced one global-front add and one local-front insertion.

`Prob015_multi_pipe_8bit` exposed a practical issue: the grid-quantile warmup
threshold was `8`, but the run ended with only `7` warmup successes, so the
archive never initialized and the memory lanes never fired. This is not a
descriptor failure; it means the smoke setting is too conservative for
low-validity problems.

## Decision

Keep T85 as an active candidate, but do not promote it to a final RTLLM arm yet.
The next T85 screen should use a lower grid-quantile warmup threshold, such as
`4`, and should compare against the existing or freshly rerun classic arm before
any performance claim.

Required next checks:

- rerun the three-problem smoke with `qd_grid_quantile_warmup_successes=4`;
- reuse or rerun matched classic on the same problems, seed, and budget;
- preserve archive-history lane counts and per-candidate memory metadata;
- compare against classic using reference-complete HV/Pareto metrics before
  adding T85 to the full RTLLM candidate shortlist.

## Warmup-4 Rerun

- Timestamp: `2026-06-26T07:42:20Z`
- Run root: `exp/useful_bd_push/front_guarded_qd_memory_20260626/fg_qdm_sr_memory_warmup4_12x3/seed_1001/openai_gpt-oss-120b`
- Runtime: `684.84` seconds
- Change from first smoke: `qd_grid_quantile_warmup_successes=4`
- Analysis root:
  `analysis/warmup4_pareto_analysis/`
- PPA distribution root:
  `analysis/warmup4_ppa_distribution/`

The lowered warmup threshold fixed the coverage failure: all three smoke
problems completed with valid winners, including `Prob015_multi_pipe_8bit`.

| Problem | Classic Score | T85 Warmup-4 Score | Score Read |
| --- | ---: | ---: | --- |
| `Prob015_multi_pipe_8bit` | 0.061050 | 0.071689 | T85 higher scalar score. |
| `Prob041_traffic_light` | 0.420875 | 0.406347 | Classic higher. |
| `Prob045_alu` | 0.416550 | 0.392585 | Classic higher. |

Mean summary score is `0.299492` for classic and `0.290207` for T85 warmup-4.
That is a small scalar-score loss, but the formal PPA-front read is more
negative.

## Warmup-4 Pareto / HV Read

| Backend | Problems | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: | ---: |
| `classic` | 3 | 0.190331 | 3.00 | 17.33 | 3 |
| `fg_qdm_sr_memory_warmup4_12x3` | 3 | 0.137536 | 2.00 | 9.00 | 0 |

Per-problem HV:

| Problem | Classic HV | T85 HV | T85 Delta | Read |
| --- | ---: | ---: | ---: | --- |
| `Prob015_multi_pipe_8bit` | 0.000000 | 0.000000 | 0.000000 | Both fronts have zero HV; T85 has fewer Pareto points. |
| `Prob041_traffic_light` | 0.315492 | 0.227261 | -0.088231 | Classic wins HV and reference-beating count. |
| `Prob045_alu` | 0.255499 | 0.185347 | -0.070152 | T85 has more Pareto points but lower HV. |

Mechanism telemetry:

| Problem | Memory Refine Calls | Front Rescue Calls | Memory Valid PPA | Memory Global-Front Adds | Memory Local-Front Adds |
| --- | ---: | ---: | ---: | ---: | ---: |
| `Prob015_multi_pipe_8bit` | 2 | 1 | 2 | 0 | 1 |
| `Prob041_traffic_light` | 4 | 0 | 1 | 0 | 1 |
| `Prob045_alu` | 4 | 2 | 3 | 0 | 1 |

The memory lanes now fire on every problem, but they do not add global-front
material in the warmup-4 rerun. This fails the pre-registered smoke gate
requiring the run to be not clearly worse than classic on mean HV.

## Warmup-4 Decision

Do not promote T85 to the frozen eight-design screen or the final RTLLM spend
queue yet.

Keep T85 as a mechanism idea because it is materially different and the
telemetry is informative, but the current `sr_pca_3d` warmup-4 version is a
negative smoke result on headline HV: `0.137536` versus classic `0.190331` on
the same three reference-complete problems.
