# Tables

Planned tables:

- `claim_gates.md`: gate checklist for any useful-QD claim.
- `planned_metric_schema.csv`: one-row-per-method/problem schema for the
  full RTLLM package.
- `full_rtllm/tables/full_problem_metrics.csv`: one row per method/problem.
- `full_rtllm/tables/full_aggregate_metrics.csv`: all-problem, screen, and
  screen-excluded aggregate metrics.
- `full_rtllm/tables/full_comparison_deltas.csv`: paired problem and aggregate
  deltas against classic.
- `full_rtllm/tables/full_validity_gates.csv`: functionality and valid-PPA
  counts with `classic_covered_loss`, `yield_warning`, and `small_n` labels.
- `full_rtllm/tables/full_budget_parity.csv`: runtime, LLM-call, token, and
  generated-candidate parity from per-problem summary JSON files.
- `full_rtllm/data/full_ppa_candidates.csv`: raw valid-PPA candidate points
  used to regenerate direct PPA-front figures.
- `method_lineage_selection.md`: why exact T26 or a T26.1 variant was selected.
- `full_rtllm/tables/full_method_manifest.csv`: method labels and run roots
  used by the generated package.

Tables must be reproducible from committed scripts or documented commands.
