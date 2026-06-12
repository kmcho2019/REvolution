> **ARCHIVED v1 (2026-06-12).** Superseded by the v2 document of the same
> base name after the phase-0 foundations landed; kept verbatim for the
> record. See journal_revamp_implementation_history.md for the refactor entry.

# Paste-Ready Goal Template

Use this text when starting the implementation goal:

```text
/goal Objective: Execute the REvolution TCAD journal revamp described in
docs/journal_features/08_journal_revamp_goal.md and the scaffold directory
docs/journal_features/revamp_history/20260612_005012_KST_journal_revamp.

Work on branch feat/journal-revamp-20260612-005012-kst. Keep journal-related
planning and history under docs/journal_features. Treat
docs/journal_features/resources/conference_submission_paper as frozen submitted
source and edit only docs/journal_features/resources/journal_draft for
manuscript work. Use /workspace/.worktrees/realbench_integration_draft as a
reference only, not as a merge source.

Before changing methodology or experiment claims, read the frozen conference
context: conference_submission_paper/main.tex, content/1_intro/v_camera.tex,
content/3_method/v_camera.tex, content/4_expnrst/v_camera.tex, and
table/result.tex. Use those files to understand the original scalar PPA,
operator-selection, benchmark, and result claims being extended.

Use /workspace/baselines as retrospective context for FunSearch, CodeEvolve,
and EoH-style RTL baseline results, but rerun or revalidate any baseline that
enters final TCAD claims under the same locked problems, seeds, model policy,
token budgets, scheduler policy, evaluator settings, and statistics.

Follow repo practice: prefer scripts/run_backend.py, keep source edits in
src/revolution and scripts with tests under tests, preserve unrelated worktree
changes, stage only scoped files, avoid secrets, run focused validation, and
use signed Conventional Commits.

The existing seven journal-extension pillars are starting scaffolding, not a
hard constraint. If a new idea works well under testing, improves or preserves
the gates, and makes the journal narrative more compelling, modify, replace, or
regroup the pillars. Keep changes only when both performance and storytelling
improve.

Implement the benchmark capability model, CVDP integration, RealBench
integration, scheduler telemetry/throughput improvements, QD performance repair,
descriptor evidence, benchmark-family reports, run validation, and narrative
review workflow needed by the goal spec.

Treat the current behavior descriptor trio as a starting hypothesis, not a hard
constraint. Explore alternate MAP-Elites descriptor profiles if they improve
PPA search, diversity metrics, cross-family stability, and the journal
narrative. Freeze the selected descriptor profile before final publication runs.

Default to local vLLM at http://host.docker.internal:8000/v1/models with
--max_tokens 128000 and --diff_max_tokens 128000. DeepSeek deepseek-v4-pro is
allowed as a predeclared capability-escalation arm for long RealBench-style
tasks. Its key comes from .env as DEEPSEEK_API_KEY; verify presence without
printing it and never commit or log the key. If local vLLM fails the locked
realbench_long_model_probe and DeepSeek passes, DeepSeek may become the primary
RealBench arm, but classic and QD must both run on DeepSeek for the same locked
task/seed set. Do not use DeepSeek as one-sided rescue for failed QD cases.

Completion requires the debug gate, final 5-seed publication gates, descriptor
gates, CVDP absolute-only PPA rule, RealBench deterministic replay gate,
scheduler 25 percent wall-clock improvement gate, and four-persona adversarial
narrative signoff. If a gate fails, fix the implementation or narrow the claim
explicitly.
```
