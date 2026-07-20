# H2 Hypothesis Card: Preference-Decomposed REvolution

## Falsifiable hypothesis

At equal total budget, maintaining a small number of objective-preference
success lanes preserves classic hill-climbing while increasing reference-
complete PPA hypervolume compared with one scalar success population.

## Motivation

Behavior-descriptor diversity was weakly aligned with PPA. PPA preference
vectors are directly aligned with the evaluated objective and do not require a
learned embedding or archive geometry.

## Proposed mechanism

- Keep one shared fail population unchanged.
- Split the success population into a dominant balanced lane and a small number
  of area/timing/power preference lanes.
- Each lane uses classic parent selection and a fixed achievement scalarization.
- Maintain a global nondominated reporting front, but do not use behavior cells.
- Share only nondominated elites; no crossover in the first implementation.

Use symmetric, preregistered preference vectors and at most one allocation knob.

## Smallest decisive screen

Frozen eight-design `8x5` screen:

1. classic single-score REvolution;
2. global Pareto-parent control;
3. preference-decomposed REvolution.

## Promotion gate

- mean reference-complete HV improves by at least 5%, or by at least 3% with
  positive HV-AUC and front-breadth gains;
- no classic-covered design is lost;
- valid-PPA yield remains within 10% relative of classic;
- at least three of eight problems improve and no single problem explains over
  half of the aggregate gain.

## Retirement gate

Retire if the balanced lane is starved, HV is below classic by more than 3%, or
front breadth increases without HV/HV-AUC value.

## Existing code path

Start from classic success-population selection and current PPA metric helpers.
Reuse Pareto reporting, not QD archive parent selection.
