# H1: Bottleneck-Conditioned Strategy Adaptation

Status: `RETIRED` at proposal review; no implementation or live spend.

## Conference Weakness

Classic REvolution adapts operator probabilities from aggregate success. It
does not distinguish validity-, area-, timing-, or power-limited search states.
Before implementation, the conference audit must establish that adaptive
operator selection itself helps enough to justify adding context.

## Falsifiable Hypothesis

At equal budget, one small synthesis-state-conditioned operator policy improves
final PPA search or useful-child efficiency over classic global adaptation
without reducing RTL-simulation functionality or valid-PPA coverage.

## Proposed Mechanism

- Derive one small typed `SynthesisContext` from evaluator data already produced
  for every valid candidate.
- Keep the fixed EoH operator family and all prompts unchanged.
- Use one contextual success table initialized from one fixed global prior.
- Use one update and selection rule for every context; do not switch to a
  separate classic fallback mode.
- Log context, operator, child validity, objective delta, and front contribution.

No neural router, problem-specific threshold, learned embedding, or hierarchy
is in scope.

## Required Controls

1. byte-identical classic global adaptation;
2. contextual adaptation;
3. shuffled-context control with identical state and budget.

The context must predict useful-child outcomes and beat the shuffled control.
A performance change without that signature does not support the mechanism.

## Validation Posture

- Small designs are execution and context-extraction checks only.
- Use the baseline-only representative manifest for a matched probe.
- Advance a non-catastrophic, mechanism-valid result to the two-seed full suite.
- Apply the shared `VIABLE` and `PAPER_CANDIDATE` gates; freeze exact practical
  margins after classic variance analysis.

## Retirement Conditions

Retire when classic adaptation lacks value, context does not predict operator
outcomes, shuffled context matches treatment, the mechanism needs hand-tuned
context thresholds or fallbacks, or allowed revisions fail the frozen gates.

## Main Reviewer Risk

This can become a technical contextual-bandit variant rather than a natural RTL
extension. It should rank below a simpler operator removal or hardware-grounded
operator hypothesis unless the audit shows a clear context-dependent failure.
