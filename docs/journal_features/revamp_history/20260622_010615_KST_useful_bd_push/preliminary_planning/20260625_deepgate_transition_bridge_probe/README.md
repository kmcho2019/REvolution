# DeepGate Transition Bridge Probe

## Verdict

Transition abstraction is a plausible DeepGate bridge fix, but the official
`python-deepgate` parser is too slow on the generated transition AIGs we need.
Do not spend live RTLLM budget on this lane yet.

The transform converts latch-bearing AIGs into combinational transition logic
by treating register state as extra inputs and next-state functions as extra
outputs. It improves export coverage for sequential designs, but the current
full-design transition AIGs still hit the parser topological-sort bottleneck.

## Contents

| Path | Purpose |
| --- | --- |
| `deepgate_transition_bridge_report.md` | Main result and decision. |
| `commands/run_deepgate_transition_bridge_probe.md` | Commands attempted. |
| `tables/transition_header_smoke.csv` | Header-level evidence for the state abstraction. |
| `logs/transition_smoke_log.md` | Manual run log and interruption rationale. |

## Decision

The next DeepGate attempt should not be another full-design transition run.
Use cone-level extraction or replace the parser/order computation first.
