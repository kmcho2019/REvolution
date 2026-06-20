# Goal Template

Use this as a draft for `/goal` after reviewing the local plan. Keep the
activated goal under 4000 characters when possible.

```text
/goal Objective: implement the RTL diversity check experiment specified in
docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_plan.md.
Use the living checklist in
rtl_diversity_check_implementation_todo.md and record all commands,
artifacts, decisions, failures, and commits in
rtl_diversity_check_implementation_history.md.

Outcome: determine whether implementation diversity is predictive or
reconstructive for RTL/Verilog PPA evolution before adding more AutoQD,
automatic BD, or AURORA-style machinery. Build a post-hoc corpus audit from
existing evolutionary runs first. Define useful diversity under functional
equivalence as structurally, synthesis-response, or embedding-distinct
candidates whose regions contribute to PPA Pareto fronts or produce useful
descendants.

Data boundaries: use this branch, the current repo, ignored outputs under
exp/diversity_check/, and the read-only historical mount
/aux/revolution-history. The auxiliary mount maps to the old REvolution
checkout and must not be written. Use available local worktrees or checkouts
such as aspdac2026-paper only if already present; do not make network fetches
part of the default path.

Initial method: post-hoc analysis before live evolution. Index existing
standard_results and recoverable historical runs; build one candidate-level
audit table; then run cluster-contribution and oracle-downsampling analyses.
Add early-diversity, parent-child jump, and shadow-archive analyses only after
the audit table is stable.

Dataset policy: small subsets are allowed for debugging the pipeline, but
final conclusions must use a large dataset run or retrospective corpus. Prefer
broad RTLLM coverage as the practical final target because it is meaningful
without being as large as full VerilogEval. Use VerilogEval only when existing
artifacts make it practical, or label it as partial evidence.

Live-run policy: do not launch new evolutionary runs by default. If new runs
or AURORA-style encoder training become genuinely necessary, preflight
`curl http://20.0.0.103:8000/v1/models` and use the served `gpt-oss-120b`
model symmetrically. Require max_model_len >= 131072. For reasoning-model
REvolution runs use --max_tokens 128000, and use --diff_max_tokens 128000
when diff-mode output is involved. Record endpoint, model id, max-model-len,
token settings, and exact commands before relying on results.

Encoder policy: use pre-trained/pre-existing encoders diagnostically before
training custom encoders. Start with Qwen3-Embedding-0.6B for RTL/source text
and optionally netlist text. Investigate DeepGate3 for synthesized-netlist
graph embeddings. Do not train an AURORA/autoencoder/GNN descriptor in this
goal unless the plan is explicitly revised after post-hoc evidence.

Code constraints: keep code simple, skimmable, typed where useful, and easy to
tweak for research. Prefer one corpus indexer, one candidate table, and one
report entry point before adding abstractions. Use asserts for required data
and fail loudly on unsupported states. Avoid broad defensive fallbacks,
backward-compatibility layers, and production-style database machinery unless
a specific corpus source requires a small targeted adapter.

Verification surface: corpus index and coverage report; candidate audit table;
Qwen dry-run and bounded embedding smoke when GPU/model access is available;
cluster-contribution and oracle-downsampling reports; plots/tables that state
whether diversity is predictive, reconstructive, descriptive-only, or
inconclusive; focused tests; ruff/typecheck evidence for touched code.

Completion requires every TODO item checked or explicitly scoped out with
evidence, plus PASS from rtl_diversity_check_adversarial_prompt.md written to
rtl_diversity_check_subagent_validation_report.md.

Blocked stop condition: if the same blocker repeats for three concrete
attempts, stop and record attempted commands, observed evidence, missing
resource/input, and the smallest next decision needed.
```
