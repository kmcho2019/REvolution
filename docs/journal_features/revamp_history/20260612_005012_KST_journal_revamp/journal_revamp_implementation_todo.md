# Journal Revamp Implementation TODO

v2 structure (2026-06-12): open items grouped by the v2 plan phases
(`journal_revamp_plan.md`); the completed phase-0 foundations log is
preserved verbatim at the bottom. The v2 adversarial sign-off requires
EVERY item below checked AND spot-verified against artifacts.

## P1 — QD repair
- [x] OPERATIONAL: GPU handed off (canary /workspace/GPU_7_FREE_20260612_121425 with evidence trail) after the hard-subset pair completed (canary /workspace/GPU_7_FREE_*); all subsequent LLM runs use --api_backend openrouter (same-provider-both-arms rule for anything gate-bearing).
- [x] Reproduce current QD underperformance against classic on hard subset (9-problem genuine intersection, seed 42, 20x5: best-quality -0.080, 2W/7L, functionality 9/9 ties - deficit is pure PPA quality; run exp/fast_iter/hard_subset_42, ledgered; 11-problem hybrid caveat recorded).
- [ ] Root-cause descriptor collapse, archive occupancy, parent selection, repair budget, and thought/code mismatch.
- [ ] Fix QD performance issues or narrow claims explicitly (screens closed: narrowing per Branch C; ablation matrix RUNNING exp/ablation_matrix; regime-scoped positives - failure-regime near-parity and pass-rate recovery - go into the narrowed claim set).
- [x] Ensure repair and k-code samples are charged as real budget (charging verified in summary accounting; scripts/report_budget_parity.py measures arm parity: hard-subset-42 verdict CONFOUNDED - QD +12.5% calls / +25.3% completion tokens / -29.7% prompt tokens vs classic at equal pop x gens; classic wins with less compute - disclose in narrative, and any promoted-fix hard-subset pair must report this artifact; budget-matched protocol decision goes to the freeze).
- [ ] Freeze one final QD target config before final runs.
- [x] P1: Complete the corrected pop-12 calibration pair (classic vs QD target, seed 42) and run `validate_fast_iteration_pair.py` on it (G1-G3 FAILED: rule90 wall dominance, PPA-flow floor, 1/6 discrimination -> subset v2 required; report at exp/fast_iter/fast_iter_20260612b/gate).
- [x] Evaluate G4 screening validity (PASS: hard-subset 9-problem genuine intersection best-quality -0.080 with 2W/7L matches the fast-subset DEMOTE sign; both fast verdicts -0.086/-0.188).
- [x] Run the seed-1001 calibration pair for G5 stability (PASS: DEMOTE both seeds, -0.086 @ 42 vs -0.188 @ 1001, identical 0W/5L/1T shape; gates G1-G3 pass on both pairs).
- [x] INSTRUMENT SIGNED OFF at v3 (G1-G5 all pass; evidence: v3 + v3_s1001 gate reports, hard-subset intersection G4). Original line: Sign off `fast_iteration_subset_v1` or cut v2 (pilot evidence already flags `Prob108_rule90` wall-clock dominance and `Prob016_fixed_point_adder` PPA flow; any threshold recalibration must be recorded with rationale) and record the signoff decision in the revamp history.
- [x] P1: Fix QD thought-mode generation logging to record every evaluated code sample's PPA details (+ regression test) BEFORE any gate-bearing run (engine logs all_samples at both thought-mode sites; test_generation_log_records_all_evaluated_samples).
- [x] P1: Diagnose the QD gap from hard-subset-42 artifacts in plan order (history 2026-06-12 13:05: three regimes - realization pass-rate collapse on spec-exact problems via bad thought transcription, no failure feedback in fail-parent payloads, grid-quantile warmup never completing on 4/11 problems from journal-trio axis collapse; QD wins exactly where the archive formed).
- [x] P1: Screen repair candidates one factor at a time - ALL DEMOTED on quality bands (k=2 -0.141 penalized; R-C -0.165 with patience fired on 4/6; R-A' -0.126; R-B fast = baseline replication -0.177 coverage-limited; R-B failure-regime FULL mechanism -0.086 0W/2L/2T with pass rates m2014_q3 3->15%, circuit7 26->62%, fsmonehot 21->40% - mechanism works, does not convert to best-quality at this budget). Screen phase CLOSED; P1 proceeds per predeclared Branch C. Original framing: R-D k=2 (RUNNING, exp/fast_iter/k_ablation_k2), R-B failure feedback (--qd_operator_fail_feedback_chars 1200 + journal_thought_only_failfb profile; QUEUED behind k2 via exp/queue_after_k2.sh), R-A' spec-first realization template variant, R-C collapsed-axis warmup fallback (engine change; also the P2 coupling).
- [ ] P1: Run the predeclared 5-arm ablation matrix (narrative ablation section; seeds 1001-1003, hard subset) and record per-arm evidence.

## P2 — BD thesis
- [ ] Evaluate `logic_depth`, `ff_depth`, and `comb_width_log` descriptor health.
- [ ] Define candidate alternate behavior descriptor profiles before final experiments.
- [ ] Evaluate descriptor candidates for PPA improvement, diversity metrics, collapse, stability, and narrative strength.
- [ ] Compare against at least one simpler descriptor profile.
- [ ] Freeze the selected descriptor profile before final publication runs.
- [ ] Write descriptor rationale in `docs/journal_features/journal_narrative.md`.
- [ ] Verify descriptor gates.
- [ ] P2: Quantify descriptor-objective |correlation| per axis on tuning runs; replace or strip the diversity claim of any axis with |r| >= 0.8 to an objective.
- [x] P2: Pre-register the named candidate descriptor profiles BEFORE any bake-off run (doc 11_descriptor_profile_preregistration.md: journal_logic_ff_width_3d, journal_graph_testability_3d, activity_control_3d, journal_simple_2d; additive YAML registration validated via load_descriptor_profiles; added predeclared warmup-completion/collapse measurement motivated by the P1 diagnosis).

- [x] P2: Cross-validate logic_depth against yosys `ltp` - DONE with production evidence: the online cross-check (ltp -noff appended to the per-candidate yosys script, parsed into logic_depth_ltp/logic_depth_ltp_delta) persisted across the rb_failure_regime_v2 run with delta=0.0 on 31/32 candidates and delta=1.0 on one (the documented buffer-skip liberty); 14 ground-truth extractor tests remain in tests/revolution/test_graph_descriptor_evaluator.py.
- [ ] P2: Port and build RentCon, then cross-validate rent_exponent RANKINGS on the fast-subset netlists (relative axis: rank agreement, not absolute p). Recon 2026-06-13: vendored source bundles MLPart (min-cut partitioning - the classic Rent methodology, ideal reference); g++ 11 build fails on the bundled gsl's 2008 configure ('cannot create executables') and missing <strings.h> for strcasecmp; recipe = system libgsl or updated config.guess + forced includes/-fpermissive; then the Dockerfile layer.
- [ ] P2: Optionally add KaHyPar-based min-cut partitioning as a second Rent reference if RentCon proves insufficient; HAL/netlistx deprioritized (heavy frameworks, low marginal value over RentCon+yosys).

- [x] P2: Profile-agnostic axis rendering check DONE for 3-axis profiles (visualization.py _grid_quantile_layout: journal trio gets preferred render order, other 3-axis profiles fall back to natural order, degenerate axes downgrade to 2d mode; a 2-AXIS profile now renders via a virtual single-bin '(flat)' slice axis through the unchanged 3-axis pipeline, commit 6eaed4f274 - the 2-axis control arm is unblocked). Original: (risk item b; items a and c CLOSED with evidence 2026-06-13: every population_ppa_details consumer is collection-only or wanted the fuller data; the visualizer reads archive artifacts; additive ltp metrics are name-filtered by descriptor selection).
## P3 — Benchmark vetting
- [ ] Add CVDP absolute-only PPA path only if synthesis is reliable.
- [ ] Add RealBench synthesis/PPA support only when deterministic (manifest currently marks only dependency-free, support-free tasks `supports_synthesis: true`; synthesis flow itself not yet validated on them).
- [ ] Add a verilator-5 harness path behind the capability model (`functional_harness_kind: verilator_testbench`): per-candidate verilate+build+run with `Total mismatched samples` parsing; account for per-candidate C++ compile cost (seconds for small modules, minutes for e203_core) in budget/timeout settings.
- [x] Re-run the RealBench golden-validation sweep with the verilator fallback (build_realbench_manifest.py --validate --verilator-fallback): 17/22 exclusions RECOVERED (55/60 validated, 92%); v2 manifest at data/bench/RealBench_v2_sweep (sha 6b5bb5cb...) with rescued tasks marked verilator_testbench; 5 goldens compile-broken in both harnesses. Runtime root promotion + debug-subset/probe re-lock pend the retention-table EDA re-review (next item).
- [x] Narrative RealBench disclosure UPDATED pre-freeze (dual-harness capability-model description, v2 retention 55/60 with per-family table, same-harness-both-arms rule) and EDA-persona re-review RUN: one required finding applied - verilator two-state evaluation can under-detect X-propagation mismatches and the 17 rescued tasks have no iverilog cross-check, so their pass claims are scoped to two-state semantics with per-task harness marking. v1 text preserved in git history.
- [ ] Run local vLLM and DeepSeek on the RealBench model-capability probe.
- [ ] Freeze whether RealBench final claims use local vLLM or a symmetric DeepSeek arm.

## P4 — Gates
- [ ] Run seed-42 debug gate across hard subset, CVDP, and RealBench.
- [ ] Freeze benchmark lists, seeds, prompts, configs, scheduler policy, and tool versions.
- [ ] Run 5-seed final publication experiments.
- [ ] Verify reference-PPA suite gates.
- [ ] Verify CVDP functional pass-rate gate.
- [ ] Verify RealBench deterministic replay and any-pass gates.
- [ ] Verify scheduler gates.
- [ ] P4: Archive the MDE/power analysis (one-way ratchet: counts may rise, never fall; infeasible gate drops its claim).
- [x] P4: Build the 26-task fresh RealBench slice (data/configs/realbench_final_26_subset.yaml from the v2 sweep manifest: seed 1337, debug ids excluded, disjoint-verified, aes 3 / e203 15 / sdc 8). DONE PARTS: held-out 20-problem reference set verified disjoint from hard AND fast-v3 (audit 2026-06-12); fresh CVDP-30 locked at data/configs/cvdp_final_30_subset.yaml (seed 1337, 6x5 categories, debug ids excluded with provenance).
- [ ] P4: Add yosys equivalence spot-check tooling and run it on showcased candidates + sampled 10% of archive elites.
- [ ] P4: Emit the tool-provenance statement (exact iverilog/yosys/OpenROAD/verilator versions) with the config freeze.

## P5 — Manuscript
- [ ] Update journal manuscript methodology/results in `resources/journal_draft/`.
- [ ] Record final evidence paths in implementation history.

## Standing rules
- [ ] Record any proposed new method idea in implementation history before large experiments.
- [ ] Accept new method ideas only if they improve or preserve gates and strengthen the narrative.

## Completed — phase-0 foundations (preserved verbatim)
- [x] Create `feat/journal-revamp-20260612-005012-kst` from `wip/journal-extension-2026`.
- [x] Commit staged manuscript-resource setup before new revamp edits.
- [x] Generate goal-scaffold directory under `docs/journal_features/revamp_history/`.
- [x] Add top-level `docs/journal_features/08_journal_revamp_goal.md`.
- [x] Add pointer to the revamp goal from journal-feature index docs.
- [x] Add original ASP-DAC submission reading path to the revamp goal.
- [x] Add ruminations coverage audit to the revamp goal.
- [x] Add evolutionary-baseline archive references to revamp notes.
- [x] Add coding and git practice guardrails to revamp scaffold.
- [x] Add method-evolution rule allowing the seven pillars to change when evidence and narrative improve.
- [x] Read frozen conference intro/method/experiment/result files before manuscript edits.
- [x] Inspect `/workspace/baselines` before deciding whether FunSearch, CodeEvolve, or EoH comparisons need reruns.
- [x] Audit benchmark metadata and define capability schema.
- [x] Add tests for capability metadata and no-reference PPA suppression.
- [x] Implement CVDP task discovery for all records in `cvdp_v1.0.2`.
- [x] Build locked 10-task CVDP debug subset.
- [x] Implement CVDP functional harness integration (pre-existing CVDPEvaluator validated end-to-end via bounded stub-DUT smoke).
- [x] Implement RealBench manifest generation from `exp/RealBench`.
- [x] Build locked 12-task RealBench debug subset.
- [x] Implement RealBench functional harness integration (strict iverilog path; 38/60 golden-validated tasks; per-task validation and failure reasons recorded in the manifest).
- [x] Replace Verilator v4.036 with v5.030 (upstream's pinned version; v5-only `--binary`/`--timing`/`--coverage-line` flags required by the official harness). Dockerfile section 6 swapped (with `help2man`); live container replaced in place at /usr/local via sudo. Validated BEFORE replacing: official `make compile run` on 5 tasks spanning every iverilog failure class - all pass with 0 mismatches, including `sdc_controller` whose golden mismatched 21,852 samples under iverilog (harness-dialect artifact, not a bad golden).
- [x] Dockerfile QoL: passwordless sudo for the dev user, en_US.UTF-8 locale generation (kills the perl locale warnings), and ripgrep/jq/htop/vim/tmux/unzip/rsync — additive only, no version changes to pinned tools.
- [x] Add benchmark-family aware summary reporting (`per_benchmark` breakdown in `statistical_tests.json`; unit ids are seed/benchmark/problem so families never blend).
- [x] Add `scripts/validate_journal_revamp_run.py` (locked-coverage, config-seed, scheduler-telemetry, QD artifact/occupancy/collapse checks; JSON+MD reports; nonzero exit on failure).
- [x] Add seed manifest and rerun ledger outputs (`data/configs/journal_seed_manifest.yaml` pre-registers debug seed 42 and final seeds 1001-1005; `scripts/journal_rerun_ledger.py` appends launch records with git commit + config sha).
- [x] Add paired-delta and bootstrap statistical report outputs (`src/revolution/journal_stats.py` + `scripts/report_journal_statistics.py` emitting `paired_deltas.csv`, `statistical_tests.json`, `statistical_tests.md` with missing-treatment-as-loss and predeclared gate profiles).
- [x] Add non-echoing DeepSeek `DEEPSEEK_API_KEY` preflight documentation.
- [x] Build locked `realbench_long_model_probe` with at least 8 long RealBench tasks (`data/configs/realbench_long_model_probe.yaml`: 8 largest harness-validated tasks by prompt+harness+support bytes, all e203).
- [x] Audit `run_backend.py` elastic scheduling options for journal runs.
- [x] Audit `runtime/parallelism.py` for worker idle time and oversubscription.
- [x] Add scheduler telemetry: wall time, eval/sec, occupancy, wait/active time (coordinator event log + `summarize_scheduler_telemetry` + per-run `*_scheduler_telemetry.json` + evaluator timeout counters in summaries).
- [x] Add adaptive queueing or work stealing if telemetry shows idle workers (fair-share extra-slot granting replaces first-come-takes-all; a bounded re-poll variant was tried, measured harmful (-6 to -10% vs fixed), and removed with evidence recorded).
- [x] Build fixed evaluator replay or bounded smoke harness for scheduler gate (`scripts/run_scheduler_replay_benchmark.py`).
- [x] Show at least 25 percent scheduling wall-clock improvement with unchanged outcomes (46.0% at scale 0.5, identical outcome digests; evidence: `scheduler_gate_report_20260612.json`).
- [x] Create `docs/journal_features/journal_narrative.md` (revision 3 after three adversarial rounds; claims contract with measurement model, predeclared scales, branch lattice, ablation matrix, statistical protocol).
- [x] Build the fast-iteration validation subset for quick classic-vs-variant loops (`data/configs/fast_iteration_subset.yaml`, `scripts/build_fast_iteration_subset.py`, `docs/journal_features/09_fast_iteration_validation_set.md`): 6 high-functionality large-headroom problems, pop 12 × 3 gens ≈ 18% of hard-subset matrix cost; tuning artifact only, excluded from the future held-out set.
- [x] Define the fast-iteration instrument spec: requirements R1-R6, quantitative signoff gates G1-G5, PROMOTE/DEMOTE/INCONCLUSIVE decision bands, and the calibration protocol (doc 09) plus the mechanical per-pair checker `scripts/validate_fast_iteration_pair.py` (G1 wall/dominance, G2 PPA flow, G3 discrimination, verdict banding).
- [x] Run TCAD editor adversarial narrative review (BLOCK r1/r2 → SIGNOFF r3).
- [x] Run skeptical Reviewer 2 adversarial narrative review (BLOCK r1/r2/r3 → SIGNOFF r4).
- [x] Run hardware/EDA methodology adversarial narrative review (BLOCK r1/r2 → SIGNOFF r3).
- [x] Run reproducibility/statistics adversarial narrative review (BLOCK r1/r2 → SIGNOFF r3).
- [x] Revise narrative or downgrade claims until all personas sign off (narrative revision 3 accepted; 16 round-1 issues + consensus round-2/3 defects fixed in narrative and statistics code; records in `narrative_review_round1.md`, `narrative_review_round2_round3.md`).
