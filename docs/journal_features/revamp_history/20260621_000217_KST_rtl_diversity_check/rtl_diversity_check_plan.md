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
