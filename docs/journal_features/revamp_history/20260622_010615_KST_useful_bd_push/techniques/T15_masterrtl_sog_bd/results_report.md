# T15 MasterRTL/Yosys-SOG BD Results Report

Status: `T0 structural_proxy_not_promoted`. This is a retrospective
Yosys-backed SOG descriptor audit over existing full-RTLLM valid-PPA
candidates, not a live QD run and not a full MasterRTL implementation.

## Question

Can RTL-native operator-graph structure provide a more defensible behavior
descriptor than regex timing-risk proxies, and does it reveal front/archive
diversity that classic misses?

## Method

T15 runs `scripts/package_yosys_sog_audit.py` over the full RTLLM valid-PPA
candidate table:

- `presentations/20260623_report/full_rtllm/family_audit/tables/full_family_candidate_rows.csv`
- `presentations/20260623_report/data/rtllm_50_problem_manifest.csv`

Each candidate RTL is lowered through Yosys with `read_verilog -sv`,
`hierarchy -auto-top`, `proc`, `flatten`, `opt`, and `write_json`. Descriptor
cells are assigned within each problem using a 4x4 quantile grid over
operator-mix score and state/control ratio.

Feature schema SHA-256:
`1e80e676824d19e6b64d548c92b1e02fb2cf2cf44534e9738c448b459a58e61c`.

## Lowering Funnel

| Status | Count |
| --- | ---: |
| `lowered` | 670 |
| `yosys_failed` | 0 |

This is the strongest T15 signal: the Yosys-SOG proxy can extract RTL-native
structure from every valid-PPA candidate in the full RTLLM audit table.

## PPA Completeness

`tables/ppa_completeness.csv` keeps the corrected full-RTLLM comparison rule:
headline direct claims use only reference-complete paired problems.

| Status | Count |
| --- | ---: |
| `headline` | 31 |
| `candidate_missing` | 15 |
| `diagnostic_only` | 4 |

The `diagnostic_only` rows are `Prob006_adder_pipe_64bit`,
`Prob013_multi_booth_8bit`, `Prob018_float_multi`, and
`Prob040_synchronizer`.

## Aggregate Descriptor Read

| Method | Candidates | Front | Occupied Cells | Front Cells | Mean Complexity | Mean Front Complexity |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 352 | 61 | 16 | 15 | 55.556818 | 50.081967 |
| Exact T26 QD | 318 | 69 | 16 | 14 | 57.704403 | 53.420290 |

The pooled SOG archive is saturated in occupied-cell count for both methods,
but classic has one more pooled front cell (`15` versus `14`).

The problem-balanced paired read is mixed:

| Delta | Mean | T26 Better | Classic Better | Tie |
| --- | ---: | ---: | ---: | ---: |
| Front SOG cells | -0.032258 | 6 | 6 | 19 |
| Occupied SOG cells | -0.741935 | 5 | 14 | 12 |
| Mean SOG complexity | 4.626736 | 21 | 9 | 1 |
| Mean front SOG complexity | -10.883871 | 11 | 11 | 9 |

## Figure Read

- `figures/archive_coverage_heatmap.png` is the clearest front-cell visual.
  It shows both methods reaching many cells, with exact T26 concentrating more
  front candidates in low state/control bins.
- `figures/sog_projection.png` preserves the full outlier range.
- `figures/sog_projection_zoom.png` is the reader-facing dense-region view.

The figures were inspected after generation. The heatmap is presentation-ready
as a diagnostic descriptor-coverage figure; the scatter is useful as context
but should not be treated as a direct PPA-performance plot.

## Tier Decision

T15 is `T0 structural_proxy_not_promoted`.

The positive result is frontend viability: every valid-PPA candidate lowered
through Yosys, and the feature vector is RTL-native, reviewer-readable, and
free of final PPA/reference/test labels. The blocker is that the descriptor
audit does not show a clear exact-T26 front/archive win over classic. T26 has a
slightly negative mean front-cell delta, loses occupied-cell breadth, and this
package is retrospective rather than live.

## Follow-Up

Use T15 as the structural frontend for a fused RTL-native descriptor lane:
combine problem-local Yosys-SOG cells with T61 timing-risk cells, then test the
fused descriptor inside T51/T26-family archive machinery only after adding
reference-complete PPA completeness, duplicate/family checks, direct PPA-front
plots, and the Phase 03.1 viewer.
