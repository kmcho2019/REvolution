# T32 Tables

Status: generated.

| Table | Purpose |
| --- | --- |
| `holdout_screen_v0_subset.yaml` | Frozen VerilogEval holdout subset reused from T30/T31. |
| `run_matrix.csv` | Comparator roots, fixed runtime parameters, and resolved T32 arm. |
| `preflight_models_20260622_010749_UTC.json` | `/v1/models` preflight response for `openai/gpt-oss-120b`. |
| `t32_holdout_pareto_validation.json` / `.md` | Pareto archive validation for the T32 arm. |
| `t32_holdout_live_problem_metrics.csv` | Per-problem live metrics for classic, T26, T31, and T32. |
| `t32_holdout_live_aggregate_metrics.csv` | Aggregate live metrics. |
| `t32_holdout_live_comparison_deltas.csv` | Deltas versus classic. |
| `t32_holdout_family_candidate_rows.csv` | Candidate-level raw PPA, front membership, hashes, and family signatures used to regenerate figures. |
| `t32_holdout_family_problem_metrics.csv` | Per-problem canonical family/netlist counts. |
| `t32_holdout_family_aggregate_metrics.csv` | Aggregate canonical family/netlist counts. |
| `t32_holdout_family_comparison_deltas.csv` | Family/netlist deltas versus classic. |
| `t32_holdout_method_manifest.csv` | Source roots for all four compared methods. |

Important rows:

- T32 valid PPA is `67`, versus classic `103`, T26 `68`, and T31 `56`.
- T32 P098 valid PPA is `19`, better than T26 `15` and T31 `14`, but still
  below classic `31`.
- T32 mean final-best score is `0.201770`, matching T31 and below T26
  `0.246463`.
- T32 mean HV and HV-AUC are both `0`, while T26 has `0.066206` and
  `0.016552`.
