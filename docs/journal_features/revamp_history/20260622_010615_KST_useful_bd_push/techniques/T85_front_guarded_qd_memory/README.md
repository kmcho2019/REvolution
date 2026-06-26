# T85 Front-Guarded QD-Memory

T85 implements FG-QDM: Front-Guarded QD-Memory REvolution. It keeps
classic REvolution-style exploitation as the primary search path and uses a
small descriptor-indexed archive only as guarded memory.

This is a search-policy test, not a new descriptor test. The first run uses
the same SR raw PCA descriptor family as T26 so the comparison isolates
whether auxiliary QD memory can help without paying the old archive-fill tax.

## Status

Pre-registered and implemented. Stage 0 unit/type/lint checks pass. Live smoke
is pending.

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
- Preliminary planning: `../../preliminary_planning/20260626_front_guarded_qd_memory_probe/`
