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
- [ ] Confirm `nvidia-smi` works inside the devcontainer.
- [ ] Confirm `/aux/revolution-history` is readable and not writable from
  the devcontainer.
- [ ] Preflight `curl http://20.0.0.103:8000/v1/models` only if live runs or
  live model calls become necessary.
- [ ] If live runs are needed, confirm `gpt-oss-120b` is served with
  `max_model_len >= 131072` and record token settings.
- [ ] Record branch, HEAD, dirty state, and devcontainer image/container
  details in the history.
- [ ] Confirm this is a post-hoc diagnostic goal, not a new in-loop QD
  method goal.
- [ ] Read the 20260618 Auto-BD final negative decision and seed-3 screening
  report before designing new descriptor experiments.
- [ ] Record that Yosys-stat, motif histogram, ST-NOD, projected SR,
  VQ/codebook, and random descriptor arms are existing control/negative
  evidence, not fresh default candidates.

## P1 - Corpus Inventory

- [ ] Index current Auto-BD seed-1 and seed-3 `standard_results` roots.
- [ ] Ingest the 20260618 Auto-BD centralized reports and final negative
  decision as context for why new diagnostics are needed.
- [ ] Index historical `exp/` roots under `/aux/revolution-history`.
- [ ] Check whether an `aspdac2026-paper` checkout/worktree is available
  locally and index its `exp/` roots if present.
- [ ] Index recoverable archived baselines from `baselines/`.
- [ ] Emit a corpus coverage table with candidate counts and available
  code/netlist/PPA artifacts.
- [ ] Label corpus strata as fully paired, partially paired, or unpaired.
- [ ] Record missing-artifact patterns without adding broad fallback logic.
- [ ] Mark small subsets as development/debug evidence only.
- [ ] Identify the largest practical final-conclusion corpus, preferring
  broad RTLLM coverage when available.
- [ ] Use VerilogEval only when existing artifacts make it practical, or
  label its evidence as partial.

## P2 - Candidate Audit Table

- [ ] Define one simple candidate-level table for retrospective analysis.
- [ ] Include method, seed, model, benchmark, problem, generation, operator,
  candidate id, code path, netlist path, validity funnel, PPA, and fitness.
- [ ] Include existing canonical netlist hash, motif signature, descriptor
  vector, and archive cell fields when present.
- [ ] Include descriptor/projection version and fitting-corpus hashes when
  fitted descriptors are used.
- [ ] Assert required fields for standard-results inputs.
- [ ] Keep outputs under `exp/diversity_check/`.

## P3 - Diagnostic Descriptors

- [ ] Reuse existing structural descriptor outputs from the Auto-BD push
  where available instead of re-running failed arms by default.
- [ ] Add Qwen3-Embedding-0.6B extraction for RTL/source text as a bounded
  diagnostic path.
- [ ] Add Qwen dry-run mode that reports candidate text coverage without
  loading the model.
- [ ] Check Qwen against identifier/comment stability and a lexical baseline.
- [ ] Investigate DeepGate3 input requirements and record the minimum
  graph-export path needed.
- [ ] Record whether DeepGate3 keeps, cone-splits, or drops sequential state.
- [ ] Treat DeepSeq, NetTAG, CircuitFusion, larger Qwen models, and custom
  AURORA training as later-stage candidates only.
- [ ] Defer custom AURORA/autoencoder training unless post-hoc evidence
  justifies it.
- [ ] If AURORA-style training is later approved, record why pre-trained
  Qwen/DeepGate3 diagnostics were insufficient first.

## P4 - First Post-Hoc Analyses

- [ ] Implement cluster contribution analysis.
- [ ] Implement oracle downsampling analysis.
- [ ] Split downsampling into oracle-reconstructive and online-available
  variants.
- [ ] Implement early diversity predictor analysis if generation data is
  available.
- [ ] Implement parent-child jump analysis only when lineage is recoverable.
- [ ] Implement shadow archive replay only after the audit table is stable.
- [ ] Compare against best-fitness-only and random-selection controls.
- [ ] Report diversity through the validity funnel and normalize by valid-PPA
  count.

## P5 - Reporting

- [ ] Generate one concise report with tables and plots for the completed
  analyses.
- [ ] Report paired problem/seed/method deltas where possible.
- [ ] Separate development-subset findings from final-conclusion findings.
- [ ] Base final conclusions on a large dataset run or retrospective corpus,
  preferably broad RTLLM coverage.
- [ ] Report whether each diversity layer is predictive, reconstructive,
  descriptive-only, or inconclusive.
- [ ] Assign claim levels `L0` through `L5` and one final verdict `A` through
  `F`.
- [ ] Include the diversity-efficiency frontier plot.
- [ ] Include visual case studies for positive, null, and negative outcomes.
- [ ] Record case-study selection rules before narrative interpretation.
- [ ] Include negative findings plainly.
- [ ] State limits from missing artifacts, model/budget confounds, and
  unpaired corpora.

## P6 - Validation And Handoff

- [ ] Add focused tests for corpus indexing and metric calculations.
- [ ] Run focused pytest commands for touched tests.
- [ ] Run `ruff check` on touched Python files.
- [ ] Run type checks on touched source modules if source modules are added.
- [ ] Update user-facing docs only for stable entry points.
- [ ] Record all command evidence and artifacts in the history.
- [ ] Run adversarial validation.
- [ ] Verify D-gate minimum evidence and descriptor-fitting leakage checks.
- [ ] Resolve FAIL findings or mark exact blockers and missing evidence.

## Completion Gates

- [ ] `rtl_diversity_check_plan.md` outcome is satisfied or explicitly
  narrowed with evidence.
- [ ] Post-hoc evidence is enough to support, reject, or qualify the claim
  that implementation diversity matters for RTL PPA evolution.
- [ ] Final claims are not based only on partial sub-datasets.
- [ ] No broad claim relies only on archive occupancy or exact duplicate
  counts.
- [ ] Auto-BD follow-up is justified only by at least one utility gate and one
  meaning gate.
- [ ] Code remains simple, typed where useful, and skimmable.
- [ ] `rtl_diversity_check_subagent_validation_report.md` records PASS.
