# T59 T51 Feedback Front-Slot QD Methodology

Status: completed; exact T59 is `T0 diagnostic_no_promotion`.

## Question

T51 restored valid-PPA yield, HV-AUC, and best-score pressure after the
thought-only variants, but classic still owns raw PPA-front breadth. T54 showed
that a fixed non-elite front-slot parent lane is active but too weak by itself.
T58 then showed that swapping the archive coordinates to frozen T11 PCA4 graph
features preserves yield but still does not create enough front material.

T59 asks whether T51's direct-code path can create more useful front material
when the existing front-slot parent lane is paired with short, same-budget
failure feedback for fail-pool parents.

This is a front-yield protected emitter test. It is not a bounded local repair
loop and it does not add extra candidate evaluations.

Measured outcome: T59 did not satisfy the acceptance signals. It improves mean
best score versus classic, but loses classic and T51 on HV, HV-AUC, valid PPA,
front points, unique PPA points, and reference-beating count. It also triggers a
`Prob153_gshare` yield warning.

## Method Delta From T51 And T54

T59 keeps fixed:

- hard/tuning 13-problem surface;
- seed `1001`;
- local vLLM model and 128k token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- SR-PCA descriptor profile `sr_pca_3d`;
- `grid_quantile` archive with warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- no two-parent fusion;
- no bounded local repair.

T59 changes T51 in two ways:

- parent selection uses T54's `front_slot_lane_nsga2`;
- fail-pool parents include short evaluator feedback with
  `qd_operator_fail_feedback_chars=600`.

The front-slot lane spends a fixed 10 percent parent-sampling chance on the
non-elite local-front member retained in an `elite_pareto_slot` cell. The short
fail feedback applies only when the scheduler samples a fail-pool parent; it
does not expose classic results, final fronts, hypervolume, or reference PPA.

## Why This Is Not T31 Or T54

T31 used same-budget fail feedback on the older T26/T30 SR-raw holdout
substrate and disabled the T51 one-slot archive mechanics. It also used a
larger `1200` character fail-feedback budget. T59 instead tests a shorter
feedback channel on the T51 hard/tuning substrate where direct-code
single-thought generation already recovered yield.

T54 used the front-slot lane with no failure feedback. T59 keeps that lane but
adds a narrow path for invalid descendants to contribute stage-specific repair
information before the next same-budget generation. If T59 does not improve
front material over T54/T51, the next follow-up should move to source changes
or a separate role-scheduled emitter rather than keep tuning feedback length.

## Leakage Rules

The behavior descriptor remains `sr_pca_3d`, fitted from the frozen
non-PPA synthesis-response profile. T59 must not use final PPA, reference PPA,
fitness, hypervolume, Pareto-front labels, problem identity, corpus, model
identity, or test pass rate as a BD input.

PPA enters only after candidate evaluation for archive quality, local
front-slot retention, NSGA-II parent selection, and offline reporting. Failure
feedback is limited to the candidate's failed stage and evaluator feedback.

## Comparator Surface

Use the T47 through T58 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `tables/hard_tuning_subset.yaml`;
- seed: `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning root;
- primary off-mode comparator: T51 `code_thought_front_slot_qd`;
- front-lane comparator: T54 `front_slot_lane_qd`;
- latest negative learned-geometry comparator: T58
  `t51_t11_pca4_front_slot_qd`.

Do not change the subset after seeing T59 outcomes.

## Required Measurements

Report:

- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T51, T54, and T58 for valid-PPA count, HV, HV-AUC, front
  points, unique PPA points, and reference-beating candidates;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples;
- front-slot lane request and hit counts;
- fail-pool parent request count and the rate of successful fail-pool
  descendants;
- generated parent-source counts for archive, fail pool, and seed;
- direct raw area-power PPA-front panels for all 13 problems;
- full Phase 03.1 `qd_ppa_viewer/` with honest classic projection into the
  T59 archive space.

## Acceptance Signals

T59 can advance only if it:

- preserves every classic-covered valid-PPA design;
- improves T51 or T54 on aggregate front points or unique PPA points;
- keeps T51 valid-PPA count within 10 percent;
- avoids a new 50 percent valid-PPA yield warning where classic has at least
  10 passing samples;
- keeps HV-AUC non-negative versus T51 or clearly positive versus T54;
- records nonzero front-slot lane hits and nonzero fail-pool descendants, so
  both added channels were actually exercised;
- includes direct raw PPA figures and the Phase 03.1 viewer.

If T59 only improves best score or yield while losing HV/HV-AUC/front breadth,
mark it `T0` and retire short fail-feedback plus fixed front-slot sampling on
this hard/tuning surface. The follow-up should then require either a small
source change for direct-code sample-local repair, a role-scheduled emitter, or
a secondary learned/archive lane rather than another same-flag tuning pass.
