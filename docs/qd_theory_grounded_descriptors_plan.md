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
  runtime extraction, profile wiring, docs, bounded smokes, Rent calibration,
  bounded theory follow-up reporting, manifest-driven broader experiment
  tooling, the first hard-subset `20 x 5` comparison, the compact follow-on
  profile, the CVT warmup fallback, and the first native Rent reference
  validation pass are complete; Stage 10 QD archive tuning is now complete,
  and the next stage is to rerun the compact theory profile using the tuned
  hard-subset CVT policy

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
    completed locally and ready for a signed checkpoint commit
- Stage 4: broader experiment follow-through
  - scope:
    add a repeatable bounded theory follow-up matrix harness, add a focused
    theory-vs-control comparison report, surface archive-health signals for the
    theory profile, and emit a compact-profile recommendation candidate from
    observed non-collapsed axes
  - status:
    completed locally and ready for a signed checkpoint commit
- Stage 5: broader experiment manifest and decision workflow
  - scope:
    add a manifest-driven theory follow-up runner for broader RTLLM /
    VerilogEval experiment passes, extend the follow-up report with
    theory-vs-control deltas and a compact-profile decision status, add example
    manifests, update docs, and validate with dry-run plus bounded live smoke
  - status:
    completed locally and ready for a signed checkpoint commit
- Stage 6: hard-subset integration and long-budget comparison
  - scope:
    add the theory-grounded backend to the hard-iteration harness/config,
    validate the workflow, run a `20 x 5` hard-subset experiment with up to 20
    worker slots, generate the final analysis bundle and histogram artifacts,
    compare against the existing classic/QD hard-subset baselines, and update
    the plan based on the observed feature diversity / collapse behavior
  - status:
    completed locally and ready for a signed checkpoint commit
- Stage 7: compact theory follow-on and centroid-init follow-up
  - scope:
    turn the Stage 6 collapse evidence into a smaller builtin theory profile,
    add bounded harness support for that profile, investigate warmup /
    centroid-initialization fallback options for low-success problems, and rerun
    the hard subset to check whether archive health remains strong without the
    current initialization failures
  - status:
    code-complete; experiment reruns moved into later stages
  - Stage 7A goal:
    land the reduced theory profile as a first-class builtin option and make
    the follow-up / hard-subset harnesses able to run it directly
  - Stage 7A expected surfaces:
    `data/configs/qd_descriptor_profiles.yaml`,
    `src/revolution/qd/descriptors.py`,
    `scripts/run_qd_theory_followup_vllm.sh`,
    `scripts/run_qd_theory_followup_manifest.py`,
    `scripts/run_hard_iteration_qd_vllm.sh`,
    matching script tests, and user-facing docs
  - Stage 7A validation:
    descriptor-profile unit tests, harness dry-run tests, targeted
    lint/typecheck, and a quick code review pass
  - Stage 7A status:
    completed locally and ready for a signed checkpoint commit
  - Stage 7B goal:
    add a CVT centroid-initialization fallback so low-success problems do not
    finish with permanently uninitialized archives when they never hit the
    configured warmup target
  - Stage 7B expected surfaces:
    `src/revolution/qd/archive.py`,
    archive/engine tests, artifact docs, and the theory plan journal
  - Stage 7B validation:
    targeted archive and engine tests, lint/typecheck, and a bounded smoke if
    the fallback changes user-visible artifact behavior
  - Stage 7B status:
    completed locally and ready for a signed checkpoint commit
- Stage 8: native Rent reference validation on synthesized netlists
  - scope:
    stage passing synthesized hard-subset netlists into `exp/`, generate
    OpenROAD DEF files, compare the repo-native Rent extractor against the
    native RentCon binary, time both paths, and record the findings in this
    plan plus a reusable report bundle
  - status:
    completed locally and ready for a signed checkpoint commit
- Stage 9: Rent confidence gating and safer profile wiring
  - scope:
    keep the raw repo-native Rent metrics for analysis, add explicit
    confidence diagnostics for low-sample or clamped fits, switch the full
    theory profile to a confidence-gated Rent axis, and update docs/tests so
    the safety policy is explicit
  - status:
    completed locally and ready for a signed checkpoint commit
  - Stage 9A goal:
    add readable helper logic that computes raw Rent diagnostics plus a
    confidence-gated profile-facing exponent without changing the raw analysis
    payload
  - Stage 9A expected surfaces:
    `src/revolution/graph_descriptor_evaluator.py`,
    `src/revolution/qd/descriptors.py`,
    `data/configs/qd_descriptor_profiles.yaml`,
    matching unit tests, and theory-profile docs
  - Stage 9A validation:
    targeted graph-descriptor and descriptor-registry tests, lint, typecheck,
    and a descriptor-probe sanity check for the full theory profile
  - Stage 9A status:
    completed locally and ready for a signed checkpoint commit
  - Stage 9B goal:
    extend the native Rent reference-validation workflow so it compares both
    raw and confidence-gated Rent against RentCon, rerun the staged hard-subset
    bundle, and record whether confidence gating improves or only stabilizes
    the reference picture
  - Stage 9B expected surfaces:
    `scripts/report_qd_rent_reference_validation.py`,
    `tests/scripts/test_report_qd_rent_reference_validation.py`,
    the Rent validation bundle under `exp/`, and the theory plan journal
  - Stage 9B validation:
    targeted report-script tests, lint, typecheck, a real hard-subset rerun,
    and a code review pass on the reporting diff
  - Stage 9B status:
    completed locally and ready for a signed checkpoint commit
- Stage 10: QD archive family and CVT parameter tuning
  - scope:
    make the hard-subset harness support config-driven archive-parameter
    matrices, run a bounded grid-vs-CVT screening matrix plus focused CVT
    knob sweeps, confirm the strongest candidate on a heavier hard-subset run,
    then freeze a recommended archive/default policy in config and docs
  - status:
    in progress
  - Stage 10A goal:
    finish the config-driven hard-subset tuning harness and document the
    tuning stage before launching experiments
  - Stage 10A expected surfaces:
    `scripts/run_hard_iteration_qd_vllm.sh`,
    `tests/scripts/test_run_hard_iteration_qd_vllm.py`,
    and this plan journal
  - Stage 10A validation:
    harness dry-run regression tests, shell syntax check, and a code review
    pass on the new config-driven mode/override handling
  - Stage 10A status:
    completed locally and ready for a signed checkpoint commit
  - Stage 10B goal:
    run a bounded hard-subset tuning matrix to answer two practical
    questions:
    `grid` or `cvt` as the better default family for this workload, and which
    active CVT settings (`qd_num_cells`, `qd_cvt_warmup_successes`,
    `qd_fill_target_fraction`, `qd_cell_reservoir`) give the strongest
    trade-off between score, archive health, and stability
  - Stage 10B expected surfaces:
    a dedicated hard-subset tuning config under `data/configs/`,
    experiment roots under `exp/`,
    and the resulting `final_analysis/` bundle(s)
  - Stage 10B validation:
    vLLM preflight, completed hard-subset screening runs, report generation,
    and a code review pass on any new report/config glue
  - Stage 10B status:
    completed locally and ready for a signed checkpoint commit
  - Stage 10C goal:
    freeze the chosen recommendation into the checked-in hard-subset defaults
    and user-facing docs, record the evidence and rationale in this plan, and
    leave the next compact-theory rerun stage with a clearer archive policy
  - Stage 10C expected surfaces:
    `data/configs/hard_iteration_subset.yaml`,
    `scripts/build_hard_iteration_subset.py`,
    relevant user docs,
    and this plan journal
  - Stage 10C validation:
    targeted tests for any changed config-emission code, lint/typecheck on
    touched Python modules, shell validation for touched harnesses, and a final
    report spot-check against the selected recommendation
  - Stage 10C status:
    completed locally and ready for a signed checkpoint commit

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
- 2026-03-26: Use a manifest-driven Python runner for broader theory follow-up
  experiments instead of continuing to extend the bounded shell harness with
  more environment-variable combinations.
- 2026-03-26: Treat compact-profile promotion as an explicit decision output,
  not just a list of candidate axes. The report now records both pairwise
  control deltas and a `candidate_ready` / `needs_more_data` status.
- 2026-03-26: The first hard-subset `20 x 5` run does not justify promoting
  `theory_grounded_full_20d` as a general-performance replacement. It should
  remain experimental and archive-health-focused until a reduced profile is
  tested.
- 2026-03-26: Three hard-subset problems never initialized CVT centroids with
  `warmup_successes=16`, so the next stage should treat centroid
  initialization, not just axis selection, as a first-class follow-up item.
- 2026-03-26: `scripts/report_evolutionary_run.py` must support nested
  model-directory run roots. Stage 6 surfaced this as a real analysis bug, and
  the report helper now resolves selected problems recursively instead of
  assuming a shallow `backend_root/<benchmark>/<problem>` layout.
- 2026-03-26: The first reduced theory follow-on should be explicit and
  reproducible, not just a report artifact. `theory_grounded_compact_8d` is now
  the checked-in compact profile name for Stage 7 experiments.
- 2026-03-26: Low-success CVT problems should not end with a permanently empty
  archive when they have at least one successful candidate. The archive now
  performs a run-end fallback initialization from the warmup buffer instead of
  discarding those successes.
- 2026-03-26: The shipped RentCon binary under `/workspace/.rentcon` is usable
  only as a best-effort offline reference on this machine. It crashes on many
  OpenROAD-generated DEFs, so the new validation helper runs one case per
  process, accepts parseable summaries from non-zero exits, and treats
  RentCon as comparison-only evidence rather than a clean batch oracle.
- 2026-03-26: Repo-native Rent extraction is cheap enough for the live runtime,
  but the current slope/clamp behavior is not calibrated well enough for small
  synthesized graphs. Promotion work should focus on confidence gating and fit
  policy before expanding Rent-heavy profiles.
- 2026-03-26: Keep raw `rent_exponent` available in `graph_metrics` for
  reporting and offline calibration, but switch the shipped full theory profile
  to `rent_exponent_confidence_gated` so low-sample or clamped fits shrink
  toward a neutral archive value instead of behaving like trusted extremes.
- 2026-03-26: The Rent reference-validation report should compare raw and
  confidence-gated Rent side by side. That keeps the archive-facing safety
  policy visible in analysis instead of only in runtime code.
- 2026-03-26: RentCon report parsing must reject out-of-range fast-path summary
  values as well as the slower fallback fit lines. The graph-traversal summary
  can emit malformed `500+` values on this machine, and those must not pollute
  accuracy summaries.
- 2026-03-26: Confidence gating is still justified as an archive-safety
  policy, but the current five-case hard-subset reference subset does not show
  a clean CP Type I accuracy win from gating. Promotion decisions should treat
  gating as safer behavior, not as proven calibration.
- 2026-03-26: For the frozen hard-subset workflow, prefer `cvt` over `grid`
  as the default archive family. The Stage 10 same-profile `size_control_3d`
  screen showed that the balanced CVT default beats grid on synthesis,
  coverage, QD score, best quality, and mean hypervolume at roughly the same
  runtime.
- 2026-03-26: Keep the hard-subset CVT default at
  `qd_num_cells=16`, `qd_cvt_warmup_successes=4`,
  `qd_fill_target_fraction=0.25`, and `qd_cell_reservoir=2`.
  `warmup2` helps raw synthesis rate, `dense24` helps mean hypervolume, and
  `fill50` reduces both archive quality and score, but the existing pack is
  still the strongest balanced default.
- 2026-03-26: Do not flip the repo-wide `run_backend.py` CLI default from
  `grid` to `cvt` yet. The hard-subset tuning result is workflow-specific, and
  the current global CVT warmup semantics at the CLI default cell count would
  be misleading as a blanket repo-wide default.

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
- [x] Add a bounded multi-problem theory follow-up matrix harness.
- [x] Add a theory-vs-control follow-up report with archive-health summaries.
- [x] Emit a compact theory-profile recommendation candidate from descriptor
  health observations.
- [x] Add a manifest-driven broader theory follow-up runner.
- [x] Add pairwise control deltas and explicit promotion-decision output to
  the follow-up report.
- [x] Add a checked-in broad follow-up matrix manifest and docs for it.
- [x] Run longer multi-problem QD experiments and compare archive behavior
  against the structural CVT controls.
- [x] Generate problem-level histogram artifacts for the hard-subset theory run.
- [x] Fix final-analysis evolutionary reporting for nested model-directory
  backend roots.
- [x] Compare repo-native Rent estimates against extracted RentCon reports on a
  small calibration corpus.
- [x] Compare repo-native Rent estimates against native RentCon runs on staged
  synthesized hard-subset netlists and record the accuracy/runtime findings.
- [x] Add a compact theory-grounded follow-on profile based on
  Stage 6 collapse evidence.
- [ ] Benchmark the compact theory-grounded follow-on profile against the full
  theory profile and the structural controls.
- [x] Add a CVT run-end fallback for low-success problems that never hit the
  configured warmup threshold.
- [ ] Decide whether any reduced theory-grounded profile should become a
  default recommended follow-on after the Stage 7 rerun.
- [x] Add rent-confidence gating or fallback handling for low-sample /
  clamped Rent cases before using Rent more aggressively in profile decisions.

## Delivered Runtime Surface

### Raw metrics

- `rtl_cyclomatic_total_log`
- `rtl_cyclomatic_max_log`
- `rent_exponent`
- `rent_exponent_confidence_gated`
- `rent_confidence`
- `rent_clamped_flag`
- `rent_k`
- `rent_r2`
- `rent_sample_count`
- `rent_raw_sample_count`
- `rent_retained_sample_ratio`
- `rent_graph_node_count`
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
- `rent_exponent_confidence_gated`
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

`theory_grounded_compact_8d`:

- `scoap_signal_smoothness`
- `laplacian_spectral_entropy`
- `scoap_cc0_bin_1_pct`
- `scoap_co_bin_3_pct`
- `scoap_cc1_bin_1_pct`
- `scoap_co_bin_0_pct`
- `scoap_cc0_bin_0_pct`
- `scoap_cc1_bin_0_pct`

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
- 2026-03-26:
  `pytest tests/scripts/test_report_qd_rent_calibration.py -q`
  passed.
- 2026-03-26:
  `ruff check scripts/report_qd_rent_calibration.py tests/scripts/test_report_qd_rent_calibration.py`
  passed.
- 2026-03-26:
  `python -m pyright --pythonpath /workspace/.venv/bin/python scripts/report_qd_rent_calibration.py`
  passed.
- 2026-03-26:
  `python scripts/report_qd_rent_calibration.py --manifest data/configs/qd_theory_rent_calibration_example.json --output_json /tmp/qd_rent_calibration_stage3/report.json --output_md /tmp/qd_rent_calibration_stage3/report.md`
  completed and emitted a real example markdown/json report over two RTLLM
  reference designs.
- 2026-03-26:
  `/workspace/.venv/bin/pytest tests/scripts/test_report_qd_rent_reference_validation.py -q`
  passed after adding the synthesized-netlist reference-validation harness and
  fallback parsing for partial RentCon outputs.
- 2026-03-26:
  `/workspace/.venv/bin/ruff check scripts/report_qd_rent_reference_validation.py tests/scripts/test_report_qd_rent_reference_validation.py`
  passed.
- 2026-03-26:
  `/workspace/.venv/bin/python -m pyright scripts/report_qd_rent_reference_validation.py`
  passed.
- 2026-03-26:
  `/workspace/.venv/bin/python scripts/report_qd_rent_reference_validation.py --run_root /workspace/.worktrees/hard-iteration-subset-qd/exp/hard_iteration_qd_5way_standard20x5_warmup16_unconstrained_20260326_032529 --output_root /workspace/.worktrees/qd-theory-grounded-descriptors/exp/qd_rent_reference_validation_hard_subset_20260326_final --workers 1 --repo_root /workspace/.worktrees/qd-theory-grounded-descriptors`
  completed and wrote the final Stage 8 bundle under
  `/workspace/.worktrees/qd-theory-grounded-descriptors/exp/qd_rent_reference_validation_hard_subset_20260326_final/final_analysis`.
- 2026-03-26:
  `bash -n scripts/run_qd_theory_followup_vllm.sh`
  passed.
- 2026-03-26:
  `pytest tests/scripts/test_run_qd_theory_followup_vllm.py tests/scripts/test_report_qd_theory_followup.py -q`
  passed.
- 2026-03-26:
  `ruff check scripts/report_qd_theory_followup.py tests/scripts/test_run_qd_theory_followup_vllm.py tests/scripts/test_report_qd_theory_followup.py`
  passed.
- 2026-03-26:
  `python -m pyright --pythonpath /workspace/.venv/bin/python scripts/report_qd_theory_followup.py`
  passed.
- 2026-03-26:
  `VLLM_HOST=host.docker.internal VLLM_PORT=8000 bash scripts/run_qd_theory_followup_vllm.sh --suite rtllm --dry-run`
  printed the expected structural/size-control/theory matrix.
- 2026-03-26:
  `VLLM_HOST=host.docker.internal VLLM_PORT=8000 THEORY_FOLLOWUP_SAVE_PATH=/tmp/qd_theory_followup_stage4 THEORY_FOLLOWUP_POPULATION_SIZE=1 THEORY_FOLLOWUP_NUM_GENERATIONS=0 THEORY_FOLLOWUP_TOTAL_WORKER_SLOTS=1 THEORY_FOLLOWUP_MAX_WORKERS=1 THEORY_FOLLOWUP_TIMEOUT_S=180 bash scripts/run_qd_theory_followup_vllm.sh --suite rtllm`
  completed and wrote a bounded live follow-up root under
  `/tmp/qd_theory_followup_stage4/20260326_153928`.
- 2026-03-26:
  `python scripts/report_qd_theory_followup.py --run_root /tmp/qd_theory_followup_stage4/20260326_153928 --output_dir /tmp/qd_theory_followup_stage4/20260326_153928/theory_followup_report`
  completed and emitted `theory_followup_summary.json`,
  `theory_followup_report.md`, and `recommended_theory_profile.json`.
- 2026-03-26:
  The bounded RTLLM follow-up used `population_size=1` and `num_generations=0`,
  so the emitted compact recommendation was intentionally empty; this is a
  useful smoke artifact, not evidence for final profile pruning.
- 2026-03-26:
  `pytest tests/scripts/test_run_qd_theory_followup_manifest.py tests/scripts/test_report_qd_theory_followup.py -q`
  passed.
- 2026-03-26:
  `ruff check scripts/run_qd_theory_followup_manifest.py scripts/report_qd_theory_followup.py tests/scripts/test_run_qd_theory_followup_manifest.py tests/scripts/test_report_qd_theory_followup.py`
  passed.
- 2026-03-26:
  `python -m pyright --pythonpath /workspace/.venv/bin/python scripts/run_qd_theory_followup_manifest.py scripts/report_qd_theory_followup.py`
  passed.
- 2026-03-26:
  `python scripts/run_qd_theory_followup_manifest.py --manifest data/configs/qd_theory_followup_broad_matrix.json --dry-run`
  printed the expected RTLLM / VerilogEval broader matrix from the checked-in
  manifest.
- 2026-03-26:
  `python scripts/run_qd_theory_followup_manifest.py --manifest data/configs/qd_theory_followup_broad_matrix.json --case rtllm_core_pair --smoke-budget --run_tag 20260326_stage5_seq_live`
  completed and wrote a bounded live manifest-driven run root under
  `/tmp/qd_theory_followup_broad/20260326_stage5_seq_live`.
- 2026-03-26:
  `python scripts/report_qd_theory_followup.py --run_root /tmp/qd_theory_followup_broad/20260326_stage5_seq_live --output_dir /tmp/qd_theory_followup_broad/20260326_stage5_seq_live/theory_followup_report`
  completed and emitted `theory_followup_summary.json`,
  `theory_followup_report.md`, `recommended_theory_profile.json`, and
  `theory_promotion_decision.json`.
- 2026-03-26:
  The manifest-driven smoke-budget RTLLM run still produced
  `recommendation_decision.status=needs_more_data`; this is the expected
  outcome for a `population_size=1`, `num_generations=0` reachability pass.
- 2026-03-26:
  `HARD_SUBSET_SAVE_PATH=/workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_grounded_20x5_warmup16_unconstrained HARD_SUBSET_TOTAL_WORKER_SLOTS=20 HARD_SUBSET_MAX_ACTIVE_PROBLEMS=20 HARD_SUBSET_MAX_WORKERS_PER_PROBLEM=20 HARD_SUBSET_CVT_WARMUP=16 bash scripts/run_hard_iteration_qd_vllm.sh --config data/configs/hard_iteration_subset.yaml --mode cvt_theory_grounded`
  completed in `3540.78` seconds over the 13-problem hard subset and wrote the
  theory run root under
  `/workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_grounded_20x5_warmup16_unconstrained/20260326_160434/cvt_theory_grounded`.
- 2026-03-26:
  `python scripts/report_qd_problem_histograms.py --run-root /workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_grounded_20x5_warmup16_unconstrained/20260326_160434/cvt_theory_grounded`
  completed for all 13 problems and wrote per-problem histogram artifacts under
  each problem directory in `qd_feature_histograms/`.
- 2026-03-26:
  `python scripts/report_qd_theory_followup.py --run_root /workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_grounded_20x5_warmup16_unconstrained/20260326_160434/cvt_theory_grounded --output_dir /workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_vs_baseline_20260326_160434/final_analysis/theory_followup`
  emitted the theory-only collapse summary, compact 8D candidate profile, and
  recommendation status for the hard-subset run.
- 2026-03-26:
  `pytest tests/scripts/test_report_evolutionary_run.py tests/scripts/test_report_final_analysis_bundle.py -q`
  passed after fixing nested-root problem discovery in
  `scripts/report_evolutionary_run.py`.
- 2026-03-26:
  `ruff check scripts/report_evolutionary_run.py tests/scripts/test_report_evolutionary_run.py tests/scripts/test_report_final_analysis_bundle.py`
  passed.
- 2026-03-26:
  `python -m pyright --pythonpath /workspace/.venv/bin/python scripts/report_evolutionary_run.py`
  passed.
- 2026-03-26:
  `python scripts/report_final_analysis_bundle.py --subset-config data/configs/hard_iteration_subset.yaml --backend_run classic=/workspace/.worktrees/hard-iteration-subset-qd/exp/hard_iteration_qd_5way_standard20x5_warmup16_unconstrained_20260326_032529/classic --backend_run cvt_implemented_structural_fixed_5d=/workspace/.worktrees/hard-iteration-subset-qd/exp/hard_iteration_qd_5way_standard20x5_warmup16_unconstrained_20260326_032529/cvt_implemented_structural_fixed_5d --backend_run cvt_large_struct10d=/workspace/.worktrees/hard-iteration-subset-qd/exp/hard_iteration_qd_5way_standard20x5_warmup16_unconstrained_20260326_032529/cvt_large_struct10d --backend_run cvt_large_struct_size_control_13d=/workspace/.worktrees/hard-iteration-subset-qd/exp/hard_iteration_qd_5way_standard20x5_warmup16_unconstrained_20260326_032529/cvt_large_struct_size_control_13d --backend_run cvt_size_control_3d=/workspace/.worktrees/hard-iteration-subset-qd/exp/hard_iteration_qd_5way_standard20x5_warmup16_unconstrained_20260326_032529/cvt_size_control_3d --backend_run cvt_theory_grounded=/workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_grounded_20x5_warmup16_unconstrained/20260326_160434/cvt_theory_grounded --output-dir /workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_vs_baseline_20260326_160434/final_analysis`
  regenerated the comparison bundle after the evolutionary-report fix. The
  repaired bundle now has a populated
  `final_analysis/evolutionary_reports/cvt_theory_grounded/summary.json`.
- 2026-03-26:
  `pytest tests/revolution/test_qd_descriptors.py tests/scripts/test_run_qd_theory_followup_manifest.py tests/scripts/test_run_qd_theory_followup_vllm.py tests/scripts/test_run_qd_theory_grounded_smoke_vllm.py tests/scripts/test_run_hard_iteration_qd_vllm.py -q`
  passed after adding the builtin compact theory profile and its harness
  surfaces.
- 2026-03-26:
  `bash -n scripts/run_qd_theory_followup_vllm.sh && bash -n scripts/run_qd_theory_grounded_smoke_vllm.sh && bash -n scripts/run_hard_iteration_qd_vllm.sh`
  passed after adding compact-profile labels and hard-subset mode support.
- 2026-03-26:
  `ruff check tests/revolution/test_qd_descriptors.py tests/scripts/test_run_qd_theory_followup_manifest.py tests/scripts/test_run_qd_theory_followup_vllm.py tests/scripts/test_run_qd_theory_grounded_smoke_vllm.py tests/scripts/test_run_hard_iteration_qd_vllm.py`
  passed.
- 2026-03-26:
  `python -m pyright --pythonpath /workspace/.venv/bin/python tests/revolution/test_qd_descriptors.py tests/scripts/test_run_qd_theory_followup_manifest.py`
  passed.
- 2026-03-26:
  `pytest tests/revolution/test_qd_archive.py tests/revolution/test_qd_engine.py -q`
  passed after adding the CVT run-end fallback initialization path.
- 2026-03-26:
  `ruff check src/revolution/qd/archive.py src/revolution/qd/artifacts.py src/revolution/qd/engine.py tests/revolution/test_qd_archive.py tests/revolution/test_qd_engine.py`
  passed.
- 2026-03-26:
  `python -m pyright --pythonpath /workspace/.venv/bin/python src/revolution/qd/archive.py src/revolution/qd/artifacts.py src/revolution/qd/engine.py`
  passed.
- 2026-03-26:
  Stage 9A code review confirmed the Rent confidence-gating change stays local
  to graph extraction, descriptor registry metadata, and profile wiring. Raw
  Rent metrics are still emitted unchanged for offline analysis; only the full
  theory profile axis changes.
- 2026-03-26:
  `/workspace/.venv/bin/pytest tests/revolution/test_graph_descriptor_evaluator.py tests/revolution/test_qd_descriptors.py tests/scripts/test_report_qd_rent_reference_validation.py -q`
  passed with `28 passed`.
- 2026-03-26:
  `/workspace/.venv/bin/ruff check src/revolution/graph_descriptor_evaluator.py src/revolution/qd/descriptors.py tests/revolution/test_graph_descriptor_evaluator.py tests/revolution/test_qd_descriptors.py`
  passed.
- 2026-03-26:
  `/workspace/.venv/bin/python -m pyright --pythonpath /workspace/.venv/bin/python src/revolution/graph_descriptor_evaluator.py src/revolution/qd/descriptors.py`
  passed.
- 2026-03-26:
  `/workspace/.venv/bin/python scripts/qd_descriptor_probe.py --archive_type cvt --profile theory_grounded_full_20d`
  confirmed the full theory profile now resolves
  `rent_exponent_confidence_gated` while keeping `requires_graph_metrics=true`.
- 2026-03-26:
  `/workspace/.venv/bin/pytest tests/scripts/test_report_qd_rent_reference_validation.py -q`
  passed with `7 passed` after extending the report to track raw and
  confidence-gated Rent side by side and after adding the out-of-range
  RentCon parser regression test.
- 2026-03-26:
  `/workspace/.venv/bin/ruff check scripts/report_qd_rent_reference_validation.py tests/scripts/test_report_qd_rent_reference_validation.py`
  passed after the Stage 9B report updates.
- 2026-03-26:
  `/workspace/.venv/bin/python -m pyright --pythonpath /workspace/.venv/bin/python scripts/report_qd_rent_reference_validation.py`
  passed after the Stage 9B report updates.
- 2026-03-26:
  `/workspace/.venv/bin/python scripts/report_qd_rent_reference_validation.py --run_root /workspace/.worktrees/hard-iteration-subset-qd/exp/hard_iteration_qd_5way_standard20x5_warmup16_unconstrained_20260326_032529 --output_root /workspace/.worktrees/qd-theory-grounded-descriptors/exp/qd_rent_reference_validation_hard_subset_20260326_stage9b_final --workers 1 --repo_root /workspace/.worktrees/qd-theory-grounded-descriptors`
  completed and wrote the corrected Stage 9B bundle under
  `/workspace/.worktrees/qd-theory-grounded-descriptors/exp/qd_rent_reference_validation_hard_subset_20260326_stage9b_final/final_analysis`.
- 2026-03-26:
  Stage 9B code review confirmed the report changes stay local to the offline
  reference-validation surface. The live QD runtime still emits the same raw
  graph metrics; only the comparison/reporting layer changed.

## Stage 7A Results

- Added the builtin reduced theory profile `theory_grounded_compact_8d`.
- Added hard-subset mode `cvt_theory_grounded_compact` so the compact profile
  can be run directly from `scripts/run_hard_iteration_qd_vllm.sh`.
- Added compact-profile labels to the theory smoke and follow-up shell harnesses
  and to the checked-in follow-up manifest.
- Updated the user-facing docs so the compact profile is documented as the
  reduced follow-on candidate from the Stage 6 hard-subset collapse pass.
- Stage 7A completed the profile and harness wiring half of the follow-up plan.

## Stage 9A Results

- Rent extraction now returns both the raw `rent_exponent` and a
  `rent_exponent_confidence_gated` variant that shrinks weak fits toward a
  neutral `0.5` value.
- The confidence signal is intentionally simple and readable: it combines
  retained sample count, graph size, retained/raw sample ratio, fit quality,
  and a clamp penalty with early returns for empty cases.
- The full theory profile now uses `rent_exponent_confidence_gated`, while raw
  Rent diagnostics remain available in `graph_metrics` for reporting and
  offline calibration.
- Descriptor registry metadata, default bounds, tests, and user-facing docs now
  all describe the same safer Rent policy.

## Stage 9B Results

- `scripts/report_qd_rent_reference_validation.py` now carries both raw and
  confidence-gated Rent through the comparison payload, summary metrics,
  markdown report, and accuracy plot.
- The report now records whether confidence gating beats the raw exponent on a
  per-case absolute-delta basis, along with low-confidence case counts and the
  confidence value used by the runtime.
- The RentCon fast-path parser now applies the same out-of-range filtering as
  the fallback parser, which removes malformed graph-traversal `500+` values
  from the summary.
- The corrected Stage 9B final bundle is at:
  `/workspace/.worktrees/qd-theory-grounded-descriptors/exp/qd_rent_reference_validation_hard_subset_20260326_stage9b_final/final_analysis`
- Stage 9B conclusion:
  - CP Type I remains the only useful reference target on this corpus.
  - Confidence gating did not improve CP Type I mean absolute error on the
    tiny comparable subset:
    `mean_abs_cp_type1_delta_raw=0.201490`,
    `mean_abs_cp_type1_delta_gated=0.221993`,
    `cp_type1_mean_abs_delta_improvement=-0.020503`.
  - Confidence gating did improve the CP Type I median absolute delta:
    `0.231087` raw to `0.208348` gated, and it improved `2 / 4` CP-comparable
    cases.
  - Confidence gating clearly improved the cleaner GT Type I comparison after
    parser repair:
    `mean_abs_gt_type1_delta_raw=0.282649`,
    `mean_abs_gt_type1_delta_gated=0.106178`,
    `gt_type1_mean_abs_delta_improvement=0.176471`,
    with `3 / 4` GT-comparable cases improved.
  - Runtime overhead is still negligible:
    `internal_total_seconds_mean=0.020551`,
    `rent_fit_seconds_mean=0.000542`,
    `reference_total_seconds_mean=0.523847`,
    `reference_over_internal_ratio_mean=25.793383`.
  - The gating change should therefore remain framed as a safer archive-facing
    policy and a better report diagnostic, not as a demonstrated CP-calibration
    improvement.

## Stage 7B Results

- Added `CVTArchive.finalize_pending()` so a run can initialize from its
  current warmup buffer at shutdown when the configured warmup target was never
  reached.
- QD engine shutdown now finalizes pending CVT archives once, refreshes the
  success view, and writes a final snapshot with `phase=run_finalization_fallback`.
- `centroids.json` and `archive_space.json` now record
  `initialization_mode`, `initialization_sample_count`, and
  `warmup_buffer_size`, and the archive-space report calls out fallback
  initialization explicitly.
- The normal warmup path is unchanged while the run is active; the fallback only
  applies at the end of the run.
- Remaining Stage 7 work is experiment reruns: the hard subset still needs to
  be rerun with the compact profile and the new fallback enabled so the effect
  on coverage, QD score, and problem-level collapse can be measured directly.

## Stage 6 Results

- Theory hard-subset run root:
  `/workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_grounded_20x5_warmup16_unconstrained/20260326_160434/cvt_theory_grounded`
- Final comparison bundle:
  `/workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_theory_vs_baseline_20260326_160434/final_analysis`
- Final bundle recommendations:
  - overall winner: `classic`
  - score-focused QD winner: `cvt_large_struct10d`
  - archive-focused QD winner: `cvt_theory_grounded`
  - multi-objective / pareto winner: `classic`
- Theory hard-subset aggregate metrics:
  - `functionality_mean=0.3660`
  - `synthesis_mean=0.2942`
  - `qd_coverage_mean=0.4087`
  - `qd_score_mean=0.7261`
  - `qd_best_quality_mean=0.2401`
  - `pareto_hypervolume_mean=0.0858`
  - `pareto_point_count_mean=2.0`
  - `pareto_reference_beating_mean=5.62`
  - `runtime_seconds_mean=3326.24`
- Comparison takeaways:
  - vs `classic`: theory lost on functionality, synthesis, hypervolume, pareto
    point count, reference-beating count, and runtime.
  - vs `cvt_large_struct10d`: theory gained archive coverage (`+0.1202`) and
    QD score (`+0.2692`) but lost best quality (`-0.0436`) and slightly lost
    pareto hypervolume (`-0.0010`).
  - vs `cvt_size_control_3d`: theory gained archive coverage (`+0.1010`) and
    slightly improved pareto hypervolume (`+0.0037`) but slightly lost QD
    score (`-0.0061`) and clearly lost best quality (`-0.0256`).
  - The current 20D theory profile behaves more like an archive-filling profile
    than a score-optimizing profile.
- Run-level feature diversity:
  - run-level feature-analysis artifacts for the theory backend are in
    `final_analysis/feature_analysis/backends/cvt_theory_grounded/`
  - run-level histogram file:
    `final_analysis/feature_analysis/backends/cvt_theory_grounded/feature_histograms.png`
  - run-level embedding views:
    `pca_fitness.png` and `tsne_fitness.png`
  - run-level summary reports `459` successful candidates and `85` final elites
  - only the global physical proxy features `ltp_noff` and `utilization`
    collapsed at the run level, which matches the earlier structural baselines
- Problem-level feature diversity:
  - per-problem histogram artifacts were written under each theory-run problem
    directory in `qd_feature_histograms/`
  - three problems never initialized CVT centroids:
    - `RTLLM/Prob037_parallel2serial` (`11` successes, below the `16`
      warmup threshold)
    - `VerilogEval-Spec-to-RTL/Prob151_review2015_fsm` (`4` successes)
    - `VerilogEval-Spec-to-RTL/Prob153_gshare` (`8` successes)
  - these cases finished with `centroid_count=0`, `coverage=0.0`, and
    `qd_score=0.0`, so they are a real source of archive-health instability for
    the current configuration
- Axis-collapse findings from the theory-only hard-subset follow-up summary:
  - collapsed in at least one problem:
    `laplacian_lambda2`, `reconv_sink_ratio`, `reconv_source_ratio`,
    `rent_exponent`, `scoap_cc0_bin_2_pct`, `scoap_cc0_bin_3_pct`,
    `scoap_cc1_bin_2_pct`, `scoap_cc1_bin_3_pct`, `scoap_co_bin_1_pct`,
    `scoap_co_bin_2_pct`
  - strongest consistently non-collapsed axes:
    `scoap_signal_smoothness`, `laplacian_spectral_entropy`,
    `scoap_cc0_bin_1_pct`, `scoap_co_bin_3_pct`, `scoap_cc1_bin_1_pct`,
    `scoap_co_bin_0_pct`, `scoap_cc0_bin_0_pct`, `scoap_cc1_bin_0_pct`
  - emitted compact candidate:
    `theory_grounded_compact_candidate_8d`
- Stage 6 conclusion:
  - `theory_grounded_full_20d` is promising for archive coverage and descriptor
    richness, but it is not yet the best choice when the goal is pure quality
    improvement or broad pareto strength.
  - The next code/data follow-up should focus on a reduced theory profile and a
    more robust centroid-initialization strategy for low-success problems.
- Stage 8 conclusion:
  - The repo-native Rent path is fast:
    mean internal wall time was `0.020968s`, and the Rent-fit portion itself
    averaged `0.000560s` across the five parseable cases.
  - The native RentCon reference path is much heavier:
    mean reference wall time was `0.514413s` per case
    (`0.331768s` OpenROAD DEF generation plus `0.182646s` RentCon), or about
    `24.85x` slower than the repo-native extractor.
  - Accuracy is not good enough yet on the CP-comparable subset:
    mean absolute delta vs circuit-partitioning Type-I Rent was `0.201490`
    with median `0.231087`, max `0.252282`, and paired Pearson correlation
    `0.246132`.
  - The current internal extractor frequently collapses to boundary values:
    4 of 5 parseable cases produced `rent_exponent` values at `0.0` or `1.0`,
    and 2 of 5 kept only `1-2` retained samples.
  - Concrete examples from the final bundle:
    `Prob004_adder_8bit` was `1.000000` internally vs `0.908496` from RentCon
    CP Type I; `Prob024_fsm` was `1.000000` vs `0.752423`;
    `Prob135_m2014_q6b` was `0.550340` vs `0.764936`;
    `Prob151_review2015_fsm` was `1.000000` vs `0.747718`.
  - The RentCon binary itself is unstable on this corpus:
    only 5 of 13 staged hard-subset cases yielded any parseable reference
    output, all 5 of those still exited non-zero, and 8 cases produced no
    parseable summary at all.
  - The next Rent-specific fixes should be:
    add explicit confidence gating for low-node / low-sample cases, avoid
    promoting clamped `rent_exponent` values as if they were high-confidence,
    and revisit the recursive-partition regression policy against
    circuit-partitioning Type-I behavior before expanding Rent-heavy profiles.
  - Stage 9A follows directly from that conclusion by keeping the raw slope for
    analysis while using a safer profile-facing axis in the archive tuple.
  - Stage 9B confirms that the new confidence-gated report view is useful for
    diagnostics, but it does not change the core calibration conclusion: the
    repo-native Rent path is still fast and still not accurate enough to claim
    direct CP Type I agreement on this corpus.

## Stage 10 Results

- Stage 10 screening run root:
  `/workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_archive_tuning_screen_20260326/20260326_184428`
- Stage 10 final bundle:
  `/workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_archive_tuning_screen_20260326/20260326_184428/final_analysis`
- Screened modes on the frozen 13-problem hard subset with the same
  `size_control_3d` profile and the same `12 x 3` budget:
  - `grid_size_control`
  - `cvt_size_control_default`
  - `cvt_size_control_fill50`
  - `cvt_size_control_warmup2`
  - `cvt_size_control_dense24`
- Family decision:
  prefer `cvt` over `grid` for the hard-subset workflow.
  On the same profile and budget, `cvt_size_control_default` beat
  `grid_size_control` on:
  - `synthesis_mean`: `0.3670` vs `0.3189`
  - `qd_coverage_mean`: `0.3269` vs `0.0986`
  - `qd_score_mean`: `0.4931` vs `0.3778`
  - `qd_best_quality_mean`: `0.2094` vs `0.1455`
  - `mean_hypervolume`: `0.0686` vs `0.0524`
  while staying close on runtime:
  `1299.82s` vs `1263.08s` mean runtime per problem.
- CVT knob results:
  - Keep `qd_fill_target_fraction=0.25`.
    `fill50` was faster, but it clearly regressed synthesis, coverage, QD
    score, best quality, Pareto breadth, and mean hypervolume.
  - Keep `qd_cvt_warmup_successes=4` as the balanced default.
    `warmup2` raised `functionality_mean` and `synthesis_mean`
    (`0.5192` / `0.4327`), but it gave back archive-health and QD quality:
    `qd_coverage_mean=0.3029`, `qd_score_mean=0.2871`,
    `qd_best_quality_mean=0.1698`, `mean_hypervolume=0.0652`.
  - Keep `qd_num_cells=16` as the balanced default.
    `dense24` improved `mean_hypervolume` to `0.0931`, but it regressed
    `functionality_mean`, `synthesis_mean`, `qd_coverage_mean`,
    `qd_score_mean`, and `qd_best_quality_mean` versus the `16`-cell default.
  - Keep `qd_cell_reservoir=2`.
    The screen did not show a reason to change it, so it stays explicit but
    unchanged.
- Final hard-subset recommendation:
  - recommended archive family: `cvt`
  - recommended compact control profile: `size_control_3d`
  - recommended archive settings:
    `qd_num_cells=16`,
    `qd_cvt_warmup_successes=4`,
    `qd_fill_target_fraction=0.25`,
    `qd_cell_reservoir=2`
- Recommendation interpretation:
  - `hard_iteration_analysis` chose `cvt_size_control_warmup2` as the overall
    winner because that report prioritizes synthesis-heavy aggregate outcomes.
  - For QD default policy, the more relevant winner is the balanced archive
    configuration: `cvt_size_control_default`.
    It best preserved archive coverage, QD score, best quality, and strong
    Pareto behavior without a meaningful runtime penalty.
- Collapse / diversity findings:
  - every screened backend collapsed only the same two physical proxy features
    at run level: `ltp_noff` and `utilization`
  - the strongest archive-bearing success counts were:
    - `cvt_size_control_warmup2`: `270` successful candidates
    - `cvt_size_control_default`: `229`
    - `grid_size_control`: `199`
  - but final elite counts and archive quality still favored the balanced CVT
    default:
    - `cvt_size_control_default`: `68` elites
    - `cvt_size_control_dense24`: `67`
    - `cvt_size_control_warmup2`: `63`
    - `cvt_size_control_fill50`: `55`
    - `grid_size_control`: `41`
- Stage 10 conclusion:
  - hard-subset QD defaults should stay CVT-based, not grid-based
  - the balanced default remains the existing `16 / 4 / 0.25 / 2` CVT pack,
    now made explicit in the emitted subset config and docs
  - `warmup2` is a useful opt-in variant when raw synthesis pass rate matters
    more than archive quality
  - `dense24` is a useful Pareto-leaning opt-in variant when hypervolume is the
    main objective
  - the evidence is not strong enough to flip the repo-wide `run_backend.py`
    CLI default from `grid` to `cvt`, because the hard-subset result is
    workflow-specific and the current global CVT warmup semantics at the CLI
    default cell count would be misleading as a blanket repo-wide default
- Validation:
  - `bash scripts/run_hard_iteration_qd_vllm.sh --config data/configs/hard_iteration_subset_qd_archive_tuning.yaml --mode matrix`
  - `python scripts/report_final_analysis_bundle.py --run-root /workspace/.worktrees/qd-theory-grounded-descriptors/exp/hard_iteration_qd_archive_tuning_screen_20260326/20260326_184428 --subset-config data/configs/hard_iteration_subset_qd_archive_tuning.yaml`
  - `pytest tests/scripts/test_build_hard_iteration_subset.py tests/scripts/test_run_hard_iteration_qd_vllm.py -q`
  - `ruff check scripts/build_hard_iteration_subset.py tests/scripts/test_build_hard_iteration_subset.py tests/scripts/test_run_hard_iteration_qd_vllm.py`
  - `python -m pyright scripts/build_hard_iteration_subset.py`

## Stage 10A Results

- `scripts/run_hard_iteration_qd_vllm.sh` now supports config-driven tuning
  matrices:
  - `--mode matrix` uses `matrix_modes` from the config when present
  - `--mode <name>` can target any named mode declared in the config
  - each mode can now override `qd_num_cells`,
    `qd_cvt_warmup_successes`, `qd_fill_target_fraction`, and
    `qd_cell_reservoir`
- The hard-subset manifest now records the resolved per-mode archive settings,
  which makes later report review and parameter audits easier.
- The harness still keeps the control flow simple:
  read config, resolve a concrete mode list, resolve per-mode overrides, write
  them to the manifest, then build one explicit `run_backend.py` command per
  mode.
- Code review outcome:
  no issues found in the Stage 10A harness diff. The new logic only exposes
  active runtime knobs and deliberately avoids adding dead or misleading
  surfaces such as `qd_neighbor_k`, which is not currently consumed by the
  runtime.
- Validation:
  - `bash -n scripts/run_hard_iteration_qd_vllm.sh`
  - `pytest tests/scripts/test_run_hard_iteration_qd_vllm.py -q`
  - `ruff check tests/scripts/test_run_hard_iteration_qd_vllm.py`

## Remaining Validation / Experiment TODOs

- [x] Run full `pytest`.
- [x] Add a repeatable theory-grounded smoke/comparison harness with dry-run
  coverage.
- [x] Add a manifest-driven Rent calibration/report workflow.
- [x] Add a bounded theory follow-up matrix harness and report workflow.
- [x] Add a manifest-driven broader theory follow-up runner and decision
  report workflow.
- [x] Add a synthesized-netlist Rent reference-validation harness that stages
  hard-subset netlists, generates DEFs, runs RentCon, and reports
  accuracy/runtime deltas.
- [ ] Run a broader theory-profile smoke matrix over both RTLLM and
  VerilogEval with the Stage 7 compact profile and non-trivial
  population/generation budgets.
- [ ] Save or vendor a stable small calibration set of RentCon outputs so
  `scripts/qd_theory_descriptor_probe.py` can report concrete deltas without
  depending on the unstable local RentCon binary.
- [x] Inspect archive-side descriptor-health behavior for the SCOAP histogram
  axes; the hard-subset run shows that several higher-score bins do collapse and
  should be pruned or demoted in the next profile iteration.
- [ ] Rerun the hard-subset comparison with the compact theory profile and
  compare it directly against the full theory profile and structural controls.
- [x] Prototype a warmup / centroid-init fallback for problems that never reach
  the current success threshold.
- [ ] Evaluate the new warmup fallback on the compact-profile hard-subset rerun
  and confirm that low-success problems no longer finish with empty archives.
- [x] Add Rent confidence gating for graphs with too few retained samples or
  obviously clamped fits.
- [x] Rerun the reference validation bundle after the confidence-gating change
  and measure whether the new diagnostics reduce misleading boundary cases.
- [x] Finish Stage 10A by landing the config-driven hard-subset tuning matrix
  support in the runner and tests.
- [x] Run the Stage 10B hard-subset archive-tuning screen for grid vs CVT plus
  the active CVT knobs.
- [x] Freeze the Stage 10 tuning decision into the hard-subset config and
  runner defaults, then document the rationale and evidence.
- [ ] Decide whether the current repo-native Rent fit should target
  circuit-partitioning Type I specifically, or whether it should become a
  different named metric that is documented as only loosely Rent-like.
- [ ] Decide whether report-side CP comparisons should stay raw-only by
  default, with confidence-gated values kept as a safety diagnostic rather than
  the headline accuracy metric.

## Open Questions

- Does the 20D profile produce useful archive diversity, or is a reduced
  subspace needed to avoid CVT dilution?
- Is the current Rent fit stable enough across small synthesized graphs, or
  should the recursive partition flow add stronger trimming, confidence
  filters, or a stricter minimum sample/node threshold?
- Should SCOAP histograms remain raw percentages, or should future follow-on
  profiles compress them through PCA or hand-picked summary ratios?
- Are there benchmark families where graph extraction from raw RTL should be
  replaced with post-`techmap` or post-`abc` graphs for better comparability?
- What is the right fallback when a CVT profile has a high warmup target but a
  problem never produces enough successful candidates to initialize centroids?
- Should the repo continue to rely on the shipped RentCon binary for native
  comparison, or should it move to a checked-in calibration corpus because the
  local binary is too unstable for unattended batch use?

## Roadmap

- Short term:
  add the compact theory candidate as a builtin profile and rerun the hard
  subset against `implemented_structural_fixed_5d`, `large_struct10d`, and
  `size_control_3d`.
- Medium term:
  rerun the hard subset with `theory_grounded_compact_8d` using the tuned
  hard-subset CVT policy (`16 / 4 / 0.25 / 2`), then compare the compact
  profile against the full theory profile now that the full profile no longer
  uses raw unclipped Rent extremes directly.
- Medium term:
  rerun confidence-gated Rent calibration against a stable reference corpus and
  decide whether `rent_k`, retained-sample counts, or fit-quality diagnostics
  should directly influence profile selection or report-side warnings, and
  decide whether raw or confidence-gated Rent should remain the headline
  CP-comparison metric in offline reports.
- Medium term:
  decide whether centroid warmup should be adaptive, reduced, or bypassed with
  a fallback archive-init path on low-success problems.
- Longer term:
  explore additional graph-signal descriptors, sequential-boundary-aware graph
  variants, and benchmark-family-specific descriptor gating.
