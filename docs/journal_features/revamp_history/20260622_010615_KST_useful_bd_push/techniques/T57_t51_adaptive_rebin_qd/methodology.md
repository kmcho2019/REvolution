# T57 T51 Adaptive-Rebin QD Methodology

Status: pre-registered; not launched.

## Question

T51 recovered much of the valid-yield and HV-AUC damage from the thought-only
lineage, but still missed classic's raw PPA-front breadth. T52 through T56
showed that widening local Pareto retention, nudging parent selection, and
coarsening SR-PCA geometry are not enough.

T57 asks whether T51's archive can stay yield-preserving while adapting its
grid-quantile cut points when the descriptor distribution shifts during the
run. This is an archive-mechanics change, not a descriptor or prompt change.

## Method Delta From T51

T57 keeps T51 fixed:

- hard/tuning 13-problem surface;
- seed `1001`;
- local vLLM model and 128k token budgets;
- `code_individual` representation;
- `single_thought_operator`;
- SR-PCA descriptor profile with `sr_pca_0`, `sr_pca_1`, and `sr_pca_2`;
- `grid_quantile` archive with warmup `4`;
- `elite_pareto_slot` with `qd_max_elites_per_cell=2`;
- champion lane `0.80`;
- `qd_parent_selection=nsga2_global_rank`;
- no two-parent fusion;
- no repair.

T57 changes only archive adaptation:

- `--qd_rebinning_kind ks_triggered`;
- `--qd_rebinning_recent_generations 1`;
- `--qd_rebinning_min_archive_members 8`;
- `--qd_rebinning_cooldown_generations 2`;
- `--qd_rebinning_base_p_threshold 0.05`.

The trigger compares descriptor values from current archive members against
recent archiveable samples with per-axis two-sample KS tests and a Bonferroni
threshold. When drift is detected, the archive rebuilds cut points and replays
stored archive members. The trigger does not use classic outcomes, final
front labels, reference PPA, hypervolume, or test-pass outcomes.

## Leakage Rules

The descriptor remains the frozen non-PPA SR-PCA profile. The pre-run probe
resolved exactly:

```text
sr_pca_0, sr_pca_1, sr_pca_2
requires_ppa=false
```

PPA enters only after candidate evaluation for archive quality, local front
slot retention, NSGA-II parent selection, and offline reporting. Rebinning may
inspect descriptor coordinates and retained archive membership after
evaluation, but not global classic results or final report metrics.

## Comparator Surface

Use the T47 through T56 hard/tuning surface:

- benchmarks: RTLLM and VerilogEval-Spec-to-RTL;
- problems: the 13 entries in `tables/hard_tuning_subset.yaml`;
- seed: `1001`;
- model: local vLLM `openai/gpt-oss-120b`;
- token budgets: `128000` max tokens and diff max tokens;
- classic comparator: T47 `classic_revolution` hard/tuning root;
- off-mode comparator: T51 `code_thought_front_slot_qd`;
- family context: T52 through T56.

Do not change the subset after seeing T57 outcomes.

## Required Measurements

Report:

- rebin check counts, trigger counts, trigger axes, replay-member counts, and
  final active archive members;
- mean HV and HV-AUC deltas versus matched classic;
- deltas versus T51 for valid-PPA count, HV, HV-AUC, aggregate front points,
  unique PPA points, and reference-beating candidates;
- classic-covered valid-PPA design losses;
- 50 percent yield warnings where classic has at least 10 passing samples;
- direct raw area-power PPA-front panels for all 13 problems;
- Phase 03.1 `qd_ppa_viewer/` with honest classic/T51 projection if archive
  artifacts support export.

## Acceptance Signals

T57 can advance only if it:

- preserves every classic-covered valid-PPA design;
- improves T51 on at least two of mean HV, HV-AUC, front points, unique PPA
  points, reference-beating candidates, or active archive members;
- keeps T51 valid-PPA count within 10 percent;
- shows nonzero rebin checks and either nonzero rebin triggers or a documented
  no-drift result with no metric regression;
- includes direct raw PPA figures and the Phase 03.1 viewer.

If T57 never reaches the minimum archive-member threshold, mark it `T0
diagnostic_no_rebin_signal` and do not blame adaptive rebinning. If it
triggers but loses T51 yield and front metrics, retire adaptive rebinning on
this hard/tuning surface.
