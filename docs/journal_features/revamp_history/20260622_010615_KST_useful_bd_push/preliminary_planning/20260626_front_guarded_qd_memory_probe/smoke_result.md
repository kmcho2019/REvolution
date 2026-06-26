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
`4`, and must include a matched classic run before any performance claim.

Required next checks:

- rerun the three-problem smoke with `qd_grid_quantile_warmup_successes=4`;
- run matched classic on the same problems, seed, and budget;
- preserve archive-history lane counts and per-candidate memory metadata;
- compare against classic using reference-complete HV/Pareto metrics before
  adding T85 to the full RTLLM candidate shortlist.
