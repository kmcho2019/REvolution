# PCN-v3 RTLLM Full Five-Seed Detailed Report

## Bottom Line

The run is finished and packaged. The corrected PCN-v3 variants do not provide statistical evidence of improvement over classic REvolution on the reference-complete RTLLM paired comparison.

The strongest publication-safe conclusion is negative: PCN-v3 memory was implemented with the corrected EoH operator controls and its memory lane did fire, but it did not beat the matched no-C-F classic control or the original classic baseline under the 8x5 budget.

## Run Status

- Stage: `rtllm_full_5seed`.
- Seeds: `1001..1005`.
- Core methods: four.
- Method/seed runs: 20/20 complete.
- Headline paired rows: 230, from 46 reference-complete RTLLM designs across five seeds.
- Missing reference-PPA designs are excluded from headline normalized metrics.

## Claim Gate Summary

| gate | status | evidence | interpretation |
| --- | --- | --- | --- |
| operator_contract | pass | all full-stage method/seed operator audits passed | The run is not affected by single-thought regression or hidden C-F in no-CF arms. |
| memory_after_no_cf_control | fail | mean HV delta -0.0065; CI [-0.0183, 0.0022] | PCN no-C-F did not beat classic no-C-F. |
| clean_pcn_vs_classic | fail | mean HV delta -0.0021; CI [-0.0137, 0.0105] | C-F-restored PCN did not beat original classic. |
| allowed_claim | negative | both controlled PCN claim gates failed | Treat PCN-v3 as not validated under 8x5 full RTLLM. |

## Overall Method Summary

| method_label | mean_hv | mean_hv_auc | mean_covered_problem_count | mean_pareto_point_count | total_valid_ppa_candidates | total_c_f_count |
| --- | --- | --- | --- | --- | --- | --- |
| Classic | 0.103802076408 | 0.0867966890001 | 32.8 | 1.49565217391 | 4882 | 768 |
| Classic no C-F | 0.106845926182 | 0.0945920744667 | 33.2 | 1.69565217391 | 4978 | 0 |
| PCN no C-F | 0.100395865568 | 0.0870308605327 | 33 | 1.55217391304 | 4942 | 0 |
| PCN C-F restored | 0.101663689558 | 0.0804660453833 | 32 | 1.47391304348 | 4229 | 670 |

## Main Pairwise Comparisons

| Comparison | Mean HV Delta | 95% CI | Mean HV-AUC Delta | Wins/Losses/Ties | Wilcoxon p |
| --- | ---: | --- | ---: | --- | ---: |
| Classic no C-F - Classic | 0.0030 | [-0.0068, 0.0153] | 0.0078 | 41/41/148 | 0.941036218638 |
| PCN no C-F - Classic no C-F | -0.0065 | [-0.0183, 0.0022] | -0.0076 | 34/48/148 | 0.372258274841 |
| PCN C-F restored - Classic | -0.0021 | [-0.0137, 0.0105] | -0.0063 | 31/48/151 | 0.193606526326 |
| PCN C-F restored - PCN no C-F | 0.0013 | [-0.0091, 0.0130] | -0.0066 | 40/35/155 | 0.757383117453 |

## Interpretation

1. Removing `C-F` alone produced a small positive mean HV delta (+0.0030), but the confidence interval crosses zero and the win/loss count is exactly balanced at 41/41 with 148 ties.
2. PCN memory without `C-F` did not beat the matched no-C-F classic control. The mean HV delta is -0.0065 and the mean HV-AUC delta is -0.0076.
3. C-F-restored PCN did not beat original classic. The mean HV delta is -0.0021, and the HV-AUC delta is -0.0063.
4. Restoring `C-F` inside PCN slightly improves final HV relative to PCN no-C-F (+0.0013), but it still loses HV-AUC and does not create a positive claim.

## Operator And Validity Checks

The operator contract passed. `single_thought_operator` count is zero for every method and seed. The two no-C-F arms have zero `C-F` rows. The original classic and C-F-restored PCN arms both produced `C-F` rows, confirming the C-F restoration actually occurred.

The C-F-restored PCN arm generated fewer reference-complete valid-PPA candidate rows than classic: 4229 versus 4882 across five seeds. This lower valid-PPA yield is a likely contributor to its weaker HV-AUC and final HV.

## Memory-Lane Mechanism

| method | lane | events | global_inserts |
| --- | --- | --- | --- |
| PCN no C-F | classic | 3934 | 508 |
| PCN no C-F | memory_refine | 332 | 21 |
| PCN C-F restored | classic | 3240 | 464 |
| PCN C-F restored | memory_refine | 285 | 18 |

The memory lane was active, so the negative result is not caused by a completely inactive PCN memory. However, memory-refine events were a small minority of archive events and did not translate into a method-level HV advantage.

## Generated Tables

- `tables/rtllm_full_5seed_overall_method_summary.csv`
- `tables/rtllm_full_5seed_seed_delta_summary.csv`
- `tables/rtllm_full_5seed_problem_delta_summary.csv`
- `tables/rtllm_full_5seed_claim_gate_summary.csv`
- `tables/rtllm_full_5seed_memory_lane_summary.csv`

## Generated Figures

- `figures/rtllm_full_5seed/overall_mean_hv_errorbar.png`
- `figures/rtllm_full_5seed/overall_mean_hv_auc_errorbar.png`
- `figures/rtllm_full_5seed/coverage_by_method.png`
- `figures/rtllm_full_5seed/seed_delta_hv_lines.png`
- `figures/rtllm_full_5seed/problem_delta_heatmap.png`
- `figures/rtllm_full_5seed/memory_lane_events.png`

## Recommended Next Step

Do not run the elite-cell variants as an automatic continuation of PCN-v3 under the current claim. The core ablation did not validate PCN memory. If we continue, the better next test is a smaller diagnostic redesign focused on reducing valid-PPA yield loss and using memory only after stagnation or only on designs where classic evicts a near-front family.
