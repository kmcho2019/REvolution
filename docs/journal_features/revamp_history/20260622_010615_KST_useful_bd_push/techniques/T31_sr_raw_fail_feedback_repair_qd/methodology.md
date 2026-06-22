# T31 SR Raw Fail-Feedback Repair QD Methodology

## Purpose

T31 is the first repair/yield/front-preserving follow-up after the T30 holdout
audit. T30 showed that exact T26 conservative-exploit SR raw is holdout
competitive on final best score and normalized HV, but still has a P098
valid-PPA yield warning and no raw PPA-front breadth win.

T31 keeps the T26/T30 descriptor and archive substrate, then changes only the
emitter used for new code generation. The aim is to spend the same
population/generation budget while using existing failed candidates more
directly as repair evidence.

## Hypothesis

Failure-feedback repair can increase valid-PPA yield on the frozen holdout
screen, especially P098, without losing T26's P135 quality gain or collapsing
the raw PPA front.

This is a high-risk repair probe, not a promotion shortcut. Older journal
evidence found that radical `thought_only` QD often traded PPA quality for pass
rate. T31 therefore stays in `code_individual` representation and does not use
extra bounded local repair attempts in the first live run.

## Compared Evidence

T31 compares against the already-packaged T30 holdout roots:

1. `classic_revolution` from T30;
2. `sr_raw_conservative_exploit_qd` from T30;
3. `sr_raw_fail_feedback_repair_qd`, the new T31 arm.

The T31 arm uses the same holdout problems, seed, model, prompt root, token
budget, population size, generations, strict-ablation evaluation, and SR raw
descriptor file as T30.

## Method Delta From T26/T30

Unchanged from T26/T30:

- SR raw PCA descriptor profile: `sr_pca_3d`;
- `grid_quantile` archive with warmup successes `8`;
- local `pareto_front` cell mode with up to `5` elites per cell;
- `qd_parent_selection=nsga2_global_rank`;
- `qd_champion_lane_fraction=0.80`;
- `qd_two_parent_probability=0.00`;
- `qd_fill_target_fraction=0.25`;
- `qd_improve_backfill_fraction=0.20`;
- `representation_kind=code_individual`.

Changed in T31:

- `qd_operator_kind=single_thought_operator`;
- `qd_operator_one_parent_fraction=1.00`;
- `qd_operator_archive_context_size=4`;
- `qd_operator_fail_feedback_chars=1200`;
- `qd_operator_two_parent_allow_intra_bin` remains enabled but is inactive
  because one-parent fraction is `1.00`;
- `repair_kind=none`, so T31 does not spend extra repair calls.

The single-thought operator includes failure stage and truncated feedback when
the sampled parent comes from the fail pool. For successful archive parents it
receives PPA-gain summaries and archive context. This makes T31 a same-budget
failure-feedback repair emitter, not a new BD and not an extra-evaluation
repair loop.

## Leakage Rules

T31 does not use final PPA, reference PPA, fitness, hypervolume, Pareto rank,
or pass rate as behavior-descriptor inputs. PPA enters only after evaluation
for local Pareto retention, NSGA-II parent selection, archive reporting, and
offline analysis. The failure-feedback text is restricted to the candidate's
failed stage and evaluator feedback, not PPA labels.

## Holdout Screen

The holdout problems remain frozen:

- `VerilogEval-Spec-to-RTL/Prob150_review2015_fsmonehot`
- `VerilogEval-Spec-to-RTL/Prob098_circuit7`
- `VerilogEval-Spec-to-RTL/Prob135_m2014_q6b`

This package must not replace holdout problems after seeing outcomes.

## Acceptance Signals

T31 can be considered a useful follow-up only if it:

- preserves at least one valid functional PPA candidate for every design where
  T30 classic and T26 had one;
- avoids a 50 percent or larger valid-PPA count drop versus T30 classic where
  classic has at least 10 passing samples;
- improves or at least preserves P098 valid-PPA count versus T26's 15 samples;
- does not lose T26's P135 final-best quality signal by a large margin;
- improves front breadth versus T26 on at least one direct metric such as
  unique PPA points, candidate-level front points, front unique families, or
  front unique netlists;
- passes Pareto archive validation.

If T31 only improves yield while damaging PPA quality or front breadth, mark it
as `T0 diagnostic` and use it to design a narrower repair lane.

## Required Artifacts

- `/v1/models` preflight capture;
- exact live command in `commands/live_holdout_v0.md`;
- run matrix with T30 comparator roots and resolved T31 root;
- Pareto archive validation for the T31 arm;
- direct raw area-power PPA Pareto PNGs with conventional non-inverted axes,
  lower-left marked as better, rank-1 front markers, and candidate-only zooms
  when the reference design stretches the scale;
- normalized improvement-front plots;
- validity/yield, HV/HV-AUC, and canonical family/netlist tables;
- visual inspection notes;
- `results_report.md` with a T0/T1/T2/T3 tier decision.

## Current Status

Completed as `T0 diagnostic`. The method preserves final-best coverage, but it
does not repair P098 yield and does not preserve T26's P135 quality/HV signal.
