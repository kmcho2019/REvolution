# T34 Qwen PCA-Residual Artifacts Manifest

Status: completed `T0 diagnostic`.

## Inputs

| Artifact | Role |
| --- | --- |
| `techniques/T33_qwen3_preprocessing_ladder_bd/tables/t33_embedding_cache_manifest.csv` | Source Qwen embedding matrices. |
| `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv` | Common 768-candidate replay surface. |
| `techniques/T33_qwen3_preprocessing_ladder_bd/tables/t33_replay_aggregate.csv` | T33 baseline comparison table. |

## Output Root

T34 writes compact committed tables and figures under this package. Any large
intermediate arrays must live under:

`exp/useful_bd_push/t34_qwen_pca_residual_bd_<timestamp>/`

Do not write new artifacts under `/aux`.

## Committed Tables

| Artifact | Rows | SHA256 |
| --- | ---: | --- |
| `tables/t34_replay_rows.csv` | 2850 | `f423bb5a1ece945cc6db809d559f071bb2106bc9cf07eb646bfa2d0c26a0ea70` |
| `tables/t34_replay_aggregate.csv` | 25 | `156145eea26d3be0a19d047724d06de66b5f04738772a8f8260d9ed8f525ef50` |
| `tables/t34_selected_candidates.csv` | 8525 | `e896bc61142b0b4e1caa437fff3d591397c3e119b482df90ab339b6406213a2d` |
| `tables/t34_ppa_front_metrics.csv` | 25 | `f8112bbcd1cc73f578684d1b7996e95f821ba76e28e87d69aaf22bfeb698df1a` |
| `tables/t34_collapse_metrics.csv` | 21 | `d6e9318b07c5546f4319fa524ae32434ed61c2f0e971cf4a1dbebaa4447caee3` |
| `tables/t34_vs_controls.csv` | 25 | `9a59084b5c4049581c6b7615bfa410c2b4558f078c0d632baba5bb3474bebf66` |

## Committed Figures

| Artifact | Role | SHA256 |
| --- | --- | --- |
| `figures/t34_raw_area_power_pareto_front.png` | Direct raw area-power PPA front. | `ee010a2a9b5630dc498cba9ea9013db7b4bd1771a7c12947b075df65329caf16` |
| `figures/t34_hypervolume_by_projection.png` | Selected-HV bar chart for top projections. | `66d967bfb360594d46ef059e2099f176dfa0e272762d4dbdd45e41bbe8ef733b` |
| `figures/t34_collapse_vs_hypervolume.png` | Same-problem collapse versus selected HV. | `327f026b648e648c79cf10954ecf3747ec224ba4c3ec8264188e92a032537878` |

## Script Hashes

| Artifact | SHA256 |
| --- | --- |
| `scripts/analyze_t34_qwen_pca_residual.py` | `500d5e251534ce310c5270533bbdc79758d928472ddcc1784efb722e20075a94` |
| `tests/scripts/test_analyze_t34_qwen_pca_residual.py` | `e063c6ed5587098ac684ea6557e9a6adbf4951691852757751666b871cade94c` |
