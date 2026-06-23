# Sub-Agent Presentation Claim Review

Date: 2026-06-23 UTC

Reviewer: sub-agent `019ef200-5d1d-74f0-aa4c-9d962dabb991`

Scope:

- `report.md`
- `slides.md`
- `README.md`
- `glossary.md`
- `retrospective/README.md`
- `full_rtllm/README.md`

## Findings

1. `screen_excluded` still included defaulted-reference
   `Prob040_synchronizer`, so the positive screen-excluded HV/HV-AUC rows could
   be read as independent support.
2. Full RTLLM visual evidence was indexed, but not on the main report reading
   path.
3. `retrospective/README.md` used the stale phrase `positive result`, which
   conflicted with the diagnostic claim posture.
4. The slide PPA definition sounded like timing was always active.

## Resolution

- Added `Screen+Prob040-excluded` rows to `report.md`.
- Added `screen_and_prob040_excluded` rows to `full_rtllm/README.md`.
- Added the key full-run figures to the main report reading path.
- Replaced the stale retrospective phrase with `diagnostic T26 front signal`.
- Clarified that timing is active only when reference timing exists.

The reviewer judged the retrospective subsection itself satisfactory: it says
the retrospective was not a live QD run, reports failed utility gates, and ties
the evidence to a narrow implementation-response archive claim.
