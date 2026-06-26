# T82 MasterRTL RF Timing Runtime Hook

Status: `T0_runtime_hook_positive_not_live_screened`.

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

This is an implementation gate, not a live QD result. It supports a tiny live
vLLM smoke next, followed by the frozen `8x5` screen only if archive artifacts
and descriptor non-collapse checks pass.

## Files

- `methodology.md`: descriptor hook and dependency boundary.
- `results_report.md`: smoke result, caveats, and next gate.
- `artifacts_manifest.md`: file inventory and commands.
- `commands/runtime_hook_smoke.md`: exact commands.
- `tables/runtime_hook_smoke_metrics.json`: measured smoke metrics.
- `figures/rf_timing_runtime_hook_smoke.png`: inspected summary figure.
