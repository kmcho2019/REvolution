# T32 Artifacts Manifest

Status: completed live execution and packaging.

## Run

| Item | Value |
| --- | --- |
| Package | `T32_sr_raw_front_preserving_emitter_qd` |
| New arm | `sr_raw_front_preserving_emitter_qd` |
| Comparator roots | T30 `classic_revolution`, T30 `sr_raw_conservative_exploit_qd`, and T31 `sr_raw_fail_feedback_repair_qd` |
| Resolved T32 run root | `exp/useful_bd_push/t32_sr_raw_front_preserving_emitter_qd_20260622_010749_UTC/` |
| T30 comparator root | `exp/useful_bd_push/t30_t26_holdout_front_audit_20260621_233506_UTC/` |
| T31 comparator root | `exp/useful_bd_push/t31_sr_raw_fail_feedback_repair_qd_20260622_002953_UTC/` |
| Seed | `1001` |
| Model | `openai/gpt-oss-120b` |
| Endpoint | `http://20.0.0.103:8000/v1` |
| Token budget | `--max_tokens 128000 --diff_max_tokens 128000` |
| Benchmark | `VerilogEval-Spec-to-RTL` |
| Problems | `Prob150_review2015_fsmonehot`, `Prob098_circuit7`, `Prob135_m2014_q6b` |
| Primary command | `commands/live_holdout_v0.md` |
| Runtime | `651.99` seconds |
| Package command | `PYTHONPATH=.:src python scripts/package_t32_front_preserving_emitter_audit.py` |

## External Run Artifacts

| Artifact | SHA256 |
| --- | --- |
| `exp/useful_bd_push/t32_sr_raw_front_preserving_emitter_qd_20260622_010749_UTC/preflight/models_20260622_010749_UTC.json` | `7d8b34a5a79ff1baaf4e44abcaf898e07eb879100ec07541304b8344ccddc8c4` |
| `exp/useful_bd_push/t32_sr_raw_front_preserving_emitter_qd_20260622_010749_UTC/logs/sr_raw_front_preserving_emitter_qd_seed_1001.log` | `becaa754bbbaed5b96b6dd57eeaff907f6ab1f964b889380f4493899faa2df11` |
| `exp/useful_bd_push/t32_sr_raw_front_preserving_emitter_qd_20260622_010749_UTC/sr_raw_front_preserving_emitter_qd/seed_1001/openai_gpt-oss-120b/20260622_010751_revolution_summary_results.txt` | `2f82b23cf110cb87f238aff14a4554082a5af72b419605841370dcfecd8c4051` |
| `exp/useful_bd_push/t32_sr_raw_front_preserving_emitter_qd_20260622_010749_UTC/sr_raw_front_preserving_emitter_qd/seed_1001/openai_gpt-oss-120b/20260622_010751_revolution_scheduler_telemetry.json` | `7814f3ba7f7e11b4508093e8962cb8d916fd06cc133f2f778a2f46f793a82a93` |
| `exp/useful_bd_push/t32_sr_raw_front_preserving_emitter_qd_20260622_010749_UTC/pareto_front_validation.json` | `a2c73dbe4080d60c9daaa686bae943acbaa675fafcd6904198af596f812af68c` |

## Committed Package Artifacts

- `tables/preflight_models_20260622_010749_UTC.json`
- `tables/t32_holdout_pareto_validation.json`
- `tables/t32_holdout_pareto_validation.md`
- `tables/t32_holdout_live_problem_metrics.csv`
- `tables/t32_holdout_live_aggregate_metrics.csv`
- `tables/t32_holdout_live_comparison_deltas.csv`
- `tables/t32_holdout_family_candidate_rows.csv`
- `tables/t32_holdout_family_problem_metrics.csv`
- `tables/t32_holdout_family_aggregate_metrics.csv`
- `tables/t32_holdout_family_comparison_deltas.csv`
- `tables/t32_holdout_method_manifest.csv`
- `figures/t32_holdout_ppa_pareto_area_power_candidate_zoom.png`
- `figures/t32_holdout_ppa_pareto_area_power.png`
- `figures/t32_holdout_ppa_fronts_improvement.png`
- `figures/t32_holdout_ppa_fronts_area_power_zoom.png`
- `figures/t32_holdout_live_aggregate.png`
- `figures/t32_holdout_problem_counts.png`
- `figures/t32_holdout_family_counts.png`
- `results_report.md`
- `figures/visual_inspection_notes.md`
