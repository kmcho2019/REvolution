from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Literal

MethodFamily = Literal[
    "random_descriptor",
    "yosys_stat_bd",
    "netlist_motif_occupancy",
    "synthesis_trajectory_nod",
    "synthesis_response_kernel_pca",
    "contrastive_synthesis_response",
    "aurora_netlist_encoder",
    "vq_implementation_codebook",
]
FittingProtocol = Literal[
    "none",
    "fixed_offline",
    "online_adaptive",
    "posthoc_visualization_only",
]

AUTO_BD_SCAFFOLD_DIR = Path(
    "docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research"
)
AUTO_BD_METHODS_DIR = AUTO_BD_SCAFFOLD_DIR / "auto_bd_methods"
FORBIDDEN_DESCRIPTOR_INPUTS = (
    "ppa",
    "reference_ppa",
    "fitness",
    "hypervolume",
    "testbench_pass_percentage",
    "problem_id",
)


@dataclass(frozen=True)
class AutoBDMethodSpec:
    """Small method-family contract used to keep Auto-BD variants organized."""

    family: MethodFamily
    directory_name: str
    title: str
    descriptor_inputs: tuple[str, ...]
    fitting_protocol: FittingProtocol
    requires_synthesis: bool
    requires_stage_dumps: bool
    requires_fitting_artifacts: bool


_METHOD_SPECS: tuple[AutoBDMethodSpec, ...] = (
    AutoBDMethodSpec(
        family="random_descriptor",
        directory_name="00_random_descriptor",
        title="Random Descriptor Control",
        descriptor_inputs=("canonical_netlist_hash",),
        fitting_protocol="none",
        requires_synthesis=True,
        requires_stage_dumps=False,
        requires_fitting_artifacts=False,
    ),
    AutoBDMethodSpec(
        family="yosys_stat_bd",
        directory_name="01_yosys_stat_bd",
        title="Yosys-Stat BD Control",
        descriptor_inputs=("yosys_json", "synthesis_stats"),
        fitting_protocol="none",
        requires_synthesis=True,
        requires_stage_dumps=False,
        requires_fitting_artifacts=False,
    ),
    AutoBDMethodSpec(
        family="netlist_motif_occupancy",
        directory_name="02_netlist_motif_occupancy",
        title="Netlist Motif Occupancy",
        descriptor_inputs=("synthesized_netlist", "yosys_json"),
        fitting_protocol="none",
        requires_synthesis=True,
        requires_stage_dumps=False,
        requires_fitting_artifacts=False,
    ),
    AutoBDMethodSpec(
        family="synthesis_trajectory_nod",
        directory_name="03_synthesis_trajectory_nod",
        title="Synthesis-Trajectory NOD",
        descriptor_inputs=("synthesized_netlist", "yosys_stage_dumps"),
        fitting_protocol="none",
        requires_synthesis=True,
        requires_stage_dumps=True,
        requires_fitting_artifacts=False,
    ),
    AutoBDMethodSpec(
        family="synthesis_response_kernel_pca",
        directory_name="04_synthesis_response_kernel_pca",
        title="Synthesis-Response Kernel PCA QD",
        descriptor_inputs=(
            "synthesis_stats",
            "motif_occupancy",
            "yosys_stage_dumps",
            "stage_cell_count_deltas",
            "stage_motif_ratios",
        ),
        fitting_protocol="fixed_offline",
        requires_synthesis=True,
        requires_stage_dumps=True,
        requires_fitting_artifacts=True,
    ),
    AutoBDMethodSpec(
        family="contrastive_synthesis_response",
        directory_name="05_contrastive_synthesis_response",
        title="Contrastive Synthesis Response",
        descriptor_inputs=("synthesized_netlist", "reference_netlist", "yosys_stage_dumps"),
        fitting_protocol="none",
        requires_synthesis=True,
        requires_stage_dumps=True,
        requires_fitting_artifacts=False,
    ),
    AutoBDMethodSpec(
        family="aurora_netlist_encoder",
        directory_name="06_aurora_netlist_encoder",
        title="AURORA-Style Netlist Encoder",
        descriptor_inputs=("motif_or_trajectory_vectors",),
        fitting_protocol="fixed_offline",
        requires_synthesis=True,
        requires_stage_dumps=False,
        requires_fitting_artifacts=True,
    ),
    AutoBDMethodSpec(
        family="vq_implementation_codebook",
        directory_name="07_vq_implementation_codebook",
        title="VQ Implementation-Style Codebook",
        descriptor_inputs=("motif_or_trajectory_vectors",),
        fitting_protocol="fixed_offline",
        requires_synthesis=True,
        requires_stage_dumps=False,
        requires_fitting_artifacts=True,
    ),
)


def method_specs() -> tuple[AutoBDMethodSpec, ...]:
    """Return the planned Auto-BD method families in evaluation order."""

    return _METHOD_SPECS


def method_spec(family: str) -> AutoBDMethodSpec:
    """Return one method spec, failing loudly for unknown families."""

    for spec in _METHOD_SPECS:
        if spec.family == family:
            return spec
    raise ValueError(f"Unknown Auto-BD method family '{family}'.")


def method_directory(family: str) -> Path:
    """Return the scaffold-local directory for one method family."""

    return AUTO_BD_METHODS_DIR / method_spec(family).directory_name


def validate_method_registry() -> None:
    """Assert that the method registry is exhaustive and leak-free."""

    families = [spec.family for spec in _METHOD_SPECS]
    assert len(families) == len(set(families)), "Auto-BD method families must be unique."
    directories = [spec.directory_name for spec in _METHOD_SPECS]
    assert len(directories) == len(set(directories)), "Auto-BD method dirs must be unique."
    for spec in _METHOD_SPECS:
        _validate_method_spec(spec)


def _validate_method_spec(spec: AutoBDMethodSpec) -> None:
    directory_prefix, _, _ = spec.directory_name.partition("_")
    assert directory_prefix.isdigit()
    assert ".." not in Path(spec.directory_name).parts
    assert not set(spec.descriptor_inputs).intersection(FORBIDDEN_DESCRIPTOR_INPUTS)
    match spec.fitting_protocol:
        case "none":
            assert not spec.requires_fitting_artifacts
        case "fixed_offline" | "online_adaptive" | "posthoc_visualization_only":
            assert spec.requires_fitting_artifacts
        case _:
            raise AssertionError(f"Unknown fitting protocol '{spec.fitting_protocol}'.")
