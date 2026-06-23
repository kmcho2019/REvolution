# T52 Results Report

Status: completed seed `1001` hard/tuning screen.

Tier: `T0 diagnostic_retired_full_pareto`.

T52 is the direct T51 front-breadth ablation. It keeps T51's direct code
representation and `single_thought_operator`, then widens each archive cell
from one local front slot to a full local Pareto set.

The result is useful negative evidence. T52 adds a small amount of front
material versus T51, but it loses the yield and HV-AUC recovery that made T51
interesting. It should not advance to seed `1002` or held-out spend.

## Run

- Raw root:
  `exp/useful_bd_push/t52_code_thought_full_pareto_20260623_035857_UTC/hard_tuning/code_thought_full_pareto_qd/seed_1001`.
- Classic comparator:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`.
- Budget: `population_size=12`, `num_generations=3`, seed `1001`.
- Scope: 13 hard/tuning problems.
- Runtime: `1666.96` seconds.

## All 13 Problems Versus Classic

| Metric | Classic | T52 | Delta |
| --- | ---: | ---: | ---: |
| Generated candidates | 624 | 624 | 0 |
| Syntax-valid candidates | 572 | 593 | +21 |
| Functional candidates | 266 | 259 | -7 |
| Valid-PPA candidates | 257 | 254 | -3 |
| Mean best score | 0.227928 | 0.242261 | +0.014333 |
| Mean HV | 0.092601 | 0.083502 | -0.009099 |
| Mean HV-AUC | 0.082020 | 0.055792 | -0.026228 |
| PPA-front points | 30 | 24 | -6 |
| Unique PPA points | 87 | 76 | -11 |
| Reference-beating candidates | 46 | 41 | -5 |

T52 preserves every classic-covered valid-PPA design, but it triggers a yield
warning on `Prob098_circuit7`: 12 functional/valid-PPA candidates versus
classic's 34. `Prob151_review2015_fsm` is labeled small-n because classic has
only 2 valid-PPA candidates there.

## Versus T51

| Metric | T51 | T52 | Delta |
| --- | ---: | ---: | ---: |
| Valid-PPA candidates | 266 | 254 | -12 |
| Mean HV | 0.089252 | 0.083502 | -0.005750 |
| Mean HV-AUC | 0.085454 | 0.055792 | -0.029662 |
| Mean best score | 0.293480 | 0.242261 | -0.051219 |
| PPA-front points | 21 | 24 | +3 |
| Unique PPA points | 75 | 76 | +1 |
| Reference-beating candidates | 43 | 41 | -2 |

The full local Pareto archive does what it was meant to test: it recovers some
front material relative to T51. The cost is too high. HV-AUC falls by 34.7
percent versus T51, best score falls by 17.5 percent, and the Prob098 yield
warning returns. This argues against simply widening the local Pareto cell.

## Validation And Visuals

- `hard_tuning_package/validation/pareto_front_validation.md`: pass.
- `hard_tuning_package/validation/single_thought_operator_validation.md`: pass.
- `visualizations/direct_ppa_pareto/index.html`: reader-facing raw PPA
  supplement; Playwright screenshot captured.
- `visualizations/qd_ppa_viewer/index.html`: full Phase 03.1 viewer with 13
  datasets; non-strict validator passes.
- Strict Phase 03.1 validation fails only because classic candidates do not
  have honest `sr_pca_0/1/2` archive coordinates. Use the viewer for T52
  archive inspection and paired PPA/front browsing, not for classic archive
  occupancy.

## Decision

Retire this exact full-Pareto widening. It partially improves front breadth,
but it fails the acceptance signal because it loses T51's HV-AUC recovery and
adds a yield warning. The next idea should not be "more local Pareto capacity"
by itself. A better follow-up would keep T51's one-slot/yield behavior and add
a bounded front-pressure trigger that activates only when archive-local
front material is demonstrably thin, without using classic results or final
PPA-front labels as descriptor inputs.
