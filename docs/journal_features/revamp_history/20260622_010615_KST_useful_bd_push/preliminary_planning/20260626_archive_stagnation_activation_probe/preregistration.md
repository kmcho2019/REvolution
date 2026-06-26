# Preregistration

## Question

Can archive-stagnation-triggered activation rescue the best auxiliary archive
family by waiting for passive archive growth to slow before spending budget on
QD archive pressure?

## Rationale

The fixed high-exploit auxiliary archive arm was the closest QD method on the
single-seed screen, but it failed the three-seed gate. Front-breadth,
depth-only, adaptive sparse-front, and fixed delayed-activation follow-ups did
not recover the headline HV gap.

The delayed activation probe suggests timing matters, but a fixed generation is
too blunt. This probe keeps passive descriptor logging from the start and
activates archive fill, backfill, and failure sampling only after two
consecutive archive-history intervals show no growth in occupied cells or
archive-member count.

## Anti-Gaming Boundary

The activation trigger may use only scheduler-visible archive state:

- `occupied_cells`;
- `archive_member_count`;
- current generation.

It must not use final PPA, reference PPA, fitness, hypervolume, Pareto rank,
functional pass rate, or synthesis pass rate as in-loop BD inputs or activation
inputs.

## Frozen Setup

- Run root:
  `exp/useful_bd_push/prelim_archive_stagnation_activation_20260626_031337_UTC/live`
- Run name: `masterrtl_archive_stagnation_activation_8x5`
- Benchmark slice: frozen eight-design reference-complete preliminary screen.
- Budget: `population_size=8`, `num_generations=5`.
- Seed: `1001`.
- Archive activation patience: `2` stagnant archive intervals.
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
| Activation patience | `2` stagnant archive intervals |
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
- count activation timing through `qd_archive_stagnation_triggered` and
  `qd_archive_pressure_active`;
- compare against fixed high-exploit, delayed activation, adaptive
  sparse-front, and classic `8x5`;
- inspect whether stagnation activation improves Pareto breadth without losing
  valid-PPA coverage.

## Decision Rule

Promote this arm only if it is within the registered `1-2%` mean-HV tolerance
versus classic or better, preserves classic-covered designs, and improves at
least one front-material metric without depending on `Prob135_m2014_q6b`.

If it loses clearly, stop this MasterRTL auxiliary archive timing family as a
full-RTLLM candidate and move to a materially different lane, such as validated
MasterRTL pretrained model-state descriptors or a broader negative report for
the tested archive-coupling families.
