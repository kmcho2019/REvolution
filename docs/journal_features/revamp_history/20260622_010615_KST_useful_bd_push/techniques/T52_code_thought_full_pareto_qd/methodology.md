# T52 Code-Thought Full-Pareto QD Methodology

Status: pre-registered; no live result yet.

## Question

T51 recovered the candidate budget, valid-PPA yield, HV-AUC, and best-score
pressure that T50 lost, but it still lost raw PPA-front breadth versus classic.
T52 asks whether that front loss is caused by T51's one-slot local-front rule.

The test keeps T51's recovered substrate and changes only the archive-retention
surface from one champion plus one front slot to a full per-cell local Pareto
set. This is the narrowest existing-knob follow-up that directly targets
T51's front-breadth blocker.

## Method Delta From T51

T52 keeps fixed:

- hard/tuning 13-problem surface;
- seed `1001`;
- local vLLM model and 128k token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- SR-PCA descriptor profile;
- grid-quantile warmup `4`;
- champion lane `0.80`;
- NSGA-II global-rank parent selection;
- no repair;
- no two-parent fusion.

T52 changes only:

- archive cell mode: `pareto_front`, not `elite_pareto_slot`;
- per-cell capacity: `qd_max_elites_per_cell=5`, matching the exact T26/T47
  full-Pareto local retention surface.

This is not a new behavior descriptor. It is an archive-coupling ablation that
tests whether T51's useful operator/representation combination needs a wider
local Pareto cell to preserve raw PPA-front material.

## Leakage Rules

The behavior descriptor remains `sr_pca_3d`, fitted from the pre-existing
non-PPA synthesis-response profile. T52 must not use final PPA, reference PPA,
fitness, hypervolume, Pareto-front labels, problem identity, corpus, model
identity, or test pass rate as a BD input.

Evaluated PPA may affect archive quality, local Pareto retention, and
NSGA-II parent selection only after candidate evaluation, as in T47 through
T51. It must not define descriptor axes or the screening subset.

## Comparator Surface

Use the T47 through T51 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `data/configs/hard_iteration_subset.yaml`;
- seed: start with `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning root;
- QD comparators: T47 exact T26, T48 gated near-front fusion, T49 thought-k
  repair, T50 candidate-matched thought front, and T51 code-thought front slot.

Do not change the subset after seeing T52 outcomes.

## Required Measurements

Report:

- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T51 for valid-PPA count, HV, HV-AUC, aggregate front points,
  unique PPA points, and reference-beating candidates;
- generated code candidates versus classic/T47/T48/T49/T50/T51;
- classic-covered valid-PPA design losses;
- per-problem front wins/losses, especially `Prob015_multi_pipe_8bit`;
- active archive coverage, archive members, and local-front counts;
- direct raw area-power PPA-front figures and candidate-level data;
- Phase 03.1 `qd_ppa_viewer/` if archive artifacts support export.

## Acceptance Signals

T52 can advance only if it:

- preserves every classic-covered valid-PPA design on the compared surface;
- improves T51 on aggregate PPA-front points or unique PPA points;
- avoids losing T51's valid-PPA count by more than 10 percent;
- avoids a new 50 percent valid-PPA yield warning where classic has at least
  10 passing samples;
- keeps mean HV-AUC non-negative versus classic or positive versus T51;
- includes direct raw area-power PPA-front figures and candidate-level data.

If T52 improves front breadth but loses T51's yield/HV-AUC recovery, mark it
`T0` and use it only as evidence for a bounded front lane. If T52 preserves
T51 yield while improving front material, advance to a seed `1002` or held-out
screen before any useful-QD claim.
