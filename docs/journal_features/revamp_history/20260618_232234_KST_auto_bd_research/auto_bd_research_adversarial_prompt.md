# Automatic BD Research Adversarial Prompt

Use this prompt with an independent sub-agent after the implementer claims
the goal is complete. The validator must inspect repository evidence, not
trust the implementer summary.

```text
You are an adversarial validator for the automatic behavior descriptor
research goal.

Read:
- docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_research_plan.md
- docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_research_implementation_todo.md
- docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_research_implementation_history.md
- docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/START_HERE.md
- docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_plan_sketch.md
- docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_ruminations.md
- every method_card.md, generated report, accept_reject.md, locked config,
  run root, test, and script named by the implementer
- docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_run_policy_lock.yaml

Write your report to:
docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_research_subagent_validation_report.md

Return exactly one verdict: PASS or FAIL.

Automatic FAIL preconditions:
1. Any unchecked TODO item lacks an explicit out-of-scope rationale with
   evidence.
2. The selected method misses any problem where original REvolution produced
   at least one valid PPA candidate under the fixed policy.
3. PPA, reference PPA, fitness, or hypervolume was used as a descriptor
   input.
4. Held-out validation was used for tuning or method selection.
5. A method was accepted without method_card.md, generated report, and
   accept_reject.md.
6. Average PPA was reported without valid-PPA coverage and robustness.
7. Duplicate synthesized netlists were counted as distinct diversity.
8. gpt-oss-120b/model settings were changed asymmetrically or without
   recorded preflight/rationale.
9. Method documentation/report directories were scattered directly under
   `docs/journal_features/` instead of
   `20260618_232234_KST_auto_bd_research/auto_bd_methods/`, except for
   explicitly linked large `exp/` artifacts.
10. The backend became materially harder to understand because experimental
    modes were added through broad optional arguments, scattered conditionals,
    or unreviewable abstraction layers.
11. Cross-method QD claims use only each method's internal descriptor space
    without a fixed common audit descriptor space.
12. PCA, UMAP, autoencoder, GNN, VQ, clustering, or normalization artifacts
    were fitted on held-out data, final evaluation candidates, or post-hoc
    full-run artifacts while being claimed as in-loop search descriptors.
13. ST-NOD or stage-dump instrumentation changed the final synthesis/PPA path
    without being declared as a method change.
14. The selected method lacks stronger functional validation for best
    candidates and representative elites, or a clear infeasibility
    justification.
15. PPA hypervolume uses method-specific reference points, clipping rules, or
    invalid-candidate handling.
16. Unique-netlist uplift is based only on exact hash count and not supported
    by motif-signature or PPA-relevant diversity.

Mechanical checks:
1. Recompute or inspect the original REvolution valid-PPA coverage set C.
   Confirm the selected Auto-BD method covers every problem in C.
2. Inspect locked subset/config/seed/model records. Confirm all compared
   methods used the same subset, seeds, model, prompts, timeouts, budget,
   and Smooth-QD substrate unless a difference was predeclared.
3. Confirm the local model preflight evidence for
   `curl http://20.0.0.103:8000/v1/models`, `gpt-oss-120b`, and the
   128k+ context/token policy.
4. Confirm `auto_bd_run_policy_lock.yaml` exists and that compared runs
   match its seed, model, token, worker, budget, and baseline-arm policy
   unless a versioned lock update was recorded before the run.
5. Verify robustness gates: functionality, synthesis, OpenROAD, and
   valid-PPA coverage versus landing Smooth-QD manual-BD.
6. Verify PPA gates: best fitness, PPA hypervolume, per-problem
   win/loss/tie, and anytime curves.
7. Verify QD gates: QD score, archive coverage, entropy, occupied cells,
   unique elites, and unique canonical synthesized netlists.
8. Verify descriptor-quality gates: manual-BD/PPA correlations,
   renaming/formatting stability, nearest-neighbor structural similarity,
   motif enrichment, and interpretable archive/codebook regions.
9. Confirm per-method reports regenerate from artifacts and are not
   manually edited result tables.
10. Confirm rejected methods are still documented and visible in the
   centralized report.
11. Confirm `auto_bd_methods/` lives under the auto-BD scaffold directory
    and that method cards, configs, reports, and accept/reject records are
    organized there.
12. Recompute or inspect the common audit archive for all methods and verify
    centralized QD comparisons use the common audit space.
13. Inspect descriptor fitting artifacts: scaler/PCA/encoder/codebook hashes,
    training candidate list, excluded held-out problems, and descriptor version
    logged per candidate.
14. Re-run or inspect stronger functional validation for final best
    candidates, hypervolume contributors, and representative elites.
15. Confirm ST-NOD instrumentation produces the same final synthesized netlist
    and PPA path as the baseline unless explicitly declared otherwise.
16. Confirm PPA/HV normalization, reference points, clipping, and
    invalid-candidate handling are fixed across methods.
17. Confirm unique-netlist claims are supported by motif-signature or
    PPA-relevant diversity, not exact hashes alone.
18. Inspect tests for descriptor extraction, hashing, stability, report
    generation, and archive integration. Weak or missing tests are a FAIL
    unless the implementation is documentation-only and the plan says so.
19. Inspect touched code for local style: simple, skimmable, narrow state,
    typed public interfaces, asserts at data-load boundaries, no broad
    try/except defaults where types should decide.
20. Confirm `uv tool run ty check <touched source modules>` was run as the
    primary Auto-BD type check, or that missing `ty` evidence is explicitly
    justified. Pyright alone is not enough for Auto-BD sign-off.
21. Confirm descriptor/method family handling is exhaustive and fails on
    unknown kinds.
22. Confirm new public modules/classes/functions and non-obvious helpers
    have useful docstrings, and comments are sparse but helpful.
23. Confirm new modes are documented in method cards, reports, or user-facing
    docs with commands, configs, artifacts, and limitations.
24. If commits exist, inspect commit messages and sign-offs according to
    the repository guidance.

Paper-facing checks:
1. Does the selected method have a real hardware-specific idea, or is it
   just AutoQD/AURORA/VQ-Elites renamed?
2. Would a skeptical EDA reviewer understand what the descriptor separates
   in RTL/netlist/synthesis terms?
3. Are limitations and negative results recorded, including methods that
   failed?
4. Are claims based on held-out validation when they are presented as
   final, rather than on tuning/development subsets?
5. Is the final method the simplest passing method, or is added complexity
   justified by evidence?

PASS only if the original intent is satisfied in evidence and the reports
are reproducible enough for the stated journal claim. Otherwise FAIL with
exact findings: file path, command/artifact inspected, observed problem,
and the smallest evidence or change required to pass.
```
