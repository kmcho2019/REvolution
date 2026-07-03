# Methodology Code Audit

This audit cross-checks the presentation claims against method wrappers,
implementation code, and smoke tests. It is read-only presenter prep, not a
new experimental result.

## Audited Sources

- `RTLLM_full_suite/20260629/commands/methods/fg_qdm_rf_leafid_front_credit_8x5.sh`
- `RTLLM_full_suite/20260630/commands/methods/pcn_v3_rf_stagnation_memory_8x5.sh`
- `qd_evaluaton_exp/20260701_1155_PCN_v3_experiments/commands/methods/*.sh`
- `src/revolution/algorithm.py`
- `src/revolution/qd/engine.py`
- `scripts/run_backend.py`
- `tests/revolution/test_algorithm.py`
- `tests/revolution/test_qd_engine.py`

## Cross-Checks

| Claim | Check | Result |
| --- | --- | --- |
| 20260629 QD was operator-confounded. | Representative FG-QDM wrapper uses `--qd_operator_kind single_thought_operator`. | Confirmed. |
| 20260630 corrected the QD operator path. | PCN wrapper uses `--qd_operator_kind eoh_strategies`. | Confirmed. |
| PCN mode does not allow `single_thought_operator`. | `QDEngine` raises if `pcn_classic_preserving_memory` is not paired with `eoh_strategies`. | Confirmed. |
| PCN keeps QD/archive two-parent fusion disabled. | Wrappers set `--qd_two_parent_probability 0.00`; engine rejects nonzero probability in memory modes. | Confirmed. |
| 20260701 isolates C-F from memory. | Wrappers expose `--eoh_success_operator_set classic` versus `one_parent`. | Confirmed. |
| C-F restoration affects EoH success operators, not QD fusion. | PCN C-F-restored wrapper has `--eoh_success_operator_set classic` and `--qd_two_parent_probability 0.00`. | Confirmed. |
| Memory lane is small and gated. | PCN wrapper uses `0.90` classic, `0.10` memory-refine; engine caps PCN memory lanes at `15%`. | Confirmed. |
| Active PCN generations force one memory-refine slot. | `_front_guarded_memory_counts()` uses `max(1, memory_refine)` after memory is sampleable. | Confirmed. |

## Methodology Caveat Added To Deck

The 20260630 PCN-v3 run is positive but not a clean memory-only causal result.
It restored EoH-style operation, but the PCN configuration still disabled C-F
relative to original classic. The presentation now states this on slide 17 and
uses slide 22 plus the appendix to explain the required C-F ablation.

## Figure Review Notes

- Slide 11 was changed from a text table to a descriptor-family rank chart.
- The new chart displays both mean-HV retention and covered designs, avoiding a
  separate table in the main deck.
- Existing concept figures were inspected through contact sheets; the remaining
  figures are simple enough for slide projection and do not contain obvious
  overlaps after the prior fixes.
