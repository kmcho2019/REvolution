#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import json
import os
import shutil
import sys
from pathlib import Path
from typing import Any

import pandas as pd

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.auto_bd.sr_pca_descriptor import (  # noqa: E402
    SR_PCA_AXES,
    sr_pca_artifact_from_json,
    sr_raw_feature_values,
    transform_sr_raw_pca,
)
from revolution.evaluation import SynthesisEvaluator  # noqa: E402
from revolution.qd.archive import GridQuantileArchive  # noqa: E402
from revolution.qd.artifacts import write_descriptor_health_files  # noqa: E402
from revolution.qd.descriptors import (  # noqa: E402
    descriptor_requirements,
    load_sr_pca_artifact_path,
    resolve_descriptor_axes,
)
from revolution.qd.types import ArchiveMember  # noqa: E402

PUSH_ROOT = Path(
    "docs/journal_features/revamp_history/20260703_121857_KST_natural_qd_push"
)
DESCRIPTOR_FILE = PUSH_ROOT / "lanes/N10_sr_relu_pca/descriptor_profile.yaml"
SCREEN_MANIFEST = PUSH_ROOT / "tables/screen_manifest.csv"
V2_ANCHOR_ROOT = Path(
    "exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/"
    "smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b"
)


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run the bounded N10 SR-ReLU PCA extraction smoke.",
    )
    parser.add_argument("--output-dir", required=True)
    return parser


def _manifest_rows() -> list[dict[str, str]]:
    with SCREEN_MANIFEST.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def _top_module(benchmark: str, problem: str) -> str:
    path = Path("data/bench") / benchmark / "synthesis_top_module_names.json"
    payload = json.loads(path.read_text(encoding="utf-8"))
    top = payload[problem]
    assert isinstance(top, str)
    return top


def _candidate_paths(benchmark: str, problem: str) -> tuple[Path, Path]:
    root = V2_ANCHOR_ROOT / benchmark / problem
    assert root.is_dir(), root
    metrics_path = sorted(root.glob("Gen*/*/code_synthesis_report.metrics.json"))[0]
    code_path = metrics_path.parent / "code.sv"
    netlist_path = metrics_path.parent / "code.syn.v"
    assert code_path.is_file(), code_path
    assert netlist_path.is_file(), netlist_path
    return code_path, netlist_path


def _member(row: dict[str, Any], axes: tuple[str, ...], index: int) -> ArchiveMember:
    quality = 1.0 - index * 0.01
    return ArchiveMember(
        candidate_id=str(row["candidate_id"]),
        descriptors=tuple(float(row[axis]) for axis in axes),
        quality_score=quality,
        objectives={"g_P": quality, "g_A": quality / 2.0, "g_T": quality / 3.0},
        payload={"benchmark": row["benchmark"], "problem": row["problem"]},
        insertion_index=index,
    )


def _write_rows(path: Path, rows: list[dict[str, Any]], axes: tuple[str, ...]) -> None:
    fields = [
        "benchmark",
        "problem",
        "candidate_id",
        "top_module",
        "code_path",
        "netlist_path",
        "stage_dump_success",
        *axes,
    ]
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _artifact_summary(artifact_path: Path) -> dict[str, Any]:
    payload = json.loads(artifact_path.read_text(encoding="utf-8"))
    training = pd.read_parquet(artifact_path.parent / "training_candidates.parquet")
    return {
        "descriptor_version": payload["descriptor_version"],
        "training_candidate_count": payload["training_candidate_count"],
        "training_problem_count": int(training["problem_id"].nunique()),
        "training_problems": sorted(str(item) for item in training["problem_id"].unique()),
        "feature_schema_hash": payload["feature_schema_hash"],
        "scaler_hash": payload["scaler_hash"],
        "random_feature_map_kind": payload["random_feature_map_kind"],
        "random_feature_count": payload["random_feature_count"],
        "random_feature_seed": payload["random_feature_seed"],
        "random_feature_map_hash": payload["random_feature_map_hash"],
        "pca_hash": payload["pca_hash"],
        "descriptor_hash": payload["descriptor_hash"],
    }


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    axes = tuple(
        resolve_descriptor_axes(
            profile_name="sr_pca_3d",
            explicit_axes=None,
            descriptor_file=DESCRIPTOR_FILE,
            archive_type="grid_quantile",
            circuit_type="sequential",
        )
    )
    assert axes == SR_PCA_AXES[:3]
    requirements = descriptor_requirements(axes)
    assert requirements["requires_ppa"] is False
    assert requirements["requires_auto_bd_sr_pca"] is True

    artifact_path = load_sr_pca_artifact_path(DESCRIPTOR_FILE)
    artifact_payload = json.loads(artifact_path.read_text(encoding="utf-8"))
    artifact = sr_pca_artifact_from_json(artifact_payload)
    assert artifact.random_map.kind == "relu"
    artifact_summary = _artifact_summary(artifact_path)

    manifest_rows = _manifest_rows()
    screen_problems = [f"{row['benchmark']}/{row['problem']}" for row in manifest_rows]
    overlap = sorted(set(screen_problems) & set(artifact_summary["training_problems"]))
    assert not overlap, overlap

    evaluator = SynthesisEvaluator()
    rows: list[dict[str, Any]] = []
    observations: list[dict[str, Any]] = []
    for index, manifest_row in enumerate(manifest_rows):
        benchmark = manifest_row["benchmark"]
        problem = manifest_row["problem"]
        code_path, netlist_path = _candidate_paths(benchmark, problem)
        sample_dir = output_dir / f"{benchmark}__{problem}"
        sample_dir.mkdir()
        top_module = _top_module(benchmark, problem)
        stage_result = evaluator.run_yosys_stage_dumps(
            verilog_file=str(code_path),
            synth_top_module_name=top_module,
            output_directory=str(sample_dir),
        )
        assert stage_result["stage_dump_success"], stage_result["stage_dump_log_path"]
        raw_values = sr_raw_feature_values(
            final_netlist_text=netlist_path.read_text(
                encoding="utf-8",
                errors="ignore",
            ),
            stage_verilog_paths=tuple(
                Path(str(path)) for path in stage_result["stage_dump_verilog_paths"]
            ),
        )
        shutil.rmtree(Path(str(stage_result["stage_dump_dir"])))
        Path(str(stage_result["stage_dump_log_path"])).unlink()
        Path(str(stage_result["stage_dump_script_path"])).unlink()
        for generated_path in sample_dir.glob("*.stnod.abc.constr"):
            generated_path.unlink()
        projected = transform_sr_raw_pca(artifact, raw_values)
        descriptor_values = {
            axis: float(value)
            for axis, value in zip(axes, projected, strict=True)
        }
        candidate_id = f"{benchmark}:{problem}:v2_anchor_first"
        row = {
            "benchmark": benchmark,
            "problem": problem,
            "candidate_id": candidate_id,
            "top_module": top_module,
            "code_path": str(code_path),
            "netlist_path": str(netlist_path),
            "stage_dump_success": "true",
            **descriptor_values,
        }
        rows.append(row)
        observations.append(
            {
                "candidate_id": candidate_id,
                "decision": "observed",
                "descriptor_values": descriptor_values,
            }
        )

    archive = GridQuantileArchive(
        axes,
        warmup_successes=len(rows),
        cell_mode="pareto_front",
        max_elites_per_cell=5,
        objective_names=("g_P", "g_A", "g_T"),
    )
    members = [_member(row, axes, index) for index, row in enumerate(rows)]
    for member in members:
        archive.insert(member)
    health = write_descriptor_health_files(
        json_path=output_dir / "descriptor_health.json",
        report_path=output_dir / "descriptor_health_report.md",
        archive=archive,
        descriptor_axes=axes,
        descriptor_profile="sr_pca_3d",
        observations=observations,
        recent_samples=members,
    )
    _write_rows(output_dir / "descriptor_values.csv", rows, axes)
    summary = {
        "status": (
            "pass"
            if health["initialized"] and not health["collapsed_axes"]
            else "fail"
        ),
        "profile": "sr_pca_3d",
        "descriptor_file": str(DESCRIPTOR_FILE),
        "artifact_file": str(artifact_path),
        "axes": list(axes),
        "requirements": requirements,
        "screen_problem_count": len(screen_problems),
        "screen_training_overlap": overlap,
        "artifact": artifact_summary,
        "descriptor_health": {
            "initialized": health["initialized"],
            "occupied_cells": health["occupied_cells"],
            "collapsed_axes": health["collapsed_axes"],
            "archive_entry_count": health["archive_entry_count"],
        },
        "note": (
            "Extraction smoke only: existing V2 seed-1001 candidates, "
            "new ST-NOD stage dumps, no LLM calls, no HV claim."
        ),
    }
    (output_dir / "extraction_smoke_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
