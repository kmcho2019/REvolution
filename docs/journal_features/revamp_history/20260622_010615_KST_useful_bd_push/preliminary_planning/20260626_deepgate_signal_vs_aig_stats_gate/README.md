# DeepGate Signal Vs AIG Stats Gate

This package checks whether the official DeepGate transition embeddings add
descriptor signal beyond simple AIG size/count statistics.

## Decision

DeepGate remains an active pretrained-netlist encoder lane, but it is not
promoted to final RTLLM spend. The official embeddings are not reducible to
simple AIG statistics, yet the current bridge still covers only `5/8`
screening problems and the raw embedding view remains problem-clustered.

## Artifacts

| Path | Purpose |
| --- | --- |
| `preregistration.md` | Frozen question, method, and decision gate. |
| `commands/run_deepgate_signal_vs_aig_stats.md` | Reproducible command. |
| `tools/analyze_deepgate_signal_vs_aig_stats.py` | Analysis script. |
| `tables/deepgate_signal_summary.json` | Machine-readable summary. |
| `tables/deepgate_signal_metrics.csv` | Metric table for the three representations. |
| `tables/deepgate_nearest_neighbors.csv` | Candidate-level nearest-neighbor diagnostics. |
| `tables/deepgate_problem_summary.csv` | Embedded-row coverage by problem. |
| `figures/deepgate_signal_vs_aig_stats.png` | Presentation-ready signal comparison. |
| `figures/visual_inspection_notes.md` | Manual figure inspection notes. |
| `results_report.md` | Result interpretation and next decision. |
