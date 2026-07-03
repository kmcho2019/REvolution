# T99 Methodology

T99 is the AURORA-style raw implementation-feature representative for the
useful-BD negative map. It does not claim a pretrained encoder or compressed
autoencoder result. It tests whether raw implementation features, which were
promising in the T13 replay lane, survive as live QD archive coordinates.

## Descriptor

Profile: `implemented_structural_compact_3d`

Axes:

- `comb_ratio`
- `adder_ratio`
- `cell_count_log`

The axes are implementation-structure descriptors. They must not use final
PPA, reference PPA, hypervolume, Pareto rank, pass rate, or problem identity.

## Search Policy

T99 uses the delayed high-exploit archive-coupling substrate from the recent
preliminary screens. The intent is to avoid early archive-fill tax while still
testing whether raw implementation structure can preserve useful PPA-front
families.

The complete pre-registration and command record are in:

```text
../../preliminary_planning/20260626_aurora_raw_impl_delayed_probe/
```
