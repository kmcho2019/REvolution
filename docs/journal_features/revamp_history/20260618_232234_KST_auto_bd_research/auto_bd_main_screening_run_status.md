# Auto-BD Main Screening Run Status

- Matrix: `docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_main_screening_run_matrix.json`
- Phase: `main_screening`
- Arms: `classic_revolution`, `landing_smooth_qd_manual_bd`, `random_descriptor_qd`, `synthesis_trajectory_nod`

## Summary

| Level | Total | Complete | Partial | Pending | Runs Complete | Standard Results |
| --- | --- | --- | --- | --- | --- | --- |
| Manifest | 12 | 12 | 0 | 0 | 0 | 0 |
| Benchmark Command | 24 | 23 | 0 | 1 | 0 | 0 |
| Arm/Seed | 12 | 0 | 1 | 0 | 0 | 11 |

## Arm / Seed Status

| Arm | Seed | Status | Benchmark Groups | Standard Results |
| --- | --- | --- | --- | --- |
| `classic_revolution` | 1001 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1001/standard_results` |
| `classic_revolution` | 1002 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1002/standard_results` |
| `classic_revolution` | 1003 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/classic_revolution/seed_1003/standard_results` |
| `landing_smooth_qd_manual_bd` | 1001 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1001/standard_results` |
| `landing_smooth_qd_manual_bd` | 1002 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1002/standard_results` |
| `landing_smooth_qd_manual_bd` | 1003 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/landing_smooth_qd_manual_bd/seed_1003/standard_results` |
| `random_descriptor_qd` | 1001 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/random_descriptor_qd/seed_1001/standard_results` |
| `random_descriptor_qd` | 1002 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/random_descriptor_qd/seed_1002/standard_results` |
| `random_descriptor_qd` | 1003 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/random_descriptor_qd/seed_1003/standard_results` |
| `synthesis_trajectory_nod` | 1001 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1001/standard_results` |
| `synthesis_trajectory_nod` | 1002 | `standard_results_complete` | 2/2 | `exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1002/standard_results` |
| `synthesis_trajectory_nod` | 1003 | `partial` | 1/2 | `exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1003/standard_results` |

## Next Pending Commands

- `synthesis_trajectory_nod` seed `1003` `VerilogEval-Spec-to-RTL`:

```bash
env PYTHONPATH=src /workspace/.venv/bin/python scripts/run_backend.py --backend revolution --benchmarks VerilogEval-Spec-to-RTL --problems Prob098_circuit7 Prob116_m2014_q3 Prob135_m2014_q6b Prob150_review2015_fsmonehot Prob151_review2015_fsm Prob153_gshare --api_backend vllm --vllm_host 20.0.0.103 --vllm_port 8000 --vllm_min_model_len 131072 --model_name openai/gpt-oss-120b --max_tokens 128000 --diff_max_tokens 128000 --population_size 20 --num_generations 5 --evaluation_mode search_accelerated --accelerated_synthesis_top_k 1 --total_worker_slots 13 --max_active_problems 13 --max_workers_per_problem 4 --rtl_simulation_timeout_s 60 --synthesis_timeout_s 300 --post_synthesis_simulation_timeout_s 300 --seed 1003 --save_path /workspace/.worktrees/journal-auto-bd-exp-20260618/exp/auto_bd_research/main_screening_screening_seed3/synthesis_trajectory_nod/seed_1003 --search_mode revolution_qd --qd_archive_type grid_quantile --qd_grid_quantile_warmup_successes 8 --qd_cell_mode pareto_front --qd_max_elites_per_cell 5 --qd_objectives ppa --qd_champion_lane_fraction 0.5 --qd_parent_selection nsga2_global_rank --qd_two_parent_probability 0.5 --qd_operator_kind eoh_strategies --representation_kind code_individual --qd_descriptor_profile stnod_trajectory_5d --qd_descriptor_file /workspace/.worktrees/journal-auto-bd-exp-20260618/docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_methods/03_synthesis_trajectory_nod/descriptor_profile.yaml
```
