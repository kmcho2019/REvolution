# T97 Results Report

Status: completed smoke; not promoted.

## Summary

T97 improves over the earlier FG-QDM smokes on mean HV, but it still does not
beat classic and it does not yet prove that memory-lane recall earns its
budget.

| Backend | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic` | `0.190331` | `3.00` | `17.33` | `3` |
| `fg_qdm_sr_front_credit_12x3` | `0.153384` | `1.67` | `9.33` | `0` |
| `fg_qdm_random_memory_12x3` | `0.138162` | `2.67` | `9.67` | `0` |
| `fg_qdm_sr_memory_warmup4_12x3` | `0.137536` | `2.00` | `9.00` | `0` |
| `fg_qdm_shape_density_memory_12x3` | `0.126367` | `3.00` | `7.00` | `0` |

## Mechanism Read

The stricter front-credit setting reduced broad memory traffic and improved
aggregate HV versus T85/T86/T87. Memory-refine contributed some local archive
material:

- `memory_refine`: `7` calls, `3` valid-PPA children, `3` local-front adds,
  `0` global-front adds.
- `front_rescue`: `4` calls, `0` valid-PPA children.

This is a partial mechanism improvement over T85 SR memory, which had only one
local memory-lane add. It is not enough for promotion because global front
contribution is still zero and Pareto breadth drops below the earlier random
and shape-density controls.

## Per-Problem Read

- `Prob045_alu`: T97 reaches HV `0.227203`, the best FG-QDM arm in this smoke,
  but still below classic `0.255499`.
- `Prob041_traffic_light`: T97 reaches HV `0.232950`, slightly above T85
  SR-memory and random memory, but still below classic `0.315492`.
- `Prob015_multi_pipe_8bit`: all arms remain at zero HV; T97 has two Pareto
  points, below classic's five.

## Decision

Do not promote exact T97 to the frozen eight-design screen yet.

T97 is useful because it shows stricter memory credit is directionally better
than permissive FG-QDM on the smoke mean-HV metric. The next fair step would be
a same-threshold random-memory control or a one-problem diagnostic that proves
memory-refine can add global-front material. Without that, the final RTLLM
candidate list remains unchanged.

## Validation

- vLLM preflight: `openai/gpt-oss-120b`, `max_model_len=131072`.
- `scripts/validate_pareto_front_run.py`: passed.
- `scripts/validate_single_thought_operator_run.py`: passed.
- `scripts/report_pareto_analysis.py`: completed.
- `scripts/report_ppa_distribution.py`: completed with `248` candidate rows,
  `3` reference problems, and `50` generated figures.
