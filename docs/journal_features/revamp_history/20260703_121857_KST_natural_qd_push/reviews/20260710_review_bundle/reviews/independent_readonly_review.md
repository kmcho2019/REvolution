# Independent Read-Only Review

Review date: 2026-07-10 UTC. Tool: `claude -p`, read-only, ten-minute timeout.
No files were edited and no experiment was launched by the reviewer.

## Verdict

The reviewer agreed that the current QD evidence is strong supporting
characterization but not a main TCAD performance contribution. The only
replicated QD win is on the small screen whose transfer weakness is itself a
campaign finding. Full-suite V2 is a parity/utility result and S07 remains
below classic final HV.

## Candidate Ranking

1. Descriptor-free Pareto REvolution: the untested, evidence-derived cell in
   the design space. Keep global Pareto selection and remove descriptor-cell
   survival pressure.
2. Reference-seeded Pareto optimization: the only candidate that changes the
   large-design feasibility regime and therefore has a clear performance
   headline path.
3. C-F and bandit simplification: cheap and important supporting ablations;
   the existing no-C-F result deserves canonical reanalysis.
4. Fixed two-emitter QD: retire because its parent-source, capacity,
   exploration, and front-lane ingredients have already closed negative or
   AUC-only.

## Main Warnings

- NSGA-II is established; novelty must come from the evidence-derived system
  reformulation and measured component value, not an algorithm novelty claim.
- Seeded optimization is highly exposed to dead-logic stripping and weak
  testbench coverage. Formal equivalence must be part of the claim path.
- New positive claims should use untouched held-out or fresh evidence.
- HV-AUC must remain secondary to final HV.
- The accepted narrative's Branch-C simplification condition is vulnerable
  because the unified operator is not independent of QD. The no-C-F control
  may provide a cleaner classic-substrate simplification, but requires
  canonical gate-grade analysis.

## Suggested Thesis

> From scalar hill climbing to Pareto design-space delivery: identify what
> multi-objective structure buys LLM-driven RTL evolution, show why behavior
> archives do not improve final quality under the tested budget, and use
> verified RTL seeding to move larger designs into a feasible optimization
> regime.

The full review output was used as an adversarial drafting input. This file is
a concise record rather than a verbatim transcript.
