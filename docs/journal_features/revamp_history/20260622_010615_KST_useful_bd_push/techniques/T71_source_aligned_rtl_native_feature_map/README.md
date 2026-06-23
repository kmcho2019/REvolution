# T71 Source-Aligned RTL-Native Feature Map

Status: `T0 descriptor_design_unblocker`.

T71 turns the T70 source-aligned MasterRTL/RTL-Timer extractor smoke into a
candidate-level behavior-descriptor table and a draft archive-cell map. It is
not a live QD method and does not use PPA, fitness, test pass rate, Pareto
rank, hypervolume, or reference PPA as descriptor inputs.

## Main Result

The 19 generated T70 candidates cover 9 of 16 proposed cells. The largest
cell holds 4 candidates, and archive entropy is `3.010571` bits. This is enough
to show that the source-aligned extractor outputs are not collapsed into one
undifferentiated bin.

| Metric | Value |
| --- | ---: |
| Candidates | `19` |
| Problems | `7` |
| Possible cells | `16` |
| Occupied cells | `9` |
| Occupancy fraction | `0.5625` |
| Largest cell | `4` |
| Archive entropy bits | `3.010571` |

## Navigation

- `methodology.md`: descriptor definitions, cell map, leakage rules, and
  promotion gate.
- `results_report.md`: measured result, interpretation, and next decision.
- `artifacts_manifest.md`: committed artifacts and regeneration notes.
- `commands/build_feature_map.md`: storage check and exact build command.
- `tables/`: feature table, archive cells, feature summary, and metrics JSON.
- `figures/`: visually inspected descriptor scatter and archive heatmap.
- `tools/build_t71_feature_map.py`: deterministic builder.

## Next Step

Use this feature map to pre-register a live source-aligned RTL-native QD
variant only after deciding how the cells couple to parent selection, local
front retention, or secondary archives. The next live result must still be
judged by reference-complete PPA comparisons against classic and the strongest
available QD control.
