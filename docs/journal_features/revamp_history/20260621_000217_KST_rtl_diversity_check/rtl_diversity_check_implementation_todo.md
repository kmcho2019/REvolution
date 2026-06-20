# RTL Diversity Check Experiment TODO

Line limit: 150 lines. Keep this checklist concise and update-oriented.
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
  diagnostic path. Scoped: optional real smoke blocked by missing `torch`.
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

- [x] `rtl_diversity_check_plan.md` outcome is satisfied or explicitly
  narrowed with evidence.
- [x] Post-hoc evidence is enough to support, reject, or qualify the claim
  that implementation diversity matters for RTL PPA evolution.
- [x] Final claims are not based only on partial sub-datasets.
- [x] No broad claim relies only on archive occupancy or exact duplicate
  counts.
- [x] Auto-BD follow-up is justified only by at least one utility gate and one
  meaning gate.
- [x] Code remains simple, typed where useful, and skimmable.
- [x] `rtl_diversity_check_subagent_validation_report.md` records PASS.
