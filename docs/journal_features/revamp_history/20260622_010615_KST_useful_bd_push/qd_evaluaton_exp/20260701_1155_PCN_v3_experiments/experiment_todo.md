# PCN-v3 Experiment Todo And Status

Last updated: 2026-07-03 02:43 UTC.

This file is the live tracker for the PCN-v3 C-F ablation package. Keep the
frozen protocol in `experiment_plan.md`; update this file when runs complete,
reports are regenerated, or a claim gate changes state.

## Current Status

The RTLLM full five-seed core ablation is complete and packaged. All twenty
method/seed runs finished successfully:

- four core methods;
- five seeds, `1001..1005`;
- 50 RTLLM problems launched;
- 46 reference-complete RTLLM problems used for headline normalized metrics;
- 230 paired rows per comparison.

The claim gate is negative. PCN-v3 memory did not beat the matched no-C-F
classic control, and C-F-restored PCN did not beat original classic.

## Active Run

There is no active run for this stage.

| Field | Value |
| --- | --- |
| Stage | `rtllm_full_5seed` |
| Tmux session | completed launcher; old session may remain idle |
| Run root | `/workspace/exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed` |
| Package marker | `logs/rtllm_full_5seed.package.done` |
| Detailed report | `reports/rtllm_full_5seed_detailed_report.md` |
| Claim status | negative for PCN-v3 under 8x5 RTLLM |

## Claim Gates

| Gate | Status | Evidence | Result Summary |
| --- | --- | --- | --- |
| G1. Package scaffold exists | done | commit `247fa598f8` | Created local commands, reports, tables, figures, logs, tools, and method wrappers. |
| G2. Operator-set control implemented | done | commit `bafb47d49b` | Added `--eoh_success_operator_set` so C-F can be controlled independently from QD/archive fusion. |
| G3. Unit and lint checks pass | done | `pytest`, `ruff`, `git diff --check` | Focused tests cover classic one-parent exclusion and PCN memory request behavior. |
| G4. Smoke operator audit passes | done | `analysis/rtllm_smoke/seed_1001/operator_contract.csv` | Classic and PCN-CF-restored produced C-F; no-CF arms produced zero C-F; no arm used `single_thought_operator`. |
| G5. Smoke metric sanity is positive | done | `tables/rtllm_smoke_comparison_summary.csv` | PCN-CF-restored beat classic on the three-problem smoke, but smoke was not decisive. |
| G6. Five-seed RTLLM core ablation completes | done | `logs/rtllm_full_5seed.package.done` | All 20 method/seed runs completed and were packaged. |
| G7. C-F confound is resolved | done | `tables/rtllm_full_5seed_comparison_summary.csv` | Removing C-F alone was not a significant win; PCN did not survive the matched controls. |
| G8. PCN memory survives operator control | fail | `tables/rtllm_full_5seed_claim_gate_summary.csv` | PCN no-C-F lost to classic no-C-F; PCN C-F-restored lost to original classic. |
| G9. Final reports and figures complete | done | `reports/rtllm_full_5seed_detailed_report.md` | Detailed tables, figures, and mechanism summary were generated. |
| G10. Elite-cell variants decision | blocked | negative core RTLLM claim gate | Do not run elite variants automatically; the core PCN claim did not validate. |
| G11. VerilogEval holdout decision | blocked | negative core RTLLM claim gate | Holdout is not useful for confirming PCN-v3 unless a revised PCN design is approved. |
| G12. Dependency hardening | deferred | external repo/submodule audit | Still useful later, but no longer blocks this PCN-v3 result. |

## Milestone Checklist

| ID | Task | Status | Result Summary | Artifact |
| --- | --- | --- | --- | --- |
| M1 | Identify PCN-v3 confound | done | Prior PCN-v3 differed from classic by adding memory and removing C-F. | `experiment_plan.md` |
| M2 | Add narrow operator-control interface | done | `classic` keeps C-F; `one_parent` removes C-F without changing QD/archive fusion. | source and tests |
| M3 | Create experiment package | done | Package mirrors RTLLM full-suite organization for reproducibility. | `README.md`, `commands/`, `tools/` |
| M4 | Define exact method wrappers | done | Four core RTLLM arms and two optional elite arms have fixed CLI flags. | `commands/methods/` |
| M5 | Run RTLLM smoke | done | Four core arms ran on the three smoke RTLLM designs at seed 1001. | `logs/rtllm_smoke.*` |
| M6 | Package smoke results | done | Smoke tables, figures, operator audit, and report are archived. | commit `10220d3841` |
| M7 | Launch five-seed RTLLM core ablation | done | Full run completed across all five seeds and four core methods. | `logs/rtllm_full_5seed.*` |
| M8 | Package five-seed RTLLM results | done | Generated paired metrics, operator audits, summaries, and plots. | `tables/`, `figures/`, `reports/` |
| M9 | Decide PCN memory claim | done | Claim is negative under 8x5 RTLLM: PCN-v3 did not beat controls. | `reports/rtllm_full_5seed_detailed_report.md` |
| M10 | Run elite-cell variants | blocked | Core PCN evidence failed; do not spend more without a redesign plan. | `rtllm_elite` |
| M11 | Run VerilogEval holdout | blocked | Holdout should wait for a revised PCN variant or a different positive candidate. | `verilogeval_holdout` |
| M12 | Write final report package | done | Detailed C-F ablation, statistics, mechanism analysis, and limitations are written. | `reports/rtllm_full_5seed_detailed_report.md` |
| M13 | Harden external dependencies | deferred | Decide later whether MasterRTL/RTLTimer repos should become submodules or pinned manifests. | future docs |

## Per-Arm Status

| Arm | Full RTLLM Status | Mean HV | Mean HV-AUC | Covered Problems | C-F Count | Result Summary |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| `classic_revolution_8x5` | done | 0.103802 | 0.086797 | 32.8 | 768 | Original conference-style baseline. |
| `classic_no_cf_8x5` | done | 0.106846 | 0.094592 | 33.2 | 0 | Slightly higher mean HV/AUC, but not statistically significant over classic. |
| `pcn_v3_no_cf_memory_8x5` | done | 0.100396 | 0.087031 | 33.0 | 0 | Lost to matched no-C-F classic control. |
| `pcn_v3_cf_restored_memory_8x5` | done | 0.101664 | 0.080466 | 32.0 | 670 | Lost to original classic and had lower valid-PPA yield. |
| `pcn_v3_cf_restored_elite3_8x5` | blocked | TBD | TBD | TBD | TBD | Do not run automatically after negative core gate. |
| `pcn_v3_cf_restored_pareto3_8x5` | blocked | TBD | TBD | TBD | TBD | Do not run automatically after negative core gate. |

## Completed Result Summaries

### Code And Config Correction

`--eoh_success_operator_set` was added to separate EoH success-pool operator
choice from QD/archive two-parent fusion. This preserves the ability to disable
QD fusion in PCN while restoring the classic `C-F` operator in the
classic-preserving lane.

Validation completed:

- `classic` mode allows `C-F` when the EoH success pool has two parents;
- `one_parent` mode excludes `C-F`;
- PCN memory can build a memory request while QD two-parent fusion stays
  disabled;
- focused `pytest`, `ruff`, and `git diff --check` passed.

### RTLLM Smoke Operator Audit

The smoke stage checked the four core arms on three RTLLM problems with seed
1001.

| Method | C-F Count | Single-Thought Count | Operator Audit |
| --- | ---: | ---: | --- |
| `classic_revolution_8x5` | 20 | 0 | pass |
| `classic_no_cf_8x5` | 0 | 0 | pass |
| `pcn_v3_no_cf_memory_8x5` | 0 | 0 | pass |
| `pcn_v3_cf_restored_memory_8x5` | 18 | 0 | pass |

This confirms that the experiment did not repeat the earlier thought-only or
single-thought mistake.

### RTLLM Full Five-Seed Result

The full run reversed the smoke-level optimism.

| Comparison | Mean HV Delta | Mean HV-AUC Delta | Wins/Losses/Ties | Interpretation |
| --- | ---: | ---: | --- | --- |
| `classic_no_cf - classic` | +0.0030 | +0.0078 | 41/41/148 | Small, not significant. |
| `pcn_no_cf - classic_no_cf` | -0.0065 | -0.0076 | 34/48/148 | PCN memory fails matched no-C-F control. |
| `pcn_cf_restored - classic` | -0.0021 | -0.0063 | 31/48/151 | Clean PCN test fails. |
| `pcn_cf_restored - pcn_no_cf` | +0.0013 | -0.0066 | 40/35/155 | C-F restoration helps final HV slightly but not enough. |

### Mechanism Result

PCN memory did fire:

| Method | Classic-Lane Events | Memory-Refine Events | Memory-Refine Global Inserts |
| --- | ---: | ---: | ---: |
| `pcn_v3_no_cf_memory_8x5` | 3934 | 332 | 21 |
| `pcn_v3_cf_restored_memory_8x5` | 3240 | 285 | 18 |

The negative result is therefore not caused by an inactive memory lane. The
memory lane was active but did not create enough useful front material to
overcome lower yield and weaker HV-AUC.

## Next Actions

1. Commit the full RTLLM package artifacts and detailed report.
2. Do not launch `rtllm_elite` automatically from this PCN-v3 result.
3. If continuing PCN, write a revised diagnostic plan focused on valid-PPA
   yield preservation and stricter memory activation.
4. Consider VerilogEval only after a revised PCN or another candidate has a
   positive RTLLM core gate.
5. Keep the negative result in the presentation as evidence that the C-F
   confound was real and that PCN memory did not validate under 8x5.

## Update Rules

- Do not promote smoke-only results to headline claims.
- Use reference-complete RTLLM rows for headline normalized metrics.
- Exclude missing-reference designs from headline direct comparisons.
- Count missing candidate PPA as invalid for that method.
- Record the commit hash for each packaged milestone.
