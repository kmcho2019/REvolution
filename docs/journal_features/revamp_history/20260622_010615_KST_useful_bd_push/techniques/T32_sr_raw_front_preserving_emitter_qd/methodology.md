# T32 SR Raw Front-Preserving Emitter QD Methodology

## Purpose

T32 is the next archive-coupling follow-up after T31. T30 showed that exact
T26 conservative-exploit SR raw can survive the frozen VerilogEval holdout and
improve P135 quality/HV, but it does not broaden raw PPA-front evidence and it
has a P098 valid-PPA warning. T31 tested whether direct same-budget
fail-feedback repair fixes that warning; it did not.

T32 therefore does not retry direct fail-pool feedback. It keeps the T26/T30
descriptor and archive substrate, keeps most champion pressure, and gives a
small explicit success-parent lane back to NSGA-II/front-preserving archive
sampling.

## Hypothesis

A modest front-preserving success-parent lane can recover some unique PPA/front
breadth or P098 yield without losing T26's P135 quality/HV signal.

This is a same-budget emitter schedule probe, not a new behavior descriptor and
not a repair-loop expansion.

## Compared Evidence

T32 compares against already-packaged roots:

1. T30 `classic_revolution`;
2. T30 `sr_raw_conservative_exploit_qd`;
3. T31 `sr_raw_fail_feedback_repair_qd`;
4. T32 `sr_raw_front_preserving_emitter_qd`, the new arm.

T32 uses the same holdout problems, seed, model, prompt root, token budget,
population size, generations, strict-ablation evaluation, and SR raw
descriptor file as T30/T31.

## Method Delta From T26/T30/T31

Unchanged from T26/T30:

- SR raw PCA descriptor profile: `sr_pca_3d`;
- `grid_quantile` archive with warmup successes `8`;
- local `pareto_front` cell mode with up to `5` elites per cell;
- `qd_parent_selection=nsga2_global_rank`;
- `qd_fill_target_fraction=0.25`;
- `qd_improve_backfill_fraction=0.20`;
- `representation_kind=code_individual`;
- `repair_kind=none`;
- `qd_operator_kind=eoh_strategies`.

Changed in T32:

- `qd_champion_lane_fraction=0.72`, between T26's `0.80` and failed T29's
  `0.60`;
- `qd_two_parent_probability=0.08`, a small front-preserving success-parent
  lane that is less aggressive than T29's `0.20`;
- no `single_thought_operator` and no fail-feedback text, because T31 already
  showed that direct same-budget fail-feedback repair worsens this holdout.

The intended parent mixture is:

- mostly champion refinement, preserving T26 quality pressure;
- some NSGA-II global-rank/crowding success-parent sampling, preserving
  near-front archive candidates;
- no expanded repair loop and no in-loop PPA descriptor input.

## Leakage Rules

T32 does not use final PPA, reference PPA, fitness, hypervolume, Pareto rank,
or pass rate as behavior-descriptor inputs. PPA enters only after evaluation
for local Pareto retention, NSGA-II parent selection, archive reporting, and
offline analysis.

## Holdout Screen

The holdout problems remain frozen:

- `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot`
- `VerilogEval-Spec-to-RTL/Prob098_circuit7`
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`

Do not replace the holdout problems after seeing outcomes.

## Acceptance Signals

T32 can be considered a useful follow-up only if it:

- preserves at least one valid functional PPA candidate for every design where
  T30 classic and T26 had one;
- avoids a 50 percent or larger valid-PPA count drop versus T30 classic where
  classic has at least 10 passing samples;
- improves P098 valid-PPA count versus T26's `15` and T31's `14`, or improves
  a direct PPA-front breadth metric without worsening P098 further;
- keeps P135 final-best score and normalized HV close to T26, rather than
  repeating T31's zero-HV collapse;
- improves front breadth versus T26/T31 on at least one direct metric such as
  unique PPA points, candidate-level front points, front unique families, or
  front unique netlists;
- passes Pareto archive validation.

If T32 only improves a ratio by reducing the denominator, mark it `T0
diagnostic`. If it preserves P135 quality while modestly improving P098 yield
or direct front breadth, mark it at least `T1 near_classic` for deeper audit.

## Required Artifacts

- `/v1/models` preflight capture;
- exact live command in `commands/live_holdout_v0.md`;
- run matrix with resolved T32 root and T30/T31 comparator roots;
- Pareto archive validation for the T32 arm;
- direct raw area-power PPA Pareto PNGs with conventional non-inverted axes,
  lower-left marked as better, rank-1 front markers, and candidate-only zooms
  when the reference design stretches the scale;
- candidate-level raw PPA/front table with method, problem, area, power,
  optional clock period, front membership, and source candidate id so the
  direct plot can be regenerated;
- normalized improvement-front plots;
- validity/yield, HV/HV-AUC, and canonical family/netlist tables;
- visual inspection notes;
- `results_report.md` with a T0/T1/T2/T3 tier decision.

## Current Status

Completed as `T0 diagnostic`. The method improves P098 valid-PPA count versus
T26/T31, but it does not preserve T26's P135 quality/HV signal.
