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
- Screening subset selection: `screening_subset_selection.md`
- Anti-reward-hacking policy: `anti_reward_hacking_policy.md`
- Code organization policy: `code_organization_policy.md`
- Visualization/reporting policy: `visualization_reporting_policy.md`
- Local vLLM runtime guide: `vllm_runtime_guide.md`
- Continuing idea backlog: `idea_backlog.md`
- Technique packages: `techniques/<technique_slug>/`

## Current Research State

T13 is the most recent completed package. It is an implementation-feature and
AURORA-style learned-BD replay: raw implementation features beat lexical HV
by `+1.06%` and improve unique PPA points, but compressed PCA/RFF/incremental
bottlenecks lose HV and raw features still miss lexical direct front hits. It
is a feature-input lead, not a promoted useful-BD claim.

T30 remains the most recent positive holdout support for exact T26
conservative-exploit SR raw: it preserves all three classic-covered
VerilogEval holdout designs and improves mean final-best score by 9.91%. It is
not a QD-front promotion because valid-PPA yield drops, P098 has a per-problem
yield warning, and front/netlist breadth does not improve.

T31 is completed and retired as `T0 diagnostic`. Same-budget failure feedback
kept final-best coverage alive, but it did not repair P098 yield, did not
preserve T26's P135 HV/quality signal, and did not widen the raw PPA Pareto
front. The next method should split champion, near-front, and bounded-repair
emitter roles instead of replacing archive-parent requests with direct
fail-feedback repair. Any T32-style follow-up must
include straightforward raw PPA Pareto figures with conventional
lower-left-better axes.

T32 is completed and retired as `T0 diagnostic`. It improves P098 valid PPA
versus T26/T31 and improves unique PPA points versus T31, but it does not
preserve T26's P135 quality/HV signal and mean HV/HV-AUC remain zero. The next
same-family method should not keep nudging champion fraction or two-parent
probability alone; it needs a stronger role-separated emitter or a branch to a
different descriptor family.

The learned-encoder lane should preserve the T13 raw implementation-feature
signal while adding feature selection, local-Pareto coupling, a contrastive
graph objective, or a true graph/AIG encoder. Do not spend the next attempt on
plain unsupervised PCA/RFF compression. Any follow-up must include
straightforward raw PPA Pareto figures before BD-space projections are used.

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

## Effectiveness Tiers

The old 10% replay threshold is too strict as the first filter. Use these
tiers instead:

- `T0 diagnostic`: runs and produces interpretable artifacts, but loses badly
  or collapses.
- `T1 near_classic`: within 2% relative HV/best-fitness loss or within noise
  of classic on at least one seed, with no classic-covered design loss and no
  catastrophic functionality/synthesis-validity collapse on comparison units
  where the classic baseline has at least 10 passing samples.
- `T2 useful_bd`: any positive reproducible delta over classic or landing
  Smooth-QD on global PPA hypervolume, passive archive QD score, passive
  archive coverage, Pareto-cell count, Pareto spread, unique front families,
  valid-PPA yield, or lineage yield, while preserving coverage and best quality
  within guardrails.
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
- Do not accept a method with catastrophic validity collapse. A 50 percent or
  larger relative decline in functionality rate or synthesis-valid rate versus
  classic is a `T0` result only when classic has at least 10 passing samples
  for the corresponding stage in the compared unit. Below that count, report
  raw counts as `small_n_validity` and do not promote or reject the method from
  the relative rate alone.
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
- DeepCell: https://arxiv.org/html/2502.06816v1
- MasterRTL: https://github.com/hkust-zhiyao/MasterRTL
- Multi-Objective QD: https://arxiv.org/pdf/2202.03057
- Discretization-free QD metrics:
  https://www.research.autodesk.com/publications/a-discretization-free-metric-for-assessing-quality-diversity-algorithms/
- QD-score AUC: https://btjanaka.net/static/qd-auc/qd-auc-paper.pdf
- MEMES: https://arxiv.org/html/2303.06137v2
