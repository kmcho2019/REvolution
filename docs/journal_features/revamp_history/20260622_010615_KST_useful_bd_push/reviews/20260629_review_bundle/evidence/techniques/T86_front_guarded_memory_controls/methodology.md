# T86 Methodology

T86 keeps FG-QDM fixed and changes only the descriptor control.

## Stage A: Random-Memory Control

Use the same front-guarded scheduler as T85:

- `qd_scheduler_mode=front_guarded_memory`
- `qd_parent_selection=front_guarded_memory`
- `qd_memory_classic_fraction=0.80`
- `qd_memory_refine_fraction=0.15`
- `qd_memory_rescue_fraction=0.05`
- `qd_memory_probe_fraction=0.00`
- `qd_two_parent_probability=0.00`
- `qd_grid_quantile_warmup_successes=4`

The descriptor is the existing `random_hash_3d` profile from the prior random
descriptor control package. It is random-looking but deterministic from
canonical synthesized-netlist content. It must not use PPA, reference PPA,
fitness, test pass rate, hypervolume, Pareto rank, problem identity, or final
outcome.

## Stage B: Verified-Descriptor Swap

Run this only if Stage A shows SR memory is better than random memory or if the
random control exposes an interpretable failure mode. Candidate swaps:

- RF leaf-ID structural axes from T83;
- DeepGate transition-AIG embedding axes after coverage is sufficient;
- source-aligned structural mix axes from T80.

## Decision Gate

Random-memory FG-QDM is not expected to beat classic. Its job is to determine
whether the FG-QDM scheduler is selecting useful cells because of descriptor
meaning or because of generic memory retention.

Advance only if:

- every classic-covered smoke design remains covered;
- random memory is not better than SR memory on mean HV and front material;
- memory-lane contribution is visible in archive history;
- generated figures and tables are packaged before any larger screen.
