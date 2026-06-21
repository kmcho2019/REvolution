# SR Pareto Validation Matrix Results Report

Status: passive validation package.

Tier decision: `T0 diagnostic`, validation support for T04/T19.

## Setup

T23 joins the central seed-1001 replay with the T17 passive local-Pareto audit
for five methods: classic, manual BD, T22 random descriptor, T19 SR ReLU PCA,
and T04 SR-RFF PCA.

The package does not fit a descriptor, change a budget, or run new vLLM
sampling. It asks whether the current synthesis-response leads remain
interesting when compared against both classic and the random descriptor
control.

## Tables

- `tables/validation_matrix.csv`
- `tables/local_pareto_retention.csv`
- `tables/comparison_deltas.csv`

## Figures

- `figures/validation_hv_summary.png`
- `figures/local_pareto_front_material.png`
- `figures/deltas_vs_classic_random.png`

Visual inspection notes are in `figures/visual_inspection_notes.md`.

## Key Results

| Method | Tier read | Final HV | HV AUC | Audit QD | Local Pareto points | Local front nets |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Classic | reference | 0.1245 | 0.0728 | 2.3163 | 17 | 10 |
| Manual BD | reference | 0.1059 | 0.0643 | 1.8526 | 18 | 11 |
| Random BD | `T0 control` | 0.1175 | 0.0987 | 1.7008 | 18 | 13 |
| SR ReLU PCA | `T0 HV lead` | 0.1454 | 0.1202 | 2.3765 | 17 | 11 |
| SR-RFF PCA | `T1 candidate` | 0.1229 | 0.0801 | 2.8111 | 19 | 14 |

`T19` SR ReLU PCA remains the clearest HV source:

- final HV is +16.82% versus classic and +23.77% versus random BD;
- HV AUC is +65.24% versus classic and +21.78% versus random BD;
- common-audit QD score is +2.60% versus classic and +39.73% versus random BD.

Its blocking issue remains front material:

- local PPA-front unique netlists are 11 versus random BD's 13;
- local global Pareto points are 17 versus random BD's 18;
- final best fitness remains below classic and random.

`T04` SR-RFF PCA remains the cleanest near-classic candidate:

- final HV is only -1.24% versus classic and +4.63% versus random BD;
- final best fitness is only -1.53% versus classic and -0.58% versus random BD;
- common-audit QD score is +21.36% versus classic and +65.28% versus random BD;
- local PPA-front unique netlists are 14 versus classic's 10 and random BD's 13;
- local global Pareto points are 19 versus classic's 17 and random BD's 18.

Its blocking issue is anytime HV:

- HV AUC is +10.06% versus classic but -18.89% versus random BD.

## Interpretation

T23 strengthens the case that `T04` and `T19` should be validated rather than
retired. The two leads have different failure modes:

- SR ReLU PCA finds better HV regions but needs quality/front retention;
- SR-RFF PCA keeps near-classic quality and stronger front/QD evidence, but
  needs better anytime behavior.

The random descriptor control matters. A method that only beats manual BD is
not persuasive. In this matrix, both SR methods beat random BD on at least one
important claimed metric, but neither dominates it across the full surface.

## Conclusion

T23 is not a final positive result. It is a focused validation matrix that
justifies the next live experiment: bounded local-Pareto archive coupling for
SR-RFF and/or SR ReLU.

The next live method should preserve the non-PPA descriptor rule and test a
fixed parent schedule such as:

- 50% local-Pareto crowded tournament within descriptor cells;
- 30% underfilled-cell exploration;
- 20% global nondominated-front sampling.

The comparison must include classic, manual BD, and T22 random descriptor under
the same subset, model, prompts, budget, and validity gates.
