import pytest

from revolution.qd.archive import GridArchive, GridAxisSpec


def test_grid_archive_inserts_into_empty_cell():
    archive = GridArchive(
        [
            GridAxisSpec(name="g_A", bins=4, lower_bound=-1.0, upper_bound=1.0),
            GridAxisSpec(name="g_T", bins=4, lower_bound=-1.0, upper_bound=1.0),
        ]
    )

    result = archive.insert("cand-a", (0.2, 0.3), 0.5, {"id": "cand-a"})

    assert result.inserted is True
    assert result.replaced is False
    assert archive.occupied_count() == 1
    assert archive.elite_for_cell(result.cell_id).candidate_id == "cand-a"


def test_grid_archive_replaces_only_on_higher_quality():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=2, lower_bound=-1.0, upper_bound=1.0)]
    )

    first = archive.insert("cand-a", (0.2,), 0.4, {"id": "cand-a"})
    second = archive.insert("cand-b", (0.3,), 0.3, {"id": "cand-b"})
    third = archive.insert("cand-c", (0.3,), 0.8, {"id": "cand-c"})

    assert first.inserted is True
    assert second.inserted is False
    assert third.replaced is True
    assert archive.elite_for_cell(third.cell_id).candidate_id == "cand-c"


def test_grid_archive_clamps_extreme_values_to_edge_bins():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=4, lower_bound=0.0, upper_bound=1.0)]
    )

    low_cell = archive.cell_id_for((-10.0,))
    high_cell = archive.cell_id_for((10.0,))

    assert low_cell == "0"
    assert high_cell == "3"


def test_grid_archive_rejects_dimension_mismatch():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=4, lower_bound=0.0, upper_bound=1.0)]
    )

    with pytest.raises(ValueError, match="dimensionality"):
        archive.cell_id_for((0.1, 0.2))
