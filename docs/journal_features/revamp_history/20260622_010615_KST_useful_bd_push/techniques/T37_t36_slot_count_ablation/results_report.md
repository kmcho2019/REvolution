# T37 T36 Slot-Count Ablation Results

Status: completed replay diagnostic. Tier: `T2 replay_candidate` for the
one-slot deployable arm; negative for two or more local-front slots.

## Method Summary

T37 tests whether the T36 bounded front lane should reserve zero, one, two, or
three descriptor-cell local area-power Pareto slots. It keeps the total retained
candidate count fixed, starts from the T11 structural contrastive farthest-first
order, then replaces the last `s` retained slots with candidates selected from
local descriptor-cell raw area-power Pareto order.

PPA is not used to fit the descriptor. PPA is used only after candidate
evaluation for replay retention analysis.

## Experimental Setup

- Candidate source:
  `exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv`.
- Graph source:
  `../T07_deepgate_family_bd/tables/netlist_graph_manifest.csv`.
- Hypergraph source:
  `../T14_dehnn_hypergraph_bd/tables/hypergraph_features.csv`.
- Retention fraction: `0.5`.
- Descriptor cells: `2 x 2` bins over the T11 structural descriptor.
- Replay groups: `114`.
- Valid PPA candidates in the replay source: `682`.
- Selected candidates per representation: `341`.

## Key Metrics

Definitions:

- `selected_hypervolume`: normalized PPA hypervolume over the selected replay
  candidates. Higher is better.
- `selected_all_valid_front_hits`: selected candidates that also lie on the
  all-valid raw area-power front for their problem group. Higher is better.
- `unique_ppa_points`: unique selected `(area, power, delay)` tuples. This is
  a breadth proxy, not a duplicate-family proof.
- `front_lane_slots`: explicit number of selected slots reserved for local
  descriptor-cell raw area-power Pareto candidates.

| Representation | Front slots | HV | HV vs lexical | Front hits | Front hit delta | Unique PPA |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| T35 front seeded | upper bound | 3.864198 | +4.39% | 132 | +10 | 171 |
| T37 top-64 slot 1 | 1 | 3.851344 | +4.04% | 126 | +4 | 180 |
| T37 weighted slot 1 | 1 | 3.851344 | +4.04% | 126 | +4 | 180 |
| Fitness top | control | 3.823248 | +3.28% | 122 | 0 | 159 |
| T37 top-64 slot 0 | 0 | 3.769259 | +1.82% | 120 | -2 | 186 |
| T11 top-64 | 0 | 3.769259 | +1.82% | 120 | -2 | 186 |
| Lexical | control | 3.701827 | 0.00% | 122 | 0 | 183 |
| T37 top-64 slot 2 | 2 | 3.369630 | -8.97% | 123 | +1 | 166 |
| T37 top-64 slot 3 | 2-3 | 3.369630 | -8.97% | 126 | +4 | 162 |

The explicit one-slot arm matches the T36 result and is the best deployable
tradeoff. Slot zero reproduces T11. Two or more local-front slots over-replace
the T11 farthest-first selector and fall back to the weak T35 cell-Pareto HV
regime.

## Figures

Open the direct raw PPA figures first:

- [t37_multi_problem_ppa_pareto_fronts.png](figures/t37_multi_problem_ppa_pareto_fronts.png)
- [t37_raw_area_power_pareto_front.png](figures/t37_raw_area_power_pareto_front.png)

Supporting summaries:

- [t37_hypervolume.png](figures/t37_hypervolume.png)
- [t37_front_hits.png](figures/t37_front_hits.png)
- [direct PPA HTML viewer](visualizations/direct_ppa_pareto/index.html)

The raw point table used to regenerate the direct front figures is
`tables/ppa_front_plot_points.csv`.

## Visual Inspection

The multi-problem and single-problem raw area-power figures were inspected
after generation. They use conventional area-on-x and power-on-y axes, mark
lower-left as better, show the all-valid front, and keep the T37 one-slot arm
visually distinguishable from the two-slot and three-slot arms.

The HTML viewer was rendered with Playwright and saved to
`visualizations/direct_ppa_pareto/screenshot.png`. The viewer title, summary
cards, problem selector, front lines, and point marks rendered without
undefined values.

## Conclusion

T37 answers the T36 ambiguity. The T36 percentage quotas looked like several
arms, but they all mapped to a one-slot local-front lane. T37 shows that the
one-slot setting is the useful boundary: it improves HV by `+4.04%` over
lexical and improves direct raw PPA front hits from `122` to `126`, while two
or more local-front slots damage HV enough to be rejected.

This is still replay evidence, not a final useful-BD claim. The next step is
same-budget live validation of the one-slot bounded lane, with direct raw PPA
Pareto figures as a required first readout. The live method should not use the
T35 front-seeded upper bound, and it should not expand the front lane beyond
one slot without new evidence.

## Validation

- `uv run pytest tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`
- `uv run ruff check scripts/analyze_t37_t36_slot_count_ablation.py tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`
- `uv run python -m pyright scripts/analyze_t37_t36_slot_count_ablation.py tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`
- `uv tool run ty check scripts/analyze_t37_t36_slot_count_ablation.py tests/scripts/test_analyze_t37_t36_slot_count_ablation.py`
- Playwright render check for `visualizations/direct_ppa_pareto/index.html`
