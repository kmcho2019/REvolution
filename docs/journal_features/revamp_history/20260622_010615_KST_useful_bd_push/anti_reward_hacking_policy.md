# Anti-Reward-Hacking And Persistence Policy

This push should lower the premature 10 percent bar without opening loopholes.
Near-classic and small positive signals are worth pursuing, but only under
fixed metrics, fixed subsets, and visible guardrails.

## Registration Before Results

Before running a method, register:

- technique slug and methodology;
- descriptor inputs and leakage exclusions;
- archive mapping;
- baseline comparators;
- subset and holdout;
- seeds and budgets;
- primary metrics;
- expected artifact paths.

Changing any of these after seeing outcomes creates a new method version. The
old version stays in the history.

## No Premature Stop

Do not stop the whole push after one or two weak results. Stop only after one
of these conditions is met:

- a `T2` or `T3` method is found and validated on holdout;
- at least 10 real method packages across the required method classes are
  complete and all fail with a documented negative map;
- the same external blocker repeats across three concrete attempts with
  commands, logs, and next decision recorded.

Failed methods must produce the next hypothesis they imply, such as a hybrid,
ablation, dependency escalation, or subset diagnostic.

## Anti-Gaming Checks

Reject or downgrade a method when:

- descriptor fitting uses PPA, fitness, hypervolume, Pareto rank, reference
  PPA, or test pass outcomes;
- archive coverage comes mostly from invalid candidates;
- unique-cell coverage disappears after canonical netlist deduplication;
- the method improves one easy problem while losing classic-covered coverage;
- the method loses any design where classic has at least one valid functional
  PPA candidate under the same budget on the fixed compared subset;
- functionality rate or synthesis-valid rate declines by 50 percent or more
  relative to classic on a comparison unit where classic has at least 10
  passing samples for the corresponding stage;
- the result depends on changing token budgets, prompt style, or subset after
  seeing outcomes;
- only average fitness improves while hypervolume, Pareto spread, and passive
  archive coverage do not;
- a learned embedding collapses to graph size, filename, identifier style, or
  comment artifacts.

## Escalation Ladder

For each promising or ambiguous method:

1. replay diagnostic on broad ASP-DAC and prior QD data;
2. common passive-archive audit against classic and landing Smooth-QD;
3. fixed screening subset live run;
4. holdout subset live run if `T1` or `T2`;
5. multi-seed confirmation if a paper claim depends on it.

For the overall push:

1. attempt at least 10 current methods before signing off a broad negative map;
2. include deterministic descriptors, automatic-QD descriptors, learned or
   projection descriptors, and archive-coupling/Pareto variants;
3. if a small subset result is promising, expand to the frozen holdout or a
   larger pre-registered subset before claiming generality.

For each blocked method:

1. try existing environment;
2. try `uv add` when it does not create broad repo dependency churn;
3. try an isolated uv env under
   `exp/useful_bd_push/envs/<technique>/<timestamp>/`;
4. try source checkout under `exp/useful_bd_push/sources/<technique>/`;
5. decide whether the external repo should be pinned as a submodule;
6. implement faithful surrogate and record differences.

The current repo uv environment is not a valid reason to abandon a method. A
blocked report must include the isolated-env or source-checkout command that
was attempted, or explain why the method is impossible without unavailable
external artifacts such as missing checkpoints.

## Idea Generation Rule

After every `T0` result, add at least one follow-up idea to the history before
moving on. Examples:

- combine the failed descriptor with a stronger archive mechanism;
- use it as a passive-audit metric rather than an active BD;
- split the descriptor by benchmark stratum;
- add a non-PPA projection head or contrastive control;
- test whether failure is caused by invalid-yield collapse, duplicate collapse,
  or poor descriptor/PPA alignment.

## Reviewer-Ready Claim Discipline

Use the weakest claim supported by evidence:

- `diagnostic`: descriptor illuminates structure but does not improve search;
- `near-classic`: descriptor preserves classic quality and adds coverage;
- `useful`: descriptor improves at least one primary QD/PPA metric with
  guardrails intact;
- `strong`: descriptor wins substantially or across multiple seeds/problems.

Never phrase diagnostic-only evidence as optimization improvement.

## Small-N Validity Caveat

Do not let a tiny classic baseline denominator create a false regression. The
50 percent relative functionality/synthesis-validity decline rule is a hard
gate only when classic has at least 10 passing samples for the corresponding
stage in the compared unit. If classic has fewer than 10 passing samples,
report the raw generated/pass counts and tag the unit `small_n_validity`;
continue judging the method with coverage retention, valid-PPA yield,
hypervolume, archive metrics, and follow-up evidence.
