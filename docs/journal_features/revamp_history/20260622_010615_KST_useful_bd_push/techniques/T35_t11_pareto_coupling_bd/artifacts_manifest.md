# T35 T11 Pareto-Coupled BD Artifacts Manifest

Status: completed replay diagnostic.

## Command

```bash
uv run python scripts/analyze_t35_t11_pareto_coupling.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv \
  --hypergraph-features-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T35_t11_pareto_coupling_bd \
  --retention-fraction 0.5 \
  --random-seed 0 \
  --cell-bins 2
```

## Generated Tables

| Path | Rows Including Header | SHA256 |
| --- | ---: | --- |
| `tables/archive_comparison.csv` | 10 | `31d83346a83db057c49f894aac16968434b669e3bc4ebc9e85bb84b4905351ca` |
| `tables/cell_summary.csv` | 369 | `a5858dd03220222ee062f4691a608aced1a0127df1fa82e529a5670e54cef6f0` |
| `tables/feature_manifest.csv` | 50 | `c82f14a0f70b0397efdc2017ce429ac10504d7ec0cc00ec03d6ef20587b7ca6c` |
| `tables/ppa_comparison.csv` | 10 | `1c2862bf1910f4209df0aa0faf721bbb1d70029dc8455ad2c07940727901f332` |
| `tables/ppa_front_metrics.csv` | 10 | `ee840031bd92d3349b1cd7c002f154a0a21170dbde3deef1b453690071c5516a` |
| `tables/ppa_front_plot_points.csv` | 97 | `1ff96142d24f8078fc42ee5bdc2467d16996aac4a9ca0742304fb9ef5a2cfffb` |
| `tables/replay_rows.csv` | 1027 | `debfe8fcdd1352133e08d59c1594cf6101ba191a3d2f2e507c09ba2293a515ae` |
| `tables/selected_candidates.csv` | 3070 | `68647eb69b972cbf563be88c9b03367fd5f211fb034b5304e7564c55d52d3ea6` |

## Generated Figures

| Path | SHA256 |
| --- | --- |
| `figures/t35_front_hits.png` | `f6280a3f8d088cfefb060fe510a05fcf8fa9a524cf5881d6b6fdbc1b148b4a53` |
| `figures/t35_hypervolume.png` | `071e3355e603398aab93ef821f7ecf58ae26d7b0ca94e9b2c39b1f0a0d8bf68d` |
| `figures/t35_multi_problem_ppa_pareto_fronts.png` | `089bbb511b5a5f83e3a16d3339f599ef79c5c6e3b53bdb5cc560b70bcca8bd4e` |
| `figures/t35_raw_area_power_pareto_front.png` | `60d1234521ab6178f996267fc0b92d807e7c8f2e1e7c3c449f9299c08265d964` |

## Generated Visualizations

| Path | SHA256 |
| --- | --- |
| `visualizations/direct_ppa_pareto/index.html` | `67434356692700ad1d2307486e7c822c03d1b98588482f70ebb80ad5d321f160` |
| `visualizations/direct_ppa_pareto/manifest.json` | `98c3807898aefa47f223b8a092e241cfc1f07b9b4343e5c0173c6b16dd6057ad` |
| `visualizations/direct_ppa_pareto/metrics.json` | `67a679133ef80aee0702cc9af7612300ffbcc1fead9305b95923c31a5e939878` |
| `visualizations/direct_ppa_pareto/points.json` | `75319eb0fac817fe79f724fce60345e01761a57762d7167aca4f3bb8ca1019c5` |
| `visualizations/direct_ppa_pareto/README.md` | `941f588972d345d92c40634a2d48f223c0ec5018b9a1db32a62935a8e58c29b6` |
| `visualizations/direct_ppa_pareto/screenshot.png` | `c88402a8493a3d369930ef449d20df0afbe75a9c01f824340dfd30f8663ce8c8` |

## Code

| Path | SHA256 |
| --- | --- |
| `scripts/analyze_t35_t11_pareto_coupling.py` | `33925280bd6d071eddd3cfd900cd980d39360bb8938b8cb0bc09f41ab76d3480` |
| `tests/scripts/test_analyze_t35_t11_pareto_coupling.py` | `19ca3bf1f9e64f1754e7d0f28ee53d51e7b06de1129e0c703a2bf23c1b8c7e69` |

## Validation

- `uv run pytest tests/scripts/test_analyze_t35_t11_pareto_coupling.py`
- `uv run ruff check scripts/analyze_t35_t11_pareto_coupling.py tests/scripts/test_analyze_t35_t11_pareto_coupling.py`
- `uv run python -m pyright scripts/analyze_t35_t11_pareto_coupling.py tests/scripts/test_analyze_t35_t11_pareto_coupling.py`
- `uv tool run ty check scripts/analyze_t35_t11_pareto_coupling.py tests/scripts/test_analyze_t35_t11_pareto_coupling.py`
- Playwright filesystem-opened `visualizations/direct_ppa_pareto/index.html`
  and saved `visualizations/direct_ppa_pareto/screenshot.png`.
