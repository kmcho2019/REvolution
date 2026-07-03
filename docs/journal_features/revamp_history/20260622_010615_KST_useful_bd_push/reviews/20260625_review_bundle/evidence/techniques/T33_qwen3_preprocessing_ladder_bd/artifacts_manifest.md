# Qwen3 Preprocessing Ladder Artifacts Manifest

Status: completed `T0 diagnostic` with T33a source inventory, T33b
preprocessing-view manifests, T33c embedding manifests, T33d collapse
diagnostics, and T33e replay/PPA-front artifacts.

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

## T33d Committed Tables

| Artifact | Rows | SHA256 |
| --- | ---: | --- |
| `tables/t33_collapse_diagnostics.csv` | 6 | `e3d2afe026bdbcbbf8c0dec2e3cd08086c96aab5cdd196c05d0a93900d8e56cd` |
| `tables/t33_nearest_neighbors.csv` | 4608 | `1fd13be2d9c10a8202eb105faaf50f2ce02ee64287deb0b069f0c8eda5bbff15` |
| `tables/t33_view_stability.csv` | 15 | `5c8b5be47e276519aad8a9f56edebad476554e63dafdecb1f2d798a8135fda08` |

## T33e Committed Replay Tables

| Artifact | Rows | SHA256 |
| --- | ---: | --- |
| `tables/t33_replay_rows.csv` | 1140 | `16700c3490edfe0c0554e138ed7fca7515067c29b3e544ff2e2629b2c259ddf5` |
| `tables/t33_replay_aggregate.csv` | 10 | `5ac953c1225895e4ad7d2b6b53e59f4ca779872dc284e10dabf68b418e72a12e` |
| `tables/t33_selected_candidates.csv` | 3410 | `45c7b1cae133d1662be444fd4e87d8a670dfbe596c1ac9954c6c1b2223a8f907` |
| `tables/t33_ppa_front_metrics.csv` | 10 | `103e7ec6e0aad051f2db05d92bd977fe09f2a751ae2dd8a1f5bf9659712dd90b` |
| `tables/t33_qwen_ladder_vs_controls.csv` | 50 | `65b47ba1244bcce5f0ceafb15beab7bfe283b6304309aae20cf0f525740e2ec6` |

## T33e Committed Figures

| Artifact | Role | SHA256 |
| --- | --- | --- |
| `figures/t33_raw_area_power_pareto_front.png` | Direct raw area-power PPA front with full-range and lower-left zoom panels. | `f543c7be56503ec690724b49e6992bdbf7de2378c6b328d62a5fc310d9214d5c` |
| `figures/t33_hypervolume_by_view.png` | Selected-HV comparison versus lexical control. | `1e5fe80cc866ed851e983b5ecc1b677faa2e38cee1bcd3ee516881cf24389b4e` |
| `figures/t33_duplicate_and_motif_counts.png` | Unique canonical-netlist and motif-signature counts by representation. | `b9d81a04ae28ea45e22e5523db9003447a5e67d6472239f1c75fb91c3867705c` |

## T33e Script Hashes

| Artifact | SHA256 |
| --- | --- |
| `scripts/analyze_t33_qwen_replay.py` | `a2f386afe9d60cd96a253c5b591e258cc908c71f9055a9610d66bee801877d34` |
| `tests/scripts/test_analyze_t33_qwen_replay.py` | `547d0226f69b902a5bf3edc3846e5db53f2c222d818d0ad8cba0b22aba71e954` |

## Subdirectories

| Path | Contents |
| --- | --- |
| `views/` | Preprocessed RTL/netlist/summary text and manifest hashes. |
| `embeddings/` | Qwen3 chunk and whole-design embeddings plus cache manifest. |
| `diagnostics/` | Collapse, nuisance-axis, and nearest-neighbor diagnostics. |
| `replay/` | Selection replay tables and per-control deltas. The current compact replay CSVs are committed under `tables/`. |
| `figures/` | Regenerated PNG figures for direct PPA and replay diagnostics. |
| `visualizations/` | Optional Phase 03.1 HTML viewer bundle when archive traces exist. |

## Dependency Route

1. Try the repo uv environment.
2. If blocked, create an isolated uv env under
   `exp/useful_bd_push/envs/t33_qwen3_preprocessing_ladder_bd_<timestamp>/`.
3. If external code is needed, clone under `exp/useful_bd_push/sources/` and
   record commit SHAs here.

## Remaining Optional Hashes

| Artifact | Hash |
| --- | --- |
| preprocessing script | committed in earlier T33b commit |
| Yosys normalization script | pending |
| model revision | pending |
| tokenizer revision | pending |
| embedding cache | `tables/t33_embedding_cache_manifest.csv` |
| replay aggregate table | `tables/t33_replay_aggregate.csv` |
| primary raw PPA-front figure | `figures/t33_raw_area_power_pareto_front.png` |
| optional HTML viewer | pending |
