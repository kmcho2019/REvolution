# PCN Memory Mechanism Summary

This note checks whether the corrected PCN arm actually used its
guarded QD-memory lane during the full RTLLM run.

## Aggregate Counters

- Problems with archive histories: 50
- Active memory generations: 100
- Memory-refine candidates generated: 86
- Memory-refine valid-PPA candidates: 62 (72.1%)
- Memory-refine local-front additions: 9
- Memory-refine global-front additions: 5

## Interpretation

The PCN arm was not passive: the memory-refine lane fired on the
full suite and produced valid-PPA children plus front insertions.
This supports interpreting the small HV/HV-AUC gain as a real
front-guarded memory signal rather than a logging artifact.

The mechanism is still modest: only a small fraction of candidates
came from memory, and the result is one seed. Treat this as a
promotion signal for multi-seed/deeper PCN tests, not as final proof.

## Artifacts

- `analysis/full/pcn_memory_mechanism_summary.csv`
- `figures/full/pcn_memory_front_contributions.png`
