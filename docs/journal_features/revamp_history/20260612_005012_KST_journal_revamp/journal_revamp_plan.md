# Journal Revamp Plan

## Scope

This scaffold captures the execution plan for revamping the REvolution journal
extension toward a TCAD-ready submission. It is derived from
`docs/journal_features/revamp_ruminations_20260612.md` and the top-level goal
spec at `../../08_journal_revamp_goal.md`.

The work is intentionally broader than a single feature. It must integrate
harder RTL benchmarks, repair the current QD/MAP-Elites performance gap,
establish defensible descriptor evidence, create a coherent journal narrative,
and make evaluation scheduling fast enough for multi-seed experiments.

## Branch And Baseline

- Working branch: `feat/journal-revamp-20260612-005012-kst`.
- Base branch: `wip/journal-extension-2026`.
- Manuscript-resource setup checkpoint: `26c3d79264`
  (`docs(journal): add manuscript submodules`).
- Conference manuscript source:
  `docs/journal_features/resources/conference_submission_paper/`.
  Treat this as frozen submitted source.
- Journal manuscript source:
  `docs/journal_features/resources/journal_draft/`.
  Commit manuscript edits inside that submodule before updating the parent
  pointer.
- RealBench draft reference:
  `/workspace/.worktrees/realbench_integration_draft`.
  Use for ideas only; do not merge it.

## Target Contribution Shape

The final journal story should be:

REvolution evolves architecture-level thoughts and evaluates their RTL
realizations in a quality-diverse, Pareto-aware archive. This avoids treating
RTL generation as a scalar PPA hill climb, removes arbitrary prompt-operator
selection from the core method, and produces evidence over larger benchmark
families with reproducible multi-seed statistics.

The plan must prevent three failure modes:

- QD looks more complicated but underperforms classic REvolution.
- Descriptor choices look arbitrary or collapse on most tasks.
- New benchmark support exists but is too partial to support journal claims.
- The paper keeps the original seven feature pillars even after a better tested
  idea would produce a cleaner story and stronger performance.

The seven existing feature pillars are starting scaffolding, not a hard
constraint. If a new idea is technically sound, validates well, improves or
preserves the quantitative gates, and fits the emerging journal narrative, the
revamp may modify, replace, merge, or split those pillars. The bar is high:
the change must make both the story and the evidence stronger.

## Original Submission Context

Read the frozen ASP-DAC submission before changing the journal narrative. Treat
these files as read-only context:

- `../../resources/README.md`
- `../../resources/conference_submission_paper/main.tex`
- `../../resources/conference_submission_paper/content/1_intro/v_camera.tex`
- `../../resources/conference_submission_paper/content/3_method/v_camera.tex`
- `../../resources/conference_submission_paper/content/4_expnrst/v_camera.tex`
- `../../resources/conference_submission_paper/table/result.tex`

The most relevant original claims are the local-search motivation, the
Thought/Code/Feedback individual, scalar weighted PPA fitness, dual-population
loop, prompt-operator set, UCB-softmax operator selection, VerilogEval/RTLLM
evaluation, and evolutionary-loop ablation.

Journal manuscript edits belong in:

- `../../resources/journal_draft/sections/3_method_journal_extension.tex`
- `../../resources/journal_draft/sections/3_method.tex`
- `../../resources/journal_draft/sections/4_exp.tex`

## Ruminations Coverage Check

The current plan covers the ruminations well enough to start implementation
because every major concern has a corresponding method change and evidence
gate:

- weighted PPA scalarization -> Pareto fronts and hypervolume/paired-delta
  reporting;
- arbitrary operators -> unified thought-level operator and claim narrowing;
- unsupported bandit/RL language -> ablation-or-delete gate;
- small benchmarks -> CVDP and RealBench end-to-end workstreams;
- weak diversity pressure -> MAP-Elites plus descriptor-health gates;
- current QD underperformance -> explicit repair workstream;
- descriptor collapse/rationale -> descriptor-profile exploration and
  comparison, not blind commitment to the original BD trio;
- better tested ideas -> permission to reshape the seven pillars if narrative
  and performance both improve;
- weak storyline -> `journal_narrative.md` plus four adversarial reviewers;
- slow evaluation -> elastic scheduling telemetry and throughput gate;
- long RealBench difficulty -> local-vs-DeepSeek model-capability probe.

The main risk is scope. If implementation time becomes constrained, do not
weaken gates silently. Split the work into smaller milestones, or narrow the
paper claims.

## Comparative Baseline Resources

Use `/workspace/baselines` as retrospective context for reviewer questions about
other recent evolutionary algorithms applied to RTL. The tracked archives of
interest are:

- `../../../baselines/20260316_120539__447c0128__funsearch/`
- `../../../baselines/20260316_120708__447c0128__codeevolve/`
- `../../../baselines/20260316_120813__447c0128__eoh/`
- `../../../baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv`

These archives include provenance files, config snapshots, summaries, and raw
candidate artifacts. They should inform the journal narrative and experiment
planning, but final paper claims require fair revalidation under the revamp's
locked benchmark manifests, seeds, model capability policy, token budgets,
evaluator settings, scheduler policy, and statistical reports.

## Implementation And Git Practices

Follow the repository guidelines while executing the revamp:

- Prefer `scripts/run_backend.py` for new benchmark, QD, and scheduler work.
- Keep framework logic under `src/revolution/`, operational wrappers under
  `scripts/`, tests under `tests/revolution/` or `tests/scripts/`, and planning
  history under `docs/journal_features/`.
- Extend existing report/artifact paths before adding new top-level formats.
- Use typed Python interfaces and focused docstrings for non-trivial public
  logic.
- Use fixtures or mocks for external tools such as `iverilog`, `yosys`, and
  OpenROAD in unit tests.
- For QD/archive/report changes, add or update the nearest tests covering
  artifacts, descriptor selection, or report packaging.
- For runtime changes, record local validation: `pytest` or focused pytest,
  `ruff check` on touched files, and `python -m pyright` on touched source
  modules when source files are touched.
- For LLM-backed changes, run vLLM preflight and at least one bounded smoke
  unless the endpoint or model capability gate blocks it.
- Keep manuscript changes in `resources/journal_draft/`. Treat
  `resources/conference_submission_paper/` as frozen reference.
- Preserve unrelated worktree changes. Stage and commit only scoped files.
- Use Conventional Commit subjects, include clear bodies for non-trivial
  changes, and sign commits with `git commit -s`.
- Before committing, inspect `git diff --check`, `git status --short`, the
  staged diff, and the stored commit message.
- Never commit secrets such as `.env` or `DEEPSEEK_API_KEY`.

## Scope Evolution Practice

When a new idea seems promising, treat it as a candidate contribution rather
than immediately expanding the final method:

- write the idea, expected mechanism, and affected claims in the implementation
  history before large experiments;
- test it against classic and current-QD baselines on a locked debug subset;
- check whether it improves PPA, pass rate, descriptor/diversity evidence, or
  benchmark robustness without hidden extra budget;
- check whether it makes the journal narrative simpler and more persuasive;
- keep it only if it survives both empirical and narrative review;
- update or retire one of the existing seven pillars if the new structure is
  clearer.

## Workstreams

### A. Benchmark Integration

Add a benchmark capability model so each suite declares whether it supports
functional testing, synthesis, post-synthesis checking, reference PPA, and
absolute-only PPA.

Required CVDP inputs:

- `data/bench/cvdp/cvdp_v1.0.2_nonagentic_code_generation_no_commercial.jsonl`
- `exp/cvdp_benchmark`

CVDP headline metric is functional pass rate. PPA, if supported, is absolute
area/power/timing only.

Required RealBench input:

- `exp/RealBench`

Build a clean manifest/evaluator path for RealBench. Use the old draft
worktree only as a reference for parsing or harness behavior.

### B. Faster Evaluation Scheduling

Use and improve the existing elastic evaluation controls:

- `--total_worker_slots`
- `--max_active_problems`
- `--max_workers_per_problem`

Audit the runner and runtime scheduling path:

- `scripts/run_backend.py`
- `src/revolution/runtime/parallelism.py`
- `src/revolution/runtime/candidate_evaluator.py`
- benchmark-specific harness launchers

Add or extend telemetry for wall time, candidate eval/sec, worker occupancy,
per-problem wait time, per-problem active time, timeout count, and retry count.
If current slot leasing leaves workers idle on heterogeneous benchmark tasks,
implement adaptive queueing or work stealing while preserving deterministic
candidate outcomes.

Classic and QD comparisons must use the same scheduler policy.

### C. QD Performance Repair

Primary target configuration:

- `grid_quantile`
- `journal_logic_ff_width_3d`
- Pareto-front archive cells
- unified `single_thought_operator`
- thought-only representation
- `k=4` code samples per thought
- KS-triggered adaptive re-binning

Investigate why the current full feature stack underperforms classic
REvolution on hard subsets. Root-cause candidates include descriptor collapse,
low archive occupancy, parent selection, repair-budget leakage, thought/code
mismatch, and scheduler starvation.

Repair budget must be accounted as real evaluation budget. Final comparisons
must either disable repair or give classic and QD symmetric repair opportunity.

### D. Descriptor Rationale

Evaluate the current descriptor trio as the initial hypothesis:

- `logic_depth`
- `ff_depth`
- `comb_width_log`

The revamp is free to explore alternate MAP-Elites behavior descriptor profiles
if they perform better for PPA search, represent diversity more faithfully, and
support a stronger journal narrative. Candidate descriptors may come from
structural, graph, testability, simulation/activity, physical, or hybrid RTL
features. Learned/high-dimensional descriptors are allowed only if they are
deterministic, affordable, interpretable enough for TCAD review, and clearly
worth the added scope.

Pre-register candidate descriptor profiles before final publication runs and
freeze one final profile after debug/selection evidence. Do not select axes
post hoc from final test plots.

Measure occupied cell fraction, descriptor entropy, collapse rate,
feature/PPA correlation, feature/pass-rate correlation, and per-family
distributions. Compare against at least one simpler descriptor profile. The
selected profile must improve or preserve QD-vs-classic PPA gates, avoid
decorative diversity, remain stable across seeds/families, and come with a
clear manuscript rationale.

### E. Reports And Validation

Add validation and reporting surfaces that make claims hard to fake:

- `scripts/validate_journal_revamp_run.py`
- locked subset and seed manifests
- benchmark-family reports
- paired deltas
- bootstrap statistical tests
- descriptor-health summaries
- scheduler telemetry summaries
- rerun ledger

Reports must not blend CVDP absolute PPA with reference-normalized suites.

### F2. Fast-Iteration Screening Instrument

Maintain a small, gated validation subset for quick classic-vs-variant
PPA comparisons so repair/descriptor iteration does not pay the
hard-subset matrix cost per check. Spec, requirements (R1-R6),
quantitative signoff gates (G1-G5: wall-clock and dominance, valid-PPA
flow, discrimination IQR, screening validity against the hard subset,
cross-seed stability), PROMOTE/DEMOTE/INCONCLUSIVE decision bands, and
the calibration protocol live in
`docs/journal_features/09_fast_iteration_validation_set.md`. Per-pair
gates are checked mechanically by
`scripts/validate_fast_iteration_pair.py`. The subset is a tuning
artifact only: never publication evidence, excluded from the held-out
final set, and revised only by version bump with recorded rationale.

### F. Narrative

Create `docs/journal_features/journal_narrative.md`. It must connect reviewer
criticisms to method choices and evidence:

- scalar PPA fitness to Pareto-aware archive,
- arbitrary operators to unified thought operator,
- small benchmarks to CVDP and RealBench,
- weak diversity to descriptor-backed QD,
- unsupported claims to narrowed, validated claims.

Run four adversarial reviewer personas before accepting the narrative.

## Debug Gate

The first implementation gate uses seed `42` and locked debug subsets:

- hard subset classic/QD complete,
- 10 medium no-commercial CVDP tasks,
- 12 RealBench module tasks,
- same model, token budgets, population/generation budget, scheduler policy,
  evaluator timeout, and toolchain for classic and QD,
- local model is used through vLLM unless a symmetric DeepSeek arm is
  predeclared,
- QD solved count is at least classic per suite or has a root-cause issue,
- archive occupancy, `qd_metrics.json`, descriptor health, and scheduler
  telemetry are present.

## Final Gate

The final publication gate requires 5 fixed seeds and frozen configs.

Reference-PPA suites:

- mean paired best-quality delta `>= +0.03`,
- mean paired average PPA-improvement delta `>= +0.05`,
- global Pareto hypervolume relative improvement `>= +5%`,
- bootstrap 95% CI lower bound `> 0` for best quality and hypervolume,
- QD win rate `>= 60%` on non-tied problem-seed pairs,
- valid-PPA any-pass count `>= classic`.

CVDP:

- functional pass-rate delta `>= +5` percentage points,
- bootstrap 95% CI lower bound `> 0`,
- PPA is absolute-only if reported.

RealBench:

- functional any-pass count `>= classic`,
- at least 90 percent of manifested tasks replay deterministically,
- PPA claims are family-scoped and reference-normalized only when references
  are valid.

Descriptor:

- median occupied-cell fraction `>= 0.25`,
- at most one unexplained collapsed descriptor axis per problem,
- descriptor-profile comparison supports the selected axes,
- final descriptor profile frozen before final runs,
- descriptor narrative explains the RTL design-space meaning of the axes.

Scheduler:

- at least 25 percent wall-clock reduction on a fixed evaluator replay or
  bounded smoke harness versus fixed per-problem worker allocation,
- candidate outcomes unchanged,
- worker occupancy and timeout/retry telemetry reported.

## Model Policy

Default to local vLLM:

```bash
curl http://host.docker.internal:8000/v1/models
```

Use long reasoning budgets:

```bash
--max_tokens 128000 --diff_max_tokens 128000
```

DeepSeek `deepseek-v4-pro` is allowed as a predeclared capability-escalation
arm for long and difficult benchmarks such as RealBench. The key is loaded from
`.env` as `DEEPSEEK_API_KEY` by the existing `deepseek` backend in
`src/revolution/llm.py`. Preflight must verify that the variable exists without
printing it, and `.env` must never be committed or copied into run artifacts.

Recommended DeepSeek command posture:

```bash
--api_backend deepseek --model_name deepseek-v4-pro \
--max_tokens 128000 --diff_max_tokens 128000
```

For explicitly labeled long RealBench probes, `256000` token budgets may be
used if supported by the provider and applied symmetrically.

Before final RealBench claims, build a locked `realbench_long_model_probe` with
at least 8 of the longest/densest RealBench tasks. Run local vLLM and DeepSeek
on the same probe with identical prompts, scheduler, generation budget, repair
policy, and evaluator timeout.

Local vLLM is insufficient for RealBench final claims if it hits any of these
predeclared conditions:

- more than 10 percent context-overflow or length-truncation failures,
- fewer than 25 percent probe tasks with any syntactically valid candidate,
- fewer than 15 percent probe tasks with any functional-pass candidate while
  DeepSeek reaches at least 30 percent.

If local fails and DeepSeek passes, DeepSeek may become the primary RealBench
arm, but classic and QD must both run on DeepSeek for the same locked
task/seed set. If both fail, RealBench claims are limited to integration and
harness readiness.

## Done Means

The goal is done only when implementation, experiments, reports, and manuscript
narrative support the same narrowed claims. A failure against the quantitative
gates requires either a fix or a claim reduction.
