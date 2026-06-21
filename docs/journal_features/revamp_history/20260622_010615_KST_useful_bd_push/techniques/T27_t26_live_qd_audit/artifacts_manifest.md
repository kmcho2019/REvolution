# T27 T26 Live QD Audit Artifacts Manifest

Status: completed live audit package.

## Source Inputs

| Label | Path |
| --- | --- |
| T24 live matrix | `exp/useful_bd_push/t24_sr_pareto_live_validation_20260621_184346_UTC` |
| T25 guarded SR raw | `exp/useful_bd_push/t25_guarded_sr_raw_pareto_qd_20260621_210402_UTC` |
| T26 conservative exploit | `exp/useful_bd_push/t26_sr_raw_conservative_exploit_qd_20260621_213249_UTC` |

## Reproduction Command

`commands/package_audit.md`

## Generated Tables

| Artifact | SHA-256 |
| --- | --- |
| `tables/live_qd_aggregate_metrics.csv` | `e0fe115566dbfaa1a4ab08e5d1c176c4bfe658f2613c4ef65b2c2045a34f1ca6` |
| `tables/live_qd_comparison_deltas.csv` | `f3c25e8a9b27430dbe58a8713a4a4013058fa2756e87e6fa8820acd24e75faf8` |
| `tables/live_qd_method_manifest.csv` | `accb83c346cba41f808d0fbffd8429fd9f1bcf70f4b778c4fbf307e58df76508` |
| `tables/live_qd_problem_metrics.csv` | `a49d76abe3b61df90b174cc0a3fc406a27f59aeecd899d1db9010c11c6ca45b5` |

## Generated Figures

| Artifact | Size | SHA-256 |
| --- | ---: | --- |
| `figures/live_qd_aggregate_metrics.png` | 3006 x 889 | `f6de7c5dab95a639b7f4616575f6b8d9865646df111be94661ac3346f31f0031` |
| `figures/live_qd_problem_metrics.png` | 3186 x 926 | `05c5aea5e50f8b9545f340c571c72a1bb5d5b1a137eb5430a9b5312c31bd885b` |

## Code Artifacts

| Artifact | SHA-256 |
| --- | --- |
| `scripts/package_t27_t26_live_qd_audit.py` | `1eba814411e36af1c7b8be0f475dec7c51cbf3fd5fd3bbd0e1b0e27a8254f7b6` |
| `tests/scripts/test_package_t27_t26_live_qd_audit.py` | `0b5069b83d210bf06324f73499778ceac7591bc54782eb2853f820b6094318dd` |

## Validation Status

- Focused pytest: passed for
  `tests/scripts/test_package_t27_t26_live_qd_audit.py`.
- Ruff: passed for the T27 script and test.
- Pyright: passed for the T27 script and test.
- Visual inspection: passed with limitations documented in
  `figures/visual_inspection_notes.md`.
