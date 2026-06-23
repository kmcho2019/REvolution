# T15 Yosys-SOG Proxy Audit Commands

Generate the candidate-level Yosys-SOG descriptor package:

```bash
uv run python scripts/package_yosys_sog_audit.py \
  --candidate-rows docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/family_audit/tables/full_family_candidate_rows.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T15_masterrtl_sog_bd \
  --cell-scope problem
```

Add the corrected full-RTLLM PPA completeness table:

```bash
uv run python scripts/report_ppa_completeness.py \
  --ppa-candidates exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/qd_ppa_viewer_source_full/final_analysis/ppa_distribution/data/ppa_candidates.csv \
  --reference-ppa-metrics exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/qd_ppa_viewer_source_full/final_analysis/ppa_distribution/data/reference_ppa_metrics.csv \
  --problem-manifest docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/data/rtllm_50_problem_manifest.csv \
  --manifest-references-complete \
  --classic-method classic \
  --qd-method sr_raw_conservative_exploit_qd \
  --reference-missing-problem RTLLM:Prob006_adder_pipe_64bit \
  --reference-missing-problem RTLLM:Prob013_multi_booth_8bit \
  --reference-missing-problem RTLLM:Prob018_float_multi \
  --reference-missing-problem RTLLM:Prob040_synchronizer \
  --output docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T15_masterrtl_sog_bd/tables/ppa_completeness.csv
```
