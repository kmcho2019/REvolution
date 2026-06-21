# T25 Guarded SR Raw Pareto QD Results Report

Status: planned, not yet run.

Tier decision: `planned`.

## Planned Question

Can the SR raw descriptor keep its T24 ALU gain and multi-pipe front material
while a guarded schedule reduces the multi-pipe best-quality collapse and
traffic-light synthesis-validity drop?

## Required Comparators

The live result must compare against the completed T24 rows:

- classic REvolution;
- landing Smooth-QD/manual BD;
- random descriptor QD;
- unguarded SR raw Pareto QD.

## Required Result Tables

After execution, this report must include:

- generated, functional, synthesis-valid, and valid-PPA counts;
- best-score and valid-PPA deltas versus classic/manual/random/SR raw;
- archive members, global Pareto members, and max local front size;
- duplicate/canonical-netlist accounting if available;
- runtime and preflight metadata;
- explicit T0/T1/T2/T3 tier decision.

## Current Conclusion

No conclusion yet. The method card is pre-registered so the scheduler guard is
fixed before any T25 outcome is inspected.
