# T87 Front-Guarded RTL-Native Memory

T87 keeps the FG-QDM scheduler from T85/T86 and swaps the descriptor to the
registered source-aligned RTL shape-density profile.

Status: completed smoke; negative; not promoted.

## Purpose

T85 showed that exact `sr_pca_3d` FG-QDM trails classic. T86 showed that
random-memory FG-QDM slightly beats SR-memory FG-QDM on the three-problem
smoke, so exact SR memory is not descriptor-positive. T87 tests the next
clean continuation: keep the memory policy fixed, but use RTL-native
MasterRTL/RTLTimer-derived descriptor axes that are already registered and
leakage-free.

## Evidence Package

- [methodology.md](methodology.md)
- [commands/run_t87_front_guarded_rtl_native_memory.md](commands/run_t87_front_guarded_rtl_native_memory.md)
- [artifacts_manifest.md](artifacts_manifest.md)
- [results_report.md](results_report.md)
- [tables/](tables/)
- [figures/](figures/)
- [analysis/](analysis/)

## Descriptor Profile

Use `source_aligned_shape_density_3d` from
`data/configs/qd_descriptor_profiles.yaml`.

Axes:

- `source_aligned_masterrtl_branching`
- `source_aligned_rtltimer_wire_density`
- `source_aligned_rtltimer_dff_density`

These axes require source-aligned RTL extraction, but do not use PPA,
reference PPA, test pass rate, hypervolume, Pareto rank, problem identity, or
final outcome.

## Promotion Rule

T87 advances only if it is materially better than both SR-memory and
random-memory FG-QDM on the matched three-problem smoke, while preserving every
classic-covered design. If it does not, keep it as a negative RTL-native
FG-QDM descriptor coupling result and move the shortlist toward a different
encoder/config family.

## Result

T87 completed the matched three-problem smoke. It trails classic, SR-memory,
and random-memory FG-QDM on mean HV. It is the strongest FG-QDM arm on
`Prob045_alu`, but the memory-refine and front-rescue lanes produce zero
valid-PPA children across the smoke, so the mechanism claim does not hold.
