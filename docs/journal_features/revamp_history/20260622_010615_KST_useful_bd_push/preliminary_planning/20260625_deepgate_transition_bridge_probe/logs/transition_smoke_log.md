# Transition Smoke Log

## 2026-06-25

- Tested `clk2fflogic` on representative sequential screen candidates.
- Confirmed that latch-bearing AIGs can be rewritten as latch-free transition
  AIGs by exposing state as inputs and next-state functions as outputs.
- Tried full transition embedding probes at caps of `700`, `300`, and `200`
  AIG variables.
- Interrupted each run after the official DeepGate parser remained in
  `return_order_info` / `top_sort`.
- Decision: transition abstraction is methodologically plausible, but the
  current full-design parser path is not usable enough for live QD spending.
