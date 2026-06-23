# T60 Tables

| File | Rows | Purpose |
| --- | ---: | --- |
| `rtl_timer_features.csv` | 670 | Candidate-level RTL timing-risk proxy features extracted before any PPA/front reporting. |
| `timing_risk_archive_metrics.csv` | 2 | Pooled timing-risk cell and front-cell counts for Classic and exact T26 QD. |
| `problem_metrics.csv` | 74 | Per-method/problem timing-risk cell counts and risk summaries. |
| `comparison_deltas.csv` | 31 | Paired exact T26 minus Classic timing-risk deltas on headline paired-PPA problems. |
| `ppa_completeness.csv` | 50 | Full RTLLM candidate/reference PPA completeness table. |

The first T60 proxy is diagnostic only. It does not include live archive
artifacts, a direct PPA viewer, or a Phase 03.1 viewer because no new live QD
run was launched for this descriptor.
