# Journal Revamp Plan v2 — Completion Phase

Status: v2 (2026-06-12). v1 archived as `journal_revamp_plan_v1_initial.md`.
This plan assumes the phase-0 foundations (see the implementation history)
and the ACCEPTED claims contract `docs/journal_features/journal_narrative.md`,
which this plan may not contradict: where the narrative predeclares a rule,
gate, pool, or threshold, the narrative wins. Every phase below names its
open questions and answers them so an implementer cannot interpret around
them.

## P1. QD repair (the thesis-deciding phase)

Prerequisite (blocking): extend QD thought-mode generation logging to
record every evaluated code sample's PPA details (today: representatives +
fail parents only) so both arms' evaluated histories are structurally
identical; add a regression test asserting per-generation logged-candidate
counts match evaluated counts.

Procedure: (1) calibrate the fast-iteration instrument (G1–G3 on the
pop-12 pair; v2 the subset if gates fail — pilot already flags
Prob108_rule90 dominance). (2) Reproduce the gap: classic vs frozen QD
target on the hard subset, seed 42, 20 pop × 5 gens, identical
budgets/scheduler; statistics via `report_journal_statistics.py`.
(3) Diagnose from artifacts in this order: descriptor health/collapse;
archive occupancy vs fill target; parent-selection distribution over
cells; repair/k-budget accounting (charged-evaluations parity within
±10%); thought-code realization failure rates; scheduler starvation
(telemetry). (4) Each candidate fix is one variant screened on the fast
subset (PROMOTE/DEMOTE/INCONCLUSIVE bands) and promoted to a hard-subset
pair only on PROMOTE. (5) Run the predeclared 5-arm ablation matrix
(narrative §ablation; seeds 1001–1003, tuning set). (6) Freeze the final
QD config in a locked YAML with sha256 in the rerun ledger.

Open questions answered: "what counts as closed?" — the narrative branch
table on final-gate statistics, nothing else; tuning-set wins are
screening only. "What if no fix works?" — Branch C with its content floor
(unified-operator one-factor result + transferable root-cause analysis),
predeclared, not optional.

## P2. BD thesis (descriptor evidence and freeze)

Deliverables: (a) descriptor-objective |correlation| per axis on tuning
runs (an axis with |r| ≥ 0.8 to any g_P/g_A/g_T objective is a
re-parameterized objective → replace or drop its diversity claim);
(b) named candidate profiles, pre-registered BEFORE evaluation: the
initial trio; one graph/testability profile; one activity profile; one
deliberately simpler 2-axis control; (c) bake-off under the narrative's
predeclared rule (paired best-quality delta → median occupancy →
mean |correlation|, plus the ≥0.25 occupancy and collapse gates);
(d) one frozen profile + a plain-language design-space rationale section
written into the narrative (axis ↔ RTL design decision), reviewed by the
EDA persona before the freeze. No axis may be selected, renamed, or
re-justified after final runs.

## P3. Benchmark vetting (end-to-end, not loaders)

(a) CVDP: one classic + one QD end-to-end evolutionary run on the locked
10-task debug slice (seed 42) with ≥1 task producing a passing candidate;
`validate_journal_revamp_run.py` green. (b) RealBench: same on the locked
12-task slice. (c) Verilator-5 path: `verilator_testbench` harness behind
the capability model; full 60-task golden re-sweep
(`build_realbench_manifest.py --validate` under v5.030); manifest version
bump; debug subset + long-model probe re-locked from the new validated
pool; retention table updated in the narrative (pre-freeze, with a
focused EDA-persona re-review of that section). (d) Long-model probe run
on local vLLM AND DeepSeek under identical settings; model arm frozen by
the predeclared sufficiency conditions; ledger entries for all runs.
(e) RealBench/CVDP synthesis-PPA paths stay disabled unless a recorded
determinism check passes (duplicate-synthesis replay on sampled tasks).

## P4. Gate experiments

(a) MDE analysis from retrospective + tuning-run variance, archived;
counts may rise, never fall; an infeasible gate drops its claim.
(b) Build final slices: held-out 20 reference-PPA problems (excluding
hard + fast subsets), 30 fresh CVDP (seed-1337 rule, debug ids excluded),
26 fresh RealBench (validated minus debug). (c) Seed-42 debug gate across
all suites per the goal spec checklist. (d) Freeze configs/prompts/tools
(provenance statement with exact versions). (e) 5-seed finals (1001–1005)
both arms (+ DeepSeek arm if frozen in); statistics + gates; mechanical
branch decision. (f) Equivalence spot-checks (yosys) on showcased
candidates + sampled 10% of elites.

## P5. Manuscript

Method/results rewrite in `resources/journal_draft/` per narrative and
selected branch; measurement-model and RealBench-disclosure sections;
four case-study artifacts (archive heatmap with equivalence-checked
solutions, thought lineage, evaluated-history scalar comparison, failure
panel); baseline treatment decision (revalidate under locks or label
retrospective); final evidence paths recorded in the history.

## Standing rules

Method-evolution rule unchanged (ideas may reshape pillars only with
fast-subset → hard-subset evidence AND narrative improvement, recorded in
history before large experiments). Secrets hygiene unchanged. Commit
discipline unchanged. Every phase ends with its TODO items checked and
its evidence paths recorded in the implementation history.
