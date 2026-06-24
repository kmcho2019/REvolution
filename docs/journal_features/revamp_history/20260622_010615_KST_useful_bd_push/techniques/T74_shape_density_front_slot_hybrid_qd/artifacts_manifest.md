# T74 Artifacts Manifest

Status: pre-registered; live artifacts pending.

## Committed Registration Artifacts

| Path | Purpose |
| --- | --- |
| `README.md` | Short package orientation and current decision. |
| `methodology.md` | Paper-grade method definition and promotion gates. |
| `commands/live_screen_v0.md` | Frozen probe, preflight, live-run, validation, and packaging commands. |
| `tables/descriptor_probe_source_aligned_shape_density_3d.json` | Descriptor probe showing source-aligned RTL-only requirements. |
| `tables/t74_method_contract.json` | Compact machine-readable method contract. |
| `results_report.md` | Pending report shell for the eventual result. |

## Expected Live Artifacts

| Path | Purpose |
| --- | --- |
| `exp/useful_bd_push/t74_shape_density_front_slot_hybrid_<timestamp>/hard_tuning/` | Live run root; keep out of `/aux`. |
| `preflight/models_<timestamp>.json` | Local vLLM `/v1/models` response. |
| `shape_density_front_slot_hybrid_qd/seed_1001/` | T74 QD backend run. |
| `final_analysis/` | Matched final-analysis scratch bundle. |
| `matched_classic_comparison/` | Compact committed result package after the live run. |

## Current Hashes

The live run is not started. Record run-root hashes after packaging, not
before.
