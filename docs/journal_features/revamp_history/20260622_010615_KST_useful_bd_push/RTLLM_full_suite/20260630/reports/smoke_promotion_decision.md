# Smoke Promotion Decision

Generated smoke package: `reports/smoke_report.md`

## Decision

Launch the full RTLLM stage with four methods:

- `classic_revolution_8x5`
- `pcn_v3_rf_stagnation_memory_8x5`
- `masterrtl_archive_activation_eoh_8x5`
- `deepgate_high_exploit_eoh_8x5`

This keeps the full run focused on the baseline, the best corrected
QD-memory method, the best RTL-native archive method, and the strongest
DeepGate-style netlist encoder representative.

## Smoke Evidence

The operator audit passed for every smoke arm:

- `single_thought_count = 0` for all methods.
- EoH strategies were used for all valid candidate rows.
- PCN used `pcn_classic_preserving_memory` with EoH operators.

Headline reference-complete smoke results:

| Method | Mean HV | HV Retention | Mean HV-AUC | Coverage |
| --- | ---: | ---: | ---: | ---: |
| `classic_revolution_8x5` | 0.3509 | 100.0% | 0.2242 | 3/3 |
| `pcn_v3_rf_stagnation_memory_8x5` | 0.3486 | 99.3% | 0.3173 | 3/3 |
| `masterrtl_archive_activation_eoh_8x5` | 0.3335 | 95.0% | 0.2458 | 3/3 |
| `deepgate_high_exploit_eoh_8x5` | 0.2326 | 66.3% | 0.1399 | 3/3 |

PCN is promoted because it nearly tied classic on final HV, improved
HV-AUC, improved valid-PPA count, improved reference-beating count, and
kept full smoke coverage. MasterRTL archive activation is promoted as a
hardware-native descriptor comparison because it retained 95.0% of
classic final HV and improved HV-AUC. DeepGate is promoted only as the
best surviving netlist-encoder representative; its smoke result is mixed
and not a headline-positive result.

## Not Promoted

`qwen_canonical_rtl_pca3_eoh_8x5` was not part of the first four-arm
full launch because its original smoke failed from CUDA out-of-memory
while descriptor extraction loaded `SentenceTransformer` inside workers.
The GPU-0 add-on rerun fixed that infrastructure issue by binding Qwen
to physical GPU 0 and lowering Qwen worker fanout. The corrected smoke
now covers 3/3 designs with the EoH operator contract passing. The
fresh rerun records mean HV 0.1859, HV-AUC 0.0966, and 53.0% HV
retention, so its mean HV is still far below classic. It is therefore
eligible as an add-on pretrained-encoder full run, not promoted as a
top-performing arm.

`masterrtl_rf_leafid_structural_eoh_8x5`,
`rf_deepgate_hybrid_eoh_8x5`, and `aurora_raw_impl_compact_eoh_8x5` are
not promoted because their final smoke HV was far below classic and PCN.
They remain useful diagnostic lanes, but the full RTLLM budget should go
to the best-performing representatives first.

## Figure Check

The generated smoke figures are readable and sufficient for the
promotion decision:

- `figures/smoke/mean_hv_by_method.png`
- `figures/smoke/mean_hv_auc_by_method.png`
- `figures/smoke/hv_win_loss_heatmap.png`
- `figures/smoke/valid_ppa_count_by_method.png`
- `figures/smoke/pareto_points_by_method.png`

The Phase 03.1 viewer export failed in the smoke package because the
viewer exporter expects staged PPA inputs under each viewer source root.
This does not invalidate the direct PPA/Pareto smoke metrics, but it
means the full package should treat the direct figures as the headline
visuals unless the viewer contract is repaired before final reporting.
