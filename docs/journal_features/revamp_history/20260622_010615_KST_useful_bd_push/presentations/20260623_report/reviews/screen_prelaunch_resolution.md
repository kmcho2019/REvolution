# Screen Prelaunch Review Resolution

Date: 2026-06-22 UTC

Reviews:

- `subagent_screen_prelaunch_review.md`
- `claude_screen_prelaunch_review.md`

Resolution:

- Fixed the hard gate precedence in `scripts/package_rtllm_milestone_screen.py`
  so `classic_covered_loss` cannot be overwritten by `yield_warning` or
  `small_n`.
- Added a focused branch test for `problem_gate_row`.
- Reconciled `README.md` and `tables/method_lineage_selection.md` so exact
  T26 is frozen as the full-run arm before full RTLLM outcomes are seen.
- Added the screen package regeneration command and source script provenance.
- Reframed exact T26 as a narrow PPA/HV confirmatory arm, not a front-breadth
  or diversity-family win.

Remaining launch caveats:

- One seed supports engineering evidence only, not seed-stable significance.
- Exact T26 must carry ALU and multi-pipe yield warnings in all result reports.
- Full packaging must include screen-excluded aggregates, LLM-call/evaluation
  parity, direct PPA plots, and Phase 03.1 viewer artifacts when archive data
  is available.
