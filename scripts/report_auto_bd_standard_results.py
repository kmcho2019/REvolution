#!/usr/bin/env python3
"""Report cross-method Auto-BD metrics from standard result directories."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
from typing import Any

import pandas as pd

from revolution.qd.pareto_analysis import (
    compute_candidate_improvements,
    hypervolume,
    objective_metrics_for_reference,
    pareto_front,
)

REPO_ROOT = Path(__file__).resolve().parents[1]
METHOD_ORDER = (
    "classic_revolution",
    "landing_smooth_qd_manual_bd",
    "random_descriptor_qd",
    "simple_yosys_stat_bd",
    "netlist_motif_occupancy",
    "synthesis_trajectory_nod",
)
FITNESS_EPSILON = 0.03
HV_EPSILON = 1e-9
REFERENCE_METHOD = "classic_revolution"


def build_report(
    *,
    results_root: Path,
    repo_root: Path,
    phase: str,
    seed: int,
) -> dict[str, Any]:
    """Build centralized seed-level report data from standard result tables."""

    result_dirs = standard_result_dirs(results_root)
    assert REFERENCE_METHOD in result_dirs, f"missing {REFERENCE_METHOD}"
    per_method = {
        method: load_method_result(method, path, repo_root)
        for method, path in sorted(result_dirs.items(), key=method_sort_key)
    }
    classic_problems = covered_problems(per_method[REFERENCE_METHOD]["problem_metrics"])
    gate_rows = [
        gate_row(method, payload["problem_metrics"], classic_problems)
        for method, payload in per_method.items()
    ]
    leaderboard_rows = [
        leaderboard_row(method, payload, per_method[REFERENCE_METHOD])
        for method, payload in per_method.items()
    ]
    comparison_rows = per_problem_comparison_rows(per_method)
    problem_rows = [
        row
        for payload in per_method.values()
        for row in payload["problem_metrics"]
    ]
    return {
        "version": 1,
        "phase": phase,
        "seed": seed,
        "reference_method": REFERENCE_METHOD,
        "normalization": normalization_payload(),
        "gate_matrix": gate_rows,
        "leaderboard": leaderboard_rows,
        "comparison_matrix": comparison_rows,
        "problem_metrics": problem_rows,
        "artifact_roots": {
            method: path.as_posix()
            for method, path in sorted(result_dirs.items(), key=method_sort_key)
        },
    }


def standard_result_dirs(results_root: Path) -> dict[str, Path]:
    assert results_root.is_dir(), f"missing results root: {results_root}"
    rows: dict[str, Path] = {}
    for path in sorted(results_root.glob("*/seed_*/standard_results")):
        assert path.is_dir()
        rows[path.parents[1].name] = path
    assert rows, f"no standard_results directories under: {results_root}"
    return rows


def load_method_result(method: str, result_dir: Path, repo_root: Path) -> dict[str, Any]:
    candidates = pd.read_parquet(result_dir / "candidates.parquet")
    per_generation = pd.read_parquet(result_dir / "per_generation_metrics.parquet")
    archive = pd.read_parquet(result_dir / "archive_snapshots.parquet")
    summary = load_json(result_dir / "method_summary.json")
    problem_rows = [
        problem_metric_row(method, str(problem_id), group, repo_root)
        for problem_id, group in candidates.groupby("problem_id", sort=True)
    ]
    return {
        "summary": summary,
        "problem_metrics": problem_rows,
        "archive": archive.to_dict("records"),
        "generation": per_generation.to_dict("records"),
    }


def problem_metric_row(
    method: str,
    problem_id: str,
    candidates: pd.DataFrame,
    repo_root: Path,
) -> dict[str, Any]:
    benchmark, problem = problem_id.split("/", 1)
    ref_metrics = load_reference_ppa(repo_root, benchmark, problem)
    objective_metrics = objective_metrics_for_reference(ref_metrics)
    valid = candidates.loc[candidates["valid_ppa"].eq(True)].copy()
    points = ppa_points(valid, ref_metrics, objective_metrics)
    front_indexes = pareto_front([row["point"] for row in points]) if points else []
    front = [points[index] for index in front_indexes]
    best_fitness = finite_max(valid["fitness"].tolist())
    ppa_front_hashes = {
        str(row["canonical_netlist_hash"])
        for row in front
        if row["canonical_netlist_hash"]
    }
    return {
        "method_name": method,
        "problem_id": problem_id,
        "benchmark_source": benchmark,
        "valid_ppa_candidate_count": int(len(valid)),
        "best_fitness": best_fitness,
        "objective_metrics": list(objective_metrics),
        "reference_metrics": {
            metric: ref_metrics[metric]
            for metric in objective_metrics
        },
        "pareto_point_count": len(front),
        "hypervolume": hypervolume([row["point"] for row in front]),
        "reference_beating_count": sum(
            1
            for row in points
            if all(value >= -1e-12 for value in row["point"])
            and any(value > 1e-12 for value in row["point"])
        ),
        "unique_canonical_netlist_count": nunique(valid, "canonical_netlist_hash"),
        "unique_motif_signature_count": nunique(valid, "motif_signature_hash"),
        "duplicate_netlist_count": int(len(valid)) - nunique(valid, "canonical_netlist_hash"),
        "ppa_front_unique_netlist_count": len(ppa_front_hashes),
        "best_improvements": best_improvements(front, objective_metrics),
    }


def ppa_points(
    candidates: pd.DataFrame,
    ref_metrics: dict[str, float],
    objective_metrics: tuple[str, ...],
) -> list[dict[str, Any]]:
    rows = []
    for row in candidates.to_dict("records"):
        ppa = {
            "area": row.get("area"),
            "power": row.get("power"),
            "eff_clk_period": row.get("timing_or_clock_period"),
        }
        improvements = compute_candidate_improvements(ppa, ref_metrics, objective_metrics)
        if improvements is None:
            continue
        rows.append(
            {
                "point": tuple(improvements[metric] for metric in objective_metrics),
                "canonical_netlist_hash": row.get("canonical_netlist_hash"),
            }
        )
    return rows


def best_improvements(
    front: list[dict[str, Any]],
    objective_metrics: tuple[str, ...],
) -> dict[str, float]:
    if not front:
        return {metric: 0.0 for metric in objective_metrics}
    return {
        metric: max(row["point"][index] for row in front)
        for index, metric in enumerate(objective_metrics)
    }


def gate_row(
    method: str,
    problem_rows: list[dict[str, Any]],
    classic_problems: set[str],
) -> dict[str, Any]:
    method_problems = covered_problems(problem_rows)
    missing = sorted(classic_problems - method_problems)
    extra = sorted(method_problems - classic_problems)
    return {
        "method_name": method,
        "covered_problems": len(method_problems),
        "classic_covered_problems": len(classic_problems),
        "missing_classic_problems": missing,
        "extra_problems": extra,
        "gate0": "PASS" if not missing else "FAIL",
    }


def leaderboard_row(
    method: str,
    payload: dict[str, Any],
    classic_payload: dict[str, Any],
) -> dict[str, Any]:
    problem_rows = payload["problem_metrics"]
    classic_rows = by_problem(classic_payload["problem_metrics"])
    fitness_result = compare_problem_metric(
        problem_rows,
        classic_rows,
        metric_name="best_fitness",
        epsilon=FITNESS_EPSILON,
    )
    hv_result = compare_problem_metric(
        problem_rows,
        classic_rows,
        metric_name="hypervolume",
        epsilon=HV_EPSILON,
    )
    summary = payload["summary"]
    return {
        "method_name": method,
        "problem_count": len(problem_rows),
        "covered_problems": len(covered_problems(problem_rows)),
        "valid_ppa_candidate_count": int(summary["valid_ppa_candidate_count"]),
        "mean_best_fitness": mean(row["best_fitness"] for row in problem_rows),
        "fitness_wins": fitness_result["wins"],
        "fitness_ties": fitness_result["ties"],
        "fitness_losses": fitness_result["losses"],
        "mean_hypervolume": mean(row["hypervolume"] for row in problem_rows),
        "hv_wins": hv_result["wins"],
        "hv_ties": hv_result["ties"],
        "hv_losses": hv_result["losses"],
        "unique_canonical_netlist_count": int(summary["unique_canonical_netlist_count"]),
        "duplicate_netlist_count": sum(int(row["duplicate_netlist_count"]) for row in problem_rows),
        "unique_motif_signature_count": int(summary["unique_motif_signature_count"]),
        "ppa_front_unique_netlist_count": sum(
            int(row["ppa_front_unique_netlist_count"]) for row in problem_rows
        ),
        "common_audit_occupied_cells": int(summary["common_audit_occupied_cells"]),
        "common_audit_qd_score": float(summary["common_audit_qd_score"]),
        "runtime_seconds": runtime_seconds(payload["generation"]),
        "llm_api_calls": llm_api_calls(payload["generation"]),
    }


def per_problem_comparison_rows(per_method: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    classic_rows = by_problem(per_method[REFERENCE_METHOD]["problem_metrics"])
    rows = []
    for method, payload in per_method.items():
        for row in payload["problem_metrics"]:
            classic = classic_rows[row["problem_id"]]
            fitness_delta = float(row["best_fitness"] or 0.0) - float(
                classic["best_fitness"] or 0.0
            )
            hv_delta = float(row["hypervolume"] or 0.0) - float(
                classic["hypervolume"] or 0.0
            )
            rows.append(
                {
                    "method_name": method,
                    "problem_id": row["problem_id"],
                    "fitness_delta": fitness_delta,
                    "fitness_outcome": outcome(fitness_delta, FITNESS_EPSILON),
                    "hypervolume_delta": hv_delta,
                    "hypervolume_outcome": outcome(hv_delta, HV_EPSILON),
                }
            )
    return rows


def compare_problem_metric(
    rows: list[dict[str, Any]],
    classic_rows: dict[str, dict[str, Any]],
    *,
    metric_name: str,
    epsilon: float,
) -> dict[str, int]:
    wins = ties = losses = 0
    for row in rows:
        classic = classic_rows[row["problem_id"]]
        delta = float(row[metric_name] or 0.0) - float(classic[metric_name] or 0.0)
        if delta > epsilon:
            wins += 1
            continue
        if delta < -epsilon:
            losses += 1
            continue
        ties += 1
    return {"wins": wins, "ties": ties, "losses": losses}


def outcome(delta: float, epsilon: float) -> str:
    if delta > epsilon:
        return "W"
    if delta < -epsilon:
        return "L"
    return "T"


def render_markdown(report: dict[str, Any]) -> str:
    rows = [
        "# Auto-BD Seed-1 Centralized Report",
        "",
        "Status: preliminary development-subset report.",
        "",
        "## Normalization",
        "",
        "- Objective directions: minimize area, power, and effective clock.",
        "- Improvement: `(reference - candidate) / max(abs(reference), 1e-12)`.",
        "- Combinational tasks use area/power; sequential tasks also use effective clock.",
        "- Hypervolume uses normalized improvement space against the zero-improvement reference point.",
        "- Negative objective improvements are clipped to zero inside the hypervolume computation.",
        "- Invalid candidates remain in generated/robustness counts but are excluded from valid-only PPA/HV.",
        "",
        "## Gate Matrix",
        "",
        markdown_table(
            ["Method", "Gate 0", "Covered", "Classic Covered", "Missing Classic"],
            [
                [
                    code(row["method_name"]),
                    row["gate0"],
                    row["covered_problems"],
                    row["classic_covered_problems"],
                    ", ".join(row["missing_classic_problems"]) or "-",
                ]
                for row in report["gate_matrix"]
            ],
        ),
        "",
        "## Leaderboard",
        "",
        markdown_table(
            [
                "Method",
                "Valid PPA",
                "Mean Fitness",
                "Fitness W/T/L",
                "Mean HV",
                "HV W/T/L",
                "Unique Netlists",
                "Dup Netlists",
                "Unique Motifs",
                "PPA-Front Netlists",
                "Audit Cells",
                "Audit QD",
                "Runtime s",
                "LLM Calls",
            ],
            [
                [
                    code(row["method_name"]),
                    row["valid_ppa_candidate_count"],
                    fmt(row["mean_best_fitness"]),
                    f"{row['fitness_wins']}/{row['fitness_ties']}/{row['fitness_losses']}",
                    fmt(row["mean_hypervolume"]),
                    f"{row['hv_wins']}/{row['hv_ties']}/{row['hv_losses']}",
                    row["unique_canonical_netlist_count"],
                    row["duplicate_netlist_count"],
                    row["unique_motif_signature_count"],
                    row["ppa_front_unique_netlist_count"],
                    row["common_audit_occupied_cells"],
                    fmt(row["common_audit_qd_score"]),
                    fmt(row["runtime_seconds"]),
                    row["llm_api_calls"],
                ]
                for row in report["leaderboard"]
            ],
        ),
        "",
        "## Per-Problem Win/Loss Matrix",
        "",
        markdown_table(
            [
                "Method",
                "Problem",
                "Fitness Delta",
                "Fitness",
                "HV Delta",
                "HV",
            ],
            [
                [
                    code(row["method_name"]),
                    code(row["problem_id"]),
                    fmt(row["fitness_delta"]),
                    row["fitness_outcome"],
                    fmt(row["hypervolume_delta"]),
                    row["hypervolume_outcome"],
                ]
                for row in report["comparison_matrix"]
            ],
        ),
        "",
        "## Per-Problem PPA And Diversity",
        "",
        markdown_table(
            [
                "Method",
                "Problem",
                "Valid PPA",
                "Best Fitness",
                "HV",
                "Pareto Points",
                "Ref-Beating",
                "Unique Netlists",
                "Dup Netlists",
                "PPA-Front Netlists",
                "Objectives",
            ],
            [
                [
                    code(row["method_name"]),
                    code(row["problem_id"]),
                    row["valid_ppa_candidate_count"],
                    fmt(row["best_fitness"]),
                    fmt(row["hypervolume"]),
                    row["pareto_point_count"],
                    row["reference_beating_count"],
                    row["unique_canonical_netlist_count"],
                    row["duplicate_netlist_count"],
                    row["ppa_front_unique_netlist_count"],
                    "/".join(row["objective_metrics"]),
                ]
                for row in report["problem_metrics"]
            ],
        ),
        "",
        "## Artifact Roots",
        "",
    ]
    for method, path in report["artifact_roots"].items():
        rows.append(f"- `{method}`: `{path}`")
    rows.append("")
    return "\n".join(rows)


def markdown_table(headers: list[str], rows: list[list[object]]) -> str:
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(value) for value in row) + " |")
    return "\n".join(lines)


def load_reference_ppa(repo_root: Path, benchmark: str, problem: str) -> dict[str, float]:
    path = repo_root / "data" / "bench" / benchmark / f"{problem}_ppa.txt"
    assert path.is_file(), f"missing reference PPA: {path}"
    lines = path.read_text(encoding="utf-8").splitlines()
    assert len(lines) >= 2, f"invalid reference PPA: {path}"
    values = lines[1].split(",")
    assert len(values) >= 5, f"invalid reference PPA: {path}"
    return {
        "tns": float(values[0]),
        "wns": float(values[1]),
        "eff_clk_period": float(values[2]),
        "power": float(values[3]),
        "area": float(values[4]),
    }


def covered_problems(rows: list[dict[str, Any]]) -> set[str]:
    return {
        str(row["problem_id"])
        for row in rows
        if int(row["valid_ppa_candidate_count"]) > 0
    }


def by_problem(rows: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    return {str(row["problem_id"]): row for row in rows}


def finite_max(values: list[Any]) -> float | None:
    finite = [float(value) for value in values if is_finite(value)]
    if not finite:
        return None
    return max(finite)


def mean(values: Any) -> float:
    finite = [float(value) for value in values if is_finite(value)]
    assert finite
    return sum(finite) / len(finite)


def is_finite(value: Any) -> bool:
    if value in ("", None):
        return False
    return math.isfinite(float(value))


def nunique(frame: pd.DataFrame, column: str) -> int:
    return int(frame[column].dropna().nunique())


def runtime_seconds(rows: list[dict[str, Any]]) -> float:
    return sum(float(row["runtime_seconds"] or 0.0) for row in rows)


def llm_api_calls(rows: list[dict[str, Any]]) -> int:
    return sum(int(row["llm_api_calls"] or 0) for row in rows)


def normalization_payload() -> dict[str, Any]:
    return {
        "objective_directions": {
            "area": "minimize",
            "power": "minimize",
            "eff_clk_period": "minimize",
        },
        "improvement_formula": "(reference - candidate) / max(abs(reference), 1e-12)",
        "hypervolume_reference_point": 0.0,
        "hypervolume_negative_clipping": "clip each objective improvement at 0",
        "combinational_objectives": ["area", "power"],
        "sequential_objectives": ["area", "power", "eff_clk_period"],
        "invalid_candidate_policy": "count for robustness, exclude from valid-only PPA/HV",
        "fitness_win_epsilon": FITNESS_EPSILON,
        "hypervolume_win_epsilon": HV_EPSILON,
    }


def method_sort_key(item: tuple[str, Path]) -> tuple[int, str]:
    method = item[0]
    if method in METHOD_ORDER:
        return (METHOD_ORDER.index(method), method)
    return (len(METHOD_ORDER), method)


def code(value: object) -> str:
    return f"`{value}`"


def fmt(value: object) -> str:
    if value is None:
        return "-"
    assert isinstance(value, int | float | str)
    return f"{float(value):.4f}"


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results-root", type=Path, required=True)
    parser.add_argument("--output-md", type=Path, required=True)
    parser.add_argument("--output-json", type=Path, required=True)
    parser.add_argument("--repo-root", type=Path, default=REPO_ROOT)
    parser.add_argument("--phase", default="development_preliminary_seed1")
    parser.add_argument("--seed", type=int, default=1001)
    args = parser.parse_args(argv)

    report = build_report(
        results_root=args.results_root,
        repo_root=args.repo_root,
        phase=args.phase,
        seed=args.seed,
    )
    args.output_md.parent.mkdir(parents=True, exist_ok=True)
    args.output_md.write_text(render_markdown(report), encoding="utf-8")
    write_json(args.output_json, report)
    print(f"Auto-BD centralized report -> {args.output_md}")
    print(f"Auto-BD centralized report data -> {args.output_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
