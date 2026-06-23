# T64 Fused Operator/Timing Live Screen Results

Status: pre-registered; no seed result yet.

T64 is the immediate T63 ablation. It keeps the same live generator and
hard/tuning surface, changing only the archive descriptor profile from
`fused_rtl_state_pipeline_2d` to `fused_rtl_operator_timing_2d`.

## Pre-Run Guardrails

- Do not interpret any T64 result outside the frozen 13-problem surface.
- Do not compare headline HV, HV-AUC, normalized improvement, or direct
  classic-vs-QD deltas on missing-reference rows.
- Missing candidate PPA is method-invalid data.
- Missing reference PPA makes the row `diagnostic_only`.
- Do not promote T64 from best-score movement alone.

## Pending Measurements

The completed report must include:

- run root and vLLM preflight metadata;
- single-thought and Pareto/front validation status;
- aggregate HV, HV-AUC, best-score, valid-PPA, and front-point deltas versus
  classic;
- lineage deltas versus T51 and T63;
- `ppa_completeness.csv`;
- direct raw area-power PPA-front supplement;
- full Phase 03.1 viewer package;
- visual inspection notes and final tier decision.
