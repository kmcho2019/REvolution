# T83 RF Leaf-ID Structural Delayed QD

Status: `T0_near_classic_diagnostic_not_promoted`.

T83 tests whether the validated MasterRTL RF timing model-state signal works
better as one archive coordinate inside a stronger RTL-native/delayed archive
coupling, instead of serving as the full RF timing descriptor geometry.

## Decision State

The frozen eight-design `8x5` screen is complete in
`../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/`.

Exact T83 is not promoted. Mean HV is close to classic
(`0.1369` versus `0.1406`), but Pareto breadth, reference-beating candidates,
and RTLLM-only HV are weaker. Removing `Prob135_m2014_q6b` widens the HV gap
to `-20.29%`.

## Files

- `methodology.md`: algorithm, descriptor axes, and anti-leakage contract.
- `results_report.md`: completed screen summary and decision.
- `commands/run_t83_rf_leafid_structural_delayed.md`: frozen live command.
- `artifacts_manifest.md`: result artifacts and current preflight record.
- `tables/preflight_models_20260626_rf_leafid.txt`: vLLM preflight copied
  from the preliminary-planning package.
- `tables/descriptor_probe_20260626_rf_leafid.json`: resolved axis
  requirements showing this BD does not use PPA inputs.
