# T69 Artifacts Manifest

Generated: `2026-06-23T19:09:16Z` and refreshed by
`tools/write_t69_summary.py`.

## Source Inputs

| Source | Commit |
| --- | --- |
| MasterRTL | `5bccf38f8db7bb511a793a709863e7cb1b333ab5` |
| RTL-Timer | `206ff4078368c251d2fafaffcc648282c68316f1` |
| Yosys | `Yosys 0.54+29 (git sha1 7b0c1fe49)` |

## Local Verification Artifacts

These are intentionally under `exp/verification/`, not `/aux`.

| Path | Role | Size |
| --- | --- | ---: |
| `exp/verification/t69_masterrtl_open_yosys/` | open-source MasterRTL SOG output and cleaned copy | `6.5M` |
| `exp/verification/t69_masterrtl_open_parse_clean/` | upstream `analyze.py` graph and node-dictionary pickles | `4.3M` |
| `exp/verification/t69_rtltimer_open_yosys/` | open-source RTL-Timer SOG BOG output and cleaned copy | `2.9M` |
| `exp/verification/t69_masterrtl_open_parse/` | failed raw parse attempt kept as diagnostic evidence | `4.0K` |

The storage footprint is bounded at roughly `14M` for the T69 local generated
artifacts.

## Committed Package Artifacts

| Path | Purpose |
| --- | --- |
| `tables/open_yosys_preprocessing_metrics.json` | full metric and hash bundle |
| `tables/open_yosys_preprocessing_summary.csv` | pass/block summary |
| `tables/source_path_inventory.csv` | upstream path and adaptation inventory |
| `tables/masterrtl_graph_comparison.csv` | shipped versus open-clean graph counts |
| `tables/masterrtl_sog_verilog_comparison.csv` | shipped versus open-clean MasterRTL Verilog counts |
| `tables/rtltimer_bog_comparison.csv` | shipped versus open-clean RTL-Timer BOG counts |
| `figures/t69_open_yosys_preprocessing_alignment.png` | visual alignment check |
| `tools/write_t69_summary.py` | regeneration script for package tables/figure |

## Key Hashes

| Artifact | SHA256 |
| --- | --- |
| shipped MasterRTL `TinyRocket_sog.v` | `a202a2b5d6fdce47e37ac96d77f90ba4d2cf91f3beec1f819f109f15ad0c00c3` |
| open-clean MasterRTL `TinyRocket_sog_open_clean.v` | `59ae4c831f79607b031af38ce4192210bba94a82790699d2b6e941a1a1b62c88` |
| shipped RTL-Timer `TinyRocket.sog.v` | `d8d3d1c6bee5227e1aa97a5fb9869d590f6005026ae0178cbcc4bbd26a27abf6` |
| open-clean RTL-Timer `TinyRocket.sog.open_clean.v` | `c2e9c90f268e5dfea0f3e76495e654b82dfe828ef98f2d18d9a04a4632f1816f` |

## Regeneration

Recreate the local `exp/verification/t69_*` artifacts with
`commands/open_yosys_preprocessing.md`, then run:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/techniques/T69_open_yosys_rtl_native_preprocessing/tools/write_t69_summary.py
```
