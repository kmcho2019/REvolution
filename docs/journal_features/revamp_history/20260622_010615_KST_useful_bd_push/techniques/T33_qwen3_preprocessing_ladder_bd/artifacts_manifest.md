# Qwen3 Preprocessing Ladder Artifacts Manifest

Status: pre-registered with T33a source inventory, T33b preprocessing-view
manifests, and T33c embedding manifests. Replay artifact hashes are pending.

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

## T33a Committed Tables

| Artifact | Rows | SHA256 |
| --- | ---: | --- |
| `tables/t33_source_inventory.csv` | 15 | `38270088aefc4bc2f5807e842597e9a867e09832cf708a4f208509d73b275677` |
| `tables/t33_prior_qwen_summary.csv` | 22 | `8c95680dc1e4a75b557f031e6bbe53786d15c69fd6721917ed3df06717338a6e` |
| `tables/t33_preprocessing_ladder_plan.csv` | 6 | `f950c5b50c593f700b7354229e3e5e786b6cf77219b61bc71488268bf7440b00` |

## T33b Committed Tables

| Artifact | Rows | SHA256 |
| --- | ---: | --- |
| `tables/t33_preprocessing_cache_manifest.csv` | 1 | `ad95530dd915baa96d1cb2ee1020091c4122bb15359c25a184e8900481998269` |
| `tables/t33_preprocessing_view_manifest.csv` | 4608 | `78e084cfe8c660a0d693cf6adaec13d5a4db83e82df7050d436055f235e9ddbc` |
| `tables/t33_preprocessing_view_summary.csv` | 6 | `950cda3c47d454419630015bdccb3d63074bf69df5bbff6e10d990e84b185e31` |

The generated text cache is intentionally not committed. It lives at:

`exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_20260622_021639_UTC`

## T33c Committed Tables

| Artifact | Rows | SHA256 |
| --- | ---: | --- |
| `tables/t33_embedding_cache_manifest.csv` | 6 | `aed377f3f81e09656c37a8c3f01d3ad42b0baeccb815562e58ef42e43700d5be` |
| `tables/t33_embedding_chunk_summary.csv` | 6 | `37b550765ce91dad95694c2cce755157b59248172afdce917f136b97c1dd90a3` |

The generated embedding matrices and chunk manifests are intentionally not
committed. They live under:

`exp/useful_bd_push/t33_qwen3_preprocessing_ladder_bd_20260622_021639_UTC/embeddings/`

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
| embedding cache | `tables/t33_embedding_cache_manifest.csv` |
| replay aggregate table | pending |
| primary raw PPA-front figure | pending |
| optional HTML viewer | pending |
