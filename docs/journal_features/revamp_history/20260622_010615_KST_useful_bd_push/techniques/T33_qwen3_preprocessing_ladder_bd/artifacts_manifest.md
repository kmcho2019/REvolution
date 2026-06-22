# Qwen3 Preprocessing Ladder Artifacts Manifest

Status: pre-registered. Artifact hashes are pending.

## Source Evidence

| Artifact | Role |
| --- | --- |
| `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/` | Prior T06 Qwen raw/commentless/identifier embedding diagnostic. |
| `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T06_qwen_projection_bd/` | Current T06 methodology, results, figures, and required follow-up notes. |
| `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/tables/frozen_screening_subset.csv` | Frozen development-screen subset. |
| `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/tables/holdout_screening_subset.csv` | Frozen holdout subset for any promoted candidate. |

## Planned Output Root

`exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_<timestamp>/`

New run files must stay in `exp/useful_bd_push/`. Do not place T33 run outputs
under `/aux`.

## Planned Subdirectories

| Path | Contents |
| --- | --- |
| `views/` | Preprocessed RTL/netlist/summary text and manifest hashes. |
| `embeddings/` | Qwen3 chunk and whole-design embeddings plus cache manifest. |
| `diagnostics/` | Collapse, nuisance-axis, and nearest-neighbor diagnostics. |
| `replay/` | Selection replay tables and per-control deltas. |
| `figures/` | Regenerated PNG figures for direct PPA and embedding diagnostics. |
| `visualizations/` | Optional Phase 03.1 HTML viewer bundle when archive traces exist. |

## Dependency Route

1. Try the repo uv environment.
2. If blocked, create an isolated uv env under
   `exp/useful_bd_push/envs/t33_qwen3_preprocessing_ladder_bd_<timestamp>/`.
3. If external code is needed, clone under `exp/useful_bd_push/sources/` and
   record commit SHAs here.

## Hashes To Fill After Run

| Artifact | Hash |
| --- | --- |
| preprocessing script | pending |
| Yosys normalization script | pending |
| model revision | pending |
| tokenizer revision | pending |
| embedding cache | pending |
| replay aggregate table | pending |
| primary raw PPA-front figure | pending |
| optional HTML viewer | pending |
