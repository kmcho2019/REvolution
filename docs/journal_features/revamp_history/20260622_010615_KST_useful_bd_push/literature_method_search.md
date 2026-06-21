# Literature Method Search

Search date: 2026-06-22 KST.

This file records the method families to try for useful RTL behavior
descriptors (BDs). The goal is not novelty theater. Novelty is useful only when
it gives a plausible path to better archive coverage, Pareto-front discovery,
or near-classic optimization quality.

## QD / MAP-Elites Sources

| source | useful idea | RTL adaptation |
| --- | --- | --- |
| MAP-Elites, `https://arxiv.org/abs/1504.04909` | Store the best elite per descriptor cell and illuminate quality across a behavior space. | Baseline archive mechanism for grid and CVT descriptors. |
| CVT-MAP-Elites, `https://arxiv.org/abs/1610.05729` | Use centroidal Voronoi cells to scale MAP-Elites to higher-dimensional descriptors. | Prefer CVT for 8-32D learned/netlist embeddings and compare with passive common archives. |
| Multi-Objective QD, `https://arxiv.org/pdf/2202.03057` | Keep Pareto fronts inside niches and use passive archives for fair comparison. | Add MOME-style per-cell fronts for PPA objectives and compute passive archive metrics for classic. |
| AutoQD, `https://arxiv.org/html/2506.05634v2` | Embed behavior distributions with random Fourier features approximating MMD, then project to BDs. | Treat synthesis-stage events, motif occupancy, and fixed simulation sketches as RTL "occupancy" distributions. |
| AURORA, `https://arxiv.org/abs/1905.11874` | Learn BDs with an autoencoder and update behavior space over time. | Train frozen and incremental autoencoders over non-PPA netlist/synthesis vectors; avoid fitting on final scores. |
| VQ-Elites, `https://arxiv.org/html/2504.08057v1` | Use vector quantization to build an unsupervised structured behavior grid. | Fit codebooks over implementation vectors or learned embeddings, then archive by codebook id and residual. |
| Continuous QD metrics, `https://www.research.autodesk.com/publications/a-discretization-free-metric-for-assessing-quality-diversity-algorithms/` | Evaluate behavior-target tradeoffs without depending on one grid resolution. | Add CQD/objective-distance hypervolume on a passive descriptor archive. |
| QD score AUC, `https://btjanaka.net/static/qd-auc/qd-auc-paper.pdf` | Measure search efficiency, not only final archive quality. | Report QD-score AUC, coverage AUC, and hypervolume AUC versus valid-PPA evaluations. |
| MEMES, `https://arxiv.org/html/2303.06137v2` | Combine explore and exploit emitters and report coverage, max fitness, and QD-score. | Try CVT archive with separate classic-exploit and novelty-explore emitters for live sampling. |

## Netlist / Circuit Representation Sources

| source | useful idea | RTL adaptation |
| --- | --- | --- |
| DeepGate3, `https://arxiv.org/abs/2407.11095` | Scalable circuit embeddings with GNN plus transformer pooling over subcircuits. | Convert candidates to AIGs, split cones, and test frozen/surrogate graph embeddings with collapse checks. |
| DeepGate4, `https://arxiv.org/abs/2502.01681` | Sparse graph transformer for larger AIGs with scalability improvements. | Prefer sparse/cone embeddings when full DeepGate3 collapses or cannot scale. |
| DeepSeq, `https://arxiv.org/abs/2302.13608` | Sequential circuit representation instead of combinational-only encoders. | Extract FF/latch boundaries, state graphs, and fixed-stimulus sketches. |
| DeepSeq2, `https://arxiv.org/abs/2411.00530` | Disentangled structure/function/sequential embeddings with better scalability. | Use separate static, functional-sketch, and sequential-state descriptor blocks. |
| NetTAG, `https://arxiv.org/html/2504.09260v1` | Text-attributed graph representation that fuses gate semantics and graph structure. | Attach symbolic expression summaries to mapped graph nodes and pool text-graph embeddings. |
| CircuitFusion, `https://arxiv.org/abs/2505.02168` | Multimodal hardware code, graph, and functionality representation. | Fuse RTL text, graph/motif descriptors, and non-reward functional sketches. |
| MGVGA, `https://openreview.net/forum?id=US9k5TXVLZ` | Masked gate modeling and Verilog-AIG alignment. | Train source-graph contrastive descriptors over replay candidates or approximate with aligned projections. |
| DE-HNN, `https://arxiv.org/abs/2404.00477` | Directed hypergraph netlist representation for long-range netlist interactions. | Encode gates/nets as directed hyperedges and use hypergraph summary or a small HNN surrogate. |
| DeepCell, `https://arxiv.org/html/2502.06816v1` | Multiview post-mapping netlist learning with masked circuit modeling. | Use standard-cell/post-mapping view plus AIG view; if full training is too costly, use multiview feature fusion. |
| MasterRTL, `https://github.com/hkust-zhiyao/MasterRTL` | Simple operator graph (SOG) as bit-level RTL representation closer to gate netlists. | Build bit-level operator graph descriptors before full synthesis and compare to Yosys/motif descriptors. |

## Method Priority

Priority is based on chance of working, novelty, dependency risk, and fit with
the paper story.

| tier | methods | reason |
| --- | --- | --- |
| P0 controls | `T01_simple_yosys_stat_bd`, `T02_motif_pathlet_bd`, `T03_synthesis_delta_stnod_bd` | Cheap, deterministic, interpretable, and needed to avoid over-crediting learned models. |
| P1 practical QD | `T05_vq_elites_codebook_bd`, `T04_autoqd_mmd_synthesis_bd`, `T17_mome_pareto_archive_bd`, `T18_adaptive_emitter_cvt_bd` | Directly targets QD archive quality, Pareto-front spread, and broader illumination. |
| P2 representation lift | `T15_masterrtl_sog_bd`, `T14_dehnn_hypergraph_bd`, `T16_deepcell_multiview_bd`, `T09_nettag_text_graph_bd`, `T10_circuitfusion_multimodal_bd` | More reviewer-interesting if they produce useful BDs or explain why structural controls are enough. |
| P3 expensive encoders | `T06_qwen_projection_bd`, `T07_deepgate_family_bd`, `T08_sequential_deepseq_bd`, `T11_mgvga_contrastive_bd`, `T13_aurora_incremental_autoencoder_bd` | Worth trying after cheap/replay diagnostics, but must pass collapse and leakage checks. |

## Hybrid Ideas To Generate During The Goal

- CVT over concatenated ST-NOD, motif, and SOG descriptors.
- VQ codebook trained on structural vectors, then MOME-style Pareto fronts per
  code instead of one elite per cell.
- AURORA-style autoencoder initialized from deterministic vectors and refreshed
  only at fixed checkpoints, with a frozen holdout to prevent moving-goalpost
  behavior.
- AutoQD random Fourier features over fixed simulation-toggle distributions
  and synthesis-stage occupancy distributions.
- DeepGate or DE-HNN cone embeddings fused with lineage repair features.
- Text-attributed graph descriptors with Qwen summaries only at node or module
  level, not raw whole-file embeddings.
- Adaptive emitters: one exploit emitter reproduces classic search pressure,
  one explore emitter targets low-occupancy cells, and one repair emitter
  targets invalid-to-valid transitions.
- Passive-archive retrospective scoring of every classic run so classic is not
  penalized for lacking an explicit QD archive during search.

Every new hybrid that is actually attempted must get a numbered
`techniques/T##_slug/` package before results are interpreted.
