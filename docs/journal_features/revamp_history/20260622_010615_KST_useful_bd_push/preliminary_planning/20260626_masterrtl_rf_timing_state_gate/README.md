# MasterRTL RF Timing State Gate

Status: completed offline, not promoted to live QD.

This package records the preliminary-planning readout for
`techniques/T81_masterrtl_rf_timing_state_gate/`.

## Answer

The current preliminary plan is not finished. T81 gives hard evidence that a
validated MasterRTL pretrained model-state descriptor lane is plausible, but
it has not yet run as a live QD configuration and cannot justify full RTLLM
spend.

## Result

| Metric | Value |
| --- | ---: |
| Generated candidates | `19` |
| Evaluated timing-path candidates | `13` |
| Timing paths | `166` |
| Unique RF leaf rows | `53` |
| Unique RF leaf IDs | `414` |

## Decision

Advance only to runtime-hook design. The next configuration must pool RF
timing model state into fixed BD coordinates, handle no-clock candidates
explicitly, and pass a bounded live smoke before an `8x5` screen.

## Links

- Technique package:
  `../../techniques/T81_masterrtl_rf_timing_state_gate/`
- Detailed report:
  `rf_timing_state_gate_report.md`
