# T71 Source-Aligned Feature Map Results

## Tier Decision

`T0 descriptor_design_unblocker`.

T71 is not a live QD result. It is a source-aligned descriptor-design package
that defines a small RTL-native archive map from T70 extractor outputs.

## Result

| Metric | Value |
| --- | ---: |
| Candidates | `19` |
| Problems | `7` |
| Possible cells | `16` |
| Occupied cells | `9` |
| Occupancy fraction | `0.5625` |
| Largest cell count | `4` |
| Archive entropy bits | `3.010571` |

State/timing class counts:

| Class | Count |
| --- | ---: |
| `comb` | `6` |
| `low_seq` | `8` |
| `mid_seq` | `2` |
| `high_seq` | `3` |

Operator-scale bins are balanced by construction: `op_q0`, `op_q1`, and
`op_q2` each contain 5 candidates; `op_q3` contains 4 candidates.

## Feature Range

| Feature | Min | Median | Max |
| --- | ---: | ---: | ---: |
| MasterRTL graph edges | `75` | `167` | `4097` |
| MasterRTL node-dict entries | `70` | `176` | `4098` |
| RTL-Timer DFF refs | `0` | `6` | `51` |
| Graph branching | `2.000000` | `2.238095` | `2.386047` |
| Wire pressure | `0.129310` | `0.153584` | `0.186528` |
| Timing-state density | `0.000000` | `0.090909` | `0.368421` |

## Visual Inspection

The descriptor scatter and archive-cell heatmap were visually inspected after
generation. The scatter cleanly separates combinational ALU/adder candidates
from sequential FSM, traffic-light, serial, signal-generator, and multi-pipe
candidates. The heatmap makes the 9 occupied cells and the largest 4-candidate
cell visible without relying on HTML interaction.

Primary figures:

- `figures/t71_descriptor_scatter.png`
- `figures/t71_archive_cell_heatmap.png`

## Interpretation

The T71 map is meaningful enough to advance the RTL-native lane from extractor
verification to a pre-registered live method. The map is not collapsed: it
places candidates across operator scale and state/timing morphology, and the
cell assignments match recognizable RTL families. For example, ALU candidates
land in high-operator combinational cells, multi-pipe candidates land in
higher state/timing cells, and FSM/parallel2serial candidates occupy low-seq
cells.

The limitation is sample size and coupling. T71 uses only 19 candidates from a
bounded T70 smoke. It does not show whether these cells improve PPA search,
whether they beat classic, or whether they retain PPA-front families. The next
method must test the cell map inside the live QD archive substrate.

## Next Decision

Pre-register a live source-aligned RTL-native QD variant that uses this map as
either:

- the primary archive cell;
- a secondary archive lane beside T51/T26-family parent pressure; or
- a gate for source-level front repair and parent selection.

The live variant should compare against classic and the strongest current QD
control on a reference-complete paired subset. It should include direct PPA
front plots and the Phase 03.1 viewer if archive artifacts are produced.
