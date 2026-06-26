# T12 Lineage Repair BD Artifacts Manifest

Status: `T0 retrospective_direct_repair_retired`.

No new live run root exists for T12. The package is a retrospective synthesis
from measured repair and lineage-emitter artifacts.

## Source Packages

| Source | Path | Use |
| --- | --- | --- |
| T31 | `../T31_sr_raw_fail_feedback_repair_qd/results_report.md` | Direct fail-pool repair evidence. |
| T49 | `../T49_thought_k_role_separated_repair_qd/results_report.md` | Role-separated repair evidence. |
| T51 | `../T51_code_thought_front_slot_qd/results_report.md` | Best recovery-base evidence. |
| T59 | `../T59_t51_feedback_front_slot_qd/results_report.md` | Short fail-pool feedback evidence. |

## Local Tables

- `tables/t12_lineage_evidence_matrix.csv`
- `tables/t12_gate_decision.csv`
- `tables/t12_source_hashes.sha256`

## Local Figures

- `figures/t12_t31_holdout_live_aggregate.png`
- `figures/t12_t49_metric_delta_summary.png`
- `figures/t12_t51_metric_delta_summary.png`
- `figures/t12_t59_metric_delta_summary.png`
- `figures/visual_inspection_notes.md`

## Commands And Validation

- `commands/retrospective_synthesis.md`
- `sha256sum -c tables/t12_source_hashes.sha256`
- `git diff --check`
