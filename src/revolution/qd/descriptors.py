from __future__ import annotations

import math
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml  # type: ignore[reportMissingModuleSource]

from revolution.runtime.problem_spec import CircuitType


@dataclass(frozen=True)
class DescriptorDefinition:
    """Registry metadata describing how one descriptor is produced and used."""

    name: str
    source_tool: str
    transform: str = "identity"
    requires_ppa: bool = False
    requires_synthesis: bool = False
    requires_simulation: bool = False
    requires_formal: bool = False
    supported_benchmarks: tuple[str, ...] = ()


@dataclass(frozen=True)
class GridAxisDescriptorSpec:
    """Resolved grid-axis binning and bounds for one descriptor axis."""

    name: str
    bins: int
    lower_bound: float
    upper_bound: float


_T11_RUNTIME_PCA_SOURCE_AXES = (
    "hyper_mean_fanout",
    "edge_per_node",
    "log_edge_count",
    "hyper_directed_edge_count",
    "hyper_fanout_entropy",
    "hyper_driven_net_count",
    "hyper_sink_net_count",
    "log_net_count",
)
_T11_RUNTIME_PCA_AXES = (
    "t11_runtime_pca_0",
    "t11_runtime_pca_1",
    "t11_runtime_pca_2",
    "t11_runtime_pca_3",
)
_T11_RUNTIME_PCA_MEANS = (
    1.196406099612,
    1.230324803388,
    3.364217972698,
    398.76953125,
    1.411169238112,
    227.411458333333,
    233.540364583333,
    3.859244883295,
)
_T11_RUNTIME_PCA_SCALES = (
    0.462385346301,
    0.821128505784,
    2.447648954374,
    1144.559855704543,
    0.507450550491,
    586.392702047477,
    604.856920439895,
    1.788825224165,
)
_T11_RUNTIME_PCA_COMPONENTS = (
    (
        0.356361378886,
        0.367674080759,
        0.410051887174,
        0.353026367488,
        0.214633794467,
        0.352592678926,
        0.350199941263,
        0.389901153935,
    ),
    (
        0.378695661276,
        0.315727698356,
        0.125065538101,
        -0.368377851599,
        0.528015043604,
        -0.395550723286,
        -0.412655291744,
        -0.004163590238,
    ),
    (
        0.090812610219,
        -0.158520462863,
        -0.365199439504,
        0.340918210028,
        0.619028903145,
        0.218266395395,
        0.135117075801,
        -0.517624235982,
    ),
    (
        -0.227176201264,
        -0.601265011248,
        0.014442195464,
        -0.094373227797,
        0.446487114326,
        0.047954298731,
        -0.060711106293,
        0.610262468321,
    ),
)


_REGISTRY: dict[str, DescriptorDefinition] = {
    "total_cells": DescriptorDefinition("total_cells", "yosys", requires_synthesis=True),
    "sequential_cells": DescriptorDefinition("sequential_cells", "yosys", requires_synthesis=True),
    "combinational_cells": DescriptorDefinition("combinational_cells", "yosys", requires_synthesis=True),
    "mux_cells": DescriptorDefinition("mux_cells", "yosys", requires_synthesis=True),
    "arithmetic_cells": DescriptorDefinition("arithmetic_cells", "yosys", requires_synthesis=True),
    "seq_ratio": DescriptorDefinition("seq_ratio", "yosys", requires_synthesis=True),
    "comb_ratio": DescriptorDefinition("comb_ratio", "yosys", requires_synthesis=True),
    "mux_ratio": DescriptorDefinition("mux_ratio", "yosys", requires_synthesis=True),
    "adder_ratio": DescriptorDefinition("adder_ratio", "yosys", requires_synthesis=True),
    "ltp_noff": DescriptorDefinition("ltp_noff", "yosys", requires_synthesis=True),
    "cell_count_log": DescriptorDefinition("cell_count_log", "yosys", transform="log1p", requires_synthesis=True),
    "always_count": DescriptorDefinition("always_count", "rtl_text"),
    "assign_count": DescriptorDefinition("assign_count", "rtl_text"),
    "if_count": DescriptorDefinition("if_count", "rtl_text"),
    "case_count": DescriptorDefinition("case_count", "rtl_text"),
    "ternary_count": DescriptorDefinition("ternary_count", "rtl_text"),
    "rtl_instance_count_est": DescriptorDefinition("rtl_instance_count_est", "rtl_text"),
    "fsm_state_count_est": DescriptorDefinition("fsm_state_count_est", "rtl_text"),
    "wire_count_log_est": DescriptorDefinition("wire_count_log_est", "rtl_estimator"),
    "wire_cell_ratio_est": DescriptorDefinition("wire_cell_ratio_est", "rtl_estimator"),
    "ast_depth_est": DescriptorDefinition("ast_depth_est", "yosys_ast"),
    "ctrl_depth_est": DescriptorDefinition("ctrl_depth_est", "yosys_ast"),
    "math_op_ast_count": DescriptorDefinition("math_op_ast_count", "yosys_ast"),
    "resource_sharing_ratio_est": DescriptorDefinition("resource_sharing_ratio_est", "yosys_ast"),
    "rtl_cyclomatic_total_log": DescriptorDefinition("rtl_cyclomatic_total_log", "yosys_ast", transform="log1p"),
    "rtl_cyclomatic_max_log": DescriptorDefinition("rtl_cyclomatic_max_log", "yosys_ast", transform="log1p"),
    "rent_exponent": DescriptorDefinition("rent_exponent", "yosys_graph"),
    "rent_exponent_confidence_gated": DescriptorDefinition("rent_exponent_confidence_gated", "yosys_graph"),
    "rent_confidence": DescriptorDefinition("rent_confidence", "yosys_graph"),
    "rent_clamped_flag": DescriptorDefinition("rent_clamped_flag", "yosys_graph"),
    "reconv_source_ratio": DescriptorDefinition("reconv_source_ratio", "yosys_graph"),
    "reconv_sink_ratio": DescriptorDefinition("reconv_sink_ratio", "yosys_graph"),
    "rent_k": DescriptorDefinition("rent_k", "yosys_graph"),
    "rent_r2": DescriptorDefinition("rent_r2", "yosys_graph"),
    "rent_sample_count": DescriptorDefinition("rent_sample_count", "yosys_graph"),
    "rent_raw_sample_count": DescriptorDefinition("rent_raw_sample_count", "yosys_graph"),
    "rent_retained_sample_ratio": DescriptorDefinition("rent_retained_sample_ratio", "yosys_graph"),
    "rent_graph_node_count": DescriptorDefinition("rent_graph_node_count", "yosys_graph"),
    "logic_depth": DescriptorDefinition("logic_depth", "yosys_graph", requires_synthesis=True),
    "ff_depth": DescriptorDefinition("ff_depth", "yosys_graph", requires_synthesis=True),
    "comb_width_log": DescriptorDefinition("comb_width_log", "yosys_graph", requires_synthesis=True),
    "hyper_mean_fanout": DescriptorDefinition("hyper_mean_fanout", "yosys_graph"),
    "edge_per_node": DescriptorDefinition("edge_per_node", "yosys_graph"),
    "log_edge_count": DescriptorDefinition("log_edge_count", "yosys_graph", transform="log1p"),
    "hyper_directed_edge_count": DescriptorDefinition("hyper_directed_edge_count", "yosys_graph"),
    "hyper_fanout_entropy": DescriptorDefinition("hyper_fanout_entropy", "yosys_graph"),
    "hyper_driven_net_count": DescriptorDefinition("hyper_driven_net_count", "yosys_graph"),
    "hyper_sink_net_count": DescriptorDefinition("hyper_sink_net_count", "yosys_graph"),
    "log_net_count": DescriptorDefinition("log_net_count", "yosys_graph", transform="log1p"),
    "hyper_net_count": DescriptorDefinition("hyper_net_count", "yosys_graph"),
    "hyper_cell_count": DescriptorDefinition("hyper_cell_count", "yosys_graph"),
    "log_node_count": DescriptorDefinition("log_node_count", "yosys_graph", transform="log1p"),
    "hyper_max_fanout": DescriptorDefinition("hyper_max_fanout", "yosys_graph"),
    "hyper_max_level": DescriptorDefinition("hyper_max_level", "yosys_graph"),
    "log_max_level": DescriptorDefinition("log_max_level", "yosys_graph", transform="log1p"),
    "hyper_max_level_delta": DescriptorDefinition("hyper_max_level_delta", "yosys_graph"),
    "share_family_inv": DescriptorDefinition("share_family_inv", "yosys_graph"),
    "operator_mix_score": DescriptorDefinition("operator_mix_score", "yosys_graph"),
    "state_control_ratio": DescriptorDefinition("state_control_ratio", "yosys_graph"),
    "sog_complexity_score": DescriptorDefinition("sog_complexity_score", "yosys_graph"),
    "sog_entropy": DescriptorDefinition("sog_entropy", "yosys_graph"),
    "pipeline_event_count": DescriptorDefinition("pipeline_event_count", "rtl_text"),
    "control_count": DescriptorDefinition("control_count", "rtl_text"),
    "arith_count": DescriptorDefinition("arith_count", "rtl_text"),
    "mul_count": DescriptorDefinition("mul_count", "rtl_text"),
    "compare_count": DescriptorDefinition("compare_count", "rtl_text"),
    "logic_op_count": DescriptorDefinition("logic_op_count", "rtl_text"),
    "max_rhs_operator_count": DescriptorDefinition("max_rhs_operator_count", "rtl_text"),
    "unique_identifier_count": DescriptorDefinition("unique_identifier_count", "rtl_text"),
    "max_identifier_fanout": DescriptorDefinition("max_identifier_fanout", "rtl_text"),
    "timing_risk_score": DescriptorDefinition("timing_risk_score", "rtl_text"),
    "control_pipeline_ratio": DescriptorDefinition("control_pipeline_ratio", "rtl_text"),
    "timing_risk_entropy": DescriptorDefinition("timing_risk_entropy", "rtl_text"),
    "masterrtl_operator_log_edges": DescriptorDefinition(
        "masterrtl_operator_log_edges",
        "source_aligned_rtl",
    ),
    "rtltimer_state_timing_class": DescriptorDefinition(
        "rtltimer_state_timing_class",
        "source_aligned_rtl",
    ),
    "source_aligned_masterrtl_branching": DescriptorDefinition(
        "source_aligned_masterrtl_branching",
        "source_aligned_rtl",
    ),
    "source_aligned_masterrtl_operator_log_count": DescriptorDefinition(
        "source_aligned_masterrtl_operator_log_count",
        "source_aligned_rtl",
    ),
    "source_aligned_masterrtl_seq_fraction": DescriptorDefinition(
        "source_aligned_masterrtl_seq_fraction",
        "source_aligned_rtl",
    ),
    "source_aligned_masterrtl_mux_fraction": DescriptorDefinition(
        "source_aligned_masterrtl_mux_fraction",
        "source_aligned_rtl",
    ),
    "source_aligned_masterrtl_xor_fraction": DescriptorDefinition(
        "source_aligned_masterrtl_xor_fraction",
        "source_aligned_rtl",
    ),
    "source_aligned_rtltimer_wire_density": DescriptorDefinition(
        "source_aligned_rtltimer_wire_density",
        "source_aligned_rtl",
    ),
    "source_aligned_rtltimer_dff_density": DescriptorDefinition(
        "source_aligned_rtltimer_dff_density",
        "source_aligned_rtl",
    ),
    "source_aligned_rf_timing_path_count": DescriptorDefinition(
        "source_aligned_rf_timing_path_count",
        "source_aligned_rf_timing",
        transform="log1p",
    ),
    "source_aligned_rf_timing_leaf_rows": DescriptorDefinition(
        "source_aligned_rf_timing_leaf_rows",
        "source_aligned_rf_timing",
        transform="log1p",
    ),
    "source_aligned_rf_timing_leaf_ids": DescriptorDefinition(
        "source_aligned_rf_timing_leaf_ids",
        "source_aligned_rf_timing",
        transform="log1p",
    ),
    "source_aligned_rf_timing_no_path_flag": DescriptorDefinition(
        "source_aligned_rf_timing_no_path_flag",
        "source_aligned_rf_timing",
    ),
    "source_aligned_rf_timing_prediction_mean": DescriptorDefinition(
        "source_aligned_rf_timing_prediction_mean",
        "source_aligned_rf_timing",
    ),
    "t11_runtime_pca_0": DescriptorDefinition("t11_runtime_pca_0", "yosys_graph"),
    "t11_runtime_pca_1": DescriptorDefinition("t11_runtime_pca_1", "yosys_graph"),
    "t11_runtime_pca_2": DescriptorDefinition("t11_runtime_pca_2", "yosys_graph"),
    "t11_runtime_pca_3": DescriptorDefinition("t11_runtime_pca_3", "yosys_graph"),
    "scoap_cc0_bin_0_pct": DescriptorDefinition("scoap_cc0_bin_0_pct", "yosys_graph"),
    "scoap_cc0_bin_1_pct": DescriptorDefinition("scoap_cc0_bin_1_pct", "yosys_graph"),
    "scoap_cc0_bin_2_pct": DescriptorDefinition("scoap_cc0_bin_2_pct", "yosys_graph"),
    "scoap_cc0_bin_3_pct": DescriptorDefinition("scoap_cc0_bin_3_pct", "yosys_graph"),
    "scoap_cc1_bin_0_pct": DescriptorDefinition("scoap_cc1_bin_0_pct", "yosys_graph"),
    "scoap_cc1_bin_1_pct": DescriptorDefinition("scoap_cc1_bin_1_pct", "yosys_graph"),
    "scoap_cc1_bin_2_pct": DescriptorDefinition("scoap_cc1_bin_2_pct", "yosys_graph"),
    "scoap_cc1_bin_3_pct": DescriptorDefinition("scoap_cc1_bin_3_pct", "yosys_graph"),
    "scoap_co_bin_0_pct": DescriptorDefinition("scoap_co_bin_0_pct", "yosys_graph"),
    "scoap_co_bin_1_pct": DescriptorDefinition("scoap_co_bin_1_pct", "yosys_graph"),
    "scoap_co_bin_2_pct": DescriptorDefinition("scoap_co_bin_2_pct", "yosys_graph"),
    "scoap_co_bin_3_pct": DescriptorDefinition("scoap_co_bin_3_pct", "yosys_graph"),
    "laplacian_lambda2": DescriptorDefinition("laplacian_lambda2", "yosys_graph"),
    "laplacian_spectral_entropy": DescriptorDefinition("laplacian_spectral_entropy", "yosys_graph"),
    "scoap_signal_smoothness": DescriptorDefinition("scoap_signal_smoothness", "yosys_graph"),
    "toggle_count_log_est": DescriptorDefinition("toggle_count_log_est", "icarus_vcd", requires_simulation=True),
    "toggle_density_est": DescriptorDefinition("toggle_density_est", "icarus_vcd", requires_simulation=True),
    "active_signal_ratio_est": DescriptorDefinition("active_signal_ratio_est", "icarus_vcd", requires_simulation=True),
    "avg_toggle_rate_est": DescriptorDefinition("avg_toggle_rate_est", "icarus_vcd", requires_simulation=True),
    "wirelength": DescriptorDefinition("wirelength", "openroad", transform="log1p", requires_synthesis=True),
    "utilization": DescriptorDefinition("utilization", "openroad", requires_synthesis=True),
    "cts_buffer_count": DescriptorDefinition("cts_buffer_count", "openroad", transform="log1p", requires_synthesis=True),
    "repair_buffer_count": DescriptorDefinition("repair_buffer_count", "openroad", transform="log1p", requires_synthesis=True),
    "hold_buffer_count": DescriptorDefinition("hold_buffer_count", "openroad", transform="log1p", requires_synthesis=True),
    "g_P": DescriptorDefinition("g_P", "ppa", requires_ppa=True),
    "g_A": DescriptorDefinition("g_A", "ppa", requires_ppa=True),
    "g_T": DescriptorDefinition("g_T", "ppa", requires_ppa=True),
    "random_hash_0": DescriptorDefinition("random_hash_0", "auto_bd_hash", requires_synthesis=True),
    "random_hash_1": DescriptorDefinition("random_hash_1", "auto_bd_hash", requires_synthesis=True),
    "random_hash_2": DescriptorDefinition("random_hash_2", "auto_bd_hash", requires_synthesis=True),
    "motif_logic_ratio": DescriptorDefinition("motif_logic_ratio", "auto_bd_motif", requires_synthesis=True),
    "motif_control_ratio": DescriptorDefinition("motif_control_ratio", "auto_bd_motif", requires_synthesis=True),
    "motif_arith_ratio": DescriptorDefinition("motif_arith_ratio", "auto_bd_motif", requires_synthesis=True),
    "motif_diversity": DescriptorDefinition("motif_diversity", "auto_bd_motif", requires_synthesis=True),
    "stnod_cell_growth_log": DescriptorDefinition("stnod_cell_growth_log", "auto_bd_stage_dumps", requires_synthesis=True),
    "stnod_logic_swing": DescriptorDefinition("stnod_logic_swing", "auto_bd_stage_dumps", requires_synthesis=True),
    "stnod_control_swing": DescriptorDefinition("stnod_control_swing", "auto_bd_stage_dumps", requires_synthesis=True),
    "stnod_arith_swing": DescriptorDefinition("stnod_arith_swing", "auto_bd_stage_dumps", requires_synthesis=True),
    "stnod_diversity_swing": DescriptorDefinition("stnod_diversity_swing", "auto_bd_stage_dumps", requires_synthesis=True),
    "sr_pca_0": DescriptorDefinition("sr_pca_0", "auto_bd_sr_pca", requires_synthesis=True),
    "sr_pca_1": DescriptorDefinition("sr_pca_1", "auto_bd_sr_pca", requires_synthesis=True),
    "sr_pca_2": DescriptorDefinition("sr_pca_2", "auto_bd_sr_pca", requires_synthesis=True),
    "sr_pca_3": DescriptorDefinition("sr_pca_3", "auto_bd_sr_pca", requires_synthesis=True),
    "sr_pca_4": DescriptorDefinition("sr_pca_4", "auto_bd_sr_pca", requires_synthesis=True),
    "sr_vq_0": DescriptorDefinition("sr_vq_0", "auto_bd_sr_vq", requires_synthesis=True),
    "sr_vq_1": DescriptorDefinition("sr_vq_1", "auto_bd_sr_vq", requires_synthesis=True),
    "sr_vq_2": DescriptorDefinition("sr_vq_2", "auto_bd_sr_vq", requires_synthesis=True),
    "sr_vq_3": DescriptorDefinition("sr_vq_3", "auto_bd_sr_vq", requires_synthesis=True),
    "sr_vq_4": DescriptorDefinition("sr_vq_4", "auto_bd_sr_vq", requires_synthesis=True),
    "qwen_pc0": DescriptorDefinition("qwen_pc0", "qwen_rtl_embedding"),
    "qwen_pc1": DescriptorDefinition("qwen_pc1", "qwen_rtl_embedding"),
    "qwen_pc2": DescriptorDefinition("qwen_pc2", "qwen_rtl_embedding"),
    "qwen_pc3": DescriptorDefinition("qwen_pc3", "qwen_rtl_embedding"),
    "deepgate_pool_pc0": DescriptorDefinition(
        "deepgate_pool_pc0",
        "deepgate_pooled_embedding",
    ),
    "deepgate_pool_pc1": DescriptorDefinition(
        "deepgate_pool_pc1",
        "deepgate_pooled_embedding",
    ),
    "deepgate_pool_pc2": DescriptorDefinition(
        "deepgate_pool_pc2",
        "deepgate_pooled_embedding",
    ),
}


def default_descriptor_profile_path() -> Path:
    """Return the repository default descriptor-profile config path."""

    return (
        Path(__file__).resolve().parents[3]
        / "data"
        / "configs"
        / "qd_descriptor_profiles.yaml"
    )


def descriptor_registry() -> dict[str, DescriptorDefinition]:
    """Return a copy of the descriptor registry used by QD axis resolution."""

    return dict(_REGISTRY)


def _load_descriptor_config(path: str | Path | None = None) -> dict[str, Any]:
    profile_path = Path(path) if path is not None else default_descriptor_profile_path()
    payload = yaml.safe_load(profile_path.read_text(encoding="utf-8")) or {}
    if not isinstance(payload, dict):
        raise ValueError("Descriptor profile file must contain a mapping.")
    return payload


def load_descriptor_profiles(path: str | Path | None = None) -> dict[str, list[str]]:
    """Load named descriptor profiles from YAML config."""

    payload = _load_descriptor_config(path)
    profiles_raw = payload.get("profiles", payload)
    if not isinstance(profiles_raw, dict):
        raise ValueError("Descriptor profiles must decode to a mapping.")

    profiles: dict[str, list[str]] = {}
    for profile_name, axes in profiles_raw.items():
        if not isinstance(axes, list) or not all(isinstance(axis, str) for axis in axes):
            raise ValueError(f"Descriptor profile '{profile_name}' must be a list of strings.")
        profiles[str(profile_name)] = [str(axis) for axis in axes]
    return profiles


def load_grid_axis_specs(path: str | Path | None = None) -> dict[str, GridAxisDescriptorSpec]:
    """Load optional per-axis grid bin/bounds specs from the descriptor config."""
    payload = _load_descriptor_config(path)
    raw_specs = payload.get("grid_axes", {})
    if not raw_specs:
        return {}
    if not isinstance(raw_specs, dict):
        raise ValueError("grid_axes must decode to a mapping.")

    specs: dict[str, GridAxisDescriptorSpec] = {}
    for axis_name, axis_payload in raw_specs.items():
        if not isinstance(axis_payload, dict):
            raise ValueError(f"grid_axes['{axis_name}'] must be a mapping.")
        try:
            bins = int(axis_payload["bins"])
            lower_bound = float(axis_payload["lower_bound"])
            upper_bound = float(axis_payload["upper_bound"])
        except KeyError as exc:
            raise ValueError(
                f"grid_axes['{axis_name}'] is missing required field {exc.args[0]!r}."
            ) from exc
        specs[str(axis_name)] = GridAxisDescriptorSpec(
            name=str(axis_name),
            bins=bins,
            lower_bound=lower_bound,
            upper_bound=upper_bound,
        )
    return specs


def load_sr_pca_artifact_path(path: str | Path | None) -> Path:
    """Load the frozen SR-PCA artifact path from a descriptor-profile file."""

    assert path is not None
    profile_path = Path(path)
    payload = _load_descriptor_config(profile_path)
    artifact_path = payload["sr_pca_artifact"]
    assert isinstance(artifact_path, str)
    resolved = Path(artifact_path)
    if resolved.is_absolute():
        return resolved
    return profile_path.parent / resolved


def load_sr_vq_artifact_path(path: str | Path | None) -> Path:
    """Load the frozen SR-VQ artifact path from a descriptor-profile file."""

    assert path is not None
    profile_path = Path(path)
    payload = _load_descriptor_config(profile_path)
    artifact_path = payload["sr_vq_artifact"]
    assert isinstance(artifact_path, str)
    resolved = Path(artifact_path)
    if resolved.is_absolute():
        return resolved
    return profile_path.parent / resolved


def load_qwen_projection_artifact_path(path: str | Path | None) -> Path:
    """Load the frozen Qwen projection artifact path from a profile file."""

    assert path is not None
    profile_path = Path(path)
    payload = _load_descriptor_config(profile_path)
    artifact_path = payload["qwen_projection_artifact"]
    assert isinstance(artifact_path, str)
    resolved = Path(artifact_path)
    if resolved.is_absolute():
        return resolved
    return profile_path.parent / resolved


def load_deepgate_projection_artifact_path(path: str | Path | None) -> Path:
    """Load the frozen DeepGate projection artifact path from a profile file."""

    assert path is not None
    profile_path = Path(path)
    payload = _load_descriptor_config(profile_path)
    artifact_path = payload["deepgate_projection_artifact"]
    assert isinstance(artifact_path, str)
    resolved = Path(artifact_path)
    if resolved.is_absolute():
        return resolved
    return profile_path.parent / resolved


def resolve_descriptor_axes(
    *,
    profile_name: str | None,
    explicit_axes: list[str] | tuple[str, ...] | None,
    descriptor_file: str | Path | None,
    archive_type: str,
    circuit_type: CircuitType,
) -> list[str]:
    """Resolve the active descriptor axis list for one archive configuration."""

    if explicit_axes:
        return _validate_descriptor_axes(list(explicit_axes))

    profiles = load_descriptor_profiles(descriptor_file)
    if profile_name:
        if profile_name not in profiles:
            raise KeyError(f"Unknown descriptor profile '{profile_name}'.")
        return _validate_descriptor_axes(
            _filter_axes_for_circuit_type(list(profiles[profile_name]), circuit_type)
        )

    if archive_type == "grid":
        axes = ["g_A", "g_P"] if circuit_type == "combinational" else ["g_A", "g_P", "g_T"]
        return _validate_descriptor_axes(axes)
    axes = ["mux_ratio", "ltp_noff", "cell_count_log", "g_P", "g_A"] if circuit_type == "combinational" else [
        "seq_ratio",
        "mux_ratio",
        "ltp_noff",
        "cell_count_log",
        "g_P",
        "g_A",
        "g_T",
    ]
    return _validate_descriptor_axes(axes)


def _filter_axes_for_circuit_type(
    axes: list[str],
    circuit_type: CircuitType,
) -> list[str]:
    if circuit_type != "combinational":
        return axes
    return [axis for axis in axes if axis != "g_T"]


def _validate_descriptor_axes(axes: list[str]) -> list[str]:
    registry = descriptor_registry()
    unknown = [axis for axis in axes if axis not in registry]
    if unknown:
        raise KeyError(f"Unknown descriptor axis '{unknown[0]}'.")
    return axes


def resolve_grid_axis_specs(
    axes: list[str] | tuple[str, ...],
    *,
    num_cells: int,
    descriptor_file: str | Path | None,
) -> list[GridAxisDescriptorSpec]:
    """Resolve grid axis specs from config with sensible per-axis fallbacks."""
    if not axes:
        raise ValueError("Grid axis resolution requires at least one axis.")
    _validate_descriptor_axes(list(axes))
    configured_specs = load_grid_axis_specs(descriptor_file)
    dim = max(1, len(axes))
    default_bins = max(2, round(num_cells ** (1 / dim)))

    resolved: list[GridAxisDescriptorSpec] = []
    for axis in axes:
        configured = configured_specs.get(axis)
        if configured is not None:
            resolved.append(configured)
            continue
        lower_bound, upper_bound = _default_grid_bounds(axis)
        resolved.append(
            GridAxisDescriptorSpec(
                name=axis,
                bins=default_bins,
                lower_bound=lower_bound,
                upper_bound=upper_bound,
            )
        )
    return resolved


def _default_grid_bounds(axis: str) -> tuple[float, float]:
    """Return conservative default bounds for grid axes lacking explicit config."""
    if axis.startswith("g_"):
        return (-1.0, 1.0)
    if axis in {"seq_ratio", "comb_ratio", "mux_ratio", "adder_ratio", "utilization"}:
        return (0.0, 1.0)
    if axis in {"operator_mix_score", "state_control_ratio", "control_pipeline_ratio"}:
        return (0.0, 4.0)
    if axis in {"timing_risk_entropy", "sog_entropy"}:
        return (0.0, 4.0)
    if axis in {"laplacian_lambda2", "scoap_signal_smoothness"}:
        return (0.0, 2.0)
    if axis in {
        "rent_exponent",
        "rent_exponent_confidence_gated",
        "rent_confidence",
        "rent_clamped_flag",
        "reconv_source_ratio",
        "reconv_sink_ratio",
        "laplacian_spectral_entropy",
    } or (
        axis.startswith("scoap_")
        and axis not in {"scoap_signal_smoothness"}
    ):
        return (0.0, 1.0)
    if axis in {
        "total_cells",
        "sequential_cells",
        "combinational_cells",
        "mux_cells",
        "arithmetic_cells",
        "sog_complexity_score",
        "timing_risk_score",
    }:
        return (0.0, 8192.0)
    if axis == "masterrtl_operator_log_edges":
        return (4.0, 8.8)
    if axis == "rtltimer_state_timing_class":
        return (0.0, 4.0)
    if axis == "source_aligned_masterrtl_branching":
        return (0.0, 8.0)
    if axis == "source_aligned_masterrtl_operator_log_count":
        return (0.0, 10.0)
    if axis in {
        "source_aligned_masterrtl_seq_fraction",
        "source_aligned_masterrtl_mux_fraction",
        "source_aligned_masterrtl_xor_fraction",
    }:
        return (0.0, 1.0)
    if axis in {
        "source_aligned_rtltimer_wire_density",
        "source_aligned_rtltimer_dff_density",
    }:
        return (0.0, 1.0)
    if axis in {
        "source_aligned_rf_timing_path_count",
        "source_aligned_rf_timing_leaf_rows",
        "source_aligned_rf_timing_leaf_ids",
    }:
        return (0.0, 5.0)
    if axis == "source_aligned_rf_timing_no_path_flag":
        return (0.0, 1.0)
    if axis == "source_aligned_rf_timing_prediction_mean":
        return (-1.0, 1.0)
    if axis in {"cell_count_log", "wirelength", "cts_buffer_count", "repair_buffer_count", "hold_buffer_count", "wire_count_log_est"}:
        return (0.0, 16.0)
    if axis in {"logic_depth", "ff_depth"}:
        return (0.0, 64.0)
    if axis == "comb_width_log":
        return (0.0, 16.0)
    if axis in {
        "log_edge_count",
        "log_net_count",
        "log_node_count",
        "log_max_level",
    }:
        return (0.0, 16.0)
    if axis in {
        "hyper_directed_edge_count",
        "hyper_driven_net_count",
        "hyper_sink_net_count",
        "hyper_net_count",
        "hyper_cell_count",
    }:
        return (0.0, 8192.0)
    if axis in {
        "hyper_mean_fanout",
        "edge_per_node",
        "hyper_fanout_entropy",
        "hyper_max_fanout",
    }:
        return (0.0, 32.0)
    if axis in {"hyper_max_level", "hyper_max_level_delta"}:
        return (0.0, 64.0)
    if axis.startswith("share_family_"):
        return (0.0, 1.0)
    if axis == "toggle_count_log_est":
        return (0.0, 16.0)
    if axis in {
        "always_count",
        "assign_count",
        "if_count",
        "case_count",
        "ternary_count",
        "pipeline_event_count",
        "control_count",
        "arith_count",
        "mul_count",
        "compare_count",
        "logic_op_count",
        "max_rhs_operator_count",
        "unique_identifier_count",
        "max_identifier_fanout",
        "rtl_instance_count_est",
        "fsm_state_count_est",
        "ast_depth_est",
        "ctrl_depth_est",
        "math_op_ast_count",
        "rtl_cyclomatic_total_log",
        "rtl_cyclomatic_max_log",
        "rent_sample_count",
        "rent_raw_sample_count",
        "rent_graph_node_count",
    }:
        return (0.0, 32.0)
    if axis == "rent_retained_sample_ratio":
        return (0.0, 1.0)
    if axis == "toggle_density_est":
        return (0.0, 64.0)
    if axis in {"active_signal_ratio_est", "avg_toggle_rate_est"}:
        return (0.0, 1.0)
    if axis.startswith("random_hash_"):
        return (0.0, 1.0)
    if axis.startswith("motif_"):
        return (0.0, 1.0)
    if axis == "stnod_cell_growth_log":
        return (-8.0, 8.0)
    if axis.startswith("stnod_"):
        return (0.0, 1.0)
    if axis.startswith("sr_pca_") or axis.startswith("sr_vq_"):
        return (-3.0, 3.0)
    if axis.startswith("qwen_pc"):
        return (-1.0, 1.0)
    if axis.startswith("deepgate_pool_pc"):
        return (-1.0, 1.0)
    if axis in {"wire_cell_ratio_est", "resource_sharing_ratio_est"}:
        return (0.0, 4.0)
    if axis == "ltp_noff":
        return (0.0, 64.0)
    return (-1.0, 1.0)


def extract_descriptor_values(
    metrics: dict[str, float],
    axes: list[str] | tuple[str, ...],
) -> dict[str, float]:
    """Project raw metric payloads onto the requested descriptor axes."""

    registry = descriptor_registry()
    values: dict[str, float] = {}
    if any(axis in _T11_RUNTIME_PCA_AXES for axis in axes):
        values.update(_extract_t11_runtime_pca_values(metrics))
    for axis in axes:
        if axis not in registry:
            raise KeyError(f"Unknown descriptor axis '{axis}'.")
        if axis in values:
            continue
        if axis not in metrics:
            raise KeyError(f"Missing required descriptor metric '{axis}'.")
        raw_value = float(metrics[axis])
        definition = registry[axis]
        if definition.transform == "log1p":
            values[axis] = math.log1p(max(raw_value, 0.0))
        else:
            values[axis] = raw_value
    return values


def _extract_t11_runtime_pca_values(metrics: dict[str, float]) -> dict[str, float]:
    source_values = tuple(
        _axis_value(metrics, axis) for axis in _T11_RUNTIME_PCA_SOURCE_AXES
    )
    centered = tuple(
        (value - mean) / scale
        for value, mean, scale in zip(
            source_values,
            _T11_RUNTIME_PCA_MEANS,
            _T11_RUNTIME_PCA_SCALES,
            strict=True,
        )
    )
    projected = tuple(
        sum(value * weight for value, weight in zip(centered, component, strict=True))
        for component in _T11_RUNTIME_PCA_COMPONENTS
    )
    return dict(zip(_T11_RUNTIME_PCA_AXES, projected, strict=True))


def _axis_value(metrics: dict[str, float], axis: str) -> float:
    if axis not in metrics:
        raise KeyError(f"Missing required descriptor metric '{axis}'.")
    raw_value = float(metrics[axis])
    if _REGISTRY[axis].transform == "log1p":
        return math.log1p(max(raw_value, 0.0))
    return raw_value


def descriptor_requirements(axes: list[str] | tuple[str, ...]) -> dict[str, bool]:
    """Summarize which runtime stages are required by the selected axes."""

    registry = descriptor_registry()
    _validate_descriptor_axes(list(axes))
    return {
        "requires_ppa": any(registry[axis].requires_ppa for axis in axes),
        "requires_synthesis": any(
            registry[axis].requires_synthesis for axis in axes
        ),
        "requires_formal": any(registry[axis].requires_formal for axis in axes),
        "requires_rtl_metrics": any(
            registry[axis].source_tool in {"rtl_text", "rtl_estimator", "yosys_ast"}
            for axis in axes
        ),
        "requires_dynamic_metrics": any(
            registry[axis].source_tool == "icarus_vcd" for axis in axes
        ),
        "requires_graph_metrics": any(
            registry[axis].source_tool == "yosys_graph" for axis in axes
        ),
        "requires_source_aligned_rtl": any(
            registry[axis].source_tool == "source_aligned_rtl" for axis in axes
        ),
        "requires_source_aligned_rf_timing": any(
            registry[axis].source_tool == "source_aligned_rf_timing" for axis in axes
        ),
        "requires_auto_bd_hash": any(
            registry[axis].source_tool == "auto_bd_hash" for axis in axes
        ),
        "requires_auto_bd_motif": any(
            registry[axis].source_tool == "auto_bd_motif" for axis in axes
        ),
        "requires_auto_bd_stage_dumps": any(
            registry[axis].source_tool == "auto_bd_stage_dumps" for axis in axes
        ),
        "requires_auto_bd_sr_pca": any(
            registry[axis].source_tool == "auto_bd_sr_pca" for axis in axes
        ),
        "requires_auto_bd_sr_vq": any(
            registry[axis].source_tool == "auto_bd_sr_vq" for axis in axes
        ),
        "requires_qwen_rtl_embedding": any(
            registry[axis].source_tool == "qwen_rtl_embedding" for axis in axes
        ),
        "requires_deepgate_pooled_embedding": any(
            registry[axis].source_tool == "deepgate_pooled_embedding"
            for axis in axes
        ),
    }


def summarize_descriptor_axes(axes: list[str] | tuple[str, ...]) -> list[dict[str, Any]]:
    """Return lightweight metadata summaries for UI/reporting surfaces."""

    registry = descriptor_registry()
    _validate_descriptor_axes(list(axes))
    return [
        {
            "name": axis,
            "source_tool": registry[axis].source_tool,
            "transform": registry[axis].transform,
            "requires_ppa": registry[axis].requires_ppa,
            "requires_synthesis": registry[axis].requires_synthesis,
            "requires_simulation": registry[axis].requires_simulation,
            "requires_graph_metrics": registry[axis].source_tool == "yosys_graph",
            "requires_source_aligned_rtl": registry[axis].source_tool
            == "source_aligned_rtl",
            "requires_source_aligned_rf_timing": (
                registry[axis].source_tool == "source_aligned_rf_timing"
            ),
            "requires_auto_bd_motif": registry[axis].source_tool == "auto_bd_motif",
            "requires_auto_bd_stage_dumps": (
                registry[axis].source_tool == "auto_bd_stage_dumps"
            ),
            "requires_auto_bd_sr_pca": registry[axis].source_tool == "auto_bd_sr_pca",
            "requires_auto_bd_sr_vq": registry[axis].source_tool == "auto_bd_sr_vq",
            "requires_qwen_rtl_embedding": (
                registry[axis].source_tool == "qwen_rtl_embedding"
            ),
            "requires_deepgate_pooled_embedding": (
                registry[axis].source_tool == "deepgate_pooled_embedding"
            ),
        }
        for axis in axes
    ]
