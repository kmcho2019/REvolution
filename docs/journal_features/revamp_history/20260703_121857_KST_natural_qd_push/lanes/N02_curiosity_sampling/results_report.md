# N02 Curiosity Sampling — Result

Runs:

- N02a gamma 1.0:
  `exp/natural_qd_push/n02_curiosity_20260703_070921_UTC/`.
- N02b gamma 0.5:
  `exp/natural_qd_push/n02b_curiosity_20260707_120427_UTC/`.

Both operator contracts pass; both config-pinned validations pass
(natural mode + gamma pinned).

## Read (frozen 8-design 8x5, seed 1001)

| Arm | Mean HV | vs classic | vs V2 | HV-AUC (8-problem) | Coverage |
| --- | --- | --- | --- | --- | --- |
| V2 (ref) | 0.17376 | +23.5% | - | 0.14366 | 8/8 |
| N02a curiosity gamma 1.0 | 0.15449 | +9.8% | -11.1% | 0.12919 | **7/8** |

HV-AUC normalization note: `report_hv_auc.py` emits rows only for
problems with candidates; the 8-problem mean above zero-fills the
missing design (0.147645 x 7/8 = 0.129189), matching the suite
convention.

## Verdict: HARD-GATE FAIL (coverage loss)

N02a lost `Prob153_gshare` entirely (0 valid-PPA candidates) — a
design classic covers. Per the plan's hard gate, coverage loss is a
kill regardless of HV. Diagnosis (cause class: exploration-tax):
gshare is the largest, hardest sequential design on the screen (1460
reference gates); inverse-occupancy weighting pulls parent draws away
from the narrow quality basin exactly where concentrated exploitation
is needed to produce any valid-PPA candidate at all.

## Status and registered follow-up

Per the card's registered rule, gamma 0.5 (N02b) got ONE retry because
N02a showed the anticipated exploration-tax signature.

Figure inspection (2026-07-05, validation-v2 obs 6): package
pairwise-front PNGs reviewed; the gshare panel shows no valid V2
points, matching the coverage-loss kill. Cause class (obs 4):
exploration-tax (already assigned above).

## N02b read (gamma 0.5; 2026-07-07)

| Arm | Mean HV | vs classic | vs V2 | HV-AUC | Valid-PPA coverage |
| --- | --- | --- | --- | --- | --- |
| classic (ref) | 0.14064 | - | -19.1% | 0.12387 | 8/8 |
| V2 (ref) | 0.17376 | +23.5% | - | 0.14366 | 8/8 |
| N02b curiosity gamma 0.5 | 0.12864 | -8.5% | -26.0% | 0.11454 | 8/8 |

Gamma 0.5 fixes the hard coverage failure: `Prob153_gshare` now has
19 valid-PPA candidates, and the full screen validates with 768 LLM API
calls. It still fails the registered retry rule because it does not
approach V2 and is also below classic on both mean HV and HV-AUC.
Problem-level final-HV W/L/T is 1/4/3 vs V2 (only
`Prob049_signal_generator` wins) and 0/5/3 vs classic.

## Verdict: RETIRE

N02 is a clean mechanism negative. Curiosity weighting can recover
coverage when softened, but the softened version mostly spends parent
draws away from the concentrated quality basins that drive the V2
screen win. No further gamma scan is allowed without a new mechanism
card and a new diagnosis. The self-contained engine remains useful as
a tested negative-control implementation; it should not headline the
TCAD extension.
