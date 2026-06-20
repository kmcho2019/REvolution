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
17. The report claims diversity is useful because D2 and D6 pass, without a
    predictive, reconstructive, random-control, or prospective utility gate.
18. Early-diversity prediction uses PCA, clustering, projection, or scaling
    fitted on the full final corpus without labeling the claim as post-hoc.
19. Oracle downsampling uses final PPA or final-front membership while claiming
    online search utility.
20. Multi-cluster Pareto evidence lacks random-label or shuffled-label
    controls.
21. Descriptor distances over mixed-scale features lack standardization or a
    documented distance metric.
22. Qwen claims omit truncation, identifier-normalization stability, or a
    lexical baseline comparison.
23. DeepGate3 claims omit whether sequential elements were represented,
    cone-split, or dropped.
24. A D gate is marked PASS without minimum corpus/problem/seed/candidate
    coverage or a low-data/preliminary label.
25. The final conclusion does not select one predefined verdict level:
    diversity not supported, illumination only, reconstructive, predictive,
    actively useful, or Auto-BD candidate justified.
26. Visual conclusions are based on cherry-picked examples, lack declared
    case-study selection rules, or are not tied to numeric gates/effect sizes.
27. The Phase 0 `B illumination_only` PASS is treated as final research
    sign-off instead of preliminary evidence to be escalated.
28. `original_notes/` details are not incorporated into the restarted plan,
    especially WP0 diversity necessity, WP1 encoder diagnostics, WP2
    quality-gated diversity pressure, and WP3 learned/AURORA/VQ gating.
29. Qwen3 real embedding extraction is marked blocked solely because
    `torch`, `transformers`, model weights, or GPU setup is missing, without
    trying `uv add`, an optional dependency path, or an isolated ignored
    environment.
30. DeepGate3 is marked blocked solely because the package is absent, without
    attempting graph export plus package/source/environment setup.
31. ST-NOD or synthesis-response descriptors are not reconstructed from
    available stage dumps, sidecars, or prior fitting artifacts, and the report
    does not prove those artifacts are absent.
32. Lineage, parent-child jump, or descendant-yield analysis is skipped after
    one corpus lacks lineage, without searching other historical corpora.
33. The restarted work closes as illumination-only without at least one
    duplicate-suppression, online-available replay, quality-gated novelty
    replay, or bounded live novelty-lane experiment.
34. AURORA, VQ/codebook, larger Qwen, DeepSeq, NetTAG, or CircuitFusion are
    promoted beyond diagnostics before WP0-WP2 show useful, robust diversity.

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
19. Inspect descriptor projection artifacts and verify fitting data does not
    include future/held-out data for predictive claims.
20. Recompute or inspect D2 with random or shuffled cluster labels.
21. Confirm oracle downsampling reports both oracle-reconstructive and
    online-available variants where data permits.
22. Confirm diversity metrics are stratified by all candidates, functional,
    synthesis-valid, valid-PPA, and Pareto-front candidates.
23. Inspect the final verdict section and verify the claim level matches the
    strongest evidence.
24. Inspect visual case studies. Confirm they include positive/null/negative
    outcomes where available, captions with sample sizes, and matching tables.
25. Confirm the history records what went wrong in Phase 0 and cites the
    original-notes details reinstated in the restarted plan.
26. Inspect Qwen setup logs. Confirm dependency escalation was attempted
    before blocker status or that real embeddings were produced.
27. Inspect DeepGate3 setup logs. Confirm AIG/Yosys graph export and package
    setup were attempted before blocker status or that embeddings were
    produced.
28. Inspect ST-NOD/synthesis-response artifacts and verify reconstruction or
    exact missing-stage blockers.
29. Inspect lineage corpus search results and verify parent-child or
    descendant-yield analysis ran wherever possible.
30. Inspect duplicate-suppression, online-available replay, or novelty-lane
    sweep artifacts and verify robustness gates are reported.

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
