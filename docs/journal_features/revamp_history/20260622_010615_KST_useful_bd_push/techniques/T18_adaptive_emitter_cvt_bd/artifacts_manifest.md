# T18 Adaptive Emitter CVT BD Artifacts Manifest

Status: `T0 retrospective_retired`.

No new live run root exists for T18. The package is a provenance-preserving
retrospective synthesis from measured T57 and T32 artifacts.

## Source Packages

| Source | Path | Use |
| --- | --- | --- |
| T57 | `../T57_t51_adaptive_rebin_qd/results_report.md` | Adaptive archive-boundary evidence. |
| T57 | `../T57_t51_adaptive_rebin_qd/hard_tuning_package/tables/t57_rebinning_counters.csv` | Rebin-count evidence copied into T18. |
| T57 | `../T57_t51_adaptive_rebin_qd/hard_tuning_package/figures/t57_rebinning_counters.png` | Copied into `figures/t18_t57_rebinning_counters.png`. |
| T32 | `../T32_sr_raw_front_preserving_emitter_qd/results_report.md` | Front-preserving emitter evidence. |
| T32 | `../T32_sr_raw_front_preserving_emitter_qd/figures/t32_holdout_live_aggregate.png` | Copied into `figures/t18_t32_holdout_live_aggregate.png`. |

## Local Tables

- `tables/t18_evidence_matrix.csv`
- `tables/t18_gate_decision.csv`
- `tables/t18_t57_rebinning_counters.csv`
- `tables/t18_source_hashes.sha256`

## Local Figures

- `figures/t18_t57_rebinning_counters.png`
- `figures/t18_t32_holdout_live_aggregate.png`
- `figures/visual_inspection_notes.md`

## Commands And Validation

- `commands/retrospective_synthesis.md`
- `git diff --check`
