# T50 Candidate-Matched Thought Front Methodology

Status: partial seed `1001` result packaged;
`T0 diagnostic_rejected_for_promotion`.

## Question

T49 separated thought generation from code sampling but ran fewer base
candidates than classic on the hard/tuning surface. It preserved
classic-covered valid-PPA coverage and improved best score, but lost mean HV,
valid-PPA count, and front coverage.

T50 asks whether the same role-separated thought emitter still loses PPA-front
material when the evaluated code-candidate budget is restored to the
T47/T48/classic scale and the per-cell Pareto archive cap is widened.

This is candidate-evaluation matched, not LLM-call or token matched.
Thought-only generation adds a thought-spec request stage before code sampling,
so T50 must report LLM request and token accounting before any runtime or
efficiency claim.

## Method Delta From T49

T50 keeps the T49 descriptor, model, subset, parent selection, champion lane,
and PPA-free BD contract. It changes three visible controls:

- representation: `thought_only`;
- operator: `single_thought_operator`;
- population size: `12`, matching the classic/T47/T48 evaluated-code
  candidate scale of `48` base candidates per problem across initial plus
  three generations;
- code samples per thought: `3`, giving four thoughts per generation;
- repair: disabled with `repair_kind=none` so candidate budget is not hidden in
  extra repair attempts;
- per-cell Pareto cap: `qd_max_elites_per_cell=8`, up from T49's `5`;
- champion lane: `qd_champion_lane_fraction=0.80`;
- parent selection: `nsga2_global_rank`;
- two-parent fusion: disabled with `qd_two_parent_probability=0.0`;
- fail-parent feedback in thought prompts: disabled with
  `qd_operator_fail_feedback_chars=0`.

The test is intentionally narrow, but not single-causal. A positive T50 result
would show that the T49 failure is not stable under candidate-budget matching
and wider local Pareto retention. It would not prove which of population size,
repair removal, or local Pareto cap caused the improvement. If T50 still loses
front coverage, retire this direct thought-only emitter line until a stronger
front-specific mechanism is specified.

## Leakage Rules

The behavior descriptor remains `sr_pca_3d`, fitted from the pre-existing
non-PPA synthesis-response profile. T50 must not use final PPA, reference PPA,
fitness, hypervolume, Pareto-front labels, problem identity, corpus, model
identity, or test pass rate as a BD input.

Archive insertion and parent selection may use evaluated PPA outcomes only
after candidate evaluation, as in the existing QD/MAP-Elites search loop.

## Comparator Surface

Use the T47/T48/T49 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `data/configs/hard_iteration_subset.yaml`;
- seed: start with `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning roots;
- QD comparators: T47 exact T26, T48 gated near-front fusion, and T49
  thought-k repair.

Do not change the subset after seeing T50 outcomes.

## Required Measurements

Report:

- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T49 for mean HV, HV-AUC, valid-PPA count, and front points;
- valid-PPA count and classic-covered design losses;
- aggregate PPA-front points and unique PPA points;
- reference-beating count;
- generated thought/code-sample counts, parent-source counts, LLM request
  counts, and token accounting where logs expose it;
- direct T50-versus-T47/T48/T49 aggregate comparison tables;
- direct raw area-power PPA-front figures and candidate-level data;
- Phase 03.1 `qd_ppa_viewer/` if archive artifacts support honest export.

## Acceptance Signals

T50 can advance only if it:

- preserves every classic-covered valid-PPA design on the hard/tuning surface;
- improves T49 on at least two of mean HV, HV-AUC, valid-PPA count, aggregate
  front points, or unique PPA points;
- avoids a new 50 percent valid-PPA yield warning where classic has at least
  10 passing samples;
- keeps evaluated code-candidate counts comparable to classic and T47/T48;
- includes direct raw area-power PPA-front figures and candidate-level data.

If T50 improves only best score while losing front/yield evidence, mark it
`T0` and retire the direct thought-only candidate-matching line.
