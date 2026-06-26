# T82 MasterRTL RF Timing Runtime Hook

Status: `T0_screened_negative_not_promoted`.

T82 wires the T81 MasterRTL RF timing-state gate into the live descriptor
registry. It adds the `source_aligned_rf_timing_state_3d` profile and keeps RF
timing extraction off unless that profile is selected.

## Result

The runtime hook smoke passes on one generated RTLLM candidate:

- profile: `source_aligned_rf_timing_state_3d`;
- candidate: `Prob015_multi_pipe_8bit` T70/T67 generated RTL;
- RF timing paths: `51`;
- unique RF leaf rows: `14`;
- unique RF leaf IDs: `161`;
- no-path flag: `0`.

The follow-up live smoke also passed on one RTLLM problem with one valid
PPA/archive member. The frozen `8x5` screen then completed in
`../../preliminary_planning/20260626_masterrtl_rf_timing_state_screen/` and is
negative for this exact profile. Classic wins mean HV `0.1406` versus RF
timing QD `0.1140`, so do not promote this profile to full RTLLM spend.

## Files

- `methodology.md`: descriptor hook and dependency boundary.
- `results_report.md`: smoke result, caveats, and next gate.
- `artifacts_manifest.md`: file inventory and commands.
- `commands/runtime_hook_smoke.md`: exact commands.
- `tables/runtime_hook_smoke_metrics.json`: measured smoke metrics.
- `figures/rf_timing_runtime_hook_smoke.png`: inspected summary figure.
