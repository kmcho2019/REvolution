# Experiment Plan

## Goal

Test PCN-v3 rigorously enough to decide whether it is a real improvement over
classic REvolution or mostly an operator-set artifact.

The key correction is separating two concepts:

- `qd_two_parent_probability`: controls QD/archive two-parent fusion.
- `eoh_success_operator_set`: controls whether the EoH success pool may use
  `C-F`.

PCN memory should keep QD/archive fusion disabled while allowing the
classic-preserving lane to restore `C-F` when requested.

## Core RTLLM Arms

| Method | Purpose |
| --- | --- |
| `classic_revolution_8x5` | Original classic baseline with `C-F`. |
| `classic_no_cf_8x5` | Tests whether removing `C-F` alone helps. |
| `pcn_v3_no_cf_memory_8x5` | Reproduces current PCN behavior explicitly. |
| `pcn_v3_cf_restored_memory_8x5` | Clean PCN memory test with classic `C-F` restored. |

## Main Comparisons

| Comparison | Interpretation |
| --- | --- |
| `classic_no_cf_8x5 - classic_revolution_8x5` | Effect of removing `C-F`. |
| `pcn_v3_no_cf_memory_8x5 - classic_no_cf_8x5` | Memory effect after controlling for no `C-F`. |
| `pcn_v3_cf_restored_memory_8x5 - classic_revolution_8x5` | Cleanest PCN-vs-classic claim. |
| `pcn_v3_cf_restored_memory_8x5 - pcn_v3_no_cf_memory_8x5` | Whether restoring `C-F` helps PCN. |

## Run Ladder

1. `rtllm_smoke`: four core methods, seed `1001`, three RTLLM smoke designs.
2. `rtllm_full_5seed`: four core methods, seeds `1001..1005`, 50 RTLLM
   designs; headline metrics use only the reference-complete subset.
3. `rtllm_elite`: run elite-cell variants only if the core ablation supports
   a PCN memory effect.
4. `verilogeval_holdout`: classic, classic-no-C-F, and C-F-restored PCN on the
   three frozen VerilogEval Spec-to-RTL holdout designs.

## Statistical Rules

Headline RTLLM claims use paired reference-complete design rows only.

Report:

- paired per-problem/per-seed HV deltas;
- mean and median delta;
- bootstrap 95% confidence interval;
- sign-test win/loss/tie counts;
- Wilcoxon signed-rank p-value when enough nonzero pairs exist;
- seed-level mean HV and HV-AUC;
- valid-PPA coverage and operator counts.

## Claim Gate

PCN memory can be credited only if:

1. `pcn_v3_no_cf_memory_8x5` improves over `classic_no_cf_8x5`, or
2. `pcn_v3_cf_restored_memory_8x5` improves over `classic_revolution_8x5`,

and the result does not hide a coverage collapse or operator mismatch.
