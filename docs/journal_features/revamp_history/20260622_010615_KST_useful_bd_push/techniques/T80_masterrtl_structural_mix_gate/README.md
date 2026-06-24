# T80 MasterRTL Structural-Mix Gate

T80 tests whether raw MasterRTL structural features can provide a usable
PPA-free descriptor profile after T77 showed that the pretrained Area tree
head collapses.

## Result

`T0_descriptor_gate_positive_not_live`.

The raw structural-mix axes produce `17/19` unique descriptor rows and `15`
occupied quantile cells on the T70/T77 generated-candidate corpus, while the
retired T77 pretrained Area-head leaf path still has only one unique leaf row.
This is a descriptor-readiness signal, not a live QD result.

## Descriptor

Runtime profile:

```text
source_aligned_masterrtl_structural_mix_3d
```

Axes:

- `source_aligned_masterrtl_seq_fraction`
- `source_aligned_masterrtl_mux_fraction`
- `source_aligned_masterrtl_xor_fraction`

The axes are computed from the MasterRTL SOG node dictionary and do not use
final PPA, reference PPA, fitness, hypervolume, Pareto rank, or pass/fail
status.

## Files

| Path | Purpose |
| --- | --- |
| `methodology.md` | Method card and anti-gaming contract. |
| `commands/t80_structural_mix_gate_v0.md` | Reproduction command. |
| `tools/run_t80_masterrtl_structural_mix_gate.py` | Table and figure builder. |
| `tables/` | Generated descriptor and occupancy tables. |
| `figures/` | Generated visual checks. |
| `results_report.md` | Tier decision after running the gate. |
| `artifacts_manifest.md` | Paths, commands, and source evidence. |
