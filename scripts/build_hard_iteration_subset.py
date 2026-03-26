#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import json
import math
import os
import sys
from dataclasses import asdict, dataclass, replace
from pathlib import Path
from typing import Any

import yaml

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.runtime.problem_spec import (  # noqa: E402
    CircuitType,
    infer_circuit_type_from_reference_ppa_path,
)

PRIMARY_FUNCTIONALITY_MIN = 0.1
PRIMARY_FUNCTIONALITY_MAX = 0.6
FALLBACK_FUNCTIONALITY_MAX = 0.8
DEFAULT_MODEL_NAME = "/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b"
DEFAULT_VLLM_HOST = "host.docker.internal"
DEFAULT_VLLM_PORT = 8000
DEFAULT_API_BACKEND = "vllm"
MODE_DEFAULTS = {
    "classic": {"search_mode": "revolution"},
    "grid_struct": {
        "search_mode": "revolution_qd",
        "qd_archive_type": "grid",
        "qd_descriptor_profile": "implemented_structural_compact_3d",
    },
    "cvt_struct": {
        "search_mode": "revolution_qd",
        "qd_archive_type": "cvt",
        "qd_descriptor_profile": "implemented_structural_fixed_5d",
    },
    "cvt_size_control": {
        "search_mode": "revolution_qd",
        "qd_archive_type": "cvt",
        "qd_descriptor_profile": "size_control_3d",
    },
}
MATRIX_DEFAULTS = {
    "population_size": 20,
    "num_generations": 5,
    "evaluation_mode": "search_accelerated",
    "accelerated_synthesis_top_k": 1,
    "total_worker_slots": 2,
    "max_active_problems": 2,
    "max_workers_per_problem": 2,
    "temperature": 1.0,
    "top_p": 1.0,
    "max_tokens": 128000,
    "diff_max_tokens": 128000,
    "qd_num_cells": 16,
    "qd_cvt_warmup_successes": 4,
    "qd_fill_target_fraction": 0.25,
    "qd_cell_reservoir": 2,
    "seed": 42,
}
BENCHMARK_SOURCES = {
    "RTLLM": "scripts/RTLLM.csv",
    "VerilogEval-Spec-to-RTL": "scripts/VerilogEval-Spec-to-RTL.csv",
}
BUCKET_ORDER = [
    ("RTLLM", "combinational"),
    ("RTLLM", "sequential"),
    ("VerilogEval-Spec-to-RTL", "combinational"),
    ("VerilogEval-Spec-to-RTL", "sequential"),
]


@dataclass(frozen=True)
class ProblemDifficultyRow:
    benchmark: str
    problem: str
    reference_gate_count: int
    circuit_type: CircuitType
    functionality_rate: float
    synthesis_rate: float
    difficulty_score: float
    bucket: str
    summary_path: str
    selected: bool = False
    selection_stage: str = ""


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def _safe_float(value: Any, default: float = 0.0) -> float:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return default
    if not math.isfinite(parsed):
        return default
    return parsed


def _load_gate_counts(csv_path: Path, benchmark: str) -> dict[str, int]:
    with csv_path.open("r", encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        gate_counts: dict[str, int] = {}
        for row in reader:
            problem = str(row["Problem"]).strip()
            gate_counts[problem] = int(str(row["Reference Gate Count"]).strip())
    if not gate_counts:
        raise ValueError(f"No gate counts found in {csv_path} for benchmark {benchmark}.")
    return gate_counts


def _load_one_shot_summaries(one_shot_root: Path) -> dict[tuple[str, str], dict[str, Any]]:
    summaries: dict[tuple[str, str], dict[str, Any]] = {}
    for summary_path in sorted(one_shot_root.rglob("*_summary.json")):
        payload = json.loads(summary_path.read_text(encoding="utf-8"))
        benchmark = str(payload.get("benchmark_name") or summary_path.parent.parent.name)
        problem = str(payload.get("problem_name") or summary_path.parent.name)
        summaries[(benchmark, problem)] = {
            "functionality_rate": _extract_rate(
                payload, primary_key="total_functionality", legacy_key="functionality"
            ),
            "synthesis_rate": _extract_rate(
                payload, primary_key="total_synthesis_ppa", legacy_key="synthesis"
            ),
            "summary_path": str(summary_path),
        }
    if not summaries:
        raise FileNotFoundError(
            f"No '*_summary.json' files found under one-shot root '{one_shot_root}'."
        )
    return summaries


def _extract_rate(payload: dict[str, Any], *, primary_key: str, legacy_key: str) -> float:
    for container_key in ("success_rates", "accumulated_success_rates"):
        success_rates = payload.get(container_key)
        if not isinstance(success_rates, dict):
            continue
        if primary_key in success_rates:
            return _safe_float(success_rates.get(primary_key))
        if legacy_key in success_rates:
            return _safe_float(success_rates.get(legacy_key))
    return 0.0


def build_problem_rows(
    *,
    one_shot_root: Path,
    benchmark_root: Path,
    csv_sources: dict[str, Path],
) -> list[ProblemDifficultyRow]:
    summaries = _load_one_shot_summaries(one_shot_root)
    rows: list[ProblemDifficultyRow] = []
    missing_summaries: list[str] = []

    for benchmark, csv_path in csv_sources.items():
        gate_counts = _load_gate_counts(csv_path, benchmark)
        for problem, reference_gate_count in sorted(gate_counts.items()):
            if reference_gate_count < 0:
                continue

            summary = summaries.get((benchmark, problem))
            if summary is None:
                missing_summaries.append(f"{benchmark}/{problem}")
                continue

            circuit_type = infer_circuit_type_from_reference_ppa_path(
                benchmark_root / benchmark / f"{problem}_ppa.txt"
            )
            if circuit_type == "unknown":
                continue

            functionality_rate = summary["functionality_rate"]
            difficulty_score = math.log1p(reference_gate_count) * (1.0 - functionality_rate)
            rows.append(
                ProblemDifficultyRow(
                    benchmark=benchmark,
                    problem=problem,
                    reference_gate_count=reference_gate_count,
                    circuit_type=circuit_type,
                    functionality_rate=functionality_rate,
                    synthesis_rate=summary["synthesis_rate"],
                    difficulty_score=difficulty_score,
                    bucket=f"{benchmark}/{circuit_type}",
                    summary_path=summary["summary_path"],
                )
            )

    if missing_summaries:
        preview = ", ".join(missing_summaries[:8])
        raise FileNotFoundError(
            "Missing one-shot summaries for benchmark problems with gate metadata: "
            f"{preview}"
        )
    return rows


def select_hard_subset(
    rows: list[ProblemDifficultyRow],
    *,
    subset_size: int,
    per_bucket: int,
) -> list[ProblemDifficultyRow]:
    selected: dict[tuple[str, str], ProblemDifficultyRow] = {}

    for benchmark, circuit_type in BUCKET_ORDER:
        bucket_rows = [
            row
            for row in rows
            if row.benchmark == benchmark and row.circuit_type == circuit_type
        ]
        primary_rows = _sort_rows(
            [
                row
                for row in bucket_rows
                if PRIMARY_FUNCTIONALITY_MIN
                <= row.functionality_rate
                <= PRIMARY_FUNCTIONALITY_MAX
            ]
        )
        for row in primary_rows[:per_bucket]:
            selected[(row.benchmark, row.problem)] = replace(
                row, selected=True, selection_stage="primary"
            )

        if len(primary_rows) >= per_bucket:
            continue

        fallback_rows = _sort_rows(
            [
                row
                for row in bucket_rows
                if row.functionality_rate > 0.0
                and row.functionality_rate <= FALLBACK_FUNCTIONALITY_MAX
                and (row.benchmark, row.problem) not in selected
            ]
        )
        remaining = per_bucket - len(
            [row for row in selected.values() if row.benchmark == benchmark and row.circuit_type == circuit_type]
        )
        for row in fallback_rows[:remaining]:
            selected[(row.benchmark, row.problem)] = replace(
                row, selected=True, selection_stage="fallback"
            )

    if len(selected) < subset_size:
        remaining_rows = _sort_rows(
            [
                row
                for row in rows
                if row.functionality_rate > 0.0 and (row.benchmark, row.problem) not in selected
            ]
        )
        for row in remaining_rows:
            if len(selected) >= subset_size:
                break
            selected[(row.benchmark, row.problem)] = replace(
                row, selected=True, selection_stage="borrowed"
            )

    selected_rows = _sort_rows(list(selected.values()))
    if len(selected_rows) < subset_size:
        raise ValueError(
            f"Unable to select {subset_size} hard problems; only found {len(selected_rows)} eligible candidates."
        )
    return selected_rows[:subset_size]


def _sort_rows(rows: list[ProblemDifficultyRow]) -> list[ProblemDifficultyRow]:
    return sorted(
        rows,
        key=lambda row: (
            row.difficulty_score,
            row.reference_gate_count,
            -row.functionality_rate,
            row.problem,
        ),
        reverse=True,
    )


def write_subset_outputs(
    *,
    rows: list[ProblemDifficultyRow],
    selected_rows: list[ProblemDifficultyRow],
    output_config: Path,
    output_csv: Path,
    subset_size: int,
    per_bucket: int,
    model_name: str,
    vllm_host: str,
    vllm_port: int,
    api_backend: str,
) -> None:
    selected_lookup = {(row.benchmark, row.problem): row for row in selected_rows}
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    with output_csv.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "benchmark",
                "problem",
                "reference_gate_count",
                "circuit_type",
                "functionality_rate",
                "synthesis_rate",
                "difficulty_score",
                "bucket",
                "selected",
                "selection_stage",
                "summary_path",
            ],
        )
        writer.writeheader()
        for row in sorted(rows, key=lambda item: (item.benchmark, item.problem)):
            selected_row = selected_lookup.get((row.benchmark, row.problem))
            payload = asdict(selected_row or row)
            writer.writerow(payload)

    problems_by_benchmark: dict[str, list[str]] = {}
    selected_payload: list[dict[str, Any]] = []
    for row in sorted(selected_rows, key=lambda item: (item.benchmark, item.problem)):
        problems_by_benchmark.setdefault(row.benchmark, []).append(row.problem)
        selected_payload.append(asdict(row))

    config_payload = {
        "version": 1,
        "subset_name": "hard_iteration_subset_v1",
        "selection": {
            "subset_size": subset_size,
            "per_bucket_target": per_bucket,
            "primary_functionality_min": PRIMARY_FUNCTIONALITY_MIN,
            "primary_functionality_max": PRIMARY_FUNCTIONALITY_MAX,
            "fallback_functionality_max": FALLBACK_FUNCTIONALITY_MAX,
            "difficulty_formula": "log1p(reference_gate_count) * (1 - functionality_rate)",
        },
        "model": {
            "api_backend": api_backend,
            "model_name": model_name,
            "vllm_host": vllm_host,
            "vllm_port": vllm_port,
        },
        "benchmarks": {
            benchmark: {"problems": problems}
            for benchmark, problems in problems_by_benchmark.items()
        },
        "matrix_defaults": MATRIX_DEFAULTS,
        "modes": MODE_DEFAULTS,
        "selected_problems": selected_payload,
    }
    output_config.parent.mkdir(parents=True, exist_ok=True)
    output_config.write_text(
        yaml.safe_dump(config_payload, sort_keys=False),
        encoding="utf-8",
    )


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build a hard iteration subset from one-shot benchmark results."
    )
    parser.add_argument("--one-shot-root", type=Path, required=True)
    parser.add_argument("--subset-size", type=int, default=16)
    parser.add_argument("--per-bucket", type=int, default=4)
    parser.add_argument(
        "--output-config",
        type=Path,
        default=Path("data/configs/hard_iteration_subset.yaml"),
    )
    parser.add_argument(
        "--output-csv",
        type=Path,
        default=Path("baselines/hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv"),
    )
    parser.add_argument(
        "--benchmark-root",
        type=Path,
        default=Path("data/bench"),
    )
    parser.add_argument(
        "--rtllm-csv",
        type=Path,
        default=Path(BENCHMARK_SOURCES["RTLLM"]),
    )
    parser.add_argument(
        "--verilogeval-csv",
        type=Path,
        default=Path(BENCHMARK_SOURCES["VerilogEval-Spec-to-RTL"]),
    )
    parser.add_argument("--model-name", type=str, default=DEFAULT_MODEL_NAME)
    parser.add_argument("--api-backend", type=str, default=DEFAULT_API_BACKEND)
    parser.add_argument("--vllm-host", type=str, default=DEFAULT_VLLM_HOST)
    parser.add_argument("--vllm-port", type=int, default=DEFAULT_VLLM_PORT)
    return parser.parse_args()


def main() -> int:
    args = _parse_args()
    repo_root = _repo_root()
    csv_sources = {
        "RTLLM": (repo_root / args.rtllm_csv).resolve(),
        "VerilogEval-Spec-to-RTL": (repo_root / args.verilogeval_csv).resolve(),
    }
    rows = build_problem_rows(
        one_shot_root=args.one_shot_root.resolve(),
        benchmark_root=(repo_root / args.benchmark_root).resolve(),
        csv_sources=csv_sources,
    )
    selected_rows = select_hard_subset(
        rows,
        subset_size=args.subset_size,
        per_bucket=args.per_bucket,
    )
    write_subset_outputs(
        rows=rows,
        selected_rows=selected_rows,
        output_config=(repo_root / args.output_config).resolve(),
        output_csv=(repo_root / args.output_csv).resolve(),
        subset_size=args.subset_size,
        per_bucket=args.per_bucket,
        model_name=args.model_name,
        vllm_host=args.vllm_host,
        vllm_port=args.vllm_port,
        api_backend=args.api_backend,
    )

    print("Selected hard iteration subset:")
    for row in selected_rows:
        print(
            f"- {row.benchmark}/{row.problem}: gate_count={row.reference_gate_count}, "
            f"circuit_type={row.circuit_type}, functionality_rate={row.functionality_rate:.3f}, "
            f"difficulty_score={row.difficulty_score:.3f}, selection_stage={row.selection_stage}"
        )
    print(f"Wrote config to {args.output_config}")
    print(f"Wrote baseline CSV to {args.output_csv}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
