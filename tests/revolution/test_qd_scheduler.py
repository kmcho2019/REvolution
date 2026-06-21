from revolution.qd.scheduler import qd_fail_share, qd_target_cells, split_qd_budget


def test_qd_target_cells_uses_fill_fraction():
    assert qd_target_cells(64, 0.25) == 16


def test_qd_fail_share_reaches_zero_at_target_fill():
    share = qd_fail_share(occupied_cells=16, num_cells=64, fill_target_fraction=0.25)
    assert share == 0.0


def test_qd_budget_fill_phase_uses_seed_and_backfill():
    split = split_qd_budget(
        total_budget=10,
        occupied_cells=4,
        num_cells=64,
        fill_target_fraction=0.25,
        fail_pool_empty=False,
        archive_empty=False,
        empty_cells_remaining=True,
        fail_share_cap=1.0,
    )

    assert split.phase == "fill"
    assert split.fail_budget == 8
    assert split.seed_budget == 1
    assert split.backfill_budget == 1
    assert split.refine_budget == 0


def test_qd_budget_fail_share_cap_reduces_fail_budget():
    split = split_qd_budget(
        total_budget=10,
        occupied_cells=4,
        num_cells=64,
        fill_target_fraction=0.25,
        fail_pool_empty=False,
        archive_empty=False,
        empty_cells_remaining=True,
        fail_share_cap=0.2,
    )

    assert split.phase == "fill"
    assert split.coverage_fail_share == 0.75
    assert split.fail_share_cap == 0.2
    assert split.fail_share == 0.2
    assert split.fail_budget == 2
    assert split.seed_budget == 2
    assert split.backfill_budget == 6
    assert split.refine_budget == 0


def test_qd_budget_fail_share_cap_does_not_increase_default_fail_budget():
    split = split_qd_budget(
        total_budget=10,
        occupied_cells=8,
        num_cells=64,
        fill_target_fraction=0.25,
        fail_pool_empty=False,
        archive_empty=False,
        empty_cells_remaining=True,
        fail_share_cap=0.9,
    )

    assert split.fail_share == 0.5
    assert split.coverage_fail_share == 0.5
    assert split.fail_share_cap == 0.9
    assert split.fail_budget == 5


def test_qd_budget_empty_fail_pool_keeps_fail_budget_zero_with_cap():
    split = split_qd_budget(
        total_budget=10,
        occupied_cells=4,
        num_cells=64,
        fill_target_fraction=0.25,
        fail_pool_empty=True,
        archive_empty=False,
        empty_cells_remaining=True,
        fail_share_cap=0.8,
    )

    assert split.fail_share == 0.75
    assert split.fail_budget == 0
    assert split.seed_budget == 3
    assert split.backfill_budget == 7


def test_qd_budget_improve_phase_uses_refine_after_target_fill():
    split = split_qd_budget(
        total_budget=10,
        occupied_cells=16,
        num_cells=64,
        fill_target_fraction=0.25,
        fail_pool_empty=False,
        archive_empty=False,
        empty_cells_remaining=True,
        fail_share_cap=1.0,
    )

    assert split.phase == "improve"
    assert split.fail_budget == 0
    assert split.backfill_budget == 2
    assert split.refine_budget == 8
    assert split.improve_backfill_fraction == 0.20


def test_qd_budget_improve_phase_accepts_guarded_backfill_fraction():
    split = split_qd_budget(
        total_budget=20,
        occupied_cells=16,
        num_cells=64,
        fill_target_fraction=0.25,
        improve_backfill_fraction=0.05,
        fail_pool_empty=False,
        archive_empty=False,
        empty_cells_remaining=True,
        fail_share_cap=1.0,
    )

    assert split.phase == "improve"
    assert split.backfill_budget == 1
    assert split.refine_budget == 19
    assert split.improve_backfill_fraction == 0.05


def test_qd_budget_reassigns_fail_budget_when_fail_pool_empty():
    split = split_qd_budget(
        total_budget=10,
        occupied_cells=0,
        num_cells=64,
        fill_target_fraction=0.25,
        fail_pool_empty=True,
        archive_empty=True,
        empty_cells_remaining=True,
        fail_share_cap=1.0,
    )

    assert split.fail_budget == 0
    assert split.seed_budget == 10
