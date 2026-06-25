# Pretrained Encoder Validation Gate

## Current Status

The completed live screen did not use pretrained encoder weights. It compared:

- classic REvolution;
- a synthesis-response custom-BD QD arm;
- a raw source-aligned MasterRTL structural-mix QD arm.

This was deliberate. The current pretrained/encoder-like lanes are not ready
for full live budget because the model path or descriptor behavior is not yet
credible enough.

## Why No Pretrained Arm Was Launched

| Lane | Current Evidence | Blocker |
| --- | --- | --- |
| Qwen3 canonical RTL | Best actual pretrained replay signal from T33. | No generation-time descriptor hook, cache contract, or live collapse test. |
| DeepGate3 | Checkpoints exist and prior probe loaded a model. | Prior generated embeddings were near-constant, so it is not a valid BD yet. |
| MasterRTL pretrained heads | Saved model artifacts exist. | Direct Area-head leaf path collapsed on generated candidates; current live arm uses raw structural metrics only. |
| AURORA-style | Raw implementation features had replay signal. | Not pretrained, and compressed bottlenecks lost replay quality. |
| T11/T36 graph lane | Strong replay signal. | Exact live T58 conversion lost HV/front breadth. |

## Required Before A Pretrained Encoder Live Arm

A pretrained-weight configuration must pass all checks below before it can
enter an expensive live screen:

1. Pin the upstream model source, checkpoint path, and commit.
2. Hash the checkpoint files and record the hashes in the package.
3. Run the upstream inference path on its shipped example or known fixture.
4. Run our loader on the same fixture and match upstream outputs within a
   documented tolerance.
5. Record the exact preprocessing used for RTL or synthesized netlist text.
6. Prove generated-candidate embeddings are nonconstant and not only
   problem-ID clusters.
7. Show that descriptor axes or archive cells are derived from the validated
   embedding/model state, not from an unverified surrogate.

## Decision

Do not claim that a live QD arm uses a pretrained encoder unless the checks
above pass. Until then, Qwen3, DeepGate3, MasterRTL pretrained-head, AURORA,
and T11/T36 results should be described as replay, bridge, or encoder-like
evidence rather than validated pretrained-encoder live results.
