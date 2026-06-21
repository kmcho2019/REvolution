#!/usr/bin/env python3
"""Package the T27 live QD audit for the T26 active lead."""

from __future__ import annotations

import argparse
import csv
import json
import math
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

from revolution.qd.pareto_analysis import (
    ProblemParetoMetrics,
    analyze_problem_pareto,
    hypervolume,
    improvement_tuple,
    pareto_front,
)

PROBLEMS = (
    "Prob045_alu",
    "Prob041_traffic_light",
    "Prob015_multi_pipe_8bit",
)

METHODS = (
    {
        "method": "classic_revolution",
        "label": "Classic",
        "source": "t24",
        "mode": "classic_revolution/seed_1001/openai_gpt-oss-120b",
    },
    {
        "method": "landing_smooth_qd_manual_bd",
        "label": "Manual BD",
        "source": "t24",
        "mode": "landing_smooth_qd_manual_bd/seed_1001/openai_gpt-oss-120b",
    },
    {
        "method": "random_descriptor_qd",
        "label": "Random",
        "source": "t24",
        "mode": "random_descriptor_qd/seed_1001/openai_gpt-oss-120b",
    },
    {
        "method": "sr_raw_pca_qd",
        "label": "SR raw",
        "source": "t24",
        "mode": "sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b",
    },
    {
        "method": "guarded_sr_raw_pareto_qd",
        "label": "Guarded SR raw",
        "source": "t25",
        "mode": "guarded_sr_raw_pareto_qd/seed_1001/openai_gpt-oss-120b",
    },
    {
        "method": "sr_raw_conservative_exploit_qd",
        "label": "Conservative exploit",
        "source": "t26",
        "mode": "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b",
    },
)

COLORS = {
    "Classic": "#4e79a7",
    "Manual BD": "#b07aa1",
    "Random": "#8c8c8c",
    "SR raw": "#59a14f",
    "Guarded SR raw": "#3b6ea8",
    "Conservative exploit": "#e15759",
}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--t24-run-root", required=True, type=Path)
    parser.add_argument("--t25-run-root", required=True, type=Path)
    parser.add_argument("--t26-run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    run_roots = {"t24": args.t24_run_root, "t25": args.t25_run_root, "t26": args.t26_run_root}
    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    problem_rows = [
        problem_row(run_roots, method, problem)
        for method in METHODS
        for problem in PROBLEMS
    ]
    aggregate = aggregate_rows_from_problem_rows(problem_rows)
    delta_rows = comparison_rows(aggregate)
    method_manifest = manifest_rows(run_roots)

    write_csv(table_dir / "live_qd_problem_metrics.csv", problem_rows)
    write_csv(table_dir / "live_qd_aggregate_metrics.csv", aggregate)
    write_csv(table_dir / "live_qd_comparison_deltas.csv", delta_rows)
    write_csv(table_dir / "live_qd_method_manifest.csv", method_manifest)
    write_figures(problem_rows, aggregate, figure_dir)
    return 0


def problem_row(
    run_roots: dict[str, Path],
    method: dict[str, str],
    problem: str,
) -> dict[str, str]:
    problem_root = run_roots[method["source"]] / method["mode"] / "RTLLM" / problem
    summary = load_json(problem_root / f"{problem}_summary.json")
    pareto = analyze_problem_pareto(problem_root, benchmark="RTLLM", problem=problem)
    archive = load_optional_json(problem_root / "archive_summary.json")
    global_pareto = load_optional_json(problem_root / "global_pareto_summary.json")
    history = load_jsonl(problem_root / "archive_history.jsonl")

    hv_curve = hypervolume_curve(pareto)
    qd_scores = [float(row.get("qd_score") or 0.0) for row in history]
    coverages = [float(row.get("coverage") or 0.0) for row in history]
    spread = front_spread(pareto)
    unique_points = unique_improvement_points(pareto.candidates, pareto.objective_metrics)

    return {
        "method": method["method"],
        "method_label": method["label"],
        "problem": problem,
        "candidate_count": str(pareto.candidate_count),
        "total_generated": str(int(summary["total_candidates_generated"])),
        "valid_ppa_count": str(success_count(summary, "synthesis_ppa")),
        "valid_ppa_rate": fmt(success_rate(summary, "synthesis_ppa")),
        "best_score": fmt(float(summary["final_population_ppa"]["best_score"])),
        "global_ppa_hypervolume": fmt(pareto.hypervolume),
        "hv_auc": fmt(required_auc(hv_curve)),
        "ppa_front_points": str(pareto.pareto_point_count),
        "reference_beating_count": str(pareto.reference_beating_count),
        "unique_ppa_points": str(len(unique_points)),
        "duplicate_ppa_point_count": str(pareto.candidate_count - len(unique_points)),
        "front_nn_distance": fmt(spread["front_nn_distance"]),
        "front_bbox_volume": fmt(spread["front_bbox_volume"]),
        "active_archive_coverage": fmt_optional(optional_float(archive, "coverage")),
        "active_archive_qd_score": fmt_optional(optional_float(archive, "qd_score")),
        "active_archive_members": fmt_optional(optional_int(archive, "total_archive_members")),
        "active_archive_cells": fmt_optional(optional_int(archive, "occupied_cells")),
        "active_max_front_size": fmt_optional(optional_int(archive, "max_front_size")),
        "active_global_pareto_members": fmt_optional(
            optional_int(global_pareto, "total_global_pareto_members")
        ),
        "active_qd_score_auc": fmt_optional(auc(qd_scores) if qd_scores else None),
        "active_coverage_auc": fmt_optional(auc(coverages) if coverages else None),
    }


def aggregate_rows_from_problem_rows(problem_rows: list[dict[str, str]]) -> list[dict[str, str]]:
    output = []
    for method in METHODS:
        rows = [row for row in problem_rows if row["method"] == method["method"]]
        output.append(
            {
                "method": method["method"],
                "method_label": method["label"],
                "problem_count": str(len(rows)),
                "valid_ppa_count": str(sum(int(row["valid_ppa_count"]) for row in rows)),
                "mean_valid_ppa_rate": fmt(mean_float(rows, "valid_ppa_rate")),
                "mean_best_score": fmt(mean_float(rows, "best_score")),
                "mean_global_ppa_hypervolume": fmt(mean_float(rows, "global_ppa_hypervolume")),
                "mean_hv_auc": fmt(mean_float(rows, "hv_auc")),
                "total_ppa_front_points": str(sum(int(row["ppa_front_points"]) for row in rows)),
                "total_reference_beating_count": str(
                    sum(int(row["reference_beating_count"]) for row in rows)
                ),
                "total_unique_ppa_points": str(sum(int(row["unique_ppa_points"]) for row in rows)),
                "total_duplicate_ppa_point_count": str(
                    sum(int(row["duplicate_ppa_point_count"]) for row in rows)
                ),
                "mean_front_nn_distance": fmt(mean_float(rows, "front_nn_distance")),
                "mean_front_bbox_volume": fmt(mean_float(rows, "front_bbox_volume")),
                "mean_active_archive_coverage": fmt_optional(mean_optional(rows, "active_archive_coverage")),
                "mean_active_archive_qd_score": fmt_optional(mean_optional(rows, "active_archive_qd_score")),
                "total_active_archive_members": fmt_optional(sum_optional(rows, "active_archive_members")),
                "total_active_global_pareto_members": fmt_optional(
                    sum_optional(rows, "active_global_pareto_members")
                ),
                "mean_active_qd_score_auc": fmt_optional(mean_optional(rows, "active_qd_score_auc")),
                "mean_active_coverage_auc": fmt_optional(mean_optional(rows, "active_coverage_auc")),
            }
        )
    return output


def comparison_rows(aggregate: list[dict[str, str]]) -> list[dict[str, str]]:
    by_method = {row["method"]: row for row in aggregate}
    metrics = (
        "mean_global_ppa_hypervolume",
        "mean_hv_auc",
        "mean_best_score",
        "valid_ppa_count",
        "total_ppa_front_points",
        "total_unique_ppa_points",
        "mean_front_nn_distance",
        "total_active_global_pareto_members",
    )
    output = []
    for method in ("sr_raw_conservative_exploit_qd", "sr_raw_pca_qd", "guarded_sr_raw_pareto_qd"):
        for reference in ("classic_revolution", "landing_smooth_qd_manual_bd", "random_descriptor_qd", "sr_raw_pca_qd"):
            if method == reference:
                continue
            for metric in metrics:
                value = parse_optional(by_method[method][metric])
                ref_value = parse_optional(by_method[reference][metric])
                output.append(
                    {
                        "method": method,
                        "method_label": by_method[method]["method_label"],
                        "reference": reference,
                        "reference_label": by_method[reference]["method_label"],
                        "metric": metric,
                        "value": fmt_optional(value),
                        "reference_value": fmt_optional(ref_value),
                        "delta": fmt_optional(None if value is None or ref_value is None else value - ref_value),
                        "relative_delta": fmt_optional(relative_delta(value, ref_value)),
                    }
                )
    return output


def manifest_rows(run_roots: dict[str, Path]) -> list[dict[str, str]]:
    return [
        {
            "method": method["method"],
            "method_label": method["label"],
            "source_run_root": str(run_roots[method["source"]]),
            "mode": method["mode"],
        }
        for method in METHODS
    ]


def hypervolume_curve(pareto: ProblemParetoMetrics) -> list[float]:
    max_generation = max(
        (candidate.generation or 0 for candidate in pareto.candidates),
        default=0,
    )
    values = []
    for generation in range(max_generation + 1):
        points = [
            improvement_tuple(candidate, pareto.objective_metrics)
            for candidate in pareto.candidates
            if (candidate.generation or 0) <= generation
        ]
        front = [points[index] for index in pareto_front(points)] if points else []
        values.append(hypervolume(front))
    return values


def front_spread(pareto: ProblemParetoMetrics) -> dict[str, float]:
    points = [
        improvement_tuple(candidate, pareto.objective_metrics)
        for candidate in pareto.pareto_candidates
    ]
    if len(points) < 2:
        return {"front_nn_distance": 0.0, "front_bbox_volume": 0.0}
    nearest = []
    for index, point in enumerate(points):
        nearest.append(
            min(
                euclidean(point, other)
                for other_index, other in enumerate(points)
                if other_index != index
            )
        )
    ranges = [
        max(point[axis] for point in points) - min(point[axis] for point in points)
        for axis in range(len(points[0]))
    ]
    volume = math.prod(max(0.0, value) for value in ranges)
    return {"front_nn_distance": sum(nearest) / len(nearest), "front_bbox_volume": volume}


def unique_improvement_points(candidates: tuple[Any, ...], metrics: tuple[str, ...]) -> set[tuple[float, ...]]:
    return {
        tuple(round(value, 12) for value in improvement_tuple(candidate, metrics))
        for candidate in candidates
    }


def write_figures(
    problem_rows: list[dict[str, str]],
    aggregate_rows_: list[dict[str, str]],
    figure_dir: Path,
) -> None:
    plot_problem_bars(problem_rows, figure_dir / "live_qd_problem_metrics.png")
    plot_aggregate_bars(aggregate_rows_, figure_dir / "live_qd_aggregate_metrics.png")


def plot_problem_bars(rows: list[dict[str, str]], output_path: Path) -> None:
    methods = [method["label"] for method in METHODS]
    by_key = {(row["method_label"], row["problem"]): row for row in rows}
    x_positions = list(range(len(PROBLEMS)))
    width = 0.84 / len(methods)
    fig, axes = plt.subplots(1, 3, figsize=(17.8, 5.0))
    problem_metric_panel(
        axes[0],
        methods,
        by_key,
        x_positions,
        width,
        "global_ppa_hypervolume",
        "PPA Hypervolume",
    )
    problem_metric_panel(
        axes[1],
        methods,
        by_key,
        x_positions,
        width,
        "ppa_front_points",
        "PPA-Front Points",
    )
    problem_metric_panel(
        axes[2],
        methods,
        by_key,
        x_positions,
        width,
        "front_nn_distance",
        "Front NN Spread",
    )
    for axis in axes:
        axis.set_xticks(x_positions)
        axis.set_xticklabels([problem.replace("Prob", "P") for problem in PROBLEMS], rotation=25, ha="right")
        axis.grid(axis="y", color="#e3e3e3", linewidth=0.8)
        axis.legend(frameon=False, fontsize=7)
    fig.suptitle("T27 Live PPA-Front Audit By Problem", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def problem_metric_panel(
    axis: Any,
    methods: list[str],
    by_key: dict[tuple[str, str], dict[str, str]],
    x_positions: list[int],
    width: float,
    metric: str,
    title: str,
) -> None:
    for method_index, method in enumerate(methods):
        offset = (method_index - (len(methods) - 1) / 2) * width
        values = [parse_optional(by_key[(method, problem)][metric]) or 0.0 for problem in PROBLEMS]
        axis.bar(
            [position + offset for position in x_positions],
            values,
            width,
            label=method,
            color=COLORS[method],
            alpha=0.82,
        )
    axis.set_title(title)


def plot_aggregate_bars(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [row["method_label"] for row in rows]
    x = list(range(len(rows)))
    fig, axes = plt.subplots(1, 3, figsize=(16.8, 4.8))
    aggregate_panel(axes[0], rows, x, "mean_global_ppa_hypervolume", "Mean HV")
    aggregate_panel(axes[1], rows, x, "mean_hv_auc", "Mean HV AUC")
    aggregate_panel(axes[2], rows, x, "total_active_global_pareto_members", "Active Pareto Members")
    for axis in axes:
        axis.set_xticks(x)
        axis.set_xticklabels(labels, rotation=25, ha="right")
        axis.grid(axis="y", color="#e3e3e3", linewidth=0.8)
    fig.suptitle("T27 Live Aggregate QD Audit", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def aggregate_panel(
    axis: Any,
    rows: list[dict[str, str]],
    x: list[int],
    metric: str,
    title: str,
) -> None:
    values = [parse_optional(row[metric]) or 0.0 for row in rows]
    colors = [COLORS[row["method_label"]] for row in rows]
    axis.bar(x, values, color=colors, alpha=0.84)
    axis.set_title(title)


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def load_optional_json(path: Path) -> dict[str, Any] | None:
    if not path.is_file():
        return None
    return load_json(path)


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    if not path.is_file():
        return []
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        payload = json.loads(line)
        assert isinstance(payload, dict)
        rows.append(payload)
    return rows


def success_rate(summary: dict[str, Any], key: str) -> float:
    return float(summary["accumulated_success_rates"][key])


def success_count(summary: dict[str, Any], key: str) -> int:
    return round(success_rate(summary, key) * int(summary["total_candidates_generated"]))


def optional_float(payload: dict[str, Any] | None, key: str) -> float | None:
    if payload is None:
        return None
    value = payload.get(key)
    if value is None:
        return None
    return float(value)


def optional_int(payload: dict[str, Any] | None, key: str) -> int | None:
    value = optional_float(payload, key)
    if value is None:
        return None
    return int(value)


def auc(values: list[float]) -> float | None:
    if not values:
        return None
    if len(values) == 1:
        return values[0]
    area = 0.0
    for left, right in zip(values[:-1], values[1:], strict=True):
        area += (left + right) / 2.0
    return area / (len(values) - 1)


def required_auc(values: list[float]) -> float:
    value = auc(values)
    assert value is not None
    return value


def mean_float(rows: list[dict[str, str]], key: str) -> float:
    values = [parse_optional(row[key]) for row in rows]
    parsed = [value for value in values if value is not None]
    assert parsed
    return sum(parsed) / len(parsed)


def mean_optional(rows: list[dict[str, str]], key: str) -> float | None:
    values = [parse_optional(row[key]) for row in rows]
    parsed = [value for value in values if value is not None]
    if not parsed:
        return None
    return sum(parsed) / len(parsed)


def sum_optional(rows: list[dict[str, str]], key: str) -> float | None:
    values = [parse_optional(row[key]) for row in rows]
    parsed = [value for value in values if value is not None]
    if not parsed:
        return None
    return sum(parsed)


def parse_optional(value: str) -> float | None:
    if value == "":
        return None
    return float(value)


def relative_delta(value: float | None, reference: float | None) -> float | None:
    if value is None or reference is None or math.isclose(reference, 0.0):
        return None
    return (value - reference) / abs(reference)


def euclidean(left: tuple[float, ...], right: tuple[float, ...]) -> float:
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(left, right, strict=True)))


def fmt(value: float) -> str:
    return f"{value:.6f}"


def fmt_optional(value: float | int | None) -> str:
    if value is None:
        return ""
    if isinstance(value, int):
        return str(value)
    return fmt(float(value))


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    raise SystemExit(main())
