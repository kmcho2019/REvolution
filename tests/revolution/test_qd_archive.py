import csv
import json
from types import SimpleNamespace

import pytest

from revolution.qd.archive import (
    CVTArchive,
    GlobalParetoArchive,
    GridArchive,
    GridAxisSpec,
    GridQuantileArchive,
    dominates,
)
from revolution.qd.artifacts import write_archive_cells_csv
from revolution.qd.types import ArchiveMember


def _member(
    candidate_id,
    descriptors,
    quality_score,
    payload=None,
    objectives=None,
    insertion_index=0,
):
    return ArchiveMember(
        candidate_id=candidate_id,
        descriptors=tuple(float(value) for value in descriptors),
        quality_score=float(quality_score),
        objectives=objectives or {"g_P": float(quality_score), "g_A": 0.0, "g_T": 0.0},
        payload=payload if payload is not None else {"id": candidate_id},
        insertion_index=insertion_index,
    )


def _insert(
    archive,
    candidate_id,
    descriptors,
    quality_score,
    payload=None,
    objectives=None,
    insertion_index=0,
):
    return archive.insert(
        _member(
            candidate_id,
            descriptors,
            quality_score,
            payload,
            objectives,
            insertion_index,
        )
    )


def test_grid_archive_inserts_into_empty_cell():
    archive = GridArchive(
        [
            GridAxisSpec(name="g_A", bins=4, lower_bound=-1.0, upper_bound=1.0),
            GridAxisSpec(name="g_T", bins=4, lower_bound=-1.0, upper_bound=1.0),
        ]
    )

    result = _insert(archive, "cand-a", (0.2, 0.3), 0.5, {"id": "cand-a"})

    assert result.inserted is True
    assert result.replaced is False
    assert result.decision == "filled_empty"
    assert archive.occupied_count() == 1
    assert archive.elite_for_cell(result.cell_id).candidate_id == "cand-a"


def test_grid_archive_replaces_only_on_higher_quality():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=2, lower_bound=-1.0, upper_bound=1.0)]
    )

    first = _insert(archive, "cand-a", (0.2,), 0.4, {"id": "cand-a"})
    second = _insert(archive, "cand-b", (0.3,), 0.3, {"id": "cand-b"})
    third = _insert(archive, "cand-c", (0.3,), 0.8, {"id": "cand-c"})

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


def test_pareto_dominance_uses_sequential_objectives():
    left = _member(
        "left",
        (0.5,),
        0.0,
        objectives={"g_P": 0.5, "g_A": 0.4, "g_T": 0.3},
    )
    right = _member(
        "right",
        (0.5,),
        0.0,
        objectives={"g_P": 0.5, "g_A": 0.4, "g_T": 0.2},
    )

    assert dominates(left, right, ("g_P", "g_A", "g_T")) is True
    assert dominates(right, left, ("g_P", "g_A", "g_T")) is False


def test_pareto_dominance_ignores_timing_for_combinational_objectives():
    left = _member(
        "left",
        (0.5,),
        0.0,
        objectives={"g_P": 0.5, "g_A": 0.4, "g_T": -1.0},
    )
    right = _member(
        "right",
        (0.5,),
        0.0,
        objectives={"g_P": 0.5, "g_A": 0.3, "g_T": 1.0},
    )

    assert dominates(left, right, ("g_P", "g_A")) is True


def test_pareto_archive_retains_dominated_member_until_capacity():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=1, lower_bound=0.0, upper_bound=1.0)],
        cell_mode="pareto_front",
        max_elites_per_cell=5,
        objective_names=("g_P", "g_A"),
    )

    first = _insert(
        archive,
        "strong",
        (0.5,),
        0.1,
        objectives={"g_P": 0.8, "g_A": 0.8},
    )
    second = _insert(
        archive,
        "weak",
        (0.5,),
        100.0,
        objectives={"g_P": 0.7, "g_A": 0.7},
    )

    assert first.inserted is True
    assert second.inserted is True
    assert second.decision == "pareto_inserted"
    assert second.pareto_rank == 2
    assert [member.candidate_id for _, member in archive.members()] == [
        "strong",
        "weak",
    ]


def test_pareto_archive_keeps_dominated_members_without_quality_score():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=1, lower_bound=0.0, upper_bound=1.0)],
        cell_mode="pareto_front",
        max_elites_per_cell=5,
        objective_names=("g_P", "g_A"),
    )

    _insert(
        archive,
        "weak",
        (0.5,),
        100.0,
        objectives={"g_P": 0.2, "g_A": 0.2},
    )
    result = _insert(
        archive,
        "strong",
        (0.5,),
        0.1,
        objectives={"g_P": 0.3, "g_A": 0.3},
    )

    assert result.inserted is True
    assert result.replaced is False
    assert {member.candidate_id for _, member in archive.members()} == {
        "weak",
        "strong",
    }
    ranked = archive.ranked_members()
    ranks = {item.member.candidate_id: item.pareto_rank for _, item in ranked}
    assert ranks == {"strong": 1, "weak": 2}


def test_pareto_archive_keeps_non_dominated_members():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=1, lower_bound=0.0, upper_bound=1.0)],
        cell_mode="pareto_front",
        max_elites_per_cell=5,
        objective_names=("g_P", "g_A"),
    )

    _insert(archive, "power", (0.5,), 0.1, objectives={"g_P": 0.9, "g_A": 0.1})
    result = _insert(
        archive,
        "area",
        (0.5,),
        0.9,
        objectives={"g_P": 0.1, "g_A": 0.9},
    )

    assert result.decision == "pareto_inserted"
    assert result.front_size == 2
    assert {member.candidate_id for _, member in archive.members()} == {"power", "area"}


def test_pareto_archive_rejects_duplicate_objectives():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=1, lower_bound=0.0, upper_bound=1.0)],
        cell_mode="pareto_front",
        max_elites_per_cell=5,
        objective_names=("g_P", "g_A"),
    )

    _insert(archive, "first", (0.5,), 0.1, objectives={"g_P": 0.4, "g_A": 0.6})
    duplicate = _insert(
        archive,
        "second",
        (0.5,),
        0.9,
        objectives={"g_P": 0.4, "g_A": 0.6},
    )

    assert duplicate.inserted is False
    assert duplicate.decision == "duplicate_objectives"
    assert len(archive.members()) == 1


def test_pareto_archive_crowding_eviction_preserves_extremes():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=1, lower_bound=0.0, upper_bound=1.0)],
        cell_mode="pareto_front",
        max_elites_per_cell=3,
        objective_names=("g_P", "g_A"),
    )

    for index, point in enumerate(
        [(0.0, 1.0), (0.25, 0.75), (0.5, 0.5), (0.75, 0.25), (1.0, 0.0)],
        start=1,
    ):
        _insert(
            archive,
            f"cand-{index}",
            (0.5,),
            float(index),
            objectives={"g_P": point[0], "g_A": point[1]},
            insertion_index=index,
        )

    members = [member for _, member in archive.members()]
    assert len(members) == 3
    assert any(member.objectives["g_P"] == 0.0 for member in members)
    assert any(member.objectives["g_P"] == 1.0 for member in members)


def test_pareto_archive_overflow_culls_worst_rank():
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=1, lower_bound=0.0, upper_bound=1.0)],
        cell_mode="pareto_front",
        max_elites_per_cell=2,
        objective_names=("g_P", "g_A"),
    )

    _insert(archive, "rank-1", (0.5,), 0.1, objectives={"g_P": 0.9, "g_A": 0.9})
    _insert(archive, "rank-2", (0.5,), 0.2, objectives={"g_P": 0.5, "g_A": 0.5})
    evicted = _insert(
        archive,
        "rank-3",
        (0.5,),
        0.3,
        objectives={"g_P": 0.1, "g_A": 0.1},
    )

    assert evicted.inserted is False
    assert evicted.decision == "crowding_evicted"
    assert evicted.evicted_candidate_id == "rank-3"
    assert evicted.evicted_pareto_rank == 3
    assert {member.candidate_id for _, member in archive.members()} == {
        "rank-1",
        "rank-2",
    }


def test_global_pareto_archive_tracks_distinct_non_dominated_members():
    archive = GlobalParetoArchive(("g_P", "g_A"))
    weak = _member("weak", (0.5,), 0.1, objectives={"g_P": 0.1, "g_A": 0.1})
    power = _member("power", (0.5,), 0.2, objectives={"g_P": 0.9, "g_A": 0.1})
    area = _member("area", (0.5,), 0.3, objectives={"g_P": 0.1, "g_A": 0.9})
    duplicate = _member("dupe", (0.5,), 0.4, objectives={"g_P": 0.9, "g_A": 0.1})

    first = archive.insert(weak)
    second = archive.insert(power)
    third = archive.insert(area)
    fourth = archive.insert(duplicate)

    assert first.inserted is True
    assert second.inserted is True
    assert second.removed_count == 1
    assert third.inserted is True
    assert fourth.inserted is False
    assert fourth.reject_reason == "duplicate_objectives"
    assert {member.candidate_id for member in archive.members()} == {"power", "area"}


def test_pareto_archive_cells_csv_writes_one_row_per_member(tmp_path):
    archive = GridArchive(
        [GridAxisSpec(name="g_A", bins=1, lower_bound=0.0, upper_bound=1.0)],
        cell_mode="pareto_front",
        max_elites_per_cell=5,
        objective_names=("g_P", "g_A"),
    )

    _insert(archive, "power", (0.5,), 0.1, objectives={"g_P": 0.9, "g_A": 0.1})
    _insert(archive, "area", (0.5,), 0.9, objectives={"g_P": 0.1, "g_A": 0.9})
    write_archive_cells_csv(
        path=tmp_path / "archive_cells.csv",
        ranked_members=archive.ranked_members(),
    )

    with (tmp_path / "archive_cells.csv").open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    space = archive.describe_space()

    assert len(rows) == 2
    assert {row["candidate_id"] for row in rows} == {"power", "area"}
    assert {int(row["front_size"]) for row in rows} == {2}
    assert {int(row["cell_member_count"]) for row in rows} == {2}
    assert {int(row["member_index"]) for row in rows} == {0, 1}
    assert {int(row["pareto_rank"]) for row in rows} == {1}
    assert "parent_count" in rows[0]
    assert all(json.loads(row["objectives_json"]) for row in rows)
    assert space["occupied_cells"] == 1
    assert space["total_archive_members"] == 2
    assert space["mean_front_size"] == 2.0
    assert space["max_front_size"] == 2


def test_pareto_cell_mode_is_supported_by_all_geometries():
    grid = GridArchive(
        [GridAxisSpec(name="g_A", bins=1, lower_bound=0.0, upper_bound=1.0)],
        cell_mode="pareto_front",
        max_elites_per_cell=2,
        objective_names=("g_P", "g_A"),
    )
    cvt = CVTArchive(
        ("g_A",),
        num_cells=1,
        warmup_successes=1,
        cell_mode="pareto_front",
        max_elites_per_cell=2,
        objective_names=("g_P", "g_A"),
    )
    quantile = GridQuantileArchive(
        ("g_A",),
        warmup_successes=2,
        cell_mode="pareto_front",
        max_elites_per_cell=2,
        objective_names=("g_P", "g_A"),
    )

    _insert(grid, "grid-a", (0.5,), 0.1, objectives={"g_P": 0.9, "g_A": 0.1})
    _insert(cvt, "cvt-a", (0.5,), 0.1, objectives={"g_P": 0.9, "g_A": 0.1})
    _insert(quantile, "q-a", (0.0,), 0.1, objectives={"g_P": 0.9, "g_A": 0.1})
    _insert(quantile, "q-b", (10.0,), 0.2, objectives={"g_P": 0.1, "g_A": 0.9})

    assert grid.members()
    assert cvt.members()
    assert quantile.members()


def test_cvt_archive_buffers_until_warmup_threshold_then_initializes():
    archive = CVTArchive(("g_A", "g_T"), num_cells=4, warmup_successes=2)

    first = _insert(archive, "cand-a", (0.2, 0.3), 0.5, {"id": "cand-a"})
    assert first.inserted is False
    assert first.decision == "warmup_buffered"
    assert archive.is_initialized is False
    assert archive.occupied_count() == 0

    second = _insert(archive, "cand-b", (0.4, 0.1), 0.6, {"id": "cand-b"})
    assert archive.is_initialized is True
    assert second.inserted is True
    assert archive.occupied_count() >= 1


def test_cvt_archive_replaces_only_on_higher_quality():
    archive = CVTArchive(("g_A",), num_cells=1, warmup_successes=1)

    first = _insert(archive, "cand-a", (0.2,), 0.4, {"id": "cand-a"})
    second = _insert(archive, "cand-b", (0.3,), 0.3, {"id": "cand-b"})
    third = _insert(archive, "cand-c", (0.3,), 0.8, {"id": "cand-c"})

    assert first.inserted is True
    assert second.inserted is False
    assert second.decision == "not_inserted"
    assert third.replaced is True
    assert third.decision == "replaced_elite"
    assert archive.elite_for_cell("0").candidate_id == "cand-c"


def test_cvt_archive_freezes_scaler_and_centroids_after_warmup():
    archive = CVTArchive(("g_A", "g_T"), num_cells=4, warmup_successes=2)
    _insert(archive, "cand-a", (0.1, 0.2), 0.4, {"id": "cand-a"})
    _insert(archive, "cand-b", (0.2, 0.4), 0.5, {"id": "cand-b"})

    assert archive.is_initialized is True
    means_before = archive.scaler.means
    stds_before = archive.scaler.stds
    centroids_before = archive.centroids

    _insert(archive, "cand-c", (100.0, -100.0), 0.6, {"id": "cand-c"})

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
    _insert(archive, "cand-a", (0.2, 0.3), 0.5, {"id": "cand-a"})

    space = archive.describe_space()
    assignment = archive.describe_assignment((0.25, 0.35))

    assert space["archive_type"] == "cvt"
    assert space["space_geometry"]["initialized"] is True
    assert assignment["archive_type"] == "cvt"
    assert assignment["initialized"] is True
    assert "centroid" in assignment


def test_cvt_archive_finalizes_from_partial_warmup_buffer():
    archive = CVTArchive(("g_A", "g_T"), num_cells=4, warmup_successes=4)

    first = _insert(archive, "cand-a", (0.2, 0.3), 0.5, {"id": "cand-a"})
    second = _insert(archive, "cand-b", (0.4, 0.1), 0.6, {"id": "cand-b"})

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
        _insert(archive, f"cand-{index}", (value,), float(index), {"id": index})

    assert archive.is_initialized is True
    assert archive.quantile_boundaries == ((10.0, 20.0, 30.0),)
    assert archive.effective_bins == (4,)
    assert archive.num_cells == 4


def test_grid_quantile_archive_collapses_duplicate_boundaries():
    archive = GridQuantileArchive(("logic_depth",), warmup_successes=5)

    for index, value in enumerate([0.0, 0.0, 0.0, 0.0, 10.0], start=1):
        _insert(archive, f"cand-{index}", (value,), float(index), {"id": index})

    assert archive.quantile_boundaries == ((0.0,),)
    assert archive.effective_bins == (2,)
    assert archive.num_cells == 2


def test_grid_quantile_archive_collapses_all_equal_axis_to_one_bin():
    archive = GridQuantileArchive(("ff_depth",), warmup_successes=4)

    for index in range(4):
        _insert(archive, f"cand-{index}", (0.0,), float(index), {"id": index})

    assert archive.is_initialized is False

    results = archive.finalize_pending()

    assert any(result.inserted for result in results.values())
    assert archive.quantile_boundaries == ((),)
    assert archive.effective_bins == (1,)
    assert archive.cell_id_for((0.0,)) == "0"
    assert archive.describe_space()["axes"][0]["collapsed"] is True


def test_grid_quantile_archive_assigns_boundary_values_to_higher_bins():
    archive = GridQuantileArchive(("logic_depth",), warmup_successes=5)
    for index, value in enumerate([0.0, 10.0, 20.0, 30.0, 40.0], start=1):
        _insert(archive, f"cand-{index}", (value,), float(index), {"id": index})

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
    first = _insert(archive, "cand-a", (0.0, 0.0), 0.5, payload_a)

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
    second = _insert(archive, "cand-b", (10.0, 10.0), 0.7, payload_b)

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


def test_grid_quantile_archive_delays_until_two_active_axes():
    archive = GridQuantileArchive(
        ("logic_depth", "ff_depth", "comb_width_log"),
        warmup_successes=2,
    )

    _insert(archive, "cand-a", (3.0, 0.0, 2.0), 0.5, {"id": "a"})
    _insert(archive, "cand-b", (3.0, 0.0, 3.0), 0.6, {"id": "b"})

    assert archive.is_initialized is False
    assert archive.warmup_buffer_size() == 2

    third = _insert(archive, "cand-c", (5.0, 0.0, 4.0), 0.7, {"id": "c"})

    assert third.decision == "warmup_buffered"
    assert archive.is_initialized is True
    assert archive.initialization_sample_count == 3
    assert archive.effective_bins[0] > 1
    assert archive.effective_bins[2] > 1


def test_grid_quantile_archive_replaces_after_initialization():
    archive = GridQuantileArchive(("logic_depth",), warmup_successes=2)
    _insert(archive, "cand-a", (0.0,), 0.5, {"id": "a"})
    _insert(archive, "cand-b", (10.0,), 0.7, {"id": "b"})

    lower_quality = _insert(archive, "cand-c", (11.0,), 0.6, {"id": "c"})
    better = _insert(archive, "cand-d", (11.0,), 0.9, {"id": "d"})

    assert lower_quality.decision == "not_inserted"
    assert better.decision == "replaced_elite"
    assert better.inserted is True
    assert archive.elite_for_cell(better.cell_id).candidate_id == "cand-d"


def test_grid_quantile_archive_describes_pending_assignment():
    archive = GridQuantileArchive(("logic_depth",), warmup_successes=2)
    _insert(archive, "cand-a", (0.0,), 0.5, {"id": "a"})

    assignment = archive.describe_assignment((0.0,))

    assert assignment["archive_type"] == "grid_quantile"
    assert assignment["initialized"] is False
    assert assignment["assignment_status"] == "warmup_pending"
