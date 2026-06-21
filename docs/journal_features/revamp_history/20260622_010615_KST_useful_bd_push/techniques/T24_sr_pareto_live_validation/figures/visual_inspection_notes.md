# T24 Figure Visual Inspection Notes

Status: partial live result inspected.

## `live_sr_family_vs_classic.png`

Inspected on 2026-06-21 UTC.

- Labels are readable at the generated 2537 x 834 resolution.
- The three panels are visually distinct: best-score delta, synthesis-PPA rate
  delta, and global Pareto members.
- SR-RFF, SR ReLU, and SR raw use fixed colors across panels; the zero line
  carries the gain/loss meaning for delta panels.
- The long problem labels do not overlap after rotation.
- The figure makes the main conclusion easy to see: SR raw is the only
  completed SR arm with a positive `Prob045_alu` best-score delta and the
  largest `Prob015_multi_pipe_8bit` global Pareto count, but all completed SR
  arms still lose best score badly on `Prob015_multi_pipe_8bit`.

## `live_sr_rff_vs_classic.png`

Inspected on 2026-06-21 UTC.

- Labels are readable at the generated 2357 x 816 resolution.
- The three panels are visually distinct: best-score delta, synthesis-PPA rate
  delta, and SR-RFF front material.
- The zero line and bar direction make the gains and losses clear without
  requiring the reader to inspect the CSV first.
- The long problem labels do not overlap after rotation.
- The figure supports the stated cautious conclusion: SR-RFF has local front
  material and one best-score gain, but `Prob015_multi_pipe_8bit` has a large
  best-score and valid-PPA-rate regression.

No T1/T2/T3 result should be assigned from this figure alone because the full
T24 live matrix is still missing the manual control arm.

## `live_completed_qd_vs_classic.png`

Inspected on 2026-06-21 UTC.

- Labels are readable at the generated 2537 x 834 resolution.
- The four completed QD arms use fixed colors across panels: random in gray,
  SR-RFF in blue, SR ReLU in orange, and SR raw in green.
- The best-score and synthesis-PPA delta panels use a clear zero line, so gains
  and losses are easy to read without consulting the CSV first.
- The long problem labels do not overlap after rotation.
- The figure makes the current blocker easy to see: all completed QD arms lose
  `Prob015_multi_pipe_8bit` best score, while SR raw retains the most
  multi-pipe global Pareto material.
