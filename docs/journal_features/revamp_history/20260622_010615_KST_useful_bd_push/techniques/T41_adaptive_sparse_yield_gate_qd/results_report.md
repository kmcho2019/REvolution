# T41 Results Report

Status: complete live screen.

Tier decision: `T0 mixed_diagnostic`.

## Question

T41 tested whether T39's sparse-yield one-slot behavior can be gated per
design. It kept the strict primary grid-quantile warmup threshold of `8`, then
allowed archive activation after generation `1` when a problem still had an
empty archive, at least `4` buffered valid PPA samples, and valid descriptor
geometry.

## Run Surface

- run root:
  `exp/useful_bd_push/t41_adaptive_sparse_yield_gate_qd_20260622_083629_UTC/`
- model: `openai/gpt-oss-120b`
- endpoint: `http://20.0.0.103:8000/v1`
- max model length from preflight: `131072`
- token caps: `max_tokens=128000`, `diff_max_tokens=128000`
- subset: `Prob045_alu`, `Prob041_traffic_light`,
  `Prob015_multi_pipe_8bit`
- seed: `1001`
- budget: population `12`, generations `3`
- classic runtime: `719` seconds
- adaptive runtime: `1033` seconds

## Primary Evidence

The primary figure is `figures/t41_raw_area_power_fronts.png`. It uses raw
area on x, raw power on y, conventional non-inverted axes, and lower-left as
better. Open circles mark each method's own raw area-power front; black stars
mark the pooled front across all compared methods.

| Problem | T41 classic valid PPA | T41 adaptive valid PPA | T41 adaptive pooled hits | Best score read |
| --- | ---: | ---: | ---: | --- |
| `Prob045_alu` | 18 | 19 | 0 | adaptive `0.400330` loses to classic `0.414603` |
| `Prob041_traffic_light` | 22 | 20 | 7 | adaptive `0.473631` beats classic `0.407742` |
| `Prob015_multi_pipe_8bit` | 15 | 13 | 0 | adaptive `-0.000378` loses to T39 `0.222285` |

The validator passed:

- `valid=True`
- `failure_count=0`
- `problem_invalid_count=0`
- `acceptance_error_count=0`
- `max_front_size_seen=2`

## Archive Behavior

All three adaptive archives initialized. ALU and traffic-light initialized
with `8` samples, while multi-pipe initialized with `5`, so the adaptive
fallback did activate on the sparse-yield design. That activation was not
enough to preserve the T39 multi-pipe gain.

| Problem | Init samples | Occupied cells | Archive members | Global Pareto size | QD score | Best quality |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `Prob045_alu` | 8 | 13 | 16 | 2 | 5.008975 | 0.400330 |
| `Prob041_traffic_light` | 8 | 13 | 16 | 3 | 3.712470 | 0.473631 |
| `Prob015_multi_pipe_8bit` | 5 | 11 | 12 | 6 | -1.282301 | -0.000378 |

## Conclusion

T41 is not a useful-QD promotion. It preserves classic-covered problems and
does not show a catastrophic valid-PPA drop, but it fails the T41 acceptance
signal because it loses the hard multi-pipe improvement that motivated the
sparse-yield lane.

It is still useful diagnostic evidence. The adaptive gate finds a strong
traffic-light front that T39/T40 did not: seven pooled raw area-power front
hits and a best score of `0.473631`. The failure is specificity, not
functionality. Waiting until generation `1` appears too late for multi-pipe;
the next ablation should initialize sparse-yield designs immediately after the
initial population when valid-PPA count is below `8` but at least `4`, while
leaving high-yield designs on the strict eight-success path.

## Next Step

Pre-register a T42 initial sparse-yield gate:

- primary warmup `8`;
- adaptive fallback threshold `4`;
- trigger generation `0`;
- same T41 subset/model/seed/budget;
- same direct raw PPA-front figure gate.

T42 should be judged by whether it keeps T41's traffic-light front gain while
recovering T39's multi-pipe best score or pooled-front contribution.
