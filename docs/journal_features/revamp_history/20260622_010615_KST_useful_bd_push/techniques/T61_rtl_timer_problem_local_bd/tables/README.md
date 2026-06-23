# T61 Tables

| File | Rows | Purpose |
| --- | ---: | --- |
| `rtl_timer_features.csv` | 670 | Candidate-level RTL timing-risk proxy features with problem-local timing-risk cells. |
| `timing_risk_archive_metrics.csv` | 2 | Pooled timing-risk cell and front-cell counts for Classic and exact T26 QD. |
| `problem_metrics.csv` | 74 | Per-method/problem timing-risk cell counts and risk summaries. |
| `comparison_deltas.csv` | 31 | Paired exact T26 minus Classic timing-risk deltas on headline paired-PPA problems. |
| `ppa_completeness.csv` | 50 | Full RTLLM candidate/reference PPA completeness table. |

This package reuses the T60 feature extractor but changes cell assignment from
global quantiles to problem-local quantiles.
