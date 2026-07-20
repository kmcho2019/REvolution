# H2: Preference-Decomposed REvolution

Status: `RETIRED` at proposal review; no implementation or live spend.

## Conference Weakness

Classic REvolution ranks successful candidates through one weighted PPA score.
The completed global NSGA-II ablation shows that removing the scalar bias alone
broadens front material but does not improve final suite-scale PPA. Any new
multiobjective mechanism must preserve classic exploitation rather than repeat
that treatment.

## Falsifiable Hypothesis

At equal total budget, a dominant balanced success lane plus a small fixed set
of PPA preference lanes preserves classic hill climbing while improving final
reference-complete hypervolume without reducing RTL-simulation functionality or
valid-PPA coverage.

## Proposed Mechanism

- Keep one shared fail population unchanged.
- Retain a dominant classic balanced success lane.
- Add a small symmetric set of area, timing, and power preference lanes using
  one fixed achievement scalarization.
- Share only nondominated successful elites through one explicit rule.
- Use EoH operators and no behavior descriptors, QD cells, crossover, adaptive
  lane count, or problem-specific preferences.

The lane allocation is the only allowed public knob and is frozen before runs.

## Required Controls And Telemetry

1. byte-identical classic scalar success population;
2. completed/global Pareto selection control where artifact reuse is valid;
3. preference-decomposed treatment.

Report per-lane evaluations, useful children, valid-PPA yield, contribution to
the final global front, lane starvation, and balanced-lane parent ancestry.

## Validation Posture

- Small sets check lane execution and starvation only.
- Use the baseline-only representative set, then the two-seed full suite for a
  sound non-catastrophic mechanism.
- Final-HV improvement and no functionality/valid-PPA regression are required
  for a primary paper nomination; HV-AUC cannot rescue a final-HV loss.
- A reproducible role-specific gain within practical margins may remain
  `VIABLE` under the shared contract.

## Retirement Conditions

Retire when lane budget dilution starves classic exploitation, extra front
material has no PPA value, gains concentrate in one design, the mechanism is not
novel beyond current preference/Pareto RTL work, or allowed revisions fail.

## Main Reviewer Risk

Preference decomposition is standard multiobjective machinery. The card needs a
clear REvolution-specific delta and evidence that preserving the balanced lane
solves the measured global-Pareto failure rather than dressing an archive in new
terminology.
