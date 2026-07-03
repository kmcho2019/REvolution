# Evidence Map

## Claim-To-Artifact Map

| Claim | Evidence | Notes |
| --- | --- | --- |
| 20260629 straightforward QD failed against classic. | `data/raw/20260629_full_suite_method_summary.csv`, `data/raw/20260629_report.md` | Classic mean HV `0.1002`; best QD mean HV `0.0735`. |
| Best 20260629 QD retained only 73.4% of classic mean HV. | `data/derived/20260629_selected_methods.csv` | `rf_deepgate_hybrid_delayed_8x5` is the best QD by mean HV. |
| 20260629 QD methods lost valid-PPA coverage. | `data/raw/20260629_full_suite_method_summary.csv` | Classic covered `33/46`; QD arms covered `27-31/46`. |
| 20260629 was confounded by QD operator changes. | `data/raw/20260629_method_configs.md` | Standard QD arms used `--qd_operator_kind single_thought_operator`. |
| 20260630 restored EoH and removed single-thought use. | `data/raw/20260630_operator_contract.csv` | Completed methods have `single_thought_count=0`. |
| 20260630 PCN-v3 beat classic in one seed. | `data/raw/20260630_full_suite_method_summary.csv`, `data/raw/20260630_full_report.md` | PCN mean HV `0.1031`; classic `0.0997`; retention `103.4%`. |
| 20260630 PCN-v3 is not a clean memory-only causal claim. | `appendix_methods.md`, `data/raw/20260630_method_configs.md` | The run was EoH-corrected but still no-C-F; 20260701 isolates that confound. |
| 20260630 descriptor/archive-only arms did not beat classic. | `data/derived/20260630_selected_methods.csv` | DeepGate, MasterRTL archive, and Qwen trail classic. |
| PCN memory lane actually fired. | `data/raw/20260630_pcn_memory_mechanism_summary.csv`, `data/raw/20260630_pcn_memory_mechanism.md` | 86 memory-refine candidates, 62 valid-PPA, 9 local-front adds, 5 global-front adds. |
| The PCN signal is not final proof. | `data/raw/20260630_full_report.md` | One seed; 9 wins, 9 losses, 28 ties versus classic. |
| 20260701 smoke validates the operator audit for C-F controls. | `data/raw/20260701_rtllm_smoke_operator_contract.csv` | Classic and PCN-C-F-restored have nonzero C-F; no-C-F arms have zero. |
| 20260701 smoke is promising but not decisive. | `data/raw/20260701_rtllm_smoke_comparison_summary.csv`, `data/raw/20260701_rtllm_smoke_report.md` | Only three smoke problems; Wilcoxon unavailable. |

## Figure Sources

| Figure | Source data |
| --- | --- |
| `figures/generated/20260629_method_retention.png` | `20260629_full_suite_method_summary.csv` |
| `figures/generated/20260629_descriptor_family_rank.png` | `20260629_full_suite_method_summary.csv` |
| `figures/generated/20260629_coverage_vs_hv_retention.png` | `20260629_full_suite_method_summary.csv` |
| `figures/generated/20260630_method_retention.png` | `20260630_full_suite_method_summary.csv` |
| `figures/generated/20260630_pcn_win_loss.png` | `20260630_full_suite_method_summary.csv` |
| `figures/generated/pcn_memory_mechanism.png` | `20260630_pcn_memory_mechanism_summary.csv` |
| `figures/generated/20260701_smoke_cf_audit.png` | `20260701_rtllm_smoke_operator_contract.csv` |
| `figures/generated/20260701_smoke_comparison.png` | `20260701_rtllm_smoke_comparison_summary.csv` |

## Claim Limits

- 20260629 does not prove diversity is useless; it shows the tested QD arms and
  operator setup were not competitive.
- 20260630 does not prove PCN is statistically better; it is one seed.
- 20260701 smoke does not settle the C-F confound; it validates the ablation
  machinery and motivates the ongoing five-seed run.
- Headline RTLLM metrics use the 46 reference-complete designs only.
