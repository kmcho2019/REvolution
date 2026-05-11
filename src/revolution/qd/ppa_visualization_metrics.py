from __future__ import annotations

import math
import random
from collections.abc import Sequence
from typing import Any, Literal, Mapping

from revolution.qd.pareto_analysis import hypervolume


ArchiveSourceType = Literal["grid", "grid_quantile", "cvt"]
AssetMode = Literal["cdn", "local", "inline"]
CoordinateMode = Literal["raw", "improvement", "normalized"]
RankScope = Literal["per_technique", "pooled_visible"]
SampleUniverse = Literal[
    "all_ppa_valid",
    "final_archive_members",
    "viewer_pooled_pareto_members",
]

COORDINATE_MODES: tuple[CoordinateMode, ...] = ("raw", "improvement", "normalized")
RANK_SCOPES: tuple[RankScope, ...] = ("per_technique", "pooled_visible")
SAMPLE_UNIVERSES: tuple[SampleUniverse, ...] = (
    "all_ppa_valid",
    "final_archive_members",
    "viewer_pooled_pareto_members",
)


def active_objective_keys(circuit_type: str) -> tuple[str, ...]:
    if circuit_type == "combinational":
        return ("g_P", "g_A")
    if circuit_type == "sequential":
        return ("g_P", "g_A", "g_T")
    raise AssertionError(f"unknown circuit type: {circuit_type}")


def active_raw_metrics(circuit_type: str) -> tuple[str, ...]:
    if circuit_type == "combinational":
        return ("area", "power")
    if circuit_type == "sequential":
        return ("area", "power", "eff_clk_period")
    raise AssertionError(f"unknown circuit type: {circuit_type}")


def finite_float(value: Any) -> float | None:
    if value in ("", None):
        return None
    parsed = float(value)
    if not math.isfinite(parsed):
        return None
    return parsed


def dominates_values(
    left: Mapping[str, float],
    right: Mapping[str, float],
    objective_keys: tuple[str, ...],
) -> bool:
    return all(left[key] >= right[key] for key in objective_keys) and any(
        left[key] > right[key] for key in objective_keys
    )


def pareto_ranks(
    samples: Sequence[Mapping[str, Any]],
    objective_keys: tuple[str, ...],
) -> dict[str, int]:
    """Return one-based nondominated-sort ranks for visible PPA samples."""
    remaining = {
        str(sample["sample_id"]): {
            key: float(sample[key])
            for key in objective_keys
        }
        for sample in samples
    }
    ranks: dict[str, int] = {}
    rank = 1
    while remaining:
        front: list[str] = []
        for sample_id, values in remaining.items():
            if any(
                other_id != sample_id
                and dominates_values(other_values, values, objective_keys)
                for other_id, other_values in remaining.items()
            ):
                continue
            front.append(sample_id)
        assert front
        for sample_id in front:
            ranks[sample_id] = rank
            del remaining[sample_id]
        rank += 1
    return ranks


def rank_one_count(
    samples: Sequence[Mapping[str, Any]],
    ranks: Mapping[str, int],
) -> int:
    return sum(1 for sample in samples if ranks[str(sample["sample_id"])] == 1)


def active_points(
    samples: Sequence[Mapping[str, Any]],
    objective_keys: tuple[str, ...],
) -> list[tuple[float, ...]]:
    return [
        tuple(float(sample[key]) for key in objective_keys)
        for sample in samples
    ]


def front_points(
    samples: Sequence[Mapping[str, Any]],
    ranks: Mapping[str, int],
    objective_keys: tuple[str, ...],
) -> list[tuple[float, ...]]:
    return [
        tuple(float(sample[key]) for key in objective_keys)
        for sample in samples
        if ranks[str(sample["sample_id"])] == 1
    ]


def hypervolume_payload(
    front: list[tuple[float, ...]],
    objective_keys: tuple[str, ...],
) -> dict[str, Any]:
    if len(objective_keys) <= 2:
        return {
            "value": float(hypervolume(front)),
            "method": "exact_recursive",
            "reference_point": {key: 0.0 for key in objective_keys},
            "objective_keys": list(objective_keys),
            "seed": None,
            "sample_count": None,
        }
    seed = 20260506
    sample_count = 4096
    return {
        "value": _monte_carlo_hypervolume(front, seed=seed, sample_count=sample_count),
        "method": "deterministic_monte_carlo",
        "reference_point": {key: 0.0 for key in objective_keys},
        "objective_keys": list(objective_keys),
        "seed": seed,
        "sample_count": sample_count,
    }


def _monte_carlo_hypervolume(
    front: list[tuple[float, ...]],
    *,
    seed: int,
    sample_count: int,
) -> float:
    clipped = [
        tuple(max(0.0, float(value)) for value in point)
        for point in front
    ]
    clipped = [point for point in clipped if any(value > 0.0 for value in point)]
    if not clipped:
        return 0.0
    dimensions = len(clipped[0])
    upper = [max(point[index] for point in clipped) for index in range(dimensions)]
    if any(value <= 0.0 for value in upper):
        return 0.0
    box_volume = math.prod(upper)
    rng = random.Random(seed)
    dominated = 0
    for _ in range(sample_count):
        probe = tuple(rng.random() * upper[index] for index in range(dimensions))
        if any(
            all(point[index] >= probe[index] for index in range(dimensions))
            for point in clipped
        ):
            dominated += 1
    return box_volume * dominated / sample_count
