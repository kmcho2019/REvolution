# 20260623 Useful-BD Milestone Report

This directory is the working package for the presentation and report on the
useful-BD push. It has two responsibilities:

1. Answer whether diversity matters for RTL/Verilog PPA evolution.
2. Answer which kind of diversity appears to matter for RTL.

It also packages the broad one-seed RTLLM comparison between classic
REvolution and exact T26 QD/MAP-Elites on PPA-centered metrics.

## Files

| Path | Purpose |
| --- | --- |
| `report.md` | Detailed written answer to the two questions, with evidence map and open gaps. |
| `slides.md` | Markdown slide deck outline for colleagues. |
| `glossary.md` | Audience-facing definitions for QD, BD, PPA, Pareto, and gate terminology. |
| `experiment_plan.md` | Pre-registered screening and full RTLLM protocol. |
| `adversarial_validation.md` | Review gates, prompts, and recorded feedback plan. |
| `archives/` | Raw original planning notes retained for traceability. |
| `commands/` | Exact command templates for preflight, screening, and full RTLLM runs. |
| `data/` | Problem manifest and source inventory for regenerating tables and figures. |
| `figures/` | Presentation-ready plots after packaging and visual inspection. |
| `tables/` | Claim gates, planned metric schema, and generated result tables. |
| `retrospective/` | Prior-branch diversity/PPA retrospective digest, tables, figures, and regeneration script. |
| `reviews/` | Sub-agent, Claude, and manual adversarial review logs. |
| `full_rtllm/` | Generated full RTLLM tables, figures, raw PPA data, and package summary. |

## Current Status

- Milestone package: full one-seed RTLLM result packaged.
- RTLLM 50-problem manifest: frozen from `bench/RTLLM/*_prompt.txt`.
- Full-run method: exact T26, `sr_raw_conservative_exploit_qd`, selected by
  the screening package.
- Screening ladder: classic, exact T26, T26.1 low-fusion, and T26.1
  mid-fusion completed. Gated T26.1 stayed omitted because it was not
  implemented for the deadline screen.
- Full RTLLM launch: completed and packaged under `full_rtllm/`.
- Claim status: `reviewable`.
- Aggregate all-RTLLM result: exact T26 improves mean HV by `0.010562` and
  mean HV-AUC by `0.012397`, with `0` hard retention failures.
- Main caveat: exact T26 has lower valid-PPA yield (`879` versus `1056`) and
  the aggregate HV gain is outlier-sensitive. The package supports a
  PPA-centered T26-bundle claim, not a descriptor-only or full-family-breadth
  claim.
- Replication policy: one seed is the deadline-driven first milestone. Package
  those results into plots, tables, and slides before starting costly
  multi-seed replication.

## Claim Discipline

Do not claim QD usefulness from average fitness alone. The report must use
paired HV, HV-AUC, valid-PPA yield, PPA-front counts, and duplicate accounting.
Family-breadth or archive-viewer claims require their own follow-up artifacts.
For this PPA-first milestone, the hard gate is classic-covered retention: if
classic has at least one valid PPA sample for a problem, QD must also have one.
Yield loss remains a visible warning, not an automatic blocker.
