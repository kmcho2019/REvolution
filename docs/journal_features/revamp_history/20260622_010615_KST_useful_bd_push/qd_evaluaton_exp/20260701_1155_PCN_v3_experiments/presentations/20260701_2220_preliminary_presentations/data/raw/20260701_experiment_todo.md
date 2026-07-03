# PCN-v3 Experiment Todo And Status

Last updated: 2026-07-01 06:02 UTC.

This file is the live tracker for the PCN-v3 C-F ablation package. Keep the
frozen protocol in `experiment_plan.md`; update this file when runs complete,
reports are regenerated, or a claim gate changes state.

## Current Status

The implementation correction and RTLLM smoke stage are complete. The smoke
confirmed that the operator-control interface works and that the corrected
PCN-CF-restored arm can generate `C-F` requests while QD/archive fusion stays
disabled.

The five-seed RTLLM core ablation is running. One of twenty full runs has
completed:

- completed: `seed_1001.classic_revolution_8x5`;
- active: `seed_1001.classic_no_cf_8x5`;
- pending: remaining seeds and PCN arms.

No publication-safe PCN claim is allowed yet. The smoke signal is positive but
too small to resolve the C-F confound statistically.

## Active Run

| Field | Value |
| --- | --- |
| Stage | `rtllm_full_5seed` |
| Tmux session | `pcn_v3_20260701_rtllm_full_5seed` |
| Run root | `/workspace/exp/useful_bd_push/pcn_v3_experiments_20260701/live/rtllm_full_5seed` |
| Package log | `logs/rtllm_full_5seed.package.log` |
| Stage log | `logs/rtllm_full_5seed.run_stage.log` |
| Current watcher state | waiting for 19 remaining runs |

## Claim Gates

| Gate | Status | Evidence | Result Summary |
| --- | --- | --- | --- |
| G1. Package scaffold exists | done | commit `247fa598f8` | Created local commands, reports, tables, figures, logs, tools, and method wrappers. |
| G2. Operator-set control implemented | done | commit `bafb47d49b` | Added `--eoh_success_operator_set` so C-F can be controlled independently from QD/archive fusion. |
| G3. Unit and lint checks pass | done | `pytest`, `ruff`, `git diff --check` | Focused tests cover classic one-parent exclusion and PCN memory request behavior. |
| G4. Smoke operator audit passes | done | `analysis/rtllm_smoke/seed_1001/operator_contract.csv` | Classic and PCN-CF-restored produced C-F; no-CF arms produced zero C-F; no arm used `single_thought_operator`. |
| G5. Smoke metric sanity is positive | done | `tables/rtllm_smoke_comparison_summary.csv` | PCN-CF-restored beat classic on the three-problem smoke, but this is not enough for a claim. |
| G6. Five-seed RTLLM core ablation completes | running | `logs/rtllm_full_5seed.*` | One of twenty method/seed runs is done; package watcher is still waiting. |
| G7. C-F confound is resolved | pending | full comparison tables | Requires paired five-seed results for classic, no-CF classic, no-CF PCN, and C-F-restored PCN. |
| G8. PCN memory survives operator control | pending | full comparison tables | Requires PCN to improve over the matched operator-control baseline without coverage collapse. |
| G9. Final reports and figures complete | pending | `reports/`, `figures/`, `tables/` | Wait for full stage packaging. |
| G10. Elite-cell variants decision | blocked | core RTLLM result | Run only if the core ablation supports a PCN memory effect. |
| G11. VerilogEval holdout decision | pending | core RTLLM result | Run after RTLLM decides the best clean PCN candidate. |
| G12. Dependency hardening | pending | external repo/submodule audit | Consider persistent MasterRTL/RTLTimer dependency tracking after the main claim is known. |

## Milestone Checklist

| ID | Task | Status | Result Summary | Artifact |
| --- | --- | --- | --- | --- |
| M1 | Identify PCN-v3 confound | done | Prior PCN-v3 differed from classic by adding memory and removing C-F. | `experiment_plan.md` |
| M2 | Add narrow operator-control interface | done | `classic` keeps C-F; `one_parent` removes C-F without changing QD/archive fusion. | source and tests |
| M3 | Create experiment package | done | Package mirrors RTLLM full-suite organization for reproducibility. | `README.md`, `commands/`, `tools/` |
| M4 | Define exact method wrappers | done | Four core RTLLM arms and two optional elite arms have fixed CLI flags. | `commands/methods/` |
| M5 | Run RTLLM smoke | done | Four core arms ran on the three smoke RTLLM designs at seed 1001. | `logs/rtllm_smoke.*` |
| M6 | Package smoke results | done | Smoke tables, figures, operator audit, and report are archived. | commit `10220d3841` |
| M7 | Launch five-seed RTLLM core ablation | running | Full run is active in tmux; one of twenty method/seed runs is complete. | `logs/rtllm_full_5seed.*` |
| M8 | Package five-seed RTLLM results | pending | Generate paired metrics, operator audits, summaries, and plots after all runs finish. | `tables/`, `figures/`, `reports/` |
| M9 | Decide PCN memory claim | pending | Compare PCN against matched operator controls on reference-complete RTLLM rows. | final report |
| M10 | Run elite-cell variants | blocked | Only run if core PCN evidence survives the C-F control. | `rtllm_elite` |
| M11 | Run VerilogEval holdout | pending | Use the best clean PCN candidate after RTLLM core decision. | `verilogeval_holdout` |
| M12 | Write final report package | pending | Include C-F ablation, statistical analysis, mechanism analysis, and limitations. | `reports/` |
| M13 | Harden external dependencies | deferred | Decide whether to promote MasterRTL/RTLTimer external repos into tracked submodules or a pinned dependency manifest. | future docs |

## Per-Arm Status

| Arm | Smoke Status | Full RTLLM Status | Expected C-F Policy | Smoke Mean HV | Notes |
| --- | --- | --- | --- | --- | --- |
| `classic_revolution_8x5` | done | seed 1001 done | observed `C-F` > 0 | 0.333995 | Original conference-style baseline. |
| `classic_no_cf_8x5` | done | seed 1001 running | `C-F` = 0 | 0.339492 | Tests whether removing C-F alone helps. |
| `pcn_v3_no_cf_memory_8x5` | done | pending | `C-F` = 0 | 0.346485 | Reproduces current PCN behavior explicitly. |
| `pcn_v3_cf_restored_memory_8x5` | done | pending | observed `C-F` > 0 | 0.516854 | Cleanest PCN-vs-classic test. |
| `pcn_v3_cf_restored_elite3_8x5` | not run | blocked | observed `C-F` > 0 | TBD | Optional follow-up after core validation. |
| `pcn_v3_cf_restored_pareto3_8x5` | not run | blocked | observed `C-F` > 0 | TBD | Optional local Pareto/crowding cell follow-up. |

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

This confirms that the experiment is no longer repeating the earlier
thought-only or single-thought mistake.

### RTLLM Smoke Metric Signal

Smoke results are encouraging but not decisive.

| Method | Mean HV | Mean HV-AUC |
| --- | ---: | ---: |
| `classic_revolution_8x5` | 0.333995 | 0.243611 |
| `classic_no_cf_8x5` | 0.339492 | 0.302403 |
| `pcn_v3_no_cf_memory_8x5` | 0.346485 | 0.316931 |
| `pcn_v3_cf_restored_memory_8x5` | 0.516854 | 0.312627 |

Interpretation:

- removing C-F alone helped slightly on the smoke subset;
- no-CF PCN also improved slightly over no-CF classic;
- C-F-restored PCN had the strongest smoke mean HV;
- the sample is only three problems, so the full five-seed RTLLM run decides
  the claim.

### Full RTLLM Launch

The full stage is running the four core arms across seeds `1001..1005` and all
50 RTLLM problems. Headline comparisons will use only reference-complete paired
design rows. The first method/seed run completed successfully:
`seed_1001.classic_revolution_8x5`.

## Next Actions

1. Monitor `rtllm_full_5seed` until all twenty method/seed runs finish or fail.
2. Package the full stage with `commands/package_stage.sh rtllm_full_5seed`.
3. Inspect the full-stage operator contract before reading performance metrics.
4. Generate paired reference-complete HV, HV-AUC, coverage, and C-F ablation
   tables.
5. Decide whether PCN memory survives the matched operator controls.
6. Run elite-cell variants only if the core result supports PCN memory.
7. Run VerilogEval holdout after the RTLLM core decision.
8. Write final reports with plots, conclusions, limitations, and allowed
   claims.

## Update Rules

- Update this file after each full-stage method/seed completion, packaging
  pass, or claim-gate decision.
- Do not promote smoke-only results to headline claims.
- Use reference-complete RTLLM rows for headline normalized metrics.
- Exclude missing-reference designs from headline direct comparisons.
- Count missing candidate PPA as invalid for that method.
- Record the commit hash for each packaged milestone.
