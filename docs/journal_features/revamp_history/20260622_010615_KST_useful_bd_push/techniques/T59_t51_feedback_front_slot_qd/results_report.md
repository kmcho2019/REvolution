# T59 Results Report

Status: completed seed `1001` hard/tuning result; `T0 diagnostic_no_promotion`.

T59 tested whether the T51/T54 direct-code front-slot lineage can create more
raw PPA-front material when fail-pool parents carry short, same-budget evaluator
feedback.

The answer is no on this seed. T59 improves mean best score versus classic, but
loses the QD-relevant aggregate evidence: HV, HV-AUC, front points, unique PPA
points, and reference-beating count. It also triggers a `Prob153_gshare` yield
warning.

## Run And Validation

- Raw run:
  `exp/useful_bd_push/t59_t51_feedback_front_slot_20260623_110249_UTC/hard_tuning/t51_feedback_front_slot_qd/seed_1001`.
- Runtime: `1624.69` seconds for all 13 hard/tuning problems.
- `scripts/validate_single_thought_operator_run.py --require-full-subset`:
  passed.
- `scripts/validate_pareto_front_run.py --require-full-subset`: passed.
- Non-strict Phase 03.1 viewer validation: passed.
- Strict Phase 03.1 viewer validation: failed only because classic candidates
  cannot be honestly projected into T59's SR-PCA archive coordinates from the
  available artifacts.
- Playwright generated a screenshot matrix but reported one archive-hover clear
  caveat; manual screenshot inspection found the direct supplement and full
  viewer readable and nonblank.

## Aggregate Result

| Metric | T59 | Classic | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.086719 | 0.092601 | -0.005882 |
| Mean HV-AUC | 0.079060 | 0.082020 | -0.002960 |
| Mean best score | 0.287754 | 0.227928 | +0.059826 |
| Valid PPA | 241 | 257 | -16 |
| PPA-front points | 20 | 30 | -10 |
| Unique PPA points | 60 | 87 | -27 |
| Reference-beating candidates | 33 | 46 | -13 |

The RTLLM-only slice is also negative on HV (`-0.011178`), HV-AUC
(`-0.005697`), best score (`-0.007588`), front points (`-5`), and unique PPA
points (`-18`), even though it improves valid PPA count by `+30`.

The VerilogEval slice has tiny positive HV/HV-AUC deltas and a large best-score
gain, but loses valid PPA (`-46`), front points (`-5`), unique PPA points
(`-9`), and has the `Prob153_gshare` yield warning.

## Lineage Comparison

T59 also loses to T51, the immediate yield-recovery base, on every primary
metric in `t59_lineage_comparison.csv`: HV (`-0.002533`), HV-AUC (`-0.006394`),
best score (`-0.005726`), valid PPA (`-25`), front points (`-1`), unique PPA
points (`-15`), and reference-beating count (`-10`).

T59 improves over T54 and T58 on HV, HV-AUC, and best score, but still loses
front breadth versus both and loses valid-PPA yield versus both. That makes T59
a partial recovery from weaker variants, not a new lead.

## Interpretation

The short fail-pool feedback did not fix the T51/T54 front-breadth blocker. It
also did not preserve T51's balance well enough: T59 increases scalar
best-score pressure but gives up the broader front evidence needed for a QD
claim.

This is useful negative evidence because it narrows the emitter space. More
same-budget fail-pool text is unlikely to solve the problem by itself. The next
candidate should either change front-slot creation directly, add a separate
source-level repair lane with measured yield/front accounting, or move graph/SR
features into a secondary archive instead of replacing the primary pressure
again.

## Artifacts

- Package: `hard_tuning_package/`.
- Lineage comparison: `hard_tuning_package/tables/t59_lineage_comparison.csv`.
- Direct PPA supplement: `visualizations/direct_ppa_pareto/index.html`.
- Full Phase 03.1 viewer: `visualizations/qd_ppa_viewer/index.html`.
- Projection caveat: `visualizations/qd_ppa_viewer/projection_caveat.md`.
- Playwright caveat: `visualizations/qd_ppa_viewer/playwright_caveat.md`.
