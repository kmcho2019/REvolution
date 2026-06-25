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
