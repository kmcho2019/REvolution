# PPA Distribution Analysis

- candidate_count: `578`
- reference_problem_count: `3`
- best_backend_problem_count: `21`
- figure_count: `10`

## Outputs

- candidates: [ppa_candidates.csv](data/ppa_candidates.csv)
- best candidates: [best_candidate_by_backend_problem.csv](data/best_candidate_by_backend_problem.csv)
- references: [reference_ppa_metrics.csv](data/reference_ppa_metrics.csv)
- all-backend figures: [figures/all_backends](figures/all_backends)
- classic-vs figures: [figures/classic_vs](figures/classic_vs)

Figures use filled score contours when enough non-collinear candidates are available, white contour lines for local score levels, subtle projected Pareto-front lines, and a red star for the reference design.

## Problems

| Benchmark | Problem | Circuit | Candidates | Figure Root |
| --- | --- | --- | ---: | --- |
| `RTLLM` | `Prob019_sub_64bit` | `combinational` | 235 | [figures/all_backends/RTLLM/Prob019_sub_64bit](figures/all_backends/RTLLM/Prob019_sub_64bit) |
| `RTLLM` | `Prob036_edge_detect` | `sequential` | 148 | [figures/all_backends/RTLLM/Prob036_edge_detect](figures/all_backends/RTLLM/Prob036_edge_detect) |
| `RTLLM` | `Prob045_alu` | `combinational` | 195 | [figures/all_backends/RTLLM/Prob045_alu](figures/all_backends/RTLLM/Prob045_alu) |
