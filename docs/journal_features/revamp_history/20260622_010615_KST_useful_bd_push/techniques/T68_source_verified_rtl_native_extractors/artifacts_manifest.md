# T68 Source-Verified RTL-Native Extractors Artifacts Manifest

## External Sources

| Repository | Local checkout | Commit |
| --- | --- | --- |
| MasterRTL | `exp/external_repos/MasterRTL` | `5bccf38f8db7bb511a793a709863e7cb1b333ab5` |
| RTL-Timer | `exp/external_repos/RTL-Timer` | `206ff4078368c251d2fafaffcc648282c68316f1` |

The checkouts are intentionally under ignored `exp/` storage. This package
records the relevant commits and measured outputs.

## Generated Verification Outputs

| Path | Purpose |
| --- | --- |
| `tables/upstream_repo_inventory.csv` | Commit and source capability summary. |
| `tables/upstream_verification_summary.csv` | Human-readable check table. |
| `tables/upstream_verification_metrics.json` | Raw quantitative metrics. |
| `figures/rtltimer_sog_slack_alignment.png` | Visual check of RTL-Timer SOG timing alignment. |
| `commands/upstream_verification.md` | Reproduction commands and observed blockers. |
| `tools/verify_upstream_artifacts.py` | Committed verifier that regenerates tables and the timing-alignment figure from local upstream checkouts. |

Additional untracked run logs are under `exp/verification/`:

- `masterrtl_yosys_sog/`
- `rtltimer_yosys_sog/`
- `masterrtl_vlg2ir/`
- `masterrtl_vlg2ir_with_venv/`
- `masterrtl_analyze_direct2/`
- `masterrtl_model_infer/`

## Validation

- Upstream clone commits recorded with `git -C <repo> rev-parse HEAD`.
- Open-source Yosys preflight recorded with `yosys -V`.
- Isolated environment created with `uv venv exp/venvs/rtl_native_verify`.
- Visual inspection: `figures/rtltimer_sog_slack_alignment.png` is readable and
  has no label overlap.
- `tools/verify_upstream_artifacts.py` reran successfully with
  `exp/venvs/rtl_native_verify/bin/python`.
