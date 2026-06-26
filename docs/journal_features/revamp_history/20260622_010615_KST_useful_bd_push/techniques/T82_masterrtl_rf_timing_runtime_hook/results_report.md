# T82 Results Report

## Tier Decision

`T0_runtime_hook_positive_not_live_screened`.

The runtime hook works on a real generated RTL candidate, but no live QD
screen has run yet. Do not use T82 as PPA evidence.

## Smoke Result

| Metric | Value |
| --- | ---: |
| Candidate | `Prob015_multi_pipe_8bit` T70/T67 generated RTL |
| RF timing paths | `51` |
| Unique RF leaf rows | `14` |
| Unique RF leaf IDs | `161` |
| RF no-path flag | `0` |
| MasterRTL branching | `2.3730297723` |

## Interpretation

This clears the implementation blocker left after T81. The live descriptor
registry can now resolve `source_aligned_rf_timing_state_3d`, require the RF
timing path only when that profile is selected, and extract RF timing metrics
through a pinned isolated environment.

This does not prove useful QD behavior. The next gate is a tiny live vLLM
smoke that confirms archive insertion, descriptor logging, and no missing
artifacts. Only then should the frozen eight-design `8x5` screen be launched.

## Checks

```text
uv run pytest tests/revolution/test_source_aligned_descriptor_evaluator.py \
  tests/revolution/test_qd_descriptors.py \
  tests/revolution/test_candidate_evaluator.py \
  tests/revolution/test_qd_engine.py -q

uv run ruff check src/revolution/algorithm.py \
  src/revolution/qd/descriptors.py \
  src/revolution/qd/engine.py \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/source_aligned_descriptor_evaluator.py \
  scripts/extract_masterrtl_rf_timing_metrics.py \
  tests/revolution/test_source_aligned_descriptor_evaluator.py \
  tests/revolution/test_qd_engine.py

uv tool run ty check src/revolution/qd/descriptors.py \
  src/revolution/qd/engine.py \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/source_aligned_descriptor_evaluator.py \
  scripts/extract_masterrtl_rf_timing_metrics.py

uv run python -m pyright src/revolution/algorithm.py \
  src/revolution/qd/descriptors.py \
  src/revolution/qd/engine.py \
  src/revolution/runtime/candidate_evaluator.py \
  src/revolution/source_aligned_descriptor_evaluator.py \
  scripts/extract_masterrtl_rf_timing_metrics.py

PYTHONHASHSEED=0 uv run --with scikit-learn==1.3.0 \
  --with numpy==1.26.4 --with networkx --with joblib \
  python scripts/extract_masterrtl_rf_timing_metrics.py ...

uv run python ... SourceAlignedRTLDescriptorEvaluator(include_rf_timing=True)
```

`ty` on `src/revolution/algorithm.py` still reports pre-existing strategy and
synthesis-result typing debt outside the RF timing hook. `pyright` passes on
that file with the T82 changes included.
