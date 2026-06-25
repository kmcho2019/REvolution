# Qwen Live-Screen Candidate Probe

## Verdict

Qwen3 canonical RTL is model-valid and nonconstant on this generated-candidate corpus,
but nearest-neighbor structure is still highly same-problem. This supports a small
live-hook screen, not a full RTLLM spend.

## Summary

![Qwen probe](figures/qwen_live_screen_probe.png)

- candidate rows: `540`
- unique canonical RTL hashes: `424`
- embedding shape: `[540, 1024]`
- off-diagonal cosine mean: `0.791654`
- nearest same-problem fraction: `0.992593`
- nearest same-backend fraction: `0.531481`
- nearest duplicate-canonical fraction: `0.266667`
- embedding output root: `exp/useful_bd_push/qwen_live_screen_probe_20260625_164500_UTC`

## Decision

Implement a live Qwen hook only with descriptor-health reporting. The first screen
must check same-problem clustering and duplicate-canonical collapse before any
promotion decision.
