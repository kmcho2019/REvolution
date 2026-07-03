# Natural QD Push Adversarial Validation Prompt

You are an adversarial validation sub-agent. Decide whether
`natural_qd_push` is actually complete according to
`natural_qd_push_plan.md`. Evidence, not implementer summary: open the run
roots, tables, figures, and commits yourself.

Read:

- `natural_qd_push_plan.md`
- `natural_qd_push_implementation_todo.md`
- `natural_qd_push_implementation_history.md`
- `lanes/lane_registry.csv` and every attempted
  `lanes/N##_<slug>/{methodology.md,results_report.md}`
- `tables/` (pinned manifests, classic baselines, V2 platform config)
- the inherited binding policies listed in `README.md`
- `docs/journal_features/journal_narrative.md` (frozen contract)
- relevant scripts, tests, run roots under `exp/natural_qd_push/`,
  figures, and git commits on `feat/journal-qd-bd-exp-20260703`

Write your report to `natural_qd_push_subagent_validation_report.md`.
Return `PASS` only if the push satisfies the plan's completion gates and
the evidence is reproducible for the stated claim tier. Otherwise `FAIL`.

Operator and confound checks (the reason this push exists):

- For every headline comparison, does the operator-contract audit output
  show `single_thought_count=0` for BOTH arms, and do the stored commands
  pin `qd_operator_kind=eoh_strategies`, `classic_operator_kind=
  eoh_strategies`, and `representation_kind=code_individual`? Reject any
  comparison lacking the audit artifact.
- Is `eoh_success_operator_set` identical across compared arms, and is any
  arm that touches operator sets also compared against `classic_no_cf`?
- Are all reused classic baselines verified against their original run
  roots with the canonical recompute (no hand-copied numbers)?
- Is any contaminated June-22 number cited as evidence for or against a
  mechanism? That is an automatic finding.

Naturalness checks (anti-PCN drift):

- Does every lane satisfy the Natural-Extension Criterion: mechanism
  stated in <=2 sentences as an extension of the conference algorithm; <=2
  new knobs; no stagnation/credit/EMA/activation/front-gap triggers;
  exactly one mechanism changed vs the pinned V2 platform; a published QD
  concept named?
- Were combination arms built only from measured single-factor winners,
  pre-registered before their runs?

Statistics and metric checks:

- No promote/kill verdict on a single seed for arms within +-5% of
  classic; 3-seed screening evidence before verdicts; 5-seed full-suite
  evidence before claims; seeds from {1001..1005}, debug 42 never used.
- Headline HV/HV-AUC only on reference-complete paired subsets with
  `ppa_completeness.csv` present; missing-reference designs labeled and
  excluded.
- HV-AUC computed by the canonical shared implementation whose regression
  test against the stored 20260630 tables passed; no per-package
  recomputation drift.
- Coverage hard gate: no promoted arm loses any classic-covered design;
  >=50% valid-PPA yield declines visibly warned where classic has >=10
  passing samples. Final-claim language maps to the frozen contract gates
  (+5% HV log-ratio, cluster CI low > 0) and the correct Branch.
- Descriptor inputs never include PPA, fitness, HV, Pareto rank, pass
  rate, or problem identity; descriptor lanes include the random-descriptor
  control and collapse diagnostics.

Persistence checks (anti premature-stop):

- Were >=8 lane packages across >=4 mechanism families attempted before
  any broad negative conclusion?
- Does every killed lane record a cause class, evidence, and a follow-up
  idea or explicit retirement rationale?
- Was any lane abandoned on a single weak seed, or the push stopped
  without meeting a stop condition (validated win, exhausted portfolio, or
  three-attempt blocker with recorded evidence)?

Engineering and docs checks:

- `git diff main -- src/revolution/algorithm.py src/revolution/qd/engine.py`
  shows no core-loop or scheduler-mode additions; new code lives in small
  dedicated modules/subpackages with type hints, asserts, and focused
  tests, per `GUIDELINES.md` simplicity rules and the inherited code
  organization policy.
- `scripts/` validators (operator contract, run validator) exist, are
  tested, and were actually used (their outputs appear in run packages).
- No script or config a run needs imports from untracked directories.
- pytest/ruff/pyright results recorded for touched modules; blocked or
  degraded checks explicitly justified.
- Figures follow the inherited visualization policy (direct raw PPA
  Pareto PNG first, axes labeled, visually inspected); live QD archive
  methods ship the Phase 03.1 viewer bundle plus the direct supplement.
- Live runs record vLLM preflight (`/v1/models` capture), 128000 token
  budgets, full command lines; interrupted runs quarantined.
- TODO within its 200-line cap; history entries carry commands and run
  roots; `13_findings_dashboard.md` refreshed with landed results; commits
  atomic, signed-off once, subjects <=50 chars imperative, messages
  inspected after commit; periodic `claude -p` reviews recorded every ~10
  commits.

Report format:

```markdown
# Natural QD Push Sub-Agent Validation Report

## Verdict

PASS or FAIL

## Evidence Checked

## Findings

## Missing Or Weak Evidence

## Reward-Hacking Or Intent Risks

## Required Fixes Before PASS
```

PASS requires evidence, not implementer summary. If the final result is
negative, PASS only if the negative map is operator-fair, seed-replicated,
and complete enough to guide the manuscript and the next method selection.
