# Journal Direction Shortlist

## Ranking

| Priority | Direction | Naturalness | Performance path | Role |
| ---: | --- | --- | --- | --- |
| 1 | Descriptor-free Pareto REvolution | High | Recover archive tax while retaining demonstrated NSGA-II benefit | Immediate primary experiment |
| 2 | Reference-seeded Pareto optimization | High for TCAD optimization | Remove the large-design validity ceiling and optimize real modules | Highest-upside journal track |
| 3 | C-F and bandit simplification | High | Existing AUC-positive no-C-F result; likely parity rather than win | Required supporting ablation |
| 4 | QD/MAP-Elites characterization | Already complete | No primary final-HV path under current evidence | Supporting analysis |
| Retire | Fixed two-emitter QD and more descriptor scans | Medium | Recombines exhausted negative mechanisms | Future work only |

## Candidate 1: Pareto REvolution

### Method In Two Sentences

Keep classic REvolution's direct-code Thought/Code/Feedback individuals,
dual Fail/Success populations, EoH operators, feedback, and matched budget.
Replace weighted scalar selection in the Success population with global
NSGA-II non-domination rank and crowding, and retain a separate external
Pareto archive for final delivery.

### Why It Is The Cleanest Follow-Up

- It directly answers the weighted-sum criticism.
- It subtracts MAP-Elites descriptor and cell state instead of adding knobs.
- NSGA-II is the only selection component with demonstrated positive causal
  evidence in the current program, although that isolation is on the earlier
  13-problem tuning ablation rather than full RTLLM.
- It preserves classic's exploitation and valid-yield strengths.
- It tests an unisolated mechanism: Pareto selection without descriptor
  binning.

### Important Distinction From V2

V2 globally ranks parents but stores survivors in descriptor cells with
bounded per-cell fronts. Pareto REvolution globally ranks and retains the
Success population itself. The descriptor grid no longer controls survival,
so globally nondominated candidates cannot be lost only because their local
cell is full.

### Novelty And Risk

NSGA-II is established, so the paper must not claim a new multi-objective
algorithm. The contribution is an evidence-derived reformulation of LLM RTL
evolution, with a controlled demonstration that Pareto structure is useful
while behavioral binning is not. The main performance risk is that it reaches
parity rather than a win because the remaining ceiling is model capability.

### Expected Code Shape

One small selection module or mode using existing `ranked_front` and crowding
logic; no new descriptor, scheduler, trigger, or prompt. The Fail population
and evaluation engine stay unchanged.

## Candidate 2: Reference-Seeded Pareto Optimization

### Method In Two Sentences

Initialize each lineage from a verified reference RTL implementation and ask
the existing EoH operators to produce interface-preserving whole-file or diff
edits. Keep functionality as a hard feasibility constraint, then use global
Pareto selection over synthesis-stage power, area, and timing.

### Why It Has The Highest Strategic Upside

- It matches a real TCAD use case: optimizing existing correct RTL.
- It removes the near-binary from-scratch correctness barrier observed on
  larger RealBench modules.
- It uses existing diff, synthesis, PPA, Verilator, support-file, and
  equivalence infrastructure.
- It can address benchmark scale and PPA quality in one coherent experiment.
- It gives QD a proper role as optional analysis of discovered
  implementation families rather than a mandatory search controller.

### Fairness And Anti-Gaming Requirements

The unchanged seed must not count as a functional-coverage win. Report
coverage only when a non-identical descendant passes and receives valid PPA;
report a stricter column for equivalence-proven PPA-improving descendants.
Compare seeded Pareto evolution against seeded scalar REvolution and a
budget-matched iterative feedback/refinement baseline.

Formal or stronger functional checking must be in the claim path. A
testbench-only pass can reward dead-logic removal or untested behavior, and
RealBench's 5% area sanity floor catches only synthesis stubs.

### Main Risk

A reviewer may say this is optimization rather than generation. The coherent
answer is a two-regime journal thesis: generate small blocks from a
specification; optimize verified RTL when design scale makes blank-page
generation infeasible. If the advisor rejects that scope, keep this as a
separate future paper rather than forcing it into the journal.

## Candidate 3: Operator Simplification

The five-seed classic-no-C-F control already has a promising shape:

| Arm | Mean HV | HV-AUC | Mean covered problems |
| --- | ---: | ---: | ---: |
| classic | 0.103802 | 0.086797 | 32.8 |
| classic without C-F | 0.106846 | 0.094592 | 33.2 |

The final-HV delta is small and non-significant, but the paired HV-AUC
confidence interval is positive in the existing report. Recompute this
through the canonical penalized statistics path before making any claim.
Then test classic UCB versus a fixed operator policy. These are supporting
ablations that can answer the conference operator criticisms; they are not a
standalone TCAD method.

The table reproduces the PCN package's AUC computation. Its classic AUC
(`0.086797`) differs slightly from the later canonical suite value
(`0.086982`), so it must not be mixed with the current headline table before
the registered reanalysis. The no-C-F switch removes only the success-side
C-F crossover/fusion operator; it does not remove failure feedback.

## QD's Recommended Final Role

Use the completed QD work to show why the main method is simpler:

- per-cell MOME retention improves trajectory but not final dominance;
- descriptor health is not PPA quality;
- active diversity can cost yield under shallow expensive budgets;
- QD archives still expose useful alternative deliverables and case studies.

This turns the negative map into design evidence rather than discarded work.
