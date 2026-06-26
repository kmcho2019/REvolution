# T81 MasterRTL RF Timing State Gate

Status: `T0_model_state_gate_positive_not_live`.

T81 tests the only MasterRTL pretrained artifact that did not collapse in T76:
the saved random-forest timing model. It runs the upstream timing-DAG split,
delay initialization, and `ProcessGraph.Graph_STA` path on the T70 generated
RTL candidate corpus, then captures the exact eight-feature path vectors sent
to `rfr_model.pkl`.

## Result

The RF timing state is noncollapsed on generated candidates:

- `13/19` candidates evaluate;
- `166` timing paths are captured;
- `53` unique RF leaf rows appear;
- `414` unique RF leaf IDs appear;
- feature out-of-range fraction is `0.125` to `0.243` for evaluated
  candidates.

The coverage caveat is also real: `6/19` candidates have `no_clock_split`, so
the descriptor is timing-path limited and should not be used as a universal
RTL descriptor.

## Files

- `methodology.md`: algorithm and validation boundary.
- `results_report.md`: result, tier decision, and follow-up.
- `artifacts_manifest.md`: commands and artifact inventory.
- `commands/rf_timing_gate_v0.md`: exact isolated uv command.
- `tools/run_t81_rf_timing_gate.py`: reproducer.
- `tables/`: generated CSV and JSON outputs.
- `figures/t81_rf_timing_state_gate.png`: inspected summary figure.
