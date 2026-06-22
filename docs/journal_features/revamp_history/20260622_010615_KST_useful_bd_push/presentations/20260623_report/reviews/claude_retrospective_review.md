# Claude Retrospective Review

Date: 2026-06-22 UTC.
Scope: `report.md`, `slides.md`, `retrospective/README.md`,
`retrospective/visual_inspection_notes.md`, `retrospective/tables/`, and
`retrospective/figures/`.

## Round 1

Command: `claude -p` adversarial review, no file edits requested.
Status: `PASS` with nonblocking suggestions.

Findings:

- The retrospective section answers the two core questions without overclaiming.
- Prior evidence from ASP-DAC, Auto-BD, and RTLLM retrospective artifacts is
  tied into the current T26 claim.
- Tables and figures are mostly clear enough for the presentation package.

Nonblocking suggestions:

- Describe the cluster case study as a 2D projection of an active PPA-space
  front, because timing can affect the true nondominated set.
- Make the cluster figure show front styles more visibly.
- Soften AURORA-style AE prose from a pure negative to near-zero, mixed, or
  negative evidence.
- Scope the Qwen `+3.35%` replay result to common-audit candidates and note
  that fitness-top retention was similarly positive.
- Define retrospective jargon such as oracle replay, common audit,
  DeepGate3/AIG, and AURORA-style linear AE.
- Harmonize the replay-gain precision around `1.35%`.

Resolution:

- Added a retrospective-terms table to `report.md`.
- Regenerated the cluster case-study figure with front points colored by style
  and described it as a 2D projection in both the report and visual notes.
- Scoped the Qwen sentence to common-audit replay and added the fitness-top
  parity caveat.
- Softened the learned-BD/AE prose to match the table.
- Harmonized report and slide text to `1.35%`.

## Round 2

Command: `claude -p` second-pass adversarial review, no file edits requested.
Status: `PASS`.

Blockers:

- None.

Verified fixes:

- The cluster figure and report now honestly describe the view as a 2D
  area-power projection of an active PPA-space front.
- AE prose matches the encoder table.
- Qwen `+3.35%` is scoped to common-audit replay and compared with fitness-top
  parity.
- ASP-DAC and VerilogEval scope is supported by `corpus_coverage.csv` and the
  source run directories.
- Retrospective jargon is defined in the report and glossary.
- Main metric terminology and rounding are consistent across `report.md` and
  `slides.md`.

Final cleanup applied after Round 2:

- Updated `retrospective_gate_summary.csv` generation so D3 uses `1.35%`.
- Added tiny deterministic offsets to the cluster plot so overlapping front
  style markers remain visible.
- Expanded `SR raw` to `synthesis-response raw descriptor` in the report and
  glossary.
- Clarified that the `114` Qwen groups are valid-PPA replay groups.
- Added a plain-language retrospective takeaway to `retrospective/README.md`.
