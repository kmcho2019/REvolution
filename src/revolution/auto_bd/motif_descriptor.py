from __future__ import annotations

import math

from revolution.auto_bd.netlist_hash import netlist_cell_instances

MOTIF_OCCUPANCY_AXES = (
    "motif_logic_ratio",
    "motif_control_ratio",
    "motif_arith_ratio",
    "motif_diversity",
)
_MOTIF_FAMILIES = ("logic", "control", "arith")
_LOGIC_TOKENS = (
    "AND",
    "NAND",
    "OR",
    "NOR",
    "XOR",
    "XNOR",
    "INV",
    "NOT",
    "BUF",
    "AOI",
    "OAI",
)
_CONTROL_TOKENS = ("MUX", "PMUX", "SEL", "TRI", "BUFIF")
_ARITH_TOKENS = (
    "ADD",
    "SUB",
    "MUL",
    "DIV",
    "MOD",
    "SHL",
    "SHR",
    "SHIFT",
    "FA",
    "HA",
)


def motif_occupancy_descriptor_values(source: str) -> dict[str, float]:
    """Extract compact motif-family occupancy from a synthesized netlist."""

    instances = netlist_cell_instances(source)
    total = len(instances)
    if total == 0:
        return {axis: 0.0 for axis in MOTIF_OCCUPANCY_AXES}

    family_counts = {family: 0 for family in _MOTIF_FAMILIES}
    type_counts: dict[str, int] = {}
    for cell_type, _pin_count in instances:
        type_counts[cell_type] = type_counts.get(cell_type, 0) + 1
        family = _motif_family(cell_type)
        if family in family_counts:
            family_counts[family] += 1

    return {
        "motif_logic_ratio": family_counts["logic"] / total,
        "motif_control_ratio": family_counts["control"] / total,
        "motif_arith_ratio": family_counts["arith"] / total,
        "motif_diversity": _normalized_entropy(tuple(type_counts.values())),
    }


def _motif_family(cell_type: str) -> str:
    name = cell_type.upper().strip("\\")
    if any(token in name for token in _CONTROL_TOKENS):
        return "control"
    if any(token in name for token in _ARITH_TOKENS):
        return "arith"
    if any(token in name for token in _LOGIC_TOKENS):
        return "logic"
    return "other"


def _normalized_entropy(counts: tuple[int, ...]) -> float:
    total = sum(counts)
    assert total > 0
    entropy = 0.0
    for count in counts:
        p = count / total
        entropy -= p * math.log(p)
    return entropy / math.log(max(total, 2))
