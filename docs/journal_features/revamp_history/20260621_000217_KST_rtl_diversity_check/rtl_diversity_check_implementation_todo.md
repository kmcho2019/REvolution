# RTL Diversity Check Experiment TODO

Line limit: 240 lines. Keep this checklist concise and update-oriented.
Move command details, failed attempts, artifact paths, and rationale to
`rtl_diversity_check_implementation_history.md`.

Central plan: `rtl_diversity_check_plan.md`.
Adversarial rubric: `rtl_diversity_check_adversarial_prompt.md`.

## P0 - Setup And Scope

- [x] Create `feat/journal-diversity-check-exp-20260620` from
  `feat/journal-auto-bd-exp-20260618`.
- [x] Move GPU devcontainer setup onto the diversity-check branch.
- [x] Mount the historical REvolution checkout read-only at
  `/aux/revolution-history`.
- [x] Confirm `nvidia-smi` works inside the devcontainer.
- [x] Confirm `/aux/revolution-history` is readable and not writable from
  the devcontainer.
- [x] Preflight `curl http://20.0.0.103:8000/v1/models` only if live runs or
  live model calls become necessary. Scoped: no live calls/runs were needed.
- [x] If live runs are needed, confirm `gpt-oss-120b` is served with
  `max_model_len >= 131072` and record token settings. Scoped: no live runs.
- [x] Record branch, HEAD, dirty state, and devcontainer image/container
  details in the history.
- [x] Confirm this is a post-hoc diagnostic goal, not a new in-loop QD
  method goal.
- [x] Read the 20260618 Auto-BD final negative decision and seed-3 screening
  report before designing new descriptor experiments.
- [x] Record that Yosys-stat, motif histogram, ST-NOD, projected SR,
  VQ/codebook, and random descriptor arms are existing control/negative
  evidence, not fresh default candidates.

## P1 - Corpus Inventory

- [x] Index current Auto-BD seed-1 and seed-3 `standard_results` roots.
  Scoped: seed-3 raw roots indexed; seed-1 centralized report ingested.
- [x] Ingest the 20260618 Auto-BD centralized reports and final negative
  decision as context for why new diagnostics are needed.
- [x] Index historical `exp/` roots under `/aux/revolution-history`.
- [x] Check whether an `aspdac2026-paper` checkout/worktree is available
  locally and index its `exp/` roots if present. Scoped: no local worktree;
  public `aspdac2026-submission` release archive was downloaded and indexed.
- [x] Index recoverable archived baselines from `baselines/`.
- [x] Emit a corpus coverage table with candidate counts and available
  code/netlist/PPA artifacts.
- [x] Label corpus strata as fully paired, partially paired, or unpaired.
- [x] Record missing-artifact patterns without adding broad fallback logic.
- [x] Mark small subsets as development/debug evidence only.
- [x] Identify the largest practical final-conclusion corpus, preferring
  broad RTLLM coverage when available. Superseded by ASP-DAC release coverage.
- [x] Use VerilogEval only when existing artifacts make it practical, or
  label its evidence as partial. ASP-DAC release includes VerilogEval.

## P2 - Candidate Audit Table

- [x] Define one simple candidate-level table for retrospective analysis.
- [x] Include method, seed, model, benchmark, problem, generation, operator,
  candidate id, code path, netlist path, validity funnel, PPA, and fitness.
- [x] Include existing canonical netlist hash, motif signature, descriptor
  vector, and archive cell fields when present.
- [x] Include descriptor/projection version and fitting-corpus hashes when
  fitted descriptors are used. Scoped: no fitted descriptor claim is used.
- [x] Assert required fields for standard-results inputs.
- [x] Keep outputs under `exp/diversity_check/`.

## P3 - Diagnostic Descriptors

- [x] Reuse existing structural descriptor outputs from the Auto-BD push
  where available instead of re-running failed arms by default.
- [x] Add Qwen3-Embedding-0.6B extraction for RTL/source text as a bounded
  diagnostic path. Phase 0 scoped this as blocked by missing `torch`; the
  restart requires dependency escalation before accepting blocker status.
- [x] Add Qwen dry-run mode that reports candidate text coverage without
  loading the model.
- [x] Check Qwen against identifier/comment stability and a lexical baseline.
- [x] Investigate DeepGate3 input requirements and record the minimum
  graph-export path needed.
- [x] Record whether DeepGate3 keeps, cone-splits, or drops sequential state.
  Scoped: DeepGate3 is absent; future run must settle graph-state policy.
- [x] Treat DeepSeq, NetTAG, CircuitFusion, larger Qwen models, and custom
  AURORA training as later-stage candidates only.
- [x] Defer custom AURORA/autoencoder training unless post-hoc evidence
  justifies it.
- [x] If AURORA-style training is later approved, record why pre-trained
  Qwen/DeepGate3 diagnostics were insufficient first. Scoped: not approved.

## P4 - First Post-Hoc Analyses

- [x] Implement cluster contribution analysis.
- [x] Implement oracle downsampling analysis.
- [x] Split downsampling into oracle-reconstructive and online-available
  variants.
- [x] Implement early diversity predictor analysis if generation data is
  available.
- [x] Implement parent-child jump analysis only when lineage is recoverable.
  Scoped: selected broad RTLLM artifacts do not expose lineage.
- [x] Implement shadow archive replay only after the audit table is stable.
- [x] Compare against best-fitness-only and random-selection controls.
- [x] Report diversity through the validity funnel and normalize by valid-PPA
  count.

## P5 - Reporting

- [x] Generate one concise report with tables and plots for the completed
  analyses.
- [x] Report paired problem/seed/method deltas where possible.
- [x] Separate development-subset findings from final-conclusion findings.
- [x] Base final conclusions on a large dataset run or retrospective corpus,
  preferably broad RTLLM coverage. Final uses broad RTLLM plus ASP-DAC.
- [x] Report whether each diversity layer is predictive, reconstructive,
  descriptive-only, or inconclusive.
- [x] Assign claim levels `L0` through `L5` and one final verdict from A-F.
- [x] Include the diversity-efficiency frontier plot.
- [x] Include visual case studies for positive, null, and negative outcomes.
- [x] Record case-study selection rules before narrative interpretation.
- [x] Include negative findings plainly.
- [x] State limits from missing artifacts, model/budget confounds, and
  unpaired corpora.

## P6 - Validation And Handoff

- [x] Add focused tests for corpus indexing and metric calculations.
- [x] Run focused pytest commands for touched tests.
- [x] Run `ruff check` on touched Python files.
- [x] Run type checks on touched source modules if source modules are added.
- [x] Update user-facing docs only for stable entry points. Scoped: experiment
  entry point is documented in the goal history/report, not promoted to README.
- [x] Record all command evidence and artifacts in the history.
- [x] Run adversarial validation.
- [x] Verify D-gate minimum evidence and descriptor-fitting leakage checks.
- [x] Resolve FAIL findings or mark exact blockers and missing evidence.

## Completion Gates

- [x] Phase 0 `rtl_diversity_check_plan.md` outcome is satisfied or explicitly
  narrowed with evidence for the generated ASP-DAC-backed report.
- [x] Phase 0 claims are not based only on partial sub-datasets.
- [x] Phase 0 broad claims do not rely only on archive occupancy or exact
  duplicate counts.
- [x] Phase 0 Auto-BD follow-up is not justified by the current utility gates.
- [x] Phase 0 code remains simple, typed where useful, and skimmable.
- [x] Phase 0 `rtl_diversity_check_subagent_validation_report.md` records PASS.

## Restart Notice - Phase 0 Is Not Final Sign-Off

- [x] Commit Phase 0 preliminary audit and archived derailed report before
  changing the plan. Commit: `a5fc5018ab`.
- [x] Treat the Phase 0 PASS as validating only the generated
  `B illumination_only` report, not the full research question.
- [x] Record in the history why Phase 0 stopped too early.
- [x] Re-read `original_notes/` and list the concrete methods Phase 0 did not
  attempt.

## WP0 - Deeper Diversity Necessity

- [x] Reconstruct ST-NOD / synthesis-response descriptor rows from available
  stage dumps, fitting artifacts, or Auto-BD sidecars.
  Scoped: seed-3 source parquets expose generated-candidate rows for all
  4,680 ST-NOD rows and all 4,680 SR random-ReLU PCA rows, but actual
  non-empty descriptor/common-audit vectors are valid-PPA-scoped.
  Artifact:
  `exp/diversity_check/wp0_stnod_sr_reconstruction_20260621_040536_UTC/`.
- [ ] Search historical corpora for lineage-rich generation logs with parent,
  operator, child, and descendant fields.
  Partial: current audit and checked Auto-BD ST-NOD/SR parquets have zero
  non-empty parent IDs; QD events preserve operator, origin pool, generation,
  archive fields, and quality, but not parent candidate IDs.
- [ ] Run parent-child jump or descendant-yield analysis on every corpus that
  exposes lineage; otherwise log the corpus search that proves none do.
- [ ] Compute diversity at 25%, 50%, 75%, and 100% of budget where generation
  metadata exists.
  Partial: computed for ST-NOD/SR seed-3 roots in
  `wp0_budget_curves.csv`; broader RTLLM/ASP-DAC generation curves remain
  open.
- [ ] Add online-available replay policies separate from oracle
  reconstructive replay.
- [ ] Add duplicate-suppression replay by canonical netlist hash and
  near-identical motif signature.
  Partial: `wp0_duplicate_suppression.csv` covers canonical netlist hash and
  exact motif-signature hash for ST-NOD/SR seed-3 roots. Near-identical motif
  distance and quality-gated novelty remain open.
- [ ] Report diversity through the generated, functional, synthesis-valid,
  valid-PPA, and Pareto-front funnels for each descriptor family.
- [ ] Add common-audit comparisons that do not let each descriptor define an
  easier archive space.

## WP1 - Real Encoder Diagnostics

- [x] Escalate Qwen3 dependencies before blocker status. Used an isolated
  environment after avoiding repo lockfile churn.
- [x] Create an isolated ignored encoder environment under
  `exp/diversity_check/encoder_envs/` and record the command.
- [x] Run real Qwen3-Embedding-0.6B extraction on a bounded corpus slice for
  raw, comment-stripped, and identifier-normalized RTL.
- [x] Add Yosys-normalized RTL to the Qwen3 probe.
- [x] Record first Qwen device, model id, artifact path/hash, runtime, and
  stability results.
- [x] Try DeepGate3 setup through `uv add`, a documented source checkout, or
  an isolated ignored environment before blocker status is accepted.
- [x] Export AIG/Yosys graph inputs for a bounded corpus slice and record
  whether sequential state is kept, cone-split, or dropped.
- [x] Run DeepGate3 embeddings end to end or log exact graph/model/setup
  blocker evidence.
- [x] Create per-encoder method cards for Qwen3 and DeepGate3 with extraction,
  stability, non-collapse, leakage, runtime, interpretability, and verdict.
- [ ] Consider larger Qwen, DeepSeq, NetTAG, CircuitFusion, or similar
  encoders only if Qwen3/DeepGate3 are blocked or inconclusive with evidence.

## WP2 - Quality-Gated / Repair-Preserving Diversity Pressure

- [ ] Decide whether retrospective evidence requires a bounded replay-only
  or live sampling experiment.
- [ ] If live sampling is used, preflight `curl http://20.0.0.103:8000/v1/models`
  and record served model id, max_model_len, token settings, subset, seed, and
  command.
- [ ] Implement or simulate a quality floor: non-dominated, HV contributor,
  top-quartile valid candidate, above median valid fitness, or one PPA axis
  improved without catastrophic regression.
- [ ] Run duplicate-suppression or quality-gated novelty replay before any
  live run.
- [ ] Run or schedule a novelty-parent sweep with fractions
  `0.00`, `0.10`, `0.25`, and `0.50`, or log why budget forbids it.
- [ ] Reject any method that loses valid-PPA coverage by more than 5
  percentage points or repeats the ST-NOD-style robustness drop.

## WP3 - Learned / AURORA / VQ Escalation

- [ ] Decide from WP0-WP2 whether AURORA/VQ/learned netlist embeddings are
  justified, diagnostic-only, or no-proceed.
- [ ] If justified, write the training/fitting corpus, leakage policy,
  checkpoint/hash, and common-audit evaluation before running training.
- [ ] Do not revive VQ/codebook in-loop unless a continuous descriptor first
  passes quality-gated robustness tests.

## Restart Completion Gates

- [ ] The restarted Diversity Necessity Report is regenerated from artifacts.
- [ ] It contains a preliminary negative-result and plan-pivot section.
- [ ] It includes per-encoder method cards and centralized encoder
  leaderboard rows for every attempted encoder.
- [ ] It includes D-gate and claim-level tables after WP0-WP2 evidence.
- [ ] It chooses one final recommendation: no-proceed, diagnostic-only,
  quality-gated ST-NOD, learned-encoder diagnostic follow-up, or AURORA/VQ
  escalation.
- [ ] The restarted adversarial prompt returns PASS, or FAIL findings are
  resolved or logged as blockers with three concrete attempts.
