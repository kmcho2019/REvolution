# T76 Results Report

## Tier Decision

`T0 verification_gate_partial`.

T76 confirms that MasterRTL saved model artifacts exist and can be loaded, but
it does not yet validate a live pretrained-model BD.

## Findings

| Check | Result | Interpretation |
| --- | --- | --- |
| XGBoost Area/Power/WNS/TNS load | pass | The four MasterRTL heads deserialize in the isolated env. |
| XGBoost feature schema | pass | Feature lengths match model expectations: `14`, `17`, `16`, and `16`. |
| XGBoost TinyRocket prediction | all `0.0` | The shipped one-design example is not enough to prove useful output variation. |
| XGBoost leaf IDs | one unique leaf per head | Tree-leaf BD needs generated-candidate variation before promotion. |
| RF timing model with `pickle` | fail | Plain pickle reports `UnpicklingError`; do not use that loader. |
| RF timing model with `joblib` | pass | The RF model loads with 8 input features, 50 trees, and nonconstant leaf IDs. |
| RTL-Timer pretrained checkpoint | not confirmed | Local tree has scripts and TinyRocket feature/label artifacts, not confirmed weights. |

## Quantitative Summary

MasterRTL XGBoost heads:

- loaded model rows: `4`;
- TinyRocket feature shapes: `1x14`, `1x17`, `1x16`, `1x16`;
- prediction mean/std: `0.0 / 0.0` for every head;
- leaf shape: `1x25`;
- unique leaf IDs: `1` for every head.

MasterRTL RF timing model:

- loader: `joblib`;
- feature shape: `128x8` sampled from `feat_all_lst.pkl`;
- prediction mean/std: `1.436055563483162 / 0.02167329100630154`;
- prediction min/max: `1.3550624058823528 / 1.4834888570979046`;
- leaf shape: `128x50`;
- unique leaf IDs: `741`.

## Decision

Advance only the verified sub-claim:

> MasterRTL pretrained tree artifacts can be loaded and inspected in an
> isolated environment, and the RF model provides nonconstant tree-region
> structure on saved features.

Do not yet claim:

> We use pretrained MasterRTL/RTL-Timer models as validated live RTL BDs.

The next live candidate should first run the model loader over generated RTL
candidate features and prove that the candidate distribution has nonconstant
leaf/margin structure without using final PPA or reference labels as archive
coordinates.
