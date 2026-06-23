# T61 RTLTimer Problem-Local BD Artifacts Manifest

Status: `T0 positive_proxy_not_promoted`.

## Source Inputs

- Candidate table:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/family_audit/tables/full_family_candidate_rows.csv`
- PPA candidates:
  `exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/qd_ppa_viewer_source_full/final_analysis/ppa_distribution/data/ppa_candidates.csv`
- Reference PPA metrics:
  `exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/qd_ppa_viewer_source_full/final_analysis/ppa_distribution/data/reference_ppa_metrics.csv`
- Problem manifest:
  `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/data/rtllm_50_problem_manifest.csv`

No external RTLTimer checkout was used. T61 is a problem-local binning ablation
over the lightweight T60 timing-risk proxy.

## Generated Artifacts

- `tables/rtl_timer_features.csv`
- `tables/timing_risk_archive_metrics.csv`
- `tables/problem_metrics.csv`
- `tables/comparison_deltas.csv`
- `tables/ppa_completeness.csv`
- `figures/timing_risk_projection.png`
- `figures/visual_inspection_notes.md`
- `commands/problem_local_proxy_audit.md`

## Hashes

| Artifact | SHA-256 |
| --- | --- |
| `scripts/package_rtl_timer_timing_risk_audit.py` | `46d337539e771390d353201482cf8ba0694a2e5da0ca18c0ca03ef3e56aff73a` |
| `tables/rtl_timer_features.csv` | `06bff42817b719b7a2a3e13e64d872c29e344d341e53c87811b905f73ad5b593` |
| `figures/timing_risk_projection.png` | `fe333aaaa4591eedf3cbf3dabc4943f5904ec08cddf373ee17cb7161ae6d3d63` |

Feature schema SHA-256:
`708de7cb22f066fa7efd9d41af50113416d0690f3a356b39e9dbe03ee6be6f22`.

## Validation

- `uv run pytest tests/scripts/test_package_rtl_timer_timing_risk_audit.py`
- `uv run ruff check scripts/package_rtl_timer_timing_risk_audit.py tests/scripts/test_package_rtl_timer_timing_risk_audit.py`
- `uv tool run ty check scripts/package_rtl_timer_timing_risk_audit.py tests/scripts/test_package_rtl_timer_timing_risk_audit.py`
- `uv run pyright scripts/package_rtl_timer_timing_risk_audit.py tests/scripts/test_package_rtl_timer_timing_risk_audit.py`

This package is not a live QD claim. It is a proxy ablation that justifies
trying true RTLTimer/MasterRTL problem-local cells in a future live screen.
