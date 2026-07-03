# P3 Seed-1001 Read (NOT a verdict; ladder continues by registration)

V2 vs the reused classic seed-1001 full-suite root, 46 ref-complete
designs, all audits green (both arms 0 single-thought, 0 other;
config-pinned validation pass; runtime 4619 s at 48/12/4).

| Metric | classic (this root) | V2 | delta |
| --- | --- | --- | --- |
| mean HV | 0.11140 | 0.09677 | -13.1% |
| mean HV-AUC (46-norm) | 0.09055 | 0.08354 | -7.7% |
| coverage | 33/46 | 32/46 | -1 |
| per-problem W/L/T | - | 6/9/31 | - |

Decomposition: Prob036_edge_detect alone is ~80% of the HV gap
(classic 0.8947 vs V2 0.3559 — a classic jackpot draw); the coverage
miss is Prob039_serial2parallel (V2 zero valid-PPA at this seed).
Remaining deltas are small and two-sided.

Context on comparator variance: this classic root recomputes to
0.11140 while the 20260630 classic seed-1001 run of the same config
scored 0.0997 — full-suite single-seed spread across identical
configs exceeds the deltas being judged. The registered ladder
therefore proceeds to seeds 1002-1005 regardless of this read
(launched as a co-scheduled pair); the 5-seed mean vs the pinned
classic 5-seed baselines (0.10380/0.08680) is the decision surface,
with the frozen-contract statistics after that.
