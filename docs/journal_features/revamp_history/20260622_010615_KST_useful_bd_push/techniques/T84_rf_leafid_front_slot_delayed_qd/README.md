# T84 RF Leaf-ID Front-Slot Delayed QD

Status: `completed_diagnostic_not_promoted`.

T84 tests whether the T83 RF leaf-ID model-state archive can recover front
material when parent sampling includes a bounded local front-slot lane.

## Decision State

The frozen eight-design screen completed. T84 does not promote to full RTLLM
spend:

| Metric | Classic | T84 |
| --- | ---: | ---: |
| Mean HV | `0.1406` | `0.1162` |
| Mean Pareto points | `3.25` | `1.88` |
| Mean reference-beating candidates | `8.00` | `3.75` |
| HV wins | `5/8` | `0/8` |

The result package is in
`../../preliminary_planning/20260626_rf_leafid_front_slot_delayed_probe/`.
Keep T83, not T84, as the current representative of the pretrained
MasterRTL RF model-state lane.

## Files

- `methodology.md`: algorithm, descriptor axes, anti-leakage contract, and
  promotion gate.
- `commands/run_t84_rf_leafid_front_slot_delayed.md`: frozen live command.
- `artifacts_manifest.md`: completed artifact index.
- `results_report.md`: technique-level conclusion.
- `tables/preflight_models_20260626_rf_leafid_front_slot.txt`: vLLM preflight
  copied from the preliminary-planning package.
- `tables/descriptor_probe_20260626_rf_leafid_front_slot.json`: resolved axis
  requirements showing this BD does not use PPA inputs.
