# T80 Artifacts Manifest

| Path | Description |
| --- | --- |
| `README.md` | Package index and result status. |
| `methodology.md` | Descriptor definition, anti-gaming rules, and gate. |
| `commands/t80_structural_mix_gate_v0.md` | Reproduction and check commands. |
| `tools/run_t80_masterrtl_structural_mix_gate.py` | Reproducer for tables and figure. |
| `tables/t80_candidate_descriptors.csv` | Per-candidate descriptor rows after generation. |
| `tables/t80_cell_occupancy.csv` | Static and quantile cell occupancy. |
| `tables/t80_summary.json` | Tier, counts, entropy, and decision. |
| `figures/t80_masterrtl_structural_mix_gate.png` | Descriptor-space and occupancy visual. |
| `figures/visual_inspection_notes.md` | Manual plot inspection. |
| `results_report.md` | Final interpretation and follow-up. |

Generated summary:

| Metric | Value |
| --- | ---: |
| Unique descriptor rows | `17/19` |
| Static occupied cells | `4` |
| Quantile occupied cells | `15` |
| T77 unique Area leaf rows | `1` |

Source evidence:

| Source | Path |
| --- | --- |
| T77 raw MasterRTL features | `../T77_masterrtl_area_leaf_variation_gate/tables/t77_area_candidate_features.csv` |
| Runtime evaluator | `src/revolution/source_aligned_descriptor_evaluator.py` |
| Descriptor profile | `data/configs/qd_descriptor_profiles.yaml` |
