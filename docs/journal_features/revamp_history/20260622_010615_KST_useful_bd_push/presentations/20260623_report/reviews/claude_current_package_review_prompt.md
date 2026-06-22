# Claude Current Package Review Prompt

Review the current milestone presentation package in `/workspace` on branch
`feat/journal-useful-bd-exp-20260622`. Do not edit files.

Read:

- `GUIDELINES.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/report.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/slides.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/README.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/family_audit/README.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/tables/claim_gates.md`
- `docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/retrospective/README.md`

Adversarially review whether the current presentation/report package answers
the two core questions without overclaiming:

1. Does diversity matter for RTL/Verilog PPA evolution?
2. Which diversity matters for RTL?

Also check whether:

- the family-audit proxy is defined precisely;
- the RTLLM one-seed limitation is visible;
- retrospective evidence is tied into the current narrative;
- figures and tables are referenced coherently;
- the package conflicts with `GUIDELINES.md` simplicity, reporting, or commit
  practices.

Return prioritized findings with file and line references where possible. If
no blocker remains, say `PASS WITH LIMITATIONS` and list the limitations that
must stay visible.
