# Retrospective Diversity Analysis Package

This package summarizes the prior retrospective branches and worktrees used to
ask whether RTL implementation-diversity measures explain later PPA outcomes.
It is a presentation-local digest, not a replacement for the source bundles.

## Main Takeaway

The retrospective evidence says diversity is measurable and interpretable, but
simple post-hoc diversity metrics did not explain or improve PPA fronts enough
to justify a standalone active-QD claim. This is why the presentation frames the
diagnostic T26 front signal around prospective exact T26 evidence, not around
generic descriptor causality.

## Source Roots

- `docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/`
- `exp/diversity_check/restarted_report_20260621_075346_UTC/`
- `exp/diversity_check/aspdac2026_submission_source/REvolution-aspdac2026-submission/exp/`
- `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/`

## Regeneration

Run from `/workspace`:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/retrospective/build_retrospective_summary.py
```

## Tables

- `tables/retrospective_source_coverage.csv`
- `tables/retrospective_gate_summary.csv`
- `tables/retrospective_counterfactual_replay.csv`
- `tables/retrospective_encoder_summary.csv`
- `tables/retrospective_cluster_case_study.csv`

## Figures

- `figures/retrospective_source_coverage.png`
- `figures/retrospective_gate_status.png`
- `figures/retrospective_replay_tradeoff.png`
- `figures/retrospective_qwen_replay_delta.png`
- `figures/retrospective_early_diversity_vs_final_hv.png`
- `figures/retrospective_cluster_case_study.png`
