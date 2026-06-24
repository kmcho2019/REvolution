# T80 Results Report

## Tier Decision

`T0_descriptor_gate_positive_not_live`.

## Summary

T80 validates that the raw MasterRTL structural-mix axes are non-collapsed on
the source-verified T70/T77 generated-candidate corpus. It does not validate
PPA improvement and must not be promoted as a QD result.

| Metric | Value |
| --- | ---: |
| Candidate rows | `19` |
| Unique descriptor rows | `17` |
| Static occupied cells | `4` |
| Quantile occupied cells | `15` |
| Static occupancy entropy | `1.7990` bits |
| Quantile occupancy entropy | `3.7871` bits |
| T77 pretrained Area leaf rows | `1` |

## Interpretation

The structural axes preserve useful variation that the pretrained Area head
discarded. Static `[0, 1]` bins are too coarse because the sequential fraction
is naturally concentrated near the lower part of the range, leaving only four
occupied cells. Quantile binning spreads the same candidates across fifteen
cells and is the only reasonable live archive geometry for this profile.

This is a good gate result for the RTL-native lane, but the tier stays `T0`
because no live classic-vs-QD PPA comparison has been run.

## Follow-Up

Define a live T81 candidate only if it keeps the method narrow:

- use `source_aligned_masterrtl_structural_mix_3d`;
- use `grid_quantile`, not static grid bounds;
- use the same matched subset/budget discipline as T79 or a pre-registered
  smaller smoke;
- compare against matched classic with HV, Pareto points, reference-beating
  candidates, valid-PPA yield, duplicate accounting, and archive coverage.

Retire this profile if the live run increases archive spread without improving
PPA-front material or preserving classic-covered designs.

## Checks

```text
uv run python docs/.../T80.../tools/run_t80_masterrtl_structural_mix_gate.py
uv run pytest tests/revolution/test_source_aligned_descriptor_evaluator.py
uv run ruff check src/revolution/source_aligned_descriptor_evaluator.py \
  src/revolution/qd/descriptors.py \
  tests/revolution/test_source_aligned_descriptor_evaluator.py \
  docs/.../T80.../tools/run_t80_masterrtl_structural_mix_gate.py
```
