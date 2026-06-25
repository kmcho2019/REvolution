# Preliminary Check Log

## 2026-06-25

### Storage

`df -h /workspace /tmp` showed `/workspace` at about `89%` used with about
`3.0T` available. This is tight enough to keep new run artifacts under
`exp/useful_bd_push/` and avoid copying old archives.

### vLLM Preflight

Checked `http://20.0.0.103:8000/v1/models`.

Result:

- model: `openai/gpt-oss-120b`
- `max_model_len`: `131072`
- status: usable for the planned `128000` token settings

Raw preflight files:

- `tables/preflight_models_20260625_133622_UTC.json`
- `tables/preflight_models_20260625_133622_UTC.txt`
- `tables/preflight_timestamp.txt`

### Matrix Generation

Command:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tools/build_screening_matrix.py
```

Outputs:

- `tables/candidate_shortlist.csv`
- `tables/screening_matrix.csv`
- `tables/prelim_screen_subset.yaml`
- `tables/prelim_screen_subset.csv`
- `tables/matrix_summary.json`
- `commands/screening_matrix_v0.md`

### Descriptor Probe

Runtime descriptor dependencies were probed for:

- `source_aligned_masterrtl_structural_mix_3d`
- `source_aligned_shape_density_3d`
- `sr_pca_3d`
- `t11_runtime_pca4_graph`

Summary output:

- `tables/descriptor_probe_summary.csv`

The immediate live screen uses only profiles with working runtime support and
clear command-line semantics.

### Encoder Legitimacy Table

Created `tables/encoder_legitimacy_checks.csv` to distinguish actual
pretrained encoders from encoder-like or raw structural lanes.

Important outcome:

- Qwen3 canonical RTL is the best actual pretrained replay signal, but needs a
  live runtime hook.
- DeepGate3 has real checkpoints but prior embeddings were near-constant.
- T36/T11 is the strongest replay encoder-like lane, but exact T58 live
  conversion failed.
- MasterRTL structural mix is spend-ready as a raw RTL-native descriptor, not
  as a pretrained-head lane.

### Matrix Validation

Command:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tools/validate_screening_matrix.py
```

Result:

- status: pass
- output: `tables/screening_matrix_validation.json`

### Tiny Live Smoke

Ran a one-problem `1x0` live smoke on `RTLLM/Prob045_alu` for the baseline and
the two spend-ready QD arms.

Artifact root:

```text
/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134317_UTC/smoke
```

Summary:

| Arm | Candidates | Valid-PPA | Result |
| --- | --- | --- | --- |
| `classic_revolution_1x0` | 1 | 0 | Launch passed; sample failed functionality. |
| `code_thought_sr_front_slot_1x0` | 1 | 0 | Launch passed; archive files emitted; sample failed functionality. |
| `masterrtl_structural_mix_1x0` | 1 | 1 | Launch passed; archive files emitted; one global Pareto member. |

Table output:

- `tables/live_smoke_summary.csv`
- `tables/live_smoke_root.txt`

### Full Preliminary Screen

Ran the registered eight-design `8x5` screen for:

- `classic_revolution_8x5`
- `code_thought_sr_front_slot_8x5`
- `masterrtl_structural_mix_8x5`

Artifact root:

```text
/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live
```

All three arms completed with `8/8` successful problem-summary rows. Valid-PPA
file counts were:

- classic: `191`
- SR front-slot QD: `168`
- MasterRTL structural-mix QD: `181`

Formal analysis command:

```bash
uv run python scripts/report_final_analysis_bundle.py \
  --backend_run classic_revolution_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/classic_revolution_8x5/seed_1001 \
  --backend_run code_thought_sr_front_slot_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/code_thought_sr_front_slot_8x5/seed_1001 \
  --backend_run masterrtl_structural_mix_8x5=exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/masterrtl_structural_mix_8x5/seed_1001 \
  --subset-config docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tables/prelim_screen_subset.yaml \
  --output-dir exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/final_analysis
```

Result:

- formal bundle completed with no skipped sections;
- overall/Pareto recommendation: `classic_revolution_8x5`;
- score/archive-QD recommendation: `masterrtl_structural_mix_8x5`;
- package report: `../live_screen_results.md`.

Figure inspection:

- `figures/live_screen_mean_hv.png`: readable; clearly shows classic ahead.
- `figures/live_screen_hv_delta_by_problem.png`: readable; shows QD deltas are
  mostly negative with only a tiny positive on `Prob024_fsm`.

### Qwen Matched Screen

Ran the Qwen canonical-RTL pretrained encoder arm on the same eight-design
`8x5` subset.

Command profile:

- env: `exp/diversity_check/encoder_envs/qwen3_probe/bin/python`
- vLLM preflight raw output:
  `tables/preflight_models_20260625_qwen_screen.txt`
- descriptor profile:
  `preliminary_planning/20260625_qwen_live_screen_probe/qwen_descriptor_profile.yaml`
- backend: `revolution_qd`
- budget: `population_size=8`, `num_generations=5`
- concurrency: `total_worker_slots=8`, `max_active_problems=4`,
  `max_workers_per_problem=2`

Artifact root:

```text
/workspace/exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/qwen_canonical_rtl_pca3_8x5/seed_1001
```

Outcome:

- completed `8/8` problem-summary success rows;
- produced `192` valid-PPA files;
- preserved coverage on `Prob153_gshare`, the hardest screen case;
- emitted descriptor-health files for all eight problems, summarized in
  `tables/live_screen_qwen_descriptor_health.csv`;
- mean HV `0.1108` versus classic `0.1406`;
- mean Pareto points `1.62` versus classic `3.25`;
- positive HV delta versus classic on `Prob024_fsm` and `Prob153_gshare`;
- not promoted as-is because aggregate HV and front breadth remain worse.
- full final-analysis bundle completed with no skipped sections. Its generic
  score-style `overall` recommendation is Qwen, but its `pareto_overall`
  recommendation is classic; the promotion decision follows the Pareto/HV
  gate.

Regenerated the package from:

```bash
uv run python docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tools/package_live_screen_results.py \
  exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live/final_analysis_with_qwen \
  exp/useful_bd_push/prelim_encoder_config_screen_20260625_134902_UTC/live
```

Figure inspection:

- `figures/live_screen_mean_hv.png`: readable with value labels.
- `figures/live_screen_hv_delta_by_problem.png`: regenerated as an annotated
  heatmap so small deltas and the large Qwen `Prob041_traffic_light` loss are
  visible.

### Local Checks

Commands:

```bash
uv run ruff check docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tools
uv tool run ty check docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tools
uv run pyright docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/preliminary_planning/20260625_encoder_config_screening/tools
git diff --check
```

Results:

- `ruff`: pass
- `ty`: pass
- `pyright`: pass through `uv run pyright`
- `python -m pyright`: unavailable in the base Python environment
- `git diff --check`: pass
