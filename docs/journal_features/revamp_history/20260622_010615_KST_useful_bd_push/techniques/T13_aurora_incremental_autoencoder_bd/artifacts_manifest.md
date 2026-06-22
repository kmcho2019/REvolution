# T13 AURORA Autoencoder BD Artifacts Manifest

Status: completed replay diagnostic.

## Command

```bash
uv run python scripts/analyze_t13_aurora_autoencoder.py \
  --candidates-csv exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv \
  --graph-manifest-csv docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T07_deepgate_family_bd/tables/netlist_graph_manifest.csv \
  --package-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T13_aurora_incremental_autoencoder_bd \
  --retention-fraction 0.5 \
  --random-seed 0 \
  --latent-dims 2 4 8
```

See `commands/replay_v0.md` for focused validation commands.

## Generated Tables

| Path | Rows Including Header | SHA256 |
| --- | ---: | --- |
| `tables/archive_metrics.csv` | 13 | `0f05b2957e7516de5aa22b8bdcea64bbede30952c513c4fa2215d2ec2970b0ac` |
| `tables/autoencoder_training.csv` | 26 | `370dda1b55e009aa90be56a66db7b8ee34dcc9f67e894f0692ddb34625bab84e` |
| `tables/collapse_diagnostics.csv` | 9 | `8a58a35013c0d33ba456534231d3c2a939e595dbee779c4ded656bbbd1677cd1` |
| `tables/feature_manifest.csv` | 37 | `1275f969848d7629ec77b018b5b8aa5282160ec2ce783245bf37c4a0f1dfa779` |
| `tables/latent_diagnostics.csv` | 9 | `ecbcc769917aec22da4e9ecf6b454ebf0472ca2836e4225d59be3c9ce0d92668` |
| `tables/ppa_comparison.csv` | 13 | `ff3efe8f9944061d3ad99126529ffa56aed2f0c2817868374ffed6cef644792a` |
| `tables/ppa_front_metrics.csv` | 13 | `031a4a95f1d4b568850949f1981807ae62f191bcb9ae9006bfbdc7a56f1afa68` |
| `tables/ppa_front_plot_points.csv` | 61 | `31517f8faf9ba64413b0e06d3001565a63844e29e34aebaa48e2350d7eae024b` |
| `tables/replay_rows.csv` | 1369 | `9da325d3eebf4099f4fa9ba9b77df3144baac545c905f74b1a0e727de2fc6537` |
| `tables/selected_candidates.csv` | 4093 | `f646cbe085b6888b79a3a89f4ca75c56d20c94189f7c1a7c14e983a8f454efa4` |
| `tables/split_manifest.csv` | 769 | `a673dc5bdb1b25ae4902351742518fdb2ce1151933ba1cdc5e616f2e58078cfe` |

## Generated Figures

| Path | SHA256 |
| --- | --- |
| `figures/aurora_multi_problem_ppa_pareto_fronts.png` | `281480ae368a8a40b1a38414b0d80270dc23de12e51725ef9f8c97c5d08ae75d` |
| `figures/aurora_raw_area_power_pareto_front.png` | `824b6f92daa0943a06713700d6955de936a3e71d6a3f4b728049f3a427d343fa` |
| `figures/aurora_hypervolume.png` | `30dac3de20a1e6c45e7d5297e45df9a649f713759285b7934aee9f85bc105049` |
| `figures/aurora_latent_projection.png` | `289cb597026345cbb40ddb1d0a0f80307ec642869fd57b007331119ee84efa3d` |
| `figures/aurora_reconstruction_vs_hv.png` | `ef42b81dc12a386d7eb1dcc3a77b502fdf38b93b2751b977f0fcdb67ab2b8c6c` |

## Code

| Path | SHA256 |
| --- | --- |
| `scripts/analyze_t13_aurora_autoencoder.py` | `82befad2631077479882e9637a27c90be659ff491df862b14f78fbe9d7d18029` |
| `tests/scripts/test_analyze_t13_aurora_autoencoder.py` | `7e7d5d3741b8b2889d50e22fc9fcdedf05754b4f05b3d08eb2c92410e33a1f68` |

## Validation

- `uv run pytest tests/scripts/test_analyze_t13_aurora_autoencoder.py`
- `uv run ruff check scripts/analyze_t13_aurora_autoencoder.py tests/scripts/test_analyze_t13_aurora_autoencoder.py`
- `uv run python -m pyright scripts/analyze_t13_aurora_autoencoder.py tests/scripts/test_analyze_t13_aurora_autoencoder.py`
- `uv tool run ty check scripts/analyze_t13_aurora_autoencoder.py tests/scripts/test_analyze_t13_aurora_autoencoder.py`
