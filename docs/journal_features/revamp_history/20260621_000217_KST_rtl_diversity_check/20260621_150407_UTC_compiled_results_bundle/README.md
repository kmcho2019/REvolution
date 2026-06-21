# RTL Diversity Compiled Results Bundle

Timestamp: `20260621_150407_UTC`

This directory is the self-contained review bundle for the restarted RTL
diversity check. It collects the validated final report, the earlier derailed
snapshot, stage-level outputs, generated summary figures, sampled raw analysis
data, and the processing scripts used to build the artifacts.

## Start Here

- `CONCLUSION.md`: detailed conclusion answering the two main research
  questions and recommending the next branch.
- `reports/final_report/diversity_necessity_report.md`: complete generated
  final report.
- `figures/generated/`: hand-auditable overview figures made for this bundle.
- `MANIFEST.md` and `MANIFEST.csv`: source paths, sizes, and SHA-256 hashes for
  every bundled artifact.

## Layout

- `reports/final_report/`: final validated report, JSON, and implementation
  gallery.
- `reports/derailed_initial_report/`: archived preliminary report and figures
  that were later judged too shallow.
- `reports/project_docs/`: active goal template, plan, todo, history,
  adversarial prompt, method cards, and validation report.
- `raw_data/final_report/`: final report CSV/JSON tables plus a 1000-row
  sample of the large candidate audit.
- `stage_results/`: WP0/WP1/WP2/WP3 intermediate results, including sampled
  rows from oversized raw tables.
- `figures/final_report/`: figures copied from the final generated report.
- `figures/generated/`: clearer overview figures for review.
- `scripts/processing/`: processing scripts used during the restarted run.
- `scripts/rebuild_bundle.py`: deterministic bundle rebuild script.

## Regeneration

From the repository root:

```bash
uv run python docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/scripts/rebuild_bundle.py
```

The full candidate audit CSV is 211 MB and the Parquet file is 23 MB, so this
bundle includes a 1000-row sample and records the full source paths in the
manifest. The full files remain under
`exp/diversity_check/restarted_report_20260621_075346_UTC/`.

## Final Verdict

Final validated report verdict: `B illumination_only`.

Only L0 descriptive evidence is supported. The run does not support a
reconstructive, predictive, mechanistic, active, or Auto-BD method claim.
