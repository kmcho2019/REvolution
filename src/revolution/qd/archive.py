from __future__ import annotations

from bisect import bisect_right
import hashlib
import json
import math
import os
import random
from dataclasses import dataclass
from typing import Any

from revolution.qd.types import QDArchiveInsertResult


@dataclass(frozen=True)
class GridAxisSpec:
    """Describe one axis in a uniform-binning grid archive."""

    name: str
    bins: int
    lower_bound: float
    upper_bound: float


@dataclass
class GridArchiveEntry:
    """Archive occupant payload for one archive cell."""

    candidate_id: str
    descriptors: tuple[float, ...]
    quality_score: float
    payload: Any


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
        return {
            "archive_type": self.archive_type,
            "num_cells": self.num_cells,
            "occupied_cells": self.occupied_count(),
            "assignment_rule": "uniform grid binning over descriptor axes",
            "cell_id_format": "comma-separated bin indices in axis order",
            "axes": axes_payload,
            "space_geometry": {
                "axis_count": len(self.axes),
                "cell_count_derivation": " x ".join(str(axis.bins) for axis in self.axes),
                "total_cells": total_cells,
            },
        }

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
                decision="filled_empty",
                previous_quality_score=None,
                new_quality_score=float(quality_score),
                previous_payload=None,
                previous_descriptors=None,
                current_payload=payload,
                current_descriptors=descriptors,
            )

        if float(quality_score) > float(entry.quality_score):
            previous = float(entry.quality_score)
            previous_payload = entry.payload
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
                decision="replaced_elite",
                previous_quality_score=previous,
                new_quality_score=float(quality_score),
                previous_payload=previous_payload,
                previous_descriptors=entry.descriptors,
                current_payload=payload,
                current_descriptors=descriptors,
            )

        return QDArchiveInsertResult(
            cell_id=cell_id,
            inserted=False,
            replaced=False,
            decision="not_inserted",
            previous_quality_score=float(entry.quality_score),
            new_quality_score=float(quality_score),
            previous_payload=entry.payload,
            previous_descriptors=entry.descriptors,
            current_payload=entry.payload,
            current_descriptors=entry.descriptors,
        )

    def elite_for_cell(self, cell_id: str) -> GridArchiveEntry | None:
        return self._entries.get(cell_id)

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
    ) -> None:
        if not axes:
            raise ValueError("GridQuantileArchive requires at least one axis.")
        if warmup_successes <= 0:
            raise ValueError("GridQuantileArchive requires warmup_successes > 0.")
        self.axes = tuple(axes)
        self.warmup_successes = int(warmup_successes)
        self.num_cells = 0
        self._entries: dict[str, GridArchiveEntry] = {}
        self._warmup_buffer: list[tuple[str, tuple[float, ...], float, Any]] = []
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
        return len(self._entries)

    def entries(self) -> dict[str, GridArchiveEntry]:
        return dict(self._entries)

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
        return {
            "archive_type": self.archive_type,
            "num_cells": self.num_cells,
            "occupied_cells": self.occupied_count(),
            "assignment_rule": "bisect_right over frozen quantile boundaries",
            "cell_id_format": "comma-separated bin indices in axis order",
            "axes": axes_payload,
            "intended_bins_per_axis": self.intended_bins_per_axis,
            "intended_num_cells": self.intended_num_cells,
            "initialized": self.initialized,
            "warmup_successes": self.warmup_successes,
            "warmup_buffer_size": self.warmup_buffer_size(),
            "warmup_buffer_samples": [
                self._sample_payload(record, sample_role="quantile_warmup_buffered")
                for record in self._warmup_buffer
            ],
            "initialization_sample_count": self.initialization_sample_count,
            "initialization_mode": self.initialization_mode,
            "effective_shape": effective_shape,
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

    def describe_history_geometry(self) -> dict[str, Any]:
        payload = {
            "initialized": self.initialized,
            "effective_shape": list(self.effective_bins) if self.initialized else [],
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

    def insert(
        self,
        candidate_id: str,
        descriptors: tuple[float, ...],
        quality_score: float,
        payload: Any,
    ) -> QDArchiveInsertResult:
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match grid_quantile axes.")
        if not self.initialized:
            self._warmup_buffer.append((candidate_id, descriptors, float(quality_score), payload))
            warmup_index = len(self._warmup_buffer)
            if warmup_index == self.warmup_successes:
                self._initialize_from_warmup()
            return QDArchiveInsertResult(
                cell_id=f"warmup:{warmup_index}",
                inserted=False,
                replaced=False,
                decision="warmup_buffered",
                previous_quality_score=None,
                new_quality_score=float(quality_score),
                previous_payload=None,
                previous_descriptors=None,
                current_payload=None,
                current_descriptors=None,
            )
        return self._insert_initialized(
            candidate_id=candidate_id,
            descriptors=descriptors,
            quality_score=float(quality_score),
            payload=payload,
        )

    def elite_for_cell(self, cell_id: str) -> GridArchiveEntry | None:
        return self._entries.get(cell_id)

    def _initialize_from_warmup(self) -> None:
        warmup_records = list(self._warmup_buffer)
        self._warmup_buffer.clear()
        descriptor_samples = [record[1] for record in warmup_records]
        self.quantile_boundaries = tuple(
            self._axis_quantile_boundaries(
                [sample[index] for sample in descriptor_samples]
            )
            for index in range(len(self.axes))
        )
        self.effective_bins = tuple(
            len(boundaries) + 1 for boundaries in self.quantile_boundaries
        )
        self.num_cells = math.prod(self.effective_bins)
        self.initialized = True
        self.initialization_mode = "warmup_complete"
        self.initialization_sample_count = len(warmup_records)
        self.warmup_initialization_samples = [
            self._sample_payload(record, sample_role="quantile_warmup_initialization")
            for record in warmup_records
        ]
        self.warmup_replay_results = []
        for record in warmup_records:
            candidate_id, descriptors, quality_score, payload = record
            previous_entry = self.elite_for_cell(self.cell_id_for(descriptors))
            result = self._insert_initialized(
                candidate_id=candidate_id,
                descriptors=descriptors,
                quality_score=quality_score,
                payload=payload,
            )
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

    def _insert_initialized(
        self,
        *,
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
                decision="filled_empty",
                previous_quality_score=None,
                new_quality_score=float(quality_score),
                previous_payload=None,
                previous_descriptors=None,
                current_payload=payload,
                current_descriptors=descriptors,
            )
        if float(quality_score) > float(entry.quality_score):
            previous = float(entry.quality_score)
            previous_payload = entry.payload
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
                decision="replaced_elite",
                previous_quality_score=previous,
                new_quality_score=float(quality_score),
                previous_payload=previous_payload,
                previous_descriptors=entry.descriptors,
                current_payload=payload,
                current_descriptors=descriptors,
            )
        return QDArchiveInsertResult(
            cell_id=cell_id,
            inserted=False,
            replaced=False,
            decision="not_inserted",
            previous_quality_score=float(entry.quality_score),
            new_quality_score=float(quality_score),
            previous_payload=entry.payload,
            previous_descriptors=entry.descriptors,
            current_payload=entry.payload,
            current_descriptors=entry.descriptors,
        )

    def _axis_quantile_boundaries(self, values: list[float]) -> tuple[float, ...]:
        sorted_values = sorted(float(value) for value in values)
        if sorted_values[0] == sorted_values[-1]:
            return ()
        boundaries = [
            self._quantile(sorted_values, 0.25),
            self._quantile(sorted_values, 0.5),
            self._quantile(sorted_values, 0.75),
        ]
        return tuple(
            sorted(
                {
                    boundary
                    for boundary in boundaries
                    if sorted_values[0] < boundary < sorted_values[-1]
                }
            )
        )

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
        record: tuple[str, tuple[float, ...], float, Any],
        *,
        sample_role: str,
    ) -> dict[str, Any]:
        candidate_id, descriptors, quality_score, payload = record
        code_path = str(getattr(payload, "code_file_path", "") or "")
        directory = os.path.basename(os.path.dirname(code_path)) if code_path else None
        return {
            "candidate_id": candidate_id,
            "descriptor_tuple": list(descriptors),
            "quality_score": float(quality_score),
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
    ) -> None:
        if not axes:
            raise ValueError("CVTArchive requires at least one axis.")
        if num_cells <= 0:
            raise ValueError("CVTArchive requires num_cells > 0.")
        self.axes = tuple(axes)
        self.num_cells = int(num_cells)
        self.warmup_successes = (
            max(1, int(warmup_successes))
            if warmup_successes is not None
            else max(32, 4 * len(self.axes), math.ceil(0.5 * self.num_cells))
        )
        self.centroid_seed = int(centroid_seed)
        self.relax_iterations = max(1, int(relax_iterations))
        self.sample_pool_factor = max(4, int(sample_pool_factor))
        self._entries: dict[str, GridArchiveEntry] = {}
        self._warmup_buffer: list[tuple[str, tuple[float, ...], float, Any]] = []
        self.scaler: FrozenCVTScaler | None = None
        self.centroids: tuple[tuple[float, ...], ...] = ()
        self.initialization_mode = "pending"
        self.initialization_sample_count = 0

    @property
    def is_initialized(self) -> bool:
        return self.scaler is not None and bool(self.centroids)

    def occupied_count(self) -> int:
        return len(self._entries)

    def entries(self) -> dict[str, GridArchiveEntry]:
        return dict(self._entries)

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
        return {
            "archive_type": self.archive_type,
            "num_cells": self.num_cells,
            "occupied_cells": self.occupied_count(),
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

    def insert(
        self,
        candidate_id: str,
        descriptors: tuple[float, ...],
        quality_score: float,
        payload: Any,
    ) -> QDArchiveInsertResult:
        if len(descriptors) != len(self.axes):
            raise ValueError("Descriptor dimensionality does not match CVT axes.")
        record = (candidate_id, descriptors, float(quality_score), payload)
        if not self.is_initialized:
            self._warmup_buffer.append(record)
            if len(self._warmup_buffer) < self.warmup_successes:
                return QDArchiveInsertResult(
                    cell_id=f"warmup:{len(self._warmup_buffer)}",
                    inserted=False,
                    replaced=False,
                    decision="warmup_buffered",
                    previous_quality_score=None,
                    new_quality_score=float(quality_score),
                    previous_payload=None,
                    previous_descriptors=None,
                    current_payload=None,
                    current_descriptors=None,
                )
            init_results = self._initialize_from_warmup()
            return init_results.get(
                candidate_id,
                QDArchiveInsertResult(
                    cell_id="warmup",
                    inserted=False,
                    replaced=False,
                    decision="warmup_buffered",
                    previous_quality_score=None,
                    new_quality_score=float(quality_score),
                    previous_payload=None,
                    previous_descriptors=None,
                    current_payload=None,
                    current_descriptors=None,
                ),
            )

        return self._insert_initialized(
            candidate_id=candidate_id,
            descriptors=descriptors,
            quality_score=float(quality_score),
            payload=payload,
        )

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

    def elite_for_cell(self, cell_id: str) -> GridArchiveEntry | None:
        return self._entries.get(cell_id)

    def _initialize_from_warmup(self) -> dict[str, QDArchiveInsertResult]:
        warmup_records = self._consume_warmup_records()
        return self._initialize_records(
            warmup_records,
            initialization_mode="warmup_complete",
        )

    def _consume_warmup_records(
        self,
    ) -> list[tuple[str, tuple[float, ...], float, Any]]:
        warmup_records = list(self._warmup_buffer)
        self._warmup_buffer.clear()
        return warmup_records

    def _initialize_records(
        self,
        warmup_records: list[tuple[str, tuple[float, ...], float, Any]],
        *,
        initialization_mode: str,
    ) -> dict[str, QDArchiveInsertResult]:
        if not warmup_records:
            return {}

        descriptor_samples = [record[1] for record in warmup_records]
        self.scaler = self._fit_scaler(descriptor_samples)
        self.centroids = self._generate_centroids(
            len(self.axes),
            seed=self.centroid_seed,
            num_cells=self.num_cells,
        )
        self.initialization_mode = initialization_mode
        self.initialization_sample_count = len(warmup_records)

        results: dict[str, QDArchiveInsertResult] = {}
        for candidate_id, descriptors, quality_score, payload in warmup_records:
            results[candidate_id] = self._insert_initialized(
                candidate_id=candidate_id,
                descriptors=descriptors,
                quality_score=quality_score,
                payload=payload,
            )
        return results

    def _insert_initialized(
        self,
        *,
        candidate_id: str,
        descriptors: tuple[float, ...],
        quality_score: float,
        payload: Any,
    ) -> QDArchiveInsertResult:
        assert self.scaler is not None
        transformed = self.scaler.transform(descriptors)
        cell_id = str(self._nearest_centroid_index(transformed))
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
                decision="filled_empty",
                previous_quality_score=None,
                new_quality_score=float(quality_score),
                previous_payload=None,
                previous_descriptors=None,
                current_payload=payload,
                current_descriptors=descriptors,
            )

        if float(quality_score) > float(entry.quality_score):
            previous = float(entry.quality_score)
            previous_payload = entry.payload
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
                decision="replaced_elite",
                previous_quality_score=previous,
                new_quality_score=float(quality_score),
                previous_payload=previous_payload,
                previous_descriptors=entry.descriptors,
                current_payload=payload,
                current_descriptors=descriptors,
            )

        return QDArchiveInsertResult(
            cell_id=cell_id,
            inserted=False,
            replaced=False,
            decision="not_inserted",
            previous_quality_score=float(entry.quality_score),
            new_quality_score=float(quality_score),
            previous_payload=entry.payload,
            previous_descriptors=entry.descriptors,
            current_payload=entry.payload,
            current_descriptors=entry.descriptors,
        )

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
