# T64 Fused Operator/Timing Live Screen Results

Status: completed seed `1001`; `T0 diagnostic_yield_archive_ablation_not_promoted`.

T64 is the narrow T63 ablation that keeps the same generator, budget, subset,
archive mechanics, and parent policy while changing the descriptor profile from
`fused_rtl_state_pipeline_2d` to `fused_rtl_operator_timing_2d`.

## Run

- Run root:
  `exp/useful_bd_push/t64_fused_operator_timing_20260623_144117_UTC/hard_tuning`
- QD arm:
  `fused_rtl_operator_timing_qd/seed_1001`
- Model preflight:
  `openai/gpt-oss-120b max_model_len=131072`
- Budget:
  population `12`, generations `3`, seed `1001`
- Subset:
  13 hard/tuning problems in `tables/hard_tuning_subset.yaml`

The run completed all 13 problems. The single-thought validator and
Pareto/front validator both passed.

## Headline Comparison

All 13 rows are reference-complete headline rows in
`hard_tuning_package/tables/t64_ppa_completeness.csv`. There are no
missing-reference rows in this screen.

| Metric | Classic | T64 | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | `0.092601` | `0.084572` | `-0.008029` |
| Mean HV-AUC | `0.082020` | `0.072750` | `-0.009270` |
| Mean best score | `0.227928` | `0.227030` | `-0.000898` |
| Valid PPA count | `257` | `283` | `+26` |
| PPA front points | `30` | `23` | `-7` |
| Unique PPA points | `87` | `74` | `-13` |
| Reference-beating candidates | `46` | `38` | `-8` |

T64 improves valid-PPA yield, especially on the RTLLM slice, but that extra
yield does not become stronger PPA-front evidence. Classic wins the primary
QD comparison metrics: HV, HV-AUC, front points, unique PPA points, and
reference-beating candidates.

## Lineage Read

Compared with T63, T64 adds valid-PPA yield but loses the stronger T63
front-material clue:

- valid PPA rises from `257` to `283`;
- mean HV falls from `0.089551` to `0.084572`;
- mean HV-AUC falls from `0.074125` to `0.072750`;
- front points fall from `25` to `23`;
- unique PPA points fall from `85` to `74`;
- reference-beating candidates fall from `50` to `38`.

This means `operator_timing` is not a better primary archive geometry than
T63's `state_pipeline` profile for this live screen. It remains useful as a
yield/archive-health diagnostic because active archive members rise from T63's
`69` to T64's `88`.

## Validity And Completeness

No classic-covered design is lost. The 50 percent yield warning gate does not
fire for any design with at least 10 classic valid-PPA samples. The
`Prob151_review2015_fsm` row is labeled `small_n` because the classic
denominator is only `2`.

Missing candidate PPA and missing reference PPA are separated. Missing
candidate PPA counts as method-invalid data. Missing reference PPA would make a
row diagnostic-only; none are present in T64's hard/tuning subset.

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

Static strict Phase 03.1 validation passed. Playwright produced screenshots,
but the interactive validator reported the same compare-guide caveat seen for
T63: compare mode did not emit rank guides for both techniques in two guide
checks. The exported viewer itself includes compare mode, timeline, archive
projection, raw/improvement/normalized PPA modes, raw A-P front mode,
datasets, manifest, validation files, and screenshots.

## Decision

T64 is not a promoted useful-QD result. It is a diagnostic RTL-native ablation:
the operator/timing descriptor improves valid-PPA yield and archive occupancy,
but it does not improve the PPA-front metrics needed to argue that the QD
archive is outperforming classic REvolution.

Next work should not spend seed `1002` on exact T64. The RTL-native lane should
either use MasterRTL/RTLTimer-style descriptors as secondary/reporting archive
evidence or redesign the generator/archive coupling so RTL-native cells are
used to preserve implementation families without weakening front creation.
