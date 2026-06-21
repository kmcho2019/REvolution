# T27 Tables

| Table | Purpose |
| --- | --- |
| `live_qd_problem_metrics.csv` | Per-problem live audit metrics for classic, manual BD, random descriptor, SR raw, guarded SR raw, and conservative exploit SR raw. |
| `live_qd_aggregate_metrics.csv` | Three-problem aggregate metrics used for the T27 tier read. |
| `live_qd_comparison_deltas.csv` | Metric deltas for T26, SR raw, and guarded SR raw against the live comparators. |
| `live_qd_method_manifest.csv` | Source run roots and mode paths used to regenerate the audit. |

The unique-point fields are unique PPA improvement tuples, not canonical
netlist or implementation-family hashes.
