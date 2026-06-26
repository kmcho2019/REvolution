# T87 Results Report

Status: completed smoke; negative; not promoted.

## Definition

T87 keeps the simplified FG-QDM scheduler fixed and changes only the descriptor
to `source_aligned_shape_density_3d`. The descriptor uses source-aligned
MasterRTL/RTLTimer RTL structure axes:

- `source_aligned_masterrtl_branching`
- `source_aligned_rtltimer_wire_density`
- `source_aligned_rtltimer_dff_density`

The test asks whether RTL-native memory cells improve FG-QDM after exact
SR-memory failed the T86 random-memory control.

## Run

| Run | Root | Read |
| --- | --- | --- |
| Shape-density memory smoke | `exp/useful_bd_push/front_guarded_rtl_native_memory_20260626/fg_qdm_shape_density_memory_12x3/seed_1001/openai_gpt-oss-120b` | Completed `3/3` smoke problems in `690.97s` after vLLM preflight. |

Preflight confirmed `openai/gpt-oss-120b` with `max_model_len=131072`.

## Headline Metrics

| Backend | Problems | Mean HV | Mean Pareto Points | Mean Ref-Beating | HV Wins |
| --- | ---: | ---: | ---: | ---: | ---: |
| `classic` | 3 | 0.190331 | 3.00 | 17.33 | 3 |
| `fg_qdm_random_memory_12x3` | 3 | 0.138162 | 2.67 | 9.67 | 0 |
| `fg_qdm_sr_memory_warmup4_12x3` | 3 | 0.137536 | 2.00 | 9.00 | 0 |
| `fg_qdm_shape_density_memory_12x3` | 3 | 0.126367 | 3.00 | 7.00 | 0 |

T87 does not pass the promotion gate. It trails classic and also trails both
SR-memory and random-memory FG-QDM on mean HV and reference-beating candidate
count. It matches classic on mean Pareto point count, but that is not enough
because the front material is lower-quality on the headline HV metric.

## Per-Problem Read

- `Prob045_alu`: T87 is the best FG-QDM arm on HV (`0.209878`), above random
  memory (`0.192897`) and SR memory (`0.185347`), but still below classic
  (`0.255499`).
- `Prob041_traffic_light`: T87 is much worse (`0.169223`) than random memory
  (`0.221590`), SR memory (`0.227261`), and classic (`0.315492`).
- `Prob015_multi_pipe_8bit`: all arms have zero HV; T87 has three Pareto
  points but no reference-beating candidates and negative timing gain.

## Mechanism Read

The descriptor is not collapsed overall: all three problems initialize the
grid, and only `Prob045_alu` collapses the DFF-density axis. However, the
memory lanes do not produce valid-PPA children:

| Problem | Memory-refine valid PPA | Front-rescue valid PPA | Memory/front global adds |
| --- | ---: | ---: | ---: |
| `Prob015_multi_pipe_8bit` | 0 | 0 | 0 |
| `Prob041_traffic_light` | 0 | 0 | 0 |
| `Prob045_alu` | 0 | 0 | 0 |

This blocks the intended FG-QDM claim. T87's useful `Prob045_alu` signal comes
from the classic lane under the FG-QDM run, not from credited memory recall.

## Decision

`T0_smoke_negative_not_promoted`.

Do not promote T87 to the frozen eight-design screen. Keep the result as
evidence that swapping FG-QDM to a stronger RTL-native descriptor is not
sufficient when the guarded memory lanes fail to produce valid-PPA children.
The next shortlist step should shift away from this exact FG-QDM coupling or
test a materially different encoder/config family.
