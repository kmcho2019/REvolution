# REvolution TCAD Extension Discovery Plan

Feature slug: `tcad_revolution_extension`

Status: `READY_FOR_AUDIT`. `program_claims_contract.md` revision 1 is the
owner-approved contract for this post-QD discovery program. Existing empirical
findings and measurement disclosures from
`docs/journal_features/journal_narrative.md` remain authoritative where the new
contract does not replace them.

## Outcome

Find, implement, and evaluate natural extensions of the ASP-DAC 2026 REvolution
method. The program must finish with an organized, reviewer-facing portfolio
that explains:

- which conference components are strong, weak, or unproven;
- which natural corrections or augmentations were considered and why;
- which mechanisms were implemented and what their evidence shows;
- whether a minimal journal-ready extension exists;
- what negative results rule out and what remains viable.

The desired outcome is `JOURNAL_READY`: at least one independently confirmed
algorithmic extension that modestly or materially improves final PPA
hypervolume over classic REvolution without losing functionality/valid-PPA,
plus a coherent supporting reliability, generalization, or evaluation result.
The program may honestly finish `PORTFOLIO_READY` or `PIVOT_REQUIRED` when the
evidence does not support a complete journal method.

## Research Thesis

The conference method established a population-based LLM loop with separate
functional-repair and PPA-optimization populations, EoH-derived evolutionary
operators, adaptive strategy selection, and scalar PPA-biased success ranking.
The journal investigation asks which of those choices are weakly justified,
insufficiently hardware-grounded, or limiting under current benchmarks, then
tests the smallest general mechanisms that directly address the audited gaps.

Generic QD/MAP-Elites and descriptor-free Pareto selection remain relevant
negative evidence. They may motivate a new candidate only when the proposal
states a distinct failure mechanism and is not another archive-capacity,
descriptor, or selection-parameter scan.

## Source Of Truth

- Claims and outcome levels: `program_claims_contract.md`
- Conference audit: `conference_method_audit.md`
- Living checklist: `tcad_revolution_extension_implementation_todo.md`
- Program history: `tcad_revolution_extension_implementation_history.md`
- Candidate portfolio: `extension_portfolio.md`
- Candidate registry: `shared/hypothesis_registry.md`
- Candidate loop: `shared/candidate_goal_contract.md`
- Claims: `shared/claim_evidence_ledger.md`
- Naturalness review: `shared/natural_extension_rubric.md`
- Experiment schema: `shared/experiment_manifest.template.yaml`
- Final audit: `tcad_revolution_extension_adversarial_prompt.md`

Current empirical grounding comes from
`docs/journal_features/13_findings_dashboard.md`,
`docs/journal_features/14_narrative_posture_assessment.md`, the natural-QD
campaign, and the completed descriptor-free Pareto validation package.

## Non-Negotiable Boundaries

- Reproduce and hash classic REvolution before candidate implementation.
- Keep the classic core engine byte-identical. Experimental behavior lives in
  an isolated backend behind one narrow typed mode or dispatch boundary.
- Default comparisons and all non-operator candidates use `eoh_operators`. A
  preregistered hardware-operator candidate may replace only that operator
  family as its isolated treatment. The unsuccessful `single_thought_operator`
  is not an eligible substrate or control.
- Match model, prompts except the isolated mechanism, candidate-evaluation
  budget, LLM budget, synthesis budget, evaluator, and benchmark coverage.
- No problem IDs, benchmark-specific prompt clauses, hand-selected per-design
  thresholds, hidden-test feedback, reference-PPA search features, or silent
  missing-data defaults.
- No fallback ladders or broad backward-compatibility paths in experimental
  code. A candidate has one explicit behavior and fails on unknown state.
- Prefer one new mechanism and one public parameter. More than two new knobs
  requires written rejection by the simplicity review before implementation.
- Do not combine candidates until each component has an independent decision.
- Do not retain a component because it improves the narrative rather than the
  evidence.

## Phase 0: Audit Classic REvolution

Complete `conference_method_audit.md` from the paper, exact classic code,
configuration, logs, existing ablations, and current related work.

Timebox the audit to one primary pass, one independent challenge, and one
evidence-based revision. Record unresolved questions rather than extending the
audit indefinitely.

Audit at least:

1. EoH-derived operators and operator adaptation.
2. Scalar success fitness and parent/survivor selection.
3. Dual fail/success populations and information retained from failures.
4. Mutation granularity, repair, and functional verification.
5. PPA objective, evaluator noise, and missing-result handling.
6. Generation-centric task scope and benchmark generalization.

For each component, distinguish `SUPPORTED`, `UNPROVEN`, `LIMITING`, and
`OUT_OF_SCOPE`. Do not propose a replacement until the current behavior and
evidence are understood.

## Phase 1: Discover And Rank Candidates

Generate candidate cards from material audit findings. Cover three kinds of
response where justified:

- **Core correction:** simplify, replace, or better justify a weak conference
  component such as adaptation, scalar selection, or fail handling.
- **Hardware-grounded extension:** make search behavior correspond more directly
  to RTL functionality, synthesis bottlenecks, or PPA-relevant transformations.
- **Natural augmentation:** add a compatible capability such as contract-aware
  mutation, verification guidance, seeded optimization, or scale handling.

Every proposal must state:

- the exact conference weakness and supporting evidence;
- a one-sentence falsifiable hypothesis;
- hardware/CAD or evolutionary-search rationale;
- current related-work delta and strongest novelty objection;
- one mechanism change and its smallest control;
- expected effect on final HV, HV-AUC, and functionality/valid-PPA;
- mechanism telemetry that distinguishes causation from chance;
- implementation surface, state, knobs, and removal plan;
- smoke, representative, full-suite, and retirement gates.

Use the natural-extension rubric before code. Reject generic algorithm
transplants, disguised parameter sweeps, and candidates whose explanation
depends on a particular benchmark design.

The H1-H4 directories are seed ideas, not a required queue. Rank them beside
new audit-derived cards. Select a wave of at most three distinct mechanisms,
then evaluate one active candidate at a time.

## Phase 2: Candidate Loop

Each selected candidate follows `shared/candidate_goal_contract.md`.

### A. Freeze The Card

Freeze the mechanism, comparator, telemetry, budgets, benchmark roles, and
decision gates. Record independent naturalness, novelty, and methodology
reviews. Advice is evidence to assess, not an instruction to accept blindly.

### B. Implement The Smallest Mechanism

Use a typed explicit mode and isolated module. Add focused unit tests for the
mechanism, deterministic selection, required-data assertions, and one end-to-end
integration smoke. Do not refactor unrelated classic code.

### C. Audit Code Before Live Spend

Inspect the complete diff and prove:

- classic files and baseline behavior remain unchanged;
- only the frozen mechanism differs;
- no fallback, compatibility layer, hidden optional state, or benchmark branch
  was added;
- logs expose the preregistered mechanism measurements;
- `ruff`, `pyright` or recorded existing debt, `ty`, and focused tests pass.

### D. Technical Smoke

Run one debug seed on a small, design-diverse set. The smoke checks execution,
artifact extraction, budget accounting, and catastrophic functionality/PPA
failure. It is not positive performance evidence.

### E. Representative Probe

Run the frozen baseline-only-selected representative set with at least two
matched seeds. Analyze final HV, HV-AUC, functionality, valid-PPA, yield,
per-problem deltas, and mechanism telemetry.

Retire only for a preregistered catastrophic failure, unsupported mechanism, or
naturalness/novelty failure. Because prior small-set transfer was weak, a noisy
or modest representative result does not by itself retire a sound candidate.

### F. Full-Suite Probe

Candidates that execute correctly, preserve the mechanism, and avoid
catastrophic regression receive a two-seed frozen full-suite probe. RTLLM,
VerilogEval, or another suite may be used according to the frozen benchmark
role. Report every reference-complete unit and count missing treatment outputs
as failures.

Classify the candidate as `VIABLE` or `RETIRED`, or nominate it for confirmation.
Permit at most two mechanism-preserving revisions total. A revision must answer
an observed failure mechanism; adjacent parameter values are not revisions.

### G. Confirmation And Holdout

Only the strongest one or two candidates receive five matched, preregistered
confirmation seeds that are disjoint from all development seeds. Freeze code
and configuration, then run a genuinely disjoint holdout once. End with
`PAPER_CANDIDATE`, `VIABLE`, `RETIRED`, or `BLOCKED`.

### H. Learn Before The Next Candidate

Update the program history, negative map, portfolio, and related-work matrix.
The next hypothesis must address the most important unresolved conference
weakness or a measured failure mechanism. Do not relaunch a retired idea under
a nearby parameter or combined name.

## Benchmark Contract

Benchmark roles are frozen before candidate outcomes:

- **Smoke:** a few combinational, sequential/datapath, and control designs for
  runtime and extraction only.
- **Representative development:** a baseline-only-selected, design-diverse set
  with moderate classic success, measurable PPA headroom, and acceptable
  synthesis determinism. It prioritizes spend but does not license final claims.
- **Full-suite development:** all reference-complete tasks in a frozen RTLLM,
  VerilogEval, or equivalent manifest. No treatment-based filtering.
- **Confirmation:** five matched, preregistered seeds disjoint from development
  seeds on the frozen suite for finalists.
- **Holdout:** genuinely untouched designs or benchmark family, run once after
  method freeze.

Use classic-only pilots to quantify task difficulty, valid-PPA rate, reference
headroom, seed variance, and synthesis noise. Freeze the selection rule and all
excluded-task reasons before evaluating a candidate. Previously explored RTLLM
tasks are development evidence, not a fresh holdout.

Before Wave 1, produce a holdout-eligibility audit that lists every candidate
source, prior exposure, contamination risk, available references, functional
harness, and final eligible manifest. If no credible untouched source remains,
the program cannot make a holdout-backed `PAPER_CANDIDATE` claim.

## Metrics And Decision Posture

Primary algorithmic surfaces:

- reference-complete final PPA hypervolume;
- hardened functionality and valid-PPA coverage;
- paired per-problem final-HV delta, uncertainty, and W/L/T.

Secondary and mechanism surfaces:

- HV-AUC under equal candidate budget;
- best normalized PPA and reference-beating count;
- valid-PPA sample yield and first-valid/first-improvement cost;
- Pareto-front material and implementation-family breadth;
- candidate-specific useful-child, routing, edit, or failure-class telemetry;
- calls, tokens, synthesis evaluations, runtime, and failure reasons.

Use the statistical unit, clustered bootstrap, penalized missing-data analysis,
tie handling, and disjoint seed roles fixed in `program_claims_contract.md`.

Modest improvements are acceptable. Freeze practical-regression margins and
uncertainty rules from classic variability before seeing treatment results.
Use `VIABLE` for a credible role-specific gain that does not meet a headline
gate. Do not call a final-HV loser a primary PPA improvement because AUC,
coverage, or a case study improved.

## Review Cadence

Use independent read-only reviewers at four points:

1. after the conference audit and candidate ranking;
2. after a hypothesis card, before implementation;
3. after code/tests, before live experimental spend;
4. after suite evidence, before the candidate decision.

Assign distinct roles: conference-method auditor, skeptical TCAD novelty
reviewer, hardware/EDA methodology reviewer, statistics/reproducibility
reviewer, and code-simplicity reviewer. Record prompts, findings, dispositions,
and unresolved objections.

When available, run a read-only `claude -p` audit at major candidate transitions
and approximately every ten goal commits with a 5-10 minute timeout. External
feedback is non-authoritative: verify every claim against code, artifacts, and
primary literature before changing the plan.

## Program Waves And Stop Conditions

- Evaluate at most three distinct candidates per wave, sequentially.
- Freeze a program-level ceiling for LLM tokens, candidate evaluations,
  synthesis evaluations, accelerator time, and wall-clock time before Wave 1.
- Start a second wave only when the first wave's negative or viable results
  identify a concrete unresolved mechanism.
- Stop discovery as `JOURNAL_READY` when a confirmed candidate and coherent
  supporting contribution satisfy the claims contract.
- Stop as `PORTFOLIO_READY` when useful natural mechanisms exist but none
  supports a complete journal claim after two waves.
- Stop as `PIVOT_REQUIRED` when two waves yield no credible candidate, novelty
  is removed by related work, or independent reviewers find no natural next
  mechanism.
- Do not weaken thresholds, expand knobs, tune on holdout, or assemble several
  near-misses to avoid a non-journal outcome.

## Completion Criteria

- Classic baseline and benchmark contracts are frozen and reproducible.
- Program and per-wave resource ceilings are frozen and reconciled.
- The conference-method audit maps every material component to code and evidence.
- The portfolio contains every reviewed candidate and every terminal decision.
- Each implemented candidate has isolated code, focused tests, manifests, raw
  artifacts, reports, mechanism evidence, and independent review dispositions.
- Finalists have five-seed confirmation and one disjoint holdout.
- The claim/evidence ledger permits no unsupported wording.
- `extension_portfolio.md` states one program outcome and the smallest coherent
  journal package, or explains why a pivot is required.
- Independent adversarial validation returns process `PASS` and agrees that the
  stated program outcome matches the evidence.
