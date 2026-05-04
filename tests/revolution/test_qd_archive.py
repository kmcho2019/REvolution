import pytest
from types import SimpleNamespace

from revolution.qd.archive import CVTArchive, GridArchive, GridAxisSpec, GridQuantileArchive


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


def test_cvt_archive_finalizes_from_partial_warmup_buffer():
    archive = CVTArchive(("g_A", "g_T"), num_cells=4, warmup_successes=4)

    first = archive.insert("cand-a", (0.2, 0.3), 0.5, {"id": "cand-a"})
    second = archive.insert("cand-b", (0.4, 0.1), 0.6, {"id": "cand-b"})

    assert first.decision == "warmup_buffered"
    assert second.decision == "warmup_buffered"
    assert archive.is_initialized is False

    results = archive.finalize_pending()

    assert archive.is_initialized is True
    assert archive.initialization_mode == "run_finalization_fallback"
    assert archive.initialization_sample_count == 2
    assert archive.describe_space()["space_geometry"]["warmup_buffer_size"] == 0
    assert set(results) == {"cand-a", "cand-b"}
    assert any(result.inserted for result in results.values())


def test_grid_quantile_archive_computes_interpolated_boundaries():
    archive = GridQuantileArchive(("logic_depth",), warmup_successes=5)

    for index, value in enumerate([0.0, 10.0, 20.0, 30.0, 40.0], start=1):
        archive.insert(f"cand-{index}", (value,), float(index), {"id": index})

    assert archive.is_initialized is True
    assert archive.quantile_boundaries == ((10.0, 20.0, 30.0),)
    assert archive.effective_bins == (4,)
    assert archive.num_cells == 4


def test_grid_quantile_archive_collapses_duplicate_boundaries():
    archive = GridQuantileArchive(("logic_depth",), warmup_successes=4)

    for index, value in enumerate([0.0, 0.0, 10.0, 10.0], start=1):
        archive.insert(f"cand-{index}", (value,), float(index), {"id": index})

    assert archive.quantile_boundaries == ((5.0,),)
    assert archive.effective_bins == (2,)
    assert archive.num_cells == 2


def test_grid_quantile_archive_collapses_all_equal_axis_to_one_bin():
    archive = GridQuantileArchive(("ff_depth",), warmup_successes=4)

    for index in range(4):
        archive.insert(f"cand-{index}", (0.0,), float(index), {"id": index})

    assert archive.quantile_boundaries == ((),)
    assert archive.effective_bins == (1,)
    assert archive.cell_id_for((0.0,)) == "0"
    assert archive.describe_space()["axes"][0]["collapsed"] is True


def test_grid_quantile_archive_assigns_boundary_values_to_higher_bins():
    archive = GridQuantileArchive(("logic_depth",), warmup_successes=5)
    for index, value in enumerate([0.0, 10.0, 20.0, 30.0, 40.0], start=1):
        archive.insert(f"cand-{index}", (value,), float(index), {"id": index})

    assert archive.cell_id_for((-5.0,)) == "0"
    assert archive.cell_id_for((10.0,)) == "1"
    assert archive.cell_id_for((15.0,)) == "1"
    assert archive.cell_id_for((20.0,)) == "2"
    assert archive.cell_id_for((35.0,)) == "3"


def test_grid_quantile_archive_buffers_warmup_then_replays_samples():
    archive = GridQuantileArchive(("logic_depth", "ff_depth"), warmup_successes=2)
    payload_a = SimpleNamespace(
        ppa_metrics={"area": 10.0},
        code_file_path="/tmp/Prob_sample1_initial/code.sv",
        generation_candidate_index=1,
        archive_insertion_index=1,
    )
    first = archive.insert("cand-a", (0.0, 0.0), 0.5, payload_a)

    assert first.decision == "warmup_buffered"
    assert first.inserted is False
    assert archive.is_initialized is False
    assert archive.occupied_count() == 0
    assert archive.describe_history_geometry()["warmup_buffer_size"] == 1
    pending_space = archive.describe_space()
    assert pending_space["warmup_buffer_samples"][0]["sample_role"] == "quantile_warmup_buffered"
    assert pending_space["warmup_buffer_samples"][0]["descriptor_tuple"] == [0.0, 0.0]

    payload_b = SimpleNamespace(
        ppa_metrics={"area": 9.0},
        code_file_path="/tmp/Prob_sample2_initial/code.sv",
        generation_candidate_index=2,
        archive_insertion_index=2,
    )
    second = archive.insert("cand-b", (10.0, 0.0), 0.7, payload_b)

    assert second.decision == "warmup_buffered"
    assert second.inserted is False
    assert archive.is_initialized is True
    assert archive.occupied_count() == 2
    assert archive.warmup_buffer_size() == 0

    space = archive.describe_space()
    assert space["warmup_buffer_samples"] == []
    assert space["warmup_initialization_samples"][0]["sample_role"] == "quantile_warmup_initialization"
    assert space["warmup_replay_results"][0]["sample_role"] == "quantile_warmup_replay"
    assert space["warmup_replay_results"][0]["inserted"] is True
    assert space["warmup_initialization_samples"][0]["generation_candidate_index"] == 1
    assert space["quantile_boundaries_hash"] == archive.quantile_boundaries_hash


def test_grid_quantile_archive_replaces_after_initialization():
    archive = GridQuantileArchive(("logic_depth",), warmup_successes=2)
    archive.insert("cand-a", (0.0,), 0.5, {"id": "a"})
    archive.insert("cand-b", (10.0,), 0.7, {"id": "b"})

    lower_quality = archive.insert("cand-c", (11.0,), 0.6, {"id": "c"})
    better = archive.insert("cand-d", (11.0,), 0.9, {"id": "d"})

    assert lower_quality.decision == "not_inserted"
    assert better.decision == "replaced_elite"
    assert better.inserted is True
    assert archive.elite_for_cell(better.cell_id).candidate_id == "cand-d"


def test_grid_quantile_archive_describes_pending_assignment():
    archive = GridQuantileArchive(("logic_depth",), warmup_successes=2)
    archive.insert("cand-a", (0.0,), 0.5, {"id": "a"})

    assignment = archive.describe_assignment((0.0,))

    assert assignment["archive_type"] == "grid_quantile"
    assert assignment["initialized"] is False
    assert assignment["assignment_status"] == "warmup_pending"
