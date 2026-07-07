# Descriptor Health Report

- archive_type: `grid_quantile`
- descriptor_profile: `implemented_structural_compact_3d`
- descriptor_axes: `comb_ratio, adder_ratio, cell_count_log`
- observation_count: `196`
- archive_entry_count: `57`
- collapsed_axes: `none`

## Live Decision Counts

- `warmup_buffered`: 196

## Grid-Quantile Initialization

- initialization_mode: `warmup_complete`
- initialized: `True`
- warmup_successes: `196`
- warmup_buffer_size: `0`
- initialization_sample_count: `196`
- effective_shape: `3x4x4`
- active_effective_axes: `3`
- collapsed_axes: `none`

### Warmup Replay Decision Counts

- `crowding_evicted`: 139
- `filled_empty`: 14
- `pareto_inserted`: 43

## Axis Health

### comb_ratio

- collapsed_in_archive: `False`
- observations: count=196, unique=44, nonzero_fraction=1.0000, mean=0.9174, stddev=0.1020
- archive_elites: count=57, unique=24, nonzero_fraction=1.0000, mean=0.8808, stddev=0.1006

### adder_ratio

- collapsed_in_archive: `False`
- observations: count=196, unique=57, nonzero_fraction=0.5000, mean=0.0577, stddev=0.0671
- archive_elites: count=57, unique=22, nonzero_fraction=0.5439, mean=0.0649, stddev=0.0773

### cell_count_log

- collapsed_in_archive: `False`
- observations: count=196, unique=69, nonzero_fraction=1.0000, mean=4.0553, stddev=2.2301
- archive_elites: count=57, unique=31, nonzero_fraction=1.0000, mean=5.0214, stddev=2.1310
