# 20260626 DeepGate Runtime Descriptor Gate

This package turns the T91 pooled DeepGate replay into a runtime descriptor
contract. It does not promote DeepGate to full RTLLM spend; it only closes the
gap between offline replay and a bounded live-smoke candidate.

## Purpose

T91 showed that full-transition and bounded-cone DeepGate embeddings cover all
`96/96` sampled candidates across the frozen eight-design screen and occupy
multiple PPA-relevant cells. T92 freezes that pooled embedding space as
`deepgate_pool_pc0..2` and wires the runtime descriptor hook so live QD runs can
emit the same descriptor family into archive artifacts.

## Current State

- Runtime source hook: `src/revolution/deepgate_descriptor_evaluator.py`
- Isolated extractor: `scripts/extract_deepgate_pooled_metrics.py`
- Frozen descriptor file: `tables/deepgate_descriptor_profiles.yaml`
- Frozen projection artifact: `tables/deepgate_pooled_projection.json`

The hook uses the existing isolated DeepGate environment at
`exp/diversity_check/encoder_envs/deepgate3_probe/bin/python`. The main repo
does not import `deepgate`; it asserts that the isolated script and frozen
projection exist, then reads the metrics JSON emitted by the subprocess.

## Decision Rule

Advance to a small live smoke only after:

- descriptor-profile resolution passes without PPA leakage;
- both `QDEngine` and `CandidateEvaluator` tests pass;
- one isolated extractor smoke emits finite `deepgate_pool_pc0..2` values on a
  previously embedded candidate.

The next live run should be a bounded one-problem or three-problem smoke, not
the final RTLLM spend.
