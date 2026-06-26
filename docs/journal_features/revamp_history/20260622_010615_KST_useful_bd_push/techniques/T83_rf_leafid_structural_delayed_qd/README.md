# T83 RF Leaf-ID Structural Delayed QD

Status: `pre_registered_not_run`.

T83 tests whether the validated MasterRTL RF timing model-state signal works
better as one archive coordinate inside a stronger RTL-native/delayed archive
coupling, instead of serving as the full RF timing descriptor geometry.

## Decision State

No result yet. The run is frozen in
`../../preliminary_planning/20260626_rf_leafid_structural_delayed_probe/`.

## Files

- `methodology.md`: algorithm, descriptor axes, and anti-leakage contract.
- `commands/run_t83_rf_leafid_structural_delayed.md`: frozen live command.
- `artifacts_manifest.md`: expected artifacts and current preflight record.
- `tables/preflight_models_20260626_rf_leafid.txt`: vLLM preflight copied
  from the preliminary-planning package.
- `tables/descriptor_probe_20260626_rf_leafid.json`: resolved axis
  requirements showing this BD does not use PPA inputs.
