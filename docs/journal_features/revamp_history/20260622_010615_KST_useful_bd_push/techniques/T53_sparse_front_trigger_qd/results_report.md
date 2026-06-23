# T53 Results Report

Status: completed seed `1001` hard/tuning screen.

Tier: `T0 diagnostic_not_promoted`.

T53 is the bounded follow-up to T52. It keeps T51's direct code
representation, `single_thought_operator`, and one-slot `elite_pareto_slot`
archive, then lowers champion pressure only when archive-local front material
is thin.

The result is useful negative evidence. The sparse-front trigger fired, so the
method is not a no-op, but it did not recover classic HV, HV-AUC, or raw
PPA-front breadth.

## Run

- Raw root:
  `exp/useful_bd_push/t53_sparse_front_trigger_20260623_045328_UTC/hard_tuning/code_thought_sparse_front_trigger_qd/seed_1001`.
- Classic comparator:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`.
- Budget: `population_size=12`, `num_generations=3`, seed `1001`.
- Scope: 13 hard/tuning problems.
- Runtime: `1592.24` seconds.

## All 13 Problems Versus Classic

| Metric | Classic | T53 | Delta |
| --- | ---: | ---: | ---: |
| Generated candidates | 624 | 624 | 0 |
| Syntax-valid candidates | 572 | 595 | +23 |
| Functional candidates | 266 | 244 | -22 |
| Valid-PPA candidates | 257 | 239 | -18 |
| Mean best score | 0.227928 | 0.290435 | +0.062507 |
| Mean HV | 0.092601 | 0.085793 | -0.006808 |
| Mean HV-AUC | 0.082020 | 0.071011 | -0.011009 |
| PPA-front points | 30 | 22 | -8 |
| Unique PPA points | 87 | 71 | -16 |
| Reference-beating candidates | 46 | 38 | -8 |

T53 preserves every classic-covered valid-PPA design, but it has two yield
warnings on `Prob098_circuit7`: functional and valid-PPA count both drop from
34 to 16. `Prob151_review2015_fsm` is small-n because classic has only two
valid-PPA candidates.

## Versus T51 And T52

| Metric | T51 | T52 | T53 |
| --- | ---: | ---: | ---: |
| Valid-PPA candidates | 266 | 254 | 239 |
| Mean HV | 0.089252 | 0.083502 | 0.085793 |
| Mean HV-AUC | 0.085454 | 0.055792 | 0.071011 |
| Mean best score | 0.293480 | 0.242261 | 0.290435 |
| PPA-front points | 21 | 24 | 22 |
| Unique PPA points | 75 | 76 | 71 |
| Reference-beating candidates | 43 | 41 | 38 |

T53 improves T52 on HV, HV-AUC, and best score, but it does not preserve T51's
yield/HV-AUC recovery. It adds only one front point versus T51 while losing 27
valid-PPA candidates, 0.014443 HV-AUC, four unique PPA points, and five
reference-beating candidates.

## Trigger Behavior

The sparse-front trigger fired 25 times:

- `Prob015_multi_pipe_8bit`: 9 batches;
- `Prob041_traffic_light`: 8 batches;
- `Prob045_alu`: 3 batches;
- `Prob024_fsm`: 2 batches;
- `Prob153_gshare`: 3 batches.

The trigger therefore exercised the intended path, but the lower champion lane
did not translate into a better front. Parent-pressure tuning alone is not the
right next escalation.

## Validation And Visuals

- `hard_tuning_package/validation/pareto_front_validation.md`: pass.
- `hard_tuning_package/validation/single_thought_operator_validation.md`:
  pass.
- `visualizations/direct_ppa_pareto/index.html`: reader-facing raw PPA
  supplement; browser screenshot captured.
- `visualizations/qd_ppa_viewer/index.html`: full Phase 03.1 viewer with 13
  datasets; non-strict validator passes.
- Strict Phase 03.1 validation fails only because classic candidates do not
  have honest `sr_pca_0/1/2` archive coordinates.
- Playwright generated the viewer screenshot set but reports a hover-clear
  caveat. Manual inspection confirms the compare-mode archive/PPA view renders.

## Decision

Retire this exact sparse-front trigger. It is a clean test of the T52
follow-up idea, but it fails promotion because classic still wins mean HV,
HV-AUC, valid-PPA count, front points, unique PPA points, and
reference-beating count.

The next attempt should stop scalar champion-lane nudging and use a
role-separated emitter lane that explicitly allocates a small budget to
front-family recovery while preserving T51's direct-code yield path.
