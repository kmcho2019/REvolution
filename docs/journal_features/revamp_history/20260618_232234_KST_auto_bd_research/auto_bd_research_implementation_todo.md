# Automatic BD Research Implementation TODO

Line limit: 160 lines. Keep this checklist concise and update it as work
lands. A future `/goal` must check every item or mark it out of scope with
evidence and rationale.

## P0 - Scope And Locks

- [x] Read `START_HERE.md`, `auto_bd_research_plan.md`, and
  `auto_bd_plan_sketch.md`.
- [x] Read `auto_bd_ruminations.md` as the initial intent record.
- [x] Preflight `curl http://20.0.0.103:8000/v1/models` and record the
  available `gpt-oss-120b` model ID.
- [x] Confirm any vLLM launch/config uses `max_model_len >= 131072`.
- [x] Confirm REvolution runs use `--max_tokens 128000` and
  `--diff_max_tokens 128000` except tiny smokes.
- [x] Select and lock the development subset from RTLLM/VerilogEval.
- [x] Select and lock the main subset from RTLLM/VerilogEval.
- [x] Select and lock the held-out subset; keep it unused until final
  method selection.
- [x] Build the benchmark task catalog with inclusion/exclusion decisions.
- [x] Record objective exclusion reasons for any skipped benchmark problem.
- [x] Freeze seeds, model, phase budgets, and baseline-arm policy.
- [x] Freeze prompt hashes, timeout policy, and tool versions in run
  manifests.
- [x] Freeze worker/thread/scheduler policy for comparable multithreaded
  runs.

## P1 - Baselines And Gate 0

- [x] Reproduce original REvolution on the development subset.
- [x] Reproduce landing Smooth-QD manual-BD / NSGA-II baseline on the
  development subset.
- [x] Record classic REvolution valid-PPA coverage set `C`.
- [x] Verify Gate 0: candidate Auto-BD methods must cover every problem in
  `C`.
- [x] Report `C_problem` and `C_problem_seed` coverage deltas.
- [x] Add or identify report inputs for functionality, synthesis,
  OpenROAD, valid-PPA, PPA, and QD metrics.
- [x] Add canonical synthesized-netlist hash extraction for valid
  candidates and elites.
- [x] Define motif-signature and PPA-relevant uniqueness checks.
- [x] Define common audit descriptor space and fixed binning.
- [x] Define PPA/hypervolume normalization, nadir points, clipping, and
  invalid-candidate handling.
- [x] Confirm method artifacts will be organized under
  `20260618_232234_KST_auto_bd_research/auto_bd_methods/`.

## P2 - Controls

- [x] Implement random descriptor QD.
- [x] Ensure random descriptor control is deterministic per candidate.
- [x] Implement simple Yosys-stat BD.
- [x] Produce method cards for both controls.
- [x] Generate per-method reports for both controls.
- [x] Write accept/reject decisions for both controls.
- [x] Use control results to sanity-check the report and gates.

## P3 - First Auto-BD Methods

- [x] Implement netlist motif occupancy descriptor.
- [x] Add motif extraction tests with small Yosys JSON/netlist fixtures.
- [x] Add descriptor stability tests for signal renaming.
- [x] Add descriptor stability tests for formatting-only RTL changes.
- [x] Run development subset and generate the method report.
- [x] Write accept/reject decision before moving to ST-NOD.

## P4 - ST-NOD

- [x] Implement synthesis-stage dump script writer.
- [x] Wire observational dump execution behind the ST-NOD method arm.
- [x] Add ST-NOD observational-equivalence test against baseline synthesis.
- [x] Implement synthesis-trajectory feature extraction.
- [ ] Combine trajectory features with motif occupancy.
- [ ] Compare motif-only versus trajectory-motif descriptors.
- [x] Verify in-loop descriptor cost is acceptable or cached.
- [x] Run development subset and generate the method report.
- [x] Write accept/reject decision with Gate 0 explicitly evaluated.

## P5 - Learned Or Codebook Variants

- [ ] Try PCA/random projection over stable motif/trajectory vectors before
  neural methods.
- [ ] Define descriptor fitting protocol and frozen fitting artifacts for
  any projected/learned method.
- [ ] Implement AURORA-style encoder only if fixed-vector methods are
  stable but insufficient.
- [ ] Implement VQ/codebook descriptor only if codebook regions can be
  labeled by motif/trajectory enrichment.
- [ ] Keep method cards, reports, and accept/reject decisions for rejected
  learned/codebook variants.
- [ ] Verify experimental modes do not spread backend logic across
  unrelated call sites or create unnecessary abstractions.

## P6 - Reporting

- [x] Implement per-method report generation from artifacts.
- [x] Emit standardized results files and `run_manifest.json`.
- [x] Include robustness funnel and failure breakdown.
- [x] Include PPA anytime and hypervolume curves.
- [x] Include QD score, coverage, entropy, and archive visualizations.
- [x] Include descriptor/manual-BD/PPA correlation heatmaps.
- [x] Include canonical-netlist uniqueness and duplicate-cell leakage.
- [x] Include common-audit archive QD score and coverage.
- [x] Include motif-signature and PPA-relevant diversity.
- [x] Include representative elite examples.
- [x] Implement centralized cross-method report generation.
- [x] Include leaderboard, gate matrix, per-problem win/loss matrix, and
  compute-cost comparison.
- [x] Link any large `exp/` artifacts from reports instead of copying them
  into docs.

## P7 - Main And Held-Out Evaluation

- [ ] Predeclare final sign-off thresholds after baseline MDE/power review.
- [ ] Promote only methods that pass development-subset Gate 0 and
  robustness gates.
- [x] Produce seed-1 preliminary reports for fast sanity checks.
- [ ] Produce seed-3 screening reports for promoted methods.
- [ ] Select the simplest passing method by predeclared gates.
- [ ] Produce seed-5 final report for the selected method when compute
  permits.
- [ ] Run held-out validation only after final method selection.
- [ ] Run stronger functional correctness audit on finalists.
- [ ] Re-run PPA extraction for best elites and hypervolume contributors.
- [ ] Draft final selected method spec and paper-section outline.

## P8 - Validation And Handoff

- [ ] Run focused tests for touched code.
- [ ] Run `ruff check` on touched files.
- [ ] Run `uv tool run ty check <touched source modules>` as the primary
  Auto-BD type check.
- [ ] Run `python -m pyright` on touched source modules as secondary
  compatibility evidence while repo guidance still requires it.
- [ ] Verify new public interfaces have useful type hints and docstrings.
- [ ] Verify comments are sparse and clarify only non-obvious logic.
- [ ] Verify required loaded data uses asserts or explicit validation
  rather than broad fallback defaults.
- [ ] Verify method-family handling is exhaustive and fails on unknown
  descriptor/method kinds.
- [ ] Record all commands, artifacts, failures, and decisions in
  `auto_bd_research_implementation_history.md`.
- [ ] Run adversarial validation using
  `auto_bd_research_adversarial_prompt.md`.
- [ ] Resolve FAIL findings or mark the goal blocked with exact missing
  evidence.
