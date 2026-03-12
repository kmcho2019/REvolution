from __future__ import annotations

import math
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml

from revolution.runtime.problem_spec import CircuitType


@dataclass(frozen=True)
class DescriptorDefinition:
    name: str
    source_tool: str
    transform: str = "identity"
    requires_ppa: bool = False
    requires_synthesis: bool = False
    requires_formal: bool = False
    supported_benchmarks: tuple[str, ...] = ()


_REGISTRY: dict[str, DescriptorDefinition] = {
    "seq_ratio": DescriptorDefinition("seq_ratio", "yosys", requires_synthesis=True),
    "comb_ratio": DescriptorDefinition("comb_ratio", "yosys", requires_synthesis=True),
    "mux_ratio": DescriptorDefinition("mux_ratio", "yosys", requires_synthesis=True),
    "adder_ratio": DescriptorDefinition("adder_ratio", "yosys", requires_synthesis=True),
    "ltp_noff": DescriptorDefinition("ltp_noff", "yosys", requires_synthesis=True),
    "cell_count_log": DescriptorDefinition("cell_count_log", "yosys", transform="log1p", requires_synthesis=True),
    "wirelength": DescriptorDefinition("wirelength", "openroad", transform="log1p", requires_synthesis=True),
    "utilization": DescriptorDefinition("utilization", "openroad", requires_synthesis=True),
    "cts_buffer_count": DescriptorDefinition("cts_buffer_count", "openroad", transform="log1p", requires_synthesis=True),
    "repair_buffer_count": DescriptorDefinition("repair_buffer_count", "openroad", transform="log1p", requires_synthesis=True),
    "hold_buffer_count": DescriptorDefinition("hold_buffer_count", "openroad", transform="log1p", requires_synthesis=True),
    "g_P": DescriptorDefinition("g_P", "ppa", requires_ppa=True),
    "g_A": DescriptorDefinition("g_A", "ppa", requires_ppa=True),
    "g_T": DescriptorDefinition("g_T", "ppa", requires_ppa=True),
}


def default_descriptor_profile_path() -> Path:
    return (
        Path(__file__).resolve().parents[3]
        / "data"
        / "configs"
        / "qd_descriptor_profiles.yaml"
    )


def descriptor_registry() -> dict[str, DescriptorDefinition]:
    return dict(_REGISTRY)


def load_descriptor_profiles(path: str | Path | None = None) -> dict[str, list[str]]:
    profile_path = Path(path) if path is not None else default_descriptor_profile_path()
    payload = yaml.safe_load(profile_path.read_text(encoding="utf-8")) or {}
    if not isinstance(payload, dict):
        raise ValueError("Descriptor profile file must contain a mapping.")
    profiles_raw = payload.get("profiles", payload)
    if not isinstance(profiles_raw, dict):
        raise ValueError("Descriptor profiles must decode to a mapping.")

    profiles: dict[str, list[str]] = {}
    for profile_name, axes in profiles_raw.items():
        if not isinstance(axes, list) or not all(isinstance(axis, str) for axis in axes):
            raise ValueError(f"Descriptor profile '{profile_name}' must be a list of strings.")
        profiles[str(profile_name)] = list(axes)
    return profiles


def resolve_descriptor_axes(
    *,
    profile_name: str | None,
    explicit_axes: list[str] | tuple[str, ...] | None,
    descriptor_file: str | Path | None,
    archive_type: str,
    circuit_type: CircuitType,
) -> list[str]:
    if explicit_axes:
        return list(explicit_axes)

    profiles = load_descriptor_profiles(descriptor_file)
    if profile_name and profile_name in profiles:
        return list(profiles[profile_name])

    if archive_type == "grid":
        return ["g_A", "g_P"] if circuit_type == "combinational" else ["g_A", "g_T"]
    return ["mux_ratio", "ltp_noff", "cell_count_log", "g_P", "g_A"] if circuit_type == "combinational" else [
        "seq_ratio",
        "mux_ratio",
        "ltp_noff",
        "cell_count_log",
        "g_P",
        "g_A",
        "g_T",
    ]


def extract_descriptor_values(
    metrics: dict[str, float],
    axes: list[str] | tuple[str, ...],
) -> dict[str, float]:
    registry = descriptor_registry()
    values: dict[str, float] = {}
    for axis in axes:
        if axis not in registry:
            raise KeyError(f"Unknown descriptor axis '{axis}'.")
        raw_value = float(metrics.get(axis, 0.0))
        definition = registry[axis]
        if definition.transform == "log1p":
            values[axis] = math.log1p(max(raw_value, 0.0))
        else:
            values[axis] = raw_value
    return values


def descriptor_requirements(axes: list[str] | tuple[str, ...]) -> dict[str, bool]:
    registry = descriptor_registry()
    return {
        "requires_ppa": any(registry[axis].requires_ppa for axis in axes if axis in registry),
        "requires_synthesis": any(
            registry[axis].requires_synthesis for axis in axes if axis in registry
        ),
        "requires_formal": any(registry[axis].requires_formal for axis in axes if axis in registry),
    }


def summarize_descriptor_axes(axes: list[str] | tuple[str, ...]) -> list[dict[str, Any]]:
    registry = descriptor_registry()
    return [
        {
            "name": axis,
            "source_tool": registry[axis].source_tool,
            "transform": registry[axis].transform,
            "requires_ppa": registry[axis].requires_ppa,
            "requires_synthesis": registry[axis].requires_synthesis,
        }
        for axis in axes
        if axis in registry
    ]
