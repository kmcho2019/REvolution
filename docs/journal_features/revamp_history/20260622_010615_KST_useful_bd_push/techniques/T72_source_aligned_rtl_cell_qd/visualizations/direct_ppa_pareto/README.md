# T72 Direct PPA Pareto Supplement

This package is the reader-facing PPA distribution supplement for the fixed
T72 hard/tuning screen.

- `index.html`: compact visual index for the most useful raw PPA plots.
- `metrics.json`: scope and claim-status summary.
- `report.md`: generated PPA distribution report.
- `summary.json`: generated run summary from `report_ppa_distribution.py`.
- `data/ppa_candidates.csv`: candidate-level PPA rows.
- `data/reference_ppa_metrics.csv`: reference PPA rows.
- `data/best_candidate_by_backend_problem.csv`: best T72 candidate per
  problem.
- `figures/all_backends/`: raw and gain plots for each problem.
- `screenshot.png`: representative raw area-power plot.

This is a single-backend package for `source_aligned_rtl_cell_qd`. It should
not be used as evidence of a classic-vs-QD win.
