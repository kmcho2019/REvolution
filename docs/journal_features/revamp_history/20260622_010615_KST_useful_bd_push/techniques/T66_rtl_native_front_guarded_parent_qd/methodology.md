# T66 RTL-Native Front-Guarded Parent QD Methodology

Status: pre-registered; result pending.

## Question

T63 showed that `fused_rtl_state_pipeline_2d` gives useful front-material
signals versus T51, but not enough to beat classic on HV, HV-AUC, or front
points. T64 showed that `fused_rtl_operator_timing_2d` improves yield and
archive occupancy, but loses more front material. T65 then showed that pure
RTLTimer-style secondary/reporting cells do not beat Classic front-cell
coverage.

T66 asks whether RTL-native descriptors become more useful when they affect
parent choice directly instead of only defining primary archive geometry or
posthoc reporting cells.

## Method Delta From T63

T66 keeps the T63 hard/tuning live surface fixed:

- hard/tuning 13-problem subset;
- seed `1001`;
- local vLLM model `openai/gpt-oss-120b`;
- `128000` max-token and diff-token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- `grid_quantile` archive with warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- descriptor profile `fused_rtl_state_pipeline_2d`;
- no bounded local repair.

T66 changes parent coupling:

- T63: `qd_parent_selection=nsga2_global_rank`;
- T66: `qd_parent_selection=front_slot_lane_nsga2`;
- T63: `qd_two_parent_probability=0.0`;
- T66: `qd_two_parent_probability=0.10`;
- T63: `qd_two_parent_gate=none`;
- T66: `qd_two_parent_gate=near_front_descriptor`;
- T63: `qd_operator_one_parent_fraction=1.0`;
- T66: `qd_operator_one_parent_fraction=0.90`.

The front-slot lane reserves the existing bounded parent requests for
cell-local front members. The near-front descriptor gate permits two-parent
fusion only when the existing rank and descriptor-distance gate accepts a
pair. If no compatible pair exists, the existing one-parent fallback is used
and counted.

## Descriptor Definition

T66 uses `fused_rtl_state_pipeline_2d`:

| Axis | Source | Intent |
| --- | --- | --- |
| `state_control_ratio` | RTL-native graph/source metrics | state/control structure |
| `control_pipeline_ratio` | RTL-native graph/source metrics | control and pipeline/register balance |

The descriptor must not use final PPA, reference PPA, fitness, hypervolume,
Pareto rank, classic results, problem identity, or test pass rate as in-loop
BD inputs.

## Why This Is Not A Pure Knob Sweep

T65 retired pure secondary RTL-native reporting cells. T66 therefore changes
the coupling point: the same RTL-native state/pipeline cells shape which
parents are sampled and which two-parent fusion requests survive. The method
tests whether meaningful RTL families help when they bias generation, not just
when they label finished candidates.

## Comparator Surface

Use the same 13-problem hard/tuning surface as T47 through T65:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: `tables/hard_tuning_subset.yaml`;
- seed: `1001`;
- classic comparator: T47 `classic_revolution`;
- lineage comparators: T51, T63, T64, and T65 diagnostics.

Do not change the subset after seeing T66 outcomes.

## Required Measurements

Report:

- descriptor probe output and emitted archive axes;
- front-slot lane parent requests and hits;
- two-parent requests, gate attempts, accepts, rejects, and fallbacks;
- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T51, T63, and T64 for valid-PPA count, front points, unique
  PPA points, reference-beating candidates, and active archive members;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples;
- `ppa_completeness.csv` with reference-complete headline eligibility;
- direct raw area-power PPA-front panels for all 13 problems;
- full Phase 03.1 `qd_ppa_viewer/` if archive artifacts are available.

## Acceptance Signals

T66 can advance only if it:

- preserves every classic-covered valid-PPA design;
- has no missing/defaulted-reference headline claim;
- improves T63 or T51 on aggregate front points, unique PPA points,
  reference-beating candidates, or active archive members;
- keeps T51 valid-PPA count within 10 percent;
- records nonzero front-slot hits or accepted gated fusion, unless the result
  beats T63/T51 without them and the report explains why;
- includes direct raw PPA figures and a Phase 03.1 viewer or a documented
  archive-artifact omission.

If T66 only improves best score while losing front/HV evidence, mark it `T0`.
If it improves front material while preserving T51 yield, it becomes the next
candidate for a held-out or seed-1002 validation.
