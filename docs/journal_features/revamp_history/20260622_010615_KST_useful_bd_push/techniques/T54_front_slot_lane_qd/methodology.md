# T54 Front-Slot Lane QD Methodology

Status: pre-registered; not launched.

## Question

T51 restored direct-code yield, HV-AUC, and best-score pressure, but still
lost raw PPA-front breadth. T52 showed that widening every cell to a full
local Pareto set recovers a few front points but hurts yield and HV-AUC. T53
showed that lowering the champion lane when local fronts are thin is not
enough.

T54 asks whether a role-separated parent lane can spend a small fixed budget
on the local front slot while preserving T51's direct-code yield path.

## Method Delta From T51

T54 keeps fixed:

- hard/tuning 13-problem surface;
- seed `1001`;
- local vLLM model and 128k token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- SR-PCA descriptor profile;
- grid-quantile warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- no repair;
- no two-parent fusion.

T54 changes only parent selection:

- T51: `qd_parent_selection=nsga2_global_rank`;
- T54: `qd_parent_selection=front_slot_lane_nsga2`.

The new mode keeps the T51 NSGA-II global-rank parent pool. For each archive
parent request, it first reserves a fixed 10 percent chance for a non-elite
member retained in an `elite_pareto_slot` cell. A non-elite slot is the local
Pareto member that is not the scalar quality elite for that descriptor cell.
If no slot exists, the request falls back to T51-style champion/global NSGA-II
sampling.

## Leakage Rules

The front-slot lane can inspect only the current QD archive after candidate
evaluation. It must not use classic results, held-out outcomes, problem
identity, final PPA-front labels, reference PPA, final hypervolume, or test
pass rate as descriptor or lane inputs.

Evaluated PPA can affect archive insertion, local Pareto retention, and
NSGA-II ranking after a candidate has been evaluated. This matches the
post-evaluation archive channel used by T47 through T53.

## Comparator Surface

Use the T47 through T53 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `tables/hard_tuning_subset.yaml`;
- seed: start with `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning root;
- QD comparators: T51 code-thought front-slot, T52 full-Pareto widening, and
  T53 sparse-front trigger.

Do not change the subset after seeing T54 outcomes.

## Required Measurements

Report:

- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T51, T52, and T53 for valid-PPA count, HV, HV-AUC, aggregate
  front points, unique PPA points, and reference-beating candidates;
- generated code candidates versus classic/T51/T52/T53;
- classic-covered valid-PPA design losses;
- per-problem front wins/losses, especially `Prob015_multi_pipe_8bit` and
  `Prob098_circuit7`;
- active archive coverage, archive members, local-front counts, front-slot
  lane request count, and front-slot lane hit count;
- direct raw area-power PPA-front figures and candidate-level data;
- Phase 03.1 `qd_ppa_viewer/` if archive artifacts support export.

## Acceptance Signals

T54 can advance only if it:

- preserves every classic-covered valid-PPA design on the compared surface;
- avoids a 50 percent valid-PPA yield warning where classic has at least
  10 passing samples;
- improves T51 on aggregate PPA-front points or unique PPA points;
- keeps T51's valid-PPA count within 10 percent;
- keeps HV-AUC non-negative versus classic or positive versus T51;
- records nonzero front-slot lane hits.

If T54 improves front breadth but loses T51's yield/HV-AUC recovery, mark it
`T0` and keep it as evidence that explicit front-slot parent pressure is still
insufficient. If it preserves T51 yield while improving front material, run
seed `1002` or a held-out screen before any useful-QD claim.
