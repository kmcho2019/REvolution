# T77 Results Report

## Tier Decision

`T0_variation_gate_negative`.

T77 does not advance the MasterRTL pretrained Area leaf embedding to a live BD.
The source-faithful Area features vary, but the pretrained Area head maps all
generated candidates to the same prediction and leaf row.

## Summary

| Metric | Value |
| --- | ---: |
| Generated RTL candidates | `19` |
| Unique Area feature rows | `17` |
| Unique pretrained Area predictions | `1` |
| Unique pretrained Area leaf rows | `1` |
| Unique leaf IDs | `1` |

## Interpretation

The negative result is informative. It separates two facts that would be easy
to blur:

1. MasterRTL `cal_oper` features do describe generated RTL differences.
2. The shipped pretrained Area XGBoost head does not expose those differences
   through predictions or leaf regions on this candidate set.

So the raw Area features may still be useful as interpretable RTL-native
features, but the pretrained Area tree model is not currently useful as an
embedding source.

## Head Status

| Head | Status | Reason |
| --- | --- | --- |
| Area | evaluated | Source-faithful 14-feature `cal_oper` path exists. |
| Power | blocked | Requires toggle-rate side data from synthesis/EDA flow. |
| WNS | blocked | Requires timing DAG and path-delay feature flow. |
| TNS | blocked | Requires timing DAG and path-delay feature flow. |

## Decision

Retire the direct pretrained Area-head leaf BD for now.

Reasonable follow-ups are:

- use raw MasterRTL Area features as transparent descriptors;
- retrain or calibrate a MasterRTL-style model on a generated-candidate corpus
  with non-PPA-leaking labels;
- pursue RTL-Timer or MasterRTL RF timing features only after reproducing the
  required timing DAG/path feature flow;
- move to the fixed-total-budget shape ablation if live budget structure is
  the more urgent uncertainty.
