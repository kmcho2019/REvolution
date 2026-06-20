# RTL Diversity Check Experiment Adversarial Validation Prompt

Use this prompt with an independent sub-agent after the implementer claims
the goal is complete. The validator must inspect repository evidence, not
trust the implementer summary.

```text
You are an adversarial validator for the RTL diversity check experiment.

Read:
- docs/feature_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_plan.md
- docs/feature_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_implementation_todo.md
- docs/feature_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_implementation_history.md
- docs/feature_history/20260621_000217_KST_rtl_diversity_check/goal_template.md
- relevant code, tests, generated reports, artifacts, and git commits named
  by the implementer

Write your report to:
docs/feature_history/20260621_000217_KST_rtl_diversity_check/rtl_diversity_check_subagent_validation_report.md

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
8. New live evolution runs are launched before available historical corpora
   are indexed and analyzed, without a recorded rationale.
9. Live model calls or runs use a model other than `gpt-oss-120b`, a different
   endpoint, or low token settings without explicit rationale.
10. If live runs are used, there is no recorded preflight for
   `curl http://20.0.0.103:8000/v1/models`, served max_model_len, and
   128K-token policy.
11. Qwen3 or DeepGate3 embeddings are promoted as in-loop behavior descriptors
   without post-hoc evidence that distances correlate with Pareto
   contribution, future improvement, or valid descendant yield.
12. AURORA-style custom encoder training is added before pre-trained
    Qwen/DeepGate3 diagnostics are attempted or explicitly shown
    insufficient.
13. Code organization is overcomplicated for a research experiment: broad
    fallback layers, production database machinery, scattered scripts, or
    excessive backward-compatibility paths.
14. The implementation writes into `/aux/revolution-history` or any historical
    checkout intended to be read-only.
15. Tests are missing for corpus indexing and the selected analysis metrics.

Mechanical checks:
1. Inspect branch status and commit history. Confirm the devcontainer GPU and
   read-only mount setup is on `feat/journal-diversity-check-exp-20260620`.
2. Confirm the old Auto-BD branch remains clean except unrelated untracked
   files.
3. Inspect the corpus index. Confirm it includes Auto-BD standard-results
   roots and at least one historical root when available.
4. Inspect the candidate audit table. Confirm it includes method, seed, model,
   problem, generation, validity funnel, PPA fields, code path, netlist path,
   and available descriptor/hash fields.
5. Confirm missing historical artifacts are reported as coverage, not silently
   filled with broad fallback behavior.
6. Confirm quick subset reports are labeled development/preliminary and that
   final conclusions use a large practical corpus, preferably broad RTLLM.
7. If VerilogEval appears in conclusions, confirm whether it is full,
   representative, or partial evidence.
8. Confirm Qwen embedding extraction has a dry-run coverage mode and records
   model name/path, device, batch size, max length, and output path/hash for
   any real run.
9. Confirm DeepGate3 is either implemented as a bounded diagnostic path or
   deferred with exact graph-export/setup blockers.
10. Recompute or inspect the cluster contribution report. Confirm it separates
   clusters that contribute Pareto/HV from clusters that are merely occupied.
11. Recompute or inspect the oracle downsampling report. Confirm it compares
   best-fitness-only, random, structural-diversity, synthesis-response, and
   embedding-based selectors at equal candidate budget.
12. Confirm early-diversity, parent-child jump, and shadow-archive analyses
    are either implemented after the audit table is stable or explicitly
    scoped out with evidence.
13. Inspect plots/tables. Confirm conclusions are labeled as predictive,
    reconstructive, descriptive-only, inconclusive, or negative.
14. Inspect touched Python code for repo style: simple, skimmable, typed where
    useful, asserts for required data, narrow states, and no broad try/except
    defaults where data must exist.
15. Confirm focused pytest, ruff, and typecheck evidence for touched code, or
    an explicit doc-only rationale if no code was added.
16. Inspect docs for clear usage, artifact paths, limitations, and how to
    reproduce the report from ignored experiment outputs.
17. Inspect commits for atomicity, conventional commit messages, and
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
