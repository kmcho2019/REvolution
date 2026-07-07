from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

import numpy as np
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

import scripts.probe_n10_sr_relu_smoke as smoke  # noqa: E402
from revolution.auto_bd.sr_pca_descriptor import (  # noqa: E402
    fit_sr_random_relu_pca_artifact,
    sr_pca_artifact_to_json,
    sr_raw_feature_axes,
)
from revolution.auto_bd.stage_dumps import STNOD_STAGE_NAMES  # noqa: E402


class FakeSynthesisEvaluator:
    def run_yosys_stage_dumps(
        self,
        *,
        verilog_file: str,
        synth_top_module_name: str,
        output_directory: str,
    ) -> dict[str, Any]:
        stage_dir = Path(output_directory) / f"{synth_top_module_name}.stnod.stages"
        stage_dir.mkdir()
        paths = []
        for index, stage in enumerate(STNOD_STAGE_NAMES):
            path = stage_dir / f"{stage}.v"
            path.write_text(_netlist(index + 1), encoding="utf-8")
            paths.append(str(path))
        log_path = Path(output_directory) / "stage.log"
        script_path = Path(output_directory) / "stage.tcl"
        log_path.write_text("ok\n", encoding="utf-8")
        script_path.write_text("ok\n", encoding="utf-8")
        return {
            "stage_dump_success": True,
            "stage_dump_log_path": str(log_path),
            "stage_dump_script_path": str(script_path),
            "stage_dump_dir": str(stage_dir),
            "stage_dump_verilog_paths": paths,
        }


def test_n10_sr_relu_smoke_writes_health(monkeypatch, tmp_path: Path) -> None:
    descriptor_file = _write_descriptor_file(tmp_path)
    manifest = tmp_path / "screen_manifest.csv"
    manifest.write_text(
        "benchmark,problem\nRTLLM,Prob001\nRTLLM,Prob002\n",
        encoding="utf-8",
    )
    anchor = tmp_path / "anchor"
    for problem in ("Prob001", "Prob002"):
        sample = anchor / "RTLLM" / problem / "Gen0" / "sample1"
        sample.mkdir(parents=True)
        (sample / "code_synthesis_report.metrics.json").write_text("{}", encoding="utf-8")
        (sample / "code.sv").write_text("module top; endmodule\n", encoding="utf-8")
        (sample / "code.syn.v").write_text(_netlist(4), encoding="utf-8")
    top_names = tmp_path / "data" / "bench" / "RTLLM"
    top_names.mkdir(parents=True)
    (top_names / "synthesis_top_module_names.json").write_text(
        json.dumps({"Prob001": "top", "Prob002": "top"}),
        encoding="utf-8",
    )

    monkeypatch.chdir(tmp_path)
    monkeypatch.setattr(smoke, "DESCRIPTOR_FILE", descriptor_file)
    monkeypatch.setattr(smoke, "SCREEN_MANIFEST", manifest)
    monkeypatch.setattr(smoke, "V2_ANCHOR_ROOT", anchor)
    monkeypatch.setattr(smoke, "SynthesisEvaluator", FakeSynthesisEvaluator)

    rc = smoke.main(["--output-dir", str(tmp_path / "out")])

    summary = json.loads((tmp_path / "out" / "extraction_smoke_summary.json").read_text())
    assert rc == 0
    assert summary["profile"] == "sr_pca_3d"
    assert summary["requirements"]["requires_auto_bd_sr_pca"] is True
    assert summary["screen_training_overlap"] == []
    assert summary["screen_problem_count"] == 2
    assert (tmp_path / "out" / "descriptor_health.json").is_file()
    assert (tmp_path / "out" / "descriptor_values.csv").is_file()
    assert not list((tmp_path / "out").glob("*/*.stnod.stages"))
    assert not list((tmp_path / "out").glob("*/*.stnod.yosys.log"))


def _write_descriptor_file(tmp_path: Path) -> Path:
    artifact_dir = tmp_path / "artifact"
    artifact_dir.mkdir()
    matrix = np.array(
        [
            [float(row + col) for col in range(len(sr_raw_feature_axes()))]
            for row in range(8)
        ],
        dtype=float,
    )
    artifact = fit_sr_random_relu_pca_artifact(
        matrix,
        dimensions=3,
        random_feature_count=8,
        random_feature_seed=123,
    )
    payload = sr_pca_artifact_to_json(artifact)
    payload.update(
        {
            "training_candidate_count": 2,
            "random_feature_map_kind": artifact.random_map.kind,
            "random_feature_count": artifact.random_map.feature_count,
            "random_feature_seed": artifact.random_map.seed,
            "random_feature_map_hash": artifact.random_map.random_feature_map_hash,
        }
    )
    (artifact_dir / "sr_random_relu_pca_artifact.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    pd.DataFrame(
        {
            "problem_id": ["RTLLM/Train001", "RTLLM/Train002"],
            "candidate_id": ["a", "b"],
        }
    ).to_parquet(artifact_dir / "training_candidates.parquet", index=False)
    descriptor_file = tmp_path / "descriptor_profile.yaml"
    descriptor_file.write_text(
        "sr_pca_artifact: artifact/sr_random_relu_pca_artifact.json\n"
        "profiles:\n"
        "  sr_pca_3d:\n"
        "    - sr_pca_0\n"
        "    - sr_pca_1\n"
        "    - sr_pca_2\n",
        encoding="utf-8",
    )
    return descriptor_file


def _netlist(cell_count: int) -> str:
    rows = "\n".join(
        f"  AND2_X1 u{index} (.A(a), .B(b), .Y(y{index}));"
        for index in range(cell_count)
    )
    return f"module top(input a, input b, output y0);\n{rows}\nendmodule\n"
