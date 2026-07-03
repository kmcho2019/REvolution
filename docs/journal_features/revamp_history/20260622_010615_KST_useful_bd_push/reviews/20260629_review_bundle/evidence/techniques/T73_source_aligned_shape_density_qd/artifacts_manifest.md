# T73 Artifacts Manifest

Status: bounded live-screen and matched-comparison package. Large live and
final-analysis artifacts remain under `exp/`.

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
| `tables/t73_live_screen_status.csv` | Per-problem live-screen status, archive occupancy, and PPA report counts. |
| `tables/t73_live_screen_summary.json` | Compact aggregate live-screen summary. |
| `tables/t73_single_thought_operator_validation.md` | Registered single-thought operator validator report. |
| `tables/t73_pareto_front_validation.md` | Registered Pareto-front validator report. |
| `figures/t73_descriptor_occupancy_audit.png` | Inspected occupancy figure from the T72 replay audit. |
| `tools/audit_t73_axes_from_t72.py` | Reproduction script for the audit tables and figure. |
| `tools/package_t73_live_screen.py` | Reproduction script for compact live-screen CSV/JSON summaries. |
| `matched_classic_comparison/` | Reference-complete matched classic comparison, compact data, figures, and Phase 03.1 viewer. |

## Source Run Inputs

| Path | Role |
| --- | --- |
| `exp/useful_bd_push/t72_source_aligned_rtl_cell_20260623_204847_UTC/hard_tuning/source_aligned_rtl_cell_qd/seed_1001/openai_gpt-oss-120b` | Source T72 archive events used for the pre-run descriptor audit. |
| `exp/useful_bd_push/t73_source_aligned_shape_density_20260623_232844_UTC/hard_tuning` | Completed T73 bounded live screen and validator reports. |
| `exp/useful_bd_push/t73_matched_classic_comparison_20260624_001300_UTC/final_analysis` | Scratch final-analysis bundle for matched classic-versus-T73 metrics. |

## Visualization Status

The matched comparison package includes:

- compact direct PPA/Pareto panels under
  `matched_classic_comparison/figures/pareto_examples/`;
- the full Phase 03.1 viewer under
  `matched_classic_comparison/visualizations/qd_ppa_viewer/`;
- strict non-Playwright viewer validation `PASS`;
- manual screenshot inspection notes.

Keep raw run directories and generated final-analysis scratch bundles under
`exp/useful_bd_push/`.
