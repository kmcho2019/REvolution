# T60 RTLTimer Timing-Risk BD Artifacts Manifest

Status: `T0 diagnostic_proxy`.

## Source Inputs

- Candidate table:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/family_audit/tables/full_family_candidate_rows.csv`
- PPA candidates:
  `exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/qd_ppa_viewer_source_full/final_analysis/ppa_distribution/data/ppa_candidates.csv`
- Reference PPA metrics:
  `exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/qd_ppa_viewer_source_full/final_analysis/ppa_distribution/data/reference_ppa_metrics.csv`
- Problem manifest:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/data/rtllm_50_problem_manifest.csv`

No external RTLTimer checkout was used in this first package. This is a
lightweight RTLTimer-style proxy over existing RTL text, intended to decide
whether the RTL-native timing-risk lane is worth escalating to a true RTLTimer
or MasterRTL/SOG extractor.

## Generated Artifacts

- `tables/rtl_timer_features.csv`
- `tables/timing_risk_archive_metrics.csv`
- `tables/problem_metrics.csv`
- `tables/comparison_deltas.csv`
- `tables/ppa_completeness.csv`
- `figures/timing_risk_projection.png`
- `figures/visual_inspection_notes.md`
- `commands/retrospective_proxy_audit.md`

## Hashes

| Artifact | SHA-256 |
| --- | --- |
| `scripts/package_rtl_timer_timing_risk_audit.py` | `a796b5aeba25b558331b4129d7de1d0b2750ce527f71914cb9288e76828b9c7c` |
| `tables/rtl_timer_features.csv` | `1dbc85fe545c36f2d990ce5b588342414b9bc053dde6b66d5dc6ef1a9422dcc1` |
| `figures/timing_risk_projection.png` | `29ffffa7be3ae1028c2082e6de6ac93e4842691d09a6eed075a308e5b5e693e0` |

Feature schema SHA-256:
`708de7cb22f066fa7efd9d41af50113416d0690f3a356b39e9dbe03ee6be6f22`.

## Validation

- `uv run pytest tests/scripts/test_package_rtl_timer_timing_risk_audit.py`
- `uv run ruff check scripts/package_rtl_timer_timing_risk_audit.py tests/scripts/test_package_rtl_timer_timing_risk_audit.py`
- `uv tool run ty check scripts/package_rtl_timer_timing_risk_audit.py tests/scripts/test_package_rtl_timer_timing_risk_audit.py`
- `uv run pyright scripts/package_rtl_timer_timing_risk_audit.py tests/scripts/test_package_rtl_timer_timing_risk_audit.py`

No artifact is used for a headline QD claim. The result is a diagnostic proxy
audit and keeps missing/defaulted-reference designs labeled
`diagnostic_only`.
