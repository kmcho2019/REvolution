# T29 Artifacts Manifest

Status: complete live development-screen run; `T0 diagnostic`.

## Run

| Item | Value |
| --- | --- |
| Method | `sr_raw_front_recovery_qd` |
| Run root | `exp/useful_bd_push/t29_sr_raw_front_recovery_qd_20260621_225827_UTC/` |
| Command | `commands/live_screen_v0.md` |
| Seed | `1001` |
| Model | `openai/gpt-oss-120b` |
| Endpoint | `http://20.0.0.103:8000/v1` |
| Token budget | `--max_tokens 128000 --diff_max_tokens 128000` |
| Problems | `Prob045_alu`, `Prob041_traffic_light`, `Prob015_multi_pipe_8bit` |

## Source Artifacts

| Artifact | SHA256 |
| --- | --- |
| `exp/useful_bd_push/t29_sr_raw_front_recovery_qd_20260621_225827_UTC/preflight/models_20260621_225827_UTC.json` | `e98930533c8d5d811a3e53ab1ccf8df5e143fd08deb9279882a8880933bc1189` |
| `exp/useful_bd_push/t29_sr_raw_front_recovery_qd_20260621_225827_UTC/logs/sr_raw_front_recovery_qd_seed_1001.log` | `19bf75a7d02e01d2181ef5852d9b6a710872cc3c5634988f61726ea97a532ed5` |
| `exp/useful_bd_push/t29_sr_raw_front_recovery_qd_20260621_225827_UTC/sr_raw_front_recovery_qd/seed_1001/openai_gpt-oss-120b/20260621_225856_revolution_summary_results.txt` | `4df60ac8254cabdcb1a6117204d63b8306ac9adf40cd13e045f6bcc26a2f801f` |

## Committed Artifacts

| Artifact | Purpose |
| --- | --- |
| `tables/live_screen_v0_subset.yaml` | Fixed three-problem development screen shared with T24/T25/T26. |
| `tables/preflight_models_20260621_225827_UTC.json` | Copied `/v1/models` preflight response. |
| `tables/live_front_recovery_pareto_validation.json` | Machine-readable Pareto archive validation report. |
| `tables/live_front_recovery_pareto_validation.md` | Human-readable Pareto archive validation report. |
| `tables/t29_live_problem_metrics.csv` | Per-method, per-problem candidate-level PPA, HV, validity, and archive metrics. |
| `tables/t29_live_aggregate_metrics.csv` | Aggregate live metrics across the three-problem screen. |
| `tables/t29_live_comparison_deltas.csv` | T29 deltas versus classic, manual BD, random, SR raw, guarded SR raw, and T26. |
| `tables/t29_family_candidate_rows.csv` | Candidate-level canonical RTL/netlist/family rows used for duplicate accounting. |
| `tables/t29_family_problem_metrics.csv` | Per-problem family/front duplicate audit. |
| `tables/t29_family_aggregate_metrics.csv` | Aggregate family/front duplicate audit. |
| `tables/t29_family_comparison_deltas.csv` | T29 family-audit deltas versus controls. |
| `tables/t29_method_manifest.csv` | Source run roots and modes for every compared method. |
| `figures/t29_ppa_fronts_area_power_zoom.png` | Direct raw area-power PPA-front scatter plot. |
| `figures/t29_ppa_fronts_improvement.png` | Normalized area/power improvement-front scatter plot. |
| `figures/t29_live_problem_front_counts.png` | Front, reference-beating, and valid-PPA counts by problem. |
| `figures/t29_live_aggregate_metrics.png` | Aggregate live HV, HV-AUC, and front-count bars. |
| `figures/t29_family_aggregate_counts.png` | Aggregate family/front duplicate audit bars. |

Representative committed hashes:

| Artifact | SHA256 |
| --- | --- |
| `tables/t29_live_aggregate_metrics.csv` | `d53b8a84fb0c35f3018a38c3241ff3950281f68462c2c463360d3fb4d565708b` |
| `figures/t29_ppa_fronts_area_power_zoom.png` | `c1d6917ad14cf18e32dfed3f8e05ea70221042820b58f918ec76cb7497fbb0e3` |
