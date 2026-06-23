# T63 Fused RTL-Native Live Screen Results

Status: completed seed `1001` hard/tuning result;
`T0 positive_mechanism_ablation_not_promoted`.

T63 tested whether fused RTL-native behavior descriptors could make the T51
archive machinery more useful. The answer is not enough to beat classic on
the headline QD metrics. T63 preserves valid-PPA coverage and improves best
score, but classic still wins mean HV, mean HV-AUC, and aggregate PPA-front
points.

## Run And Validation

- Raw run:
  `exp/useful_bd_push/t63_fused_rtl_native_20260623_133903_UTC/hard_tuning/fused_rtl_state_pipeline_qd/seed_1001`.
- Runtime: `1664.03` seconds for the 13-problem hard/tuning screen.
- Preflight passed:
  `openai/gpt-oss-120b max_model_len=131072`.
- `scripts/validate_single_thought_operator_run.py --require-full-subset`:
  passed.
- `scripts/validate_pareto_front_run.py --require-full-subset`: passed.
- Strict static Phase 03.1 viewer validation: passed.
- Playwright generated the screenshot matrix but reported two compare-guide
  debug-hook failures; see `visualizations/qd_ppa_viewer/playwright_caveat.md`.

## Aggregate Result

| Metric | T63 | Classic | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | 0.089551 | 0.092601 | -0.003050 |
| Mean HV-AUC | 0.074125 | 0.082020 | -0.007895 |
| Mean best score | 0.268251 | 0.227928 | +0.040323 |
| Valid PPA | 257 | 257 | 0 |
| PPA-front points | 25 | 30 | -5 |

The comparison is reference-complete for this screen: all 13 rows in
`hard_tuning_package/tables/t63_ppa_completeness.csv` are `headline`.
Missing candidate PPA is still treated as method-invalid data; missing
reference PPA would make a row diagnostic-only, but no row in this T63 subset
has a missing reference.

## Lineage Result

T63 is more interesting against T51 than against classic. Versus T51, T63 has
a tiny mean-HV gain (`+0.000299`), adds `+4` front points, `+10` unique PPA
points, `+7` reference-beating candidates, and `+2` active archive members.
It still loses T51 on HV-AUC (`-0.011329`), best score (`-0.025229`), and
valid-PPA count (`-9`).

The RTLLM slice is the useful clue: T63 gains `+22` valid-PPA samples, `+4`
front points, `+11` unique PPA points, and `+9` reference-beating candidates
versus T51. The VerilogEval slice is weaker and carries the yield concern.

## Interpretation

T63 supports the RTL-native lane as a mechanism direction, not as a promoted
method. The fused state/pipeline descriptors can create more local front
material than T51 on RTLLM, but the same profile does not preserve HV-AUC,
best score, or VerilogEval yield well enough.

Do not spend seed `1002` on the exact `fused_rtl_state_pipeline_2d` profile.
If the lane continues, the next experiment should either try the
`fused_rtl_operator_timing_2d` ablation from T62 or use RTL-native descriptors
as a secondary/reporting archive while keeping T51/T26-family quality pressure
as the primary generator.

## Artifacts

- Package: `hard_tuning_package/`.
- Direct raw PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Viewer source:
  `visualizations/qd_ppa_viewer_source/final_analysis/`.
- Playwright caveat:
  `visualizations/qd_ppa_viewer/playwright_caveat.md`.
