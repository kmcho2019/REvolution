# T29 Artifacts Manifest

Status: pre-registered, pending live execution.

## Planned Run

| Item | Value |
| --- | --- |
| Method | `sr_raw_front_recovery_qd` |
| Run root | `exp/useful_bd_push/t29_sr_raw_front_recovery_qd_<RUN_TS>/` |
| Command | `commands/live_screen_v0.md` |
| Seed | `1001` |
| Model | `openai/gpt-oss-120b` |
| Endpoint | `http://20.0.0.103:8000/v1` |
| Token budget | `--max_tokens 128000 --diff_max_tokens 128000` |
| Problems | `Prob045_alu`, `Prob041_traffic_light`, `Prob015_multi_pipe_8bit` |

## Expected Committed Artifacts

- `/v1/models` preflight metadata path and SHA256;
- run command log path and SHA256;
- packaged comparison tables;
- direct PPA-front figures;
- duplicate/family accounting tables and figures;
- `results_report.md` with tier decision;
- visual inspection notes.

Hashes and exact paths will be filled after the run completes and outputs are
packaged.
