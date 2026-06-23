# T49 Thought-K Role-Separated Repair Methodology

Status: completed; `T0 mixed_diagnostic`.

## Question

T47 and T48 show that exact T26 and gated T26.1 are not ready for held-out
spend on the hard/tuning contract surface. Both preserve useful best-score
pressure, but both lose HV, HV-AUC, valid-PPA count, and aggregate front
material versus classic.

T49 asks whether separating the roles that were previously entangled inside one
code-individual emitter can recover yield/front material without losing the T26
champion pressure.

## Method Delta From T48

T49 keeps the T48 descriptor, archive, parent selection, model, subset, and
PPA-free BD contract, but changes the representation and emitter schedule:

- representation: `thought_only`;
- operator: `single_thought_operator`;
- code samples per thought: `3`;
- base population size: `9`;
- bounded repair: at most `1` sample-local repair attempt per thought;
- maximum code evaluations per generation: `9` base samples plus at most `3`
  repairs, matching the `12` candidate scale of the T47/T48 contract;
- champion lane: `qd_champion_lane_fraction=0.80`;
- parent selection: `nsga2_global_rank`;
- two-parent fusion: disabled with `qd_two_parent_probability=0.0`;
- fail-parent feedback in thought prompts: disabled with
  `qd_operator_fail_feedback_chars=0`;
- archive context size: `4`.

This intentionally avoids another two-parent fusion tweak. The role separation
is:

- champion lane: keeps T26-style quality pressure;
- non-champion archive lane: samples from the NSGA-II rank/crowding pool for
  near-front local-rank pressure;
- bounded repair lane: repairs only failed code samples generated from the same
  thought using sample-local feedback, not broad fail-pool transcripts;
- fail-pool lane: may generate new thoughts from failed parents through the
  existing QD scheduler, but without injecting long failure feedback into the
  parent prompt.

## Leakage Rules

The behavior descriptor remains `sr_pca_3d`, fitted from the pre-existing
non-PPA synthesis-response profile. T49 must not use final PPA, reference PPA,
hypervolume, Pareto-front labels, problem identity, corpus, model identity, or
test pass rate as a BD input.

Repair prompts may use only the thought spec, the failed sample code, the
coarse failure stage, and sample-local feedback produced before the repair.
Repair attempts are logged and counted as candidate-evaluation budget.

## Comparator Surface

Use the T47/T48 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `data/configs/hard_iteration_subset.yaml`;
- seeds: start with `1001`; add `1002` only if seed `1001` is not clearly
  dominated or blocked;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning roots;
- QD comparators: T47 exact T26 and T48 gated near-front fusion.

Do not change the subset after seeing T49 outcomes.

## Required Measurements

Report the same primary metrics as T48:

- mean HV and HV-AUC deltas versus matched classic;
- valid-PPA count and classic-covered design losses;
- aggregate PPA-front points and unique PPA points;
- reference-beating count;
- repair attempts used, repair successes, and repaired-candidate front/HV
  contribution;
- generated parent-source counts for archive, fail-pool, and seed;
- Phase 03.1 `qd_ppa_viewer/` and direct raw-PPA supplement if archive
  artifacts are produced.

## Acceptance Signals

T49 can advance only if it:

- preserves every classic-covered valid-PPA design on the T47/T48 surface;
- improves T48 on mean HV, HV-AUC, valid-PPA count, or aggregate front points;
- avoids a new 50 percent valid-PPA yield warning where classic has at least
  10 passing samples;
- does not hide extra budget through unreported repair attempts;
- includes direct raw area-power PPA-front figures and candidate-level data.

If T49 improves only best score while losing HV/HV-AUC/front/yield evidence,
mark it `T0` and retire this direct thought-repair variant.

## Measured Outcome

Seed `1001` followed this method card and was packaged under
`hard_tuning_package/`. It preserved every classic-covered valid-PPA design and
improved mean best score, but lost mean HV, valid-PPA count, aggregate front
points, unique PPA points, and reference-beating candidates. That matches the
pre-registered `T0` retirement condition for this direct thought-repair
variant.
