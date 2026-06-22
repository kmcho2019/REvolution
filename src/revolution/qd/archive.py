from __future__ import annotations

from bisect import bisect_right
import hashlib
import json
import math
import os
import random
from dataclasses import dataclass
from typing import Any

from revolution.qd.types import (
    ArchiveMember,
    GlobalParetoInsertResult,
    QDArchiveDecision,
    QDArchiveInsertResult,
    QDCellMode,
    RankedArchiveMember,
)


@dataclass(frozen=True)
class GridAxisSpec:
    """Describe one axis in a uniform-binning grid archive."""

    name: str
    bins: int
    lower_bound: float
    upper_bound: float


GridArchiveEntry = ArchiveMember


@dataclass(frozen=True)
class FrozenCVTScaler:
    """Frozen descriptor scaler used once CVT warm-up has completed."""

    means: tuple[float, ...]
    stds: tuple[float, ...]

    def transform(self, descriptors: tuple[float, ...]) -> tuple[float, ...]:
        if len(descriptors) != len(self.means):
            raise ValueError("Descriptor dimensionality does not match CVT scaler.")
        return tuple(
            (float(value) - mean) / std
            for value, mean, std in zip(descriptors, self.means, self.stds)
        )


def active_ppa_objectives(circuit_type: str) -> tuple[str, ...]:
    """Return maximize-form PPA objectives active for one circuit type."""

    if circuit_type == "combinational":
        return ("g_P", "g_A")
    if circuit_type == "sequential":
        return ("g_P", "g_A", "g_T")
    raise ValueError(f"Unsupported circuit_type '{circuit_type}'.")


def dominates(
    left: ArchiveMember,
    right: ArchiveMember,
    objective_names: tuple[str, ...],
) -> bool:
    """Return true when left Pareto-dominates right over active objectives."""

    greater_or_equal = True
    strictly_greater = False
    for name in objective_names:
        left_value = left.objectives[name]
        right_value = right.objectives[name]
        greater_or_equal = greater_or_equal and left_value >= right_value
        strictly_greater = strictly_greater or left_value > right_value
    return greater_or_equal and strictly_greater


def _objective_key(
    member: ArchiveMember,
    objective_names: tuple[str, ...],
) -> tuple[float, ...]:
    return tuple(member.objectives[name] for name in objective_names)


def _validate_cell_mode(cell_mode: QDCellMode) -> None:
    if cell_mode not in {"scalar_elite", "pareto_front", "elite_pareto_slot"}:
        raise ValueError(f"Unsupported qd_cell_mode '{cell_mode}'.")


def _validate_cell_config(
    cell_mode: QDCellMode,
    max_elites_per_cell: int,
    objective_names: tuple[str, ...],
) -> None:
    _validate_cell_mode(cell_mode)
    if max_elites_per_cell <= 0:
        raise ValueError("max_elites_per_cell must be > 0.")
    if cell_mode in {"pareto_front", "elite_pareto_slot"} and not objective_names:
        raise ValueError(f"{cell_mode} mode requires objective_names.")
    if cell_mode == "elite_pareto_slot" and max_elites_per_cell < 2:
        raise ValueError("elite_pareto_slot mode requires max_elites_per_cell >= 2.")


def _validate_objectives(
    member: ArchiveMember,
    objective_names: tuple[str, ...],
) -> None:
    for name in objective_names:
        if name not in member.objectives:
            raise ValueError(f"Archive member is missing objective '{name}'.")


def ranked_front(
    front: list[ArchiveMember],
    objective_names: tuple[str, ...],
) -> list[RankedArchiveMember]:
    """Return transient one-based Pareto ranks and NSGA-II crowding distances."""
    if not front:
        return []
    if not objective_names:
        return [
            RankedArchiveMember(
                member=member,
                pareto_rank=1,
                crowding_distance=float("inf"),
            )
            for member in front
        ]

    remaining = list(front)
    ranked: list[RankedArchiveMember] = []
    rank = 1
    while remaining:
        current_front = [
            member
            for member in remaining
            if not any(
                other is not member and dominates(other, member, objective_names)
                for other in remaining
            )
        ]
        distances = _crowding_distances(current_front, objective_names)
        ranked.extend(
            RankedArchiveMember(member=member, pareto_rank=rank, crowding_distance=distance)
            for member, distance in zip(current_front, distances)
        )
        remaining = [
            member
            for member in remaining
            if not any(member is front_member for front_member in current_front)
        ]
        rank += 1
    by_id = {id(item.member): item for item in ranked}
    return [by_id[id(member)] for member in front]


def _member_result(
    *,
    cell_id: str,
    member: ArchiveMember,
    inserted: bool,
    replaced: bool,
    decision: QDArchiveDecision,
    previous: ArchiveMember | None,
    current: ArchiveMember | None,
    removed: list[ArchiveMember] | None,
    objective_names: tuple[str, ...],
    front: list[ArchiveMember],
    evicted: ArchiveMember | None = None,
) -> QDArchiveInsertResult:
    member_index = None
    member_rank: RankedArchiveMember | None = None
    evicted_rank: RankedArchiveMember | None = None
    ranked = ranked_front(front, objective_names)
    if current is member:
        for index, item in enumerate(ranked):
            if item.member is member:
                member_index = index
                member_rank = item
                break
    if evicted is not None:
        ranked_with_evicted = ranked_front([*front, evicted], objective_names)
        for item in ranked_with_evicted:
            if item.member is evicted:
                evicted_rank = item
                break
    return QDArchiveInsertResult(
        cell_id=cell_id,
        inserted=inserted,
        replaced=replaced,
        decision=decision,
        previous_quality_score=(
            float(previous.quality_score) if previous is not None else None
        ),
        new_quality_score=float(member.quality_score),
        previous_payload=previous.payload if previous is not None else None,
        previous_descriptors=previous.descriptors if previous is not None else None,
        current_payload=current.payload if current is not None else None,
        current_descriptors=current.descriptors if current is not None else None,
        removed_payloads=tuple(item.payload for item in removed or []),
        removed_descriptors=tuple(item.descriptors for item in removed or []),
        objectives=dict(member.objectives),
        objective_names=objective_names,
        member_index=member_index,
        front_size=len(front),
        pareto_rank=member_rank.pareto_rank if member_rank is not None else None,
        crowding_distance=(
            member_rank.crowding_distance if member_rank is not None else None
        ),
        evicted_candidate_id=evicted.candidate_id if evicted is not None else None,
        evicted_pareto_rank=(
            evicted_rank.pareto_rank if evicted_rank is not None else None
        ),
    )


def _representative(front: list[ArchiveMember]) -> ArchiveMember:
    return max(front, key=lambda member: (member.quality_score, -member.insertion_index))


def _insert_scalar(
    fronts: dict[str, list[ArchiveMember]],
    *,
    cell_id: str,
    member: ArchiveMember,
    objective_names: tuple[str, ...],
) -> QDArchiveInsertResult:
    front = fronts.get(cell_id)
    if front is None:
        fronts[cell_id] = [member]
        return _member_result(
            cell_id=cell_id,
            member=member,
            inserted=True,
            replaced=False,
            decision="filled_empty",
            previous=None,
            current=member,
            removed=None,
            objective_names=objective_names,
            front=fronts[cell_id],
        )

    current = front[0]
    if member.quality_score > current.quality_score:
        fronts[cell_id] = [member]
        return _member_result(
            cell_id=cell_id,
            member=member,
            inserted=True,
            replaced=True,
            decision="replaced_elite",
            previous=current,
            current=member,
            removed=[current],
            objective_names=objective_names,
            front=fronts[cell_id],
        )

    return _member_result(
        cell_id=cell_id,
        member=member,
        inserted=False,
        replaced=False,
        decision="not_inserted",
        previous=current,
        current=current,
        removed=None,
        objective_names=objective_names,
        front=front,
    )


def _insert_pareto(
    fronts: dict[str, list[ArchiveMember]],
    *,
    cell_id: str,
    member: ArchiveMember,
    max_elites_per_cell: int,
    objective_names: tuple[str, ...],
) -> QDArchiveInsertResult:
    _validate_objectives(member, objective_names)
    front = fronts.get(cell_id)
    if front is None:
        fronts[cell_id] = [member]
        return _member_result(
            cell_id=cell_id,
            member=member,
            inserted=True,
            replaced=False,
            decision="filled_empty",
            previous=None,
            current=member,
            removed=None,
            objective_names=objective_names,
            front=fronts[cell_id],
        )

    member_key = _objective_key(member, objective_names)
    for existing in front:
        if _objective_key(existing, objective_names) == member_key:
            return _member_result(
                cell_id=cell_id,
                member=member,
                inserted=False,
                replaced=False,
                decision="duplicate_objectives",
                previous=existing,
                current=existing,
                removed=None,
                objective_names=objective_names,
                front=front,
            )

    kept = [*front, member]
    removed: list[ArchiveMember] = []
    evicted = None
    if len(kept) > max_elites_per_cell:
        evicted = _ranked_eviction(kept, objective_names)
        kept = [existing for existing in kept if existing is not evicted]
        removed.append(evicted)
    fronts[cell_id] = kept

    inserted = member is not evicted
    decision = "crowding_evicted" if evicted is not None else "pareto_inserted"
    current = member if inserted else (_representative(kept) if kept else None)
    return _member_result(
        cell_id=cell_id,
        member=member,
        inserted=inserted,
        replaced=bool(removed and inserted),
        decision=decision,
        previous=removed[0] if removed else None,
        current=current,
        removed=removed,
        objective_names=objective_names,
        front=kept,
        evicted=evicted,
    )


def _insert_elite_pareto_slot(
    fronts: dict[str, list[ArchiveMember]],
    *,
    cell_id: str,
    member: ArchiveMember,
    max_elites_per_cell: int,
    objective_names: tuple[str, ...],
) -> QDArchiveInsertResult:
    _validate_objectives(member, objective_names)
    front = fronts.get(cell_id)
    if front is None:
        fronts[cell_id] = [member]
        return _member_result(
            cell_id=cell_id,
            member=member,
            inserted=True,
            replaced=False,
            decision="filled_empty",
            previous=None,
            current=member,
            removed=None,
            objective_names=objective_names,
            front=fronts[cell_id],
        )

    member_key = _objective_key(member, objective_names)
    for existing in front:
        if _objective_key(existing, objective_names) == member_key:
            return _member_result(
                cell_id=cell_id,
                member=member,
                inserted=False,
                replaced=False,
                decision="duplicate_objectives",
                previous=existing,
                current=existing,
                removed=None,
                objective_names=objective_names,
                front=front,
            )

    previous_elite = _representative(front)
    candidates = [*front, member]
    elite = _representative(candidates)
    slots = sorted(
        (item for item in ranked_front(candidates, objective_names) if item.member is not elite),
        key=lambda item: (
            item.pareto_rank,
            -item.crowding_distance,
            item.member.insertion_index,
            item.member.candidate_id,
        ),
    )
    kept = [elite, *(item.member for item in slots[: max_elites_per_cell - 1])]
    removed = [existing for existing in front if not any(existing is item for item in kept)]
    inserted = any(item is member for item in kept)
    fronts[cell_id] = kept

    if inserted:
        elite_replaced = member is elite and previous_elite is not elite
        decision: QDArchiveDecision = (
            "replaced_elite" if elite_replaced else "pareto_inserted"
        )
        return _member_result(
            cell_id=cell_id,
            member=member,
            inserted=True,
            replaced=elite_replaced or bool(removed),
            decision=decision,
            previous=previous_elite if elite_replaced else (removed[0] if removed else None),
            current=member,
            removed=removed,
            objective_names=objective_names,
            front=kept,
            evicted=removed[0] if removed else None,
        )

    current = _representative(kept)
    return _member_result(
        cell_id=cell_id,
        member=member,
        inserted=False,
        replaced=False,
        decision="crowding_evicted",
        previous=current,
        current=current,
        removed=None,
        objective_names=objective_names,
        front=kept,
        evicted=member,
    )


def _crowding_distances(
    members: list[ArchiveMember],
    objective_names: tuple[str, ...],
) -> list[float]:
    if not members:
        return []
    distances = [0.0 for _ in members]
    for name in objective_names:
        ordered = sorted(range(len(members)), key=lambda index: members[index].objectives[name])
        distances[ordered[0]] = float("inf")
        distances[ordered[-1]] = float("inf")
        lower = members[ordered[0]].objectives[name]
        upper = members[ordered[-1]].objectives[name]
        if upper == lower:
            continue
        for ordered_index in range(1, len(ordered) - 1):
            front_index = ordered[ordered_index]
            if distances[front_index] == float("inf"):
                continue
            previous_value = members[ordered[ordered_index - 1]].objectives[name]
            next_value = members[ordered[ordered_index + 1]].objectives[name]
            distances[front_index] += (next_value - previous_value) / (upper - lower)
    return distances


def _ranked_eviction(
    front: list[ArchiveMember],
    objective_names: tuple[str, ...],
) -> ArchiveMember:
    ranked = ranked_front(front, objective_names)
    worst_rank = max(item.pareto_rank for item in ranked)
    candidates = [item for item in ranked if item.pareto_rank == worst_rank]
    evicted_index = min(
        range(len(candidates)),
        key=lambda index: (
            candidates[index].crowding_distance,
            -candidates[index].member.insertion_index,
            candidates[index].member.candidate_id,
        ),
    )
    return candidates[evicted_index].member


def _front_stats(fronts: dict[str, list[ArchiveMember]]) -> dict[str, Any]:
    sizes = [len(front) for front in fronts.values()]
    total_members = sum(sizes)
    return {
        "occupied_cells": len(fronts),
        "total_archive_members": total_members,
        "mean_front_size": (total_members / len(sizes)) if sizes else 0.0,
        "max_front_size": max(sizes) if sizes else 0,
    }


def _ranked_members(
    fronts: dict[str, list[ArchiveMember]],
    objective_names: tuple[str, ...],
) -> list[tuple[str, RankedArchiveMember]]:
    return [
        (cell_id, ranked_member)
        for cell_id in sorted(fronts)
        for ranked_member in ranked_front(fronts[cell_id], objective_names)
    ]


class GlobalParetoArchive:
    """Per-problem read-only final Pareto frontier for archiveable candidates."""

    def __init__(self, objective_names: tuple[str, ...]) -> None:
        if not objective_names:
            raise ValueError("GlobalParetoArchive requires objective_names.")
        self.objective_names = tuple(objective_names)
        self._members: list[ArchiveMember] = []

    def members(self) -> list[ArchiveMember]:
        return list(self._members)

    def insert(self, member: ArchiveMember) -> GlobalParetoInsertResult:
        _validate_objectives(member, self.objective_names)
        member_key = _objective_key(member, self.objective_names)
        for existing in self._members:
            if _objective_key(existing, self.objective_names) == member_key:
                return GlobalParetoInsertResult(
                    inserted=False,
                    reject_reason="duplicate_objectives",
                    removed_count=0,
                    archive_size=len(self._members),
                )
            if dominates(existing, member, self.objective_names):
                return GlobalParetoInsertResult(
                    inserted=False,
                    reject_reason="dominated",
                    removed_count=0,
                    archive_size=len(self._members),
                )

        kept = [
            existing
            for existing in self._members
            if not dominates(member, existing, self.objective_names)
        ]
        removed_count = len(self._members) - len(kept)
        kept.append(member)
        self._members = kept
        return GlobalParetoInsertResult(
            inserted=True,
            reject_reason=None,
            removed_count=removed_count,
            archive_size=len(self._members),
        )


class GridArchive:
    """Uniform-binning MAP-Elites archive for reduced-axis debug runs."""

    archive_type = "grid"

    def __init__(
        self,
        axes: list[GridAxisSpec] | tuple[GridAxisSpec, ...],
        *,
        cell_mode: QDCellMode = "scalar_elite",
        max_elites_per_cell: int = 1,
        objective_names: tuple[str, ...] = (),
    ) -> None:
        if not axes:
            raise ValueError("GridArchive requires at least one axis.")
        _validate_cell_config(cell_mode, max_elites_per_cell, tuple(objective_names))
        for axis in axes:
            if axis.bins <= 0:
                raise ValueError("Grid axis bins must be > 0.")
            if axis.upper_bound <= axis.lower_bound:
                raise ValueError("Grid axis upper_bound must exceed lower_bound.")
        self.axes = tuple(axes)
        self.cell_mode = cell_mode
        self.max_elites_per_cell = int(max_elites_per_cell)
        self.objective_names = tuple(objective_names)
        self.num_cells = math.prod(axis.bins for axis in self.axes)
        self._fronts: dict[str, list[ArchiveMember]] = {}

    def occupied_count(self) -> int:
        return len(self._fronts)

    def entries(self) -> dict[str, GridArchiveEntry]:
        return {
            cell_id: _representative(front)
            for cell_id, front in self._fronts.items()
        }

    def members(self) -> list[tuple[str, ArchiveMember]]:
        return [
            (cell_id, member)
            for cell_id in sorted(self._fronts)
            for member in self._fronts[cell_id]
        ]

    def ranked_members(self) -> list[tuple[str, RankedArchiveMember]]:
        return _ranked_members(self._fronts, self.objective_names)

    def describe_space(self) -> dict[str, Any]:
        """Return a machine-readable description of the current grid geometry."""
        total_cells = 1
        axes_payload = []
        for axis in self.axes:
            total_cells *= axis.bins
            bin_width = (axis.upper_bound - axis.lower_bound) / axis.bins
            intervals = []
            for index in range(axis.bins):
                lower = axis.lower_bound + index * bin_width
                upper = axis.upper_bound if index == axis.bins - 1 else lower + bin_width
                intervals.append(
                    {
                        "index": index,
                        "lower_bound": lower,
                        "upper_bound": upper,
                        "upper_inclusive": index == axis.bins - 1,
                    }
                )
            axes_payload.append(
                {
                    "name": axis.name,
                    "bins": axis.bins,
                    "lower_bound": axis.lower_bound,
                    "upper_bound": axis.upper_bound,
                    "bin_width": bin_width,
                    "intervals": intervals,
                }
            )
        payload = {
            "archive_type": self.archive_type,
            "num_cells": self.num_cells,
            "occupied_cells": self.occupied_count(),
            "cell_mode": self.cell_mode,
            "max_elites_per_cell": self.max_elites_per_cell,
            "objective_names": list(self.objective_names),
            "assignment_rule": "uniform grid binning over descriptor axes",
            "cell_id_format": "comma-separated bin indices in axis order",
            "axes": axes_payload,
            "space_geometry": {
                "axis_count": len(self.axes),
                "cell_count_derivation": " x ".join(str(axis.bins) for axis in self.axes),
                "total_cells": total_cells,
            },
        }
        payload.update(_front_stats(self._fronts))
        return payload

    def cell_id_for(self, descriptors: tuple[float, ...]) -> str:
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match grid axes.")
        bucket_indices = []
        for axis, value in zip(self.axes, descriptors):
            bucket_indices.append(self._bin_index(axis, float(value)))
        return ",".join(str(index) for index in bucket_indices)

    def describe_assignment(self, descriptors: tuple[float, ...]) -> dict[str, Any]:
        """Explain how one descriptor tuple maps into the current grid cell."""
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match grid axes.")
        cell_id = self.cell_id_for(descriptors)
        indices = [int(index) for index in cell_id.split(",")]
        axis_details = []
        for axis, value, bin_index in zip(self.axes, descriptors, indices):
            lower, upper = self._bin_interval(axis, bin_index)
            axis_details.append(
                {
                    "axis": axis.name,
                    "value": float(value),
                    "bin_index": bin_index,
                    "lower_bound": lower,
                    "upper_bound": upper,
                    "upper_inclusive": bin_index == axis.bins - 1,
                }
            )
        return {
            "archive_type": self.archive_type,
            "cell_id": cell_id,
            "descriptor_tuple": list(descriptors),
            "indices": indices,
            "axis_details": axis_details,
        }

    def insert(self, member: ArchiveMember) -> QDArchiveInsertResult:
        cell_id = self.cell_id_for(member.descriptors)
        return self._insert_cell_member(cell_id, member)

    def rebuild_from_records(
        self,
        records: list[ArchiveMember],
        *,
        initialization_mode: str,
    ) -> dict[str, QDArchiveInsertResult]:
        _ = initialization_mode
        assert records
        axes = []
        for index, axis in enumerate(self.axes):
            values = [float(record.descriptors[index]) for record in records]
            lower = min(values)
            upper = max(values)
            if lower == upper:
                lower -= 0.5
                upper += 0.5
            axes.append(
                GridAxisSpec(
                    name=axis.name,
                    bins=axis.bins,
                    lower_bound=lower,
                    upper_bound=upper,
                )
            )
        self.axes = tuple(axes)
        self._fronts.clear()
        results = {}
        for record in records:
            results[record.candidate_id] = self.insert(record)
        return results

    def elite_for_cell(self, cell_id: str) -> GridArchiveEntry | None:
        front = self._fronts.get(cell_id)
        if front is None:
            return None
        return _representative(front)

    def front_for_cell(self, cell_id: str) -> list[ArchiveMember]:
        return list(self._fronts.get(cell_id, []))

    def _insert_cell_member(
        self,
        cell_id: str,
        member: ArchiveMember,
    ) -> QDArchiveInsertResult:
        if self.cell_mode == "scalar_elite":
            return _insert_scalar(
                self._fronts,
                cell_id=cell_id,
                member=member,
                objective_names=self.objective_names,
            )
        if self.cell_mode == "pareto_front":
            return _insert_pareto(
                self._fronts,
                cell_id=cell_id,
                member=member,
                max_elites_per_cell=self.max_elites_per_cell,
                objective_names=self.objective_names,
            )
        if self.cell_mode == "elite_pareto_slot":
            return _insert_elite_pareto_slot(
                self._fronts,
                cell_id=cell_id,
                member=member,
                max_elites_per_cell=self.max_elites_per_cell,
                objective_names=self.objective_names,
            )
        raise ValueError(f"Unsupported qd_cell_mode '{self.cell_mode}'.")

    def _bin_index(self, axis: GridAxisSpec, value: float) -> int:
        clamped = min(max(value, axis.lower_bound), axis.upper_bound)
        if clamped == axis.upper_bound:
            return axis.bins - 1
        ratio = (clamped - axis.lower_bound) / (axis.upper_bound - axis.lower_bound)
        return min(axis.bins - 1, max(0, int(ratio * axis.bins)))

    def _bin_interval(self, axis: GridAxisSpec, index: int) -> tuple[float, float]:
        width = (axis.upper_bound - axis.lower_bound) / axis.bins
        lower = axis.lower_bound + index * width
        upper = axis.upper_bound if index == axis.bins - 1 else lower + width
        return lower, upper


class GridQuantileArchive:
    """Static 4-bin quantile MAP-Elites archive for journal descriptor runs."""

    archive_type = "grid_quantile"
    intended_bins_per_axis = 4
    quantile_method = "linear_interpolation_n_minus_1"

    def __init__(
        self,
        axes: list[str] | tuple[str, ...],
        *,
        warmup_successes: int,
        warmup_max_buffer: int = 0,
        cell_mode: QDCellMode = "scalar_elite",
        max_elites_per_cell: int = 1,
        objective_names: tuple[str, ...] = (),
    ) -> None:
        if not axes:
            raise ValueError("GridQuantileArchive requires at least one axis.")
        if warmup_successes <= 0:
            raise ValueError("GridQuantileArchive requires warmup_successes > 0.")
        if warmup_max_buffer < 0:
            raise ValueError("warmup_max_buffer must be >= 0.")
        if 0 < warmup_max_buffer < warmup_successes:
            raise ValueError("warmup_max_buffer must be >= warmup_successes when set.")
        _validate_cell_config(cell_mode, max_elites_per_cell, tuple(objective_names))
        self.axes = tuple(axes)
        self.cell_mode = cell_mode
        self.max_elites_per_cell = int(max_elites_per_cell)
        self.objective_names = tuple(objective_names)
        self.warmup_successes = int(warmup_successes)
        self.warmup_max_buffer = int(warmup_max_buffer)
        self.num_cells = 0
        self._fronts: dict[str, list[ArchiveMember]] = {}
        self._warmup_buffer: list[ArchiveMember] = []
        self.initialized = False
        self.initialization_sample_count = 0
        self.initialization_mode = "pending"
        self.quantile_boundaries: tuple[tuple[float, ...], ...] = tuple(
            () for _ in self.axes
        )
        self.effective_bins: tuple[int, ...] = tuple(0 for _ in self.axes)
        self.warmup_initialization_samples: list[dict[str, Any]] = []
        self.warmup_replay_results: list[dict[str, Any]] = []

    @property
    def is_initialized(self) -> bool:
        return self.initialized

    @property
    def intended_num_cells(self) -> int:
        return self.intended_bins_per_axis ** len(self.axes)

    @property
    def minimum_active_axes(self) -> int:
        return min(2, len(self.axes))

    @property
    def collapsed_axes(self) -> tuple[str, ...]:
        return tuple(
            axis for axis, bins in zip(self.axes, self.effective_bins) if bins <= 1
        )

    @property
    def quantile_boundaries_hash(self) -> str | None:
        if not self.initialized:
            return None
        payload = {
            "axes": [
                {"name": axis, "boundaries": list(boundaries)}
                for axis, boundaries in zip(self.axes, self.quantile_boundaries)
            ]
        }
        encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode(
            "utf-8"
        )
        return hashlib.sha256(encoded).hexdigest()

    def occupied_count(self) -> int:
        return len(self._fronts)

    def entries(self) -> dict[str, GridArchiveEntry]:
        return {
            cell_id: _representative(front)
            for cell_id, front in self._fronts.items()
        }

    def members(self) -> list[tuple[str, ArchiveMember]]:
        return [
            (cell_id, member)
            for cell_id in sorted(self._fronts)
            for member in self._fronts[cell_id]
        ]

    def ranked_members(self) -> list[tuple[str, RankedArchiveMember]]:
        return _ranked_members(self._fronts, self.objective_names)

    def warmup_buffer_size(self) -> int:
        return len(self._warmup_buffer)

    def describe_space(self) -> dict[str, Any]:
        axes_payload = []
        for index, axis in enumerate(self.axes):
            boundaries = self.quantile_boundaries[index]
            effective_bins = self.effective_bins[index]
            axes_payload.append(
                {
                    "name": axis,
                    "intended_bins": self.intended_bins_per_axis,
                    "effective_bins": effective_bins,
                    "quantile_boundaries": list(boundaries),
                    "collapsed": self.initialized and effective_bins <= 1,
                    "intervals": self._axis_intervals(boundaries)
                    if self.initialized
                    else [],
                }
            )
        effective_shape = list(self.effective_bins) if self.initialized else []
        payload = {
            "archive_type": self.archive_type,
            "num_cells": self.num_cells,
            "occupied_cells": self.occupied_count(),
            "cell_mode": self.cell_mode,
            "max_elites_per_cell": self.max_elites_per_cell,
            "objective_names": list(self.objective_names),
            "assignment_rule": "bisect_right over frozen quantile boundaries",
            "cell_id_format": "comma-separated bin indices in axis order",
            "axes": axes_payload,
            "intended_bins_per_axis": self.intended_bins_per_axis,
            "intended_num_cells": self.intended_num_cells,
            "initialized": self.initialized,
            "warmup_successes": self.warmup_successes,
            "minimum_active_axes": self.minimum_active_axes,
            "warmup_buffer_size": self.warmup_buffer_size(),
            "warmup_buffer_samples": [
                self._sample_payload(record, sample_role="quantile_warmup_buffered")
                for record in self._warmup_buffer
            ],
            "initialization_sample_count": self.initialization_sample_count,
            "initialization_mode": self.initialization_mode,
            "effective_shape": effective_shape,
            "active_effective_axes": (
                sum(1 for bins in self.effective_bins if bins > 1)
                if self.initialized
                else 0
            ),
            "collapsed_axes": list(self.collapsed_axes) if self.initialized else [],
            "quantile_method": self.quantile_method,
            "quantile_boundaries_hash": self.quantile_boundaries_hash,
            "warmup_initialization_samples": self.warmup_initialization_samples,
            "warmup_replay_results": self.warmup_replay_results,
            "space_geometry": {
                "axis_count": len(self.axes),
                "initialized": self.initialized,
                "intended_cell_count_derivation": " x ".join(
                    str(self.intended_bins_per_axis) for _ in self.axes
                ),
                "intended_total_cells": self.intended_num_cells,
                "effective_cell_count_derivation": (
                    " x ".join(str(bins) for bins in self.effective_bins)
                    if self.initialized
                    else "pending"
                ),
                "total_cells": self.num_cells,
            },
        }
        payload.update(_front_stats(self._fronts))
        return payload

    def describe_history_geometry(self) -> dict[str, Any]:
        payload = {
            "initialized": self.initialized,
            "effective_shape": list(self.effective_bins) if self.initialized else [],
            "active_effective_axes": (
                sum(1 for bins in self.effective_bins if bins > 1)
                if self.initialized
                else 0
            ),
            "collapsed_axes": list(self.collapsed_axes) if self.initialized else [],
            "quantile_boundaries_hash": self.quantile_boundaries_hash,
        }
        if not self.initialized:
            payload.update(
                {
                    "warmup_successes": self.warmup_successes,
                    "warmup_buffer_size": self.warmup_buffer_size(),
                    "intended_num_cells": self.intended_num_cells,
                }
            )
        return payload

    def cell_id_for(self, descriptors: tuple[float, ...]) -> str:
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match grid_quantile axes.")
        if not self.initialized:
            raise ValueError("GridQuantileArchive cell assignment is unavailable before warm-up completes.")
        indices = [
            bisect_right(boundaries, float(value))
            for boundaries, value in zip(self.quantile_boundaries, descriptors)
        ]
        return ",".join(str(index) for index in indices)

    def describe_assignment(self, descriptors: tuple[float, ...]) -> dict[str, Any]:
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match grid_quantile axes.")
        if not self.initialized:
            return {
                "archive_type": self.archive_type,
                "initialized": False,
                "descriptor_tuple": list(descriptors),
                "warmup_successes": self.warmup_successes,
                "warmup_buffer_size": self.warmup_buffer_size(),
                "assignment_status": "warmup_pending",
            }
        indices = [int(index) for index in self.cell_id_for(descriptors).split(",")]
        axis_details = []
        for axis, value, boundaries, bin_index in zip(
            self.axes,
            descriptors,
            self.quantile_boundaries,
            indices,
        ):
            axis_details.append(
                {
                    "axis": axis,
                    "value": float(value),
                    "bin_index": bin_index,
                    "boundaries": list(boundaries),
                    "boundary_rule": "exact boundary values map to the higher bin",
                }
            )
        return {
            "archive_type": self.archive_type,
            "initialized": True,
            "cell_id": ",".join(str(index) for index in indices),
            "descriptor_tuple": list(descriptors),
            "indices": indices,
            "axis_details": axis_details,
        }

    def insert(self, member: ArchiveMember) -> QDArchiveInsertResult:
        descriptors = member.descriptors
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match grid_quantile axes.")
        if not self.initialized:
            self._warmup_buffer.append(member)
            warmup_index = len(self._warmup_buffer)
            if warmup_index >= self.warmup_successes and self._warmup_geometry_ready():
                self._initialize_from_warmup()
            elif self.warmup_max_buffer and warmup_index >= self.warmup_max_buffer:
                # Patience fallback: degenerate descriptor axes (no quantile
                # boundaries possible) must not buffer forever - initialize
                # the collapsed space so elites, archive context, and
                # ks-rebinning can still operate in-run.
                self._initialize_from_warmup("warmup_patience_fallback")
            return QDArchiveInsertResult(
                cell_id=f"warmup:{warmup_index}",
                inserted=False,
                replaced=False,
                decision="warmup_buffered",
                previous_quality_score=None,
                new_quality_score=float(member.quality_score),
                previous_payload=None,
                previous_descriptors=None,
                current_payload=None,
                current_descriptors=None,
                objectives=dict(member.objectives),
                objective_names=self.objective_names,
            )
        return self._insert_initialized(member)

    def finalize_pending(self) -> dict[str, QDArchiveInsertResult]:
        if self.initialized or not self._warmup_buffer:
            return {}
        if len(self._warmup_buffer) < self.warmup_successes:
            return {}
        return self._initialize_from_warmup("run_finalization_fallback")

    def rebuild_from_records(
        self,
        records: list[ArchiveMember],
        *,
        initialization_mode: str,
    ) -> dict[str, QDArchiveInsertResult]:
        assert records
        self._warmup_buffer.clear()
        self._fronts.clear()
        self.quantile_boundaries = self._boundaries_for_records(records)
        self.effective_bins = tuple(
            len(boundaries) + 1 for boundaries in self.quantile_boundaries
        )
        self.num_cells = math.prod(self.effective_bins)
        self.initialized = True
        self.initialization_mode = initialization_mode
        self.initialization_sample_count = len(records)
        self.warmup_replay_results = []
        results = {}
        for record in records:
            result = self._insert_initialized(record)
            results[record.candidate_id] = result
        return results

    def elite_for_cell(self, cell_id: str) -> GridArchiveEntry | None:
        front = self._fronts.get(cell_id)
        if front is None:
            return None
        return _representative(front)

    def front_for_cell(self, cell_id: str) -> list[ArchiveMember]:
        return list(self._fronts.get(cell_id, []))

    def _initialize_from_warmup(
        self,
        initialization_mode: str = "warmup_complete",
    ) -> dict[str, QDArchiveInsertResult]:
        warmup_records = list(self._warmup_buffer)
        self._warmup_buffer.clear()
        self.quantile_boundaries = self._boundaries_for_records(warmup_records)
        self.effective_bins = tuple(
            len(boundaries) + 1 for boundaries in self.quantile_boundaries
        )
        self.num_cells = math.prod(self.effective_bins)
        self.initialized = True
        self.initialization_mode = initialization_mode
        self.initialization_sample_count = len(warmup_records)
        self.warmup_initialization_samples = [
            self._sample_payload(record, sample_role="quantile_warmup_initialization")
            for record in warmup_records
        ]
        self.warmup_replay_results = []
        results = {}
        for record in warmup_records:
            previous_entry = self.elite_for_cell(self.cell_id_for(record.descriptors))
            result = self._insert_initialized(record)
            replay = self._sample_payload(record, sample_role="quantile_warmup_replay")
            replay.update(
                {
                    "cell_id": result.cell_id,
                    "decision": result.decision,
                    "inserted": result.inserted,
                    "replaced": result.replaced,
                    "previous_candidate_id": (
                        previous_entry.candidate_id if previous_entry is not None else None
                    ),
                }
            )
            self.warmup_replay_results.append(replay)
            results[record.candidate_id] = result
        return results

    def _warmup_geometry_ready(self) -> bool:
        boundaries = self._boundaries_for_records(self._warmup_buffer)
        return sum(1 for axis in boundaries if axis) >= self.minimum_active_axes

    def _boundaries_for_records(
        self,
        records: list[ArchiveMember],
    ) -> tuple[tuple[float, ...], ...]:
        descriptor_samples = [record.descriptors for record in records]
        return tuple(
            self._axis_quantile_boundaries(
                [sample[index] for sample in descriptor_samples]
            )
            for index in range(len(self.axes))
        )

    def _insert_initialized(self, member: ArchiveMember) -> QDArchiveInsertResult:
        cell_id = self.cell_id_for(member.descriptors)
        return self._insert_cell_member(cell_id, member)

    def _insert_cell_member(
        self,
        cell_id: str,
        member: ArchiveMember,
    ) -> QDArchiveInsertResult:
        if self.cell_mode == "scalar_elite":
            return _insert_scalar(
                self._fronts,
                cell_id=cell_id,
                member=member,
                objective_names=self.objective_names,
            )
        if self.cell_mode == "pareto_front":
            return _insert_pareto(
                self._fronts,
                cell_id=cell_id,
                member=member,
                max_elites_per_cell=self.max_elites_per_cell,
                objective_names=self.objective_names,
            )
        if self.cell_mode == "elite_pareto_slot":
            return _insert_elite_pareto_slot(
                self._fronts,
                cell_id=cell_id,
                member=member,
                max_elites_per_cell=self.max_elites_per_cell,
                objective_names=self.objective_names,
            )
        raise ValueError(f"Unsupported qd_cell_mode '{self.cell_mode}'.")

    def _axis_quantile_boundaries(self, values: list[float]) -> tuple[float, ...]:
        sorted_values = sorted(float(value) for value in values)
        if sorted_values[0] == sorted_values[-1]:
            return ()
        boundaries = [
            self._quantile(sorted_values, 0.25),
            self._quantile(sorted_values, 0.5),
            self._quantile(sorted_values, 0.75),
        ]
        return tuple(sorted(set(boundaries)))

    def _quantile(self, sorted_values: list[float], probability: float) -> float:
        position = probability * (len(sorted_values) - 1)
        lower_index = math.floor(position)
        upper_index = math.ceil(position)
        if lower_index == upper_index:
            return sorted_values[lower_index]
        fraction = position - lower_index
        lower = sorted_values[lower_index]
        upper = sorted_values[upper_index]
        return lower + (upper - lower) * fraction

    def _axis_intervals(self, boundaries: tuple[float, ...]) -> list[dict[str, Any]]:
        return [
            {
                "index": index,
                "lower_bound": None if index == 0 else boundaries[index - 1],
                "upper_bound": None if index == len(boundaries) else boundaries[index],
                "lower_inclusive": index > 0,
                "upper_inclusive": False,
            }
            for index in range(len(boundaries) + 1)
        ]

    def _sample_payload(
        self,
        record: ArchiveMember,
        *,
        sample_role: str,
    ) -> dict[str, Any]:
        payload = record.payload
        code_path = str(getattr(payload, "code_file_path", "") or "")
        directory = os.path.basename(os.path.dirname(code_path)) if code_path else None
        return {
            "candidate_id": record.candidate_id,
            "descriptor_tuple": list(record.descriptors),
            "quality_score": float(record.quality_score),
            "objectives": dict(record.objectives),
            "ppa_metrics": dict(getattr(payload, "ppa_metrics", {}) or {}),
            "score_components": dict(getattr(payload, "score_components", {}) or {}),
            "generation_candidate_index": getattr(payload, "generation_candidate_index", None),
            "archive_insertion_index": getattr(payload, "archive_insertion_index", None),
            "candidate_directory_basename": directory,
            "sample_role": sample_role,
        }


class CVTArchive:
    """Frozen-scaler CVT archive with warm-up buffering and nearest-centroid insertion."""

    archive_type = "cvt"

    def __init__(
        self,
        axes: list[str] | tuple[str, ...],
        *,
        num_cells: int,
        warmup_successes: int | None = None,
        centroid_seed: int = 0,
        relax_iterations: int = 5,
        sample_pool_factor: int = 32,
        cell_mode: QDCellMode = "scalar_elite",
        max_elites_per_cell: int = 1,
        objective_names: tuple[str, ...] = (),
    ) -> None:
        if not axes:
            raise ValueError("CVTArchive requires at least one axis.")
        if num_cells <= 0:
            raise ValueError("CVTArchive requires num_cells > 0.")
        _validate_cell_config(cell_mode, max_elites_per_cell, tuple(objective_names))
        self.axes = tuple(axes)
        self.cell_mode = cell_mode
        self.max_elites_per_cell = int(max_elites_per_cell)
        self.objective_names = tuple(objective_names)
        self.num_cells = int(num_cells)
        self.warmup_successes = (
            max(1, int(warmup_successes))
            if warmup_successes is not None
            else max(32, 4 * len(self.axes), math.ceil(0.5 * self.num_cells))
        )
        self.centroid_seed = int(centroid_seed)
        self.relax_iterations = max(1, int(relax_iterations))
        self.sample_pool_factor = max(4, int(sample_pool_factor))
        self._fronts: dict[str, list[ArchiveMember]] = {}
        self._warmup_buffer: list[ArchiveMember] = []
        self.scaler: FrozenCVTScaler | None = None
        self.centroids: tuple[tuple[float, ...], ...] = ()
        self.initialization_mode = "pending"
        self.initialization_sample_count = 0

    @property
    def is_initialized(self) -> bool:
        return self.scaler is not None and bool(self.centroids)

    def occupied_count(self) -> int:
        return len(self._fronts)

    def entries(self) -> dict[str, GridArchiveEntry]:
        return {
            cell_id: _representative(front)
            for cell_id, front in self._fronts.items()
        }

    def members(self) -> list[tuple[str, ArchiveMember]]:
        return [
            (cell_id, member)
            for cell_id in sorted(self._fronts)
            for member in self._fronts[cell_id]
        ]

    def ranked_members(self) -> list[tuple[str, RankedArchiveMember]]:
        return _ranked_members(self._fronts, self.objective_names)

    def warmup_buffer_size(self) -> int:
        return len(self._warmup_buffer)

    def describe_space(self) -> dict[str, Any]:
        """Return a machine-readable description of the current CVT geometry."""
        scaler_payload = None
        if self.scaler is not None:
            scaler_payload = {
                "means": list(self.scaler.means),
                "stds": list(self.scaler.stds),
            }
        payload = {
            "archive_type": self.archive_type,
            "num_cells": self.num_cells,
            "occupied_cells": self.occupied_count(),
            "cell_mode": self.cell_mode,
            "max_elites_per_cell": self.max_elites_per_cell,
            "objective_names": list(self.objective_names),
            "assignment_rule": "nearest centroid in frozen normalized descriptor space",
            "axes": list(self.axes),
            "space_geometry": {
                "axis_count": len(self.axes),
                "warmup_successes": self.warmup_successes,
                "warmup_buffer_size": self.warmup_buffer_size(),
                "initialized": self.is_initialized,
                "initialization_mode": self.initialization_mode,
                "initialization_sample_count": self.initialization_sample_count,
                "centroid_count": len(self.centroids),
                "centroids": [list(centroid) for centroid in self.centroids],
                "scaler": scaler_payload,
            },
        }
        payload.update(_front_stats(self._fronts))
        return payload

    def cell_id_for(self, descriptors: tuple[float, ...]) -> str:
        if not self.is_initialized:
            raise ValueError("CVTArchive cell assignment is unavailable before warm-up completes.")
        assert self.scaler is not None
        transformed = self.scaler.transform(descriptors)
        return str(self._nearest_centroid_index(transformed))

    def describe_assignment(self, descriptors: tuple[float, ...]) -> dict[str, Any]:
        """Explain how one descriptor tuple maps into the current CVT cell."""
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match CVT axes.")
        if not self.is_initialized:
            return {
                "archive_type": self.archive_type,
                "initialized": False,
                "descriptor_tuple": list(descriptors),
                "warmup_successes": self.warmup_successes,
                "warmup_buffer_size": self.warmup_buffer_size(),
                "initialization_mode": self.initialization_mode,
                "assignment_status": "warmup_pending",
            }
        assert self.scaler is not None
        transformed = self.scaler.transform(descriptors)
        centroid_index = self._nearest_centroid_index(transformed)
        centroid = self.centroids[centroid_index]
        distance_sq = sum((lhs - rhs) ** 2 for lhs, rhs in zip(transformed, centroid))
        return {
            "archive_type": self.archive_type,
            "initialized": True,
            "cell_id": str(centroid_index),
            "descriptor_tuple": list(descriptors),
            "scaled_descriptor_tuple": list(transformed),
            "centroid": list(centroid),
            "distance_sq": distance_sq,
            "assignment_status": "assigned_to_frozen_centroid",
        }

    def insert(self, member: ArchiveMember) -> QDArchiveInsertResult:
        descriptors = member.descriptors
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match CVT axes.")
        if not self.is_initialized:
            self._warmup_buffer.append(member)
            if len(self._warmup_buffer) < self.warmup_successes:
                return QDArchiveInsertResult(
                    cell_id=f"warmup:{len(self._warmup_buffer)}",
                    inserted=False,
                    replaced=False,
                    decision="warmup_buffered",
                    previous_quality_score=None,
                    new_quality_score=float(member.quality_score),
                    previous_payload=None,
                    previous_descriptors=None,
                    current_payload=None,
                    current_descriptors=None,
                    objectives=dict(member.objectives),
                    objective_names=self.objective_names,
                )
            init_results = self._initialize_from_warmup()
            return init_results.get(
                member.candidate_id,
                QDArchiveInsertResult(
                    cell_id="warmup",
                    inserted=False,
                    replaced=False,
                    decision="warmup_buffered",
                    previous_quality_score=None,
                    new_quality_score=float(member.quality_score),
                    previous_payload=None,
                    previous_descriptors=None,
                    current_payload=None,
                    current_descriptors=None,
                    objectives=dict(member.objectives),
                    objective_names=self.objective_names,
                ),
            )

        return self._insert_initialized(member)

    def finalize_pending(self) -> dict[str, QDArchiveInsertResult]:
        """Initialize from the current warmup buffer when the run is ending."""
        if self.is_initialized:
            return {}
        if not self._warmup_buffer:
            return {}
        warmup_records = self._consume_warmup_records()
        return self._initialize_records(
            warmup_records,
            initialization_mode="run_finalization_fallback",
        )

    def rebuild_from_records(
        self,
        records: list[ArchiveMember],
        *,
        initialization_mode: str,
    ) -> dict[str, QDArchiveInsertResult]:
        assert records
        self._fronts.clear()
        self._warmup_buffer.clear()
        return self._initialize_records(
            records,
            initialization_mode=initialization_mode,
        )

    def elite_for_cell(self, cell_id: str) -> GridArchiveEntry | None:
        front = self._fronts.get(cell_id)
        if front is None:
            return None
        return _representative(front)

    def front_for_cell(self, cell_id: str) -> list[ArchiveMember]:
        return list(self._fronts.get(cell_id, []))

    def _initialize_from_warmup(self) -> dict[str, QDArchiveInsertResult]:
        warmup_records = self._consume_warmup_records()
        return self._initialize_records(
            warmup_records,
            initialization_mode="warmup_complete",
        )

    def _consume_warmup_records(self) -> list[ArchiveMember]:
        warmup_records = list(self._warmup_buffer)
        self._warmup_buffer.clear()
        return warmup_records

    def _initialize_records(
        self,
        warmup_records: list[ArchiveMember],
        *,
        initialization_mode: str,
    ) -> dict[str, QDArchiveInsertResult]:
        if not warmup_records:
            return {}

        descriptor_samples = [record.descriptors for record in warmup_records]
        self.scaler = self._fit_scaler(descriptor_samples)
        self.centroids = self._generate_centroids(
            len(self.axes),
            seed=self.centroid_seed,
            num_cells=self.num_cells,
        )
        self.initialization_mode = initialization_mode
        self.initialization_sample_count = len(warmup_records)

        results: dict[str, QDArchiveInsertResult] = {}
        for record in warmup_records:
            results[record.candidate_id] = self._insert_initialized(record)
        return results

    def _insert_initialized(self, member: ArchiveMember) -> QDArchiveInsertResult:
        assert self.scaler is not None
        descriptors = member.descriptors
        transformed = self.scaler.transform(descriptors)
        cell_id = str(self._nearest_centroid_index(transformed))
        return self._insert_cell_member(cell_id, member)

    def _insert_cell_member(
        self,
        cell_id: str,
        member: ArchiveMember,
    ) -> QDArchiveInsertResult:
        if self.cell_mode == "scalar_elite":
            return _insert_scalar(
                self._fronts,
                cell_id=cell_id,
                member=member,
                objective_names=self.objective_names,
            )
        if self.cell_mode == "pareto_front":
            return _insert_pareto(
                self._fronts,
                cell_id=cell_id,
                member=member,
                max_elites_per_cell=self.max_elites_per_cell,
                objective_names=self.objective_names,
            )
        if self.cell_mode == "elite_pareto_slot":
            return _insert_elite_pareto_slot(
                self._fronts,
                cell_id=cell_id,
                member=member,
                max_elites_per_cell=self.max_elites_per_cell,
                objective_names=self.objective_names,
            )
        raise ValueError(f"Unsupported qd_cell_mode '{self.cell_mode}'.")

    def _nearest_centroid_index(self, transformed: tuple[float, ...]) -> int:
        best_index = 0
        best_distance = float("inf")
        for index, centroid in enumerate(self.centroids):
            distance = sum(
                (value - center) ** 2 for value, center in zip(transformed, centroid)
            )
            if distance < best_distance:
                best_distance = distance
                best_index = index
        return best_index

    def _fit_scaler(
        self,
        descriptors: list[tuple[float, ...]],
    ) -> FrozenCVTScaler:
        means: list[float] = []
        stds: list[float] = []
        for index in range(len(self.axes)):
            values = [float(sample[index]) for sample in descriptors]
            mean = sum(values) / max(len(values), 1)
            variance = sum((value - mean) ** 2 for value in values) / max(len(values), 1)
            means.append(mean)
            stds.append(max(math.sqrt(variance), 1e-6))
        return FrozenCVTScaler(means=tuple(means), stds=tuple(stds))

    def _generate_centroids(
        self,
        dim: int,
        *,
        seed: int,
        num_cells: int,
    ) -> tuple[tuple[float, ...], ...]:
        rng = random.Random(seed)
        centroids = [
            [rng.uniform(-1.0, 1.0) for _ in range(dim)]
            for _ in range(num_cells)
        ]
        sample_count = num_cells * self.sample_pool_factor
        for _ in range(self.relax_iterations):
            sums = [[0.0 for _ in range(dim)] for _ in range(num_cells)]
            counts = [0 for _ in range(num_cells)]
            for _ in range(sample_count):
                point = [rng.uniform(-1.0, 1.0) for _ in range(dim)]
                nearest = 0
                nearest_distance = float("inf")
                for index, centroid in enumerate(centroids):
                    distance = sum(
                        (value - center) ** 2
                        for value, center in zip(point, centroid)
                    )
                    if distance < nearest_distance:
                        nearest = index
                        nearest_distance = distance
                counts[nearest] += 1
                for axis_index, value in enumerate(point):
                    sums[nearest][axis_index] += value
            for index, centroid in enumerate(centroids):
                if counts[index] == 0:
                    centroids[index] = [rng.uniform(-1.0, 1.0) for _ in range(dim)]
                    continue
                centroids[index] = [
                    total / counts[index] for total in sums[index]
                ]
        return tuple(tuple(value for value in centroid) for centroid in centroids)
