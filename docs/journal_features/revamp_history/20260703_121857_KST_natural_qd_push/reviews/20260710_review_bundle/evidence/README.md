# Evidence Guide And Provenance

Every copied file is a snapshot of a canonical repository file as of
2026-07-10. The conference Markdown copy has trailing whitespace normalized;
all other evidence/source copies are byte-identical. Use the canonical path
when checking later updates.

| Bundle path | Canonical source | Why included |
| --- | --- | --- |
| `governing/revamp_ruminations_20260612.md` | `docs/journal_features/revamp_ruminations_20260612.md` | Original journal intent and reviewer criticisms |
| `governing/journal_narrative.md` | `docs/journal_features/journal_narrative.md` | Accepted claims and measurement contract |
| `governing/13_findings_dashboard.md` | `docs/journal_features/13_findings_dashboard.md` | Current result inventory |
| `governing/14_narrative_posture_assessment.md` | `docs/journal_features/14_narrative_posture_assessment.md` | Candid manuscript posture |
| `governing/conference_paper.md` | `docs/REvolution_evolutionary_framework_for_RTL_generation_driven_by_LLMs.md` | Conference method and claims |
| `results/central_comparison_report.md` | `natural_qd_push/central_comparison_report.md` | Operator-fair two-scale result |
| `results/followup_decision_map.md` | `natural_qd_push/followup_decision_map.md` | Post-N10 mechanism map |
| `results/suite_campaign_README.md` | `natural_qd_push/suite_variant_campaign/README.md` | Current suite-first state |
| `results/variant_registry.csv` | `natural_qd_push/suite_variant_campaign/variant_registry.csv` | All registered suite variants |
| `results/s07_five_seed_summary.md` | `suite_variant_campaign/S07_capacity3/five_seed_analysis/summary.md` | Strongest current QD near miss |
| `results/s07_seed_paired_deltas.csv` | S07 five-seed package | Seed-level evidence |
| `results/s07_per_problem_win_loss_map.csv` | S07 five-seed package | Problem-level evidence |
| `results/s07_statistical_tests.json` | S07 five-seed package | Descriptive tests |
| `results/s32_results_report.md` | `suite_variant_campaign/S32_capacity4/seed_1001/results_report.md` | Capacity interpolation closure |
| `results/negative_map_validation.md` | `natural_qd_push/negative_map_adversarial_validation_report.md` | Adversarial PASS on the negative map |
| `operator_ablation/classic_no_cf_report.md` | June-22 PCN-v3 detailed report | Five-seed C-F control and PCN closure |
| `operator_ablation/comparison_summary.csv` | PCN-v3 table | Paired C-F deltas and intervals |
| `infrastructure/realbench_reference_ppa.md` | `docs/journal_features/realbench_reference_ppa.md` | Large-design PPA and verification state |
| `infrastructure/experimental_setup.md` | June-22 useful-BD push setup | Runtime and reproducibility rules |
| `infrastructure/v2_platform_config.md` | `natural_qd_push/tables/v2_platform_config.md` | Exact operator-fair QD platform |

Raw run roots remain under `exp/natural_qd_push/` and
`exp/useful_bd_push/`. They are not copied because of size.
