# T46 Frozen T11 PCA Graph Results Report

Status: complete live screen.

Tier: `T0 mixed_diagnostic`.

## Method Summary

T46 replaces T45's direct top-4 T11 graph axes with a frozen four-dimensional
PCA projection of the same top-8 graph feature family used in T44. The
projection is fitted only from non-PPA graph features in the T14 replay
feature table, then used online as ordinary archive coordinates.

The live screen, model, subset, seed, budget, operators, parent selection, and
archive mechanics stay fixed to T45.

## Run Summary

- run root:
  `exp/useful_bd_push/t46_t11_runtime_pca4_graph_20260622_182358_UTC`
- matched arms: `classic_revolution` and `t11_runtime_pca4_graph_qd`
- subset: `Prob045_alu`, `Prob041_traffic_light`,
  `Prob015_multi_pipe_8bit`
- seed/budget: seed `1001`, population `12`, generations `3`,
  `96` LLM calls per problem
- endpoint: `openai/gpt-oss-120b` with `max_model_len=131072`
- runtime: classic `664.23` seconds, T46 QD `744.18` seconds

Pareto archive validation passed for all three problems with
`failure_count=0`, `problem_invalid_count=0`, `acceptance_error_count=0`, and
`max_front_size_seen=2`.

## Main Result

T46 is a valid diagnostic, not a promotion. It preserves all three
classic-covered designs and avoids a 50 percent valid-PPA yield warning, but
classic wins the primary multi-objective comparison:

| Metric | Classic | T46 PCA4 | Read |
| --- | ---: | ---: | --- |
| Mean HV | 0.158754 | 0.115527 | classic wins |
| HV wins | 2 | 1 | T46 wins only `Prob045_alu` |
| Mean Pareto points | 2.67 | 3.00 | T46 has slightly broader local fronts |
| Mean reference-beating count | 11.00 | 7.00 | classic wins |
| Valid PPA samples | 54 | 37 | classic wins |
| Best-score wins | 1 | 2 | T46 wins ALU and multi-pipe score |

The positive signal is narrow but real: T46 improves `Prob045_alu` HV
(`0.204635` versus classic `0.196159`), contributes one pooled raw
area-power front point on ALU, and improves the final best score on ALU and
multi-pipe. The blocker is traffic-light: HV falls from `0.280105` to
`0.141947`, best score falls from `0.424797` to `0.377367`, and the direct
raw-PPA comparison has no T46 pooled-front hit for that problem.

## Visual Evidence

- Raw candidate table:
  `tables/t46_candidate_ppa_points.csv`
- Problem/method summary:
  `tables/t46_problem_method_summary.csv`
- Direct raw PPA-front PNG:
  `figures/t46_raw_area_power_fronts.png`
- Direct raw PPA count summary:
  `figures/t46_front_count_summary.png`
- Direct raw PPA-front HTML:
  `visualizations/direct_ppa_pareto/index.html`
- Direct raw PPA screenshot:
  `visualizations/direct_ppa_pareto/screenshot.png`
- Full Phase 03.1 viewer:
  `visualizations/qd_ppa_viewer/index.html`
- Full viewer validation:
  `visualizations/qd_ppa_viewer/validation.md`
- Manual visual notes:
  `figures/visual_inspection_notes.md`

The direct raw-PPA supplement shows the reader-facing lower-left-better
area-power fronts. The full Phase 03.1 viewer is present separately and passed
strict validation with Playwright.

Classic candidates are projected into the QD/PPA comparison honestly: the
viewer uses the matched classic backend as backend A, the T46 archive as
backend B, and the T46 archive source for the native archive pane. Classic has
PPA samples and comparison points but no fabricated in-loop T46 descriptor
archive of its own.

## Decision

Retire frozen PCA4 graph projection as a primary live archive coordinate for
now. The graph lane has repeatedly found narrow local signals, but T44 loses
yield, T45 loses primary metrics after fixing yield, and T46 loses aggregate
HV/reference-beating count after projection. Keep T11 graph features as
secondary archive/reporting coordinates or as inputs to a trained encoder; do
not spend the next live budget on another direct graph-axis dimensionality
variant without a new mechanism.
