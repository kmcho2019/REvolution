from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Literal, Protocol

QDSearchMode = Literal["revolution", "revolution_qd"]
QDArchiveType = Literal["grid", "cvt"]
QDPhaseName = Literal["fail", "seed", "backfill", "refine", "crossover"]
QDGenerationMode = Literal["auto", "whole", "diff"]


@dataclass(frozen=True)
class QDArchiveInsertResult:
    cell_id: str
    inserted: bool
    replaced: bool
    previous_quality_score: float | None = None
    new_quality_score: float | None = None


class QDArchive(Protocol):
    """Shared archive contract for grid/CVT backends."""

    archive_type: QDArchiveType
    num_cells: int

    def occupied_count(self) -> int: ...

    def insert(
        self,
        candidate_id: str,
        descriptors: tuple[float, ...],
        quality_score: float,
        payload: Any,
    ) -> QDArchiveInsertResult: ...
