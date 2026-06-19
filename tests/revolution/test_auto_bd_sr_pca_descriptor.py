from __future__ import annotations

import json
from pathlib import Path
from typing import Any, cast

import numpy as np

from revolution.auto_bd.sr_pca_descriptor import (
    SR_PCA_AXES,
    fit_sr_raw_pca_artifact,
    sr_pca_artifact_from_json,
    sr_pca_artifact_to_json,
    sr_raw_feature_axes,
    sr_raw_feature_values,
    transform_sr_raw_pca,
)
from revolution.auto_bd.stage_dumps import STNOD_STAGE_NAMES
from revolution.qd.engine import QDEngine


def test_sr_raw_feature_schema_excludes_leakage_inputs(tmp_path: Path) -> None:
    stage_paths = _write_stage_files(tmp_path, "sample")
    final_netlist = _netlist_text(("AND2_X1", "MUX2_X1", "ADD_X1"))

    values = sr_raw_feature_values(
        final_netlist_text=final_netlist,
        stage_verilog_paths=stage_paths,
    )

    axes = sr_raw_feature_axes()
    assert set(values) == set(axes)
    assert "fitness" not in axes
    assert "hypervolume" not in axes
    assert "ppa" not in axes
    assert "problem_id" not in axes
    assert values["final_cell_count_log"] > 0.0
    assert values["stnod_logic_swing"] >= 0.0


def test_sr_raw_pca_artifact_round_trips_and_projects() -> None:
    matrix = np.array(
        [
            [float(row + col) for col in range(len(sr_raw_feature_axes()))]
            for row in range(6)
        ],
        dtype=float,
    )

    artifact = fit_sr_raw_pca_artifact(matrix, dimensions=3)
    payload = sr_pca_artifact_to_json(artifact)
    loaded = sr_pca_artifact_from_json(payload)
    raw_values = {
        axis: float(index)
        for index, axis in enumerate(sr_raw_feature_axes())
    }

    descriptor = transform_sr_raw_pca(loaded, raw_values)

    assert loaded.descriptor_hash == artifact.descriptor_hash
    assert len(descriptor) == 3
    assert payload["raw_feature_schema_version"] == "synthesis_response_raw_v1"
    assert list(SR_PCA_AXES[:3]) == ["sr_pca_0", "sr_pca_1", "sr_pca_2"]


def test_qd_engine_extracts_sr_pca_descriptor_values(tmp_path: Path) -> None:
    stage_paths = _write_stage_files(tmp_path, "candidate")
    netlist_path = tmp_path / "code.syn.v"
    netlist_path.write_text(_netlist_text(("AND2_X1", "MUX2_X1", "ADD_X1")), encoding="utf-8")
    matrix = np.array(
        [
            [float(row + col) for col in range(len(sr_raw_feature_axes()))]
            for row in range(6)
        ],
        dtype=float,
    )
    artifact = fit_sr_raw_pca_artifact(matrix, dimensions=3)
    artifact_path = tmp_path / "sr_raw_pca_artifact.json"
    artifact_path.write_text(
        json.dumps(sr_pca_artifact_to_json(artifact), indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    descriptor_file = tmp_path / "descriptor_profile.yaml"
    descriptor_file.write_text(
        "sr_pca_artifact: sr_raw_pca_artifact.json\n"
        "profiles:\n"
        "  sr_pca_3d:\n"
        "    - sr_pca_0\n"
        "    - sr_pca_1\n"
        "    - sr_pca_2\n",
        encoding="utf-8",
    )
    engine = object.__new__(QDEngine)
    engine.qd_archive_type = "grid"
    engine.qd_grid_axes = ("sr_pca_0", "sr_pca_1", "sr_pca_2")
    engine.qd_descriptor_file = str(descriptor_file)
    engine._sr_pca_artifact = None

    values = QDEngine._extract_candidate_descriptor_values(
        engine,
        cast(Any, object()),
        {
            "synthesis_success": True,
            "ppa_success": True,
            "synthesized_netlist_path": netlist_path.as_posix(),
            "stage_dump_verilog_paths": [path.as_posix() for path in stage_paths],
        },
    )

    assert set(values) == {"sr_pca_0", "sr_pca_1", "sr_pca_2"}
    assert all(isinstance(value, float) for value in values.values())


def _write_stage_files(tmp_path: Path, name: str) -> tuple[Path, ...]:
    stage_dir = tmp_path / f"{name}.stnod.stages"
    stage_dir.mkdir()
    paths = []
    for index, stage in enumerate(STNOD_STAGE_NAMES):
        cells = ("AND2_X1", "MUX2_X1", "ADD_X1")[: (index % 3) + 1]
        path = stage_dir / f"{stage}.v"
        path.write_text(_netlist_text(cells), encoding="utf-8")
        paths.append(path)
    return tuple(paths)


def _netlist_text(cells: tuple[str, ...]) -> str:
    instances = "\n".join(
        f"  {cell} u{index} (.A(a), .B(b), .Y(y{index}));"
        for index, cell in enumerate(cells)
    )
    return f"module top(input a, input b, output y0);\n{instances}\nendmodule\n"
