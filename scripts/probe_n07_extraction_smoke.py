#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Any

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.qd.archive import GridQuantileArchive  # noqa: E402
from revolution.qd.artifacts import write_descriptor_health_files  # noqa: E402
from revolution.qd.descriptors import (  # noqa: E402
    descriptor_requirements,
    extract_descriptor_values,
    resolve_descriptor_axes,
)
from revolution.qd.types import ArchiveMember  # noqa: E402
from revolution.source_aligned_descriptor_evaluator import (  # noqa: E402
    SourceAlignedRTLDescriptorEvaluator,
)


SCREEN_REFS = (
    ("RTLLM", "Prob015_multi_pipe_8bit", "data/bench/RTLLM/Prob015_multi_pipe_8bit_ref.sv"),
    ("RTLLM", "Prob024_fsm", "data/bench/RTLLM/Prob024_fsm_ref.sv"),
    ("RTLLM", "Prob041_traffic_light", "data/bench/RTLLM/Prob041_traffic_light_ref.sv"),
    ("RTLLM", "Prob045_alu", "data/bench/RTLLM/Prob045_alu_ref.sv"),
    ("RTLLM", "Prob049_signal_generator", "data/bench/RTLLM/Prob049_signal_generator_ref.sv"),
    ("VerilogEval-Spec-to-RTL", "Prob116_m2014_q3", "data/bench/VerilogEval-Spec-to-RTL/Prob116_m2014_q3_ref.sv"),
    ("VerilogEval-Spec-to-RTL", "Prob135_m2014_q6b", "data/bench/VerilogEval-Spec-to-RTL/Prob135_m2014_q6b_ref.sv"),
    ("VerilogEval-Spec-to-RTL", "Prob153_gshare", "data/bench/VerilogEval-Spec-to-RTL/Prob153_gshare_ref.sv"),
)
V2_ANCHOR_METRICS_ROOT = Path(
    "exp/natural_qd_push/p0_v2_anchor_20260703_041511_UTC/live/"
    "smooth_qd_v2_8x5/seed_1001/openai_gpt-oss-120b"
)


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run a bounded N07 descriptor extraction smoke.",
    )
    parser.add_argument(
        "--profile",
        default="source_aligned_rf_timing_state_3d",
        choices=[
            "source_aligned_rf_timing_state_3d",
            "implemented_structural_compact_3d",
        ],
    )
    parser.add_argument("--output-dir", required=True)
    return parser


def _member(
    *,
    benchmark: str,
    problem: str,
    path: Path,
    descriptors: tuple[float, ...],
    insertion_index: int,
) -> ArchiveMember:
    quality = 1.0 - insertion_index * 0.01
    return ArchiveMember(
        candidate_id=f"{benchmark}:{problem}:{insertion_index}",
        descriptors=descriptors,
        quality_score=quality,
        objectives={"g_P": quality, "g_A": quality / 2.0, "g_T": quality / 3.0},
        payload={"benchmark": benchmark, "problem": problem, "rtl": str(path)},
        insertion_index=insertion_index,
    )


def _source_aligned_rows(axes: tuple[str, ...]) -> list[dict[str, Any]]:
    evaluator = SourceAlignedRTLDescriptorEvaluator(include_rf_timing=True)
    rows: list[dict[str, Any]] = []
    for benchmark, problem, raw_path in SCREEN_REFS:
        path = Path(raw_path)
        assert path.is_file(), f"missing frozen reference RTL: {path}"
        metrics = evaluator.extract_metrics(code_file_path=path, top_module_name=None)
        rows.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "rtl": str(path),
                "descriptor_values": extract_descriptor_values(metrics, axes),
            }
        )
    return rows


def _structural_rows(axes: tuple[str, ...]) -> list[dict[str, Any]]:
    assert V2_ANCHOR_METRICS_ROOT.is_dir(), V2_ANCHOR_METRICS_ROOT
    rows: list[dict[str, Any]] = []
    for benchmark, problem, _ in SCREEN_REFS:
        problem_dir = V2_ANCHOR_METRICS_ROOT / benchmark / problem
        assert problem_dir.is_dir(), problem_dir
        paths = sorted(problem_dir.glob("Gen*/*/code_synthesis_report.metrics.json"))
        assert paths, problem_dir
        for path in paths:
            payload = json.loads(path.read_text(encoding="utf-8"))
            metrics = payload["structural_metrics"]
            assert isinstance(metrics, dict)
            rows.append(
                {
                    "benchmark": benchmark,
                    "problem": problem,
                    "metrics": str(path),
                    "descriptor_values": extract_descriptor_values(metrics, axes),
                }
            )
    return rows


def main(argv: list[str] | None = None) -> int:
    args = _build_parser().parse_args(argv)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    axes = tuple(
        resolve_descriptor_axes(
            profile_name=args.profile,
            explicit_axes=None,
            descriptor_file=None,
            archive_type="grid_quantile",
            circuit_type="sequential",
        )
    )
    requirements = descriptor_requirements(axes)
    assert requirements["requires_ppa"] is False
    if args.profile == "source_aligned_rf_timing_state_3d":
        assert requirements["requires_source_aligned_rf_timing"] is True
        smoke_rows = _source_aligned_rows(axes)
        note_source = "frozen reference RTLs"
    elif args.profile == "implemented_structural_compact_3d":
        assert requirements["requires_synthesis"] is True
        smoke_rows = _structural_rows(axes)
        note_source = "existing V2 anchor synthesis metrics"
    else:
        raise ValueError(args.profile)

    archive = GridQuantileArchive(
        axes,
        warmup_successes=len(smoke_rows),
        cell_mode="pareto_front",
        max_elites_per_cell=5,
        objective_names=("g_P", "g_A", "g_T"),
    )
    members: list[ArchiveMember] = []
    observations: list[dict[str, Any]] = []

    for index, row in enumerate(smoke_rows):
        benchmark = row["benchmark"]
        problem = row["problem"]
        values = row["descriptor_values"]
        artifact_path = row.get("rtl") or row.get("metrics")
        assert isinstance(artifact_path, str)
        descriptors = tuple(float(values[axis]) for axis in axes)
        member = _member(
            benchmark=benchmark,
            problem=problem,
            path=Path(artifact_path),
            descriptors=descriptors,
            insertion_index=index,
        )
        result = archive.insert(member)
        members.append(member)
        observations.append(
            {
                "candidate_id": member.candidate_id,
                "decision": result.decision,
                "descriptor_values": values,
            }
        )

    health = write_descriptor_health_files(
        json_path=output_dir / "descriptor_health.json",
        report_path=output_dir / "descriptor_health_report.md",
        archive=archive,
        descriptor_axes=axes,
        descriptor_profile=args.profile,
        observations=observations,
        recent_samples=members,
    )
    problem_counts: dict[str, int] = {}
    for row in smoke_rows:
        key = f"{row['benchmark']}/{row['problem']}"
        problem_counts[key] = problem_counts.get(key, 0) + 1
    summary = {
        "status": (
            "pass"
            if health["initialized"] and not health["collapsed_axes"]
            else "fail"
        ),
        "profile": args.profile,
        "axes": list(axes),
        "requirements": requirements,
        "input_count": len(smoke_rows),
        "problem_counts": problem_counts,
        "descriptor_health": {
            "initialized": health["initialized"],
            "occupied_cells": health["occupied_cells"],
            "collapsed_axes": health["collapsed_axes"],
            "archive_entry_count": health["archive_entry_count"],
        },
        "note": (
            f"Extraction smoke only: {note_source}, no LLM calls, "
            "no new evolutionary result claim. Live N07 screens must still use "
            "qd_operator_kind=eoh_strategies."
        ),
    }
    (output_dir / "extraction_smoke_summary.json").write_text(
        json.dumps(summary, indent=2),
        encoding="utf-8",
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
