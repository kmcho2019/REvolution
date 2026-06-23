# T66 Results Report

Status: completed seed `1001`; `T0 diagnostic_yield_positive_front_negative_not_promoted`.

T66 ran the 13-problem hard/tuning screen with the T63
`fused_rtl_state_pipeline_2d` descriptor coupled to
`front_slot_lane_nsga2` parent pressure plus low-rate near-front descriptor
fusion.

## Run

- Run root:
  `exp/useful_bd_push/t66_rtl_native_front_guarded_parent_20260623_160756_UTC/hard_tuning`
- QD arm:
  `rtl_native_front_guarded_parent_qd/seed_1001`
- Classic comparator:
  `exp/useful_bd_push/t47_t26_contract_probe_20260622_203146_UTC/hard_tuning/classic_revolution/seed_1001`
- Model preflight:
  `openai/gpt-oss-120b max_model_len=131072`
- Budget:
  population `12`, generations `3`, seed `1001`
- Subset:
  13 hard/tuning problems in `tables/hard_tuning_subset.yaml`

The run completed all 13 problems in `1688.07` seconds. The single-thought
operator validator, Pareto/front validator, and strict Phase 03.1 viewer
validator passed.

## Headline Comparison

All 13 rows are reference-complete headline rows in
`hard_tuning_package/tables/t66_ppa_completeness.csv`. There are no
missing-reference rows in this screen.

| Metric | Classic | T66 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | `0.092601` | `0.081293` | `-0.011308` |
| Mean HV-AUC | `0.082020` | `0.071443` | `-0.010577` |
| Mean best score | `0.227928` | `0.278020` | `+0.050092` |
| Valid PPA count | `257` | `260` | `+3` |
| PPA front points | `30` | `20` | `-10` |
| Unique PPA points | `87` | `90` | `+3` |
| Reference-beating candidates | `46` | `48` | `+2` |

T66 preserves every classic-covered design and improves yield/best-score
diagnostics, but it loses the primary front metrics needed for a useful-QD
promotion. The RTLLM slice drives the front-negative result: RTLLM mean HV is
`0.093810` versus classic `0.115168`, and RTLLM HV-AUC is `0.075600` versus
classic `0.095533`.

## Parent-Gate Read

The front-slot lane was only lightly exercised: `15` parent requests and `12`
hits across the full screen. Two-parent fusion did not trigger at all:
two-parent attempts, gate attempts, accepts, rejects, and fallbacks are all
`0`.

Do not cite this run as evidence that gated descriptor-compatible two-parent
fusion works or fails. It is mainly evidence about RTL-native cells coupled to
parent pressure under the T63/T51-style archive machinery.

## Validity And Completeness

No classic-covered valid-PPA design is lost. The hard/tuning subset is
reference-complete, so missing/defaulted `ppa.txt` cannot skew the headline
comparison here.

Two VerilogEval designs trigger large yield warnings with classic denominators
above the small-n threshold:

- `Prob098_circuit7`
- `Prob116_m2014_q3`

`Prob151_review2015_fsm` is labeled `small_n` because the classic valid-PPA
denominator is `2`.

## Visualizations

- Direct reader-facing raw PPA supplement:
  `visualizations/direct_ppa_pareto/index.html`
- Direct supplement screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`
- Full Phase 03.1 linked archive/PPA viewer:
  `visualizations/qd_ppa_viewer/index.html`
- Full viewer screenshot:
  `visualizations/qd_ppa_viewer/screenshot.png`
- Final-analysis source bundle:
  `visualizations/qd_ppa_viewer_source/final_analysis/`

The direct supplement and full viewer screenshots were manually inspected.
Both render nonblank, readable artifacts. The full viewer shows compare mode,
timeline controls, archive projection panes, raw/improvement/normalized PPA
controls, and raw A-P front mode.

## Decision

T66 is not promoted. It is a useful diagnostic showing that RTL-native
state/pipeline archive cells can improve yield and best-score diagnostics
without missing-reference artifacts, but the method still loses classic on HV,
HV-AUC, and front points.

Do not spend seed `1002` on exact T66. The next RTL-native attempt should
change the coupling mechanism: either make front-slot creation stronger,
connect MasterRTL/RTLTimer-style descriptors to a measured repair/source
selection lane, or use RTL-native cells as secondary archive evidence while
the primary live archive stays closer to the stronger T51/T26 family.
