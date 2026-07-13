# Pareto REvolution Claims Addendum V2

Status: preregistered for independent re-review before live evidence.

This addendum supersedes V1 for execution. It does not modify the accepted
revision-3 journal narrative. V2 freezes missing-reference circuit types,
repairs the smoke surface, and requires fresh matched classic comparators.

## Question

Does descriptor-free NSGA-II population selection improve classic
REvolution's PPA search without reducing functionality coverage?

## One Treatment

The treatment is `revolution_pareto`. It preserves classic REvolution's
direct-code Thought/Code/Feedback individual, dual Fail/Success pools, EoH
operators, UCB policy, prompts, feedback, evaluator, model, and `8 x 5`
candidate budget.

Only successful-candidate population selection changes:

1. Rank the fixed current Success pool once per generation by global Pareto
   rank and NSGA-II crowding distance.
2. Choose successful parents by two-contestant binary tournaments. Draw
   contestants without replacement. Rank wins, then crowding, then a unique
   insertion index. A singleton wins directly. The second `C-F` parent
   excludes the first winner.
3. Select successful survivors from the previous Success pool plus all new
   successful offspring by NSGA-II environmental selection. Fill complete
   fronts, then crowding-truncate the boundary front by unique insertion index.
4. If fewer valid successes exist than the population cap, append failed new
   offspring using classic's seeded shuffle and descending scalar score.
   Previous Fail candidates are not retained, matching classic.

Insertion index is the candidate's unique position in the stable candidate
list being ranked. Candidate UUID is recorded but never decides selection.

Reference-complete tasks use maximize-form normalized power, area, and active
timing gains. Reference-incomplete tasks use negative raw active PPA values.
Combinational tasks use power and area; sequential tasks also use effective
clock period. The four RTLLM tasks without reference PPA are frozen as
sequential from their reference RTL: each contains clocked state. Runtime must
assert that these are the only unknown `ProblemSpec` circuit types accepted by
the mode and must resolve them from the frozen mapping, never from synthetic
reference values.

Every Success must have post-synthesis functionality and all active PPA
values. Any other unknown circuit type or invalid Success record fails the
run. The delivered global Pareto front is reconstructed post hoc and cannot
affect search.

Scalar score remains in unchanged feedback and UCB reward accounting. The
claim is "Pareto-aware successful population selection," not a fully
scalar-free control loop.

Classic and Pareto both prioritize valid successes over failures because
failed candidates have `-inf` scalar score. The treatment removes scalar
ordering and the explicit score/per-axis champion lane among successes; NSGA-II
boundary crowding preserves objective extremes instead.

## Comparators And Scope

- Small matched check: fresh classic and Pareto runs on
  `Prob003_adder_32bit` (two axes), `Prob025_sequence_detector` (three axes),
  and `Prob006_adder_pipe_64bit` (three raw axes without reference PPA), seed
  42. Runtime must assert those objective counts. This is technical and
  directional evidence only.
- Full development evidence: fresh matched classic and Pareto runs on all 50
  RTLLM tasks, seeds 1001-1005 through frozen stop rules. PPA headlines use the
  locked 46 reference-complete tasks; functional any-pass uses all 50 and is
  also reported on 46.
- Fresh matched classic REvolution is the only gate comparator. Historical
  classic and Smooth-QD V2 roots are descriptive checks only.

All 156 VerilogEval-Spec-to-RTL tasks have prior evaluated outcomes in the
archived conference run tree. A fresh prior-run-disjoint 20-task holdout is
therefore impossible under the reviewed rule. This campaign cannot produce a
paper-facing primary win by itself. Even a positive full-RTLLM result is
"positive development evidence" until a genuinely fresh benchmark is frozen.

## Metrics

Primary metrics:

- full-history final mean hypervolume on the locked 46-task denominator;
- valid-PPA coverage: a problem-seed has at least one testbench-passing,
  post-synthesis-passing candidate with every active PPA value;
- functional any-pass coverage over all 50 tasks and separately over 46.

Secondary metrics:

- HV-AUC46;
- mean and best scalar fitness, disclosed as a reporting metric only;
- per-axis PPA gains and average PPA improvement;
- Pareto cardinality, positive-HV coverage, weak reference-beating coverage,
  candidate yield, calls, tokens, and wall time.

Missing treatment where classic succeeds is a treatment loss. Infrastructure
failures are rerun without changing the method. Report paired per-seed and
per-problem deltas, cluster-bootstrap intervals, sign/Wilcoxon/t-test outputs
where assumptions and sample counts permit, and leave-one-seed-out sensitivity
after five seeds.

## Frozen Decisions

- Historical seed-1001 classic HV is `0.1114014700215706`; its 90% diagnostic
  value is `0.10026132301941354`. The live stop uses the fresh matched classic
  value and reports both values.
- Seed-1001 stop: stop if Pareto mean HV is below 90% of fresh matched classic,
  valid-PPA coverage is at least four tasks lower, or correctness/budget fails.
- Two-seed promotion: mean final HV, aggregate valid-PPA coverage, and
  functional any-pass must each be at least fresh classic.
- Five-seed confirmation: the same three conditions must remain at least
  fresh classic. HV-AUC cannot rescue final HV.
- Candidate evaluator invocations match exactly. Calls and tokens beyond
  +/-10% mark the comparison budget-asymmetric. Persistent method-inherent
  skew closes as supporting or negative evidence.
- No parent-only/survivor-only split, tournament scan, descriptor, QD cell,
  capacity, warmup, emitter, trigger, prompt, operator, or metric follow-up is
  allowed after results are visible.

Possible conclusions are positive development evidence, supporting/near-miss,
or negative. A missed gate is a completed result, not permission to tune.
