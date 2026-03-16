from __future__ import annotations

import math
from dataclasses import dataclass


@dataclass(frozen=True)
class QDBudgetSplit:
    """Resolved per-generation QD budget allocation across search phases."""

    total_budget: int
    target_cells: int
    occupied_cells: int
    fail_share: float
    fail_budget: int
    success_budget: int
    phase: str
    seed_budget: int
    backfill_budget: int
    refine_budget: int


def qd_target_cells(num_cells: int, fill_target_fraction: float) -> int:
    """Return the occupied-cell target that switches fill into improve mode."""

    return max(1, math.ceil(max(fill_target_fraction, 0.0) * max(num_cells, 1)))


def qd_fail_share(*, occupied_cells: int, num_cells: int, fill_target_fraction: float) -> float:
    """Compute the linear fail-side budget share from current archive fill."""

    target = qd_target_cells(num_cells, fill_target_fraction)
    rho = min(1.0, max(0, occupied_cells) / max(target, 1))
    return 1.0 - rho


def split_qd_budget(
    *,
    total_budget: int,
    occupied_cells: int,
    num_cells: int,
    fill_target_fraction: float,
    fail_pool_empty: bool,
    archive_empty: bool,
    empty_cells_remaining: bool,
) -> QDBudgetSplit:
    """Split one generation budget across fail, seed, backfill, and refine."""

    total_budget = max(0, int(total_budget))
    target = qd_target_cells(num_cells, fill_target_fraction)
    fail_share = qd_fail_share(
        occupied_cells=occupied_cells,
        num_cells=num_cells,
        fill_target_fraction=fill_target_fraction,
    )
    fail_budget = round(total_budget * fail_share)
    if fail_pool_empty:
        fail_budget = 0
    success_budget = max(0, total_budget - fail_budget)

    if archive_empty:
        return QDBudgetSplit(
            total_budget=total_budget,
            target_cells=target,
            occupied_cells=occupied_cells,
            fail_share=fail_share,
            fail_budget=fail_budget,
            success_budget=success_budget,
            phase="fill",
            seed_budget=success_budget,
            backfill_budget=0,
            refine_budget=0,
        )

    if occupied_cells < target:
        seed_budget = math.ceil(0.25 * success_budget)
        backfill_budget = max(0, success_budget - seed_budget)
        return QDBudgetSplit(
            total_budget=total_budget,
            target_cells=target,
            occupied_cells=occupied_cells,
            fail_share=fail_share,
            fail_budget=fail_budget,
            success_budget=success_budget,
            phase="fill",
            seed_budget=seed_budget,
            backfill_budget=backfill_budget,
            refine_budget=0,
        )

    backfill_budget = max(1, round(0.20 * success_budget)) if empty_cells_remaining and success_budget > 0 else 0
    refine_budget = max(0, success_budget - backfill_budget)
    return QDBudgetSplit(
        total_budget=total_budget,
        target_cells=target,
        occupied_cells=occupied_cells,
        fail_share=fail_share,
        fail_budget=fail_budget,
        success_budget=success_budget,
        phase="improve",
        seed_budget=0,
        backfill_budget=backfill_budget,
        refine_budget=refine_budget,
    )
