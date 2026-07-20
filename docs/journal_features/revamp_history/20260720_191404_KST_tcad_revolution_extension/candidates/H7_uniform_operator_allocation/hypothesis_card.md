# H7: Uniform Operator Allocation

Status: `DEFERRED_DIAGNOSTIC`; outside the candidate wave.

## Identity

- Candidate ID: H7
- Class: `CORE_CORRECTION`
- Intended role: `RELIABILITY`

## Conference Weakness And Hypothesis

The conference claims that UCB improves search efficiency but provides no
fixed-policy or random-policy ablation. Aggregate classic pulls are already
near uniform: failed-parent counts span 771-805 and successful-parent counts
span 1,155-1,256 over five full-suite seeds. A live control is justified only
if per-problem and per-generation analysis shows that UCB materially changes
allocation.

## Mechanism

Set the existing `strategy_selection_method` to `random`. Keep both classic
operator sets, prompts, dual pools, parent/survivor selection, reward logging,
model, evaluator, and budget unchanged. Selection entropy, operator counts,
useful-child rates, final HV, AUC, and coverage are the registered telemetry.

## Naturalness And Ceiling

- Provisional score: 11/14: continuity 2, need 2, hardware grounding 0,
  generality 2, clarity 2, simplicity 2, novelty/paper value 1.
- No hard rejection applies, but the lack of hardware grounding caps this at a
  component-validation or simplification result.
- It cannot become the primary TCAD contribution even if it wins, so it is a
  diagnostic rather than an extension candidate.

## Implementation And Validation

- First report per-problem/generation pull counts, normalized entropy, and total
  variation distance from the eligible uniform policy.
- No source implementation is allowed; any later control uses the existing
  typed configuration and keeps classic code, prompts, and defaults unchanged.
- A live run requires a separately frozen noninferiority question; it may not
  use an outcome-disjunctive HV-or-coverage benefit gate.
- No confirmation or holdout is allocated to this diagnostic.
