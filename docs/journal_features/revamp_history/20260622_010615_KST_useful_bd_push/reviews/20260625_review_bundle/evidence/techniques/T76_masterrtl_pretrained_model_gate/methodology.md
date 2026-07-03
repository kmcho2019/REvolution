# T76 Methodology

## Purpose

T76 verifies the model-artifact side of the MasterRTL/RTL-Timer descriptor
discussion before spending another live vLLM budget. The question is narrow:
can we load upstream pretrained assets with asserted feature schemas, and are
those assets suitable enough to justify a future learned tree-region BD?

## Inputs

| Source | Commit |
| --- | --- |
| MasterRTL | `5bccf38f8db7bb511a793a709863e7cb1b333ab5` |
| RTL-Timer | `206ff4078368c251d2fafaffcc648282c68316f1` |

The verification uses the existing isolated environment
`exp/venvs/rtl_native_verify/` because the main repo environment does not carry
`xgboost` or `scikit-learn`.

## Checks

1. Hash the MasterRTL saved model files.
2. Load the four XGBoost heads using the upstream MasterRTL inference
   preprocessor:
   `Area`, `Power`, `WNS`, and `TNS`.
3. Assert each XGBoost feature vector length equals the loaded model's
   `n_features_in_`.
4. Record predictions and tree leaf IDs for the shipped TinyRocket example.
5. Try the MasterRTL RF timing model through both `pickle` and `joblib`;
   record the failed loader and the successful loader separately.
6. Inventory RTL-Timer model directories and example feature/label artifacts.

## Planned Follow-Up

If this lane advances, the next method should not use scalar predicted PPA as
the descriptor. The cleaner BD is a tree-region descriptor:

- XGBoost or RF leaf IDs;
- per-head leaf clusters or hashed leaf buckets;
- a raw source-aligned RTL structural axis, such as branching or DFF density.

That keeps the descriptor close to learned RTL implementation regions without
turning the archive cell into a hidden final-PPA proxy.
