# T30 Tables

Status: generated from the live run.

| Table | Purpose |
| --- | --- |
| `holdout_screen_v0_subset.yaml` | Fixed three-problem VerilogEval holdout screen. |
| `run_matrix.csv` | Resolved classic and T26 holdout arms, parameters, run roots, and status. |
| `preflight_models_20260621_233506_UTC.json` | `/v1/models` preflight response for the local `openai/gpt-oss-120b` vLLM endpoint. |
| `t30_holdout_method_manifest.csv` | Source run root, backend mode, benchmark, and method label for each arm. |
| `t30_holdout_live_problem_metrics.csv` | Per-problem live metrics: valid PPA counts, reference PPA, final-best score, HV, HV AUC, front counts, and unique PPA points. |
| `t30_holdout_live_aggregate_metrics.csv` | Aggregate live metrics used in the result report. |
| `t30_holdout_live_comparison_deltas.csv` | T26-vs-classic deltas for aggregate live metrics. |
| `t30_holdout_family_candidate_rows.csv` | Candidate-level raw PPA metrics, hashes, family signatures, front flags, and code paths. This table regenerates the direct PPA-front plots. |
| `t30_holdout_family_problem_metrics.csv` | Per-problem canonical RTL/netlist/family duplicate accounting. |
| `t30_holdout_family_aggregate_metrics.csv` | Aggregate canonical family/netlist metrics. |
| `t30_holdout_family_comparison_deltas.csv` | T26-vs-classic deltas for family/netlist metrics. |
| `holdout_t26_pareto_validation.json` | Machine-readable T26 Pareto archive validation report. |
| `holdout_t26_pareto_validation.md` | Human-readable T26 Pareto archive validation report. |

The direct raw PPA Pareto figures are generated from
`t30_holdout_family_candidate_rows.csv` plus the reference area/power columns
in `t30_holdout_live_problem_metrics.csv`.
