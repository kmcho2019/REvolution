# Preregistration

## Question

Does the best diagnostic auxiliary archive result survive seed noise and the
`Prob135_m2014_q6b` robustness check?

## Rationale

The 2026-06-25 periodic review accepted the current planning package as honest,
but not finished. It identified two blockers before choosing full-RTLLM QD
configs:

1. all current live screens are single-seed;
2. the high-exploit auxiliary archive aggregate is dominated by
   `Prob135_m2014_q6b`.

This gate answers those blockers without changing descriptor geometry or
parent-selection settings.

## Frozen Setup

- Run root:
  `exp/useful_bd_push/prelim_aux_archive_seed_replication_20260625_232854_UTC/live`
- Benchmark slice: the existing eight-design reference-complete preliminary
  screen.
- Budget: `population_size=8`, `num_generations=5`.
- Endpoint: local vLLM, `openai/gpt-oss-120b`, `max_tokens=128000`,
  `diff_max_tokens=128000`.
- Seeds launched here: `1002`, `1003`.
- Seed `1001` is reused only from the existing completed runs during rollup.

## Arms

| Arm | Search mode | Key settings |
| --- | --- | --- |
| `classic_revolution_8x5` | `revolution` | No QD archive. |
| `masterrtl_aux_archive_high_exploit_8x5` | `revolution_qd` | `source_aligned_masterrtl_structural_mix_3d`, `qd_fill_target_fraction=0.10`, `qd_improve_backfill_fraction=0.05`, `qd_champion_lane_fraction=0.90`, `qd_parent_selection=nsga2_global_rank`, `qd_two_parent_probability=0.0`. |

## Metrics

Primary:

- reference-complete paired mean HV;
- paired HV delta by problem and seed;
- mean Pareto points;
- mean reference-beating candidates;
- classic-covered design preservation.

Robustness:

- repeat aggregate with `Prob135_m2014_q6b` removed;
- report per-problem HV deltas for all three seeds;
- report classic seed spread so sub-1% QD differences are not over-read.

## Decision Rule

Do not promote this mechanism to final RTLLM spend unless the three-seed rollup
is within the pre-registered `1-2%` mean-HV tolerance or better, does not rely
on `Prob135_m2014_q6b` for its aggregate read, and does not lose front breadth
catastrophically.

If it loses clearly after this gate, retire the current auxiliary archive
geometry and switch to a preregistered adaptive archive-pressure mechanism.
