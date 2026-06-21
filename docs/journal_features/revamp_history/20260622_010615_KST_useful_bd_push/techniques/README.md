# Technique Package Index

Each subdirectory is a method package for the useful-BD push. A package is
ready to run when `methodology.md` fixes the algorithm, commands, descriptor
inputs, leakage exclusions, archive mapping, and expected artifacts. A package
is complete only after `results_report.md`, `artifacts_manifest.md`,
`figures/`, and `tables/` contain measured evidence.

At least 10 current packages must be attempted with real results before the
push can sign off a broad negative map.

The packages intentionally include simple controls, deterministic netlist
descriptors, learned/projection descriptors, and archive-coupling variants:

- `simple_yosys_stat_bd`
- `motif_pathlet_bd`
- `synthesis_delta_stnod_bd`
- `autoqd_mmd_synthesis_bd`
- `vq_elites_codebook_bd`
- `qwen_projection_bd`
- `deepgate_family_bd`
- `sequential_deepseq_bd`
- `nettag_text_graph_bd`
- `circuitfusion_multimodal_bd`
- `mgvga_contrastive_bd`
- `lineage_repair_bd`
- `aurora_incremental_autoencoder_bd`
- `dehnn_hypergraph_bd`
- `masterrtl_sog_bd`
- `deepcell_multiview_bd`
- `mome_pareto_archive_bd`
- `adaptive_emitter_cvt_bd`

All methods must be scored with the same `T0` to `T3` tier definitions from
`../useful_bd_push_plan.md`. Near-classic behavior is a useful signal; the
former 10 percent threshold is only the `T3 strong_win` bar.

Completed packages must also satisfy `../visualization_reporting_policy.md`.
Figures should be manually inspected before a result is accepted.
