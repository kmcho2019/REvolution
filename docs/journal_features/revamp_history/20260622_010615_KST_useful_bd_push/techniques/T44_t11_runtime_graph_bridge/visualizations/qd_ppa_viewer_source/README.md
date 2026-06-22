# T44 QD/PPA Viewer Source Bundle

This directory holds the committed `final_analysis/` inputs used to regenerate
the full Phase 03.1 viewer in `../qd_ppa_viewer/`.

Required viewer inputs:

- `final_analysis/ppa_distribution/data/ppa_candidates.csv`
- `final_analysis/ppa_distribution/data/reference_ppa_metrics.csv`
- `final_analysis/design_space_analysis/successful_candidates.csv`

Useful result summaries:

- `final_analysis/pareto_analysis/aggregate_backend_metrics.csv`
- `final_analysis/pareto_analysis/backend_problem_metrics.csv`
- `final_analysis/evolutionary_reports/classic/per_problem_summary.csv`
- `final_analysis/evolutionary_reports/t11_runtime_top8_graph_qd/per_problem_summary.csv`

Regenerate the viewer with the command in `../qd_ppa_viewer/README.md`. Keep
this source bundle aligned with `manifest.json` so descriptor recovery and
classic archive projection remain reproducible.
