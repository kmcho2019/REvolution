# T62 Fused RTL-Native BD Results

## Status

`T0 positive_proxy_not_promoted`.

T62 strengthens the RTL-native behavior-descriptor lane, but it is not a
headline QD win. The useful signal is narrow: fused structural/timing
descriptors improve the problem-balanced Pareto-front cell proxy, while broader
occupied-cell breadth remains worse than classic.

## Main Result

| Profile | Mean Front-Cell Delta | T26 Better | Classic Better | Ties | Mean Occupied-Cell Delta |
| --- | ---: | ---: | ---: | ---: | ---: |
| `operator_timing` | `+0.161290` | 7 | 7 | 17 | `-0.677419` |
| `state_pipeline` | `+0.161290` | 6 | 3 | 22 | `-0.612903` |
| `complexity_entropy` | `+0.129032` | 6 | 4 | 21 | `-0.806452` |

The script selects `operator_timing` as the best profile because it is the
first profile with the maximum mean front-cell delta. For method development,
`state_pipeline` is at least as interesting because it ties the front-cell
delta and has the gentler occupied-cell loss.

The pooled view does not show a decisive separation. Both classic and exact T26
occupy all 16 cells for all three profiles. Pooled front-cell counts also tie:
`15` versus `15` for `operator_timing`, `14` versus `14` for
`state_pipeline`, and `15` versus `15` for `complexity_entropy`.

## Completeness

The copied `tables/ppa_completeness.csv` records:

- `31` reference-complete headline problems;
- `15` candidate-missing problems;
- `4` diagnostic-only missing-reference problems:
  `Prob006_adder_pipe_64bit`, `Prob013_multi_booth_8bit`,
  `Prob018_float_multi`, and `Prob040_synchronizer`.

This package does not use missing/defaulted reference PPA for headline claims.

## Interpretation

The result supports the current priority shift: combine practical
T26/T51-family archive machinery with RTL-native descriptors. MasterRTL/SOG
features give reviewer-readable structural axes, and RTLTimer-style features
add timing-risk/path morphology. The fused proxy is more defensible than an
opaque embedding-only BD lane, but it still needs a live archive test.

The blocker is breadth. Exact T26 places front candidates into slightly more
useful fused cells on average, but it still explores fewer occupied cells. A
live follow-up should therefore use fused RTL-native descriptors as a guarded
secondary archive lane or a local-front reporting lane, not as an unrestricted
primary parent-selection geometry.

## Next Step

If the L7 lane advances, test a guarded fused RTL-native archive on top of the
T51/T26-family machinery. The live report must include:

- reference-complete paired PPA/HV/HV-AUC claims only;
- direct raw PPA-front figures;
- candidate and reference PPA completeness tables;
- duplicate/family checks;
- Phase 03.1 viewer artifacts if archive artifacts exist.
