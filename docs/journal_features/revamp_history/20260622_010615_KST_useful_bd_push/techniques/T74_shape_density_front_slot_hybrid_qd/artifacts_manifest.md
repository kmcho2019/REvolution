# T74 Artifacts Manifest

Status: completed `T0 diagnostic_regression_not_promoted`.

## Committed Registration Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Short package orientation and current decision. |
| `methodology.md` | Paper-grade method definition and promotion gates. |
| `commands/live_screen_v0.md` | Frozen probe, preflight, live-run, validation, and packaging commands. |
| `tables/descriptor_probe_source_aligned_shape_density_3d.json` | Descriptor probe showing source-aligned RTL-only requirements. |
| `tables/t74_method_contract.json` | Compact machine-readable method contract. |
| `results_report.md` | Completed live-screen result and tier decision. |
| `matched_classic_comparison/` | Compact matched result package. |

## Live Artifacts

| Path | Purpose |
| --- | --- |
| `exp/useful_bd_push/t74_shape_density_front_slot_hybrid_20260624_010922_UTC/hard_tuning/` | Live run root; kept under `exp/`, not `/aux`. |
| `preflight/models_20260624_010922_UTC.json` | Local vLLM `/v1/models` response. |
| `shape_density_front_slot_hybrid_qd/seed_1001/` | T74 QD backend run. |
| `final_analysis/` | Matched final-analysis scratch bundle. |
| `matched_classic_comparison/` | Compact committed result package. |

## Current Hashes

Run-root content is intentionally left under `exp/`. The committed package
contains regenerated data, compact tables, figures, validation records, and
the packager script used to reproduce the package from `final_analysis/`.
