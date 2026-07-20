# REvolution TCAD Extension Program Plan

Feature slug: `tcad_revolution_extension`

Status: `PROPOSED`. This draft is subordinate to the accepted
`docs/journal_features/journal_narrative.md` contract and must not be activated
until every blocker in `intake_review.md` is resolved through a versioned
addendum or replacement contract.

## Outcome

Produce a defensible TCAD journal extension of the ASP-DAC 2026 REvolution
framework. The final system must contain at least one independently validated
algorithmic extension that improves or robustly preserves reference-complete
PPA performance under equal budget, plus a reliability or task-generalization
contribution and a reproducible updated evaluation suite.

The program must not manufacture a positive result. Each candidate ends in a
reproducible `PROMOTED`, `RETIRED`, or `BLOCKED` decision. The paper-integration
goal may start only after at least one algorithmic candidate is promoted.

## Proposed narrative

The conference version established population-based LLM RTL generation with
separate functional-repair and PPA-optimization populations plus adaptive
strategy selection. Follow-up QD/MAP-Elites experiments show that generic
behavioral diversity does not reliably improve reference-complete PPA HV.
The journal extension therefore investigates whether REvolution becomes a
stronger CAD optimizer through synthesis-context-aware adaptation,
objective-aligned multiobjective search, and functionality-preserving edits.

## Core research questions

1. Can synthesis context make REvolution's strategy adaptation more effective
   than global success-rate adaptation?
2. Can direct PPA preference decomposition improve HV while preserving the
   conference method's hill-climbing strength?
3. Can local contract-preserving mutations improve valid-PPA yield without
   sacrificing final PPA quality?
4. Does the resulting method generalize from specification-to-RTL generation
   to optimization of valid but suboptimal RTL?

## Source of truth

- Living checklist: `tcad_revolution_extension_implementation_todo.md`
- Program history: `tcad_revolution_extension_implementation_history.md`
- Intake decision: `intake_review.md`
- Hypotheses: `shared/hypothesis_registry.md`
- Claims: `shared/claim_evidence_ledger.md`
- Natural-extension rubric: `shared/natural_extension_rubric.md`
- Experiment schema: `shared/experiment_manifest.template.yaml`
- Adversarial rubric: `tcad_revolution_extension_adversarial_prompt.md`

The current empirical grounding is
`docs/journal_features/13_findings_dashboard.md`,
`docs/journal_features/14_narrative_posture_assessment.md`, and the completed
descriptor-free Pareto package at
`docs/journal_features/revamp_history/20260710_222442_KST_pareto_revolution_validation/`.

## Program boundaries

- Equal model, prompt budget, LLM-call budget, and synthesis budget for primary
  method comparisons unless an explicitly separate efficiency experiment is
  preregistered.
- Keep classic REvolution's core engine byte-identical. Implement experimental
  behavior in an isolated backend with a narrow dispatch boundary.
- Use the established EoH operator family in primary comparisons. The failed
  single-thought operator is not an eligible substitute.
- No problem-ID branches, benchmark-specific prompt clauses, hidden-test use in
  search, reference-PPA use as a behavior feature, or silent missing-data
  defaults.
- Development problems may be used for debugging and parameter selection.
  Holdout problems may be used once per frozen candidate. The final suite may
  be used only by promoted candidates with frozen code and configuration.
- A method may expose at most three new user-facing tuning parameters before
  the first holdout run. More requires a written simplicity justification.
- Do not include a component in the integrated system solely because it makes
  the paper story longer. Every included component needs isolated evidence.

## Required workstreams

1. **Baseline contract**
   - Reproduce classic REvolution.
   - Freeze problem manifests, references, tool versions, model settings,
     prompts, seeds, missing-data policy, and report scripts.
2. **H1: Bottleneck-conditioned strategy adaptation**
3. **H2: Preference-decomposed multiobjective REvolution**
4. **H3: Contract-preserving patch evolution**
5. **H4: Seeded RTL optimization and updated benchmark suite**
6. **Integration and interaction ablation**
7. **Paper claim/evidence package**

## Global primary metrics

- Reference-complete PPA hypervolume.
- Hypervolume AUC under equal candidate budget.
- Hardened valid-PPA count and method coverage.
- Paired per-problem HV delta with bootstrap confidence interval and W/L/T.

## Secondary metrics

- Best normalized PPA score.
- Reference-beating candidates and problems.
- Pareto-front points and canonical implementation families.
- Functional pass rate, public-pass/hidden-fail rate, and first-valid cost.
- LLM calls and synthesis calls to first PPA improvement.

## Candidate progression

### Stage A: design and novelty gate

A candidate is `READY` only when its hypothesis card identifies a conference
limitation, mechanism, related-work delta, primary metric, smallest decisive
screen, promotion gate, and retirement gate. It must pass the natural-extension
rubric with no hard rejection and score at least 8/10.

### Stage B: implementation gate

- Minimal implementation behind one explicit typed mode or enum.
- Focused unit tests and one integration smoke test.
- No unrelated refactor.
- `ruff`, `ty`, and repository tests pass through normal `uv run` commands.

### Stage C: screen

Use a small subset only for runtime and extraction checks. Because prior small
screens transferred weakly to full RTLLM, the performance promotion decision
must use a frozen full-suite probe. A candidate may tune only preregistered
knobs and may be revised at most twice after the initial implementation. All
attempts, including failures, remain in the history.

### Stage D: holdout

Freeze code, prompts, configuration, and decision rules. Run the holdout once.
No post-hoc problem removal or metric substitution.

### Stage E: decision

- `PROMOTED`: meets quantitative, mechanism, naturalness, code, and docs gates.
- `RETIRED`: fails a primary or mechanism gate after allowed revisions.
- `BLOCKED`: evidence cannot be obtained because of a named external resource.

## Paper-integration gates

- At least one algorithmic candidate is `PROMOTED` on holdout.
- The minimal integrated method outperforms each included component's isolated
  result or demonstrates complementary gains without primary-metric regression.
- Full reference-complete evaluation is run from a frozen commit.
- At least two seeds are used for the final selected method; use three where
  budget permits.
- Core paper claims have direct rows in the claim/evidence ledger.
- Methodology can be reproduced from one manifest plus documented commands.
- Independent adversarial validator returns PASS.

## Program stop conditions

- If H1 and H2 both retire and H3 provides only functionality improvement with
  no noninferior PPA result, stop the journal-integration goal as
  `PIVOT_REQUIRED`; do not assemble a nominal positive method.
- If the final suite contradicts holdout, report the contradiction and revise
  the claim downward rather than retuning on the final suite.
