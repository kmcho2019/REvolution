# N04 Baseline Verification

Verified 2026-07-07 before launching or reading `smooth_qd_v2_6x7`.

Comparator root:

`exp/useful_bd_push/t79_budget_shape_ablation_20260624_043841_UTC/live/classic_revolution_6x7/seed_1001`

## Result

| Metric | Value |
| --- | --- |
| mean HV | `0.1700994814185665` |
| mean HV-AUC | `0.146221021526` |
| coverage | `8/8` |
| mean Pareto points | `2.625` |
| candidates | `222` |
| LLM API calls | `768` |
| single_thought_count | `0` |
| operator audit | `pass` |
| run validation | `pass` |

The fresh recompute agrees with the archived T79 package row for mean HV
(`0.1700994814185665`). N04 may use this as the seed-1001 6x7 classic
comparator.
