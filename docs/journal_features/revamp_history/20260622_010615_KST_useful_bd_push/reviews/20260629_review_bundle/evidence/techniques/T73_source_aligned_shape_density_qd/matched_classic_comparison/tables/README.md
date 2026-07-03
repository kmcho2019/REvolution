# Tables

| File | Meaning |
| --- | --- |
| `aggregate_backend_metrics.csv` | Aggregate HV, Pareto points, reference-beating count, and HV wins. |
| `backend_problem_metrics.csv` | Per-problem Pareto metrics for classic and T73. |
| `t73_ppa_completeness.csv` | Headline eligibility table for reference and candidate PPA completeness. |
| `backend_comparison.md` | Detailed final-analysis comparison report. |
| `pareto_report.md` | Detailed Pareto report. |
| `final_analysis_summary.json` | Machine-readable final-analysis summary. |
| `pareto_summary.json` | Machine-readable Pareto summary. |

`Prob151_review2015_fsm` is marked `headline` for candidate-PPA completeness
because both methods have PPA rows, but its T73 live archive summary failed
and has zero archive members. Treat it as an archive-health warning.
