# T60 RTLTimer Timing-Risk BD Results Report

Status: `T0 diagnostic_proxy`. This is a retrospective descriptor audit over
existing full-RTLLM valid-PPA candidates, not a live QD run.

## Question

Does a lightweight RTLTimer-style timing-risk descriptor separate useful
front material better than the current exact T26 SR-PCA archive evidence?

## Method

`scripts/package_rtl_timer_timing_risk_audit.py` reads the full RTLLM family
audit candidate table and extracts descriptor-only RTL features from each
candidate `code.sv`. The proxy features count control constructs, pipeline
events, arithmetic and shift operators, comparator/logical operators, RHS
operator depth, identifier fanout, and an aggregate timing-risk score.

Inputs do not include final PPA, reference PPA, fitness, hypervolume, Pareto
rank, or test pass status. Pareto-front labels are used only after feature
extraction for reporting.

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

The `diagnostic_only` rows are the known missing/defaulted-reference designs:
`Prob006_adder_pipe_64bit`, `Prob013_multi_booth_8bit`,
`Prob018_float_multi`, and `Prob040_synchronizer`.

## Aggregate Descriptor Read

| Method | Candidates | Front | Occupied Cells | Front Cells | Mean Risk | Mean Front Risk |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Classic | 352 | 61 | 16 | 16 | 32.005824 | 26.695902 |
| Exact T26 QD | 318 | 69 | 16 | 16 | 28.658176 | 29.384783 |

Both methods occupy all 16 coarse timing-risk cells overall and all 16 front
cells in the pooled view. That means this first T60 proxy does not show a
clear archive-coverage advantage over classic.

The problem-balanced comparison is weaker for exact T26:

| Delta | Mean | T26 Better | Classic Better | Tie |
| --- | ---: | ---: | ---: | ---: |
| Front timing-risk cells | -0.096774 | 4 | 6 | 21 |
| Occupied timing-risk cells | -0.612903 | 6 | 17 | 8 |
| Mean timing-risk score | -0.490162 | 13 | 18 | 0 |
| Mean front timing-risk score | -3.056707 | 9 | 18 | 4 |

## Figure Read

`figures/timing_risk_projection.png` shows a visible timing-risk geometry with
outliers, dense low-risk clusters, and front markers. The plot is useful for
inspection, but it does not reveal a clean T26-only region of front material.

Manual visual inspection passed: labels are readable, methods are visually
separable, hollow markers identify front candidates, and axes do not claim to
be PPA objectives.

## Tier Decision

T60 remains `T0 diagnostic_proxy`.

This proxy supports continuing the RTL-native descriptor lane because the
features are interpretable and RTL-native, but it does not promote a live
configuration. The first result is not a near-classic or better QD result.

## Follow-Up

Next T60/T61 work should replace the regex proxy with a true RTLTimer or
MasterRTL/SOG extraction path, then normalize timing-risk cells per problem
before a live screen. A reasonable hybrid is T51 or T26 archive machinery with
problem-local RTL timing-risk bins, plus a redundancy check that the descriptor
is not only problem identity or PPA-yield proxy.
