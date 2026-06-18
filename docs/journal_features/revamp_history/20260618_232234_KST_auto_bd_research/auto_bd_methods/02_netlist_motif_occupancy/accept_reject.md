# Netlist Motif Occupancy Decision

Decision: promote to seed-3 screening candidate; reject as the final
Auto-BD method for now.

## Evidence

- Seed-1 development Gate 0: pass
- Covered problems: 6
- Missing problems: 0
- Gate 0 delta versus original REvolution: none
- Report: `seed1_preliminary_report.md`
- Coverage artifact: `../../auto_bd_gate0_coverage_seed1_netlist_motif_occupancy.json`

## Rationale

The descriptor is simple, CAD-native, available at candidate insertion
time, and now passes the first hard coverage gate. It is a credible first
Auto-BD candidate because it separates logic, control, arithmetic, and
cell-diversity behavior without fitting learned state.

It is not yet acceptable as the selected method. The seed-1 result only
proves that the descriptor does not regress valid-PPA coverage on the
development subset. The method still needs evidence that motif occupancy
adds useful search pressure beyond random descriptors and Yosys-stat
controls.

## Next Use

Run seed-3 screening if compute permits. Compare against classic
REvolution, landing Smooth-QD manual-BD, random descriptor QD, and
Yosys-stat BD using Gate 0, PPA/hypervolume, common-audit QD, and
structural diversity metrics.
