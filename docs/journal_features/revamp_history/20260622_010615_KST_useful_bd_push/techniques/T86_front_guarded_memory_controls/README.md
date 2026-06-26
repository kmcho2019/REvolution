# T86 Front-Guarded Memory Controls

T86 is the next control lane after T85. It keeps the front-guarded memory
scheduler but asks whether descriptor-indexed memory is doing more than random
retention.

Status: pre-registered; not run.

## Purpose

T85 showed that exact `sr_pca_3d` FG-QDM is not spend-ready. Before swapping in
another descriptor, T86 tests a stricter control:

1. run random-memory FG-QDM under the same scheduler and smoke subset;
2. compare SR-memory FG-QDM against random-memory FG-QDM;
3. only if SR memory beats random memory, spend on a verified descriptor swap.

## Evidence Package

- [methodology.md](methodology.md)
- [commands/run_t86_front_guarded_memory_controls.md](commands/run_t86_front_guarded_memory_controls.md)
- [artifacts_manifest.md](artifacts_manifest.md)
