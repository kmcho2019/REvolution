# T92 DeepGate Runtime Descriptor Gate Results

## Summary

T92 closes the implementation gap after T91. DeepGate pooled descriptors are
now available through the normal runtime descriptor path as
`deepgate_pool_pc0..2`.

This is not a live QD/HV result. It promotes the lane from replay-only to
bounded-live-smoke-ready.

## What Changed

- Added `src/revolution/deepgate_descriptor_evaluator.py`.
- Added `scripts/extract_deepgate_pooled_metrics.py`.
- Registered `deepgate_pool_pc0`, `deepgate_pool_pc1`, and
  `deepgate_pool_pc2` in the QD descriptor registry.
- Wired descriptor extraction through both `QDEngine` and
  `CandidateEvaluator`.
- Froze T91's pooled candidate embedding PCA in
  `tables/deepgate_pooled_projection.json`.
- Added `tables/deepgate_descriptor_profiles.yaml` with profile
  `deepgate_pooled_pc3`.

## Real Model Smoke

The isolated DeepGate environment was used directly:

```text
/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/bin/python
```

Smoke candidate:

```text
exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001/openai_gpt-oss-120b/RTLLM/Prob024_fsm/Gen1/Prob024_fsm_sample1_M-S/code.sv
```

| Metric | Value |
| --- | ---: |
| `deepgate_pool_pc0` | `0.1690518098` |
| `deepgate_pool_pc1` | `0.0919195418` |
| `deepgate_pool_pc2` | `-0.0000848739` |
| AIG variables | `61` |
| AIG ANDs | `50` |
| Source | `full_transition` |
| Embedding seconds | `0.042885` |

## Validation

- `uv run pytest tests/revolution/test_deepgate_descriptor_evaluator.py`
  passed.
- `uv run ruff check ...` on touched source, scripts, and tests passed.
- `uv run python -m pyright ...` on the new evaluator, extractor script,
  projection builder, and tests passed.
- `PYTHONPATH=/workspace/exp/diversity_check/encoder_envs/deepgate3_probe/lib/python3.8/site-packages uv tool run ty check ...`
  passed.
- `git diff --check` passed.

## Decision

DeepGate remains a pretrained synthesized-netlist encoder category
representative. The next step is a small matched live smoke with
`deepgate_pooled_pc3`, not full RTLLM spend.

Do not claim DeepGate beats classic until matched HV data exists.
