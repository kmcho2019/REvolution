# T97 Front-Credit FG-QDM Memory

Status: completed smoke; diagnostic improvement; not promoted.

T97 tests a stricter configuration of front-guarded QD memory without adding a
new runtime mode. It raises the cell-credit threshold and lowers memory-refine
traffic so the auxiliary memory lane spends fewer calls on weakly credited
cells.

## Files

- [methodology.md](methodology.md)
- [results_report.md](results_report.md)
- [commands/run_t97_front_credit_fg_qdm.md](commands/run_t97_front_credit_fg_qdm.md)
- [tables/t97_backend_metrics.csv](tables/t97_backend_metrics.csv)
- [tables/t97_mechanism_summary.csv](tables/t97_mechanism_summary.csv)
- [figures/visual_inspection_notes.md](figures/visual_inspection_notes.md)
- [artifacts_manifest.md](artifacts_manifest.md)
- [analysis/pareto_analysis/report.md](analysis/pareto_analysis/report.md)
- [analysis/ppa_distribution/report.md](analysis/ppa_distribution/report.md)
