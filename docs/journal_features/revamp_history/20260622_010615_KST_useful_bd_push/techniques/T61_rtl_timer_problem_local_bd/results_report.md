# T61 RTLTimer Problem-Local BD Results Report

Status: `T0 positive_proxy_not_promoted`. This is a retrospective descriptor
audit over existing full-RTLLM valid-PPA candidates, not a live QD run.

## Question

Does problem-local timing-risk binning reveal useful front-cell diversity that
was hidden by T60's global timing-risk bins?

## Method

T61 reuses `scripts/package_rtl_timer_timing_risk_audit.py` with
`--cell-scope problem`. The RTL timing-risk feature vector is identical to T60;
only the cell assignment changes. Each problem gets its own 4x4 quantile grid
over timing-risk score and control/pipeline ratio.

Source data:

- `presentations/20260623_report/full_rtllm/family_audit/tables/full_family_candidate_rows.csv`
- `presentations/20260623_report/data/rtllm_50_problem_manifest.csv`

Feature schema SHA-256:
`708de7cb22f066fa7efd9d41af50113416d0690f3a356b39e9dbe03ee6be6f22`.

## PPA Completeness

`tables/ppa_completeness.csv` keeps the full 50-problem RTLLM manifest visible:

| Status | Count |
| --- | ---: |
| `headline` | 31 |
| `candidate_missing` | 15 |
| `diagnostic_only` | 4 |

The `diagnostic_only` rows are `Prob006_adder_pipe_64bit`,
`Prob013_multi_booth_8bit`, `Prob018_float_multi`, and
`Prob040_synchronizer`.

## Aggregate Descriptor Read

| Method | Candidates | Front | Occupied Cells | Front Cells | Mean Risk | Mean Front Risk |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 352 | 61 | 16 | 15 | 32.005824 | 26.695902 |
| Exact T26 QD | 318 | 69 | 16 | 16 | 28.658176 | 29.384783 |

Problem-local bins turn one pooled front-cell signal positive: exact T26 QD
occupies `16` front cells versus classic's `15`. The problem-balanced
front-cell delta also improves versus T60:

| Metric | T60 Global | T61 Problem-Local |
| --- | ---: | ---: |
| Mean front-cell delta | -0.096774 | 0.129032 |
| Problems where T26 has more front cells | 4 | 6 |
| Problems where classic has more front cells | 6 | 4 |

The broader archive signal is still weak:

| Delta | Mean | T26 Better | Classic Better | Tie |
| --- | ---: | ---: | ---: | ---: |
| Front timing-risk cells | 0.129032 | 6 | 4 | 21 |
| Occupied timing-risk cells | -0.774194 | 8 | 16 | 7 |
| Mean timing-risk score | -0.490162 | 13 | 18 | 0 |
| Mean front timing-risk score | -3.056707 | 9 | 18 | 4 |

## Figure Read

`figures/timing_risk_projection.png` uses the same raw descriptor geometry as
T60. The plot remains readable and diagnostic, but the T61 result is in the
cell table rather than the scatter geometry.

## Tier Decision

T61 is `T0 positive_proxy_not_promoted`.

The problem-local cell ablation finds a small positive front-cell signal, so
the RTL-native timing-risk lane should continue. It is not a live QD result,
does not beat classic on PPA metrics, and still has weaker occupied-cell
breadth, so it cannot be promoted beyond a proxy clue.

## Follow-Up

Use problem-local timing-risk bins in the next true RTL-native live screen, but
replace the regex proxy with RTLTimer or MasterRTL/SOG extraction first. The
live candidate should be paired with T51/T26-family archive machinery and must
include Phase 03.1 visualization, direct PPA-front plots, PPA completeness, and
duplicate/family checks.
