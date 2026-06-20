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

Cluster valid candidates by simple structural features, ST-NOD-like
features when present, and embeddings when available. Report how many
clusters contribute final Pareto points and how much hypervolume each
cluster contributes.

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
