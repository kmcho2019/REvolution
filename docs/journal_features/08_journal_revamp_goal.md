# 08. Journal Revamp Goal

## Purpose

This document is the source-of-truth goal spec for the TCAD journal-extension
revamp of REvolution. It turns the June 2026 ruminations into an executable
research and implementation plan with quantitative gates.

The branch for this work is `feat/journal-revamp-20260612-005012-kst`, created
from `wip/journal-extension-2026`. The timestamped goal-scaffold directory is:

`docs/journal_features/revamp_history/20260612_005012_KST_journal_revamp/`

The older RealBench worktree at `/workspace/.worktrees/realbench_integration_draft`
is a reference only. Do not merge it directly.

## Original Submission Context

Before implementing or rewriting journal claims, read the frozen ASP-DAC paper
sources as context. These files are read-only for normal revamp work:

- `docs/journal_features/resources/README.md`: submodule rules and manuscript
  workflow.
- `docs/journal_features/resources/conference_submission_paper/main.tex`:
  submitted paper entry point and abstract.
- `docs/journal_features/resources/conference_submission_paper/content/1_intro/v_camera.tex`:
  original motivation, local-search argument, and contribution framing.
- `docs/journal_features/resources/conference_submission_paper/content/3_method/v_camera.tex`:
  original Thought/Code/Feedback representation, scalar weighted fitness,
  dual-population loop, prompt operators, and UCB-softmax strategy selection.
- `docs/journal_features/resources/conference_submission_paper/content/4_expnrst/v_camera.tex`:
  original benchmark setup, LLMs, pass-rate/PPA metrics, case study, and
  evolutionary-loop ablation.
- `docs/journal_features/resources/conference_submission_paper/table/result.tex`:
  original headline result table.

Journal edits should go to the active manuscript repo:

- `docs/journal_features/resources/journal_draft/sections/3_method_journal_extension.tex`
- `docs/journal_features/resources/journal_draft/sections/3_method.tex`
- `docs/journal_features/resources/journal_draft/sections/4_exp.tex`

Use the conference repo to understand what was claimed and what reviewers are
reacting to. Do not modify or push it unless explicitly asked to update the
frozen reference.

## Comparative Baseline Resources

The repository already contains archived runs for recent evolutionary
algorithm-style baselines applied to RTL tasks. Use these as context for likely
reviewer questions about how REvolution compares to other evolutionary
frameworks, but do not treat them as final journal evidence until they are
revalidated under the revamp's locked benchmark, seed, model, scheduler, and
reporting gates.

Useful baseline archive roots:

- `baselines/20260316_120539__447c0128__funsearch/`: FunSearch-style baseline
  archive with REvolution comparison summaries.
- `baselines/20260316_120708__447c0128__codeevolve/`: CodeEvolve-style
  baseline archive, including a four-way comparison summary.
- `baselines/20260316_120813__447c0128__eoh/`: EoH-style baseline archive with
  REvolution and FunSearch comparison summaries.
- `baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv`: hard
  subset reference material for local `openai-gpt-oss-120b` baseline runs.

Each archive contains provenance, config snapshots, summaries, and compressed
raw candidate artifacts. If a final TCAD table includes these algorithms, rerun
or revalidate them under the same problem lists, seeds, model capability policy,
token budgets, evaluator settings, scheduler policy, and statistics as classic
REvolution and QD REvolution. Label older archived results as retrospective
context unless that revalidation is complete.

## Core Thesis

The journal extension should move REvolution from scalar-fitness, operator-bandit
RTL evolution toward thought-level, quality-diverse, Pareto-aware design-space
search. The paper should argue that RTL optimization is not just a single-score
hill-climb problem: useful RTL variants occupy different structural regions,
trade off area/power/timing differently, and require benchmark evidence beyond
small RTLLM and VerilogEval tasks.

The implementation must support that thesis with measurable artifacts:

- MAP-Elites diversity pressure over RTL descriptors.
- Per-cell Pareto fronts instead of scalar weighted-sum replacement.
- A unified thought-level evolutionary operator instead of arbitrary prompt
  operator selection.
- Benchmark breadth through CVDP and RealBench integration.
- Reproducible multi-seed evidence, statistics, and run ledgers.
- Faster evaluator scheduling so journal-scale experiments are feasible.

## Method Evolution Rule

The seven existing journal-extension feature pillars are a starting structure,
not a sacred boundary. If a new idea is technically sound, works well in
testing, improves or preserves the predeclared performance gates, and fits the
journal narrative more naturally, the revamp may modify, replace, or regroup
the existing pillars.

This flexibility has a strict condition: narrative and empirical evidence must
move together. A clever feature with weak results should not become a headline
contribution, and a metric improvement with an awkward or unconvincing story
should not drive the manuscript. The final method should be simple to explain,
compelling to TCAD reviewers, and justified by fair comparisons.

## Reviewer Critique Map

| Critique | Method response | Evidence required |
| --- | --- | --- |
| Weighted PPA averages bias search and hide Pareto structure. | Use bounded per-cell Pareto fronts with NSGA-II crowding and no scalar archive replacement. | Hypervolume, Pareto cardinality, win-rate, paired PPA deltas, and no-reference metric suppression where references are absent. |
| Evolutionary operators look arbitrary and inherited from EoH. | Use one unified thought-generation operator with one or two parent thoughts. | Operator-selection ablation is replaced by a clear removed-degree-of-freedom argument plus EoH/classic baselines. |
| Bandit/RL operator selection claims lack ablation support. | Do not make a central bandit/RL claim for the journal method unless a controlled ablation is added. | Manuscript and configs must not overclaim unsupported operator-bandit benefits. |
| Benchmarks are too small. | Add CVDP and RealBench benchmark paths with locked subsets and full manifests. | Functional pass rates, synthesis/PPA availability, benchmark-family reports, and task manifests. |
| Evolution lacks diversity pressure. | Use QD/MAP-Elites with descriptor-health reporting and descriptor-ablation evidence. The final behavior descriptor profile is not required to be the current BD trio. | Occupancy, entropy, collapse rate, descriptor/PPA correlation, descriptor-profile comparisons, and a persuasive descriptor narrative. |

## Rumination Coverage Audit

This plan is suitable for the June 2026 ruminations if each concern below is
preserved during implementation. The goal is intentionally strict because a
journal extension should survive skeptical review, not merely add features.

| Rumination intent | Covered by this goal | Remaining implementation pressure |
| --- | --- | --- |
| Replace weighted-average PPA as the core search objective. | Per-cell Pareto fronts, hypervolume, paired PPA deltas, and no-reference metric suppression. | Reports must prove archive replacement is not secretly scalarized. |
| Avoid arbitrary EoH-style evolutionary operators. | Unified thought-level operator and removed bandit/operator-selection claim. | Manuscript must clearly downgrade or remove unsupported UCB-softmax claims from the journal method. |
| Support the original paper's bandit/RL-adjacent claims with evidence or stop claiming them. | Reviewer critique map and narrative gate require claim narrowing unless ablations are added. | Any remaining bandit language in the journal draft must be justified or deleted. |
| Move beyond small RTLLM/VerilogEval benchmarks. | CVDP and RealBench workstreams, manifests, deterministic replay, and model-capability gate. | Benchmark integration must reach end-to-end evolutionary runs, not just loaders. |
| Add real diversity pressure. | QD/MAP-Elites, descriptor-health gates, occupancy/entropy/collapse metrics, descriptor-profile comparison, and freedom to replace the initial BD trio. | Descriptor axes must improve PPA search, represent diversity, and support a strong narrative. |
| Repair QD underperformance against classic REvolution. | Explicit QD performance-repair workstream and final classic-vs-QD gates. | If QD cannot beat classic under fair budgets, claims must be narrowed rather than hidden. |
| Make thought-only evolution central. | Thought-level thesis, unified operator, thought-only `k=4` target config, repair-budget accounting. | Thought/code mismatch must be measured through k-code success and repair artifacts. |
| Handle long, difficult RealBench tasks honestly. | Local-first model policy, DeepSeek capability-escalation probe, symmetric model arms, long-token budgets. | DeepSeek must not be used as one-sided rescue after seeing failures. |
| Allow better ideas to reshape the current seven pillars. | Method evolution rule permits replacing or regrouping pillars when testing and narrative both improve. | Any added feature must pass fair gates and strengthen, not fragment, the journal story. |
| Create a persuasive journal story. | Required `journal_narrative.md` and four adversarial reviewer personas. | Narrative signoff should happen before final experiments, not after plots are already chosen. |
| Make evaluation fast enough for journal-scale runs. | Scheduler telemetry, elastic worker controls, and 25 percent throughput gate. | Throughput gains must preserve candidate outcomes and comparison fairness. |

## Required Workstreams

### 1. Benchmark Capability Model

Extend benchmark metadata so runners and reports know what each suite can
legitimately claim:

- `supports_functional`
- `functional_harness_kind`
- `supports_synthesis`
- `supports_post_synth_check`
- `supports_reference_ppa`
- `ppa_mode`
- `top_module`
- `clock_metadata`
- `reset_metadata`
- `aux_files`
- `timeout`
- `license_tag`

CVDP starts from
`data/bench/cvdp/cvdp_v1.0.2_nonagentic_code_generation_no_commercial.jsonl`
and the official code under `exp/cvdp_benchmark`. It must report functional
pass rate as the headline metric. If synthesis/PPA is added, CVDP reports
absolute area/power/timing only. It must not report reference-normalized gains
or suite-blended hypervolume unless a vetted reference protocol is introduced.

RealBench starts from the dataset under `exp/RealBench`. The old draft worktree
can inform parsing and harness details, but this branch must implement its own
clean manifest/evaluator path.

### 2. Faster Evaluation Scheduling

Journal-scale runs must use the existing elastic parallelism controls and add
measurement where needed:

- Prefer `scripts/run_backend.py` with `--total_worker_slots`,
  `--max_active_problems`, and `--max_workers_per_problem`.
- Audit `src/revolution/runtime/parallelism.py`,
  `src/revolution/runtime/candidate_evaluator.py`, and benchmark harnesses for
  CPU/tool oversubscription and long-problem head-of-line blocking.
- Add queue-level work stealing or adaptive problem scheduling if current slot
  leasing leaves workers idle on heterogeneous CVDP/RealBench tasks.
- Emit scheduler telemetry: wall time, candidate eval/sec, worker occupancy,
  per-problem wait time, per-problem active time, timeout count, and retry count.
- Apply the same scheduler policy to classic and QD runs in comparisons.

The throughput gate is part of completion: on a fixed local evaluator replay or
bounded smoke harness, the revamp scheduler must reduce wall-clock time by at
least 25 percent versus a fixed per-problem worker baseline without changing
candidate outcomes. Live LLM runs must at least record occupancy and show no
deadlocks or abandoned work.

### 3. QD Performance Repair

The primary target configuration is:

- `grid_quantile`
- `journal_logic_ff_width_3d`
- Pareto-front archive cells
- unified `single_thought_operator`
- thought-only representation with `k=4`
- KS-triggered adaptive re-binning

Repair attempts and k-code samples count as real evaluation budget. Either
disable repair for final comparisons or give classic and QD symmetric repair
budget so QD does not win by hidden extra attempts.

The implementation must identify why
`grid_quantile_pareto_journal_bd_unified_rebin_on` underperforms classic
REvolution on hard-subset tests, then fix or document the mechanism. Candidate
causes include descriptor collapse, archive under-occupancy, poor parent
selection, thought/code mismatch, repair-budget accounting, and scheduler
starvation.

### 4. Descriptor Evidence

The current descriptor trio is `logic_depth`, `ff_depth`, and
`comb_width_log`. Treat it as an initial hypothesis, not a design lock. The
revamp is free to explore alternate MAP-Elites behavior descriptor profiles as
long as the final profile performs well, represents design diversity, and has a
sound, powerful, persuasive journal narrative.

Candidate descriptor profiles may use structural, graph, testability,
simulation/activity, physical, or hybrid RTL features already available or
reasonably added to the evaluation stack. Learned or high-dimensional
descriptors may be explored only if their cost, determinism, and interpretability
are compatible with the journal schedule and reproducibility requirements.

Before final publication experiments, pre-register the descriptor profiles to be
compared and freeze one final profile. Do not choose axes post hoc from final
test plots. The decision requires:

- occupied cell fraction,
- descriptor entropy,
- axis collapse rate,
- feature/PPA correlation,
- feature/pass-rate correlation,
- per-family descriptor distributions,
- comparison against at least one simpler descriptor profile,
- paired QD-vs-classic PPA evidence using the descriptor profile,
- stability across seeds and benchmark families,
- a concise manuscript rationale explaining why the axes correspond to
  meaningful RTL design differences.

If an axis collapses on a task family for structural reasons, the report must
label that family explicitly rather than hiding the collapse in aggregate plots.
If a new descriptor profile beats the original trio on PPA and diversity gates,
prefer the new profile and update the journal narrative accordingly.

### 5. Narrative And Adversarial Review

Create `docs/journal_features/journal_narrative.md` before final experiments.
It must connect the method to the reviewer critiques without awkwardly listing
features. The narrative should be short enough to be usable in the manuscript
but concrete enough to determine what experiments are necessary.

Four adversarial reviewer personas must sign off before the narrative is
accepted:

- TCAD editor,
- skeptical Reviewer 2,
- hardware/EDA methodology reviewer,
- reproducibility/statistics reviewer.

Any blocking persona review requires a revision or an explicit downgraded claim.

## Model And Budget Rules

Use the local vLLM endpoint first:

```bash
curl http://host.docker.internal:8000/v1/models
```

Expected current model: `openai-gpt-oss-120b` with `max_model_len=131072`.
Reasoning-model experiments must use long budgets:

- `--max_tokens 128000`
- `--diff_max_tokens 128000`

DeepSeek `deepseek-v4-pro` through the existing `deepseek` backend is allowed
as a predeclared capability-escalation arm. The API key is loaded from `.env`
as `DEEPSEEK_API_KEY` and consumed by `src/revolution/llm.py`. Never print the
key, copy it into configs, include it in run logs, or commit `.env`. Preflight
should check only that the variable exists, for example with a non-echoing shell
test after loading `.env`.

DeepSeek runs should use the same long-context posture as local reasoning-model
runs:

- `--api_backend deepseek`
- `--model_name deepseek-v4-pro`
- `--max_tokens 128000`
- `--diff_max_tokens 128000`
- `256000` token budgets may be used for explicitly labeled long RealBench
  probes if the backend/provider supports them and the same setting is applied
  symmetrically across compared methods.

The reason for allowing DeepSeek is substantive: some RealBench tasks may be
long enough that the local `openai-gpt-oss-120b` endpoint cannot produce a
conclusive answer, even if the REvolution method is sound. That concern must be
handled with a fixed model-capability rule rather than ad hoc rescue.

Before final RealBench claims, create a locked `realbench_long_model_probe`
subset with at least 8 of the longest/densest RealBench tasks by prompt size,
auxiliary-file footprint, or harness complexity. Run the local vLLM model and
DeepSeek on the same probe with the same prompt profile, scheduler policy,
population/generation budget, repair policy, and evaluator timeout.

The local model is considered insufficient for RealBench final claims if any of
these predeclared conditions hold on the locked probe:

- more than 10 percent of attempts fail from context overflow, provider length
  limits, or length-truncated completions;
- fewer than 25 percent of probe tasks produce any syntactically valid RTL
  candidate;
- fewer than 15 percent of probe tasks produce any functional-pass candidate
  while DeepSeek reaches at least 30 percent on the same probe.

If local vLLM fails this gate and DeepSeek passes it, DeepSeek may become the
primary RealBench model arm, but classic and QD must both run on DeepSeek for
the same locked task/seed set. Local-model results should then be reported as a
model-capability limitation, not used to cherry-pick method wins. If both local
and DeepSeek fail the probe, RealBench claims must be narrowed to integration
and harness readiness rather than optimization quality.

DeepSeek is not an ad hoc rescue path for only failed QD cases. If used in a
final comparison, it must be used symmetrically for classic and QD on the same
locked problem/seed set with comparable token budgets.

## Quantitative Gates

### Single-Seed Debug Gate

This is for implementation readiness only. It is not publishable evidence.

- Seed `42` is used for the first locked debug pass.
- Hard-subset classic and QD runs complete.
- CVDP debug slice contains 10 locked medium no-commercial tasks, balanced
  across available challenge categories such as `cid002` and `cid003`.
- RealBench debug slice contains 12 locked module tasks, balanced across major
  available families such as SDC, AES, and E203.
- Classic and QD use the same model, token budgets, population/generation
  budget, evaluator timeout, scheduler policy, and toolchain.
- QD solved count is at least classic on each suite, or any deficit has a
  root-cause issue with a concrete fix before final experiments.
- QD has nonzero archive occupancy, archive summaries, `qd_metrics.json`,
  descriptor-health artifacts, and no fatal descriptor collapse.
- Scheduler telemetry is emitted for every run.
- DeepSeek credential preflight is documented without exposing
  `DEEPSEEK_API_KEY`.
- The RealBench long-model probe is generated and run, or explicitly deferred
  with RealBench final claims blocked until it exists.

### Final Publication Gate

Freeze the final QD config, prompts, benchmark lists, seeds, model settings,
timeouts, scheduler policy, and tool versions before running final experiments.

Final evidence requires 5 fixed seeds. The statistical unit is the problem-seed
pair. Missing QD data where classic succeeds counts as a QD loss.

For reference-PPA suites such as RTLLM and VerilogEval:

- Mean paired best-quality delta is at least `+0.03`.
- Mean paired average PPA-improvement delta is at least `+0.05`.
- Global Pareto hypervolume relative improvement is at least `+5%`.
- Bootstrap 95% confidence interval lower bound is greater than `0` for best
  quality and hypervolume.
- QD win rate is at least `60%` over non-tied problem-seed pairs.
- Valid-PPA any-pass count is at least classic.

For CVDP:

- Functional pass-rate delta is at least `+5` percentage points.
- Bootstrap 95% confidence interval lower bound is greater than `0`.
- Any PPA reporting is absolute-only and family-scoped.

For RealBench:

- Functional any-pass count is at least classic.
- If synthesis/PPA is stable, report family-scoped absolute PPA plus any
  reference-normalized metrics only when the benchmark supplies a valid
  reference implementation.
- At least 90 percent of manifested tasks must produce deterministic harness
  outcomes in replay.

For descriptors:

- Median occupied-cell fraction is at least `0.25` on QD-compatible suites.
- No more than one descriptor axis may collapse per problem unless the report
  explicitly explains the structural reason and excludes the case from that
  descriptor claim.
- Descriptor-profile comparison must show that the selected profile is not a
  purely decorative axis choice.
- The selected descriptor profile must be frozen before final experiments and
  must not be chosen using final-result cherry-picking.
- The selected descriptor profile must be tied to a persuasive RTL-design-space
  narrative, not only to numeric occupancy plots.

For scheduling:

- Fixed local evaluator replay or bounded smoke harness shows at least `25%`
  wall-clock reduction versus fixed per-problem worker allocation.
- Candidate outcomes are unchanged relative to the baseline scheduling run.
- Worker occupancy and timeout/retry telemetry are included in final reports.

## Required Artifacts

- `scripts/validate_journal_revamp_run.py`
- locked benchmark manifests and seed manifests
- `paired_deltas.csv`
- `statistical_tests.json`
- `statistical_tests.md`
- scheduler telemetry files
- benchmark-family summary reports
- descriptor-health and design-space reports
- `docs/journal_features/journal_narrative.md`
- `docs/journal_features/revamp_history/<timestamp>_journal_revamp/`

## Completion Definition

This goal is complete only when the code, reports, and manuscript narrative
support the same claims. A run that improves one metric while failing the
predeclared statistical, descriptor, benchmark, or scheduler gates is not
complete. Claims should be narrowed instead of patched with post-hoc exceptions.
