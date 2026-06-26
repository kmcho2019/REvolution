# FG-QDM Contribution Audit Results

Status: completed audit; no FG-QDM variant promoted.

## Definition

FG-QDM means front-guarded QD memory. It keeps classic REvolution's primary
success pool as the main optimizer, passively records valid-PPA candidates in a
descriptor archive, and spends a small lane budget on remembered archive
parents.

Memory-lane contribution means the `memory_refine` and `front_rescue` lanes
produce children that pass PPA and preferably add global or local PPA-front
material.

## Evidence

The three completed FG-QDM smokes cover:

| Arm | Descriptor | Mean HV | Memory calls | Memory valid PPA | Memory global adds | Read |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| `fg_qdm_sr_memory_warmup4_12x3` | `sr_pca_3d` | `0.137536` | `8` | `3` | `0` | Memory runs, but does not add global-front material. |
| `fg_qdm_random_memory_12x3` | `random_hash_3d` | `0.138162` | `8` | `5` | `2` | Control beats SR memory, so SR is not earning budget. |
| `fg_qdm_shape_density_memory_12x3` | `source_aligned_shape_density_3d` | `0.126367` | `6` | `0` | `0` | RTL-native memory descriptor does not produce valid-PPA memory children. |

Classic remains the smoke comparator at mean HV `0.190331`.

## Interpretation

The user-proposed FG-QDM philosophy has already been tested in a first form:
classic pressure remains dominant, the archive is auxiliary memory, empty-cell
fill is disabled, and memory budget is small. That part is not the blocker.

The blocker is that the memory lanes have not shown enough offspring-level
evidence. Exact SR memory loses the random-memory control, and the RTL-native
shape-density swap fails at the mechanism level before headline metrics matter.

## Decision

Do not spend the frozen eight-design screen or final RTLLM budget on exact
T85/T86/T87 FG-QDM. A continuation must change the memory-credit policy enough
to answer a different question.

The justified continuation was T97 front-credit FG-QDM:

- lower memory pressure;
- raise `qd_memory_min_cell_credit`;
- allow memory recall mainly from cells containing global-front members or
  repeatedly credited cells;
- require memory-lane valid-PPA and front-add rates to beat the random-memory
  control before any wider run.

T97 has now completed. It improves FG-QDM smoke mean HV to `0.153384`, above
T85/T86/T87, but classic remains ahead at `0.190331`. Its memory-refine lane
produces `3/7` valid-PPA children and `3` local-front additions, but no
memory-lane global-front additions. Keep T97 as the FG-QDM category
representative, not an eight-design or full-RTLLM candidate.
