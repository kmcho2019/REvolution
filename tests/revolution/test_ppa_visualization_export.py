from __future__ import annotations

from collections.abc import Mapping, Sequence
import csv
import json
import math
from pathlib import Path
from typing import Any

import pytest

from revolution.qd.ppa_visualization_export import (
    BackendRun,
    _graph_metrics_for_code,
    _project_sample,
    export_qd_ppa_visualization,
)


def _write_csv(path: Path, rows: Sequence[Mapping[str, object]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def _write_json(path: Path, payload: Mapping[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def _grid_quantile_space() -> dict[str, Any]:
    return {
        "archive_type": "grid_quantile",
        "initialized": True,
        "num_cells": 4,
        "axes": [
            {"name": "logic_depth", "effective_bins": 2, "quantile_boundaries": [2.0]},
            {"name": "ff_depth", "effective_bins": 1, "quantile_boundaries": []},
            {"name": "comb_width_log", "effective_bins": 2, "quantile_boundaries": [1.5]},
        ],
        "effective_shape": [2, 1, 2],
    }


def _write_run(root: Path) -> tuple[Path, Path, Path]:
    run_root = root / "run"
    classic_root = run_root / "classic"
    qd_root = run_root / "grid_quantile_pareto_journal_bd"
    ppa_rows = [
        {
            "backend": "classic",
            "benchmark": "RTLLM",
            "problem": "Prob001",
            "circuit_type": "combinational",
            "generation": 0,
            "candidate_id": "classic_a",
            "strategy": "initial",
            "source": "generation_log",
            "score_from_run": 0.2,
            "ppa_score": 0.2,
            "area": 90.0,
            "power": 0.8,
            "eff_clk_period": 0.0,
            "ref_area": 100.0,
            "ref_power": 1.0,
            "ref_eff_clk_period": 0.0,
            "g_A": 0.1,
            "g_P": 0.2,
            "g_T": 0.0,
            "candidate_dir": "",
            "report_path": "",
        },
        {
            "backend": "grid_quantile_pareto_journal_bd",
            "benchmark": "RTLLM",
            "problem": "Prob001",
            "circuit_type": "combinational",
            "generation": 0,
            "candidate_id": "qd_a",
            "strategy": "initial",
            "source": "generation_log",
            "score_from_run": 0.3,
            "ppa_score": 0.3,
            "area": 85.0,
            "power": 0.9,
            "eff_clk_period": 0.0,
            "ref_area": 100.0,
            "ref_power": 1.0,
            "ref_eff_clk_period": 0.0,
            "g_A": 0.15,
            "g_P": 0.1,
            "g_T": 0.0,
            "candidate_dir": "",
            "report_path": "",
        },
    ]
    _write_csv(run_root / "final_analysis" / "ppa_distribution" / "data" / "ppa_candidates.csv", ppa_rows)
    _write_csv(
        run_root / "final_analysis" / "ppa_distribution" / "data" / "reference_ppa_metrics.csv",
        [
            {
                "benchmark": "RTLLM",
                "problem": "Prob001",
                "circuit_type": "combinational",
                "ref_area": 100.0,
                "ref_power": 1.0,
                "ref_eff_clk_period": 0.0,
                "summary_path": "",
            }
        ],
    )
    _write_csv(
        run_root / "final_analysis" / "design_space_analysis" / "successful_candidates.csv",
        [
            {
                "backend": "classic",
                "benchmark": "RTLLM",
                "problem": "Prob001",
                "candidate_id": "classic_a",
                "quality_score": 0.2,
                "candidate_dir": "",
                "code_file_path": "",
                "logic_depth": 3.0,
                "ff_depth": 0.0,
                "comb_width_log": 1.0,
            },
            {
                "backend": "grid_quantile_pareto_journal_bd",
                "benchmark": "RTLLM",
                "problem": "Prob001",
                "candidate_id": "qd_a",
                "quality_score": 0.3,
                "candidate_dir": "",
                "code_file_path": "",
                "logic_depth": 1.0,
                "ff_depth": 0.0,
                "comb_width_log": 2.0,
            },
        ],
    )
    for backend_root in (classic_root, qd_root):
        problem_dir = backend_root / "model" / "RTLLM" / "Prob001"
        _write_json(
            problem_dir / "Prob001_summary.json",
            {
                "benchmark_name": "RTLLM",
                "problem_name": "Prob001",
                "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 0.0},
            },
        )
    qd_problem = qd_root / "model" / "RTLLM" / "Prob001"
    _write_json(qd_problem / "archive_space.json", _grid_quantile_space())
    _write_csv(
        qd_problem / "archive_cells.csv",
        [
            {
                "cell_id": "0,0,1",
                "member_index": 0,
                "front_size": 1,
                "pareto_rank": 1,
                "candidate_id": "qd_a",
                "quality_score": 0.3,
                "generation": 0,
                "strategy": "initial",
                "code_file_path": "",
                "g_P": 0.1,
                "g_A": 0.15,
                "g_T": 0.0,
                "objectives_json": "{}",
                "descriptors_json": "[1.0, 0.0, 2.0]",
                "parent_ids_json": "[]",
            }
        ],
    )
    _write_csv(
        qd_problem / "global_pareto_archive.csv",
        [
            {
                "candidate_id": "qd_a",
                "benchmark": "RTLLM",
                "problem": "Prob001",
            }
        ],
    )
    return run_root, classic_root, qd_root


def test_export_writes_projected_classic_dataset(tmp_path: Path) -> None:
    run_root, classic_root, qd_root = _write_run(tmp_path)
    output_dir = run_root / "visualization" / "qd_ppa_viewer"

    result = export_qd_ppa_visualization(
        run_root=run_root,
        backend_runs=(
            BackendRun("classic", classic_root),
            BackendRun("grid_quantile_pareto_journal_bd", qd_root),
        ),
        archive_source_backend="grid_quantile_pareto_journal_bd",
        output_dir=output_dir,
        subset_config=None,
        selected_problem="RTLLM/Prob001",
        asset_mode="inline",
        strict=True,
        recover_classic_descriptors=False,
    )

    assert result.manifest_path.is_file()
    assert (output_dir / "index.html").is_file()
    html = (output_dir / "index.html").read_text(encoding="utf-8")
    assert "__QD_PPA_VIEWER_DEBUG__" in html
    assert "drawPpa3d(" in html
    assert "drawPpa2d(" in html
    assert "rankScopeSelect" in html
    assert "advancedPanel" in html
    assert "archiveGeometryPerspectiveSelect" in html
    assert 'data-ppa-scale="final"' in html
    assert 'data-ppa-view="area_power_front"' in html
    assert "setPpaScaleMode" in html
    assert "setPpaViewMode" in html
    assert "drawPpaAreaPowerFront(" in html
    assert "renderedCellIds.has(summary.cell_id)" in html
    dataset = json.loads(result.dataset_paths[0].read_text(encoding="utf-8"))
    classic = next(sample for sample in dataset["samples"] if sample["technique"] == "classic")
    qd = next(sample for sample in dataset["samples"] if sample["technique"] != "classic")
    assert classic["projection_type"] == "posthoc"
    assert classic["archive_projection_status"] == "projected"
    assert classic["archive_cell_id"] == "1,0,0"
    assert qd["local_archive_member"] is True
    assert qd["mode_global_pareto_member"] is True
    assert dataset["viewer_defaults"]["coordinate_modes"] == ["raw", "improvement", "normalized"]
    assert dataset["viewer_defaults"]["ppa_scale_modes"] == ["current", "final"]
    assert dataset["viewer_defaults"]["archive_geometry_perspective"] == "native_timeline"
    assert dataset["archive_geometry_perspectives"] == ["native_timeline", "final_fixed"]
    assert len(dataset["archive_geometry_snapshots"]) == 1
    assert dataset["schema_version"] == "qd_ppa_problem.v2"
    assert classic["pareto_rank_final"] == 1
    assert qd["pareto_rank_final"] == 1
    assert dataset["technique_stats_by_step"]["final"]["classic"]["rank1_count"] == 1
    assert dataset["technique_stats_by_step"]["final"]["_pooled_visible"]["hypervolume"]["method"] == "exact_recursive"


def test_export_records_adaptive_rebin_geometry(tmp_path: Path) -> None:
    run_root, classic_root, qd_root = _write_run(tmp_path)
    qd_problem = qd_root / "model" / "RTLLM" / "Prob001"
    old_geometry = {
        **_grid_quantile_space(),
        "effective_shape": [1, 1, 2],
        "axes": [
            {"name": "logic_depth", "effective_bins": 1, "quantile_boundaries": []},
            {"name": "ff_depth", "effective_bins": 1, "quantile_boundaries": []},
            {"name": "comb_width_log", "effective_bins": 2, "quantile_boundaries": [1.5]},
        ],
    }
    new_geometry = _grid_quantile_space()
    (qd_problem / "archive_history.jsonl").write_text(
        json.dumps(
            {
                "event_kind": "rebin",
                "generation": 1,
                "total_rebin_count": 1,
                "trigger_axes": ["logic_depth"],
                "corrected_p_threshold": 0.0167,
                "axis_results": [{"axis": "logic_depth", "ks_p_value": 0.001}],
                "old_geometry": old_geometry,
                "new_geometry": new_geometry,
            }
        )
        + "\n",
        encoding="utf-8",
    )

    result = export_qd_ppa_visualization(
        run_root=run_root,
        backend_runs=(
            BackendRun("classic", classic_root),
            BackendRun("grid_quantile_pareto_journal_bd", qd_root),
        ),
        archive_source_backend="grid_quantile_pareto_journal_bd",
        output_dir=run_root / "visualization" / "adaptive",
        subset_config=None,
        selected_problem="RTLLM/Prob001",
        asset_mode="inline",
        strict=True,
        recover_classic_descriptors=False,
    )
    dataset = json.loads(result.dataset_paths[0].read_text(encoding="utf-8"))
    qd = next(sample for sample in dataset["samples"] if sample["technique"] != "classic")

    assert dataset["rebin_timeline_markers"][0]["trigger_axes"] == ["logic_depth"]
    assert len(dataset["archive_geometry_snapshots"]) >= 2
    assert "cell_summaries_by_step_native_timeline" in dataset
    assert qd["native_archive_geometry_id"] == dataset["rebin_timeline_markers"][0]["old_geometry_id"]
    assert qd["final_fixed_archive_geometry_id"] != qd["native_archive_geometry_id"]


def test_missing_descriptors_stay_in_ppa_and_out_of_cells(tmp_path: Path) -> None:
    run_root, classic_root, qd_root = _write_run(tmp_path)
    design_path = run_root / "final_analysis" / "design_space_analysis" / "successful_candidates.csv"
    rows = list(csv.DictReader(design_path.open(encoding="utf-8", newline="")))
    rows[0]["logic_depth"] = ""
    _write_csv(design_path, rows)

    result = export_qd_ppa_visualization(
        run_root=run_root,
        backend_runs=(
            BackendRun("classic", classic_root),
            BackendRun("grid_quantile_pareto_journal_bd", qd_root),
        ),
        archive_source_backend="grid_quantile_pareto_journal_bd",
        output_dir=run_root / "visualization" / "missing",
        subset_config=None,
        selected_problem="RTLLM/Prob001",
        asset_mode="inline",
        strict=False,
        recover_classic_descriptors=False,
    )
    dataset = json.loads(result.dataset_paths[0].read_text(encoding="utf-8"))
    classic = next(sample for sample in dataset["samples"] if sample["technique"] == "classic")

    assert classic["archive_projection_status"] == "missing_descriptors"
    assert classic["archive_cell_id"] is None
    assert "classic" not in dataset["cell_summaries_by_step"]["final"]


def test_strict_export_keeps_uninitialized_quantile_samples_out_of_cells(
    tmp_path: Path,
) -> None:
    run_root, classic_root, qd_root = _write_run(tmp_path)
    problem_dir = qd_root / "model" / "RTLLM" / "Prob001"
    space = _grid_quantile_space()
    space["initialized"] = False
    space["num_cells"] = 0
    for axis in space["axes"]:
        axis["effective_bins"] = 0
        axis["quantile_boundaries"] = []
    _write_json(problem_dir / "archive_space.json", space)
    (problem_dir / "archive_cells.csv").write_text("candidate_id\n", encoding="utf-8")

    result = export_qd_ppa_visualization(
        run_root=run_root,
        backend_runs=(
            BackendRun("classic", classic_root),
            BackendRun("grid_quantile_pareto_journal_bd", qd_root),
        ),
        archive_source_backend="grid_quantile_pareto_journal_bd",
        output_dir=run_root / "visualization" / "uninitialized",
        subset_config=None,
        selected_problem="RTLLM/Prob001",
        asset_mode="inline",
        strict=True,
        recover_classic_descriptors=False,
    )
    dataset = json.loads(result.dataset_paths[0].read_text(encoding="utf-8"))

    assert dataset["archive_definition"]["initialized"] is False
    assert dataset["archive_projection"]["disclaimer"]
    assert {
        sample["archive_projection_status"]
        for sample in dataset["samples"]
    } == {"archive_uninitialized"}
    assert all(sample["archive_cell_id"] is None for sample in dataset["samples"])
    assert dataset["cell_summaries_by_step"]["final"] == {}
    assert all(
        stats["projected_archive_sample_count"] == 0
        for technique, stats in dataset["technique_stats_by_step"]["final"].items()
        if technique != "_pooled_visible"
    )


def test_projection_rules_cover_grid_quantile_grid_and_cvt() -> None:
    grid_quantile = _grid_quantile_space()
    assert _project_sample(
        grid_quantile,
        descriptors={"logic_depth": 2.0, "ff_depth": 0.0, "comb_width_log": 1.5},
        technique="classic",
    )["archive_cell_id"] == "1,0,1"

    grid = {
        "archive_type": "grid",
        "axes": [
            {"name": "x", "bins": 2, "lower_bound": 0.0, "upper_bound": 10.0},
            {"name": "y", "bins": 2, "lower_bound": 0.0, "upper_bound": 10.0},
        ],
    }
    assert _project_sample(grid, descriptors={"x": 10.0, "y": 0.0}, technique="classic")[
        "archive_cell_id"
    ] == "1,0"

    cvt = {
        "archive_type": "cvt",
        "axes": [{"name": "x"}, {"name": "y"}],
        "space_geometry": {
            "initialized": True,
            "scaler_means": [0.0, 0.0],
            "scaler_stds": [1.0, 1.0],
            "centroids": [[0.0, 0.0], [2.0, 2.0]],
        },
    }
    assert _project_sample(cvt, descriptors={"x": 1.8, "y": 1.9}, technique="classic")[
        "archive_cell_id"
    ] == "1"


def test_graph_recovery_combines_rtl_and_graph_metrics(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: Path,
) -> None:
    code_path = tmp_path / "code.sv"
    code_path.write_text("module top; endmodule\n", encoding="utf-8")

    class FakeRTLDescriptorEvaluator:
        def extract_metrics(
            self,
            *,
            code_text: str,
            code_file_path: str | Path | None,
            mapped_cell_count: float | int | None = None,
        ) -> dict[str, float]:
            return {"rtl_cyclomatic_total_log": 3.0}

    class FakeGraphDescriptorEvaluator:
        def __init__(self, *, yosys_timeout_seconds: int = 30) -> None:
            assert yosys_timeout_seconds == 30

        def extract_metrics(
            self,
            *,
            code_file_path: str | Path | None,
            top_module_name: str | None,
        ) -> dict[str, float]:
            return {
                "reconv_sink_ratio": 0.25,
                "scoap_signal_smoothness": 0.75,
            }

    monkeypatch.setattr(
        "revolution.rtl_descriptor_evaluator.RTLDescriptorEvaluator",
        FakeRTLDescriptorEvaluator,
    )
    monkeypatch.setattr(
        "revolution.graph_descriptor_evaluator.GraphDescriptorEvaluator",
        FakeGraphDescriptorEvaluator,
    )

    _, metrics = _graph_metrics_for_code(
        (
            str(code_path),
            (
                "rtl_cyclomatic_total_log",
                "reconv_sink_ratio",
                "scoap_signal_smoothness",
            ),
        )
    )

    assert metrics == {
        "rtl_cyclomatic_total_log": pytest.approx(math.log1p(3.0)),
        "reconv_sink_ratio": 0.25,
        "scoap_signal_smoothness": 0.75,
    }


def test_export_supports_grid_and_cvt_archive_sources(tmp_path: Path) -> None:
    run_root, classic_root, qd_root = _write_run(tmp_path)
    problem_dir = qd_root / "model" / "RTLLM" / "Prob001"
    grid_space = {
        "archive_type": "grid",
        "num_cells": 8,
        "axes": [
            {"name": "logic_depth", "bins": 2, "lower_bound": 0.0, "upper_bound": 4.0},
            {"name": "ff_depth", "bins": 2, "lower_bound": 0.0, "upper_bound": 2.0},
            {"name": "comb_width_log", "bins": 2, "lower_bound": 0.0, "upper_bound": 3.0},
        ],
    }
    _write_json(problem_dir / "archive_space.json", grid_space)

    grid_result = export_qd_ppa_visualization(
        run_root=run_root,
        backend_runs=(
            BackendRun("classic", classic_root),
            BackendRun("grid_quantile_pareto_journal_bd", qd_root),
        ),
        archive_source_backend="grid_quantile_pareto_journal_bd",
        output_dir=run_root / "visualization" / "grid",
        subset_config=None,
        selected_problem="RTLLM/Prob001",
        asset_mode="inline",
        strict=True,
        recover_classic_descriptors=False,
    )
    grid_dataset = json.loads(grid_result.dataset_paths[0].read_text(encoding="utf-8"))
    assert grid_dataset["archive_definition"]["archive_type"] == "grid"
    assert any(sample["archive_projection_status"] == "projected" for sample in grid_dataset["samples"])

    cvt_space = {
        "archive_type": "cvt",
        "num_cells": 2,
        "axes": [
            {"name": "logic_depth"},
            {"name": "ff_depth"},
            {"name": "comb_width_log"},
        ],
        "space_geometry": {
            "initialized": True,
            "scaler_means": [0.0, 0.0, 0.0],
            "scaler_stds": [1.0, 1.0, 1.0],
            "centroids": [[1.0, 0.0, 2.0], [3.0, 0.0, 1.0]],
        },
    }
    _write_json(problem_dir / "archive_space.json", cvt_space)
    cvt_result = export_qd_ppa_visualization(
        run_root=run_root,
        backend_runs=(
            BackendRun("classic", classic_root),
            BackendRun("grid_quantile_pareto_journal_bd", qd_root),
        ),
        archive_source_backend="grid_quantile_pareto_journal_bd",
        output_dir=run_root / "visualization" / "cvt",
        subset_config=None,
        selected_problem="RTLLM/Prob001",
        asset_mode="inline",
        strict=True,
        recover_classic_descriptors=False,
    )
    cvt_dataset = json.loads(cvt_result.dataset_paths[0].read_text(encoding="utf-8"))
    assert cvt_dataset["archive_definition"]["archive_type"] == "cvt"
    assert cvt_dataset["archive_projection"]["rendering"] == "true_centroid"
    assert any(sample["archive_projection_status"] == "native" for sample in cvt_dataset["samples"])
