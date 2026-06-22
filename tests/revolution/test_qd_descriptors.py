import math
from pathlib import Path

import pytest

from revolution.qd.descriptors import (
    descriptor_requirements,
    extract_descriptor_values,
    load_grid_axis_specs,
    load_descriptor_profiles,
    load_sr_pca_artifact_path,
    load_sr_vq_artifact_path,
    resolve_descriptor_axes,
    resolve_grid_axis_specs,
)

RANDOM_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/00_random_descriptor/descriptor_profile.yaml"
)
YOSYS_STAT_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/01_yosys_stat_bd/descriptor_profile.yaml"
)
MOTIF_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/02_netlist_motif_occupancy/descriptor_profile.yaml"
)
STNOD_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/03_synthesis_trajectory_nod/descriptor_profile.yaml"
)
SR_PCA_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml"
)
SR_RFF_PCA_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile_rff.yaml"
)
SR_VQ_DESCRIPTOR_FILE = (
    "docs/journal_features/revamp_history/"
    "20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/07_vq_implementation_codebook/descriptor_profile.yaml"
)


def test_load_descriptor_profiles_includes_hybrid_defaults():
    profiles = load_descriptor_profiles()
    assert "hybrid_seq_default" in profiles
    assert "rtl_core" in profiles
    assert "implemented_structural_fixed_5d" in profiles
    assert "implemented_structural_compact_3d" in profiles
    assert "size_control_3d" in profiles
    assert "timing_control_3d" in profiles
    assert profiles["journal_logic_ff_width_3d"] == [
        "logic_depth",
        "ff_depth",
        "comb_width_log",
    ]


def test_load_descriptor_profiles_includes_retrospective_structural_profiles():
    profiles = load_descriptor_profiles()
    assert profiles["implemented_structural_fixed_5d"] == [
        "seq_ratio",
        "comb_ratio",
        "mux_ratio",
        "adder_ratio",
        "cell_count_log",
    ]
    assert profiles["implemented_structural_compact_3d"] == [
        "comb_ratio",
        "adder_ratio",
        "cell_count_log",
    ]


def test_load_descriptor_profiles_includes_runtime_retro_profiles():
    profiles = load_descriptor_profiles()
    assert profiles["size_control_3d"] == [
        "wire_count_log_est",
        "assign_count",
        "ctrl_depth_est",
    ]
    assert profiles["timing_control_3d"] == [
        "wire_count_log_est",
        "if_count",
        "ast_depth_est",
    ]
    assert profiles["wire_ctrl_assign_3d"] == [
        "wire_count_log_est",
        "ctrl_depth_est",
        "assign_count",
    ]
    assert profiles["wire_if_math_3d"] == [
        "wire_count_log_est",
        "if_count",
        "math_op_ast_count",
    ]
    assert profiles["wire_always_ternary_3d"] == [
        "wire_count_log_est",
        "always_count",
        "ternary_count",
    ]
    assert profiles["assign_always_math_3d"] == [
        "assign_count",
        "always_count",
        "math_op_ast_count",
    ]
    assert profiles["activity_size_3d"] == [
        "toggle_count_log_est",
        "active_signal_ratio_est",
        "wire_count_log_est",
    ]
    assert profiles["activity_control_3d"] == [
        "toggle_density_est",
        "active_signal_ratio_est",
        "ctrl_depth_est",
    ]
    assert profiles["theory_grounded_full_20d"] == [
        "rtl_cyclomatic_total_log",
        "rtl_cyclomatic_max_log",
        "rent_exponent_confidence_gated",
        "reconv_source_ratio",
        "reconv_sink_ratio",
        "scoap_cc0_bin_0_pct",
        "scoap_cc0_bin_1_pct",
        "scoap_cc0_bin_2_pct",
        "scoap_cc0_bin_3_pct",
        "scoap_cc1_bin_0_pct",
        "scoap_cc1_bin_1_pct",
        "scoap_cc1_bin_2_pct",
        "scoap_cc1_bin_3_pct",
        "scoap_co_bin_0_pct",
        "scoap_co_bin_1_pct",
        "scoap_co_bin_2_pct",
        "scoap_co_bin_3_pct",
        "laplacian_lambda2",
        "laplacian_spectral_entropy",
        "scoap_signal_smoothness",
    ]
    assert profiles["theory_grounded_compact_8d"] == [
        "scoap_signal_smoothness",
        "laplacian_spectral_entropy",
        "scoap_cc0_bin_1_pct",
        "scoap_co_bin_3_pct",
        "scoap_cc1_bin_1_pct",
        "scoap_co_bin_0_pct",
        "scoap_cc0_bin_0_pct",
        "scoap_cc1_bin_0_pct",
    ]
    assert profiles["t11_runtime_top4_graph"] == [
        "hyper_mean_fanout",
        "edge_per_node",
        "log_edge_count",
        "hyper_directed_edge_count",
    ]
    assert profiles["t11_runtime_top8_graph"] == [
        *profiles["t11_runtime_top4_graph"],
        "hyper_fanout_entropy",
        "hyper_driven_net_count",
        "hyper_sink_net_count",
        "log_net_count",
    ]
    assert profiles["t11_runtime_top16_graph"] == [
        *profiles["t11_runtime_top8_graph"],
        "hyper_net_count",
        "hyper_cell_count",
        "log_node_count",
        "hyper_max_fanout",
        "hyper_max_level",
        "log_max_level",
        "hyper_max_level_delta",
        "share_family_inv",
    ]


def test_t11_runtime_profile_requires_graph_metrics():
    requirements = descriptor_requirements(
        [
            "hyper_mean_fanout",
            "edge_per_node",
            "log_edge_count",
            "share_family_inv",
        ]
    )
    assert requirements["requires_graph_metrics"] is True
    assert requirements["requires_ppa"] is False


def test_load_descriptor_profiles_includes_hard_iteration_large_profile():
    profiles = load_descriptor_profiles("data/configs/qd_descriptor_profiles_hard_iteration_large.yaml")
    assert profiles["hard_iteration_large_struct10d"] == [
        "sequential_cells",
        "mux_ratio",
        "mux_cells",
        "adder_ratio",
        "seq_ratio",
        "arithmetic_cells",
        "total_cells",
        "g_P",
        "g_A",
        "g_T",
    ]


def test_resolve_descriptor_axes_prefers_explicit_axes():
    axes = resolve_descriptor_axes(
        profile_name="rtl_core",
        explicit_axes=["seq_ratio", "g_A"],
        descriptor_file=None,
        archive_type="grid",
        circuit_type="sequential",
    )
    assert axes == ["seq_ratio", "g_A"]


def test_resolve_descriptor_axes_uses_grid_defaults_for_comb_logic():
    axes = resolve_descriptor_axes(
        profile_name=None,
        explicit_axes=None,
        descriptor_file=None,
        archive_type="grid",
        circuit_type="combinational",
    )
    assert axes == ["g_A", "g_P"]


def test_resolve_descriptor_axes_uses_grid_defaults_for_sequential_logic():
    axes = resolve_descriptor_axes(
        profile_name=None,
        explicit_axes=None,
        descriptor_file=None,
        archive_type="grid",
        circuit_type="sequential",
    )
    assert axes == ["g_A", "g_P", "g_T"]


def test_resolve_descriptor_axes_drops_g_t_for_named_comb_profile(tmp_path: Path):
    cfg = tmp_path / "profiles.yaml"
    cfg.write_text(
        "profiles:\n"
        "  large_profile:\n"
        "    - wire_count_log_est\n"
        "    - g_P\n"
        "    - g_A\n"
        "    - g_T\n",
        encoding="utf-8",
    )
    axes = resolve_descriptor_axes(
        profile_name="large_profile",
        explicit_axes=None,
        descriptor_file=cfg,
        archive_type="cvt",
        circuit_type="combinational",
    )
    assert axes == ["wire_count_log_est", "g_P", "g_A"]


def test_resolve_descriptor_axes_drops_g_t_for_hard_iteration_large_profile():
    axes = resolve_descriptor_axes(
        profile_name="hard_iteration_large_struct10d",
        explicit_axes=None,
        descriptor_file="data/configs/qd_descriptor_profiles_hard_iteration_large.yaml",
        archive_type="grid",
        circuit_type="combinational",
    )
    assert axes == [
        "sequential_cells",
        "mux_ratio",
        "mux_cells",
        "adder_ratio",
        "seq_ratio",
        "arithmetic_cells",
        "total_cells",
        "g_P",
        "g_A",
    ]


def test_resolve_descriptor_axes_uses_journal_profile_for_comb_and_seq():
    for circuit_type in ("combinational", "sequential"):
        axes = resolve_descriptor_axes(
            profile_name="journal_logic_ff_width_3d",
            explicit_axes=None,
            descriptor_file=None,
            archive_type="cvt",
            circuit_type=circuit_type,
        )
        assert axes == ["logic_depth", "ff_depth", "comb_width_log"]


def test_random_hash_profile_requires_auto_bd_hash_metrics():
    axes = resolve_descriptor_axes(
        profile_name="random_hash_3d",
        explicit_axes=None,
        descriptor_file=RANDOM_DESCRIPTOR_FILE,
        archive_type="grid_quantile",
        circuit_type="sequential",
    )
    requirements = descriptor_requirements(axes)

    assert axes == ["random_hash_0", "random_hash_1", "random_hash_2"]
    assert requirements["requires_synthesis"] is True
    assert requirements["requires_auto_bd_hash"] is True


def test_yosys_stat_profile_uses_synthesis_metrics_only():
    axes = resolve_descriptor_axes(
        profile_name="yosys_stat_compact_3d",
        explicit_axes=None,
        descriptor_file=YOSYS_STAT_DESCRIPTOR_FILE,
        archive_type="grid_quantile",
        circuit_type="sequential",
    )
    requirements = descriptor_requirements(axes)

    assert axes == ["cell_count_log", "seq_ratio", "mux_ratio"]
    assert requirements["requires_synthesis"] is True
    assert requirements["requires_ppa"] is False
    assert requirements["requires_graph_metrics"] is False
    assert requirements["requires_auto_bd_hash"] is False


def test_motif_profile_uses_auto_bd_motif_metrics():
    axes = resolve_descriptor_axes(
        profile_name="netlist_motif_occupancy_4d",
        explicit_axes=None,
        descriptor_file=MOTIF_DESCRIPTOR_FILE,
        archive_type="grid_quantile",
        circuit_type="sequential",
    )
    requirements = descriptor_requirements(axes)

    assert axes == [
        "motif_logic_ratio",
        "motif_control_ratio",
        "motif_arith_ratio",
        "motif_diversity",
    ]
    assert requirements["requires_synthesis"] is True
    assert requirements["requires_auto_bd_motif"] is True
    assert requirements["requires_auto_bd_hash"] is False


def test_stnod_profile_uses_stage_dump_metrics(tmp_path: Path):
    descriptor_file = tmp_path / "profiles.yaml"
    descriptor_file.write_text(
        "profiles:\n"
        "  stnod_trajectory_5d:\n"
        "    - stnod_cell_growth_log\n"
        "    - stnod_logic_swing\n"
        "    - stnod_control_swing\n"
        "    - stnod_arith_swing\n"
        "    - stnod_diversity_swing\n",
        encoding="utf-8",
    )
    axes = resolve_descriptor_axes(
        profile_name="stnod_trajectory_5d",
        explicit_axes=None,
        descriptor_file=descriptor_file,
        archive_type="grid_quantile",
        circuit_type="sequential",
    )
    requirements = descriptor_requirements(axes)

    assert axes == [
        "stnod_cell_growth_log",
        "stnod_logic_swing",
        "stnod_control_swing",
        "stnod_arith_swing",
        "stnod_diversity_swing",
    ]
    assert requirements["requires_synthesis"] is True
    assert requirements["requires_auto_bd_stage_dumps"] is True
    assert requirements["requires_auto_bd_motif"] is False


def test_stnod_motif_trajectory_profile_uses_motif_and_stage_metrics():
    axes = resolve_descriptor_axes(
        profile_name="stnod_motif_trajectory_9d",
        explicit_axes=None,
        descriptor_file=STNOD_DESCRIPTOR_FILE,
        archive_type="grid_quantile",
        circuit_type="sequential",
    )
    requirements = descriptor_requirements(axes)

    assert axes == [
        "motif_logic_ratio",
        "motif_control_ratio",
        "motif_arith_ratio",
        "motif_diversity",
        "stnod_cell_growth_log",
        "stnod_logic_swing",
        "stnod_control_swing",
        "stnod_arith_swing",
        "stnod_diversity_swing",
    ]
    assert requirements["requires_synthesis"] is True
    assert requirements["requires_auto_bd_motif"] is True
    assert requirements["requires_auto_bd_stage_dumps"] is True


def test_resolve_descriptor_axes_rejects_unknown_profile():
    with pytest.raises(KeyError, match="Unknown descriptor profile"):
        resolve_descriptor_axes(
            profile_name="missing_profile",
            explicit_axes=None,
            descriptor_file=None,
            archive_type="cvt",
            circuit_type="sequential",
        )


def test_extract_descriptor_values_applies_log1p_transform():
    values = extract_descriptor_values(
        {"cell_count_log": 99.0, "g_A": 0.2},
        ["cell_count_log", "g_A"],
    )
    assert values["cell_count_log"] > 0.0
    assert values["g_A"] == pytest.approx(0.2)


def test_extract_descriptor_values_requires_metrics():
    with pytest.raises(KeyError, match="Missing required descriptor metric"):
        extract_descriptor_values({"logic_depth": 2.0}, ["logic_depth", "ff_depth"])


def test_extract_descriptor_values_accepts_journal_axis_values():
    values = extract_descriptor_values(
        {
            "logic_depth": 3.0,
            "ff_depth": 2.0,
            "comb_width_log": math.log1p(7.0),
        },
        ["logic_depth", "ff_depth", "comb_width_log"],
    )
    assert values == {
        "logic_depth": pytest.approx(3.0),
        "ff_depth": pytest.approx(2.0),
        "comb_width_log": pytest.approx(math.log1p(7.0)),
    }


def test_extract_descriptor_values_accepts_hard_iteration_structural_counts():
    values = extract_descriptor_values(
        {
            "sequential_cells": 12.0,
            "mux_cells": 3.0,
            "arithmetic_cells": 5.0,
            "total_cells": 24.0,
        },
        ["sequential_cells", "mux_cells", "arithmetic_cells", "total_cells"],
    )
    assert values == {
        "sequential_cells": pytest.approx(12.0),
        "mux_cells": pytest.approx(3.0),
        "arithmetic_cells": pytest.approx(5.0),
        "total_cells": pytest.approx(24.0),
    }


def test_descriptor_requirements_detect_ppa_and_synthesis_needs():
    reqs = descriptor_requirements(["seq_ratio", "g_A"])
    assert reqs["requires_synthesis"] is True
    assert reqs["requires_ppa"] is True
    assert reqs["requires_rtl_metrics"] is False


def test_descriptor_requirements_detect_rtl_metric_axes():
    reqs = descriptor_requirements(["wire_count_log_est", "assign_count", "ctrl_depth_est"])
    assert reqs["requires_rtl_metrics"] is True


def test_descriptor_requirements_detect_dynamic_metric_axes():
    reqs = descriptor_requirements(["toggle_count_log_est", "active_signal_ratio_est"])
    assert reqs["requires_dynamic_metrics"] is True


def test_descriptor_requirements_detect_graph_metric_axes():
    reqs = descriptor_requirements(
        ["rent_exponent_confidence_gated", "reconv_source_ratio", "laplacian_lambda2"]
    )
    assert reqs["requires_graph_metrics"] is True
    assert reqs["requires_rtl_metrics"] is False


def test_descriptor_requirements_detect_journal_profile_needs_graph_and_synthesis():
    reqs = descriptor_requirements(["logic_depth", "ff_depth", "comb_width_log"])
    assert reqs["requires_graph_metrics"] is True
    assert reqs["requires_synthesis"] is True
    assert reqs["requires_ppa"] is False


def test_sr_pca_profile_resolves_artifact_and_requirements():
    axes = resolve_descriptor_axes(
        profile_name="sr_pca_3d",
        explicit_axes=None,
        descriptor_file=SR_PCA_DESCRIPTOR_FILE,
        archive_type="grid",
        circuit_type="sequential",
    )
    requirements = descriptor_requirements(axes)
    artifact_path = load_sr_pca_artifact_path(SR_PCA_DESCRIPTOR_FILE)

    assert axes == ["sr_pca_0", "sr_pca_1", "sr_pca_2"]
    assert requirements["requires_synthesis"] is True
    assert requirements["requires_auto_bd_sr_pca"] is True
    assert artifact_path.is_file()


def test_sr_rff_pca_profile_resolves_artifact():
    axes = resolve_descriptor_axes(
        profile_name="sr_pca_3d",
        explicit_axes=None,
        descriptor_file=SR_RFF_PCA_DESCRIPTOR_FILE,
        archive_type="grid",
        circuit_type="sequential",
    )
    artifact_path = load_sr_pca_artifact_path(SR_RFF_PCA_DESCRIPTOR_FILE)

    assert axes == ["sr_pca_0", "sr_pca_1", "sr_pca_2"]
    assert artifact_path.is_file()
    assert "sr_rff_pca_artifact.json" in artifact_path.as_posix()


def test_sr_vq_profile_resolves_artifact_and_requirements():
    axes = resolve_descriptor_axes(
        profile_name="sr_vq_3d",
        explicit_axes=None,
        descriptor_file=SR_VQ_DESCRIPTOR_FILE,
        archive_type="grid",
        circuit_type="sequential",
    )
    requirements = descriptor_requirements(axes)
    artifact_path = load_sr_vq_artifact_path(SR_VQ_DESCRIPTOR_FILE)

    assert axes == ["sr_vq_0", "sr_vq_1", "sr_vq_2"]
    assert requirements["requires_synthesis"] is True
    assert requirements["requires_auto_bd_sr_vq"] is True
    assert artifact_path.is_file()
    assert "sr_vq_codebook_artifact.json" in artifact_path.as_posix()


def test_load_descriptor_profiles_accepts_custom_file(tmp_path: Path):
    cfg = tmp_path / "profiles.yaml"
    cfg.write_text("profiles:\n  mini:\n    - g_A\n    - g_T\n", encoding="utf-8")
    profiles = load_descriptor_profiles(cfg)
    assert profiles["mini"] == ["g_A", "g_T"]


def test_load_grid_axis_specs_accepts_custom_file(tmp_path: Path):
    cfg = tmp_path / "profiles.yaml"
    cfg.write_text(
        "profiles:\n  mini:\n    - g_A\n"
        "grid_axes:\n"
        "  g_A:\n"
        "    bins: 5\n"
        "    lower_bound: -0.5\n"
        "    upper_bound: 0.75\n",
        encoding="utf-8",
    )
    specs = load_grid_axis_specs(cfg)
    assert specs["g_A"].bins == 5
    assert specs["g_A"].lower_bound == pytest.approx(-0.5)
    assert specs["g_A"].upper_bound == pytest.approx(0.75)


def test_resolve_grid_axis_specs_uses_configured_and_fallback_specs(tmp_path: Path):
    cfg = tmp_path / "profiles.yaml"
    cfg.write_text(
        "grid_axes:\n"
        "  seq_ratio:\n"
        "    bins: 3\n"
        "    lower_bound: 0.1\n"
        "    upper_bound: 0.9\n",
        encoding="utf-8",
    )
    specs = resolve_grid_axis_specs(
        ["seq_ratio", "g_A"],
        num_cells=16,
        descriptor_file=cfg,
    )
    assert specs[0].bins == 3
    assert specs[0].lower_bound == pytest.approx(0.1)
    assert specs[0].upper_bound == pytest.approx(0.9)
    assert specs[1].bins == 4
    assert specs[1].lower_bound == pytest.approx(-1.0)
    assert specs[1].upper_bound == pytest.approx(1.0)


def test_default_descriptor_file_exposes_retrospective_structural_grid_specs():
    specs = load_grid_axis_specs()
    assert specs["seq_ratio"].bins == 2
    assert specs["seq_ratio"].lower_bound == pytest.approx(0.0)
    assert specs["seq_ratio"].upper_bound == pytest.approx(0.2918918918918919)
    assert specs["comb_ratio"].bins == 2
    assert specs["comb_ratio"].lower_bound == pytest.approx(0.7081081081081081)
    assert specs["comb_ratio"].upper_bound == pytest.approx(1.0)
    assert specs["mux_ratio"].bins == 2
    assert specs["mux_ratio"].lower_bound == pytest.approx(0.026345721755332695)
    assert specs["mux_ratio"].upper_bound == pytest.approx(0.37158469945355194)
    assert specs["adder_ratio"].bins == 2
    assert specs["adder_ratio"].lower_bound == pytest.approx(0.0)
    assert specs["adder_ratio"].upper_bound == pytest.approx(0.11588330632090761)
    assert specs["cell_count_log"].bins == 2
    assert specs["cell_count_log"].lower_bound == pytest.approx(5.1152555343856845)
    assert specs["cell_count_log"].upper_bound == pytest.approx(7.605890001053122)
    assert specs["wire_count_log_est"].bins == 4
    assert specs["wire_count_log_est"].lower_bound == pytest.approx(5.306052475806975)
    assert specs["wire_count_log_est"].upper_bound == pytest.approx(7.729735331385051)
    assert specs["assign_count"].bins == 4
    assert specs["assign_count"].lower_bound == pytest.approx(0.0)
    assert specs["assign_count"].upper_bound == pytest.approx(8.740000000000009)
    assert specs["always_count"].bins == 4
    assert specs["always_count"].lower_bound == pytest.approx(0.0)
    assert specs["always_count"].upper_bound == pytest.approx(4.0)
    assert specs["case_count"].bins == 4
    assert specs["case_count"].lower_bound == pytest.approx(0.0)
    assert specs["case_count"].upper_bound == pytest.approx(4.0)
    assert specs["ctrl_depth_est"].bins == 2
    assert specs["ctrl_depth_est"].lower_bound == pytest.approx(0.0)
    assert specs["ctrl_depth_est"].upper_bound == pytest.approx(10.0)
    assert specs["math_op_ast_count"].bins == 2
    assert specs["math_op_ast_count"].lower_bound == pytest.approx(0.0)
    assert specs["math_op_ast_count"].upper_bound == pytest.approx(16.0)
    assert specs["toggle_count_log_est"].bins == 4
    assert specs["toggle_count_log_est"].lower_bound == pytest.approx(0.0)
    assert specs["toggle_count_log_est"].upper_bound == pytest.approx(16.0)
    assert specs["toggle_density_est"].bins == 4
    assert specs["toggle_density_est"].lower_bound == pytest.approx(0.0)
    assert specs["toggle_density_est"].upper_bound == pytest.approx(64.0)
    assert specs["active_signal_ratio_est"].bins == 4
    assert specs["active_signal_ratio_est"].lower_bound == pytest.approx(0.0)
    assert specs["active_signal_ratio_est"].upper_bound == pytest.approx(1.0)
