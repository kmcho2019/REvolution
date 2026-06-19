from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

from revolution.auto_bd.stage_dumps import STNOD_STAGE_NAMES

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_sr_pca_artifacts.py"
)
_SPEC = importlib.util.spec_from_file_location("build_sr_pca_artifacts", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_sr_pca_artifacts", mod)
_SPEC.loader.exec_module(mod)


def test_build_artifacts_writes_frozen_sr_pca_files(tmp_path: Path) -> None:
    standard_results = tmp_path / "standard_results"
    _write_candidates(standard_results)
    output_dir = tmp_path / "artifacts"

    payload = mod.build_artifacts(
        standard_results_dir=standard_results,
        output_dir=output_dir,
        method_name="sr_raw_pca_qd",
        dimensions=3,
    )

    artifact_path = output_dir / "sr_raw_pca_artifact.json"
    assert artifact_path.is_file()
    saved = json.loads(artifact_path.read_text(encoding="utf-8"))
    assert saved["descriptor_hash"] == payload["descriptor_hash"]
    assert saved["training_candidate_count"] == 4
    assert "fitness" in saved["forbidden_descriptor_inputs"]
    assert "problem_id" in saved["forbidden_descriptor_inputs"]
    assert (output_dir / "training_candidates.parquet").is_file()
    assert (output_dir / "raw_features.parquet").is_file()
    assert (output_dir / "training_descriptor_vectors.parquet").is_file()


def _write_candidates(standard_results: Path) -> None:
    standard_results.mkdir(parents=True)
    rows = []
    for index in range(5):
        candidate_dir = standard_results.parent / f"candidate_{index}"
        candidate_dir.mkdir()
        rtl_path = candidate_dir / "code.sv"
        netlist_path = candidate_dir / "code.syn.v"
        rtl_path.write_text("module top; endmodule\n", encoding="utf-8")
        netlist_path.write_text(_netlist_text(index + 1), encoding="utf-8")
        _write_stage_dir(candidate_dir, index)
        rows.append(
            {
                "method_name": "synthesis_trajectory_nod",
                "method_family": "synthesis_trajectory_nod",
                "problem_id": "RTLLM/ProbA",
                "seed": 1001,
                "generation": index,
                "candidate_id": f"candidate-{index}",
                "valid_ppa": index != 4,
                "rtl_path": rtl_path.as_posix(),
                "netlist_path": netlist_path.as_posix() if index != 4 else "",
            }
        )
    pd.DataFrame(rows).to_parquet(standard_results / "candidates.parquet", index=False)


def _write_stage_dir(candidate_dir: Path, offset: int) -> None:
    stage_dir = candidate_dir / "top.stnod.stages"
    stage_dir.mkdir()
    for index, stage in enumerate(STNOD_STAGE_NAMES):
        path = stage_dir / f"{stage}.v"
        path.write_text(_netlist_text(index + offset + 1), encoding="utf-8")


def _netlist_text(cell_count: int) -> str:
    cell_types = ("AND2_X1", "MUX2_X1", "ADD_X1")
    instances = "\n".join(
        f"  {cell_types[index % len(cell_types)]} u{index} (.A(a), .B(b), .Y(y{index}));"
        for index in range(cell_count)
    )
    return f"module top(input a, input b, output y0);\n{instances}\nendmodule\n"
