# Goal Template

Use this text for `/goal`. It omits the literal `/goal` prefix. The plan is
the contract; sibling docs and the inherited June-22 policies are binding.

```text
Objective: on branch feat/journal-qd-bd-exp-20260703, make a persistent,
operator-fair push to find a natural QD/MAP-Elites extension of classic
REvolution that beats classic on PPA hypervolume and HV-AUC while keeping
functionality. Use docs/journal_features/revamp_history/
20260703_121857_KST_natural_qd_push/ as the push root. The plan is the
contract, TODO the checklist, history the audit log; the inherited
June-22 policies are binding;
docs/journal_features/journal_narrative.md wins on any conflict.

Outcome: at least one lane that beats matched classic on 3-seed screening
mean HV and HV-AUC with coverage retained, confirmed on full RTLLM 46
ref-complete at 5 seeds toward the frozen +5% HV log-ratio gate — or, only
after the persistence policy is exhausted, an operator-fair negative map.

Current interpretation: the June-22 negative map is contaminated (QD arms
ran single_thought_operator vs classic eoh_strategies; corrected reruns
recovered 30-46 retention points), PCN-v3 failed 5-seed replication and was
C-F-confounded, and Smooth-QD V2 (see plan) is at statistical parity
with classic. The job is parity -> win: single-factor upgrades on the V2
platform, one mechanism at a time, operator-fair.

Current priority: P0 first — pin the 8-design manifest, classic baselines,
and exact V2 config; port the operator-contract auditor into scripts/ with
tests; canonicalize HV-AUC against the stored 20260630 tables; run the V2
anchor on the screen. Then P1 lanes N01 (per-cell Pareto slots), N02
(Pareto-biased sampling), N03 (archive parent lane), N05 (fixed warmup),
each pre-registered.

Metrics: mean global PPA hypervolume and canonical HV-AUC on
reference-complete paired subsets, per-design coverage, valid-PPA yield,
Pareto points/front families. Never average fitness as primary evidence.
Screening gates: kill below 0.95x classic on 3-seed mean HV or on coverage
loss; promote at >= classic 3-seed on HV and HV-AUC with coverage retained.

Required scope: attempt at least 8 lane packages across at least 4
mechanism families before any broad negative sign-off. Every lane needs
pre-registration, commands, operator-contract audit, figures (direct raw
PPA Pareto PNG first), tables, tier decision, and a follow-up idea or
retirement rationale.

Constraints: qd_operator_kind=eoh_strategies and code_individual
representation everywhere; eoh_success_operator_set matched across
compared arms (compare against classic_no_cf whenever operator sets are
touched); single_thought_count must audit to 0 for both arms of every
headline comparison; no stagnation/credit/activation triggers and at most
two new knobs per lane (Natural-Extension Criterion); descriptors never
use PPA, fitness, HV, Pareto rank, pass rate, or problem identity; freeze
subsets before outcomes; 128000 token budgets and recorded vLLM preflights
for live runs; no verdict on a single seed within +-5% of classic; never
cite contaminated June-22 numbers as evidence; no edits to engine.py core
loops — config-first, new code in small tested modules per GUIDELINES.md.

Iteration policy: after each result, classify the outcome (yield-loss,
front-loss, exploration-tax, descriptor-collapse, mechanism-inert), record
the diagnosis and next action, and prefer the cheapest experiment that
removes the most uncertainty. Escalate: single-factor lanes -> budget
shape -> pre-registered combination of winners -> conditional descriptor
bake-off -> corrected-suite completion. Keep the TODO under its cap,
append evidence to history, commit atomically with signed, verified
messages, and run the periodic claude -p review every ~10 commits.

Blocked stop condition: stop only after three concrete attempts hit the
same blocker, with commands, artifacts, the missing input, and the exact
next decision recorded. Do not stop because one lane is weak. Completion
requires the plan's completion gates and PASS from
natural_qd_push_adversarial_prompt.md written to
natural_qd_push_subagent_validation_report.md.
```
