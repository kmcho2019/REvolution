# Sub-Agent Current Package Review

Reviewer status: `PASS WITH LIMITATIONS`.

Supersession note: the longer `claude -p` current-package review found
stricter blockers after this review. Use
`claude_current_package_resolution.md` as the controlling resolution.

## Findings

- P2: claim-level vocabulary was inconsistent. `claim_gates.md` defines
  `diagnostic`, `near_classic`, `useful_qd`, and `strong_win`, while the
  package headline used `reviewable`.
- P2: the family-audit proxy was cautiously framed, but the reader-facing
  README/report did not define the exact synthesized-cell signature grammar.
- P3: the slide deck used the loose phrase "performance" instead of effective
  clock period.
- P3: the deck did not point readers to the main full-RTLLM figures recommended
  by the visual-inspection notes.
- P3: commit hygiene was mostly good; prior inspected commits were signed and
  had no raw `\n` artifacts. The reviewer noted that some older test-command
  bullets in commit bodies exceeded the 72-character wrap rule.

## Limitations To Keep Visible

The package answers both core questions only at the scoped level already
stated: diversity matters enough to continue QD/MAP-Elites for RTL PPA, and
the supported diversity is the T26 implementation-response archive bundle with
quality pressure, not generic novelty or descriptor-only causality.

The visible caveats must remain: one seed only, `4` HV wins versus `15` losses
and `31` ties, aggregate sensitivity to `Prob040_synchronizer`, lower
valid-PPA yield, fewer unique PPA points, fewer total family proxies, and fewer
reference-beating family proxies.
