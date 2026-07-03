# PCN-v3 rtllm_full_5seed Report

## Comparison Summary

| Comparison | n | Mean HV Delta | CI95 | Wins/Losses/Ties | Wilcoxon p |
| --- | ---: | ---: | --- | --- | ---: |
| classic_no_cf_minus_classic | 230 | 0.0030 | [-0.0068, 0.0153] | 41/41/148 | 0.941036218638 |
| pcn_cf_restored_minus_classic | 230 | -0.0021 | [-0.0137, 0.0105] | 31/48/151 | 0.193606526326 |
| pcn_cf_restored_minus_pcn_no_cf | 230 | 0.0013 | [-0.0091, 0.0130] | 40/35/155 | 0.757383117453 |
| pcn_no_cf_minus_classic_no_cf | 230 | -0.0065 | [-0.0183, 0.0022] | 34/48/148 | 0.372258274841 |

## Interpretation Rule

Credit PCN memory only if the PCN arm improves over the matching operator-control baseline. A win over original classic alone is not sufficient when no-C-F classic also improves.

## Generated Figures

- `figures/<stage>/mean_hv_by_method_seed.png`
- `figures/<stage>/cf_count_by_method_seed.png`
- `figures/<stage>/delta_hv_boxplot.png`
- `figures/<stage>/delta_hv_auc_boxplot.png`
- `figures/<stage>/pcn_cf_restored_vs_classic_scatter.png`
