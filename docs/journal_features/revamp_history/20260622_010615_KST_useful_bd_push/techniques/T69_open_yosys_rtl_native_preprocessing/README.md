# T69 Open-Yosys RTL-Native Preprocessing

Status: `T0 preprocessing_unblocker`.

T69 tests whether the T68 `read -verific` blocker can be bypassed without
abandoning the upstream MasterRTL and RTL-Timer preprocessing semantics. It is
not a live QD method and does not contain PPA evidence.

## Main Result

Open-source Yosys can regenerate TinyRocket SOG/BOG artifacts close to the
shipped examples when the invocation removes only `read -verific` and the
generated Verilog is cleaned with the upstream attribute-stripping convention.

| Check | Result |
| --- | --- |
| MasterRTL open Yosys conversion | pass |
| MasterRTL `vlg2ir/analyze.py` parse after attribute cleanup | pass |
| RTL-Timer SOG BOG generation and cleanup | pass |
| Live QD/PPA promotion | blocked; no candidate run used this extractor yet |

## Navigation

- `methodology.md`: exact question, protocol, leakage rules, and promotion
  gate.
- `results_report.md`: measured evidence and decision.
- `artifacts_manifest.md`: local artifact paths, hashes, storage footprint,
  and regeneration notes.
- `commands/open_yosys_preprocessing.md`: exact commands used for the T69
  smoke.
- `tables/`: generated CSV/JSON metrics.
- `figures/t69_open_yosys_preprocessing_alignment.png`: visual comparison of
  open-source generated artifacts against shipped TinyRocket artifacts.
- `tools/write_t69_summary.py`: compact table and figure generator.

## Next Step

Use this preprocessing path on a tiny set of our generated RTL candidates. A
future technique may claim MasterRTL/RTLTimer-aligned BD evidence only after it
reports extractor success rate, descriptor sanity metrics, and a
reference-complete PPA comparison.
