# T29 Tables

| Table | Purpose |
| --- | --- |
| `run_matrix.csv` | Live arm, fixed parameters, resolved run root, and result status. |
| `live_screen_v0_subset.yaml` | Fixed three-problem development screen shared with T24/T25/T26. |
| `preflight_models_20260621_225827_UTC.json` | Local vLLM `/v1/models` preflight response for the live run. |
| `live_front_recovery_pareto_validation.json` | Machine-readable Pareto archive validation result. |
| `live_front_recovery_pareto_validation.md` | Human-readable Pareto archive validation result. |
| `t29_live_problem_metrics.csv` | Per-method, per-problem candidate-level PPA, HV, validity, and active archive metrics. |
| `t29_live_aggregate_metrics.csv` | Aggregate live metrics across the three-problem screen. |
| `t29_live_comparison_deltas.csv` | T29 live deltas versus classic, manual BD, random, SR raw, guarded SR raw, and T26. |
| `t29_family_candidate_rows.csv` | Candidate-level canonical RTL/netlist/family data used for duplicate accounting and direct-front plots. |
| `t29_family_problem_metrics.csv` | Per-problem canonical/family front metrics. |
| `t29_family_aggregate_metrics.csv` | Aggregate canonical/family front metrics. |
| `t29_family_comparison_deltas.csv` | T29 family-audit deltas versus controls. |
| `t29_method_manifest.csv` | Source run root and mode for each compared method. |

Important caveat: `t29_live_problem_metrics.csv` distinguishes
candidate-level valid PPA from active archive members. T29 has six
candidate-level valid PPA samples on `Prob015_multi_pipe_8bit`, but the
Pareto archive validator reports zero active archive members for that problem.
