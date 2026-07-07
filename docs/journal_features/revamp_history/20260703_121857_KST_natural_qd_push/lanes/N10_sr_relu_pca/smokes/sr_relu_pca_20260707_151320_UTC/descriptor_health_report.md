# Descriptor Health Report

- archive_type: `grid_quantile`
- descriptor_profile: `sr_pca_3d`
- descriptor_axes: `sr_pca_0, sr_pca_1, sr_pca_2`
- observation_count: `8`
- archive_entry_count: `8`
- collapsed_axes: `none`

## Live Decision Counts

- `observed`: 8

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

- `filled_empty`: 8

## Axis Health

### sr_pca_0

- collapsed_in_archive: `False`
- observations: count=8, unique=8, nonzero_fraction=1.0000, mean=13.2760, stddev=2.9848
- archive_elites: count=8, unique=8, nonzero_fraction=1.0000, mean=13.2760, stddev=2.9848

### sr_pca_1

- collapsed_in_archive: `False`
- observations: count=8, unique=8, nonzero_fraction=1.0000, mean=-0.6929, stddev=2.1207
- archive_elites: count=8, unique=8, nonzero_fraction=1.0000, mean=-0.6929, stddev=2.1207

### sr_pca_2

- collapsed_in_archive: `False`
- observations: count=8, unique=8, nonzero_fraction=1.0000, mean=5.1910, stddev=2.8873
- archive_elites: count=8, unique=8, nonzero_fraction=1.0000, mean=5.1910, stddev=2.8873
