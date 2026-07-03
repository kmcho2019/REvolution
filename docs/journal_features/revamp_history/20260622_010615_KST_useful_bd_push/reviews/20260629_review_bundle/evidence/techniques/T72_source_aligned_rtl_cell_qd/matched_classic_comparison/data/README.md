# Data

These CSVs are the compact raw analysis inputs retained for regeneration.

| File | Meaning |
| --- | --- |
| `ppa_candidates.csv` | Candidate-level PPA rows from the matched final-analysis bundle. |
| `reference_ppa_metrics.csv` | Benchmark reference PPA rows. |
| `best_candidate_by_backend_problem.csv` | Best candidate rows by backend and problem. |

Missing candidate PPA is counted as method invalid/non-PPA. Missing reference
PPA would make a problem diagnostic-only for normalized comparison, but this
T72 matched subset has valid reference PPA for every problem.
