# RF Leaf-ID Front-Slot Delayed Probe Results

Status: completed diagnostic; not promoted for full RTLLM spend.

## Definitions

- Hypervolume, or HV: normalized Pareto-front volume dominated by valid PPA
  candidates. Higher is better.
- Pareto point: a valid PPA candidate that is not dominated by another valid
  candidate on the reported objectives.
- Reference-beating candidate: a valid candidate that beats the benchmark
  reference PPA on at least one normalized objective used by the Pareto report.
- Headline-paired comparison: both classic and QD have valid candidate PPA and
  the benchmark reference PPA is valid for the design.

## Run

- Run root:
  `exp/useful_bd_push/prelim_rf_leafid_front_slot_delayed_20260626_062400_UTC/live/`
- QD backend:
  `masterrtl_rf_leafid_front_slot_delayed_8x5/seed_1001`
- Baseline:
  `classic_revolution_8x5/seed_1001` from
  `prelim_encoder_config_screen_20260625_134902_UTC`
- Subset:
  `../20260625_encoder_config_screening/tables/prelim_screen_subset.yaml`
- Budget:
  `population_size=8`, `num_generations=5`
- Model:
  `openai/gpt-oss-120b`
- Token budget:
  `max_tokens=128000`, `diff_max_tokens=128000`
- Runtime:
  `1651.69` seconds

## Method Read

T84 keeps T83's PPA-free descriptor axes:

```text
source_aligned_rf_timing_leaf_ids
source_aligned_masterrtl_branching
source_aligned_rtltimer_wire_density
```

It also keeps delayed archive activation at generation `3`, but changes parent
selection from global NSGA-II rank to `front_slot_lane_nsga2` with `0.20`
local front-slot traffic and `0.80` champion traffic.

This tests whether explicit local front-slot parent sampling repairs T83's
weak Pareto breadth. It is not a new pretrained model validation; the RF
leaf-ID coordinate still comes from the validated MasterRTL RF timing
model-state path.

## Headline Metrics

| Metric | Classic | T84 QD | Delta |
| --- | ---: | ---: | ---: |
| Mean HV | `0.1406447841` | `0.1161771736` | `-0.0244676105` |
| Mean Pareto points | `3.25` | `1.875` | `-1.375` |
| Mean reference-beating candidates | `8.00` | `3.75` | `-4.25` |
| HV wins | `5/8` | `0/8` | `-5` |

T84 loses the main screen decisively. It is worse than classic and worse than
T83 on all-design mean HV, Pareto points, reference-beating candidates, and HV
wins.

## Robustness Check

Removing `Prob135_m2014_q6b`, T84 improves over T83 but still loses classic:

| Backend | Problems | Mean HV | Mean Pareto points | Mean ref-beating |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | `7` | `0.1607368961` | `3.5714` | `9.0000` |
| `masterrtl_rf_leafid_structural_delayed_8x5` | `7` | `0.1281299195` | `2.0000` | `4.7143` |
| `masterrtl_rf_leafid_front_slot_delayed_8x5` | `7` | `0.1327739127` | `2.0000` | `4.2857` |

This means T84 slightly improves the no-`Prob135` robustness read versus T83,
but not enough to justify the much worse all-design score and zero HV wins.

## Descriptor Health

The descriptor path remains valid, but the RF leaf-ID axis still collapses in
archive entries for:

- `Prob045_alu`
- `Prob116_m2014_q3`
- `Prob135_m2014_q6b`

The full table is in `tables/descriptor_health_summary.csv`. T84 therefore
does not fix the RF model-state collapse pattern seen in T83.

## Visual Inspection

- `figures/rf_leafid_front_slot_delayed_summary.png` was inspected and is
  presentation-readable.
- The right panel makes the main result clear: T84 has three ties and no
  positive per-problem HV deltas versus classic.

## Decision

Do not promote exact T84 to the full RTLLM comparison.

The experiment answers its decision question: front-slot parent sampling is
too expensive for this RF leaf-ID descriptor under the current `8x5` budget.
It does not recover T83's front-material weakness, and it removes T83's
near-classic mean-HV signal.

Keep T83, not T84, as the current best representative of the pretrained
MasterRTL RF model-state lane. The next RF model-state attempt should change
the descriptor or combine RF state as a secondary diagnostic in a stronger
archive mechanism; it should not rerun this exact front-slot coupling.
