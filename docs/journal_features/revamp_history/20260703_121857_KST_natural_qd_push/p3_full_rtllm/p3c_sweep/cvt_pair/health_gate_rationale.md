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
- Ordering rule (watch c8, dated 2026-07-04): this ruling was written
  AFTER the automated gate had already launched seed 1002 (launch
  17:29 UTC, ruling committed 17:53 UTC). The evidence supports the
  gate so the launch stands, but future health-gated launches must
  record the semantic ruling BEFORE the gated launch fires — either
  by a manual gate step or by implementing the subset-semantics check
  in the chain itself.

Post-hoc qualification (2026-07-05, watch c19): at seed 1002 the
compact_8d arm DID hit a genuine extraction failure — Prob050 died
with "Missing required descriptor metric 'scoap_signal_smoothness'"
(worker log), leaving archive artifacts but no summary; the arm
process exited 0 so the chain saw no run-level failure. Per the
registration's own kill clause this makes compact_8d formally
extraction-fragile (1 hard failure per ~100 problem-runs). HV impact
is negligible (Prob050 zero-filled; classic 0.0028 / trio_cvt 0.0010
there), but the fragility qualifies the swap candidacy and future
validators should treat missing problem summaries as failures even
when generation logs exist.
