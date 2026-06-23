# T53 Sparse-Front Trigger QD Methodology

Status: pre-registered; not launched.

## Question

T51 restored direct-code yield, HV-AUC, and best-score pressure, but classic
still had more raw PPA-front breadth. T52 showed that simply widening every
cell to a full local Pareto set adds a few front points but damages yield,
HV-AUC, and best score.

T53 asks whether a bounded trigger can recover some front pressure without
abandoning T51's one-slot archive default.

## Method Delta From T51

T53 keeps fixed:

- hard/tuning 13-problem surface;
- seed `1001`;
- local vLLM model and 128k token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- SR-PCA descriptor profile;
- grid-quantile warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- no repair;
- no two-parent fusion.

T53 changes only parent selection:

- T51: `qd_parent_selection=nsga2_global_rank`;
- T53: `qd_parent_selection=sparse_front_triggered_nsga2`.

The new mode uses the same NSGA-II global-rank parent pool as T51. When the
active `elite_pareto_slot` archive has at least four occupied cells and fewer
than two extra local-front slots beyond one member per occupied cell, it lowers
the champion lane from `0.80` to `0.65` for that parent-sampling call.

Outside that sparse-front condition, T53 is T51.

## Leakage Rules

The trigger can inspect only the current archive occupancy and retained
archive-member counts after candidate evaluation. It must not use classic
results, held-out outcomes, problem identity, final PPA-front labels, or
reference PPA as a descriptor or trigger input.

Evaluated PPA may affect archive quality, local Pareto retention, and NSGA-II
rank after a candidate has been evaluated. This is the same post-evaluation
quality channel used by T47 through T52.

## Comparator Surface

Use the T47 through T52 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `data/configs/hard_iteration_subset.yaml`;
- seed: start with `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning root;
- QD comparators: T51 code-thought front-slot and T52 full-Pareto widening.

Do not change the subset after seeing T53 outcomes.

## Required Measurements

Report:

- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T51 and T52 for valid-PPA count, HV, HV-AUC, aggregate front
  points, unique PPA points, and reference-beating candidates;
- generated code candidates versus classic/T51/T52;
- classic-covered valid-PPA design losses;
- per-problem front wins/losses, especially `Prob015_multi_pipe_8bit`;
- active archive coverage, archive members, local-front counts, and sparse
  trigger counts;
- direct raw area-power PPA-front figures and candidate-level data;
- Phase 03.1 `qd_ppa_viewer/` if archive artifacts support export.

## Acceptance Signals

T53 can advance only if it:

- preserves every classic-covered valid-PPA design on the compared surface;
- avoids a 50 percent valid-PPA yield warning where classic has at least
  10 passing samples;
- improves T51 on aggregate PPA-front points or unique PPA points;
- keeps T51's valid-PPA count within 10 percent;
- keeps HV-AUC non-negative versus classic or positive versus T51;
- shows nonzero sparse-front trigger use in the QD summary.

If T53 improves front breadth but loses T51's yield/HV-AUC recovery, mark it
`T0` and keep it as evidence that parent pressure alone is insufficient. If it
preserves T51 yield while improving front material, run seed `1002` or a
held-out screen before any useful-QD claim.
