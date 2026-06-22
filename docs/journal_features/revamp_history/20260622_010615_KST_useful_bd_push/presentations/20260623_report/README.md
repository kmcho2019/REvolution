# 20260623 Useful-BD Milestone Report

This directory is the working package for the presentation and report on the
useful-BD push. It has two responsibilities:

1. Answer whether diversity matters for RTL/Verilog PPA evolution.
2. Answer which kind of diversity appears to matter for RTL.

It also pre-registers the broad RTLLM comparison that should decide whether a
T26-family QD/MAP-Elites method can beat the classic REvolution conference
baseline on PPA-centered metrics.

## Files

| Path | Purpose |
| --- | --- |
| `report.md` | Detailed written answer to the two questions, with evidence map and open gaps. |
| `slides.md` | Markdown slide deck outline for colleagues. |
| `experiment_plan.md` | Pre-registered screening and full RTLLM protocol. |
| `adversarial_validation.md` | Review gates, prompts, and recorded feedback plan. |
| `archives/` | Raw original planning notes retained for traceability. |
| `commands/` | Exact command templates for preflight, screening, and full RTLLM runs. |
| `data/` | Problem manifest and source inventory for regenerating tables and figures. |
| `figures/` | Presentation-ready plots after packaging and visual inspection. |
| `tables/` | Claim gates, planned metric schema, and generated result tables. |
| `reviews/` | Sub-agent, Claude, and manual adversarial review logs. |

## Current Status

- Milestone package: scaffolded.
- RTLLM 50-problem manifest: frozen from `bench/RTLLM/*_prompt.txt`.
- Full-run method: exact T26, `sr_raw_conservative_exploit_qd`, selected by
  the screening package.
- Screening ladder: classic, exact T26, T26.1 low-fusion, and T26.1
  mid-fusion completed. Gated T26.1 stayed omitted because it was not
  implemented for the deadline screen.
- Full RTLLM launch: blocked only until pre-launch adversarial review artifacts
  are recorded.
- Replication policy: one seed is the deadline-driven first milestone. Package
  those results into plots, tables, and slides before starting costly
  multi-seed replication.

## Claim Discipline

Do not claim QD usefulness from average fitness alone. The report must use
paired HV, HV-AUC, valid-PPA yield, front/family breadth, archive coverage, and
duplicate accounting. A result is useful only if it preserves classic-covered
problems and reports yield loss, validity collapse, or invalid diversity
instead of hiding it.
