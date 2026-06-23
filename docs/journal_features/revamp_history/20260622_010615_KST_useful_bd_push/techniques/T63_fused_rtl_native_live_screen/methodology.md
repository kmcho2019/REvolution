# T63 Fused RTL-Native Live Screen Methodology

Status: pre-registered; not run yet.

## Question

T62 showed that fused RTL-native descriptors give a small positive
front-cell proxy, but still lose occupied-cell breadth. T63 asks whether that
descriptor can help when used inside the stronger T51 live machinery instead
of as a retrospective audit.

This is the first live-runnable L7 method after T62. It should be treated as a
screen, not a headline run.

## Method Delta From T51

T63 keeps T51 fixed:

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

T63 changes only the archive descriptor profile:

- T51: `sr_pca_3d`;
- T63 primary: `fused_rtl_state_pipeline_2d`.

The primary profile axes are:

- `state_control_ratio`, emitted by the Yosys graph/SOG path;
- `control_pipeline_ratio`, emitted by the RTL timing-risk path.

If the primary screen preserves coverage but front evidence remains weak,
`fused_rtl_operator_timing_2d` is the first ablation because T62 tied the best
front-cell delta on that profile. Do not run both blindly before packaging the
primary screen.

## Runtime Descriptor Hook

T63 registers the fused RTL-native profile in
`data/configs/qd_descriptor_profiles.yaml` and adds narrow runtime metrics:

- Yosys graph/SOG: `operator_mix_score`, `state_control_ratio`,
  `sog_complexity_score`, and `sog_entropy`;
- RTL timing-risk: `timing_risk_score`, `control_pipeline_ratio`, and
  `timing_risk_entropy`.

These descriptors do not use final PPA, reference PPA, fitness, hypervolume,
Pareto rank, classic results, or test pass rate as inputs.

## Comparator Surface

Use the T47 through T59 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in the command file;
- seed: `1001`;
- classic comparator: T47 `classic_revolution`;
- primary off-mode comparator: T51 `code_thought_front_slot_qd`;
- latest negative controls: T58 and T59.

Do not change the subset after seeing T63 outcomes.

## Required Measurements

Report:

- descriptor probe output and emitted archive axes;
- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T51 for valid-PPA count, HV, HV-AUC, aggregate front points,
  unique PPA points, reference-beating candidates, and active archive members;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples;
- direct raw area-power PPA-front panels for all 13 problems;
- full Phase 03.1 `qd_ppa_viewer/` with honest classic projection;
- `ppa_completeness.csv`, with missing-reference rows excluded from headline
  claims.

The completeness table must use this schema:

```text
problem,classic_valid_ppa,qd_valid_ppa,reference_ppa_valid,comparison_status
```

Rows with missing candidate PPA are method-invalid rows. Rows with missing
reference PPA are `diagnostic_only` rows: include them in inventory and raw
diagnostic plots, but exclude them from headline HV, HV-AUC, normalized
improvement, and direct classic-vs-QD claims.

## Acceptance Signals

T63 can advance only if it:

- preserves every classic-covered valid-PPA design;
- improves T51 on aggregate front points, unique PPA points, or active archive
  members;
- keeps T51 valid-PPA count within 10 percent;
- has no defaulted-reference headline claim;
- includes direct raw PPA figures and the Phase 03.1 viewer.

If T63 loses T51 on HV/HV-AUC and front evidence, keep the RTL-native lane as
reporting or secondary-archive evidence and do not spend seed `1002` on this
exact profile.
