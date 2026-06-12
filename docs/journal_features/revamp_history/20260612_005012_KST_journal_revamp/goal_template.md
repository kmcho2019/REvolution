# Goal Template v2 — TCAD Revamp Completion Phase

Status: v2 (2026-06-12), written after the phase-0 foundations landed.
v1 is archived verbatim as `goal_template_v1_initial.md`. Original intent:
`docs/journal_features/revamp_ruminations_20260612.md`. Claims contract
(accepted by four adversarial personas, frozen):
`docs/journal_features/journal_narrative.md`.

---

Objective: Complete the REvolution TCAD journal revamp to the accepted
claims contract. Phase-0 foundations are DONE (benchmark capability model;
CVDP + RealBench integration with locked debug subsets and probe; scheduler
telemetry + fair-share leasing with a passed 46% replay gate; cluster-
bootstrap statistics, run validator, seed manifest, rerun ledger; accepted
journal narrative; gated fast-iteration instrument; Verilator 5.030).
What remains is the science and the evidence:

1. QD repair: reproduce, root-cause, and close (or explicitly narrow via
   the narrative's branch table) the classic-vs-QD gap on the tuning sets;
   freeze one final QD config. Fix the QD thought-mode generation-log gap
   (all k evaluated samples recorded) BEFORE any gate-bearing run.
2. BD thesis: establish the behavior-descriptor feature set with basis,
   evidence, and narrative — descriptor-objective correlation quantified,
   candidate profiles compared under the predeclared bake-off rule, one
   profile frozen pre-finals with a plain-language design-space rationale
   written into the narrative. Decorative diversity is failure.
3. Benchmark vetting: end-to-end evolutionary runs (not loaders) on CVDP
   and RealBench debug slices; the Verilator-5 60-task golden re-sweep
   with manifest version bump and subset/probe re-locks; the RealBench
   long-model probe run on both arms and the model arm frozen.
4. Gates: seed-42 debug gate across all suites; MDE analysis; freeze
   everything; 5-seed finals on the held-out/fresh sets; evaluate every
   gate with the shipped statistics machinery; apply the branch decision
   mechanically.
5. Manuscript: rewrite method/results in `resources/journal_draft/` per
   the narrative and the selected branch, with the four case-study
   artifacts and final evidence paths recorded.

Anti-fudge rules (binding): gate thresholds, branch rules, pools, and
budget rules are frozen in the narrative and may not be revised after
final runs begin; locked artifacts change only by version bump with
recorded rationale; every journal-relevant launch goes in the rerun
ledger; tuning (hard subset, fast subset, debug slices) and evidence
(held-out + fresh sets) stay disjoint; missing data follows the
penalized-as-loss statistics; budget symmetry is candidate evaluations
with ±10% auxiliary skew reported.

Completion requires the v2 adversarial sign-off
(`journal_revamp_adversarial_prompt.md`): every item in
`journal_revamp_implementation_todo.md` checked off AND spot-verified
against artifacts, every narrative gate evaluated with its mechanical
checker, and all four personas signing off on the final evidence-plus-
manuscript package. A failed gate is closed by fixing the implementation
or narrowing the claim through the predeclared branch table — never by
adjusting the gate.
