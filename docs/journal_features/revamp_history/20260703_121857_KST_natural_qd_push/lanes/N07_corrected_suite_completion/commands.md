# N07 Commands

Registered: 2026-07-07 before any N07 V2-faithful live result.

## Descriptor Probes Already Run

```bash
uv run python scripts/qd_descriptor_probe.py \
  --profile source_aligned_rf_timing_state_3d \
  --archive_type grid_quantile \
  --circuit_type sequential \
  > docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/probes/probe_source_aligned_rf_timing_state_3d.json

uv run python scripts/qd_descriptor_probe.py \
  --profile rf_deepgate_hybrid_3d \
  --descriptor_file docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/tables/rf_deepgate_hybrid_descriptor_profiles.yaml \
  --archive_type grid_quantile \
  --circuit_type sequential \
  > docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/probes/probe_rf_deepgate_hybrid_3d.json

uv run python scripts/qd_descriptor_probe.py \
  --profile implemented_structural_compact_3d \
  --archive_type grid_quantile \
  --circuit_type sequential \
  > docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/probes/probe_implemented_structural_compact_3d.json
```

## N07a Extraction Smoke Already Run

```bash
timeout 600s uv run python scripts/probe_n07_extraction_smoke.py \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/smokes/n07a_source_aligned_rf_timing_20260707_130130_UTC
```

Result: pass. Artifacts:

- `smokes/n07a_source_aligned_rf_timing_20260707_130130_UTC/extraction_smoke_summary.json`
- `smokes/n07a_source_aligned_rf_timing_20260707_130130_UTC/descriptor_health.json`
- `smokes/n07a_source_aligned_rf_timing_20260707_130130_UTC/descriptor_health_report.md`

This was descriptor extraction only: no LLM calls, no evolutionary run,
and no performance claim.

## N07c Extraction Smoke Already Run

```bash
timeout 600s uv run python scripts/probe_n07_extraction_smoke.py \
  --profile implemented_structural_compact_3d \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/smokes/n07c_implemented_structural_compact_20260707_134155_UTC
```

Result: pass. Artifacts:

- `smokes/n07c_implemented_structural_compact_20260707_134155_UTC/extraction_smoke_summary.json`
- `smokes/n07c_implemented_structural_compact_20260707_134155_UTC/descriptor_health.json`
- `smokes/n07c_implemented_structural_compact_20260707_134155_UTC/descriptor_health_report.md`

This used existing V2 anchor synthesis-metric artifacts from 196
generated candidates across the frozen 8 problems. It was descriptor
extraction only: no LLM calls, no new evolutionary run, and no
performance claim.

## N07a Live Screen Already Run

Preflight:
`preflight_vllm_models_20260707_130714_UTC.json` reports
`openai/gpt-oss-120b`, `max_model_len=131072`, `owned_by=vllm`.

Run root:
`exp/natural_qd_push/n07_corrected_suite_20260707_130714_UTC/live/source_aligned_rf_timing_state_3d/seed_1001`.

The launched command matched the template below with:

- `--search_mode revolution_qd`
- `--representation_kind code_individual`
- `--qd_operator_kind eoh_strategies`
- `--qd_descriptor_profile source_aligned_rf_timing_state_3d`
- `--max_tokens 128000 --diff_max_tokens 128000`

Package commands:

```bash
uv run python scripts/report_pareto_analysis.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run smooth_qd_v2_8x5=exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001 \
  --backend_run n07a_source_aligned_rf_timing=exp/natural_qd_push/n07_corrected_suite_20260707_130714_UTC/live/source_aligned_rf_timing_state_3d/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07a_pareto_analysis

uv run python scripts/report_ppa_distribution.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run smooth_qd_v2_8x5=exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001 \
  --backend_run n07a_source_aligned_rf_timing=exp/natural_qd_push/n07_corrected_suite_20260707_130714_UTC/live/source_aligned_rf_timing_state_3d/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07a_ppa_distribution

uv run python scripts/report_hv_auc.py \
  --ppa-candidates docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07a_ppa_distribution/data/ppa_candidates.csv \
  --num-generations 5 \
  --output docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07a_hv_auc.csv

uv run python scripts/audit_operator_contract.py \
  --ppa-candidates docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07a_ppa_distribution/data/ppa_candidates.csv \
  --output docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07a_operator_contract.csv

uv run python scripts/validate_natural_qd_run.py \
  --run-root exp/natural_qd_push/n07_corrected_suite_20260707_130714_UTC/live/source_aligned_rf_timing_state_3d/seed_1001 \
  --manifest docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/tables/screen_manifest.csv \
  --arm qd \
  --expect-config search_mode=revolution_qd \
  --expect-config qd_operator_kind=eoh_strategies \
  --expect-config representation_kind=code_individual \
  --expect-config population_size=8 \
  --expect-config num_generations=5 \
  --expect-config evaluation_mode=strict_ablation \
  --expect-config seed=1001 \
  --expect-config qd_num_cells=16 \
  --expect-config qd_grid_quantile_warmup_successes=8 \
  --expect-config qd_cell_mode=pareto_front \
  --expect-config qd_max_elites_per_cell=5 \
  --expect-config qd_parent_selection=nsga2_global_rank \
  --expect-config qd_descriptor_profile=source_aligned_rf_timing_state_3d \
  --output docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07a_run_validation.json
```

## N07c Live Screen Already Run

Preflight:
`preflight_vllm_models_20260707_134510_UTC.json` reports
`openai/gpt-oss-120b`, `max_model_len=131072`, `owned_by=vllm`.

Run root:
`exp/natural_qd_push/n07_corrected_suite_20260707_134510_UTC/live/implemented_structural_compact_3d/seed_1001`.

The launched command matched the template below with:

- `--search_mode revolution_qd`
- `--representation_kind code_individual`
- `--qd_operator_kind eoh_strategies`
- `--qd_descriptor_profile implemented_structural_compact_3d`
- `--max_tokens 128000 --diff_max_tokens 128000`

Package commands:

```bash
uv run python scripts/report_pareto_analysis.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run smooth_qd_v2_8x5=exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001 \
  --backend_run n07c_implemented_structural_compact=exp/natural_qd_push/n07_corrected_suite_20260707_134510_UTC/live/implemented_structural_compact_3d/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07c_pareto_analysis

uv run python scripts/report_ppa_distribution.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run smooth_qd_v2_8x5=exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/smooth_qd_v2_8x5/seed_1001 \
  --backend_run n07c_implemented_structural_compact=exp/natural_qd_push/n07_corrected_suite_20260707_134510_UTC/live/implemented_structural_compact_3d/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07c_ppa_distribution

uv run python scripts/report_hv_auc.py \
  --ppa-candidates docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07c_ppa_distribution/data/ppa_candidates.csv \
  --num-generations 5 \
  --output docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07c_hv_auc.csv

uv run python scripts/audit_operator_contract.py \
  --ppa-candidates docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07c_ppa_distribution/data/ppa_candidates.csv \
  --output docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07c_operator_contract.csv

uv run python scripts/validate_natural_qd_run.py \
  --run-root exp/natural_qd_push/n07_corrected_suite_20260707_134510_UTC/live/implemented_structural_compact_3d/seed_1001 \
  --manifest docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/tables/screen_manifest.csv \
  --arm qd \
  --expect-config search_mode=revolution_qd \
  --expect-config qd_operator_kind=eoh_strategies \
  --expect-config representation_kind=code_individual \
  --expect-config population_size=8 \
  --expect-config num_generations=5 \
  --expect-config evaluation_mode=strict_ablation \
  --expect-config seed=1001 \
  --expect-config qd_num_cells=16 \
  --expect-config qd_grid_quantile_warmup_successes=8 \
  --expect-config qd_cell_mode=pareto_front \
  --expect-config qd_max_elites_per_cell=5 \
  --expect-config qd_parent_selection=nsga2_global_rank \
  --expect-config qd_descriptor_profile=implemented_structural_compact_3d \
  --output docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/n07c_run_validation.json
```

## Live Screen Template

Do not run this template until the arm's extraction smoke has passed.
Use the P0 V2 platform command and change only the descriptor argument
and save path.

```bash
RUN_ROOT=exp/natural_qd_push/n07_corrected_suite_<UTC>/live
curl -sS http://20.0.0.103:8000/v1/models \
  > docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push/lanes/N07_corrected_suite_completion/preflight_vllm_models_<UTC>.json

uv run python scripts/run_backend.py \
  --backend revolution \
  --benchmarks RTLLM VerilogEval-Spec-to-RTL \
  --problems Prob015_multi_pipe_8bit Prob024_fsm Prob041_traffic_light \
    Prob045_alu Prob049_signal_generator Prob116_m2014_q3 \
    Prob135_m2014_q6b Prob153_gshare \
  --api_backend vllm --vllm_host 20.0.0.103 --vllm_port 8000 \
  --vllm_min_model_len 128000 \
  --model_name openai/gpt-oss-120b \
  --max_tokens 128000 --diff_max_tokens 128000 \
  --population_size 8 --num_generations 5 \
  --evaluation_mode strict_ablation \
  --temperature 1.0 --top_p 1.0 \
  --total_worker_slots 32 --max_active_problems 8 \
  --max_workers_per_problem 4 \
  --seed 1001 \
  --no-backend_subdir \
  --search_mode revolution_qd \
  --representation_kind code_individual \
  --qd_operator_kind eoh_strategies \
  --qd_champion_lane_fraction 0.5 \
  --qd_parent_selection nsga2_global_rank \
  --qd_archive_type grid_quantile \
  --qd_descriptor_profile <PROFILE> \
  --qd_num_cells 16 \
  --qd_grid_quantile_warmup_successes 8 \
  --qd_cell_mode pareto_front \
  --qd_max_elites_per_cell 5 \
  --qd_rebinning_kind ks_triggered \
  --save_path "${RUN_ROOT}/<ARM>/seed_1001"
```

For N07b only, add the frozen descriptor file:

```bash
--qd_descriptor_file docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260626_rf_deepgate_hybrid_delayed_probe/tables/rf_deepgate_hybrid_descriptor_profiles.yaml
```

## Forbidden Copy

The 20260630 commands under
`../20260622_010615_KST_useful_bd_push/RTLLM_full_suite/20260630/commands/methods/`
are provenance inputs only. They are not valid N07 launch commands
because they change archive activation, cell mode, champion lane
fraction, fill/backfill fractions, and repair flags in addition to the
descriptor.
