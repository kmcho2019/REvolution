# Descriptor Health Report

- archive_type: `grid_quantile`
- descriptor_profile: `source_aligned_rf_timing_state_3d`
- descriptor_axes: `source_aligned_rf_timing_leaf_rows, source_aligned_rf_timing_path_count, source_aligned_masterrtl_branching`
- observation_count: `8`
- archive_entry_count: `8`
- collapsed_axes: `none`

## Live Decision Counts

- `warmup_buffered`: 8

## Grid-Quantile Initialization

- initialization_mode: `warmup_complete`
- initialized: `True`
- warmup_successes: `8`
- warmup_buffer_size: `0`
- initialization_sample_count: `8`
- effective_shape: `4x4x4`
- active_effective_axes: `3`
- collapsed_axes: `none`

### Warmup Replay Decision Counts

- `filled_empty`: 7
- `pareto_inserted`: 1

## Axis Health

### source_aligned_rf_timing_leaf_rows

- collapsed_in_archive: `False`
- observations: count=8, unique=6, nonzero_fraction=0.6250, mean=1.4872, stddev=1.2894
- archive_elites: count=8, unique=6, nonzero_fraction=0.6250, mean=1.4872, stddev=1.2894

### source_aligned_rf_timing_path_count

- collapsed_in_archive: `False`
- observations: count=8, unique=6, nonzero_fraction=0.6250, mean=2.1343, stddev=1.9918
- archive_elites: count=8, unique=6, nonzero_fraction=0.6250, mean=2.1343, stddev=1.9918

### source_aligned_masterrtl_branching

- collapsed_in_archive: `False`
- observations: count=8, unique=8, nonzero_fraction=1.0000, mean=2.6926, stddev=0.3216
- archive_elites: count=8, unique=8, nonzero_fraction=1.0000, mean=2.6926, stddev=0.3216
