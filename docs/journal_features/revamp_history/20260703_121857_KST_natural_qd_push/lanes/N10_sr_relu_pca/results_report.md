# N10 SR-ReLU PCA Results Report

Status: smoke-passed; live screen not yet run.

## Probe Result

The bounded extraction smoke completed on 2026-07-07 at
`smokes/sr_relu_pca_20260707_151320_UTC/`.

| Check | Result |
| --- | --- |
| Frozen profile resolves | pass (`sr_pca_0`, `sr_pca_1`, `sr_pca_2`) |
| PPA-free requirement | pass (`requires_ppa=false`) |
| Screen/training overlap | pass (`[]`) |
| ST-NOD extraction | pass on 8/8 existing V2 candidates |
| Descriptor health | pass: initialized `4x4x4`, 8 occupied cells |
| Collapsed axes | none |

This is not an HV or functionality result. It only clears the registered
gate for one seed-1001 V2-faithful live screen.

## Decision

N10 is eligible for a single seed-1001 screen. Escalation beyond that requires
beating V2 on both mean HV and HV-AUC with coverage retained and operator
audit `single_thought_count=0`.

Full-RTLLM use needs a new holdout-clean SR-ReLU artifact because the old T19
fitting corpus includes RTLLM problems.
