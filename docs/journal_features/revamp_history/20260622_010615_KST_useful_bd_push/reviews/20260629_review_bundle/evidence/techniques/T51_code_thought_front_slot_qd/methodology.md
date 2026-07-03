# T51 Code-Thought Front-Slot QD Methodology

Status: pre-registered; no live result yet.

## Question

T49 and T50 show that role-separated thought generation can preserve
classic-covered valid-PPA coverage and improve best-score pressure, but the
thought-only path loses valid-PPA count, HV, HV-AUC, and PPA-front material.
T50 also failed to match classic's evaluated-code count in practice.

T51 asks whether the useful part is the single-thought operator rather than the
thought-only representation. It keeps direct code individuals so each
generation evaluates ordinary code candidates, then pairs the operator with the
one-front-slot archive rule from T38/T39.

This is a composite rescue, not a single-causal ablation. A positive result
would justify follow-up ablations; it would not prove whether the gain came
from representation, sparse warmup, the front slot, or their combination.

## Method Delta From T50

T51 keeps the T47-T50 hard/tuning surface, SR-PCA descriptor, local vLLM model,
seed policy, population size, and no-fusion/no-repair rule. It changes the
search substrate:

- representation: `code_individual`, not `thought_only`;
- operator: `single_thought_operator`;
- archive cell mode: `elite_pareto_slot`;
- per-cell capacity: `qd_max_elites_per_cell=2`, meaning one scalar champion
  plus one local PPA-front slot;
- grid-quantile warmup: `qd_grid_quantile_warmup_successes=4`, following the
  T39 sparse-yield archive initialization result;
- champion lane: `qd_champion_lane_fraction=0.80`;
- parent selection: `nsga2_global_rank`;
- two-parent fusion: disabled with `qd_two_parent_probability=0.0`;
- fail-feedback prompt injection: disabled with
  `qd_operator_fail_feedback_chars=0`;
- repair: disabled with `repair_kind=none`.

The intended mechanism is simple:

1. direct code individuals should recover evaluated-code count and avoid the
   thought-to-code bottleneck seen in T50;
2. the single-thought operator should keep T49/T50's best-score pressure;
3. the one-slot archive should keep at least one local front alternative near
   each champion instead of letting the champion lane monopolize the cell;
4. sparse warmup should avoid empty active archives on low-yield designs.

## Leakage Rules

The behavior descriptor remains `sr_pca_3d`, fitted from the pre-existing
non-PPA synthesis-response profile. T51 must not use final PPA, reference PPA,
fitness, hypervolume, Pareto-front labels, problem identity, corpus, model
identity, or test pass rate as a BD input.

PPA enters only after candidate evaluation for archive quality, local front
slot retention, NSGA-II parent selection, and offline reporting. The method
does not choose descriptor axes or problem subsets from T51 outcomes.

## Comparator Surface

Use the T47-T50 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `data/configs/hard_iteration_subset.yaml`;
- seed: start with `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning roots;
- QD comparators: T47 exact T26, T48 gated near-front fusion, T49 thought-k
  repair, and T50 candidate-matched thought front.

Do not change the subset after seeing T51 outcomes.

## Required Measurements

Report:

- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T50 for valid-PPA count, HV, HV-AUC, front points, and unique
  PPA points on the matched completed subset;
- generated code candidates versus classic/T47/T48/T49/T50;
- classic-covered valid-PPA design losses;
- aggregate PPA-front points and unique PPA points;
- reference-beating count;
- active archive coverage and final elite count;
- direct raw area-power PPA-front figures and candidate-level data;
- Phase 03.1 `qd_ppa_viewer/` if archive artifacts support honest export.

## Acceptance Signals

T51 can advance only if it:

- preserves every classic-covered valid-PPA design on the compared surface;
- improves T50 on at least two of mean HV, HV-AUC, valid-PPA count, aggregate
  front points, unique PPA points, or generated code-candidate count;
- avoids a new 50 percent valid-PPA yield warning where classic has at least
  10 passing samples;
- keeps mean best-score delta non-negative versus T50 or within `0.03`;
- includes direct raw area-power PPA-front figures and candidate-level data.

If T51 improves only generated candidate count but not HV/front/yield metrics,
mark it `T0` and retire direct single-thought operator escalation on this
surface. If it improves T50 and reaches near-classic primary metrics, run the
small ablation matrix before seed `1002` or held-out spend:

- code-individual plus `eoh_strategies` on the same front-slot archive;
- code-individual plus `single_thought_operator` on `pareto_front`;
- T51 with warmup `8` instead of `4`.
