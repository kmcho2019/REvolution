# T37 Artifacts Manifest

## Reproducibility Command

The replay command is recorded in `commands/replay_v0.md`.

## Source Files

| Path | SHA-256 |
| --- | --- |
| `scripts/analyze_t37_t36_slot_count_ablation.py` | `97e0dc32431651bf41ce5165aa3a4a87eedc938b1b2df0f6e4e740621567926e` |
| `tests/scripts/test_analyze_t37_t36_slot_count_ablation.py` | `d09976f879fc37c88e47c1ab9956148aedf2dc13632d03df99b7e49cda28b811` |
| `methodology.md` | `7fd23006296dbf52924278d8e3ec997aef5bc27be9f77a3476a646c8280cec5a` |
| `commands/replay_v0.md` | `7c5f14f80eb07c409416eeebde6e77a552a31a7127fd807c5f8bca52982e1f12` |
| `results_report.md` | `7a4ecccde2cb70d9c8b8c182ddf4204a4c3c46b8517f530463c4992e4256f2c4` |
| `figures/README.md` | `ac0429977e15e9255b05092ea795d4ec33e29dfc32151c531960c2e361372d87` |
| `figures/visual_inspection_notes.md` | `db50176eb9d4fe8c095c5775975ef88ee199ac63a6702b5e7e8f714be679dcca` |
| `tables/README.md` | `5ebe02240b86d926e2ef63ce0a657ae8df5220ce3b5777063bfd4fcb59575845` |

## Tables

| Path | Rows | SHA-256 |
| --- | ---: | --- |
| `tables/archive_comparison.csv` | 16 | `24df5e23bfd034008b512d682c7fcc00848594291b5541811f89f0932e33a58b` |
| `tables/feature_manifest.csv` | 50 | `c82f14a0f70b0397efdc2017ce429ac10504d7ec0cc00ec03d6ef20587b7ca6c` |
| `tables/ppa_comparison.csv` | 16 | `3e7d71b71c3ef4ed2fa0b670071096fd2fba29070336ee78bb7e4406c25087e8` |
| `tables/ppa_front_metrics.csv` | 16 | `c6729a60126136c2b7a7628936af35a46fb39de9d634eaf4d71bd72a3e61f8c1` |
| `tables/ppa_front_plot_points.csv` | 109 | `be69c298cc79359a747ceeee1bbfde0eccf7ea91033afbaca89d446a1585f0b1` |
| `tables/replay_rows.csv` | 1711 | `b40d3e61336a5a834d59dad30c2364cf2642aaf8b3482419d461e10aecd1f2c1` |
| `tables/selected_candidates.csv` | 5116 | `c778c384707a270f3029a5592438b4913baa4bfce5da41eca7bf7c6e9eb87641` |
| `tables/slot_summary.csv` | 685 | `6539e630fb721e1ec0c7a3d2fa323440aa9e593c20f50e76a7239c01d9daccc5` |

## Figures And Viewer

| Path | Bytes | SHA-256 |
| --- | ---: | --- |
| `figures/t37_front_hits.png` | 81628 | `6fa043b99edd62086d25f61837d4748bf16288b66c78dc7666275cda5863be59` |
| `figures/t37_hypervolume.png` | 80521 | `9347a574854c2ef939a11ae4688e08946ea0be427e8505b29f6d55db070e51bc` |
| `figures/t37_multi_problem_ppa_pareto_fronts.png` | 270700 | `e0d33a0710951f5b8c8e1cbf61d1bf986caf8d71afe6b734075af9c05494381a` |
| `figures/t37_raw_area_power_pareto_front.png` | 203068 | `da6a6ce36ea0603c1063799eaf55eccdd62bd01367c87a61a361b5a903da4604` |
| `visualizations/direct_ppa_pareto/index.html` | 58671 | `a56f888d51f94e39735be110a68bf45124fb2f6e1e8f2845ef7bd49d0a426b43` |
| `visualizations/direct_ppa_pareto/manifest.json` | 227 | `c18be06ba5ba386b7269b196e99dd6a5d544121c500a3bfb89aefd29201ce2f4` |
| `visualizations/direct_ppa_pareto/metrics.json` | 10984 | `143d9cf626b3273d34969405fc76bc0570303508f9c362a176089c79dfe91351` |
| `visualizations/direct_ppa_pareto/points.json` | 47222 | `f756614c399338316eb8c4d402f42c23eba3f76b61251d60abc7c62c670f97ff` |
| `visualizations/direct_ppa_pareto/screenshot.png` | 74257 | `9e5f1edbd0866b66c7a506eae7f34697a4d35c1e4800127c03e0d0d31b700efa` |

## Validation

- `uv run pytest tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`
- `uv run ruff check scripts/analyze_t37_t36_slot_count_ablation.py tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`
- `uv run python -m pyright scripts/analyze_t37_t36_slot_count_ablation.py tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`
- `uv tool run ty check scripts/analyze_t37_t36_slot_count_ablation.py tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`
- Playwright render check for the direct PPA HTML viewer.
