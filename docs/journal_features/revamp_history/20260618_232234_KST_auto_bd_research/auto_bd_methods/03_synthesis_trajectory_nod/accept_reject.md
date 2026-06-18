# Synthesis-Trajectory NOD Decision

Decision: promote to seed-3 screening candidate; reject as the final
Auto-BD method for now.

## Evidence

- Seed-1 development Gate 0: pass
- Covered problems: 6
- Missing problems: 0
- Gate 0 delta versus original REvolution: none
- Report: `seed1_preliminary_report.md`
- Coverage artifact:
  `../../auto_bd_gate0_coverage_seed1_synthesis_trajectory_nod.json`
- Fix commit: `ac0e5d3a4c`

## Rationale

The descriptor is CAD-native, available at candidate insertion time after
normal synthesis/PPA success, and now passes the first hard coverage
gate. It also has a stronger hardware rationale than final aggregate
Yosys-stat axes because it describes how candidates transform through
synthesis stages.

It is not yet acceptable as the selected method. The seed-1 result only
proves that the descriptor does not regress valid-PPA coverage on the
development subset and that its initial runtime is acceptable. The method
still needs evidence that synthesis trajectories add useful search
pressure beyond motif-only, random-descriptor, Yosys-stat, manual-BD,
and classic REvolution baselines.

## Next Use

Run seed-3 screening if compute permits. Compare against classic
REvolution, landing Smooth-QD manual-BD, random descriptor QD,
Yosys-stat BD, and motif occupancy using Gate 0, PPA/hypervolume,
common-audit QD, and structural diversity metrics.
