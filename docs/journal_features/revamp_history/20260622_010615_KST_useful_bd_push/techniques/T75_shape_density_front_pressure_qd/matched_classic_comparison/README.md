# T75 Matched Classic Comparison

This compact package compares T75 against classic, T73, T74, and related
hard/tuning runs on the same 13-problem reference-complete subset.

## Decision

`T0 positive_diagnostic_not_promoted`.

T75 improves over T74 and slightly over T73 on mean HV, and it has more
valid-PPA samples than classic. It is not promoted because classic remains the
overall multi-objective winner.

## Key Files

| Path | Purpose |
| --- | --- |
| `results_report.md` | Main interpretation and tier decision. |
| `tables/aggregate_backend_metrics.csv` | Mean HV, Pareto points, ref-beating count, and HV wins by backend. |
| `tables/backend_problem_metrics.csv` | Per-problem Pareto/HV metrics. |
| `tables/t75_ppa_completeness.csv` | Reference and candidate PPA completeness gate. |
| `tables/t75_direct_comparisons.csv` | Direct pairwise T75 deltas versus classic, T73, and T74. |
| `data/ppa_candidates.csv` | Compact raw candidate PPA table used for regeneration. |
| `figures/t75_hv_delta_by_problem.png` | Classic-vs-T75 HV delta summary. |
| `figures/t75_valid_ppa_counts.png` | Valid-PPA sample count summary. |

## Caveat

The full final-analysis bundle was interrupted during `design_space_analysis`
after the PPA and Pareto outputs were produced. The committed headline claims
use the completed PPA/Pareto artifacts only.
