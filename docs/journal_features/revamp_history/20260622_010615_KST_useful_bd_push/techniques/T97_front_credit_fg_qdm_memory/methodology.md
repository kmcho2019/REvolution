# T97 Methodology

T97 reuses the T85 `front_guarded_memory` scheduler and `sr_pca_3d`
descriptor. It changes only memory pressure and credit threshold:

| Parameter | T85 | T97 |
| --- | ---: | ---: |
| `qd_memory_classic_fraction` | `0.80` | `0.85` |
| `qd_memory_refine_fraction` | `0.15` | `0.10` |
| `qd_memory_rescue_fraction` | `0.05` | `0.05` |
| `qd_memory_min_cell_credit` | `0.20` | `0.50` |
| `qd_memory_front_gap_epsilon` | `0.03` | `0.03` |
| `qd_two_parent_probability` | `0.00` | `0.00` |

The stricter credit threshold makes passive valid-PPA insertion insufficient
for routine memory sampling. Cells containing global-front candidates remain
sampleable through the existing guard.

The smoke uses the same three RTLLM problems as T85:

- `Prob045_alu`
- `Prob041_traffic_light`
- `Prob015_multi_pipe_8bit`

Budget: `12x3`, seed `1001`, `openai/gpt-oss-120b`, strict ablation
evaluation.
