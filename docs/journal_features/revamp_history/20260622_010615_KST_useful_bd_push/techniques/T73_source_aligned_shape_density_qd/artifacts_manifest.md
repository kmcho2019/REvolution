# T73 Artifacts Manifest

Status: pre-run package. Large live artifacts must remain under `exp/`.

## Committed Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Local package overview and current decision. |
| `methodology.md` | Pre-registered method, leakage rules, archive choice, and acceptance gates. |
| `commands/live_screen_v0.md` | Storage, probe, audit, preflight, run, validation, and packaging commands. |
| `results_report.md` | Current pre-run conclusion and no-promotion caveat. |
| `tables/descriptor_probe_source_aligned_shape_density_3d.json` | Descriptor contract probe showing source-aligned, PPA-free requirements. |
| `tables/t73_descriptor_collapse_audit.csv` | Per-problem T72 collapse and T73 projection audit. |
| `tables/t73_axis_screen_summary.json` | Compact machine-readable audit summary. |
| `tables/source_aligned_shape_density_contract.json` | Method contract used by this package. |
| `figures/t73_descriptor_occupancy_audit.png` | Inspected occupancy figure from the T72 replay audit. |
| `tools/audit_t73_axes_from_t72.py` | Reproduction script for the audit tables and figure. |

## Source Run Inputs

| Path | Role |
| --- | --- |
| `exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC/hard_tuning/source_aligned_rtl_cell_qd/seed_1001/openai_gpt-oss-120b` | Source T72 archive events used for the pre-run descriptor audit. |

## Expected Live Artifacts

After the T73 live run, add or copy compact summaries into this package:

- `tables/t73_live_screen_status.csv`;
- `visualizations/direct_ppa_pareto/`;
- `visualizations/qd_ppa_viewer/`;
- matched classic comparison package;
- visual inspection notes for every generated plot and viewer screenshot.

Keep raw run directories and generated final-analysis scratch bundles under
`exp/useful_bd_push/`.
