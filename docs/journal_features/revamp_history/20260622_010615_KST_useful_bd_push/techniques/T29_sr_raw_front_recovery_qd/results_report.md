# T29 Results Report

Status: complete live development-screen run; `T0 diagnostic`.

## Pre-Registered Question

Can SR raw front recovery restore rank-1 PPA-front material versus T26 while
preserving T26's live HV/HV-AUC and classic-covered-design behavior?

## Setup

See `methodology.md`, `commands/live_screen_v0.md`, and
`commands/package_t29_audit.md`.

The live run used `openai/gpt-oss-120b`, seed `1001`, population `12`, three
generations, strict ablation evaluation, and the same three RTLLM development
screen as T24/T25/T26. The resolved run root is:

`exp/useful_bd_push/t29_sr_raw_front_recovery_qd_20260621_225827_UTC/`

## Primary Result

T29 does not recover T26's front deficit and should not be promoted. It keeps
valid candidate-level PPA samples on all three problems, but
`Prob015_multi_pipe_8bit` has no final-population best PPA and no active
archive members in the validator report. Candidate-level analysis finds only
two rank-1 PPA-front points for multi-pipe, compared with five for T26, ten for
unguarded SR raw, and eleven for classic.

Direct PPA-front figures are the main visual evidence:

- `figures/t29_ppa_fronts_area_power_zoom.png` plots raw area-power points with
  lower-is-better axes inverted and open-circle front markers.
- `figures/t29_ppa_fronts_improvement.png` plots normalized area/power
  improvement, where higher is better.
- `figures/t29_live_problem_front_counts.png` shows that front recovery drops
  to two multi-pipe front points and six valid multi-pipe PPA samples.

## Aggregate Metrics

| Method | Mean HV | HV AUC | Final best problems | Valid PPA | Front points | Front families |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 0.160241 | 0.122837 | 3 | 66 | 18 | 19 |
| SR raw | 0.147152 | 0.127593 | 3 | 49 | 16 | 16 |
| T26 conservative exploit | 0.178862 | 0.144485 | 3 | 57 | 9 | 9 |
| T29 front recovery | 0.139295 | 0.118396 | 2 | 42 | 8 | 9 |

T29 trails T26 by 22.12% mean HV, 18.06% HV-AUC, 26.32% valid PPA, and one
aggregate PPA-front point. It also trails classic by 13.07% mean HV, 36.36%
valid PPA, and 55.56% front points. The apparent mean-final-best gain is not a
valid promotion signal because the metric is available for only two of the
three problems.

## Per-Problem Read

- `Prob045_alu`: T29 remains useful but not decisive. It has best score
  `0.408761`, HV `0.233085`, and three front points; this is close to T26's
  ALU quality while recovering more front points.
- `Prob041_traffic_light`: T29 weakens quality and yield. It has best score
  `0.389132`, valid PPA count `14`, and three front points, trailing classic
  and manual BD on final quality.
- `Prob015_multi_pipe_8bit`: T29 fails the reason it was created. It has six
  valid candidate-level PPA samples, two candidate-level front points, zero
  reference-beating candidates, zero active archive members, and no final best
  PPA.

## Validation

Pareto archive validation passed structurally with zero failures:
`tables/live_front_recovery_pareto_validation.md`. The validation result is
not a quality pass; it means the exported local-Pareto archive is internally
consistent. The validator also exposes the multi-pipe failure:
`RTLLM/Prob015_multi_pipe_8bit` has `members=0`.

## Tier Decision

`T0 diagnostic`.

T29 should be treated as negative evidence for simple partial reversal of the
T26 champion-lane schedule. Lowering champion-lane pressure from `0.80` to
`0.60` and restoring `0.20` two-parent fusion does not recover the desired
front shape and loses final multi-pipe coverage. The next branch should not
continue blind schedule interpolation. It should either:

- hold out T26 directly to test whether the current lead generalizes; or
- add an explicit repair/yield emitter or front-preserving emitter that keeps
  T26-style champion refinement while protecting multi-pipe active-archive
  survival.
