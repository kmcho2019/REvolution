import pytest

from revolution.qd.archive import CVTArchive, GridArchive, GridAxisSpec


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
    assert result.decision == "filled_empty"
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
    assert second.decision == "not_inserted"
    assert third.replaced is True
    assert third.decision == "replaced_elite"
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


def test_cvt_archive_buffers_until_warmup_threshold_then_initializes():
    archive = CVTArchive(("g_A", "g_T"), num_cells=4, warmup_successes=2)

    first = archive.insert("cand-a", (0.2, 0.3), 0.5, {"id": "cand-a"})
    assert first.inserted is False
    assert first.decision == "warmup_buffered"
    assert archive.is_initialized is False
    assert archive.occupied_count() == 0

    second = archive.insert("cand-b", (0.4, 0.1), 0.6, {"id": "cand-b"})
    assert archive.is_initialized is True
    assert second.inserted is True
    assert archive.occupied_count() >= 1


def test_cvt_archive_replaces_only_on_higher_quality():
    archive = CVTArchive(("g_A",), num_cells=1, warmup_successes=1)

    first = archive.insert("cand-a", (0.2,), 0.4, {"id": "cand-a"})
    second = archive.insert("cand-b", (0.3,), 0.3, {"id": "cand-b"})
    third = archive.insert("cand-c", (0.3,), 0.8, {"id": "cand-c"})

    assert first.inserted is True
    assert second.inserted is False
    assert second.decision == "not_inserted"
    assert third.replaced is True
    assert third.decision == "replaced_elite"
    assert archive.elite_for_cell("0").candidate_id == "cand-c"


def test_cvt_archive_freezes_scaler_and_centroids_after_warmup():
    archive = CVTArchive(("g_A", "g_T"), num_cells=4, warmup_successes=2)
    archive.insert("cand-a", (0.1, 0.2), 0.4, {"id": "cand-a"})
    archive.insert("cand-b", (0.2, 0.4), 0.5, {"id": "cand-b"})

    assert archive.is_initialized is True
    means_before = archive.scaler.means
    stds_before = archive.scaler.stds
    centroids_before = archive.centroids

    archive.insert("cand-c", (100.0, -100.0), 0.6, {"id": "cand-c"})

    assert archive.scaler.means == means_before
    assert archive.scaler.stds == stds_before
    assert archive.centroids == centroids_before


def test_grid_archive_describes_space_and_assignment():
    archive = GridArchive(
        [
            GridAxisSpec(name="g_A", bins=2, lower_bound=-1.0, upper_bound=1.0),
            GridAxisSpec(name="g_P", bins=4, lower_bound=-1.0, upper_bound=1.0),
        ]
    )

    space = archive.describe_space()
    assignment = archive.describe_assignment((0.25, -0.2))

    assert space["archive_type"] == "grid"
    assert space["space_geometry"]["total_cells"] == 8
    assert assignment["cell_id"] == "1,1"
    assert assignment["axis_details"][0]["axis"] == "g_A"


def test_cvt_archive_describes_space_and_assignment():
    archive = CVTArchive(("g_A", "g_T"), num_cells=4, warmup_successes=1)
    archive.insert("cand-a", (0.2, 0.3), 0.5, {"id": "cand-a"})

    space = archive.describe_space()
    assignment = archive.describe_assignment((0.25, 0.35))

    assert space["archive_type"] == "cvt"
    assert space["space_geometry"]["initialized"] is True
    assert assignment["archive_type"] == "cvt"
    assert assignment["initialized"] is True
    assert "centroid" in assignment
