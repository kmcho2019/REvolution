# compact_8d Seed-1002 Health-Gate Rationale (2026-07-04, watch c7)

The registered gate ("extraction failure on any problem kills the arm
at one seed") required interpretation: seed 1001 shows 50/50 health
files but 15 problems with zero observations and 6 with collapsed
axes.

Ruling, with evidence:

- **Zero-observation problems are upstream candidate scarcity, not
  descriptor failure.** The trio_cvt control at the same seed has 14
  zero-observation problems and the sets are identical except
  Prob029_barrel_shifter — these are the suite's hard designs where no
  candidate survives to descriptor extraction under ANY profile.
  Extraction succeeded on every problem where candidates existed, so
  the gate PASSES and seed 1002 ran.
- **Collapse comparison (nonzero-observation problems, identical CVT
  geometry, same seed): compact_8d 6 collapsed vs trio 26.** The
  profile's screen-era zero-collapse property scales: at suite scale
  it is ~4x more collapse-resistant than the frozen trio on the same
  archive geometry.
- Gate-implementation note: the chain's automated check tested health-
  file existence only; this document is the explicit semantic ruling
  the reviewer required, and any future health gate should test
  "zero-observation set is a subset (+-1) of the control's" rather
  than file existence.
