# T12 Lineage Repair BD Results Report

Status: `T0 retrospective_direct_repair_retired`.

## Question

Do measured repair and lineage-emitter variants justify a fresh T12 live run,
or should direct fail-feedback and role-separated repair be retired until the
mechanism changes?

## Headline Result

Do not run exact T12. Direct fail-feedback and short fail-pool feedback are
retired. T51's code-individual front-slot recovery remains useful context, but
it is not enough to claim a repair-lineage BD win.

## Evidence Matrix

The machine-readable summary is in `tables/t12_lineage_evidence_matrix.csv`.

| Source | Mechanism | HV Delta | HV-AUC Delta | Valid PPA Delta | Front Delta | Unique PPA Delta | Decision |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| `T31` | Direct fail-pool repair | 0.000000 | 0.000000 | -47 | 0 | -5 | Retire direct fail-feedback. |
| `T49` | Role-separated repair | -0.005704 | +0.001127 | -26 | -10 | -11 | Diagnostic only. |
| `T51` | Code front-slot recovery base | -0.003349 | +0.003434 | +9 | -9 | -12 | Keep as recovery base. |
| `T59` | Short feedback on T51 | -0.005882 | -0.002960 | -16 | -10 | -27 | Retire short feedback. |

T31 is a holdout comparison, so its HV delta against classic is zero because
both T31 and classic have zero mean normalized HV. The relevant blocker is that
T31 loses T26's P135 HV signal and does not repair P098 yield.

## Gate Decision

The machine-readable gate table is in `tables/t12_gate_decision.csv`.

| Gate | Result | Reason |
| --- | --- | --- |
| Preserve classic-covered designs | Partial | T49/T51 preserve coverage, but T31 has per-problem yield warnings. |
| Repair improves valid-PPA yield | Partial | T51 improves yield; direct repair variants do not. |
| Repair improves HV or front | Fail | T31, T49, and T59 do not improve headline front evidence. |
| Feedback adds front material | Fail | T59 loses front points versus both classic and T51. |
| Lineage signal is useful | Partial | T51 is a useful recovery base, not a final claim. |

## Visual Evidence

- `figures/t12_t31_holdout_live_aggregate.png`: direct fail-feedback loses the
  T26 holdout HV/HV-AUC signal.
- `figures/t12_t49_metric_delta_summary.png`: role-separated repair improves
  best score/HV-AUC but loses front and valid-PPA volume.
- `figures/t12_t51_metric_delta_summary.png`: code-individual front-slot
  recovery restores yield and HV-AUC but still trails classic on front breadth.
- `figures/t12_t59_metric_delta_summary.png`: short fail-pool feedback does
  not fix the T51 front-breadth blocker.

## Conclusion

T12 answers the lineage-repair question negatively for direct fail-feedback and
same-budget short feedback. Validity or repair history can be useful as a
diagnostic lane, and T51 proves code-individual front-slot pressure can recover
yield and HV-AUC. But the measured repair variants do not create enough
PPA-front material to justify a fresh exact T12 live run.

Future work should use a materially different source-level repair or
front-rescue lane with explicit per-lane counters. It must not use final PPA,
reference PPA, hypervolume, Pareto rank, pass labels, or problem identity as
in-loop BD inputs.
