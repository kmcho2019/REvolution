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
    )

    assert split.phase == "fill"
    assert split.fail_budget == 8
    assert split.seed_budget == 1
    assert split.backfill_budget == 1
    assert split.refine_budget == 0


def test_qd_budget_improve_phase_uses_refine_after_target_fill():
    split = split_qd_budget(
        total_budget=10,
        occupied_cells=16,
        num_cells=64,
        fill_target_fraction=0.25,
        fail_pool_empty=False,
        archive_empty=False,
        empty_cells_remaining=True,
    )

    assert split.phase == "improve"
    assert split.fail_budget == 0
    assert split.backfill_budget == 2
    assert split.refine_budget == 8


def test_qd_budget_reassigns_fail_budget_when_fail_pool_empty():
    split = split_qd_budget(
        total_budget=10,
        occupied_cells=0,
        num_cells=64,
        fill_target_fraction=0.25,
        fail_pool_empty=True,
        archive_empty=True,
        empty_cells_remaining=True,
    )

    assert split.fail_budget == 0
    assert split.seed_budget == 10
