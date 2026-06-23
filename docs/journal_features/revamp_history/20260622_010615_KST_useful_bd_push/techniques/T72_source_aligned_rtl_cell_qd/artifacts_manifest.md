# T72 Artifacts Manifest

Status: pre-run method package. No live results are claimed.

## Committed Pre-Run Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Package summary and current decision. |
| `methodology.md` | Full pre-registered method card. |
| `commands/live_screen_v0.md` | Preflight, runtime-gate, live-run, validation, and packaging command templates. |
| `tables/source_aligned_descriptor_contract.json` | Machine-readable descriptor and run contract. |
| `tables/hard_tuning_subset.yaml` | Frozen 13-problem comparator subset. |
| `tables/t72_method_matrix.csv` | Compact comparison against T51/T66/T67. |
| `tables/README.md` | Table inventory. |
| `figures/README.md` | Figure requirements; no figures yet because no live result exists. |

## Required Future Artifacts

The live run is not allowed until these exist:

| Path | Requirement |
| --- | --- |
| `tables/descriptor_probe_source_aligned_masterrtl_rtltimer_cell_2d.json` | Runtime probe proving exact T71-compatible axes with no PPA requirement. |
| `tables/t72_ppa_completeness.csv` | Reference-complete comparison eligibility table. |
| `visualizations/direct_ppa_pareto/` | Static raw area-power PPA-front supplement. |
| `visualizations/qd_ppa_viewer/` | Full Phase 03.1 viewer if archive artifacts are generated. |
| `results_report.md` | Tier decision and measured result after execution. |

## Storage Policy

Do not place new T72 run artifacts under `/aux`. Live outputs should go under:

```text
exp/useful_bd_push/t72_source_aligned_rtl_cell_<timestamp>/
```

The committed pre-run package is documentation and small tables only.
