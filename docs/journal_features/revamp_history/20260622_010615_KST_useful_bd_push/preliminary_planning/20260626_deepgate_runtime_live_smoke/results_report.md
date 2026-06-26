# T93 DeepGate Runtime Live Smoke Results

## Question

Does the T92 `deepgate_pooled_pc3` runtime descriptor profile work inside a
live REvolution QD run when generated RTL reaches valid PPA?

## Result

Yes, but only as a bounded runtime-smoke result.

The successful `Prob045_alu` `4x1` run generated one valid-PPA candidate. The
archive initialized with one member and wrote finite DeepGate descriptor values
to `archive_cells.csv`:

| Axis | Value |
| --- | ---: |
| `deepgate_pool_pc0` | `0.0002696719071487415` |
| `deepgate_pool_pc1` | `0.08077756043733988` |
| `deepgate_pool_pc2` | `-0.09394080465509182` |

The candidate's PPA objectives were:

| Objective | Value |
| --- | ---: |
| `g_P` | `0.9910526315789473` |
| `g_A` | `0.190561797752809` |

This proves the live descriptor path can call the isolated official DeepGate
environment, project the pooled embedding through the frozen T91 PCA artifact,
and pass the values through the QD archive artifact surface.

## Failed Initial-Only Attempts

Three initial-only attempts did not produce any valid-PPA candidates:

| Problem | Budget | Valid PPA | Descriptor observations |
| --- | --- | ---: | ---: |
| `Prob024_fsm` | `2x0` | `0/2` | `0` |
| `Prob041_traffic_light` | `4x0` | `0/4` | `0` |
| `Prob045_alu` | `4x0` | `0/4` | `0` |

These are not DeepGate failures. The descriptor is only evaluated for
valid-PPA candidates, and no valid-PPA candidates existed in those runs.

## Successful Attempt

| Problem | Budget | Valid PPA | Archive members | Descriptor observations |
| --- | --- | ---: | ---: | ---: |
| `Prob045_alu` | `4x1` | `1/8` | `1` | `1` |

Run root:

```text
exp/useful_bd_push/deepgate_runtime_live_smoke_20260626_1155_UTC/qd_deepgate_pooled_pc3_4x1_prob045/seed_1001/openai_gpt-oss-120b
```

## Interpretation

T93 upgrades DeepGate from implementation-gate-positive to
runtime-smoke-positive. It does not make DeepGate spend-ready for full RTLLM.

The archive has one member, so all axes are globally collapsed by definition.
That is acceptable for the runtime smoke but insufficient for descriptor
health, matched HV, or final-arm selection.

## Next Gate

The next valid DeepGate gate is a matched small screen, not full RTLLM:

1. use the frozen reference-complete preliminary subset;
2. compare against matched classic under the same budget;
3. require nonzero descriptor observations on multiple problems;
4. report mean HV, HV-AUC when available, Pareto points, unique PPA points,
   and valid-PPA coverage;
5. keep DeepGate out of final RTLLM spend unless it approaches classic or
   improves front material without coverage loss.
