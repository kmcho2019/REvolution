# T30 Artifacts Manifest

Status: pre-registered, pending live execution.

## Planned Run

| Item | Value |
| --- | --- |
| Package | `T30_t26_holdout_front_audit` |
| Arms | `classic_revolution`, `sr_raw_conservative_exploit_qd` |
| Planned run root | `exp/useful_bd_push/t30_t26_holdout_front_audit_<RUN_TS>/` |
| Command | `commands/live_holdout_v0.md` |
| Seed | `1001` |
| Model | `openai/gpt-oss-120b` |
| Endpoint | `http://20.0.0.103:8000/v1` |
| Token budget | `--max_tokens 128000 --diff_max_tokens 128000` |
| Benchmark | `VerilogEval-Spec-to-RTL` |
| Problems | `Prob150_review2015_fsmonehot`, `Prob098_circuit7`, `Prob135_m2014_q6b` |

## Expected Committed Artifacts

- copied `/v1/models` preflight metadata with SHA256;
- copied or referenced runner logs with SHA256;
- fixed holdout subset YAML;
- run matrix with resolved run root and status;
- Pareto archive validation report for the T26 arm;
- packaged direct PPA-front tables and figures;
- canonical RTL/netlist/family duplicate audit tables and figures;
- visual inspection notes;
- `results_report.md` with a T0/T1/T2/T3 tier decision.

Hashes and exact paths will be filled after the run completes and outputs are
packaged.
