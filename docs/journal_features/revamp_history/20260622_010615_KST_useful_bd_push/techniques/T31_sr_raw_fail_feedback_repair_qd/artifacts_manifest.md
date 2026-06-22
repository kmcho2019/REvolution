# T31 Artifacts Manifest

Status: pre-registered, pending live execution.

## Planned Run

| Item | Value |
| --- | --- |
| Package | `T31_sr_raw_fail_feedback_repair_qd` |
| New arm | `sr_raw_fail_feedback_repair_qd` |
| Comparator roots | T30 `classic_revolution` and `sr_raw_conservative_exploit_qd` |
| Planned run root | `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_<RUN_TS>/` |
| Seed | `1001` |
| Model | `openai/gpt-oss-120b` |
| Endpoint | `http://20.0.0.103:8000/v1` |
| Token budget | `--max_tokens 128000 --diff_max_tokens 128000` |
| Benchmark | `VerilogEval-Spec-to-RTL` |
| Problems | `Prob150_review2015_fsmonehot`, `Prob098_circuit7`, `Prob135_m2014_q6b` |
| Primary command | `commands/live_holdout_v0.md` |

## Expected Committed Artifacts

- copied `/v1/models` preflight metadata with SHA256;
- runner log and summary references with SHA256;
- run matrix with resolved T31 root and status;
- T31 Pareto archive validation report;
- direct raw PPA-front figures and visual inspection notes;
- candidate-level and aggregate result tables;
- `results_report.md` with T0/T1/T2/T3 decision.

Hashes and exact paths will be filled after execution and packaging.
