# T38 Results Report

Status: bounded live arm completed; comparator arms not run yet.

T38 currently documents and implements the live `elite_pareto_slot` archive
mode needed to test the T37 one-slot result. The first full bounded arm ran
with the pre-registered three RTLLM problems, population 12, 3 generations,
seed 1001, and full 128000 token caps.

## Smoke Result

A one-problem smoke run completed under
`exp/useful_bd_push/t38_elite_pareto_slot_live_qd_20260622_054857_UTC/`.
It verified the vLLM endpoint, CLI path, runtime archive config, generated
archive files, and Pareto validator compatibility for `elite_pareto_slot`.

The smoke generated 8 candidates on `RTLLM/Prob045_alu`, but none reached
functional or synthesis-PPA success. Archive member count, global Pareto size,
and `max_front_size_seen` were all zero. This is a runtime contract check only,
not PPA-front evidence and not a method tier result.

## Live Bounded-Arm Result

Run root:
`exp/useful_bd_push/t38_elite_pareto_slot_live_qd_20260622_054857_UTC/elite_pareto_slot_qd/seed_1001/openai_gpt-oss-120b/`.

The Pareto archive validator passed with `failure_count=0` and
`max_front_size_seen=2`.

| Problem | Valid PPA | Local front | Global front | Archive members | Best quality |
| --- | ---: | ---: | ---: | ---: | ---: |
| `Prob045_alu` | 25 | 2 | 2 | 19 | 0.416377 |
| `Prob041_traffic_light` | 8 | 2 | 2 | 7 | 0.399899 |
| `Prob015_multi_pipe_8bit` | 7 | 3 | 3 | 0 |  |

The direct raw area-power plot is
`figures/t38_live_raw_area_power_fronts.png`. It uses raw area on x, raw power
on y, no inverted axes, and lower-left marked as better. It shows usable T38
PPA/front material for ALU and traffic-light, and it exposes the main failure
mode for multi-pipe: valid/global Pareto candidates exist, but the active
grid-quantile archive has zero members because the run produced only seven
valid PPA points, below the configured warmup threshold of eight.

## Conclusion

T38 should be treated as `T0 diagnostic`, not a useful-BD win. The new cell
mode runs end to end and can retain two-member cells on problems with enough
valid PPA samples, but the current live configuration does not preserve active
archive coverage on multi-pipe. The next variant should keep the
champion-plus-one-slot rule but change the warmup policy for sparse-yield
problems before spending budget on broader comparator arms.

Current tier: `T0 diagnostic`.
