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


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run the N07 source-aligned RF extraction smoke on frozen refs.",
    )
    parser.add_argument(
        "--profile",
        default="source_aligned_rf_timing_state_3d",
        choices=["source_aligned_rf_timing_state_3d"],
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
        candidate_id=f"{benchmark}:{problem}:ref",
        descriptors=descriptors,
        quality_score=quality,
        objectives={"g_P": quality, "g_A": quality / 2.0, "g_T": quality / 3.0},
        payload={"benchmark": benchmark, "problem": problem, "rtl": str(path)},
        insertion_index=insertion_index,
    )


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
    assert requirements["requires_source_aligned_rf_timing"] is True

    evaluator = SourceAlignedRTLDescriptorEvaluator(include_rf_timing=True)
    archive = GridQuantileArchive(
        axes,
        warmup_successes=len(SCREEN_REFS),
        cell_mode="pareto_front",
        max_elites_per_cell=5,
        objective_names=("g_P", "g_A", "g_T"),
    )
    members: list[ArchiveMember] = []
    observations: list[dict[str, Any]] = []
    rows: list[dict[str, Any]] = []

    for index, (benchmark, problem, raw_path) in enumerate(SCREEN_REFS):
        path = Path(raw_path)
        assert path.is_file(), f"missing frozen reference RTL: {path}"
        metrics = evaluator.extract_metrics(code_file_path=path, top_module_name=None)
        values = extract_descriptor_values(metrics, axes)
        descriptors = tuple(float(values[axis]) for axis in axes)
        member = _member(
            benchmark=benchmark,
            problem=problem,
            path=path,
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
        rows.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "rtl": str(path),
                "descriptor_values": values,
            }
        )

    assert archive.is_initialized
    health = write_descriptor_health_files(
        json_path=output_dir / "descriptor_health.json",
        report_path=output_dir / "descriptor_health_report.md",
        archive=archive,
        descriptor_axes=axes,
        descriptor_profile=args.profile,
        observations=observations,
        recent_samples=members,
    )
    summary = {
        "status": "pass",
        "profile": args.profile,
        "axes": list(axes),
        "requirements": requirements,
        "input_count": len(rows),
        "inputs": rows,
        "descriptor_health": {
            "initialized": health["initialized"],
            "occupied_cells": health["occupied_cells"],
            "collapsed_axes": health["collapsed_axes"],
            "archive_entry_count": health["archive_entry_count"],
        },
        "note": (
            "Extraction smoke only: frozen reference RTLs, no LLM calls, "
            "no evolutionary result claim. Live N07 screens must still use "
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
