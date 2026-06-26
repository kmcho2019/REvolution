# Useful BD Push Plan

Feature slug: `useful_bd_push`

Status: active research plan on branch
`feat/journal-useful-bd-exp-20260622`.

## Outcome

Find behavior descriptors (BDs) or archive-coupling techniques that make
QD/MAP-Elites useful for RTL netlist evolution and PPA optimization.

The prior Auto-BD and RTL-diversity attempts are negative evidence, not a
reason to stop. The new push should cast a wider net, lower the initial
effectiveness bar, and preserve every attempted technique as a paper-ready
method package.

The desired end state is one of:

1. a BD/QD method that matches classic REvolution within a small tolerance
   while adding meaningful archive diversity or analysis value;
2. a BD/QD method that beats classic REvolution or landing Smooth-QD by any
   reproducible positive PPA/HV/best-fitness margin;
3. a clear, well-documented negative result showing which BD families fail and
   why, with enough evidence to guide the manuscript away from overclaiming.

## Source Of Truth

- Full plan: `useful_bd_push_plan.md`
- Living checklist: `useful_bd_push_implementation_todo.md`
- Evidence log: `useful_bd_push_implementation_history.md`
- Copy/paste goal text: `goal_template.md`
- Validator prompt: `useful_bd_push_adversarial_prompt.md`
- Validator output: `useful_bd_push_subagent_validation_report.md`
- Literature search and method map: `literature_method_search.md`
- Repeatable setup: `experimental_setup.md`
- QD metrics and tier definitions: `metrics_and_acceptance.md`
- Common baseline/schema/passive-archive contract:
  `common_evaluation_contract.md`
- Screening subset selection: `screening_subset_selection.md`
- Anti-reward-hacking policy: `anti_reward_hacking_policy.md`
- Code organization policy: `code_organization_policy.md`
- Visualization/reporting policy: `visualization_reporting_policy.md`
- Local vLLM runtime guide: `vllm_runtime_guide.md`
- Continuing idea backlog: `idea_backlog.md`
- Consolidated strategy note: `research_strategy_recommendations.md`
- Technique packages: `techniques/<technique_slug>/`

## Current Research State

The strategic interpretation is now explicit: classic REvolution is a strong
small-budget hill climber, and naive MAP-Elites is unlikely to beat it simply
by spreading samples across generic descriptor cells. The working claim should
be narrower and stronger: useful diversity for RTL PPA evolution means
preserving PPA-competitive RTL implementation families under validity
constraints. QD should act as auxiliary memory and front-preserving pressure
beside classic-like exploitation, not as a wholesale replacement for it.
This does not invalidate QD/MAP-Elites literature; it means the RTL setting
requires a constrained, validity-aware variant whose archive cost is earned by
front material.

The current preliminary-planning status is more advanced than the early
T37/T43-era text this section replaced. The branch has now screened or closed
the main candidate families:

- T26/T30/T47-T59: synthesis-response/code-thought archive and emitter
  variants preserve useful mechanism evidence but do not beat classic on
  reference-complete PPA-front metrics.
- T72-T75 and T79: source-aligned RTL-native QD and budget-shape ablations
  show that exact shape-density front pressure is diagnostic-positive but
  negative against matched classic at `12x3`, `8x5`, and `6x7`.
- T83/T84 and auxiliary-archive probes: MasterRTL RF model-state and
  high-exploit auxiliary archives produce the closest single-seed clues, but
  replication and follow-up screens remain negative.
- T94/T95/T96/T99: Qwen/DeepGate/RF-DeepGate/AURORA-style encoder or
  encoder-like lanes now have bounded live evidence; none is spend-ready.
- T85/T86/T87/T97/T98/T100: front-guarded QD memory exists and is tested as an
  auxiliary-memory scheduler. T100 is the best FG-QDM smoke (`0.1566` mean HV)
  but still trails matched classic (`0.1903`) and is not promoted.
- T08/T09/T10/T12/T16/T18: early learned/proxy scaffolds are closed with
  measured retrospective evidence and explicit non-reproduction caveats.

`preliminary_planning/current_selection_status.md` is now the operational
shortlist. It records no full-RTLLM-spend-ready QD arm, keeps one best current
representative for each encoder/config category, and ranks the top ten QD
configurations by observed mean HV while labeling smoke-only and replicated
rows separately.

The current research answer is therefore negative but useful: generic
descriptor spread and direct encoder-axis swaps have not produced a robust
PPA-front win. The most defensible remaining story is QD as guarded auxiliary
memory for PPA-competitive RTL implementation families, but the completed
FG-QDM smokes show that even this framing needs a stronger memory-lane
front-add mechanism before larger RTLLM spend.

Completion is not yet proven. The remaining completion work is concentrated in
three areas: common passive-archive/metric coverage across all headline
packages, a concise central comparison report that states the negative map
without overclaiming, and independent adversarial validation of that exact
claim.

## Prior Evidence To Reuse

Use these as starting evidence and as warnings against repeated mistakes:

- `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/`
  tested random descriptors, manual BD, Yosys-stat, motif occupancy, ST-NOD,
  synthesis-response random features, and VQ/codebook variants.
- `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/`
  found final verdict `B illumination_only` after Qwen, DeepGate3, ST-NOD/SR,
  lineage, quality-gated novelty, near-motif suppression, and learned encoder
  diagnostics.
- `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/CONCLUSION.md`
  is the easiest summary of what failed and why.
- `docs/revolution_qd_map_elites_implementation_plan.md` records earlier live
  QD evidence, including long-token `20 x 5` runs where CVT filled broader
  archives on larger RTLLM tasks and beat classic best quality on
  `RTLLM/Prob045_alu`.
- `exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/`
  contains copied ASP-DAC release runs for DeepSeek, GPT-4.1-mini, and Llama3
  variants across RTLLM and VerilogEval. Verify any remote
  `aspdac2026-paper` ref at goal start, but this local replay source exists.

## Research Questions

1. Can any BD/QD method come close to classic REvolution while preserving more
   useful implementation families or Pareto-front options?
2. Can any descriptor improve best fitness, PPA hypervolume, valid-PPA count,
   or Pareto-front spread by even a small reproducible amount?
3. Did prior failures come from weak descriptors, overly aggressive diversity
   pressure, archive mechanics, missing sequential/netlist semantics, or a
   too-strict 10% threshold?
4. Which descriptor families are paper-defensible enough to describe as RTL
   netlist evolution methodology?
5. Can QD be defended with archive and Pareto metrics rather than average
   fitness or average best PPA?
6. Which benchmark subset best screens for differentiated PPA/front behavior
   without cherry-picking?
7. Does the current `12 x 3` budget shape bias results against QD by leaving
   too little depth for archive cells to mature?
8. Can any verified pretrained or retrained MasterRTL/RTLTimer tree-model
   outputs improve RTL-native BDs beyond raw source-aligned graph/count
   features, now that direct MasterRTL Area-head leaves failed the variation
   gate?

## Effectiveness Tiers

The old 10% replay threshold is too strict as the first filter. Use these
tiers instead:

- `T0 diagnostic`: runs and produces interpretable artifacts, but loses badly
  or collapses.
- `T1 near_classic`: within 2% relative HV/best-fitness loss or within noise
  of classic on at least one seed, with no classic-covered design loss and
  visible yield warnings for any large functionality, synthesis-valid, or
  valid-PPA drop.
- `T2 useful_bd`: any positive reproducible delta over classic or landing
  Smooth-QD on reference-complete PPA-front evidence such as global PPA
  hypervolume, Pareto spread, unique front families, or reference-beating
  candidates, while preserving coverage and best quality within guardrails.
  Passive archive QD score, archive coverage, Pareto-cell count, valid-PPA
  yield, and lineage yield are supporting evidence only.
- `T3 strong_win`: at least 10% gain or a statistically stable multi-seed win.

Do not discard a method just because it fails `T3`. Anything at `T1` or `T2`
deserves deeper analysis and a method package.

## Hard Constraints

- Compare against classic REvolution and landing Smooth-QD manual-BD whenever
  live or replay artifacts allow.
- Score classic and every QD method through a common passive archive so archive
  geometry does not bias the comparison.
- Keep model, benchmark subset, seeds, prompts, operators, budget, timeouts,
  and evaluation flow fixed across methods unless the plan records a versioned
  exception before running.
- For live LLM runs, use `vllm_runtime_guide.md` to select and preflight the
  endpoint, record served model metadata, and keep long-context token budgets.
- Do not use final PPA, reference PPA, fitness, hypervolume, or test pass rate
  as in-loop BD inputs. They may be evaluation labels, controls, or offline
  analysis outputs.
- Do not count duplicate netlists as diversity.
- Do not hide invalid-candidate funnel loss behind archive coverage.
- Do not promote any method without a method package and accept/reject report.
- Do not promote any method using only average fitness or average best PPA.
  Primary evidence must come from `metrics_and_acceptance.md`.
- Strict functionality retention: on the fixed compared subset and equal
  evolutionary budget, if classic REvolution has at least one valid functional
  PPA candidate for a design, the new method must also produce at least one
  valid functional PPA candidate for that design before it can be `T1` or
  higher.
- For the deadline RTLLM milestone, treat a 50 percent or larger relative
  decline in functionality rate, synthesis-valid rate, or valid-PPA yield as a
  warning rather than an automatic rejection, as long as every classic-covered
  design still has at least one valid QD PPA candidate. Below 10 classic
  passing samples, report raw counts as `small_n_validity` and do not promote
  or reject the method from the relative rate alone.
- Freeze the screening subset before method outcomes are reviewed. Replacement
  must follow `screening_subset_selection.md`.
- Do not stop the push early unless the stop condition in
  `anti_reward_hacking_policy.md` is satisfied.
- New code must follow `code_organization_policy.md` and `GUIDELINES.md`: clean
  shared evaluators, typed simple modules, and no broad fallback/back-compat
  clutter.
- The main uv environment is not a hard dependency gate. If a proposed method
  conflicts with the repo environment, create an isolated uv environment under
  `exp/useful_bd_push/envs/<technique>/<timestamp>/` or clone the external repo
  under `exp/useful_bd_push/sources/<technique>/`; use submodules only when a
  source repo must become versioned reproducibility material.
- MasterRTL/RTLTimer paper-facing claims require model-path honesty. Extractor
  features may be described as source-aligned RTL-native structural descriptors;
  pretrained-model descriptors require recorded commits, file hashes,
  successful weight loading, feature-schema assertions, and upstream inference
  reproduction before any live QD result can claim them.
- New code must include docstrings for non-obvious helpers and keep docs,
  comments, and report guidance updated with each implementation batch.
- Figures and reports must follow `visualization_reporting_policy.md`; inspect
  generated images before accepting a technique package.

## Required Technique Package

Every attempted technique must have a subdirectory:

```text
techniques/<technique_slug>/
  methodology.md
  results_report.md
  artifacts_manifest.md
  figures/
  tables/
```

`methodology.md` must be detailed enough for a paper methodology section and
for recreation: inputs, preprocessing, descriptor formula or model, fitting
data, leakage exclusions, archive mapping, parent-selection coupling,
runtime/dependencies, commands, and expected outputs.

`results_report.md` must include tables and figure links after the technique
runs: validity funnel, PPA/HV/best-fitness comparison, archive coverage,
unique netlist/motif counts, duplicate accounting, runtime, and a clear
conclusion with tier (`T0` to `T3`).

The report and figures must be easy to understand. A technique is not complete
until its plots have been visually inspected and its conclusion explains what
was answered, what was not answered, and what should be tried next.

## Candidate Technique Families

Start with these packages and add more only with a method card:

- `T01_simple_yosys_stat_bd`: strong simple control over deterministic synthesis
  statistics.
- `T02_motif_pathlet_bd`: netlist motifs, pathlets, fanout, reconvergence, and
  sequential cone balance.
- `T03_synthesis_delta_stnod_bd`: stage-to-stage synthesis response, not just
  final netlist counts.
- `T04_autoqd_mmd_synthesis_bd`: AutoQD-inspired random Fourier features over
  synthesis/event occupancy vectors.
- `T05_vq_elites_codebook_bd`: VQ/codebook archive over non-PPA implementation
  vectors.
- `T06_qwen_projection_bd`: Qwen3 embeddings with projection heads, contrastive
  positives/negatives, and identifier/comment stability controls.
- `T07_deepgate_family_bd`: DeepGate2/3/4-style AIG encoders with cone splitting
  and non-collapse tests.
- `T08_sequential_deepseq_bd`: DeepSeq/DeepSeq2-style sequential netlist features
  and state-aware handcrafted controls.
- `T09_nettag_text_graph_bd`: text-attributed graph descriptors over mapped gates
  and Boolean-expression summaries.
- `T10_circuitfusion_multimodal_bd`: multimodal RTL text, graph, and functionality
  summary descriptors.
- `T11_mgvga_contrastive_bd`: masked-gate and Verilog-AIG alignment style
  self-supervised descriptor.
- `T12_lineage_repair_bd`: descriptors based on parent-child repair, operator
  yield, and descendant utility.
- `T13_aurora_incremental_autoencoder_bd`: AURORA-style learned descriptors with
  fixed refresh checkpoints and passive-archive audit.
- `T14_dehnn_hypergraph_bd`: directed hypergraph netlist representation for
  long-range multi-pin interactions.
- `T15_masterrtl_sog_bd`: bit-level simple operator graph descriptor before full
  synthesis.
- `T16_deepcell_multiview_bd`: post-mapping plus AIG multiview descriptor.
- `T17_mome_pareto_archive_bd`: multi-objective QD with local Pareto fronts inside
  descriptor cells.
- `T18_adaptive_emitter_cvt_bd`: CVT archive with fixed explore/exploit/repair
  emitter mixture.
- `T37_t36_slot_count_ablation`: explicit bounded-front slot-count ablation
  for the T36/T11 replay lead.
- `T38_elite_pareto_slot_live_qd`: live champion-plus-one-Pareto-slot archive
  mode for the T37 one-slot boundary.

At least 10 technique packages must be attempted with real results before the
goal can claim a completed negative map. Prior failed methods can be reused as
controls, but at least 10 methods in this push must have current tables,
figures, and result reports.

## Wide-Net Search Notes

Primary-source methods worth considering:

- MAP-Elites and CVT-MAP-Elites define the archive mechanics and scalable
  high-dimensional cell assignment.
- AURORA, AutoQD, and VQ-Elites motivate automatic or learned BDs, but must be
  adapted to RTL without using PPA leakage.
- DeepGate2/3/4, DeepSeq/DeepSeq2, NetTAG, CircuitFusion, MGVGA, DeepCell, and
  DE-HNN are relevant circuit/netlist representation families.
- Some methods may not be directly runnable. If so, create a faithful
  lightweight surrogate using the same representation principle, and record
  what was approximated.

## Evaluation Surface

Each method should emit:

- run root under `exp/useful_bd_push/<technique>/<timestamp>/`;
- method package updates under `techniques/<technique>/`;
- `methodology.md` with frozen spec and command lines;
- `tables/*.csv` with raw and summarized results;
- `figures/*.png` with readable visual summaries;
- `results_report.md` with tier decision and next-step recommendation;
- centralized comparison report across all attempted techniques.

Required metrics:

- generated, syntax-valid, functional, synthesis-valid, valid-PPA, and
  Pareto-front counts;
- global PPA hypervolume, passive archive QD score, passive archive coverage,
  Pareto-cell count, Pareto spread, unique front families, and valid-PPA yield;
- QD-score AUC, coverage AUC, and hypervolume AUC for live runs;
- best fitness, area/power/timing minima, and Pareto size as secondary
  diagnostics;
- classic-covered problem retention;
- unique canonical netlists and motif signatures;
- archive occupancy, entropy, QD score, and common-audit coverage;
- duplicate and near-duplicate suppression impact;
- runtime, dependency cost, and fitting/inference cost;
- vLLM endpoint metadata, token budgets, and blocked live-run status where
  applicable;
- per-seed and per-problem deltas against classic and landing Smooth-QD.

## Iteration Policy

Start cheap and broad, then escalate:

1. build or reuse a common evaluator/report that every technique writes into;
2. rerun simple controls under the lower tier policy;
3. try fixed, deterministic descriptors before learned encoders;
4. try projection/codebook descriptors over stable hardware vectors;
5. try MOME-style Pareto archives and adaptive CVT emitters on the best cheap
   descriptor before assuming descriptor learning is the only lever;
6. try Qwen/DeepGate/NetTAG/CircuitFusion/MGVGA-style encoders only with
   explicit dependency setup, fitting corpus, and collapse/leakage tests;
7. run bounded live sampling only after replay or diagnostics produce a `T1`
   or `T2` candidate.

After each attempt, update the technique package and central history before
starting the next method. Commit regularly.

After each `T0`, add at least one follow-up idea, ablation, or hybrid to
`idea_backlog.md` or the implementation history before moving on.

## Current Validation Target

The current target is no longer a single T40-T43 follow-up. It is to turn the
completed wide-net run evidence into a rigorous final claim:

1. no QD configuration is promoted for full RTLLM spend yet;
2. T100 is kept as the best FG-QDM category representative, not a positive
   result;
3. T83 and the high-exploit auxiliary archive remain the closest MasterRTL
   model-state/archive clues, but their replicated evidence is negative;
4. T95/T96/T99 keep the best DeepGate, RF/DeepGate, and AURORA-style encoder
   representatives visible without overstating them; and
5. final sign-off requires passive-archive/metric completeness and an
   adversarial validation report, not another small descriptor-axis swap.

The next live run should not launch until it changes the mechanism in a way
that could plausibly improve memory-lane front contribution per LLM call, or
until the final negative-map audit identifies a specific missing comparison
that cannot be answered from existing artifacts.

## Completion Gates

- [ ] At least 10 technique packages have real results, not placeholders,
      before any broad negative conclusion is signed off.
- [ ] At least one simple control, one synthesis/netlist descriptor, one
      learned/projection descriptor, and one archive-coupling variant are
      attempted.
- [ ] The selected screening subset and any holdout are frozen and justified
      before method outcomes are interpreted.
- [ ] Metrics include passive archive coverage/QD score, global PPA
      hypervolume, Pareto spread/cell count, unique front families, and
      validity funnels.
- [ ] Every attempted technique has methodology, tables, figures,
      `results_report.md`, and an accept/reject/tier decision.
- [ ] Central report compares methods against classic and landing Smooth-QD.
- [ ] Generated figures are visually inspected and pass
      `visualization_reporting_policy.md`.
- [ ] Technique and central conclusions are concise, precise, and explain the
      evidence behind each tier decision.
- [ ] Claims use `T0` to `T3` tiers and do not overclaim optimization utility.
- [ ] Tests/lint/type checks for touched scripts pass or blocked results are
      recorded.
- [ ] New code follows `code_organization_policy.md` with focused shared
      modules rather than method-specific clutter.
- [ ] New code updates docstrings, comments, and docs where needed.
- [ ] Adversarial validation returns PASS for the stated claim.

## Risks And Blockers

- Encoders may be hard to install or may not expose usable checkpoints.
  Dependency failure is not a blocker until `uv add`, an isolated per-method
  uv env, source checkout, and submodule decision have been tried and logged.
- Live sampling may be expensive. Use replay first, then run a bounded D4-style
  live experiment only for candidates that reach `T1` or `T2`.
- A method can game diversity by producing invalid or duplicate designs.
  Validity funnels and duplicate accounting are mandatory.
- Missing reference `ppa.txt` can make normalized improvement, HV, and HV-AUC
  misleading. Direct classic-vs-QD headline claims must use the
  reference-complete paired subset; missing-reference designs are
  diagnostic-only unless a real reference PPA is added before analysis.
- A method can look good from one easy problem. Require per-problem deltas and
  classic-covered problem retention before claiming usefulness.
- A method can exploit a loosened threshold. Use the tier system to continue
  promising work, but keep the anti-loophole rules in
  `anti_reward_hacking_policy.md` binding.

## References

- MAP-Elites: https://arxiv.org/abs/1504.04909
- CVT-MAP-Elites: https://arxiv.org/abs/1610.05729
- AURORA: https://arxiv.org/abs/1905.11874
- AutoQD: https://arxiv.org/abs/2506.05634
- VQ-Elites: https://arxiv.org/html/2504.08057v1
- DeepGate2: https://arxiv.org/abs/2305.16373
- DeepGate3: https://arxiv.org/abs/2407.11095
- DeepGate4: https://arxiv.org/abs/2502.01681
- DeepSeq: https://arxiv.org/abs/2302.13608
- DeepSeq2: https://arxiv.org/abs/2411.00530
- NetTAG: https://arxiv.org/abs/2504.09260
- CircuitFusion: https://arxiv.org/abs/2505.02168
- MGVGA: https://openreview.net/forum?id=US9k5TXVLZ
- DeepCell: https://arxiv.org/html/2502.06816v1
- DE-HNN: https://arxiv.org/abs/2404.00477
- MasterRTL: https://github.com/hkust-zhiyao/MasterRTL
- RTL-Timer: https://github.com/hkust-zhiyao/RTL-Timer
- RTL-Timer paper: https://arxiv.org/abs/2403.18453
- Multi-Objective QD: https://arxiv.org/pdf/2202.03057
- Discretization-free QD metrics:
  https://www.research.autodesk.com/publications/a-discretization-free-metric-for-assessing-quality-diversity-algorithms/
- QD-score AUC: https://btjanaka.net/static/qd-auc/qd-auc-paper.pdf
- MEMES: https://arxiv.org/html/2303.06137v2
