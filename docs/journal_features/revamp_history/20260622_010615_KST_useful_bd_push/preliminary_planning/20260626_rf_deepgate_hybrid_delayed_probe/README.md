# T96 RF DeepGate Hybrid Delayed Probe

This package pre-registers a cross-domain pretrained descriptor test.

## Question

Can a compact hybrid of validated MasterRTL RF timing model-state and official
DeepGate pooled netlist embeddings recover front material better than either
encoder family alone?

## Rationale

T83 was the closest single-seed pretrained/model-state QD arm, but replication
blocked promotion. T95 improved over T94, which suggests DeepGate can help when
archive pressure is less disruptive, but DeepGate alone still trails classic
badly on front breadth.

T96 keeps T83's delayed high-exploit archive coupling and changes only the
descriptor:

- `source_aligned_rf_timing_leaf_ids`: validated MasterRTL RF timing
  model-state signal;
- `source_aligned_masterrtl_branching`: RTL-native structural family axis;
- `deepgate_pool_pc0`: official DeepGate pooled netlist embedding axis.

The descriptor remains PPA-free. PPA is used only for normal selection,
retention, and offline reporting.

## Promotion Gate

T96 is not promoted unless it:

1. preserves all eight reference-complete preliminary problems;
2. avoids missing-reference or missing-candidate loopholes;
3. beats or comes within a small tolerance of classic mean HV; or
4. improves front breadth or reference-beating count enough to justify a
   clearly pre-registered follow-up.

## Evidence

- Pre-registration:
  [preregistration.md](preregistration.md)
- Descriptor config:
  [tables/rf_deepgate_hybrid_descriptor_profiles.yaml](tables/rf_deepgate_hybrid_descriptor_profiles.yaml)
- Run command:
  [commands/run_rf_deepgate_hybrid_delayed_probe.md](commands/run_rf_deepgate_hybrid_delayed_probe.md)
- Validation log:
  [logs/validation_log.md](logs/validation_log.md)

## Status

Pre-registered. Live run not started in this package yet.
