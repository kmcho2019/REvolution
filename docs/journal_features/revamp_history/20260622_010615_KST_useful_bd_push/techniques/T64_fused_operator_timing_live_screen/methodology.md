# T64 Fused Operator/Timing Live Screen Methodology

Status: completed seed `1001`; result is diagnostic, not promoted.

## Question

T63 showed that fused RTL-native descriptors can add RTLLM front material
versus T51, but the `state_pipeline` profile still loses classic on mean HV,
HV-AUC, and front points. T64 asks whether the other T62 co-lead profile,
`fused_rtl_operator_timing_2d`, is a better live archive geometry.

This is a narrow ablation, not a new algorithm family.

## Method Delta From T63

T64 keeps the T63 live setup fixed:

- hard/tuning 13-problem surface;
- seed `1001`;
- local vLLM model `openai/gpt-oss-120b`;
- `128000` max-token and diff-token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- `grid_quantile` archive with warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- `qd_parent_selection=nsga2_global_rank`;
- no two-parent fusion;
- no repair.

T64 changes only the archive descriptor profile:

- T63: `fused_rtl_state_pipeline_2d`;
- T64: `fused_rtl_operator_timing_2d`.

The T64 axes are:

- `operator_mix_score`, emitted by the Yosys graph/SOG path;
- `timing_risk_score`, emitted by the RTL timing-risk path.

Both axes are RTL-native and PPA-free. They do not use final PPA, reference
PPA, fitness, hypervolume, Pareto rank, classic results, or test pass rate.

## Comparator Surface

Use the same hard/tuning comparator surface as T47 through T63:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `tables/hard_tuning_subset.yaml`;
- seed: `1001`;
- classic comparator: T47 `classic_revolution`;
- lineage comparators: T51 and T63.

Do not change the subset after seeing T64 outcomes.

## Required Measurements

Report:

- descriptor probe output and emitted archive axes;
- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T51 and T63 for valid-PPA count, HV, HV-AUC, aggregate front
  points, unique PPA points, reference-beating candidates, and active archive
  members;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples;
- direct raw area-power PPA-front panels for all 13 problems;
- full Phase 03.1 `qd_ppa_viewer/` with honest classic projection;
- `ppa_completeness.csv`, with missing-reference rows excluded from headline
  claims.

## Acceptance Signals

T64 can advance only if it:

- preserves every classic-covered valid-PPA design;
- improves T63 or T51 on aggregate front points, unique PPA points, active
  archive members, or reference-beating candidates;
- keeps T51 valid-PPA count within 10 percent;
- has no defaulted-reference headline claim;
- includes direct raw PPA figures and the Phase 03.1 viewer.

If T64 repeats the T63 pattern or worsens yield, retire exact fused
operator/timing as a primary archive geometry and keep RTL-native descriptors
only as secondary/reporting archive evidence unless a new generator coupling
is specified first.

## Outcome

T64 improves valid-PPA yield (`283` versus classic `257`) and active archive
members (`88`), but it loses classic on mean HV, HV-AUC, front points, unique
PPA points, and reference-beating candidates. The live result therefore
confirms `operator_timing` as a diagnostic RTL-native descriptor, not as a
better primary archive geometry than T63's `state_pipeline` profile.
