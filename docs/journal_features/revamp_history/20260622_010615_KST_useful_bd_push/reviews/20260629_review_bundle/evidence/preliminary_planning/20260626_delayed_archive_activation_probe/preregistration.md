# Preregistration

## Question

Can delayed archive activation rescue the best auxiliary archive family by
letting early generations behave like a classic hill climber before archive
pressure starts?

## Rationale

The fixed high-exploit auxiliary archive arm was the closest QD method on the
single-seed screen, but it failed the three-seed gate. Front-breadth,
depth-only, and adaptive sparse-front follow-ups did not recover the headline
HV gap. The next useful test should change the timing of QD pressure.

This probe keeps passive descriptor logging from the start, but disables
archive fill, backfill, and failure sampling pressure for generations `1` and
`2`. Generation `3` and later use the normal high-exploit auxiliary archive
policy.

## Frozen Setup

- Run root:
  `exp/useful_bd_push/prelim_delayed_archive_activation_20260626_022126_UTC/live`
- Run name: `masterrtl_delayed_archive_activation_8x5`
- Benchmark slice: frozen eight-design reference-complete preliminary screen.
- Budget: `population_size=8`, `num_generations=5`.
- Seed: `1001`.
- Archive activation generation: `3`.
- Endpoint: local vLLM, `openai/gpt-oss-120b`, `max_tokens=128000`,
  `diff_max_tokens=128000`.
- Baseline: existing matched seed `1001` `classic_revolution_8x5` from
  `exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live`.

## Arm

| Setting | Value |
| --- | --- |
| Archive descriptor | `source_aligned_masterrtl_structural_mix_3d` |
| Archive type | `grid_quantile` |
| Warmup successes | `4` |
| Cell mode | `elite_pareto_slot` |
| Max elites per cell | `2` |
| Fill target fraction | `0.10` |
| Improve backfill fraction | `0.05` |
| Archive activation generation | `3` |
| Parent selection after activation | `nsga2_global_rank` |
| Champion lane after activation | `0.90` |
| Two-parent probability | `0.0` |
| Operator | `single_thought_operator`, one-parent only |

## Metrics

Primary:

- reference-complete paired mean HV;
- paired HV delta by problem;
- mean Pareto points;
- mean reference-beating candidates;
- classic-covered design preservation.

Diagnostics:

- repeat aggregate with `Prob135_m2014_q6b` removed;
- count delayed generations through `qd_archive_pressure_active`;
- compare against fixed high-exploit, adaptive sparse-front, and classic `8x5`;
- inspect whether delayed activation improves Pareto breadth without losing
  valid-PPA coverage.

## Decision Rule

Promote this arm only if it is within the registered `1-2%` mean-HV tolerance
versus classic or better, preserves classic-covered designs, and improves at
least one front-material metric without depending on `Prob135_m2014_q6b`.

If it loses clearly, do not run another small geometry tweak in this same
MasterRTL auxiliary archive family. Move to a materially different mechanism,
such as stagnation-triggered archive activation, RTL-native pretrained
model-state descriptors, or a broader negative report for the tested families.
