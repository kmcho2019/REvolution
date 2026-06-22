# T31 Tables

Status: generated.

| Table | Purpose |
| --- | --- |
| `holdout_screen_v0_subset.yaml` | Frozen VerilogEval holdout subset reused from T30. |
| `run_matrix.csv` | Comparator roots, fixed runtime parameters, and resolved T31 arm. |
| `preflight_models_20260622_002953_UTC.json` | Captured `/v1/models` metadata for the live run. |
| `t31_holdout_pareto_validation.json` / `.md` | T31 Pareto archive validation output. |
| `t31_holdout_live_problem_metrics.csv` | Per-problem live metrics for classic, T26, and T31. |
| `t31_holdout_live_aggregate_metrics.csv` | Aggregate valid-PPA, final-best coverage, HV, HV-AUC, and front counts. |
| `t31_holdout_live_comparison_deltas.csv` | T26 and T31 deltas versus classic. |
| `t31_holdout_family_candidate_rows.csv` | Candidate-level raw PPA, hashes, family signatures, and front flags. |
| `t31_holdout_family_problem_metrics.csv` | Per-problem canonical family/netlist metrics. |
| `t31_holdout_family_aggregate_metrics.csv` | Aggregate family/netlist metrics. |
| `t31_holdout_family_comparison_deltas.csv` | Family/netlist deltas versus classic. |
| `t31_holdout_method_manifest.csv` | Source roots for all three compared arms. |

Primary read: T31 preserves final-best coverage on all three holdout problems
but drops aggregate valid PPA to `56`, leaves P098 at `14` valid PPA samples,
and has zero mean normalized HV/HV-AUC.
