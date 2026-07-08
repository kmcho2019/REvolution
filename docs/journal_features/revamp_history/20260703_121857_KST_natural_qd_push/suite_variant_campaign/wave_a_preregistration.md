# Wave A Pre-Registration

Date: 2026-07-08.

## Rationale

The 8-design screen has weak transfer to full RTLLM. Wave A therefore
uses full RTLLM directly for implemented, natural variants that need no
core engine changes.

## Scope

Full RTLLM 50-problem run, headline restricted to the 46
reference-complete designs as in P3. Population/generation shape stays
8x5 except descriptor-completion arms that reuse existing P3c settings.

## Baselines

Classic 5-seed baseline: `0.103802` HV, `0.086982` HV-AUC46,
coverage `164/230`.

V2 5-seed baseline: `0.098801` HV, `0.087428` HV-AUC46,
coverage `166/230`.

## Arms

| ID | Arm | Seeds | Change |
| --- | --- | --- | --- |
| S01 | capacity7 | 1001-1002 | `qd_max_elites_per_cell=7`. |
| S02 | warmup16 | 1001-1002 | `qd_grid_quantile_warmup_successes=16`. |
| S03 | elite_pareto_slot_2 | 1001-1002 | `qd_cell_mode=elite_pareto_slot`, `qd_max_elites_per_cell=2`. |
| S04 | compact8d_cvt_complete | 1003-1005 | Complete existing compact8d CVT suite arm to 5 seeds. |
| S05 | trio_cvt_complete | 1003-1005 | Complete existing trio CVT suite control to 5 seeds. |
| S06 | gt3d_complete | 1003-1005 | Optional coverage-focused completion. |

S06 runs only if the manuscript explicitly wants a functionality/coverage
appendix arm after S01-S05 status is known.

## Gates

- Every launched seed needs vLLM preflight, 128k token budgets,
  `qd_operator_kind=eoh_strategies`, `representation_kind=code_individual`,
  `--eoh_success_operator_set classic`, operator audit, and config-pin
  validation.
- Promote S01-S03 to seeds 1003-1005 if the 2-seed read reaches classic
  mean HV or clearly improves coverage/functionality over classic.
- Promote S04/S05 only after the 5-seed completion packages cleanly.
- Quarantine any run with nonzero `single_thought_count`, failed
  validation, missing reference-complete package, or descriptor leakage.

## Interpretation

One- or two-seed reads do not create paper claims. They decide which arms
deserve 5-seed confirmation.
