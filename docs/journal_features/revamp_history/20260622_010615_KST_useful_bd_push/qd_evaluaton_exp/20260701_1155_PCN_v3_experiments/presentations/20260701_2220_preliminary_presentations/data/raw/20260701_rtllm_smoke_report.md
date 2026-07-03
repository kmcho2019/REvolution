# PCN-v3 rtllm_smoke Report

## Comparison Summary

| Comparison | n | Mean HV Delta | CI95 | Wins/Losses/Ties | Wilcoxon p |
| --- | ---: | ---: | --- | --- | ---: |
| classic_no_cf_minus_classic | 3 | 0.0055 | [0.0000, 0.0165] | 2/0/1 | not_available |
| pcn_cf_restored_minus_classic | 3 | 0.1829 | [0.0000, 0.5388] | 3/0/0 | not_available |
| pcn_cf_restored_minus_pcn_no_cf | 3 | 0.1704 | [-0.0277, 0.5388] | 1/1/1 | not_available |
| pcn_no_cf_minus_classic_no_cf | 3 | 0.0070 | [0.0000, 0.0210] | 1/0/2 | not_available |

## Interpretation Rule

Credit PCN memory only if the PCN arm improves over the matching operator-control baseline. A win over original classic alone is not sufficient when no-C-F classic also improves.

## Generated Figures

- `figures/<stage>/mean_hv_by_method_seed.png`
- `figures/<stage>/cf_count_by_method_seed.png`
- `figures/<stage>/delta_hv_boxplot.png`
- `figures/<stage>/delta_hv_auc_boxplot.png`
- `figures/<stage>/pcn_cf_restored_vs_classic_scatter.png`
