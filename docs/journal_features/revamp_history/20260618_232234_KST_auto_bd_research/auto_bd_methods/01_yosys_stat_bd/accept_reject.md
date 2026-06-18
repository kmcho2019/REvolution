# Yosys-Stat BD Control Decision

Decision: retain as a strong simple control; reject as the selected final
Auto-BD method for now.

## Evidence

- Seed-1 development Gate 0: pass
- Covered problems: 6
- Missing problems: 0
- Gate 0 delta versus original REvolution: none
- Report: `seed1_preliminary_report.md`
- Coverage artifact: `../../auto_bd_gate0_coverage_seed1_simple_yosys_stat_bd.json`

## Rationale

The method is useful because it tests whether simple synthesized-netlist
statistics explain most of the benefit expected from automatic BDs. It is
not yet acceptable as the final method because the descriptor may collapse
into size and coarse cell composition, and it does not capture pathlets,
motifs, or synthesis response.

## Next Use

Keep this control in later comparisons. A motif/ST-NOD method should
produce a clearer gain than this simple control under common-audit QD,
PPA, diversity, and interpretability metrics.
