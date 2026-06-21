# RTL Diversity Check Experiment Plan

Feature slug: `rtl_diversity_check`

Status: restarted after Phase 0. The committed preliminary audit is useful
evidence, but it is not research sign-off. This directory defines the active
research contract for the `feat/journal-diversity-check-exp-20260620` branch.

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

## Restart Directive - 2026-06-20 UTC

The first implementation pass stopped too early. It built a useful candidate
audit/report generator and corrected the initial RTLLM-only `C reconstructive`
read to an ASP-DAC-backed `B illumination_only` read, but it did not exhaust
the research question. The previous PASS validates only that narrow generated
report. It must not be read as sign-off that diversity is unimportant or that
the original notes have been fully tested.

What went wrong:

- Real Qwen3 embedding extraction was not made to work; missing `torch` was
  accepted too quickly instead of trying dependency setup.
- DeepGate3 stopped at an import/setup card; there was no end-to-end AIG or
  graph embedding attempt.
- ST-NOD and synthesis-response descriptors were treated mostly as prior
  Auto-BD evidence, not reconstructed as post-hoc descriptors in the new audit.
- Lineage, parent-child jump, and descendant-yield evidence were scoped out
  after one broad corpus lacked lineage, rather than searching for corpora
  that expose it.
- The report did not run a bounded live or replay-based test of duplicate
  suppression, quality-gated novelty, or archive-parent fraction.
- The TODO and validation report allowed the Phase 0 `B illumination_only`
  artifact to look complete even though the original-notes escalation ladder
  remained mostly unattempted.

Dependency rule: missing Python/model dependencies are engineering tasks, not
terminal blockers. For Qwen, DeepGate3, DeepSeq, NetTAG, CircuitFusion, or
AURORA-style probes, the implementer must try one of:

- adding a repo-local optional dependency path with `uv add` or the nearest
  existing dependency mechanism;
- creating an isolated throwaway environment under ignored `exp/` for the
  encoder probe;
- checking out or adding an external encoder repo in a documented
  submodule-style or ignored source directory when license/size allows.

Only after those attempts fail with command evidence may the encoder be marked
blocked.

The restarted plan reinstates the work-package ladder from `original_notes/`.
Each package must end with artifacts, quantitative gates, and a proceed /
no-proceed decision.

### WP0 - Deeper Diversity Necessity

Re-run the diversity-necessity study across the full layered definition:
`D_code`, `D_struct`, `D_synth`, `D_ppa`, and `D_lineage`.

Required additions beyond Phase 0:

- reconstruct ST-NOD or synthesis-response descriptors where stage dumps or
  prior fitting artifacts allow;
- compute diversity at 25%, 50%, 75%, and 100% of budget where generation
  metadata exists;
- search historical roots for parent/child or generation-log lineage and run
  parent-child jump or descendant-yield analysis wherever recoverable;
- split counterfactual replay into oracle reconstructive, online-available,
  duplicate-suppression, and quality-plus-diversity variants;
- report validity-normalized diversity at generated, functional,
  synthesis-valid, valid-PPA, and Pareto-front levels;
- compare every descriptor in a shared common-audit space, not only its
  internal archive occupancy.

### WP1 - Real Encoder Diagnostics

Use encoders as diagnostics before in-loop claims. Required families:

- Qwen3-Embedding-0.6B on raw, comment-stripped, identifier-normalized, and
  Yosys-normalized RTL where available;
- DeepGate3 over AIG/netlist graphs, including a recorded state policy:
  sequential elements kept, cone-split, or dropped;
- larger Qwen, DeepSeq, NetTAG, CircuitFusion, or similar encoders if the
  first two are blocked or inconclusive and dependency setup is feasible.

Every promoted encoder needs a method card with extraction success, runtime,
stability, non-collapse, leakage controls, descriptor/manual-BD correlation,
descriptor/PPA correlation, cluster-to-PPA contribution, replay signal,
common-audit score, and an accept/reject/diagnostic-only verdict.

### WP2 - Quality-Gated Search Coupling

If retrospective evidence remains inconclusive, run a bounded replay or live
test of repair-preserving diversity pressure. Keep quality-first search as the
primary path and add diversity only as a valid-only novelty lane.

Minimum experiments:

- duplicate suppression by canonical netlist hash and near-identical motif
  signature;
- quality-gated novelty-parent sweep with `novelty_parent_fraction` in
  `{0.00, 0.10, 0.25, 0.50}`;
- quality floors: non-dominated candidate, HV contributor, top-quartile valid
  candidate, above problem-median valid fitness, or one PPA axis improved
  without catastrophic regression;
- compare against both classic REvolution and landing Smooth-QD manual-BD
  where artifacts or live budget allow.

Reject any live/replay method that loses valid-PPA coverage by more than 5
percentage points or repeats the ST-NOD-style robustness loss.

### WP3 - Learned / AURORA / VQ Only If Justified

AURORA, VQ/codebook revival, or learned netlist embeddings may move beyond
diagnostics only if WP0-WP2 show that useful diversity exists and that a
quality-gated diversity lane helps without robustness loss. The preferred
learned direction, if justified, is a hardware-native synthesis-trajectory
embedding/codebook rather than a black-box text embedding.

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
- Encoder escalation: `rtl_diversity_check_encoder_escalation_plan.md`

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

## Claim Levels

Every result and paper-facing sentence must use the strongest claim level
actually supported by evidence:

- `L0 descriptive`: multiple implementation regions exist. This does not
  imply useful search pressure.
- `L1 reconstructive`: diversity-aware retention reconstructs a better
  historical Pareto front at equal candidate budget.
- `L2 predictive`: early diversity predicts later HV, best fitness,
  Pareto-front expansion, or descendant yield after controls.
- `L3 mechanistic`: diverse parents, regions, or jumps produce useful
  descendants or final-front lineages.
- `L4 active`: a prospective diversity intervention improves PPA/HV without
  robustness loss under the same budget.
- `L5 method`: a concrete QD/Auto-BD method beats landing Smooth-QD manual-BD
  under frozen gates, budget, seeds, and benchmark subset.

The report may not claim a higher level than the evidence supports. `L0`
alone is an illumination result, not an optimization result.

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

Stratify historical corpora before making comparative claims:

- `fully_paired`: same problem, seed, model, prompt policy, budget, and
  evaluator;
- `partially_paired`: same problem and evaluator, but different seed or
  budget;
- `unpaired`: different problem mix, model, prompt policy, budget, or
  evaluator.

Active method comparisons require fully paired data. Predictive and
descriptive analyses may use less paired data, but must include method, model,
budget, problem, and valid-count controls. Unpaired corpora cannot support
"method A is better than method B" claims.

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

Report two variants:

- `E2a oracle_reconstructive`: may use final PPA/front information and only
  supports `L1 reconstructive` claims.
- `E2b online_available`: uses only information available at candidate
  insertion time and is the only replay result that can support stronger
  method-follow-up claims.

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

Qwen diagnostics should compare raw RTL, comment-stripped RTL,
identifier-normalized RTL, and Yosys-normalized `write_verilog` output when
available. Record truncation, chunks, pooling, prompt, max length, and compare
against a simple lexical baseline such as TF-IDF or Verilog token counts. If
Qwen mainly separates comments, formatting, or names, it is text-style
diagnostic only.

DeepGate3 diagnostics must record the graph export format, whether sequential
elements are represented, cone-split, or dropped, graph size distribution, and
extraction failures. Do not compare DeepGate3 against ST-NOD without stating
which circuit information each representation keeps or discards.

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

## Descriptor Fitting And Leakage

Every descriptor/projection must be labeled:

- `intrinsic`: no fitting, such as manual BD or raw Yosys stats;
- `frozen_pretrained`: frozen model, no corpus fitting, such as raw Qwen
  embeddings;
- `fitted_unsupervised`: scaler, PCA, k-means, CVT, VQ, UMAP, or clustering
  fitted on a declared corpus;
- `posthoc_visualization`: fitted after the full run for plotting only.

Predictive claims require fitted projections and clusters to be trained only
on data available before the prediction cutoff, or on a separate dev corpus.
Anything fitted on the full final corpus is descriptive or reconstructive
only. UMAP/t-SNE are visualization-only unless their fitting seed, stability,
and quantitative use are explicitly validated.

## Quantitative Gates

The D gates measure whether diversity has useful signal:

- `D1 early_predictive`: early implementation diversity has positive
  association with final HV or best fitness after controlling for valid
  candidate count, problem, seed, method, model, and budget. Suggested
  evidence: positive standardized coefficient with mostly positive bootstrap
  95% CI, or Spearman rho >= 0.25 on at least 60% of analyzable problems.
- `D2 multi_cluster_front`: in at least 60% of analyzable problems, the final
  PPA Pareto front contains candidates from at least two stable structural
  clusters, and those clusters beat random or shuffled cluster labels.
- `D3 replay_retention`: diversity-aware counterfactual retention improves
  retained HV, unique motif signatures, common-audit coverage, or retained
  positive-improvement candidates by at least one predeclared threshold:
  10% HV, 10% motif signatures, 10% common-audit coverage, or two additional
  positive-improvement problems.
- `D4 prospective_moderate_diversity`: if live runs are later approved,
  archive parent fraction 0.25 or 0.5 beats 0.0 on HV or best fitness without
  more than a 5 percentage point functionality, synthesis, or valid-PPA drop.
- `D5 real_beats_random`: a hardware descriptor beats random descriptor under
  identical archive mechanics, cells/dimensions, retained budget, validity
  denominator, and common-audit space on HV, common-audit QD score, unique
  motif diversity, or valid-PPA-safe front quality.
- `D6 interpretable_regions`: representative regions correspond to clear
  RTL/netlist implementation styles such as mux-heavy, arithmetic-heavy,
  shallow-wide, deep-narrow, register-balanced, resource-shared,
  duplicated-compute, or control-dominated.

Minimum evidence for PASS:

- D1/D2/D3 need at least 8 analyzable problems, preferably 12+, or must be
  labeled low-data/preliminary.
- D3 random-selection controls need at least 20 random seeds.
- D4 live evidence, if later approved, needs at least 3 seeds under the same
  model, prompt policy, budget, subset, and evaluator.
- D5 random descriptors need at least 5 descriptor seeds offline or 3 live-run
  seeds online.

Proceed to full Auto-BD only if at least one utility gate passes
(`D1`, `D3`, `D4`, or `D5`) and at least one meaning gate passes (`D2` or
`D6`). `D2 + D6` alone supports illumination/reporting only. If only `D3`
passes, prefer shadow archives or offline retention over causal search claims.

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

## Validity-Normalized Diversity

For every descriptor family, report diversity through the funnel:

- all generated candidates;
- syntax-valid candidates;
- functionally valid candidates;
- synthesis-valid candidates;
- valid-PPA candidates;
- Pareto-front candidates.

Also report efficiency metrics: `valid_PPA_per_occupied_cell`,
`HV_per_valid_PPA_candidate`, `front_members_per_valid_PPA_candidate`,
`unique_motif_signatures_per_valid_PPA_candidate`, and
`common_audit_QD_per_valid_PPA_candidate`. High all-candidate diversity with
low valid-PPA diversity means the descriptor mostly creates invalid variety.

## Report And Visualization Spec

The main deliverable is a regenerated Diversity Necessity Report, with
per-encoder sections and a centralized comparison. It should not be manually
assembled from cherry-picked tables.

Required centralized tables:

- corpus coverage by root, method, model, seed, benchmark, and artifact type;
- encoder leaderboard with family, stability, non-collapse, predictive
  signal, Pareto-cluster signal, replay signal, cost, and verdict;
- signoff gate matrix for D1-D6;
- claim-level table using `L0` through `L5`;
- diversity-vs-PPA regression summary;
- cluster summary with dominant motifs, candidate count, best area/power/
  timing/fitness, Pareto members, and representative paths;
- counterfactual retention-policy comparison;
- prior 20260618 Auto-BD negative/control summary table;
- common-audit metrics across descriptor families;
- final verdict: `A diversity_not_supported`,
  `B illumination_only`, `C reconstructive`, `D predictive`,
  `E actively_useful`, or `F autobd_candidate_justified`.

Required visualizations:

- embedding scatter by fitness, validity, generation, cluster, and Pareto
  membership;
- PPA Pareto front colored by implementation cluster;
- diversity over time versus best fitness or HV over time;
- diversity-efficiency frontier: valid-PPA rate/count versus HV, best
  fitness, or common-audit QD score;
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

## Visual Evidence And Case Studies

Visuals are not decoration in this study. Each main claim must have one
primary figure and one quantitative table that support the same conclusion.
Figures must be reproducible from the candidate audit table and report the
corpus stratum, candidate count, problem count, seed count, and descriptor
family in the caption or adjacent table.

Required diagrams:

- RTL evolution validity funnel: syntax, interface, functional, synthesis,
  OpenROAD, valid-PPA, and final Pareto/frontier contribution.
- Claim-level ladder from `L0 descriptive` to `L5 method`, showing which
  analyses can support each claim.
- Descriptor fitting/leakage diagram showing raw candidate artifacts,
  descriptor extraction, fitted projections, frozen hashes, and which outputs
  are prediction-safe versus post-hoc visualization only.
- Retrospective analysis dataflow from historical run roots to corpus index,
  candidate audit table, descriptors, reports, and verdict.

Required visual case studies:

- one positive or best-supported case where diversity appears useful;
- one null case where implementation regions exist but do not improve PPA;
- one negative case where descriptor diversity trades away valid-PPA
  throughput;
- one 20260618 Auto-BD negative-control case, preferably ST-NOD or VQ, showing
  why archive organization alone was not enough;
- one encoder case study for Qwen or DeepGate3 when embeddings are used,
  showing whether clusters align with implementation/PPA meaning or collapse
  to style/noise.

Case studies must be selected by declared rules before narrative writing:
largest HV delta, median representative problem, clearest robustness loss, or
predeclared benchmark family. Do not cherry-pick only attractive examples. If
no positive case exists, the positive slot becomes an explicit negative/null
case.

High-value figure panels:

- robustness funnel plus HV/common-audit score in the same panel family;
- PPA Pareto front colored by cluster, with objective extremes labeled;
- descriptor or embedding scatter colored separately by validity, fitness,
  generation, and Pareto membership;
- diversity-efficiency frontier with valid-PPA rate/count on one axis and HV,
  best fitness, or common-audit QD on the other;
- lineage strip or ancestry graph for representative Pareto candidates;
- before/after RTL or netlist motif snippets for representative regions.

Every visual conclusion must also state the corresponding numeric gate,
effect size, and whether the figure supports `L0`, `L1`, `L2`, `L3`, `L4`, or
`L5`.

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

Superseded Phase 0 boundaries:

- full production-grade in-loop MAP-Elites/QD parent-selection rewrites;
- ungated descriptor pressure that can dominate repair/exploitation;
- AURORA-style custom encoder training before WP0-WP2 justify it;
- broad production-grade database/schema compatibility;
- claims that diversity helps search unless retrospective, encoder, replay, or
  bounded live evidence supports the corresponding claim level.

The earlier prohibition on duplicate suppression, novelty lanes, and live
sampling is no longer absolute. They are now allowed only as bounded WP2
experiments after historical evidence is organized and the dependency/setup
attempts are logged.

## Roadmap

1. Preserve Phase 0: keep the preliminary ASP-DAC-backed
   `B illumination_only` report and the derailed RTLLM-only archive as audit
   artifacts, not final research sign-off.
2. Re-read `original_notes/` and record the methods Phase 0 did not attempt.
3. WP0: deepen the retrospective study with ST-NOD/synthesis-response,
   lineage, online-available replay, duplicate-suppression replay, and
   validity-normalized common-audit comparisons.
4. WP1: make real encoder attempts. Use dependency escalation for Qwen3 and
   DeepGate3 before marking them blocked; add method cards and per-encoder
   reports.
5. WP2: run bounded quality-gated diversity-pressure tests when retrospective
   evidence remains inconclusive. Include novelty fractions 0, 0.10, 0.25,
   and 0.50 or record why a live sweep is not affordable.
6. WP3: consider AURORA/VQ/learned encoders only after WP0-WP2 pass the
   utility, meaning, robustness, and common-audit gates.
7. Regenerate the centralized Diversity Necessity Report with a preliminary
   negative-result section, per-encoder comparison, and final proceed /
   no-proceed recommendation.
8. Run the restarted adversarial validation prompt. A validator must be able
   to fail the work for premature dependency blocking or missing WP2 evidence.

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
  reconstructive, merely descriptive, active, method-level, or inconclusive.
- [ ] The final report selects exactly one verdict from A-F and does not
  claim above the supported level.
- [ ] Tests cover corpus indexing and the selected analysis metrics with
  small fixtures.
- [ ] The TODO and history files are updated with commands, artifacts, and
  blocked evidence.
- [ ] The adversarial validator returns PASS or records exact FAIL findings.
- [ ] The implementation history records why Phase 0 was insufficient and
  which `original_notes/` details were reinstated.
- [ ] Missing Qwen/DeepGate3 dependencies are handled through `uv add`, an
  optional dependency path, or an isolated ignored environment before blocker
  status is accepted.
- [ ] Qwen3 real embeddings are extracted, or the failed setup/runtime attempt
  is logged with commands and environment evidence.
- [ ] DeepGate3 graph export plus embedding is run, or the failed setup/runtime
  attempt is logged with commands and graph-state-policy evidence.
- [ ] ST-NOD/synthesis-response descriptors are reconstructed from available
  artifacts or blocked with exact missing-stage evidence.
- [ ] At least one lineage, parent-child, or descendant-yield analysis is run
  on a corpus that exposes lineage, or a corpus search proves none do.
- [ ] At least one duplicate-suppression, online-available replay, or bounded
  quality-gated novelty experiment is run before the research is closed as
  illumination-only.
- [ ] The final recommendation explicitly chooses among no-proceed,
  diagnostic-only, quality-gated ST-NOD, learned encoder diagnostic follow-up,
  or AURORA/VQ escalation.

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
