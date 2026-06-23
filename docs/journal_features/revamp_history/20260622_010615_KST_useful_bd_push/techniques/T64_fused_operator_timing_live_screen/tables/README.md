# T64 Tables

| Table | Purpose |
| --- | --- |
| `hard_tuning_subset.yaml` | Frozen 13-problem comparator surface inherited from T63. |
| `descriptor_probe_fused_rtl_operator_timing_2d.json` | Runtime descriptor-axis probe proving the profile uses graph and RTL metrics, not PPA. |
| `../hard_tuning_package/tables/t64_problem_seed_metrics.csv` | Per-problem seed metrics after the live run. |
| `../hard_tuning_package/tables/t64_aggregate_metrics.csv` | Aggregate classic-vs-T64 metrics. |
| `../hard_tuning_package/tables/t64_validity_gates.csv` | Small-n-aware validity gate table. |
| `../hard_tuning_package/tables/t64_ppa_completeness.csv` | Reference-complete comparison eligibility table. |

All 13 T64 hard/tuning rows are reference-complete `headline` rows. Missing
candidate PPA remains method-invalid data; missing reference PPA would make a
row diagnostic-only, but none are present in this subset.
