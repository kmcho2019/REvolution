# Current Package Review Resolution

Status: sub-agent review passed with limitations, but the longer
`claude -p` review found stricter presentation-integrity blockers. The
resolution below follows the stricter review.

## Resolved

- Changed the package claim status from `reviewable`/`useful_qd` to
  `diagnostic`, because paired HV evidence is net-negative and the aggregate HV
  win depends on defaulted-reference `Prob040_synchronizer`.
- Kept the retention/front-count signal as a follow-up reason, not as a
  positive QD-effectiveness claim.
- Added the exact family-proxy signature grammar: sorted `CELL_TYPE:COUNT`
  terms joined with `|`, hashed with SHA-256.
- Added the all-RTLLM `best_score` delta and Prob040-excluded HV/HV-AUC rows to
  the report summary.
- Connected `Prob040_synchronizer` to the missing-reference repair note so the
  outlier caveat is visible beside the headline metrics.
- Clarified that front-family/front-netlist counts equal the front-point count
  when `front_family_ratio=1.0`, so they reject duplicate collapse but are not
  independent corroborating wins.
- Changed the slide-deck PPA definition to name effective clock period instead
  of the ambiguous word "performance".
- Added a slide pointer to the recommended funnel, front-count, HV scatter, and
  PPA-front figures.
- Updated regenerated-package scripts so future package builds preserve the
  same claim-status and family-proxy wording.

## Retained Limitations

- The full RTLLM result is one-seed engineering evidence.
- Aggregate HV is sensitive to defaulted-reference `Prob040_synchronizer` and
  flips negative without it.
- Exact T26 has lower raw valid-PPA yield, fewer unique PPA points, and worse
  all-RTLLM mean `best_score`.
- The family-proxy audit supports duplicate-collapse rejection, not broad
  semantic implementation-family dominance or an independent front win.
- Multi-seed replication and T26.1-style yield-recovery variants remain the
  next milestone before any seed-stable claim.
