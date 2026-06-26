# RF Leaf-ID Seed Robustness Gate

Status: preregistered; QD seeds pending.

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

Do not promote T83 unless the replicated read is at least near-classic on mean
HV and does not depend on `Prob135_m2014_q6b`. Keep the result as the best
MasterRTL RF model-state category representative even if it remains below
classic.

## Files

- `preregistration.md`: fixed method and decision rule.
- `commands/run_rf_leafid_seed_robustness.md`: exact run commands.
- `logs/`: preflight and run checkpoints.
- `tables/`: packaged metrics after the QD seeds finish.
- `figures/`: inspected summary figures after packaging.
