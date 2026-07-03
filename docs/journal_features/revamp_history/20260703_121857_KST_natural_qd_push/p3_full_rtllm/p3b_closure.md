# P3b Closure — Full-Suite Variant Probe Verdicts (2026-07-04)

All arms packaged per seed with green operator contracts; gates
applied exactly as registered (codex-verified arithmetic).

## Final suite-scale family table (46 ref-complete, 8x5)

| Arm | Seeds | Mean HV | vs classic | HV-AUC46 | vs classic | Coverage |
| --- | --- | --- | --- | --- | --- | --- |
| classic (reused roots) | 5 | 0.103802 | - | 0.086982 | - | 164 |
| **N03b front-slot lane** | 5 | **0.100587** | **96.9%** | **0.089186** | **102.5%** | 163 |
| V2 platform | 5 | 0.098801 | 95.2% | 0.087428 | 100.5% | 166 |
| gt3d descriptor swap | 2 (killed) | 0.091397 | 87.5% | - | - | 34+34 (best/seed) |

N03b per-seed: 88.7% / 97.2% / **106.0% (outright win)** / 95.6% /
97.7% — 1W/4L on HV; coverage mixed (one net design below classic,
not systematic).

## What the probe answered (the user's question)

1. **Do QD variants matter at suite scale despite screen kills?**
   Yes, measurably — but on different axes than HV. N03b overtakes V2
   at suite scale (96.9% vs 95.2% HV; 102.5% vs 100.5% AUC), inverting
   their screen-scale order — a second demonstration of the transfer
   gap, now BETWEEN QD variants, not just QD-vs-classic. gt3d moved
   coverage (34 designs per seed, best of any arm) while losing HV.
2. **Does any variant clear the +5% contract gate at suite scale?**
   No. The QD family sits at HV parity (95-97%) with AUC advantages
   (100.5-102.5%) and axis-specific trades: V2 buys coverage, N03b
   buys AUC and front material, gt3d buys per-seed coverage breadth.
3. **Suite-scale QD family finding (for the paper):** archive-based
   selection reallocates a few HV points into anytime performance
   (HV-AUC), functionality coverage, or front breadth depending on the
   mechanism knob — a controllable trade surface, not a free win, at
   the scale where LLM capability binds.

## Consequences

- Promotion arm remains V2 by the registered rule sequence; N03b's
  suite AUC lead makes it the co-headline QD arm for the
  characterization and the primary archive for the Branch-B
  utility-metric analysis (P4, no new runs needed).
- P3b-C (compact_8d + CVT) stays unlaunched: two suite probes landed
  below classic on HV, and its contingency condition (a suite-scale
  signal from A or B beating V2's read... N03b did beat V2) — ruling:
  the condition is met in letter by N03b, but N03b is a MECHANISM arm,
  not a descriptor arm; the descriptor evidence (gt3d kill +
  coverage-only movement) does not justify a two-arm CVT spend.
  Recorded as a scoped-out decision; revisitable with the N04/wave-2
  backlog.
