# T61 Problem-Local Proxy Audit Commands

This package is a diagnostic proxy audit over existing full-RTLLM valid-PPA
candidates. It is not a live QD run.

## Timing-Risk Feature Package

```bash
uv run python scripts/package_rtl_timer_timing_risk_audit.py \
  --candidate-rows docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/family_audit/tables/full_family_candidate_rows.csv \
  --cell-scope problem \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T61_rtl_timer_problem_local_bd
```

Output:

```text
feature_schema_sha256=708de7cb22f066fa7efd9d41af50113416d0690f3a356b39e9dbe03ee6be6f22
candidate_count=670
cell_scope=problem
```

## PPA Completeness

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
  --output docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T61_rtl_timer_problem_local_bd/tables/ppa_completeness.csv
```

Result: `50` problems, `31` headline rows, `15` candidate-missing rows, and
`4` diagnostic-only missing-reference rows.
