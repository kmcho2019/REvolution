# Supplemental Formal Final Analysis

This directory is a supplemental `report_final_analysis_bundle.py` output for
the full RTLLM milestone. It is not the authoritative all-50 milestone package;
that remains `../README.md` plus the generated tables, figures, direct PPA
viewer, Phase 03.1 viewer, and family audit.

## Generation Command

The merged milestone root uses symlinked problem directories. The generic
formal bundle generator does not discover those symlinked problem directories
through its run-root scan, so the run was materialized as a temporary symlink
farm with physical directories and symlinked files:

```bash
rm -rf /tmp/rtllm_final_analysis_input
cp -asL \
  /workspace/exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/merged_ref_default_fix_v0 \
  /tmp/rtllm_final_analysis_input

uv run python scripts/report_final_analysis_bundle.py \
  --run-root /tmp/rtllm_final_analysis_input \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/rtllm_reference_complete_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/final_analysis
```

The temporary `/tmp` input is reproducible from the committed command and the
raw experiment root; it is not part of the presentation artifact.

## Scope

The subset-scoped sections use `../rtllm_reference_complete_subset.yaml`, a
46-problem RTLLM subset that excludes only problems where at least one arm lacks
reference `area` in the summary schema:

- `Prob006_adder_pipe_64bit`
- `Prob013_multi_booth_8bit`
- `Prob018_float_multi`
- `Prob040_synchronizer`

This restriction is needed because `report_ppa_distribution.py` requires
`ref_ppa_metric["area"]`. The all-50 milestone packager handles the missing or
defaulted-reference cases separately and remains the correct source for the
presentation headline.

`backend_comparison.md` scans all backend summaries and therefore still lists
all 50 problems, using `N/A` where reference fields are missing. The
Pareto/PPA/design-space/feature sections are subset-scoped and report
`problem_count: 46`.

## Reading The Result

The formal bundle recommends:

- overall: `classic_revolution`
- score_qd: `sr_raw_conservative_exploit_qd`
- archive_qd: `sr_raw_conservative_exploit_qd`
- multi_objective: `classic_revolution`
- pareto winner: `classic_revolution`

This agrees with the presentation claim discipline: exact T26 has useful
archive/front diagnostic signal, but the formal reference-complete analysis
does not support a positive QD-effectiveness claim over classic.

## Files

- `report.md`: top-level formal bundle index and recommendations.
- `backend_comparison.md`: full-root backend comparison table.
- `hard_iteration_analysis/`: success, quality, runtime, and QD aggregate
  summary.
- `pareto_analysis/`: subset-scoped Pareto metrics and per-problem figures.
- `evolutionary_reports/`: generated evolutionary report summary.
- `ppa_distribution/`: subset-scoped PPA distribution report and figures.
- `design_space_analysis/`: generic feature profile over successful
  candidates.
- `feature_analysis/`: QD feature-space profile over QD artifacts.
- `summary.json`: machine-readable section index and recommendations.
- `visual_inspection_notes.md`: validation and visual caveats for the
  generated formal figures.
