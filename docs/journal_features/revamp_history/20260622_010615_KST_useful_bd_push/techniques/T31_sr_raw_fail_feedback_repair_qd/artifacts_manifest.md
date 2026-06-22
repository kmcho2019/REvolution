# T31 Artifacts Manifest

Status: completed live execution and packaging.

## Run

| Item | Value |
| --- | --- |
| Package | `T31_sr_raw_fail_feedback_repair_qd` |
| New arm | `sr_raw_fail_feedback_repair_qd` |
| Comparator roots | T30 `classic_revolution` and `sr_raw_conservative_exploit_qd` |
| Resolved T31 run root | `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_20260622_002953_UTC/` |
| T30 comparator root | `exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/` |
| Seed | `1001` |
| Model | `openai/gpt-oss-120b` |
| Endpoint | `http://20.0.0.103:8000/v1` |
| Token budget | `--max_tokens 128000 --diff_max_tokens 128000` |
| Benchmark | `VerilogEval-Spec-to-RTL` |
| Problems | `Prob150_review2015_fsmonehot`, `Prob098_circuit7`, `Prob135_m2014_q6b` |
| Primary command | `commands/live_holdout_v0.md` |
| Runtime | `681.97` seconds |
| Package command | `python -m scripts.package_t31_holdout_repair_audit` |

## External Run Artifacts

| Artifact | SHA256 |
| --- | --- |
| `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_20260622_002953_UTC/preflight/models_20260622_002953_UTC.json` | `a166b2664f832ab1333b608e3d32aef36170a53a6572d569cfdb3d2ff92d33e3` |
| `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_20260622_002953_UTC/logs/sr_raw_fail_feedback_repair_qd_seed_1001.log` | `b9d5dcf5d53a8a227b1c26e1878a82bc779164fc9c64539fe3f8b929e5a23446` |
| `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_20260622_002953_UTC/sr_raw_fail_feedback_repair_qd/seed_1001/openai_gpt-oss-120b/20260622_002955_revolution_summary_results.txt` | `b60bbb5b5f504b87e4448431ed87386c43ad19468743350f1ea36abb4a6ad1c3` |
| `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_20260622_002953_UTC/sr_raw_fail_feedback_repair_qd/seed_1001/openai_gpt-oss-120b/20260622_002955_revolution_scheduler_telemetry.json` | `c02b3924485ce6994830a84ceec8176b406a8bf05da3dea6cdab308829185164` |
| `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_20260622_002953_UTC/pareto_front_validation.json` | `94ebacebde1fd32e3784b754177170060d29885bdf32f6f32824222817d714c4` |

## Committed Package Artifacts

- `tables/preflight_models_20260622_002953_UTC.json`
- `tables/t31_holdout_pareto_validation.json`
- `tables/t31_holdout_pareto_validation.md`
- `tables/t31_holdout_live_problem_metrics.csv`
- `tables/t31_holdout_live_aggregate_metrics.csv`
- `tables/t31_holdout_live_comparison_deltas.csv`
- `tables/t31_holdout_family_candidate_rows.csv`
- `tables/t31_holdout_family_problem_metrics.csv`
- `tables/t31_holdout_family_aggregate_metrics.csv`
- `tables/t31_holdout_family_comparison_deltas.csv`
- `tables/t31_holdout_method_manifest.csv`
- `figures/t31_holdout_ppa_pareto_area_power_candidate_zoom.png`
- `figures/t31_holdout_ppa_pareto_area_power.png`
- `figures/t31_holdout_ppa_fronts_improvement.png`
- `figures/t31_holdout_ppa_fronts_area_power_zoom.png`
- `figures/t31_holdout_live_aggregate.png`
- `figures/t31_holdout_problem_counts.png`
- `figures/t31_holdout_family_counts.png`
- `results_report.md`
- `figures/visual_inspection_notes.md`
