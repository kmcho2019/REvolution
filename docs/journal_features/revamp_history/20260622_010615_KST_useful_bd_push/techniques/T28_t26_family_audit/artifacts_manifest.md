# T28 T26 Family Audit Artifacts Manifest

Status: completed canonical/family audit package.

## Source Inputs

| Label | Path |
| --- | --- |
| T24 live matrix | `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC` |
| T25 guarded SR raw | `exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC` |
| T26 conservative exploit | `exp/useful_bd_push/t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC` |

## Reproduction Command

`commands/package_family_audit.md`

## Generated Tables

| Artifact | SHA-256 |
| --- | --- |
| `tables/family_aggregate_metrics.csv` | `fb72b34eb073a14cab8d8bc273d0a4a3830f5fe2b6ab9a8c875fbe801f169df6` |
| `tables/family_candidate_rows.csv` | `0333000c3e3d1283e6a82a79d89f296e6a68bcad533c3fffbbbf7042f449857f` |
| `tables/family_comparison_deltas.csv` | `e5e1eb4dc3970edde2d27accc9e071cba8e4cfee5379c637c534368d0fe11e63` |
| `tables/family_method_manifest.csv` | `accb83c346cba41f808d0fbffd8429fd9f1bcf70f4b778c4fbf307e58df76508` |
| `tables/family_problem_metrics.csv` | `96f8f3a61563ee1832b170202e07eb6e4fa30193cf127e9235f5fcbcb02ecba4` |

## Generated Figures

| Artifact | Size | SHA-256 |
| --- | ---: | --- |
| `figures/family_aggregate_counts.png` | 3006 x 889 | `b05d309bb4ad2d29a02c7f1544d8ddd7f02839b77214347bde9001ce7c240aea` |
| `figures/family_problem_front_counts.png` | 3186 x 926 | `42c21742d0bf3241b34eb507d9c194758d450e2dc8018f2afd61c00416f2199d` |
| `figures/ppa_pareto_fronts_area_power.png` | 3149 x 953 | `44d541f0d85da784435319a2ae8d61b3f882186df705de7e8bdc4d97a3f92c8c` |
| `figures/ppa_pareto_fronts_improvement.png` | 3149 x 953 | `15cb1c647c2b1dc240e4e912e3db2c43fb079e49f223b362449d73c6cd4ff291` |

## Generated Visualizations

| Artifact | SHA-256 |
| --- | --- |
| `visualizations/qd_ppa_viewer/index.html` | `c3d835fad15c8df021e1f104e73ccafbc7be381e8ac30ce8edfa44685ba61fc1` |
| `visualizations/qd_ppa_viewer/manifest.json` | `88e9b66b834e4ccdfa986f3ef12c2d7795415c84f1337e69c1372a195a9c58e6` |
| `visualizations/qd_ppa_viewer/datasets/RTLLM__Prob015_multi_pipe_8bit.json` | `35bd26d815a86d8f17760b6e08a92721b886a692b1ffd833e09c22b1b56c302e` |
| `visualizations/qd_ppa_viewer/datasets/RTLLM__Prob041_traffic_light.json` | `a8f5a9380254fc6d9aa3b1323a4380dd64a20b96b4b7a9c22707733f9fb17083` |
| `visualizations/qd_ppa_viewer/datasets/RTLLM__Prob045_alu.json` | `fc0624ed25800ce3423827be2d15e01df31e48d2a0b111f9e997578e498e12ca` |
| `visualizations/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/ppa_candidates.csv` | `267e0546a200a71367ebc26aa6ca31c0e961927fc8f410fe5b41938eb74b3125` |
| `visualizations/qd_ppa_viewer_source/final_analysis/ppa_distribution/data/reference_ppa_metrics.csv` | `809cdd6f019666e0cf889466e94d468db9f066be090d4c4bca473f247ac28b33` |
| `visualizations/qd_ppa_viewer_source/final_analysis/design_space_analysis/successful_candidates.csv` | `3f345395bf320206f2f05c5a3c1b80917c5e911163afb05c1a718ccbb78391d4` |

## Code Artifacts

| Artifact | SHA-256 |
| --- | --- |
| `scripts/package_t28_t26_family_audit.py` | `b97bcb903f3ee7eb042b5e2fc1ef8d704334810b759d93084d5da88604a42aaf` |
| `tests/scripts/test_package_t28_t26_family_audit.py` | `3acc416f6d6e7cb406fc3e33aff99dd576330fff8bb46c1cf1f7e8b9a20809e6` |

## Validation Status

- Focused pytest: passed for
  `tests/scripts/test_package_t28_t26_family_audit.py`.
- Ruff: passed for the T28 script and test.
- Pyright: passed for the T28 script and test.
- QD/PPA viewer static validation: passed for
  `visualizations/qd_ppa_viewer/`.
- Playwright smoke: generated screenshots and visual parity report; one
  scoped archive-hover caveat is documented in
  `figures/visual_inspection_notes.md`.
- Visual inspection: passed with limitations documented in
  `figures/visual_inspection_notes.md`.
