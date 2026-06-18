# Random Descriptor Control Decision

Decision: retain as a required negative control; reject as a final
Auto-BD method candidate.

## Evidence

- Seed-1 development Gate 0: pass
- Covered problems: 6
- Missing problems: 0
- Gate 0 delta versus original REvolution: none
- Report: `seed1_preliminary_report.md`
- Coverage artifact: `../../auto_bd_gate0_coverage_seed1_random_descriptor_qd.json`

## Rationale

The method is useful because it checks whether archive partitioning alone
can explain an apparent Auto-BD gain. It is not acceptable as the final
journal method because its cells are intentionally meaningless and cannot
support a hardware-native descriptor rationale.

## Next Use

Keep this control in seed-3 and final selected-method comparisons when
compute permits. If a proposed descriptor does not clearly beat this
control under common-audit QD, PPA, and diversity metrics, reject the
proposed descriptor or narrow its claim.
