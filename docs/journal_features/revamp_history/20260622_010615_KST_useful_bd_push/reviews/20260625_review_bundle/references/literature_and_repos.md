# Literature And Repository References

This file maps external ideas to the attempted technique lanes. It is not a
complete bibliography.

## QD And MAP-Elites

| Reference | URL | Used For |
| --- | --- | --- |
| MAP-Elites | `https://arxiv.org/abs/1504.04909` | Archive cells indexed by behavior descriptors. |
| CVT-MAP-Elites | `https://arxiv.org/abs/1610.05729` | Higher-dimensional learned/netlist descriptor spaces. |
| Multi-Objective QD | `https://arxiv.org/pdf/2202.03057` | Pareto fronts inside niches and multi-objective archive metrics. |
| AutoQD | `https://arxiv.org/html/2506.05634v2` | Random-feature/MMD-style automatic descriptors over behavior distributions. |
| AURORA | `https://arxiv.org/abs/1905.11874` | Autoencoder-learned behavior descriptors. |
| VQ-Elites | `https://arxiv.org/html/2504.08057v1` | Discrete codebook behavior cells. |
| QD-score AUC | `https://btjanaka.net/static/qd-auc/qd-auc-paper.pdf` | Search-efficiency metrics, not only final archive quality. |

## Circuit And Netlist Representation

| Reference | URL | Used For |
| --- | --- | --- |
| DeepGate3 | `https://arxiv.org/abs/2407.11095` | Circuit embedding target for synthesized netlists/AIGs. |
| DeepGate4 | `https://arxiv.org/abs/2502.01681` | Sparse scalable circuit transformer idea. |
| DeepSeq | `https://arxiv.org/abs/2302.13608` | Sequential circuit representation. |
| DeepSeq2 | `https://arxiv.org/abs/2411.00530` | Disentangled sequential circuit embeddings. |
| NetTAG | `https://arxiv.org/html/2504.09260v1` | Text-attributed graph representation. |
| CircuitFusion | `https://arxiv.org/abs/2505.02168` | Multimodal hardware code, graph, and functionality representation. |
| MGVGA | `https://openreview.net/forum?id=US9k5TXVLZ` | Masked gate modeling and Verilog-AIG alignment. |
| DE-HNN | `https://arxiv.org/abs/2404.00477` | Directed hypergraph representation for netlists. |
| DeepCell | `https://arxiv.org/html/2502.06816v1` | Multiview post-mapping netlist learning. |
| MasterRTL | `https://github.com/hkust-zhiyao/MasterRTL` | Simple operator graph RTL representation and saved tree models. |
| RTL-Timer | `https://github.com/hkust-zhiyao/RTL-Timer` | RTL timing-risk/path morphology. |
| RTL-Timer paper | `https://arxiv.org/abs/2403.18453` | Fine-grained RTL timing estimation. |

## Internal Evidence Pointers

| Topic | Bundle Path |
| --- | --- |
| Current results matrix | `evidence/current_goal_docs/current_results_matrix.md` |
| Technique lanes | `evidence/current_goal_docs/technique_lanes.md` |
| Strategy recommendations | `evidence/current_goal_docs/research_strategy_recommendations.md` |
| Full RTLLM milestone report | `evidence/presentation/report.md` |
| Synthesis-response evidence | `evidence/techniques/T04_*`, `T19_*`, `T20_*`, `T24_*`, `T26_*` |
| Pretrained/text encoder evidence | `evidence/techniques/T33_*` |
| Netlist/graph encoder evidence | `evidence/techniques/T07_*`, `T11_*`, `T13_*`, `T14_*`, `T36_*`, `T58_*` |
| RTL-native evidence | `evidence/techniques/T72_*`, `T75_*`, `T76_*`, `T77_*`, `T79_*`, `T80_*` |
