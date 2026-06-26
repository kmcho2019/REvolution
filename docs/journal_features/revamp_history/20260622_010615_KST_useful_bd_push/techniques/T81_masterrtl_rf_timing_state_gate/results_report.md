# T81 Results Report

## Tier Decision

`T0_model_state_gate_positive_not_live`.

T81 advances the MasterRTL pretrained lane beyond T77's Area-head collapse, but
it is not a live QD result and must not be described as a PPA improvement.

## Summary

| Metric | Value |
| --- | ---: |
| Generated RTL candidates | `19` |
| Evaluated candidates | `13` |
| Skipped candidates | `6` |
| Timing paths | `166` |
| Unique RF leaf rows | `53` |
| Unique RF leaf IDs | `414` |
| RF training feature rows | `20978` |
| Feature out-of-range fraction | `0.125` to `0.243` |

## Interpretation

This is the first MasterRTL pretrained model-state gate with noncollapsed
generated-candidate output. Unlike the pretrained Area head from T77, the RF
timing model produces distinct path-level predictions and tree-leaf states on
generated RTL.

The method is still constrained:

- it only evaluates candidates with timing split points;
- `Prob004_adder_8bit` and `Prob045_alu` candidates are skipped as
  `no_clock_split`;
- feature-range drift exists but is bounded enough for a follow-up probe;
- no live archive or PPA-front improvement has been measured.

## Decision

Advance to a preregistered runtime-hook design, not a full live screen yet.
The next step should define one narrow descriptor profile such as:

- RF timing leaf-state cluster plus raw MasterRTL branching; or
- RF timing prediction quantile plus path-count class plus structural
  sequential fraction.

The live profile must preserve the anti-gaming boundary and explicitly handle
no-clock candidates without broad fallback behavior. A live run is allowed only
after focused tests prove stable runtime extraction and noncollapse diagnostics.

## Visual Inspection

Inspected: `figures/t81_rf_timing_state_gate.png`.

The figure is readable and clearly shows coverage limits and noncollapsed leaf
rows. It is suitable for internal planning, though a later presentation figure
should shorten candidate labels.

## Checks

```text
PYTHONHASHSEED=0 uv run --with scikit-learn==1.3.0 --with numpy==1.26.4 \
  --with networkx --with joblib --with matplotlib \
  python docs/.../T81.../tools/run_t81_rf_timing_gate.py

uv run ruff check docs/.../T81.../tools/run_t81_rf_timing_gate.py
git diff --check
```
