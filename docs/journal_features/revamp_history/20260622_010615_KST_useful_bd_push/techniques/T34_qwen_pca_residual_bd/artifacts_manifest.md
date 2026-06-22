# T34 Qwen PCA-Residual Artifacts Manifest

Status: pre-registered. Run artifacts are pending.

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

## Pending Hashes

| Artifact | SHA256 |
| --- | --- |
| replay script | pending |
| replay aggregate table | pending |
| direct PPA-front figure | pending |
| visual inspection notes | pending |
