# Random Descriptor Control

## 1. Motivation

This control checks whether any improvement from an Auto-BD archive comes
from descriptor meaning or merely from adding a different archive
partition. It should not be accepted as the final method; it is a
negative control for the search and reporting pipeline.

## 2. Core Idea

Map each archiveable candidate's canonical synthesized-netlist hash to
three deterministic pseudo-random values in `[0, 1)`. The descriptor is
hardware-native only in the narrow sense that it keys off the synthesized
netlist artifact; the cell assignment itself is intentionally meaningless.

## 3. Input Artifacts

- RTL source: used by the normal REvolution evaluation flow.
- Yosys JSON/netlist: synthesized netlist path emitted by
  `SynthesisEvaluator.evaluate`.
- Synthesis-stage dumps: not used.
- OpenROAD artifacts: used only for PPA objectives, not descriptor input.
- Other: canonical synthesized-netlist hash.

## 4. Descriptor Extraction Algorithm

For an archiveable candidate:

```text
netlist_hash = canonical_netlist_hash(synthesized_netlist_text)
for axis in random_hash_0, random_hash_1, random_hash_2:
    descriptor[axis] = sha256(seed, axis, netlist_hash)[0:64 bits] / 2^64
```

The implementation lives in `src/revolution/auto_bd/random_descriptor.py`
and is exposed through this method directory's `descriptor_profile.yaml`
as the `random_hash_3d` descriptor profile.

## 5. Descriptor Fitting Protocol

- Fitting kind: none
- Training data: none
- Validity filters: candidate must be archiveable and have a synthesized
  netlist artifact.
- Frozen artifact hashes: none
- Rebinning policy: use the same grid-quantile archive policy as the
  landing Smooth-QD manual-BD baseline.

## 6. Archive Integration

- Archive type: `grid_quantile`
- Internal descriptor dimensions: 3
- Internal binning/cell policy: quantile grid, warmup successes 8
- Common audit descriptor: required by the centralized report
- Common audit binning: fixed by the future report implementation

## 7. Hyperparameters

- Descriptor seed: `20260618_auto_bd_random_descriptor`
- Axes: `random_hash_0`, `random_hash_1`, `random_hash_2`
- Cell mode: `pareto_front`
- Objectives: `ppa`
- Max elites per cell: 5
- Champion-lane fraction: 0.5
- Parent selection: `nsga2_global_rank`

## 8. Expected Advantage

No semantic advantage is expected. If this control matches or beats a
proposed Auto-BD method on PPA/QD claims, the proposed method needs a
stronger rationale or rejection.

## 9. Risks

- It can create apparent coverage by random fragmentation.
- It can hide duplicate structural solutions unless canonical-netlist and
  motif-signature audits are reported.
- It is not interpretable and cannot support the final journal thesis.

## 10. Implementation Status

Implemented as a descriptor profile and candidate-evaluator extraction
path. Not yet run on the development subset.

## 11. Experimental Setup

- Benchmark subset: locked development subset first
- Seeds: seed-1 preliminary, then seed-3 screening if needed
- Model and endpoint: `openai/gpt-oss-120b` at
  `http://20.0.0.103:8000/v1`
- Evaluation budget: follow `auto_bd_run_policy_lock.yaml`
- Worker/thread policy: follow `auto_bd_run_policy_lock.yaml`
- Synthesis/OpenROAD settings: same as landing Smooth-QD manual-BD

## 12. Results

Not run.

## 13. Accept / Reject Decision

Pending.

## 14. Reason

No experimental evidence yet. This control is complete enough for a
development-subset run once classic and landing Smooth-QD baseline
coverage are reproduced.
