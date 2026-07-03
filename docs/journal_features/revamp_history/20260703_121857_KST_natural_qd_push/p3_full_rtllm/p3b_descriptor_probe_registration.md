# P3b Full-Suite Variant Probe — Registration (2026-07-04, user-directed)

## Versioned amendment to the screening ladder (recorded before results)

New evidence from P3: the screen -> full-suite transfer gap is large
and measured (V2: +12.9% at screen scale, 95.2% at full suite — an
~18-point swing). The user's directive: screen-based elimination has
limited validity for full-suite outcomes, so near-band variants get a
direct full-suite test. Amendment scope:

- Screen kills REMAIN valid for coverage-loss and mechanism-inert
  verdicts and for deep losers (the random floor at -22.6% is not a
  full-suite candidate).
- Screen arms within the near band (roughly >= 85% of V2 on screen HV,
  coverage kept) are eligible for full-suite probes when budget
  allows, notwithstanding a screen loss.
- The transfer-gap itself is a first-class finding for the journal's
  methodology discussion (small-subset screening validity).

## Arms (single change vs the P3 V2 command each)

- **P3b-A `graph_testability_3d`**: descriptor swap only
  (`--qd_descriptor_profile journal_graph_testability_3d`). Rationale:
  best screen challenger (-12.6% vs V2, beat the random floor on both
  metrics); collapse-resistant exactly where the trio degenerates
  (small control logic), and the full suite is rich in such designs;
  theory-grounded (SCOAP/reconvergence/cyclomatic).
- **P3b-B `front_slot_lane_030` (N03b)**: the registered two-factor
  exception arm (elite_pareto_slot(2) + lane 0.30). Rationale: screen
  3-seed V2-tie with MORE front points on every seed — the Branch-B
  utility candidate; full-suite behavior unknown.
- P3b-C `theory_grounded_compact_8d` + CVT (+ trio-CVT paired
  control): CONTINGENT — registered but launched only if A or B shows
  a full-suite signal (its CVT pairing doubles comparison cost).

## Ladder and gates (registered)

1. Per arm: seeds 1001+1002 as a co-scheduled pair (~2 h). Kill after
   the pair only if 2-seed mean HV < 0.90 x the classic 2-seed mean
   (0.104479) OR coverage falls below classic on BOTH seeds.
2. Survivors complete seeds 1003-1005 (pair + single). Decision read =
   5-seed mean HV / canonical HV-AUC / coverage vs BOTH the classic
   5-seed baselines (0.103802/0.086982; recompute-verified) and the V2
   full-suite reference (0.098801/0.087428).
3. Full standard packaging per seed (pareto, ppa, canonical HV-AUC,
   operator audit, config-pinned validation). Interim contract-form
   log-ratio stats at 5 seeds; canonical statistics with the P4 batch.
4. No verdict language from partial ladders; jackpot decomposition
   reported per seed (edge_detect-class outliers named).

## Comparators

All reused: classic 5-seed roots (zero new classic spend), V2's own
five P3 seeds (the platform reference now exists at full scale).
