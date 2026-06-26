# Preregistration

## Question

Can adaptive sparse-front pressure improve the best auxiliary archive mechanism
without paying a constant front-slot tax?

## Rationale

The fixed high-exploit auxiliary archive arm failed seed replication. The
front-breadth variant recovered some Pareto count but lost too much HV, while
the depth-only variant helped classic more than QD. The next clean test should
change when diversity pressure is paid, not just change descriptor geometry or
run depth.

This probe uses the existing `sparse_front_triggered_nsga2` selector. It keeps
classic-like global NSGA-II parent sampling and a high champion lane until the
archive has too few extra local-front slots. When that sparse-front condition
is true, the engine caps the champion lane at `0.65` for that batch.

## Frozen Setup

- Run root:
  `exp/useful_bd_push/prelim_adaptive_sparse_front_20260626_013437_UTC/live`
- Run name: `masterrtl_aux_archive_adaptive_sparse_front_8x5`
- Benchmark slice: frozen eight-design reference-complete preliminary screen.
- Budget: `population_size=8`, `num_generations=5`.
- Seed: `1001`.
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
| Parent selection | `sparse_front_triggered_nsga2` |
| Champion lane | `0.90`, capped at `0.65` only when sparse-front trigger fires |
| Two-parent probability | `0.0` |
| Operator | `single_thought_operator`, one-parent only |

## Metrics

Primary:

- reference-complete paired mean HV;
- paired HV delta by problem;
- mean Pareto points;
- mean reference-beating candidates;
- classic-covered design preservation.

Robustness:

- repeat aggregate with `Prob135_m2014_q6b` removed;
- count sparse-front trigger batches and parent requests;
- compare against fixed high-exploit, front-breadth, and depth-only auxiliary
  archive results as context.

## Decision Rule

Do not promote this arm to full RTLLM spend unless it is within the registered
`1-2%` mean-HV tolerance versus classic or better, preserves classic-covered
designs, and improves at least one front-material metric without depending on
`Prob135_m2014_q6b`.

If it loses clearly, stop this fixed MasterRTL auxiliary archive family and
write the current milestone as a rigorous negative screen for these QD
variants.
