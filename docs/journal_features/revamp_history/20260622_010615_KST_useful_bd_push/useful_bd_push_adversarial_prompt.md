# Useful BD Push Adversarial Validation Prompt

You are an adversarial validation sub-agent. Decide whether
`useful_bd_push` is actually complete according to
`useful_bd_push_plan.md`.

Read:

- `useful_bd_push_plan.md`
- `useful_bd_push_implementation_todo.md`
- `useful_bd_push_implementation_history.md`
- every attempted `techniques/<technique_slug>/methodology.md`
- every attempted `techniques/<technique_slug>/results_report.md`
- relevant scripts, tests, reports, figures, tables, run roots, and commits

Write your report to `useful_bd_push_subagent_validation_report.md`.

Return `PASS` only if the implementation satisfies the original intent and
the evidence is reproducible enough for the stated tier. Otherwise return
`FAIL`.

Check:

- Does at least one simple control, one synthesis/netlist descriptor, one
  learned/projection descriptor, and one archive-coupling method have real
  results?
- Are at least 10 current technique packages complete before any broad
  negative conclusion is accepted, with methodology, artifacts manifest,
  figures, tables, result report, and tier decision?
- Does every `T1` or higher method preserve every design where classic has at
  least one valid functional PPA candidate under the same budget?
- Does every promoted method avoid a 50 percent or larger relative decline in
  functionality rate or synthesis-valid rate versus classic?
- Is any `T1`, `T2`, or `T3` claim supported by per-problem and per-seed
  evidence against classic and landing Smooth-QD?
- Did the implementer lower the early threshold responsibly without reward
  hacking, cherry-picking, or hiding invalid-candidate loss?
- Are PPA, fitness, hypervolume, reference PPA, and test pass rate excluded
  from in-loop BD inputs?
- Are duplicate netlists, missing classic-covered problems, and invalid
  candidates accounted for explicitly?
- Are generated figures and tables understandable, aesthetically clean,
  manually inspected, and tied to claims?
- Do per-technique reports and the central report explain the method,
  terminology, result, conclusion, limitations, and next step precisely?
- For live LLM-backed runs, did the implementer follow
  `vllm_runtime_guide.md`: endpoint preflight, served model metadata,
  `128000` token budgets for research evidence, and blocked-run logging?
- For dependency-heavy methods, did the implementer avoid stopping at repo
  `.venv` or uv-lock conflicts by trying isolated uv envs, source checkouts,
  and a submodule decision when appropriate?
- Are code changes simple, typed, modular, and aligned with `GUIDELINES.md`,
  `AGENTS.md`, and `code_organization_policy.md`?
- Are docstrings, comments, and docs updated for new code paths?
- Are tests, ruff, pyright, and `git diff --check` recorded, or are blocked
  results explicitly justified?
- Are commits atomic, signed, and message-verified?

PASS requires evidence, not implementer summary. If the final result is
negative, PASS only if the negative map is complete enough to be useful for
the manuscript and future method selection.
