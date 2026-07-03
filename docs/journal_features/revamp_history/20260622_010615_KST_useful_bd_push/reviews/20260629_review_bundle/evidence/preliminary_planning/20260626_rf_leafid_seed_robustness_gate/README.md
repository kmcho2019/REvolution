# RF Leaf-ID Seed Robustness Gate

Status: completed diagnostic negative; do not promote exact T83.

## Purpose

T83 is the closest current QD arm by single-seed mean HV, but its apparent
near-tie depends heavily on `Prob135_m2014_q6b` and does not hold on the
RTLLM-only slice. This gate tests whether that result is repeatable before any
larger RTLLM spend.

## Fixed Comparison

| Item | Value |
| --- | --- |
| QD arm | `masterrtl_rf_leafid_structural_delayed_8x5` |
| New QD seeds | `1002`, `1003` |
| Reused classic seeds | `1002`, `1003` from `prelim_aux_archive_seed_replication_20260625_232854_UTC` |
| Existing seed | `1001` from T83 |
| Budget | `population_size=8`, `num_generations=5` |
| Subset | frozen eight-design preliminary screen |
| Model | `openai/gpt-oss-120b` through local vLLM |

## Decision

The gate failed. Three-seed classic mean HV is `0.144182`, while T83 mean HV
is `0.125986` (`-12.62%`). T83 loses all three seed-level mean-HV comparisons,
and the RTLLM-only slice remains negative (`0.108504` versus classic
`0.150861`). Keep T83 as the MasterRTL RF model-state category representative,
but do not spend larger RTLLM budget on this exact configuration.

## Files

- `preregistration.md`: fixed method and decision rule.
- `commands/run_rf_leafid_seed_robustness.md`: exact run commands.
- `logs/`: preflight and run checkpoints.
- `tables/`: packaged seed, problem, robustness, and descriptor-health metrics.
- `figures/`: inspected summary figures after packaging.
- `seed_robustness_report.md`: concise conclusion report.
