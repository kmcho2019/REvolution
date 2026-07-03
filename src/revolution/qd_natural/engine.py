"""Lane N02: cell-curiosity weighted NSGA-II parent draws.

``NaturalQDEngine`` changes exactly one mechanism relative to the
Smooth-QD V2 platform: one-parent draws from the NSGA-II global pool
are weighted by inverse archive-cell occupancy instead of uniform.
Pool construction, champion lane, operators, and the C-F two-parent
path are inherited unchanged from ``QDEngine``.
"""

from __future__ import annotations

import random
from collections import Counter
from typing import Any, cast

from revolution.algorithm import Heuristic
from revolution.qd.archive import ranked_front
from revolution.qd.engine import QDEngine
from revolution.qd.types import ArchiveMember


def curiosity_pool(
    members_with_cells: list[tuple[str, ArchiveMember]],
    objective_names: tuple[str, ...],
    pool_size: int,
    gamma: float,
) -> tuple[list[Heuristic], list[float]]:
    """NSGA-II-ranked parent pool with inverse-cell-occupancy draw weights.

    Pool construction mirrors ``QDEngine._nsga2_global_pool`` (doc 16,
    smooth-QD V2): rank every success member by global non-domination
    rank, crowding distance, insertion index, and candidate id, then
    keep the top ``pool_size``. Each kept member's draw weight is
    ``(1 / occupancy(cell)) ** gamma`` with occupancy counted over the
    full success archive, so members in under-populated cells are drawn
    more often.

    Args:
        members_with_cells: ``(cell_id, member)`` pairs from
            ``success_archive.members()``.
        objective_names: Maximize-form objective keys for ranking.
        pool_size: Pool cap (the V2 rule uses ``population_size``).
        gamma: Curiosity exponent; must be positive (0 would silently
            reproduce plain V2 — run that as the V2 arm instead).

    Returns:
        Parallel lists: pool payloads and their draw weights.
    """
    assert gamma > 0.0
    assert pool_size >= 1
    if not members_with_cells:
        return [], []
    occupancy = Counter(cell_id for cell_id, _ in members_with_cells)
    cell_by_candidate = {
        member.candidate_id: cell_id for cell_id, member in members_with_cells
    }
    ranked = ranked_front(
        [member for _, member in members_with_cells], objective_names
    )
    ranked.sort(
        key=lambda item: (
            item.pareto_rank,
            -item.crowding_distance,
            item.member.insertion_index,
            item.member.candidate_id,
        )
    )
    kept = ranked[:pool_size]
    pool = [cast(Heuristic, item.member.payload) for item in kept]
    weights = [
        (1.0 / occupancy[cell_by_candidate[item.member.candidate_id]]) ** gamma
        for item in kept
    ]
    return pool, weights


class NaturalQDEngine(QDEngine):
    """QDEngine with curiosity-weighted one-parent draws (lane N02)."""

    def __init__(self, *, qd_curiosity_gamma: float, **kwargs: Any) -> None:
        super().__init__(**kwargs)
        assert qd_curiosity_gamma > 0.0
        assert self.qd_parent_selection == "nsga2_global_rank", (
            "N02 curiosity draws compose only with nsga2_global_rank"
        )
        self.qd_curiosity_gamma = float(qd_curiosity_gamma)

    def _sample_success_parents(self, count: int) -> list[Heuristic]:
        pool, weights = curiosity_pool(
            list(self.success_archive.members()),
            self._objective_names(),
            self.population_size,
            self.qd_curiosity_gamma,
        )
        if not pool:
            return super()._sample_success_parents(count)
        champion_lane_fraction = self._active_champion_lane_fraction()
        champion = (
            self._global_best_success_member()
            if champion_lane_fraction > 0.0
            else None
        )
        parents: list[Heuristic] = []
        for _ in range(count):
            if champion is not None and random.random() < champion_lane_fraction:
                parents.append(champion)  # champion lane: refine the best
            else:
                parents.append(random.choices(pool, weights=weights, k=1)[0])
        return parents
