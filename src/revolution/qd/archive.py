from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Any

from revolution.qd.types import QDArchiveInsertResult


@dataclass(frozen=True)
class GridAxisSpec:
    name: str
    bins: int
    lower_bound: float
    upper_bound: float


@dataclass
class GridArchiveEntry:
    candidate_id: str
    descriptors: tuple[float, ...]
    quality_score: float
    payload: Any


class GridArchive:
    """Uniform-binning MAP-Elites archive for reduced-axis debug runs."""

    archive_type = "grid"

    def __init__(self, axes: list[GridAxisSpec] | tuple[GridAxisSpec, ...]) -> None:
        if not axes:
            raise ValueError("GridArchive requires at least one axis.")
        for axis in axes:
            if axis.bins <= 0:
                raise ValueError("Grid axis bins must be > 0.")
            if axis.upper_bound <= axis.lower_bound:
                raise ValueError("Grid axis upper_bound must exceed lower_bound.")
        self.axes = tuple(axes)
        self.num_cells = math.prod(axis.bins for axis in self.axes)
        self._entries: dict[str, GridArchiveEntry] = {}

    def occupied_count(self) -> int:
        return len(self._entries)

    def entries(self) -> dict[str, GridArchiveEntry]:
        return dict(self._entries)

    def cell_id_for(self, descriptors: tuple[float, ...]) -> str:
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match grid axes.")
        bucket_indices = []
        for axis, value in zip(self.axes, descriptors):
            bucket_indices.append(self._bin_index(axis, float(value)))
        return ",".join(str(index) for index in bucket_indices)

    def insert(
        self,
        candidate_id: str,
        descriptors: tuple[float, ...],
        quality_score: float,
        payload: Any,
    ) -> QDArchiveInsertResult:
        cell_id = self.cell_id_for(descriptors)
        entry = self._entries.get(cell_id)
        if entry is None:
            self._entries[cell_id] = GridArchiveEntry(
                candidate_id=candidate_id,
                descriptors=descriptors,
                quality_score=float(quality_score),
                payload=payload,
            )
            return QDArchiveInsertResult(
                cell_id=cell_id,
                inserted=True,
                replaced=False,
                previous_quality_score=None,
                new_quality_score=float(quality_score),
            )

        if float(quality_score) > float(entry.quality_score):
            previous = float(entry.quality_score)
            self._entries[cell_id] = GridArchiveEntry(
                candidate_id=candidate_id,
                descriptors=descriptors,
                quality_score=float(quality_score),
                payload=payload,
            )
            return QDArchiveInsertResult(
                cell_id=cell_id,
                inserted=True,
                replaced=True,
                previous_quality_score=previous,
                new_quality_score=float(quality_score),
            )

        return QDArchiveInsertResult(
            cell_id=cell_id,
            inserted=False,
            replaced=False,
            previous_quality_score=float(entry.quality_score),
            new_quality_score=float(quality_score),
        )

    def elite_for_cell(self, cell_id: str) -> GridArchiveEntry | None:
        return self._entries.get(cell_id)

    def _bin_index(self, axis: GridAxisSpec, value: float) -> int:
        clamped = min(max(value, axis.lower_bound), axis.upper_bound)
        if clamped == axis.upper_bound:
            return axis.bins - 1
        ratio = (clamped - axis.lower_bound) / (axis.upper_bound - axis.lower_bound)
        return min(axis.bins - 1, max(0, int(ratio * axis.bins)))
