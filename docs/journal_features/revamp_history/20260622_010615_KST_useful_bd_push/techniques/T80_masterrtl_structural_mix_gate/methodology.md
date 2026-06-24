# T80 Methodology

## Question

Can raw MasterRTL structural-mix features provide a live-ready behavior
descriptor after T77 showed that the pretrained Area-head prediction and leaf
rows collapse?

## Motivation

T77 found `17/19` unique source-faithful MasterRTL Area feature rows, but only
one pretrained Area prediction and one leaf row. That retires the direct
pretrained Area-head leaf descriptor, but it does not retire the raw
MasterRTL-derived structural signal.

T80 keeps only the structural subset that is safe for in-loop descriptor use:
operator mix and sequential load from the SOG node dictionary.

## Runtime Descriptor Profile

The profile added in `data/configs/qd_descriptor_profiles.yaml` is:

```yaml
source_aligned_masterrtl_structural_mix_3d:
  - source_aligned_masterrtl_seq_fraction
  - source_aligned_masterrtl_mux_fraction
  - source_aligned_masterrtl_xor_fraction
```

Axis definitions:

| Axis | Definition |
| --- | --- |
| `source_aligned_masterrtl_seq_fraction` | `dff_bits / (dff_bits + operator_count)` |
| `source_aligned_masterrtl_mux_fraction` | `mux_operator_count / operator_count` |
| `source_aligned_masterrtl_xor_fraction` | `xor_operator_count / operator_count` |

`operator_count` is the count of active MasterRTL SOG nodes whose type is
`Operator`, `UnaryOperator`, `Concat`, or `Repeat`.

## Anti-Gaming Rules

- No final PPA, reference PPA, fitness, hypervolume, Pareto rank, or test
  status is used to compute any T80 axis.
- The gate is not a live QD result and cannot promote a QD method by itself.
- A live successor must still preserve classic-covered valid-PPA problems and
  compare against matched classic with the common reporting surface.

## Gate

T80 advances only if the generated-candidate corpus shows:

- more than one unique descriptor row;
- more than one occupied descriptor cell under static or quantile binning;
- no dependence on the collapsed pretrained Area prediction or leaf rows;
- a clear follow-up live method with fixed budget, subset, and profile.
