# Combined RTL Diversity Check Goal And Spec

Generated from the scaffold files listed in each section.

---

## Source: `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/goal_template.md`

# Goal Template

Use this draft for `/goal` after reviewing the plan. Keep the activated goal
under 4000 characters.

```text
/goal Objective: implement the RTL diversity check experiment in docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_plan.md. Use rtl_diversity_check_implementation_todo.md as the checklist and record commands, artifacts, failures, decisions, and commits in rtl_diversity_check_implementation_history.md.

Outcome: decide whether implementation diversity among functionally equivalent RTL candidates is predictive, reconstructive, or useful for PPA evolution before further AutoQD/AURORA/VQ work. Start from post-hoc corpora, not new live evolution. Define useful diversity as structural, synthesis-response, or embedding distinction whose region contributes to the PPA Pareto front or produces useful descendants.

Interpretation constraint: use the 20260618 Auto-BD results as negative/control evidence. Yosys-stat, motif, ST-NOD, projected synthesis-response, VQ/codebook, and random descriptor arms did not produce clean robust PPA uplift, so do not present them as fresh promising defaults. Ask whether those failures mean diversity is weakly relevant, the wrong diversity was measured, or diversity pressure traded away exploitation and repair.

Data: use this branch, ignored outputs under exp/diversity_check/, and read-only /aux/revolution-history. Index Auto-BD standard_results, old exp roots, recoverable baselines, and aspdac2026-paper artifacts only if locally present. Do not write historical checkouts.

Dataset policy: debug on small subsets, but final claims require a large retrospective corpus/run, preferably broad RTLLM. Use VerilogEval only when existing artifacts make it practical; otherwise label it partial.

Encoder policy: first add Qwen/Qwen3-Embedding-0.6B RTL text diagnostics and DeepGate3 netlist/AIG diagnostics if practical. Treat DeepSeq, NetTAG, CircuitFusion, larger Qwen models, and AURORA/custom training as later-stage only after Qwen/DeepGate3 and existing descriptor evidence justify them.

Live-run policy: no new runs by default. If needed, preflight curl http://20.0.0.103:8000/v1/models and use gpt-oss-120b with max_model_len >= 131072, --max_tokens 128000, and --diff_max_tokens 128000 when relevant.

Required report: regenerate a Diversity Necessity Report with corpus coverage, candidate audit table, encoder leaderboard, D1-D6 gate matrix, diversity-vs-PPA regressions, cluster summaries, counterfactual replay, common-audit metrics, and visualizations: embedding scatter, PPA front by cluster, diversity-over-time vs quality, early-diversity vs final HV, replay bars, stability boxplots, correlation heatmaps, common-audit heatmaps, and representative implementation gallery.

Proceed toward Auto-BD only if at least two D gates pass: early diversity predicts quality after valid-count/problem/seed controls; Pareto front spans multiple structural clusters in >=60% analyzable problems; diversity-aware replay improves retained HV/motif/common-audit coverage; moderate live diversity pressure helps without >5pp robustness drop; real hardware descriptors beat random; descriptor regions are interpretable.

Code constraints: keep code simple, typed where useful, assert required data, avoid broad fallbacks/backward-compat/database machinery, and keep entry points skimmable. Completion requires TODO items checked or scoped with evidence and PASS from rtl_diversity_check_adversarial_prompt.md written to rtl_diversity_check_subagent_validation_report.md. If blocked for three concrete attempts, stop with commands, evidence, blocker, and required input.
```

---

## Source: `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_adversarial_prompt.md`

# RTL Diversity Check Experiment Adversarial Validation Prompt

Use this prompt with an independent sub-agent after the implementer claims
the goal is complete. The validator must inspect repository evidence, not
trust the implementer summary.

```text
You are an adversarial validator for the RTL diversity check experiment.

Read:
- docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_plan.md
- docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_implementation_todo.md
- docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_implementation_history.md
- docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/goal_template.md
- relevant code, tests, generated reports, artifacts, and git commits named
  by the implementer

Write your report to:
docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_subagent_validation_report.md

Return exactly one verdict: PASS or FAIL.

Automatic FAIL preconditions:
1. Any checked completion claim lacks command evidence or artifact paths.
2. The report claims "diversity helps RTL PPA evolution" using only archive
   occupancy, exact duplicate counts, or unpaired aggregate averages.
3. Functional diversity is counted as useful RTL diversity.
4. Invalid candidates are used to claim PPA diversity without clearly
   separating validity and failure-mode analysis.
5. Historical corpus coverage is unclear: roots scanned, missing artifacts,
   candidate counts, methods, seeds, models, or benchmark/problem coverage are
   not reported.
6. Final conclusions are based only on small convenience subsets without a
   large-dataset retrospective analysis or explicit preliminary label.
7. RTLLM is available as a broad practical corpus but ignored without
   rationale, or VerilogEval partial evidence is presented as full-suite
   evidence.
8. The 20260618 Auto-BD negative/control evidence is ignored, or Yosys-stat,
   motif histogram, ST-NOD, projected SR, VQ/codebook, or random descriptor
   arms are presented as untested promising baselines rather than existing
   mixed/negative evidence.
9. New live evolution runs are launched before available historical corpora
   are indexed and analyzed, without a recorded rationale.
10. Live model calls or runs use a model other than `gpt-oss-120b`, a different
   endpoint, or low token settings without explicit rationale.
11. If live runs are used, there is no recorded preflight for
   `curl http://20.0.0.103:8000/v1/models`, served max_model_len, and
   128K-token policy.
12. Qwen3 or DeepGate3 embeddings are promoted as in-loop behavior descriptors
   without post-hoc evidence that distances correlate with Pareto
   contribution, future improvement, or valid descendant yield.
13. AURORA-style custom encoder training is added before pre-trained
    Qwen/DeepGate3 diagnostics are attempted or explicitly shown
    insufficient.
14. Code organization is overcomplicated for a research experiment: broad
    fallback layers, production database machinery, scattered scripts, or
    excessive backward-compatibility paths.
15. The implementation writes into `/aux/revolution-history` or any historical
    checkout intended to be read-only.
16. Tests are missing for corpus indexing and the selected analysis metrics.

Mechanical checks:
1. Inspect branch status and commit history. Confirm the devcontainer GPU and
   read-only mount setup is on `feat/journal-diversity-check-exp-20260620`.
2. Confirm the old Auto-BD branch remains clean except unrelated untracked
   files.
3. Inspect the corpus index. Confirm it includes Auto-BD standard-results
   roots and at least one historical root when available.
4. Inspect the 20260618 Auto-BD final negative decision, seed-3 screening
   report, and centralized reports. Confirm the new study explains how those
   results constrain the interpretation of Yosys-stat, motif, ST-NOD, random,
   projected SR, and VQ/codebook descriptors.
5. Inspect the candidate audit table. Confirm it includes method, seed, model,
   problem, generation, validity funnel, PPA fields, code path, netlist path,
   and available descriptor/hash fields.
6. Confirm missing historical artifacts are reported as coverage, not silently
   filled with broad fallback behavior.
7. Confirm quick subset reports are labeled development/preliminary and that
   final conclusions use a large practical corpus, preferably broad RTLLM.
8. If VerilogEval appears in conclusions, confirm whether it is full,
   representative, or partial evidence.
9. Confirm Qwen embedding extraction has a dry-run coverage mode and records
   model name/path, device, batch size, max length, and output path/hash for
   any real run.
10. Confirm DeepGate3 is either implemented as a bounded diagnostic path or
   deferred with exact graph-export/setup blockers.
11. Recompute or inspect the cluster contribution report. Confirm it separates
   clusters that contribute Pareto/HV from clusters that are merely occupied.
12. Recompute or inspect the oracle downsampling report. Confirm it compares
   best-fitness-only, random, structural-diversity, synthesis-response, and
   embedding-based selectors at equal candidate budget.
13. Confirm early-diversity, parent-child jump, and shadow-archive analyses
    are either implemented after the audit table is stable or explicitly
    scoped out with evidence.
14. Inspect plots/tables. Confirm conclusions are labeled as predictive,
    reconstructive, descriptive-only, inconclusive, or negative.
15. Inspect touched Python code for repo style: simple, skimmable, typed where
    useful, asserts for required data, narrow states, and no broad try/except
    defaults where data must exist.
16. Confirm focused pytest, ruff, and typecheck evidence for touched code, or
    an explicit doc-only rationale if no code was added.
17. Inspect docs for clear usage, artifact paths, limitations, and how to
    reproduce the report from ignored experiment outputs.
18. Inspect commits for atomicity, conventional commit messages, and
    sign-offs according to `GUIDELINES.md`.

Paper-facing checks:
1. Does the evidence justify testing diversity in RTL PPA evolution, or does
   it show diversity is decorative under current descriptors?
2. Does the definition of diversity avoid counting meaningless syntax/style
   variation unless it connects to PPA-front contribution or descendants?
3. Are negative and inconclusive outcomes preserved instead of hidden?
4. Would a skeptical hardware/EDA reviewer understand the difference between
   functional behavior and implementation-strategy diversity?
5. Are Qwen/DeepGate3/AURORA claims bounded to what the evidence actually
   shows?

PASS only if the goal satisfies the plan and the evidence is reproducible
enough for the stated research claim. Otherwise FAIL with exact findings:
file path, command/artifact inspected, observed problem, and the smallest
evidence or change required to pass.
```

---

## Source: `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_implementation_todo.md`

# RTL Diversity Check Experiment TODO

Line limit: 140 lines. Keep this checklist concise and update-oriented.
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
- [ ] Assert required fields for standard-results inputs.
- [ ] Keep outputs under `exp/diversity_check/`.

## P3 - Diagnostic Descriptors

- [ ] Reuse existing structural descriptor outputs from the Auto-BD push
  where available instead of re-running failed arms by default.
- [ ] Add Qwen3-Embedding-0.6B extraction for RTL/source text as a bounded
  diagnostic path.
- [ ] Add Qwen dry-run mode that reports candidate text coverage without
  loading the model.
- [ ] Investigate DeepGate3 input requirements and record the minimum
  graph-export path needed.
- [ ] Treat DeepSeq, NetTAG, CircuitFusion, larger Qwen models, and custom
  AURORA training as later-stage candidates only.
- [ ] Defer custom AURORA/autoencoder training unless post-hoc evidence
  justifies it.
- [ ] If AURORA-style training is later approved, record why pre-trained
  Qwen/DeepGate3 diagnostics were insufficient first.

## P4 - First Post-Hoc Analyses

- [ ] Implement cluster contribution analysis.
- [ ] Implement oracle downsampling analysis.
- [ ] Implement early diversity predictor analysis if generation data is
  available.
- [ ] Implement parent-child jump analysis only when lineage is recoverable.
- [ ] Implement shadow archive replay only after the audit table is stable.
- [ ] Compare against best-fitness-only and random-selection controls.

## P5 - Reporting

- [ ] Generate one concise report with tables and plots for the completed
  analyses.
- [ ] Report paired problem/seed/method deltas where possible.
- [ ] Separate development-subset findings from final-conclusion findings.
- [ ] Base final conclusions on a large dataset run or retrospective corpus,
  preferably broad RTLLM coverage.
- [ ] Report whether each diversity layer is predictive, reconstructive,
  descriptive-only, or inconclusive.
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
- [ ] Resolve FAIL findings or mark exact blockers and missing evidence.

## Completion Gates

- [ ] `rtl_diversity_check_plan.md` outcome is satisfied or explicitly
  narrowed with evidence.
- [ ] Post-hoc evidence is enough to support, reject, or qualify the claim
  that implementation diversity matters for RTL PPA evolution.
- [ ] Final claims are not based only on partial sub-datasets.
- [ ] No broad claim relies only on archive occupancy or exact duplicate
  counts.
- [ ] Code remains simple, typed where useful, and skimmable.
- [ ] `rtl_diversity_check_subagent_validation_report.md` records PASS.

---

## Source: `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_subagent_validation_report.md`

# RTL diversity check experiment Sub-Agent Validation Report

## Verdict

PENDING

## Evidence Checked

## Findings

## Missing Or Weak Evidence

## Reward-Hacking Or Intent Risks

## Required Fixes Before PASS

---

## Source: `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_plan.md`

# RTL Diversity Check Experiment Plan

Feature slug: `rtl_diversity_check`

Status: scaffold for a future `/goal`; do not treat this as an activated
goal. This directory defines the research contract for the
`feat/journal-diversity-check-exp-20260620` branch.

## Outcome

Establish whether implementation diversity is a useful causal variable for
RTL/Verilog PPA evolution before adding more AutoQD, automatic behavior
descriptor, or AURORA-style machinery.

The central question is:

> Does preserving diverse implementation strategies under functional
> equivalence produce better PPA fronts or better descendants under the same
> LLM/evaluation budget?

The first milestone is post-hoc and diagnostic. Use existing evolutionary
run corpora first, then pre-trained encoders as analysis tools. Do not start
with a new in-loop QD algorithm.

## Current Evidence From 20260618 Auto-BD Work

The notes in `original_notes/` include pre-study brainstorming written before
the 20260618 Auto-BD result push. The plan must be interpreted in light of the
newer evidence in
`docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research`.

That evidence already tested several simple/manual hardware descriptor arms:
random descriptor QD, simple Yosys-stat BD, netlist motif occupancy, ST-NOD,
synthesis-trajectory motif variants, projected synthesis-response variants,
and VQ/codebook variants. The important lesson is not that these should be
rerun as promising first methods. The lesson is that descriptor/archive
diversity could be measured and sometimes organized archives differently, but
it did not produce a clean robust PPA uplift and often hurt the valid-PPA
funnel.

Therefore this branch should ask a prior question:

> Were those failures because diversity is weakly relevant for RTL PPA search,
> because the tested descriptors measured the wrong diversity, or because
> diversity pressure was applied in a way that traded away exploitation and
> repair?

Use the 20260618 Auto-BD results as baseline/control evidence and as a warning
against assuming that hardware-native descriptor labels are automatically
useful.

## Source Of Truth

- Full plan: `rtl_diversity_check_plan.md`
- Living checklist: `rtl_diversity_check_implementation_todo.md`
- Evidence log: `rtl_diversity_check_implementation_history.md`
- Copy/paste goal text: `goal_template.md`
- Validator prompt: `rtl_diversity_check_adversarial_prompt.md`
- Validator output: `rtl_diversity_check_subagent_validation_report.md`

## Research Questions

1. Does classic REvolution already discover high-quality PPA candidates from
   multiple implementation regions, or does it collapse to one region?
2. Does early implementation diversity predict later best fitness,
   hypervolume, valid-PPA count, Pareto-front expansion, or descendant yield?
3. Do descriptor jumps between parents and children help search, or mostly
   create syntax, functional, synthesis, or OpenROAD failures?
4. Can quality plus diversity reconstruct a stronger historical Pareto front
   than best-fitness-only or random selection at the same candidate budget?
5. Are pre-trained RTL/code or netlist encoders useful diagnostics for PPA
   search, or do their distances fail to correlate with useful outcomes?

## Diversity Definition

RTL diversity must not mean functional diversity. Valid candidates should
implement the same benchmark specification.

For this goal, useful diversity means:

> Functionally equivalent candidates that are structurally,
> synthesis-response, or embedding-distinct, and whose regions either
> contribute directly to the PPA Pareto front or produce descendants that do.

Track diversity in layers:

- `D_code`: RTL/source diversity from tokens, operators, AST-like structure,
  module organization, always-block style, and Qwen code embeddings.
- `D_struct`: synthesized-netlist diversity from canonical netlist hash,
  motif signature, cell-family ratios, depth, fanout, and pathlet features.
- `D_synth`: synthesis-response diversity from Yosys stage trajectories,
  ST-NOD-like features, and transformation deltas.
- `D_ppa`: PPA-front diversity from distinct non-dominated netlists,
  hypervolume, PPA-grid occupancy, and area/power/timing tradeoff spread.
- `D_lineage`: evolutionary diversity from generation, operator, parent,
  child, cluster, and final-front ancestry when recoverable.

Do not count diversity as useful merely because archive occupancy increases.
It must predict or reconstruct valid-PPA outcomes.

## Initial Corpus

Use existing artifacts before launching new expensive runs:

- Auto-BD seed-1 and seed-3 artifacts from
  `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research`
  and matching historical `exp/auto_bd_research` roots.
- Historical runs under the read-only devcontainer mount
  `/aux/revolution-history`, backed by
  `/home/kmcho/1_RESEARCH/2026_REvolution_Journal_Ext/code_repo/REvolution`.
- Main repo and worktree `exp/` directories that contain earlier
  evolutionary runs.
- Archived baselines in `baselines/` when candidate code/netlists are
  recoverable.
- The `aspdac2026-paper` branch's `exp/` directories if that checkout or
  worktree is available locally; do not require network fetches for the
  initial goal.

The corpus index should record roots scanned, methods, seeds, models,
benchmarks, candidate counts, available code/netlist/PPA artifacts, and
which artifacts are missing. Missing historical data is a coverage fact, not
a reason to add complex fallback behavior.

Quick development subsets are allowed while building and debugging the audit
pipeline. Final conclusions should not rely only on partial convenience
subsets. For paper-facing claims, run the retrospective analysis on the
largest practical corpus available. Prefer a broad RTLLM sweep because it is
large enough to be meaningful but usually small enough to analyze or rerun in
a short period. Use VerilogEval when existing artifacts make it practical;
otherwise label VerilogEval evidence as partial rather than final.

## Live Run Policy

Do not launch new evolutionary runs by default. The first goal should extract
as much evidence as possible from existing corpora.

If new live runs become necessary, or if the plan is explicitly revised to
try AURORA-style encoder training, use the existing vLLM instance:

```bash
curl http://20.0.0.103:8000/v1/models
```

The intended model is `gpt-oss-120b`. Treat it as a reasoning model with a
large context requirement:

- require served `max_model_len >= 131072`;
- use `--max_tokens 128000` for REvolution runs;
- use `--diff_max_tokens 128000` when diff-mode output is involved;
- record endpoint, model id, max-model-len, token settings, and command
  evidence before relying on any live-run result.

Do not silently switch model, endpoint, prompt policy, subset, seed, or
budget when comparing against historical evidence.

## First Experiments

### E1: Cluster Contribution Test

Cluster valid candidates by existing structural/ST-NOD-like descriptor
outputs when present, plus embeddings when available. Report how many
clusters contribute final Pareto points and how much hypervolume each
cluster contributes. Treat the 20260618 structural descriptor outcomes as
prior evidence, not as methods to rerun by default.

### E2: Oracle Downsampling Test

From a fixed historical candidate pool, select equal-size subsets by:

- best fitness only;
- random selection with fixed seeds;
- quality plus canonical-netlist or motif diversity;
- quality plus ST-NOD or synthesis-response diversity;
- quality plus Qwen RTL embedding diversity;
- quality plus DeepGate3 netlist embedding diversity when available.

Compare reconstructed Pareto front, hypervolume, unique front netlists, and
valid-PPA coverage.

### E3: Early Diversity Predictor Test

Measure whether generation-0 or generation-1 diversity predicts later best
fitness, hypervolume, valid-PPA count, or front expansion within the same
problem/seed/method.

### E4: Parent-Child Jump Test

When lineage is recoverable, measure descriptor distance from parent to
child and compare it to child validity, PPA, Pareto-front membership, and
descendant quality.

### E5: Shadow Archive Test

Replay completed classic runs into post-hoc MAP-Elites archives without
changing selection. Report whether cells reveal distinct high-quality
regions that scalar selection did not preserve.

## Encoder Policy

Use pre-trained or pre-existing encoders before training custom AURORA-style
encoders:

- Qwen3-Embedding-0.6B for RTL/source text and optionally synthesized
  netlist text.
- DeepGate3 for synthesized netlist graph embeddings when the graph export
  path is stable enough.

Encoders are diagnostic descriptor sources in this goal. They are not
accepted as in-loop behavior descriptors unless post-hoc evidence shows
that distances correlate with Pareto contribution, future improvement, or
valid descendant yield.

Do not train a new AURORA/autoencoder/GNN descriptor in the first goal.
That is a follow-on only after fixed structural, synthesis-response, and
pre-trained encoder descriptors show useful signal.

## Descriptor Families

Compare descriptor families in increasing complexity, but avoid treating the
already-tested descriptor arms as fresh proposed methods. Every learned or
neural descriptor must beat or complement the existing simple-control evidence
before it is promoted beyond "diagnostic only."

Existing/control families to ingest from prior artifacts:

- `manual_bd`: current Smooth-QD manual trio: combinational depth, FF depth,
  and log combinational gate count.
- `yosys_stat`: gate/FF/mux/arithmetic/comparator counts, PI/PO counts,
  fanout summary, depth, cell histogram, and level histogram.
- `motif_histogram`: local netlist motifs, pathlets, FF-to-FF cones,
  PI-to-PO cones, reconvergent fanout, mux-heavy, arithmetic-heavy, and
  control-heavy regions.
- `stnod_like`: synthesis-stage motif/stat vectors and trajectory deltas
  across Yosys lowering, optimization, ABC/AIG, and mapping stages.
- `random_descriptor`: negative control under the same archive mechanics.

Treat these families as controls and retrospective evidence. Do not spend the
first goal re-proving that Yosys-stat, motif histogram, ST-NOD, or random
descriptor are final methods unless a specific coverage gap is found in the
existing artifacts.

New diagnostic families to evaluate before exotic/custom training:

- `qwen3_embedding_0p6b`: frozen `Qwen/Qwen3-Embedding-0.6B` over raw RTL,
  canonical RTL without comments, identifier-normalized RTL, and optional
  module-summary-plus-canonical-RTL text.
- `deepgate3_aig`: frozen DeepGate3 over final AIG/netlist graphs when AIG
  export and model setup are stable enough.

Later-stage families are optional and should not block the first milestone:
Qwen3-Embedding-4B/8B, RTL-specialized encoders if available, DeepSeq for
sequential circuits, DeepGate4 for larger circuits, NetTAG, CircuitFusion,
and post-mapped netlist encoders. These belong after the first-pass report
shows a real diversity signal.

## Encoder Method Card Requirements

Each descriptor or encoder promoted beyond a quick probe must have a method
card or equivalent report section covering:

- family, motivation, and expected RTL/PPA diversity mechanism;
- input artifacts: RTL variant, Yosys JSON, AIG, techmapped netlist,
  synthesis-stage dumps, or OpenROAD report fields;
- model/checkpoint/version/hash, license if relevant, frozen/trained status,
  and fitting data;
- preprocessing: comments, identifier normalization, module chunking,
  canonicalization, and large-module policy;
- embedding dimension, pooling, normalization, runtime, and failure handling;
- projection/archive mapping: PCA, k-means, CVT, VQ, or quantile grid,
  including fitting-data hash;
- leakage controls: no direct area, power, timing, fitness, reference PPA,
  final HV, or held-out tuning;
- stability tests under renaming, formatting, declaration order changes, and
  comment removal;
- interpretability: dominant motifs, representative RTL/netlist examples,
  and PPA tendency for important regions;
- verdict: accept, reject, diagnostic only, or needs more evidence.

## Quantitative Gates

The project should proceed from diversity pre-study to full Auto-BD only if
at least two Diversity Necessity gates pass:

- `D1 early_predictive`: early implementation diversity has positive
  association with final HV or best fitness after controlling for valid
  candidate count, problem, and seed. Suggested evidence: positive
  standardized coefficient with mostly positive bootstrap 95% CI, or
  Spearman rho >= 0.25 on at least 60% of analyzable problems.
- `D2 multi_cluster_front`: in at least 60% of analyzable problems, the final
  PPA Pareto front contains candidates from at least two structural clusters.
- `D3 replay_retention`: diversity-aware counterfactual retention improves
  retained HV, unique motif signatures, common-audit coverage, or retained
  positive-improvement candidates by at least one predeclared threshold:
  10% HV, 10% motif signatures, 10% common-audit coverage, or two additional
  positive-improvement problems.
- `D4 prospective_moderate_diversity`: if live runs are later approved,
  archive parent fraction 0.25 or 0.5 beats 0.0 on HV or best fitness without
  more than a 5 percentage point functionality, synthesis, or valid-PPA drop.
- `D5 real_beats_random`: a hardware descriptor beats random descriptor under
  identical archive mechanics on HV, common-audit QD score, unique motif
  diversity, or valid-PPA-safe front quality.
- `D6 interpretable_regions`: representative regions correspond to clear
  RTL/netlist implementation styles such as mux-heavy, arithmetic-heavy,
  shallow-wide, deep-narrow, register-balanced, resource-shared,
  duplicated-compute, or control-dominated.

An embedding can be accepted as an in-loop BD only after it passes extraction
success, stability, leakage, non-collapse, interpretability, common-audit, and
runtime gates:

- extraction success >= 99% for synthesized candidates;
- embedding NaN rate equals 0 and embedding dimension is fixed/logged;
- perturbation stability: same-cluster rate >= 90%, or median cosine
  similarity >= 0.95, or same-candidate perturbation distance below the 10th
  percentile of between-candidate distance;
- no direct PPA leakage;
- no near-perfect collapse to manual BDs; reject if max absolute correlation
  with a manual-BD dimension exceeds 0.95, flag high-risk above 0.85;
- extraction overhead is acceptable: target <= 10% of synthesis/PPA time, or
  <= 30 seconds per candidate for screening when OpenROAD dominates.

For a journal-candidate Auto-BD method versus landing Smooth-QD manual-BD,
the method must preserve robustness and improve at least one optimization or
diversity gate: no valid-PPA problem coverage drop, no >5 percentage point
functionality/synthesis/valid-PPA drop, and at least one of >=10% best-fitness
or HV improvement, >=2 additional positive-improvement problems, >=15%
common-audit QD-score improvement, >=20% common-audit coverage improvement,
or >=25% more motif-signature elites.

## Report And Visualization Spec

The main deliverable is a regenerated Diversity Necessity Report, with
per-encoder sections and a centralized comparison. It should not be manually
assembled from cherry-picked tables.

Required centralized tables:

- corpus coverage by root, method, model, seed, benchmark, and artifact type;
- encoder leaderboard with family, stability, non-collapse, predictive
  signal, Pareto-cluster signal, replay signal, cost, and verdict;
- signoff gate matrix for D1-D6;
- diversity-vs-PPA regression summary;
- cluster summary with dominant motifs, candidate count, best area/power/
  timing/fitness, Pareto members, and representative paths;
- counterfactual retention-policy comparison;
- common-audit metrics across descriptor families;
- final recommendation: do not proceed, restrict diversity to diagnostics,
  revisit a simple hardware descriptor only with new evidence, proceed with
  learned netlist embedding, or proceed with multimodal encoder.

Required visualizations:

- embedding scatter by fitness, validity, generation, cluster, and Pareto
  membership;
- PPA Pareto front colored by implementation cluster;
- diversity over time versus best fitness or HV over time;
- early diversity versus final HV with problem/method markers;
- counterfactual archive replay bar charts;
- descriptor stability boxplots for renamed/reformatted/comment-stripped RTL;
- descriptor/manual-BD/PPA correlation heatmaps;
- common-audit archive heatmaps using a fixed audit space;
- representative implementation gallery with RTL snippet, netlist motif
  summary, manual BD values, PPA values, and why the region is distinct.

Every report must distinguish internal descriptor-space metrics from common
audit-space metrics. Cross-method diversity claims should rely on PPA HV,
best fitness, valid-PPA coverage, common-audit QD score/coverage, unique
canonical netlists, unique motif signatures, and representative examples, not
only each method's internal archive coverage.

## Implementation Boundaries

Keep the implementation small and skimmable:

- Prefer one corpus indexing script, one candidate table format, and one
  report entry point before adding abstractions.
- Keep reusable logic in `src/revolution/` only when more than one script
  needs it.
- Use asserts for required data and fail loudly for unknown formats.
- Avoid broad fallback paths and compatibility layers for old layouts unless
  a specific corpus source requires them.
- Keep generated analysis outputs under `exp/diversity_check/` or another
  explicitly named ignored experiment directory.
- Treat `/aux/revolution-history` as read-only; do not write into historical
  checkouts.

Out of scope for the first goal:

- new in-loop MAP-Elites/QD parent-selection mechanisms;
- duplicate suppression or novelty lanes in live evolution;
- AURORA-style custom encoder training;
- broad production-grade database/schema compatibility;
- claims that diversity helps search unless the post-hoc evidence supports
  them.

## Roadmap

1. Preparation: verify devcontainer GPU access, read-only historical mount,
   corpus roots, and ignored output location.
2. Retrospective corpus: index candidates, validity, PPA, code/netlist paths,
   existing descriptors, hashes, generation/operator metadata, and the
   20260618 Auto-BD negative/control reports.
3. First-pass new diagnostics: Qwen3-Embedding-0.6B and DeepGate3 if
   practical, compared against existing manual-BD, Yosys-stat, motif,
   ST-NOD, projected SR, VQ/codebook, and random-control evidence.
4. Retrospective report: cluster contribution, oracle downsampling,
   early-diversity predictor, counterfactual archive replay, and
   visualization package.
5. Decision point: if at least two D gates pass, design a small prospective
   diversity-pressure sweep; otherwise conclude that Auto-BD should be
   scoped to reporting/illumination or deprioritized.
6. Follow-on only if justified: duplicate suppression, quality-gated novelty
   lane, archive-parent fraction sweep, ST-NOD-VQ/codebook, DeepSeq/NetTAG/
   CircuitFusion, or AURORA-style training.

## Completion Gates

- [ ] The branch and devcontainer setup are documented, including GPU access
  and the read-only historical corpus mount.
- [ ] Corpus discovery indexes at least the Auto-BD standard-results roots
  and one historical root, with missing-artifact coverage reported.
- [ ] A candidate-level audit table exists with method, seed, problem,
  generation, validity funnel, PPA fields, code path, netlist path, and
  available descriptor/hash fields.
- [ ] Qwen embedding extraction runs in dry-run mode and one bounded real
  embedding smoke when GPU/model access is available.
- [ ] DeepGate3 integration is either implemented as a bounded diagnostic
  path or explicitly deferred with the missing graph-export/setup evidence
  recorded.
- [ ] At least two post-hoc experiments run end to end, including the oracle
  downsampling test and cluster contribution test.
- [ ] Paper-facing conclusions use a large dataset run or retrospective
  corpus, preferably broad RTLLM coverage; any smaller or partial subset is
  labeled as development-only or preliminary.
- [ ] The generated report states whether diversity is predictive,
  reconstructive, merely descriptive, or inconclusive.
- [ ] Tests cover corpus indexing and the selected analysis metrics with
  small fixtures.
- [ ] The TODO and history files are updated with commands, artifacts, and
  blocked evidence.
- [ ] The adversarial validator returns PASS or records exact FAIL findings.

## Risks And Blockers

- Historical runs may have incomplete code, netlist, or PPA artifacts. Treat
  this as corpus coverage and keep the index honest.
- Different models, prompts, seeds, and budgets may confound conclusions.
  Prefer paired problem/seed/method comparisons where possible.
- Small development subsets can be misleading. Use them for debugging, not
  final claims.
- Exact netlist hashes may overstate or understate meaningful diversity.
  Support hash claims with motif or PPA-front evidence.
- Qwen and DeepGate3 distances may not correlate with PPA outcomes. If so,
  keep them as negative diagnostics rather than forcing them into QD.
- GPU or model downloads may be unavailable in the devcontainer. Dry-run and
  corpus indexing should still work without embeddings.
