# T82 Results Report

## Tier Decision

`T0_screened_negative_not_promoted`.

The runtime hook works on a real generated RTL candidate and a one-problem
live smoke produced one valid PPA/archive member. The follow-up frozen
eight-design `8x5` screen also ran, but the exact RF timing-state descriptor
profile trails classic on mean HV and front metrics. Do not promote this exact
profile to the full RTLLM comparison.

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

The one-problem live smoke confirms archive insertion, descriptor logging, and
artifact emission. It has only one archive observation, so descriptor-health
collapse flags are expected and should not be used as non-collapse evidence.
Use T81 for generated-candidate non-collapse evidence.

The frozen eight-design screen in
`preliminary_planning/20260626_masterrtl_rf_timing_state_screen/` is valid and
negative. All eight comparisons are headline-paired, but RF timing QD reaches
mean HV `0.1140` versus classic `0.1406`, mean Pareto points `2.00` versus
`3.25`, and `2/8` HV wins. Several problems collapse the RF path-count axis,
so the next RF timing attempt should change the descriptor coupling.

## Live Smoke Result

| Metric | Value |
| --- | ---: |
| Problem | `Prob015_multi_pipe_8bit` |
| Valid PPA candidates | `1` |
| Archive members | `1` |
| Global Pareto members | `1` |
| RF timing paths | `51` |
| Unique RF leaf rows | `17` |
| Unique RF leaf IDs | `319` |
| RF no-path flag | `0` |

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
