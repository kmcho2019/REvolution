# T84 Results

Status: completed diagnostic; not promoted.

T84 tested whether a bounded `front_slot_lane_nsga2` parent lane could repair
T83's Pareto-breadth loss while preserving the RF leaf-ID delayed-activation
signal.

It did not. On the frozen eight-design screen, T84 reached mean HV `0.1162`
versus classic `0.1406` and T83 `0.1369`. It also lost Pareto points,
reference-beating candidates, and every HV win comparison against classic.

Decision: retire exact T84. Keep T83 as the best current representative of the
pretrained MasterRTL RF timing model-state lane, while treating both T83 and
T84 as diagnostic rather than spend-ready.

Detailed tables, validation logs, and the inspected summary figure are in
`../../preliminary_planning/20260626_rf_leafid_front_slot_delayed_probe/`.
