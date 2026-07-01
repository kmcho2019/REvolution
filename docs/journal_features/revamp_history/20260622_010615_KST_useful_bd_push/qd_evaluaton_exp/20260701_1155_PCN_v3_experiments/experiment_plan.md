# PCN-v3 Statistical And C-F Ablation Plan

This is the stable protocol for the PCN-v3 ablation package. Keep live
progress, completed-task summaries, and run status in `experiment_todo.md`.

## Goal

Test PCN-v3 rigorously enough to decide whether it is a real improvement over
classic REvolution or mostly an operator-set artifact.

The prior corrected RTLLM full-suite result suggested that
`pcn_v3_rf_stagnation_memory_8x5` could outperform the classic REvolution
conference baseline. That result was promising, but it was not an isolated
test of PCN memory because the PCN configuration also removed the `C-F`
success operator.

The experiment therefore separates two effects:

1. removing or retaining `C-F` in the EoH success pool;
2. adding PCN guarded QD memory on top of the selected EoH operator set.

## Confound Being Tested

The original PCN-v3 run set:

```text
--qd_two_parent_probability 0.00
--qd_two_parent_gate none
```

That disabled QD/archive two-parent fusion, which was intentional. It also
caused the PCN success-request branch to use only one-parent EoH operators:

```text
M-S, M-E, M-R, M-I
```

The classic baseline used:

```text
M-S, M-E, M-R, M-I, C-F
```

So the earlier win had two simultaneous changes:

1. guarded PCN memory was added;
2. `C-F` was removed from the classic-like success lane.

This package tests whether PCN memory still helps after controlling for that
operator-set difference.

## Questions

1. Is the observed PCN-v3 advantage statistically credible across five RTLLM
   seeds?
2. Does removing `C-F` alone explain the observed gain?
3. Does a C-F-restored PCN memory variant preserve the result?
4. Does the RF/MasterRTL/RTLTimer memory design generalize beyond RTLLM,
   including VerilogEval Spec-to-RTL holdout designs?

## Operator Control

The package adds one narrow operator-control interface:

```text
--eoh_success_operator_set {classic,one_parent}
```

The meanings are:

| Value | Success operators |
| --- | --- |
| `classic` | `M-S`, `M-E`, `M-R`, `M-I`, `C-F` |
| `one_parent` | `M-S`, `M-E`, `M-R`, `M-I` |

This switch controls the EoH success-pool operators used by classic REvolution
and by the PCN classic-preserving lane. It must not enable QD/archive
two-parent fusion. PCN keeps `--qd_two_parent_probability 0.00` unless a later
experiment explicitly tests archive fusion.

The key correction is separating two concepts:

- `qd_two_parent_probability`: controls QD/archive two-parent fusion.
- `eoh_success_operator_set`: controls whether the EoH success pool may use
  `C-F`.

## Core RTLLM Arms

| Method | Purpose |
| --- | --- |
| `classic_revolution_8x5` | Original classic baseline with `C-F`. |
| `classic_no_cf_8x5` | Tests whether removing `C-F` alone helps. |
| `pcn_v3_no_cf_memory_8x5` | Reproduces current PCN behavior explicitly. |
| `pcn_v3_cf_restored_memory_8x5` | Clean PCN memory test with classic `C-F` restored. |

All four core arms use the same model, benchmark set, budget, seed set,
evaluator, PPA parser, and reporting scripts. The intended difference is only
the operator set and whether guarded PCN memory is active.

## Main Comparisons

| Comparison | Interpretation |
| --- | --- |
| `classic_no_cf_8x5 - classic_revolution_8x5` | Effect of removing `C-F`. |
| `pcn_v3_no_cf_memory_8x5 - classic_no_cf_8x5` | Memory effect after controlling for no `C-F`. |
| `pcn_v3_cf_restored_memory_8x5 - classic_revolution_8x5` | Cleanest PCN-vs-classic claim. |
| `pcn_v3_cf_restored_memory_8x5 - pcn_v3_no_cf_memory_8x5` | Whether restoring `C-F` helps PCN. |

## Optional Follow-Up Arms

Run these only if the core ablation supports a PCN memory effect.

| Method | Purpose |
| --- | --- |
| `pcn_v3_cf_restored_elite3_8x5` | Current champion-plus-slot cell model with three elites per cell. |
| `pcn_v3_cf_restored_pareto3_8x5` | Local Pareto/crowding cell selection with three elites per cell. |

The elite variants test whether the current one scalar champion plus one
locally useful tradeoff slot is too restrictive. They are not first-line
evidence because they add another hyperparameter change on top of the core PCN
claim.

## VerilogEval Holdout

Run VerilogEval Spec-to-RTL only after the RTLLM core decision.

| Method | Purpose |
| --- | --- |
| `classic_revolution_8x5` | Baseline. |
| `classic_no_cf_8x5` | C-F confound check. |
| `pcn_v3_cf_restored_memory_8x5` | Best clean PCN candidate. |

The holdout question is whether the corrected PCN result is RTLLM-specific or
whether it transfers to a different spec-to-RTL benchmark family.

## Run Ladder

1. `rtllm_smoke`: four core methods, seed `1001`, three RTLLM smoke designs.
2. `rtllm_full_5seed`: four core methods, seeds `1001..1005`, 50 RTLLM
   designs; headline metrics use only the reference-complete subset.
3. `rtllm_elite`: elite-cell variants only if the core ablation supports a PCN
   memory effect.
4. `verilogeval_holdout`: classic, classic-no-C-F, and C-F-restored PCN on the
   frozen VerilogEval Spec-to-RTL holdout designs.

## Evaluation Rules

Headline RTLLM claims use paired reference-complete design rows only.

Rules:

- missing reference `ppa.txt`: exclude from headline normalized comparisons;
- missing candidate PPA: count as invalid for that method;
- same design must be present for both methods in a paired comparison;
- operator-count audit must pass before any performance claim;
- smoke results are implementation checks, not publication-safe evidence.

Report:

- paired per-problem/per-seed HV deltas;
- mean and median delta;
- bootstrap 95% confidence interval;
- sign-test win/loss/tie counts;
- Wilcoxon signed-rank p-value when enough nonzero pairs exist;
- seed-level mean HV and HV-AUC;
- valid-PPA coverage and operator counts;
- memory-lane contribution metrics for PCN arms.

## Claim Gate

PCN memory can be credited only if at least one controlled comparison supports
it:

1. `pcn_v3_no_cf_memory_8x5` improves over `classic_no_cf_8x5`; or
2. `pcn_v3_cf_restored_memory_8x5` improves over
   `classic_revolution_8x5`.

The result must also avoid:

- a valid-PPA coverage collapse;
- a hidden operator mismatch;
- single-thought or thought-only operator regression;
- defaulted-reference headline metrics.

If `classic_no_cf_8x5` matches `pcn_v3_no_cf_memory_8x5`, the prior win should
be interpreted mostly as an operator simplification result. If
`pcn_v3_cf_restored_memory_8x5` wins while preserving coverage and operator
audit correctness, the clean PCN memory claim becomes substantially stronger.

## Reporting Package

The package should end with:

- `README.md`: navigation and current high-level status;
- `experiment_plan.md`: this frozen protocol;
- `experiment_todo.md`: live status, task checklist, and result summaries;
- `method_configs.md`: exact CLI flags and descriptor definitions;
- `commands/`: launch scripts and per-method wrappers;
- `logs/`: run logs and done/failed markers;
- `tables/`: per-seed, per-problem, and aggregate metrics;
- `figures/`: reader-facing plots;
- `reports/`: final report, C-F ablation report, and mechanism report;
- `analysis/`: raw derived CSV/JSON used to regenerate plots.
