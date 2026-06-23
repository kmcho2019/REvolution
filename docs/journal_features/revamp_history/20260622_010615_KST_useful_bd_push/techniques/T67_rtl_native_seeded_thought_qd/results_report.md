# T67 Results Report

Status: completed seed `1001`; `T0 diagnostic_yield_positive_front_negative_blocked`.

T67 ran the 13-problem hard/tuning screen with the T63
`fused_rtl_state_pipeline_2d` descriptor and source-preserving seeded
thought-code realization.

## Run

- Run root:
  `exp/useful_bd_push/t67_rtl_native_seeded_thought_20260623_170935_UTC/hard_tuning`
- QD arm:
  `rtl_native_seeded_thought_qd/seed_1001`
- Classic comparator:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- Model preflight:
  `openai/gpt-oss-120b max_model_len=131072`
- Budget:
  population `12`, generations `3`, seed `1001`
- Subset:
  13 hard/tuning problems in `tables/hard_tuning_subset.yaml`

The run completed in about `3335` seconds. The top-level run summary reports
11 successful problems and 2 failed problems: `Prob116_m2014_q3` and
`Prob153_gshare`. Candidate-level packaging still finds valid T67 PPA rows for
`Prob116_m2014_q3`, but T67 has no valid-PPA candidate for `Prob153_gshare`.

The Pareto/front validator passed. The single-thought validator passed after
the validator was corrected to accept the separate `code_from_thought` and
`code_from_thought_seeded` prompt stages emitted by thought-only runs. The
strict Phase 03.1 viewer validator and Playwright visual smoke passed.

## Headline Comparison

All 13 rows are reference-complete in
`hard_tuning_package/tables/t67_ppa_completeness.csv`. This screen has no
missing-reference rows, so normalized HV, HV-AUC, and improvement metrics are
eligible for direct comparison.

T67 does not preserve every classic-covered valid-PPA design. `Prob153_gshare`
is `candidate_missing`: classic has 8 valid-PPA candidates, while T67 has 0.

| Metric | Classic | T67 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | `0.092601` | `0.091741` | `-0.000860` |
| Mean HV-AUC | `0.082020` | `0.082090` | `+0.000070` |
| Mean best score | `0.227928` | `0.226566` | `-0.001362` |
| Valid PPA count | `257` | `304` | `+47` |
| PPA front points | `30` | `18` | `-12` |
| Unique PPA points | `87` | `67` | `-20` |
| Reference-beating candidates | `46` | `41` | `-5` |

The aggregate valid-PPA count rises by 18 percent, so seeded thought-code
realization is a yield mechanism clue. It is not a promotion result because
front material collapses, unique PPA breadth falls, best score is slightly
negative, and one classic-covered design is lost.

## Validity And Completeness

The completeness table separates the two failure modes requested for future
run check-in:

- missing candidate PPA is counted as a method invalid/non-PPA outcome;
- missing reference PPA would make a design diagnostic-only, but no T67
  hard/tuning row is missing reference PPA.

`Prob153_gshare` is the decisive validity blocker. It is not a
missing-reference artifact. It is a T67 candidate-missing row on a
reference-valid design.

`Prob116_m2014_q3` also has a large yield warning with a classic denominator
above the small-n threshold. `Prob151_review2015_fsm` is labeled `small_n`
because the classic valid-PPA denominator is only `2`.

## Final-Analysis Read

The final-analysis source bundle is at
`visualizations/qd_ppa_viewer_source/final_analysis/`. Its recommendation JSON
selects T67 for overall/score/archive diagnostics, but selects classic for
`multi_objective` and `pareto_overall`.

Interpretation: T67 is better at producing valid candidates and archive
activity on this screen, but the PPA-front evidence still favors classic.

## Visualizations

- Direct reader-facing raw PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`
- Direct supplement screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`
- Raw area-power front PNG:
  `visualizations/direct_ppa_pareto/t67_raw_area_power_fronts_seed1001.png`
- Improvement-coordinate supplement:
  `visualizations/direct_ppa_pareto/t67_direct_ppa_fronts_seed1001.png`
- Full Phase 03.1 linked archive/PPA viewer:
  `visualizations/qd_ppa_viewer/index.html`
- Full viewer screenshot:
  `visualizations/qd_ppa_viewer/screenshot.png`
- Final-analysis source bundle:
  `visualizations/qd_ppa_viewer_source/final_analysis/`

The direct supplement and full viewer screenshots were inspected. The direct
raw PPA panel is readable and shows the expected lower-left-better raw
area-power axes. The full viewer renders compare mode, timeline controls,
archive projection panes, raw/improvement/normalized PPA controls, and raw
A-P front mode.

## Decision

T67 is not promoted. It should not receive seed `1002` unchanged.

The useful part is source-preserving realization: it improves total valid-PPA
yield. The blocker is front creation and design retention. The next
RTL-native attempt should keep MasterRTL/RTLTimer-style descriptors as the
most defensible behavior-descriptor story, but connect them to a front
preservation or repair/source-selection mechanism that cannot drop a
classic-covered design like `Prob153_gshare`.
