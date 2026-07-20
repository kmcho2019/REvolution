# H1 Hypothesis Card: Bottleneck-Conditioned Strategy Adaptation

## Falsifiable hypothesis

At equal LLM and synthesis budget, conditioning REvolution's existing adaptive
strategy selection on a structured synthesis bottleneck state improves
reference-complete PPA HV or HV-AUC over global strategy-success adaptation,
without reducing hardened valid-PPA coverage.

## Conference limitation addressed

The conference mechanism adapts strategy probabilities from aggregate success
rates. It does not distinguish whether a valid design is area-, timing-,
power-, or validity-limited.

## Proposed mechanism

- Extract a small typed `SynthesisContext` from existing reports.
- Keep a fixed, general operator set.
- Maintain contextual operator success estimates with shrinkage to the global
  prior.
- Select operators from context-specific evidence; fall back to classic when
  context evidence is weak.
- Log context, selected operator, validity, targeted-objective delta, and front
  contribution for mechanism analysis.

Start simple: a context/operator success table or Beta-Bernoulli posterior.
Do not begin with a neural router.

## Smallest decisive screen

Four designs spanning different dominant bottlenecks, `12x3`, two seeds:

1. classic conference adaptation;
2. bottleneck-conditioned adaptation;
3. shuffled-context control.

## Promotion gate

- final mean HV is no worse than classic by more than 1%;
- HV-AUC improves by at least 5% or final HV improves by at least 3%;
- no method-coverage loss;
- contextual routing beats shuffled context on operator useful-child rate;
- natural-extension score remains at least 8/10.

## Retirement gate

Retire after at most two revisions if shuffled context matches the method,
context does not predict operator outcomes, or HV drops by more than 3%.

## Existing code path

Start from classic REvolution's adaptive strategy-probability update and success
population. Add one typed context representation and one contextual selection
implementation. Do not route through the QD archive code.
