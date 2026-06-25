# Transition Smoke Log

## 2026-06-25

- Tested `clk2fflogic` on representative sequential screen candidates.
- Confirmed that latch-bearing AIGs can be rewritten as latch-free transition
  AIGs by exposing state as inputs and next-state functions as outputs.
- Found that the first rewrite preserved sparse latch variable numbers and let
  constant literals reach DeepGate as node `-1`; this caused parser
  topological-sort hangs.
- Added canonical renumbering and a surrogate PI for constants.
- Re-ran the transition probe with `--max-aig-vars 700`; it completed with
  `60` embeddings across `5/8` screen problems.
- Tested `Prob015_multi_pipe_8bit` at higher cap. One transition AIG parsed
  in `39.76s`, so large designs are possible offline but too slow for the
  current live descriptor path.
