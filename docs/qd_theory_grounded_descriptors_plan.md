# Theory-Grounded QD Descriptor Plan

## Summary

Implement a new experimental QD descriptor family for `revolution_qd` that is
more tightly anchored to established RTL / graph-theoretic metrics than the
current lightweight heuristic profiles. The first runtime landing combines:

- RTL cyclomatic complexity from the Yosys AST walk
- Rent exponent from repo-native recursive spectral bipartitioning
- reconvergent fan-out ratios
- SCOAP controllability / observability histogram descriptors
- spectral / graph-signal descriptors from the normalized Laplacian

The combined builtin profile is `theory_grounded_full_20d`. It is intentionally
opt-in, CVT-first, and not a replacement for the current structural defaults.

## Status

- Branch: `feat/qd-theory-grounded-descriptors`
- Base branch: `feat/hard-iteration-subset-qd`
- Base worktree: `/workspace`
- Implementation worktree:
  `/workspace/.worktrees/qd-theory-grounded-descriptors`
- Current stage:
  runtime extraction, profile wiring, docs, and bounded validation complete;
  the branch now has passing full local tests plus one live theory-profile QD
  smoke; follow-on work is mainly broader experiment evidence and optional
  RentCon cross-check automation

## Worktree Notes

- This feature was implemented in a separate Git worktree so the main checkout
  could stay undisturbed during descriptor/runtime changes.
- Worktree creation command:
  `git worktree add -b feat/qd-theory-grounded-descriptors /workspace/.worktrees/qd-theory-grounded-descriptors feat/hard-iteration-subset-qd`
- The worktree does not automatically inherit untracked directories from the
  main checkout.
- Important local examples:
  - Python environment remains in `/workspace/.venv`
  - RentCon reference assets remain in `/workspace/.rentcon`

## Working Rules

- Split follow-on work into explicit numbered stages with a bounded scope.
- Before starting a new stage, update this document with:
  - stage goal
  - concrete files or surfaces expected to change
  - validation expected for the stage
- After finishing a stage, always do all three before moving on:
  - code review of the changed surface
  - doc updates for any new user-facing or workflow-facing behavior
  - tests or smoke validation appropriate to the change
- Keep commits stage-scoped and logical. Prefer one signed multi-line commit per
  finished stage rather than one large mixed commit.
- Commit messages should follow the repository’s existing style:
  `<type>(<scope>): <subject>` with a wrapped body, optional `Tests:` and
  `Docs:` sections, and `git commit -s`.
- Optimize code for readability first:
  - make the control flow skimmable
  - prefer early returns
  - avoid cleverness and dense one-off abstractions
  - use simple helper functions when they reduce indentation or repeated logic
  - prefer obvious names over short names
- Keep this document current as a living journal:
  - cross off completed items
  - add new TODOs discovered during implementation
  - record major design decisions and validation outcomes

## Stage Plan

- Stage 1: core runtime rollout
  - scope:
    graph extraction, theory-grounded descriptor computation, QD/runtime
    wiring, registry/profile wiring, archive payload wiring, docs, and base
    tests
  - status:
    completed locally and ready for a signed checkpoint commit
- Stage 2: repeatable theory-profile smoke/comparison harness
  - scope:
    add a dedicated script for theory-grounded CVT smoke/comparison runs,
    update docs, add dry-run regression coverage, and validate against the
    shared vLLM endpoint
  - status:
    completed locally and ready for a signed checkpoint commit
- Stage 3: RentCon calibration workflow
  - scope:
    make it easier to compare repo-native Rent extraction against stored
    RentCon outputs and record calibration decisions
  - status:
    pending
- Stage 4: broader experiment follow-through
  - scope:
    multi-problem bounded theory-profile runs, archive-health review, and any
    compact-profile decisions
  - status:
    pending

## Decisions Log

- 2026-03-26: Keep the first landing repo-native. Rent extraction runs from
  Yosys JSON plus spectral recursive bipartitioning; RentCon is comparison-only
  and not a live dependency.
- 2026-03-26: Keep the new descriptor family opt-in only. Do not change the
  current default grid or CVT profiles.
- 2026-03-26: Treat `theory_grounded_full_20d` as CVT-first. Fallback grid
  bounds exist for debugging and probing, but the intended archive geometry is
  CVT.
- 2026-03-26: Emit raw graph descriptors through `graph_metrics` in candidate
  payloads and archive events so post-run analysis can inspect the underlying
  metric values directly.
- 2026-03-26: Use fixed four-bin SCOAP histograms per score family
  (`1`, `2-3`, `4-7`, `8+`) to keep the vector length stable while preserving
  distribution shape.
- 2026-03-26: Add an offline probe script for theory descriptors and optional
  RentCon report comparison instead of invoking RentCon from the evaluation hot
  path.

## Implementation Checklist

- [x] Create a dedicated worktree and branch from
  `feat/hard-iteration-subset-qd`.
- [x] Add RTL cyclomatic metrics to the AST descriptor extractor.
- [x] Add repo-native graph extraction from Yosys JSON.
- [x] Compute Rent exponent, Rent fit diagnostics, and recursive partition
  samples from the flattened graph.
- [x] Compute reconvergent fan-out descriptors.
- [x] Compute SCOAP-based controllability / observability histograms.
- [x] Compute spectral / graph-signal descriptors.
- [x] Add `graph_metrics` to shared runtime result payloads.
- [x] Wire graph metrics into the QD engine and archive event artifacts.
- [x] Register the new axes in the descriptor registry.
- [x] Add the builtin profile `theory_grounded_full_20d`.
- [x] Add unit/integration tests for the new runtime surfaces.
- [x] Add repo docs for the new profile and descriptor family.
- [x] Add an offline theory-descriptor probe / Rent comparison helper.
- [ ] Run longer multi-problem QD experiments and compare archive behavior
  against the structural CVT controls.
- [ ] Compare repo-native Rent estimates against extracted RentCon reports on a
  small calibration corpus.
- [ ] Decide whether any reduced theory-grounded profile should become a
  default recommended follow-on after experiment evidence exists.

## Delivered Runtime Surface

### Raw metrics

- `rtl_cyclomatic_total_log`
- `rtl_cyclomatic_max_log`
- `rent_exponent`
- `rent_k`
- `rent_r2`
- `rent_sample_count`
- `reconv_source_ratio`
- `reconv_sink_ratio`
- `scoap_cc0_bin_0_pct` through `scoap_cc0_bin_3_pct`
- `scoap_cc1_bin_0_pct` through `scoap_cc1_bin_3_pct`
- `scoap_co_bin_0_pct` through `scoap_co_bin_3_pct`
- `laplacian_lambda2`
- `laplacian_spectral_entropy`
- `scoap_signal_smoothness`

### Builtin profile

`theory_grounded_full_20d`:

- `rtl_cyclomatic_total_log`
- `rtl_cyclomatic_max_log`
- `rent_exponent`
- `reconv_source_ratio`
- `reconv_sink_ratio`
- `scoap_cc0_bin_0_pct`
- `scoap_cc0_bin_1_pct`
- `scoap_cc0_bin_2_pct`
- `scoap_cc0_bin_3_pct`
- `scoap_cc1_bin_0_pct`
- `scoap_cc1_bin_1_pct`
- `scoap_cc1_bin_2_pct`
- `scoap_cc1_bin_3_pct`
- `scoap_co_bin_0_pct`
- `scoap_co_bin_1_pct`
- `scoap_co_bin_2_pct`
- `scoap_co_bin_3_pct`
- `laplacian_lambda2`
- `laplacian_spectral_entropy`
- `scoap_signal_smoothness`

## Validation Log

- 2026-03-26:
  `python scripts/qd_descriptor_probe.py --archive_type cvt --profile theory_grounded_full_20d`
  confirmed 20 resolved axes plus `requires_graph_metrics=true`.
- 2026-03-26:
  `pytest tests/revolution/test_rtl_descriptor_evaluator.py -q`
  passed.
- 2026-03-26:
  `pytest tests/revolution/test_graph_descriptor_evaluator.py -q`
  passed.
- 2026-03-26:
  `pytest tests/revolution/test_rtl_descriptor_evaluator.py tests/revolution/test_qd_descriptors.py tests/revolution/test_candidate_evaluator.py::test_candidate_evaluator_extracts_graph_metrics_for_theory_profile tests/revolution/test_qd_engine.py::test_qd_engine_writes_candidate_archive_event_for_empty_fill -q`
  passed.
- 2026-03-26:
  broader lint, typecheck, and bounded smoke validation were run after the
  docs/probe additions; see the latest entries below.
- 2026-03-26:
  `ruff check src/revolution/graph_descriptor_evaluator.py src/revolution/rtl_descriptor_evaluator.py src/revolution/qd/descriptors.py src/revolution/qd/engine.py src/revolution/qd/artifacts.py src/revolution/runtime/candidate_evaluator.py src/revolution/algorithm.py scripts/qd_theory_descriptor_probe.py tests/revolution/test_graph_descriptor_evaluator.py tests/revolution/test_rtl_descriptor_evaluator.py tests/revolution/test_qd_descriptors.py tests/revolution/test_candidate_evaluator.py tests/revolution/test_qd_engine.py tests/scripts/test_qd_theory_descriptor_probe.py`
  passed.
- 2026-03-26:
  `python -m pyright --pythonpath /workspace/.venv/bin/python src/revolution/graph_descriptor_evaluator.py src/revolution/rtl_descriptor_evaluator.py src/revolution/qd/descriptors.py src/revolution/qd/engine.py src/revolution/qd/artifacts.py src/revolution/runtime/candidate_evaluator.py scripts/qd_theory_descriptor_probe.py`
  passed.
- 2026-03-26:
  `python -m pyright --pythonpath /workspace/.venv/bin/python src/revolution/algorithm.py`
  passed after tightening type narrowing in the legacy engine path.
- 2026-03-26:
  `python scripts/qd_theory_descriptor_probe.py --rtl data/bench/RTLLM/Prob001_accu_ref.sv --top accu --profile theory_grounded_full_20d`
  produced the expected 20D descriptor payload on a real RTLLM reference
  design.
- 2026-03-26:
  `curl http://host.docker.internal:8000/v1/models`
  confirmed the shared vLLM endpoint serves
  `/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b` with
  `max_model_len=131072`.
- 2026-03-26:
  `python scripts/run_backend.py --backend revolution --search_mode revolution_qd --qd_archive_type cvt --qd_descriptor_profile theory_grounded_full_20d --benchmarks RTLLM --problems Prob001_accu --api_backend vllm --vllm_host host.docker.internal --vllm_port 8000 --model_name /project/cad-team/LX_Semicon/models/openai-gpt-oss-120b --max_tokens 128000 --diff_max_tokens 128000 --total_worker_slots 1 --max_active_problems 1 --max_workers_per_problem 1 --population_size 1 --num_generations 1 --save_path /tmp/qd_theory_smoke_20260326`
  completed in 28.16 seconds and emitted `qd_archive_event.json`,
  `archive_space_report.md`, `descriptor_health_report.md`, and
  `archive_summary.json` with the theory-grounded axes.
- 2026-03-26:
  `pytest -q`
  passed with `451 passed, 4 skipped`.
- 2026-03-26:
  `bash -n scripts/run_qd_theory_grounded_smoke_vllm.sh`
  passed.
- 2026-03-26:
  `pytest tests/scripts/test_run_qd_theory_grounded_smoke_vllm.py -q`
  passed.
- 2026-03-26:
  `ruff check tests/scripts/test_run_qd_theory_grounded_smoke_vllm.py`
  passed.
- 2026-03-26:
  `VLLM_HOST=host.docker.internal VLLM_PORT=8000 bash scripts/run_qd_theory_grounded_smoke_vllm.sh --suite rtllm --mode theory-only --dry-run`
  printed the expected CVT theory-grounded command matrix.
- 2026-03-26:
  `VLLM_HOST=host.docker.internal VLLM_PORT=8000 THEORY_SMOKE_SAVE_PATH=/tmp/qd_theory_stage2_smoke bash scripts/run_qd_theory_grounded_smoke_vllm.sh --suite rtllm --mode theory-only`
  completed in 33.25 seconds and wrote a bounded live smoke root under
  `/tmp/qd_theory_stage2_smoke/20260326_152838`.

## Remaining Validation / Experiment TODOs

- [x] Run full `pytest`.
- [x] Add a repeatable theory-grounded smoke/comparison harness with dry-run
  coverage.
- [ ] Run a broader theory-profile smoke matrix over both RTLLM and
  VerilogEval.
- [ ] Save a small calibration set of RentCon outputs so
  `scripts/qd_theory_descriptor_probe.py` can report concrete deltas instead of
  just repo-native values.
- [ ] Inspect archive-side descriptor-health behavior for the SCOAP histogram
  axes; some bins may collapse on trivial designs and may need profile pruning.

## Open Questions

- Does the 20D profile produce useful archive diversity, or is a reduced
  subspace needed to avoid CVT dilution?
- Is the current Rent fit stable enough across small synthesized graphs, or
  should the recursive partition flow add stronger trimming / sample filters?
- Should SCOAP histograms remain raw percentages, or should future follow-on
  profiles compress them through PCA or hand-picked summary ratios?
- Are there benchmark families where graph extraction from raw RTL should be
  replaced with post-`techmap` or post-`abc` graphs for better comparability?

## Roadmap

- Short term:
  compare `theory_grounded_full_20d` against
  `implemented_structural_fixed_5d` and `size_control_3d` on bounded CVT runs.
- Medium term:
  calibrate repo-native Rent against RentCon reference outputs and decide
  whether `rent_k` or fit-quality diagnostics deserve report-side exposure.
- Medium term:
  identify a compact theory-grounded follow-on profile for longer-budget
  experiments.
- Longer term:
  explore additional graph-signal descriptors, sequential-boundary-aware graph
  variants, and benchmark-family-specific descriptor gating.
