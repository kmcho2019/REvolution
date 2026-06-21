# Technique Package Index

Each numbered subdirectory is a method package for the useful-BD push. The
visible `T##_` prefix is the chronological tracking index. A package is ready
to run when `methodology.md` fixes the algorithm, commands, descriptor inputs,
leakage exclusions, archive mapping, and expected artifacts. A package is
complete only after `results_report.md`, `artifacts_manifest.md`, `figures/`,
and `tables/` contain measured evidence.

At least 10 current packages must be attempted with real results before the
push can sign off a broad negative map.

The canonical machine-readable index is `technique_registry.csv`.

| ID | Directory | Family | State |
| --- | --- | --- | --- |
| `T01` | `T01_simple_yosys_stat_bd` | Simple control | `T0 diagnostic` |
| `T02` | `T02_motif_pathlet_bd` | Deterministic netlist descriptor | `T0 diagnostic` |
| `T03` | `T03_synthesis_delta_stnod_bd` | Synthesis/netlist descriptor | `T0 diagnostic`, near-miss |
| `T04` | `T04_autoqd_mmd_synthesis_bd` | Automatic QD descriptor | `T1 near_classic`, validation candidate |
| `T05` | `T05_vq_elites_codebook_bd` | Codebook/archive descriptor | `T0 diagnostic` |
| `T06` | `T06_qwen_projection_bd` | Learned/projection descriptor | `T0 diagnostic` |
| `T07` | `T07_deepgate_family_bd` | Circuit encoder descriptor | Scaffolded |
| `T08` | `T08_sequential_deepseq_bd` | Sequential encoder descriptor | Scaffolded |
| `T09` | `T09_nettag_text_graph_bd` | Text-attributed graph descriptor | Scaffolded |
| `T10` | `T10_circuitfusion_multimodal_bd` | Multimodal descriptor | Scaffolded |
| `T11` | `T11_mgvga_contrastive_bd` | Contrastive graph descriptor | Scaffolded |
| `T12` | `T12_lineage_repair_bd` | Lineage/yield descriptor | Scaffolded |
| `T13` | `T13_aurora_incremental_autoencoder_bd` | Learned AURORA descriptor | Scaffolded |
| `T14` | `T14_dehnn_hypergraph_bd` | Hypergraph descriptor | Scaffolded |
| `T15` | `T15_masterrtl_sog_bd` | RTL operator-graph descriptor | Scaffolded |
| `T16` | `T16_deepcell_multiview_bd` | Multiview circuit descriptor | Scaffolded |
| `T17` | `T17_mome_pareto_archive_bd` | Archive-coupling/Pareto variant | `T0 diagnostic`, passive live-candidate |
| `T18` | `T18_adaptive_emitter_cvt_bd` | Archive-coupling/emitter variant | Scaffolded |
| `T19` | `T19_sr_relu_pca_bd` | Automatic QD descriptor | `T0 diagnostic`, high-priority HV lead |
| `T20` | `T20_sr_raw_pca_bd` | Automatic QD descriptor | `T0 diagnostic`, projection ablation near-miss |
| `T21` | `T21_stnod_motif_hybrid_bd` | Deterministic netlist descriptor | `T0 diagnostic`, archive-coverage ablation |
| `T22` | `T22_random_descriptor_control` | Negative control | `T0 control`, required comparator |
| `T23` | `T23_sr_pareto_validation_matrix` | Archive-coupling validation | `T0 diagnostic`, passive live-candidate matrix |
| `T24` | `T24_sr_pareto_live_validation` | Archive-coupling live validation | `T0 diagnostic`, complete six-arm live matrix |
| `T25` | `T25_guarded_sr_raw_pareto_qd` | Archive-coupling guarded live variant | `T0 diagnostic` |
| `T26` | `T26_sr_raw_conservative_exploit_qd` | Archive-coupling parent-source variant | `T0 diagnostic`, active lead |

All methods must be scored with the same `T0` to `T3` tier definitions from
`../useful_bd_push_plan.md`. Near-classic behavior is a useful signal; the
former 10 percent threshold is only the `T3 strong_win` bar.

Completed packages must also satisfy `../visualization_reporting_policy.md`.
Figures should be manually inspected before a result is accepted.
