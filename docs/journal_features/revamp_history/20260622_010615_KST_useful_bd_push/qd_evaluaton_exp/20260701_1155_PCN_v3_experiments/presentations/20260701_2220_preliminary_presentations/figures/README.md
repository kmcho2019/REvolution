# Figure Inventory

## Directories

| Path | Meaning |
| --- | --- |
| `copied/20260629/` | Exact copied figures from the 20260629 full-suite package. |
| `copied/20260630_full/` | Exact copied figures from the 20260630 full-stage package. |
| `copied/20260701_smoke/` | Exact copied figures from the PCN-v3 smoke package. |
| `generated/` | Presentation-style data plots regenerated from copied CSVs. |
| `concepts/` | Conceptual diagrams generated for the deck. |
| `imagegen_trials/` | Optional native imagegen concept alternatives and captions. |

## Regeneration

Run:

```bash
uv run python tools/build_presentation_assets.py
```

from this presentation directory, or run the same script from `/workspace`
using its full path.

## Presentation Figures

Important generated data plots:

- `generated/20260629_method_retention.png`
- `generated/20260629_descriptor_family_rank.png`
- `generated/20260629_coverage_vs_hv_retention.png`
- `generated/method_family_matrix.png`
- `generated/20260630_operator_audit.png`
- `generated/20260630_method_retention.png`
- `generated/20260630_corrected_method_comparison.png`
- `generated/20260630_pcn_win_loss.png`
- `generated/pcn_memory_mechanism.png`
- `generated/qwen_operator_correction.png`
- `generated/20260701_smoke_cf_audit.png`
- `generated/20260701_smoke_comparison.png`

Important conceptual diagrams:

- `concepts/scalar_fitness_vs_pareto.png`
- `concepts/hv_hv_auc_explainer.png`
- `concepts/classic_revolution_methodology_clean.png`
- `concepts/generic_qd_map_elites_methodology_clean.png`
- `concepts/pcn_v3_methodology_clean.png`
- `concepts/operator_mismatch_diagram.png`
- `concepts/cf_ablation_design.png`
- `concepts/pcn_architecture.png`
- `concepts/replacement_vs_memory.png`
- `concepts/recommended_algorithm_shape.png`
- `concepts/claim_gate_checklist.png`
- `concepts/discussion_question_map.png`

Optional imagegen trials:

- `imagegen_trials/images/replacement_vs_memory_imagegen.png`
- `imagegen_trials/images/pcn_architecture_imagegen.png`
- `imagegen_trials/images/scalar_vs_pareto_imagegen.png`
- `imagegen_trials/images/classic_revolution_methodology_imagegen.png`
- `imagegen_trials/images/generic_qd_map_elites_methodology_imagegen.png`
- `imagegen_trials/images/pcn_v3_methodology_imagegen.png`
- `imagegen_trials/images/classic_revolution_methodology_paper_imagegen.png`
- `imagegen_trials/images/generic_qd_map_elites_methodology_paper_imagegen.png`
- `imagegen_trials/images/pcn_v3_methodology_paper_imagegen.png`
