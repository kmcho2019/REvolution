from __future__ import annotations

import math
from pathlib import Path

from revolution.auto_bd.motif_descriptor import motif_occupancy_descriptor_values
from revolution.auto_bd.netlist_hash import netlist_cell_instances

STNOD_TRAJECTORY_AXES = (
    "stnod_cell_growth_log",
    "stnod_logic_swing",
    "stnod_control_swing",
    "stnod_arith_swing",
    "stnod_diversity_swing",
)


def synthesis_trajectory_descriptor_values(
    stage_verilog_paths: tuple[Path, ...],
) -> dict[str, float]:
    """Extract compact ST-NOD trajectory features from Yosys stage snapshots."""

    assert stage_verilog_paths
    cell_counts: list[int] = []
    motif_series: dict[str, list[float]] = {
        "motif_logic_ratio": [],
        "motif_control_ratio": [],
        "motif_arith_ratio": [],
        "motif_diversity": [],
    }
    for path in stage_verilog_paths:
        text = path.read_text(encoding="utf-8", errors="ignore")
        cell_counts.append(len(netlist_cell_instances(text)))
        motif_values = motif_occupancy_descriptor_values(text)
        for axis in motif_series:
            motif_series[axis].append(motif_values[axis])

    return {
        "stnod_cell_growth_log": math.log1p(cell_counts[-1])
        - math.log1p(cell_counts[0]),
        "stnod_logic_swing": _swing(motif_series["motif_logic_ratio"]),
        "stnod_control_swing": _swing(motif_series["motif_control_ratio"]),
        "stnod_arith_swing": _swing(motif_series["motif_arith_ratio"]),
        "stnod_diversity_swing": _swing(motif_series["motif_diversity"]),
    }


def _swing(values: list[float]) -> float:
    assert values
    return max(values) - min(values)
