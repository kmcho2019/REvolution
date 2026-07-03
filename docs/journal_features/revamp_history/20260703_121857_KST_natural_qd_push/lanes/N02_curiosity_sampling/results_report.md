# N02 Curiosity Sampling — Seed-1001 Result (2026-07-03)

Runs: `exp/natural_qd_push/n02_curiosity_20260703_070921_UTC/` (gamma
1.0). Operator contract passes; config-pinned validation passes
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

Per the card's registered rule, gamma 0.5 (N02b) gets ONE retry —
the exploration-tax signature is precisely the case it was registered
for — at reduced priority behind the N03b promotion test. If N02b
also loses coverage or fails to approach V2, the lane retires with
this diagnosis. The engine itself (`src/revolution/qd_natural/`)
stays: it is contract-clean, tested, and the negative is a mechanism
result, not an implementation failure.
