# Sub-Agent Screen Prelaunch Review

Reviewer: Bohr (`019eefab-d9da-7e42-a422-ac4e22b0528d`)
Date: 2026-06-22 UTC

## Findings

- No metric blocker under the revised hard gate. Exact T26 preserves every
  classic-covered screen problem: ALU `10/26`, traffic-light `20/19`, and
  multi-pipe `10/21`. The two drops are correctly labeled `yield_warning`, not
  `classic_covered_loss`.
- Package consistency was the main pre-launch blocker: the screen report
  selected `sr_raw_conservative_exploit_qd`, while the top-level README and
  method-lineage table still said selection was pending. These were updated
  before full launch.
- A gate-order issue in `problem_gate_row` could overwrite
  `classic_covered_loss` with `small_n` when classic had 1-9 valid-PPA samples
  and QD had zero. It did not affect the screen but was corrected before reuse.

## Required Caveats

- This is a one-seed engineering milestone, not seed-stable evidence.
- Exact T26's screen win is narrow: mean HV `+1.35%`, HV-AUC `+12.0%`, valid
  PPA `40` versus classic `66`, front points `6` versus `10`, and unique PPA
  points `33` versus `55`.
- Do not claim front/family diversity improvement from exact T26. Prior T28/T30
  audits show weaker front-family breadth than classic.
- Full report must include screen-excluded aggregates and budget parity / LLM
  call counts.

## Arm Choice

Exact T26 is the right full-run arm for the deadline goal because it is the only
screened QD arm with positive final mean HV versus classic and also improves
HV-AUC. Low fusion and mid fusion should be treated as exploratory follow-ups,
not the confirmatory full-run arm.
