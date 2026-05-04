from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Literal, Protocol

QDSearchMode = Literal["revolution", "revolution_qd"]
QDArchiveType = Literal["grid", "cvt", "grid_quantile"]
QDPhaseName = Literal["fail", "seed", "backfill", "refine", "crossover"]
QDGenerationMode = Literal["auto", "whole", "diff"]
QDArchiveDecision = Literal[
    "warmup_buffered",
    "filled_empty",
    "replaced_elite",
    "not_inserted",
]


@dataclass(frozen=True)
class QDArchiveInsertResult:
    """Describe how one successful candidate interacted with the archive."""

    cell_id: str
    inserted: bool
    replaced: bool
    decision: QDArchiveDecision
    previous_quality_score: float | None = None
    new_quality_score: float | None = None
    previous_payload: Any | None = None
    previous_descriptors: tuple[float, ...] | None = None
    current_payload: Any | None = None
    current_descriptors: tuple[float, ...] | None = None


class QDArchive(Protocol):
    """Shared archive contract for QD archive backends."""

    archive_type: QDArchiveType
    num_cells: int

    def occupied_count(self) -> int: ...

    def entries(self) -> dict[str, Any]: ...

    def cell_id_for(self, descriptors: tuple[float, ...]) -> str: ...

    def insert(
        self,
        candidate_id: str,
        descriptors: tuple[float, ...],
        quality_score: float,
        payload: Any,
    ) -> QDArchiveInsertResult: ...

    def describe_space(self) -> dict[str, Any]: ...

    def describe_assignment(self, descriptors: tuple[float, ...]) -> dict[str, Any]: ...
