# T98 Results Report

Status: completed control; not promoted.

## Summary

T98 blocks the claim that stricter front-credit scheduling alone explains the
T97 smoke improvement. T97's SR descriptor beats the same-threshold random
control on mean HV, but both still trail classic.

| Backend | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: |
| `classic` | `0.190331` | `3.00` | `17.33` | `3` |
| `fg_qdm_sr_front_credit_12x3` | `0.153384` | `1.67` | `9.33` | `0` |
| `fg_qdm_random_memory_12x3` | `0.138162` | `2.67` | `9.67` | `0` |
| `fg_qdm_sr_memory_warmup4_12x3` | `0.137536` | `2.00` | `9.00` | `0` |
| `fg_qdm_shape_density_memory_12x3` | `0.126367` | `3.00` | `7.00` | `0` |
| `fg_qdm_random_front_credit_12x3` | `0.104805` | `2.67` | `7.00` | `0` |

## Mechanism Read

The same-threshold random control produced one memory-refine global-front add,
but that did not translate into better final HV.

- `memory_refine`: `7` calls, `1` valid-PPA child, `1` global-front add,
  `1` local-front add.
- `front_rescue`: `5` calls, `1` valid-PPA child, `0` global-front adds,
  `1` local-front add.

This means T97 has a better aggregate HV result than its same-threshold random
control, but the FG-QDM mechanism is still not strong enough. T97 has no
memory-lane global-front adds, while T98 has one that is not quality-productive
at the final PPA-front level.

## Per-Problem Read

- `Prob045_alu`: T98 HV `0.175969`, below T97 `0.227203` and classic
  `0.255499`.
- `Prob041_traffic_light`: T98 HV `0.138446`, below T97 `0.232950` and
  classic `0.315492`.
- `Prob015_multi_pipe_8bit`: all arms stay at zero HV; T98 has two Pareto
  points and eight valid candidates.

## Decision

Keep T97 as the FG-QDM category representative, but do not promote FG-QDM to
the frozen eight-design screen or final RTLLM spend.

T98 answers the immediate control question: T97 is better than random memory
under the same stricter credit threshold. It does not answer the larger
mechanism question positively because classic still wins every HV comparison
and memory-lane front additions do not yet improve the final PPA front enough
to justify broader spend.

## Validation

- vLLM preflight: `openai/gpt-oss-120b`, `max_model_len=131072`.
- Runtime: `707.43s`.
- `scripts/validate_pareto_front_run.py`: passed.
- `scripts/validate_single_thought_operator_run.py`: passed.
- `scripts/report_pareto_analysis.py`: completed.
- `scripts/report_ppa_distribution.py`: completed with `290` candidate rows,
  `3` reference problems, and `60` generated figures.
