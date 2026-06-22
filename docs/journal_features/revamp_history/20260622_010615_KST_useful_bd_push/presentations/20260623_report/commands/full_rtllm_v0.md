# Full RTLLM V0 Commands

This file records the intended command shape and the completed milestone
commands. The completed package uses a merged analysis root because three QD
problems needed a repair run after missing-reference PPA handling was fixed.

```bash
RUN_TS="$(date -u +%Y%m%d_%H%M%S_UTC)"
RUN_ROOT="exp/useful_bd_push/rtllm_milestone_full_${RUN_TS}"
mkdir -p "${RUN_ROOT}/preflight"
curl -sS --max-time 10 http://20.0.0.103:8000/v1/models \
  > "${RUN_ROOT}/preflight/models_${RUN_TS}.json"
```

```bash
export OPENAI_API_KEY="${OPENAI_API_KEY:-vllm-local-placeholder}"
export PYTHONPATH=src

RTLLM_PROBLEMS=(
  Prob001_accu Prob002_adder_16bit Prob003_adder_32bit
  Prob004_adder_8bit Prob005_adder_bcd Prob006_adder_pipe_64bit
  Prob007_comparator_3bit Prob008_comparator_4bit Prob009_div_16bit
  Prob010_radix2_div Prob011_multi_16bit Prob012_multi_8bit
  Prob013_multi_booth_8bit Prob014_multi_pipe_4bit
  Prob015_multi_pipe_8bit Prob016_fixed_point_adder
  Prob017_fixed_point_substractor Prob018_float_multi Prob019_sub_64bit
  Prob020_JC_counter Prob021_counter_12 Prob022_ring_counter
  Prob023_up_down_counter Prob024_fsm Prob025_sequence_detector
  Prob026_asyn_fifo Prob027_LIFObuffer Prob028_LFSR
  Prob029_barrel_shifter Prob030_right_shifter Prob031_freq_div
  Prob032_freq_divbyeven Prob033_freq_divbyfrac Prob034_freq_divbyodd
  Prob035_calendar Prob036_edge_detect Prob037_parallel2serial
  Prob038_pulse_detect Prob039_serial2parallel Prob040_synchronizer
  Prob041_traffic_light Prob042_width_8to16 Prob043_RAM Prob044_ROM
  Prob045_alu Prob046_clkgenerator Prob047_instr_reg Prob048_pe
  Prob049_signal_generator Prob050_square_wave
)

COMMON_ARGS=(
  --backend revolution
  --benchmarks RTLLM
  --problems "${RTLLM_PROBLEMS[@]}"
  --api_backend vllm
  --vllm_host 20.0.0.103
  --vllm_port 8000
  --vllm_min_model_len 128000
  --model_name openai/gpt-oss-120b
  --max_tokens 128000
  --diff_max_tokens 128000
  --population_size 12
  --num_generations 3
  --evaluation_mode strict_ablation
  --temperature 1.0
  --top_p 1.0
  --total_worker_slots 50
  --max_active_problems 50
  --max_workers_per_problem 4
  --seed 1001
  --no-backend_subdir
)
```

Classic arm:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution \
  --classic_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --save_path "${RUN_ROOT}/classic_revolution/seed_1001"
```

Selected QD arm, exact T26:

```bash
uv run python scripts/run_backend.py \
  "${COMMON_ARGS[@]}" \
  --search_mode revolution_qd \
  --qd_archive_type grid_quantile \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_fill_target_fraction 0.25 \
  --qd_improve_backfill_fraction 0.20 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_objectives ppa \
  --qd_champion_lane_fraction 0.80 \
  --qd_parent_selection nsga2_global_rank \
  --qd_two_parent_probability 0.00 \
  --qd_operator_kind eoh_strategies \
  --representation_kind code_individual \
  --qd_descriptor_profile sr_pca_3d \
  --qd_descriptor_file docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml \
  --save_path "${RUN_ROOT}/sr_raw_conservative_exploit_qd/seed_1001"
```

Package completed arms:

```bash
uv run python scripts/package_rtllm_milestone_full.py \
  --run-root "${RUN_ROOT}" \
  --manifest docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/data/rtllm_50_problem_manifest.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm
```

Then inspect every PNG under `full_rtllm/figures/` before moving figures into
the slide deck or report.

## Completed Run

Primary run root:

```text
exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC
```

Merged package root:

```text
exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/merged_ref_default_fix_v0
```

Repair source for `Prob013_multi_booth_8bit`, `Prob018_float_multi`, and
`Prob040_synchronizer`:

```text
exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/sr_raw_conservative_exploit_qd_ref_default_fix/seed_1001/openai_gpt-oss-120b
```

Completed packaging command:

```bash
uv run python scripts/package_rtllm_milestone_full.py \
  --run-root exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/merged_ref_default_fix_v0 \
  --manifest docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/data/rtllm_50_problem_manifest.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm
```

The final package has `0` hard retention failures, `4` yield warnings, and
claim status `reviewable`.

## Completed Phase 03.1 Viewer Export

The full RTLLM viewer source was generated under:

```text
exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/qd_ppa_viewer_source_full
```

The viewer subset includes the `37` RTLLM problems with at least one valid
PPA candidate. The other `13` manifest problems remain in the aggregate
package but have no candidate-level PPA point to render.

Classic candidates were projected into the exact T26 SR-PCA archive with the
frozen SR raw PCA artifact from the 20260618 Auto-BD run. Projection summary:

```text
classic rows: 352
projected rows: 352
failed rows: 0
descriptor hash: 931edf18e9ec5e3a7b2b8d7996c603c64ec82619f6185ea44cf4803e6105ee1b
```

Export command:

```bash
uv run python scripts/export_qd_ppa_visualization.py \
  --run-root exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/qd_ppa_viewer_source_full \
  --backend_run classic=exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/classic_revolution/seed_1001 \
  --backend_run sr_raw_conservative_exploit_qd=exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/qd_viewer_backend_physical \
  --archive_source_backend sr_raw_conservative_exploit_qd \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/visualizations/rtllm_valid_ppa_viewer_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/visualizations/qd_ppa_viewer \
  --strict \
  --no-classic-descriptor-recovery
```

Validation command:

```bash
uv run python scripts/validate_qd_ppa_visualization.py \
  --viewer-root docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/visualizations/qd_ppa_viewer \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/visualizations/rtllm_valid_ppa_viewer_subset.yaml \
  --strict \
  --playwright
```

Validation result: `QD/PPA viewer validation passed`.

## Completed Family Audit

Command:

```bash
uv run python scripts/package_full_rtllm_family_audit.py \
  --run-root exp/useful_bd_push/rtllm_milestone_full_20260622_142254_UTC/merged_ref_default_fix_v0 \
  --manifest docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/data/rtllm_50_problem_manifest.csv \
  --ppa-candidates docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/data/full_ppa_candidates.csv \
  --output-dir docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/presentations/20260623_report/full_rtllm/family_audit
```

Headline result: exact T26 QD has `69` front family-proxy hits and `69` front
netlists versus classic's `61` and `61`. Exact T26 QD has fewer summed family
proxies (`311` versus `341`) and fewer reference-beating family-proxy hits
(`129` versus `179`), so this supports a front-material proxy observation
rather than broad family dominance.
