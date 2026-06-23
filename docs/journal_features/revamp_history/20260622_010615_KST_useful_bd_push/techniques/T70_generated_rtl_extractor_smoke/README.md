# T70 Generated RTL Extractor Smoke

Status: `T0 extractor_smoke_unblocker`.

T70 applies the T69 open-Yosys MasterRTL/RTL-Timer preprocessing path to real
REvolution-generated RTL from the T67 hard/tuning run. It checks whether the
source-aligned extractors work on our candidate distribution before spending
another live RTL-native QD budget.

## Main Result

Both extractors parse every sampled candidate:

| Group | Count | MasterRTL pass | RTL-Timer pass | Both pass |
| --- | ---: | ---: | ---: | ---: |
| all | `19` | `19` | `19` | `19` |
| first raw | `7` | `7` | `7` | `7` |
| first synthesized | `5` | `5` | `5` | `5` |
| last synthesized | `7` | `7` | `7` | `7` |

Five sampled candidates did not already have `code.syn.v`, so this is not only
a post-synthesis artifact check. The extractors also produced nonempty,
differentiated artifacts: MasterRTL graph edges range from `75` to `4097`, and
RTL-Timer DFF references range from `0` to `51`.

## Navigation

- `methodology.md`: sample rule, extractor commands, leakage rules, and
  promotion gate.
- `results_report.md`: measured result and interpretation.
- `artifacts_manifest.md`: committed and local artifact paths.
- `commands/generated_rtl_extractor_smoke.md`: exact rerun command and storage
  check.
- `tables/`: candidate manifest, pass/fail results, summary, and JSON metrics.
- `figures/`: pass-rate and output-richness figures with visual notes.
- `tools/run_t70_extractor_smoke.py`: deterministic runner.

## Next Step

The next RTL-native method may move from source-alignment to descriptor design.
It should extract MasterRTL/RTL-Timer features for a larger candidate set and
define archive cells from pre-synthesis operator/control/timing-risk features
without using PPA, fitness, test pass rate, Pareto rank, or hypervolume as BD
inputs.
