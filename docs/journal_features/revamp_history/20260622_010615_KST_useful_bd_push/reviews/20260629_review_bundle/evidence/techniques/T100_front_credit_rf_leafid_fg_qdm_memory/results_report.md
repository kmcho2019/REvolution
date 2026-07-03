# T100 Results Report

## Question

Does the existing front-guarded QD-memory scheduler become more competitive if
T97's SR-PCA descriptor is replaced with the validated MasterRTL RF leaf-ID
structural descriptor used by T83?

## Answer

Partially. T100 is the best FG-QDM smoke so far, but it still does not beat
classic REvolution on the three-problem smoke. The result supports a narrow
descriptor conclusion, not a promotion decision:

- RF leaf-ID structural memory is better than SR memory under the same
  front-credit FG-QDM policy on this smoke.
- RF leaf-ID structural memory is much better than the same-threshold random
  memory control.
- Classic REvolution remains stronger on mean HV, strict per-problem HV record,
  Pareto-front breadth, and reference-beating candidate count.

## Metrics

Source:
`analysis/pareto_analysis/aggregate_backend_metrics.csv`.

| Arm | Mean HV | Mean Pareto points | Mean reference-beating count | Backend-best HV count |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_12x3` | `0.190331` | `3.00` | `17.33` | `3` |
| `fg_qdm_rf_leafid_front_credit_12x3` | `0.156553` | `2.00` | `12.00` | `0` |
| `fg_qdm_sr_front_credit_12x3` | `0.153384` | `1.67` | `9.33` | `0` |
| `fg_qdm_random_front_credit_12x3` | `0.104805` | `2.67` | `7.00` | `0` |

Per-problem HV:

| Problem | Classic | T100 RF-leaf FG-QDM | T97 SR FG-QDM | T98 random FG-QDM |
| --- | ---: | ---: | ---: | ---: |
| `Prob015_multi_pipe_8bit` | `0.000000` | `0.000000` | `0.000000` | `0.000000` |
| `Prob041_traffic_light` | `0.315492` | `0.233054` | `0.232950` | `0.138446` |
| `Prob045_alu` | `0.255499` | `0.236606` | `0.227203` | `0.175969` |

## Mechanism Signal

Source: `tables/t100_memory_lane_summary.csv`.

| Lane | Generated | Valid PPA | Global-front adds | Local-front adds |
| --- | ---: | ---: | ---: | ---: |
| `classic` | `98` | `37` | `11` | `24` |
| `memory_refine` | `6` | `2` | `0` | `2` |
| `front_rescue` | `4` | `4` | `2` | `4` |
| `probe` | `0` | `0` | `0` | `0` |

The important difference from T97 is the `front_rescue` lane: it produced
valid-PPA children on every sampled call and added global-front material. The
`memory_refine` lane remains weak, with no global-front additions.

## Common Evaluation Contract

Source: `tables/method_seed_summary.csv`.

| Method | Headline problems | Mean HV | Mean HV-AUC | Mean valid-PPA | Passive coverage | Classic HV delta |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `classic_revolution_12x3` | `3` | `0.190331` | `0.165380` | `23.67` | `not_available` | `0.000000` |
| `fg_qdm_rf_leafid_front_credit_12x3` | `3` | `0.156553` | `0.126839` | `16.33` | `0.312500` | `-0.033777` |

The completeness gate marks all three smoke problems as `headline` with
`pass` valid-PPA yield status. That means T100 preserves coverage on this
smoke subset. The common-table result still reinforces the negative promotion
decision because T100 loses mean HV, HV-AUC, Pareto points, and
reference-beating count. The strict paired HV record is classic `2`,
T100 `0`, and ties `1`.

Classic passive archive fields are `not_available`. This is intentional: the
RF leaf-ID descriptor cannot be honestly recovered for classic candidates by
the generic graph-metric path.

## Visualization

- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`.
- Direct static PPA-front supplement:
  `visualizations/direct_ppa_pareto/index.html`.
- PPA distribution report:
  `analysis/ppa_distribution/report.md`.

Classic candidate projection into the RF leaf-ID archive was disabled during
viewer export. The generic graph-metric recovery path cannot honestly recover
`source_aligned_rf_timing_leaf_ids` for classic candidates. The viewer still
shows classic PPA samples, but classic archive cells are not claimed.

## Decision

Keep T100 as the FG-QDM category representative because it improves over T97
and gives a cleaner front-rescue mechanism signal. Do not promote exact T100
to the frozen eight-design screen or full RTLLM run because classic still wins
the smoke HV comparison decisively enough.
