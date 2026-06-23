# T69 Tables

- `open_yosys_preprocessing_metrics.json`: full metric bundle, hashes, and
  environment metadata.
- `open_yosys_preprocessing_summary.csv`: pass/block checklist.
- `source_path_inventory.csv`: upstream source paths, T68 blocker, and T69
  adaptation.
- `masterrtl_graph_comparison.csv`: shipped versus open-clean MasterRTL graph
  pickle metrics.
- `masterrtl_sog_verilog_comparison.csv`: shipped versus open-clean MasterRTL
  SOG Verilog text metrics.
- `rtltimer_bog_comparison.csv`: shipped versus open-clean RTL-Timer SOG BOG
  text metrics.

Regenerate these with `../tools/write_t69_summary.py` after recreating the
local `exp/verification/t69_*` artifacts.
