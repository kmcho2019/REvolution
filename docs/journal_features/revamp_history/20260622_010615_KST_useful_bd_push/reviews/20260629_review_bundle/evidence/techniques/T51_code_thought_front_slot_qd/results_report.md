# T51 Results Report

Status: completed seed `1001` hard/tuning screen.

Tier: `T0 positive_ablation_not_promoted`.

T51 is a useful recovery from T50, but not a promoted QD/MAP-Elites headline
method. Returning to direct code individuals restored the evaluated-candidate
budget and valid-PPA yield, and the method beats classic on mean HV-AUC and
mean best score. The blocker is still front breadth: classic has more raw PPA
front points and more unique PPA points.

## Run

- Raw root:
  `exp/useful_bd_push/t51_code_thought_front_slot_20260623_030540_UTC/hard_tuning/code_thought_front_slot_qd/seed_1001`.
- Classic comparator:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`.
- Budget: `population_size=12`, `num_generations=3`, seed `1001`.
- Scope: 13 hard/tuning problems, including `Prob153_gshare`.
- Runtime: `1664.77` seconds.

## All 13 Problems Versus Classic

| Metric | Classic | T51 | Delta |
| --- | ---: | ---: | ---: |
| Generated candidates | 624 | 624 | 0 |
| Syntax-valid candidates | 572 | 598 | +26 |
| Functional candidates | 266 | 272 | +6 |
| Valid-PPA candidates | 257 | 266 | +9 |
| Mean best score | 0.227928 | 0.293480 | +0.065552 |
| Mean HV | 0.092601 | 0.089252 | -0.003349 |
| Mean HV-AUC | 0.082020 | 0.085454 | +0.003434 |
| PPA-front points | 30 | 21 | -9 |
| Unique PPA points | 87 | 75 | -12 |
| Reference-beating candidates | 46 | 43 | -3 |

Validity gates pass: no classic-covered valid-PPA design is lost and no yield
warning is triggered where the classic denominator is at least 10. The only
small-n row is `Prob151_review2015_fsm`, where T51 has 3 valid-PPA candidates
versus classic's 2.

## Matched 12-Problem Family Comparison

The T50 package was partial because `Prob153_gshare` did not finish. On the
same 12-problem subset, T51 improves T50 on every pre-registered rescue metric
except raw PPA-front points:

| Metric | T50 | T51 | Delta |
| --- | ---: | ---: | ---: |
| Generated candidates | 336 | 576 | +240 |
| Valid-PPA candidates | 156 | 245 | +89 |
| Mean HV | 0.073617 | 0.096588 | +0.022971 |
| Mean HV-AUC | 0.059753 | 0.092549 | +0.032796 |
| Mean best score | 0.301301 | 0.281321 | -0.019980 |
| PPA-front points | 18 | 16 | -2 |
| Unique PPA points | 47 | 60 | +13 |
| Reference-beating candidates | 26 | 39 | +13 |

The best-score decline versus T50 is within the pre-registered `0.03`
tolerance. T51 therefore succeeds as a T50 rescue ablation. It does not
succeed as a final useful-BD claim because front points remain below classic.

## Validation And Visuals

- `hard_tuning_package/validation/pareto_front_validation.md`: pass.
- `hard_tuning_package/validation/single_thought_operator_validation.md`: pass.
- `visualizations/direct_ppa_pareto/index.html`: reader-facing raw PPA
  supplement; Playwright screenshot captured.
- `visualizations/qd_ppa_viewer/index.html`: full Phase 03.1 viewer with 13
  datasets; non-strict validator passes.
- Strict Phase 03.1 validation fails only because classic candidates do not
  have honest `sr_pca_0/1/2` archive coordinates. Use the viewer for T51 archive
  inspection and paired PPA/front browsing, not for classic archive occupancy.

## Decision

Do not launch T51 seed `1002` as a promotion run. The next method should keep
T51's code-individual yield recovery and HV-AUC signal, but add a stronger
front-preserving mechanism. A narrow follow-up should target the
`Prob015_multi_pipe_8bit` front collapse and preserve T51's full 13-problem
coverage.
