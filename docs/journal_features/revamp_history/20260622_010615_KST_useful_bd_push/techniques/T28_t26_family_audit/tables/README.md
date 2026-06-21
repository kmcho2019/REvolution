# T28 Tables

| Table | Purpose |
| --- | --- |
| `family_candidate_rows.csv` | One row per valid-PPA candidate with RTL hash, synthesized-netlist hash, family hash, front flag, PPA metrics, and source path. |
| `family_problem_metrics.csv` | Per-method/per-problem duplicate and family-front metrics. |
| `family_aggregate_metrics.csv` | Three-problem aggregate family metrics used for the T28 tier read. |
| `family_comparison_deltas.csv` | T26 deltas against classic, manual BD, random, SR raw, and guarded SR raw. |
| `family_method_manifest.csv` | Source run roots and mode paths used to regenerate the audit. |

The family hash is a synthesized-cell histogram proxy, not formal netlist
graph isomorphism.
