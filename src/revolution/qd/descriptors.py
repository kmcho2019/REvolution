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
    }:
        return (0.0, 8192.0)
    if axis in {"cell_count_log", "wirelength", "cts_buffer_count", "repair_buffer_count", "hold_buffer_count", "wire_count_log_est"}:
        return (0.0, 16.0)
    if axis in {"logic_depth", "ff_depth"}:
        return (0.0, 64.0)
    if axis == "comb_width_log":
        return (0.0, 16.0)
    if axis == "toggle_count_log_est":
        return (0.0, 16.0)
    if axis in {
        "always_count",
        "assign_count",
        "if_count",
        "case_count",
        "ternary_count",
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
    for axis in axes:
        if axis not in registry:
            raise KeyError(f"Unknown descriptor axis '{axis}'.")
        if axis not in metrics:
            raise KeyError(f"Missing required descriptor metric '{axis}'.")
        raw_value = float(metrics[axis])
        definition = registry[axis]
        if definition.transform == "log1p":
            values[axis] = math.log1p(max(raw_value, 0.0))
        else:
            values[axis] = raw_value
    return values


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
        "requires_auto_bd_hash": any(
            registry[axis].source_tool == "auto_bd_hash" for axis in axes
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
        }
        for axis in axes
    ]
