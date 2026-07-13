# Pareto REvolution Claims Addendum V1

Status: preregistered for independent review before live evidence.

This addendum narrows the reviewed scaffold to the experiment requested on
2026-07-13. It does not modify the accepted revision-3 journal narrative.

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
   contestants without replacement. Rank wins, then crowding, then stable
   insertion order and candidate id. A singleton wins directly. The second
   `C-F` parent excludes the first winner.
3. Select successful survivors from the previous Success pool plus all new
   successful offspring by NSGA-II environmental selection. Fill complete
   fronts, then crowding-truncate the boundary front with the same stable tie
   rule.
4. If fewer valid successes exist than the population cap, append failed new
   offspring using classic's seeded shuffle and descending scalar score.
   Previous Fail candidates are not retained, matching classic.

Reference-complete tasks use maximize-form normalized power, area, and active
timing gains. Reference-incomplete tasks use negative raw active PPA values.
Combinational tasks use power and area; sequential tasks also use effective
clock period. Every Success must have post-synthesis functionality and all
active PPA values. Unknown circuit types and invalid Success records fail the
run. The delivered global Pareto front is reconstructed post hoc and cannot
affect search.

Scalar score remains in unchanged feedback and UCB reward accounting. The
claim is "Pareto-aware successful population selection," not a fully
scalar-free control loop.

## Comparators And Scope

- Small matched check: fresh classic and Pareto runs on
  `Prob003_adder_32bit` and `Prob024_fsm`, seed 42. This is technical and
  directional evidence only.
- Full development evidence: all 50 RTLLM tasks, seeds 1001-1005 through the
  frozen stop rules. PPA headlines use the locked 46 reference-complete tasks;
  functional any-pass uses all 50 and is also reported on 46.
- Matched classic REvolution is the only gate comparator. Existing Smooth-QD
  V2 may appear only as descriptive context.

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
where their assumptions and sample counts permit, and leave-one-seed-out
sensitivity after five seeds.

## Frozen Decisions

- Seed-1001 stop: stop if Pareto mean HV is below 90% of matched classic,
  valid-PPA coverage is at least four tasks lower, or correctness/budget fails.
- Two-seed promotion: mean final HV, aggregate valid-PPA coverage, and
  functional any-pass must each be at least classic.
- Five-seed confirmation: the same three conditions must remain at least
  classic. HV-AUC cannot rescue final HV.
- Auxiliary calls or tokens beyond +/-10% mark the comparison
  budget-asymmetric. Persistent method-inherent skew closes as supporting or
  negative evidence.
- No parent-only/survivor-only split, tournament scan, descriptor, QD cell,
  capacity, warmup, emitter, trigger, prompt, operator, or metric follow-up is
  allowed after results are visible.

Possible conclusions are positive development evidence, supporting/near-miss,
or negative. A missed gate is a completed result, not permission to tune.
