# Suite Campaign Audit - 2026-07-08

Read-only sub-agent audit requested during the suite-first full-RTLLM
variant campaign. No files were edited by the auditor.

## Verdict

WARN.

The campaign remains aligned with the TCAD natural-extension goal, but
the auditor found process warnings to fix before launching many more
full-suite runs.

## Findings

- Naturalness: PASS. S01/S02/S03 and near-term S20/S21 are simple
  MAP-Elites/QD extensions, not PCN-style trigger or credit heuristics.
- Operator/headline constraints: PASS with warning. The high-level
  contract is explicit, but the campaign command template should also
  spell out actual V2 parity pins such as `qd_parent_selection`,
  `qd_num_cells`, and warmup.
- Navigation: WARN. Doc 13 was stale for the 2026-07-08 suite-first
  continuation and needed a top-level pointer.
- Next variants: PASS. Close S03 seed 1005, then prefer S20/S21 before
  more capacity or warmup scans.
- Anti-bloat: WARN. Keep future suite packages compact and link to raw
  `exp/` roots instead of copying broad figure trees into docs.

## Actions Taken

- Updated `suite_variant_campaign/commands.md` with the full V2 parity
  command pins and fuller validation expectations.
- Updated doc 13 with a 2026-07-08 suite-first pointer.
- Trimmed the seed 1005 package to summary/data/table artifacts and
  omitted generated per-problem figure trees from the curated docs copy.
