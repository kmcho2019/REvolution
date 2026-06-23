# T68 Tables

| File | Meaning |
| --- | --- |
| `upstream_repo_inventory.csv` | Source commits, saved-weight availability, example availability, and conversion status. |
| `upstream_verification_summary.csv` | Compact table of pass, limited-pass, and blocker checks. |
| `upstream_verification_metrics.json` | Raw quantitative metrics from shipped MasterRTL and RTL-Timer artifacts. |

Regenerate these tables with
`tools/verify_upstream_artifacts.py` from the repository root after cloning the
upstream repositories under `exp/external_repos/`.
