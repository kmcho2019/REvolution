# Artifacts Manifest

## Commands

| Artifact | Description |
| --- | --- |
| `commands/rf_timing_gate_v0.md` | Exact isolated uv command. |
| `tools/run_t81_rf_timing_gate.py` | Reproducer script. |

## Tables

| Artifact | Description |
| --- | --- |
| `tables/t81_candidate_timing_summary.csv` | Per-candidate coverage, timing-path, prediction, leaf, and feature-range summary. |
| `tables/t81_path_feature_rows.csv` | Raw path-feature rows sent to the pretrained RF model. |
| `tables/t81_rf_timing_summary.json` | Aggregate variation and model metadata summary. |

## Figures

| Artifact | Description |
| --- | --- |
| `figures/t81_rf_timing_state_gate.png` | Inspected summary plot of path coverage and unique RF leaf rows. |

## External Inputs

| Artifact | Description |
| --- | --- |
| `exp/external_repos/MasterRTL` | MasterRTL clone at commit `5bccf38f8db7bb511a793a709863e7cb1b333ab5`. |
| `exp/external_repos/MasterRTL/ML_model/saved_model/rfr_model.pkl` | Saved MasterRTL RF timing model loaded with `joblib`. |
| `exp/external_repos/MasterRTL/ML_model/saved_data/feat_all_lst.pkl` | Saved RF training feature matrix used for feature-range diagnostics. |
| `techniques/T70_generated_rtl_extractor_smoke/tables/t70_extractor_results.csv` | Generated-candidate source-aligned SOG corpus. |
