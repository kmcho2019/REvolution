# T85 Front-Guarded QD-Memory

T85 implements FG-QDM: Front-Guarded QD-Memory REvolution. It keeps
classic REvolution-style exploitation as the primary search path and uses a
small descriptor-indexed archive only as guarded memory.

This is a search-policy test, not a new descriptor test. The first run uses
the same SR raw PCA descriptor family as T26 so the comparison isolates
whether auxiliary QD memory can help without paying the old archive-fill tax.

## Status

Pre-registered and implemented. Stage 0 unit/type/lint checks pass. Two
three-problem live smokes completed.

The warmup-4 rerun fixes the first smoke's `Prob015_multi_pipe_8bit` coverage
failure, but it is a negative promotion result: classic wins three-problem
mean HV `0.1903` to `0.1375`. Classic wins `2/3` per-problem HV comparisons
and ties `Prob015_multi_pipe_8bit` at zero HV for both arms. Do not promote
exact `sr_pca_3d` FG-QDM to the frozen eight-design screen.

## Key Contract

- Scheduler: `front_guarded_memory`
- Parent selection: `front_guarded_memory`
- Primary optimizer: separate classic-style primary success pool
- Memory archive: passive insertion of valid-PPA candidates only
- Memory budget: 80% classic, 15% memory refine, 5% front rescue
- Two-parent fusion: disabled
- Probe lane: disabled
- Rebinning: disabled for this first implementation

## Evidence Package

- [methodology.md](methodology.md)
- [commands/run_t85_front_guarded_qd_memory.md](commands/run_t85_front_guarded_qd_memory.md)
- [artifacts_manifest.md](artifacts_manifest.md)
- [results_report.md](results_report.md)
- [figures/](figures/)
- [tables/](tables/)
- Preliminary planning: `../../preliminary_planning/20260626_front_guarded_qd_memory_probe/`
