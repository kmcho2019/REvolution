#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import json
import math
import os
import sys
from itertools import combinations
from pathlib import Path
from typing import Any, cast

import matplotlib

matplotlib.use("Agg")

from matplotlib.lines import Line2D
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import yaml

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.qd.pareto_analysis import (  # noqa: E402
    ProblemParetoMetrics,
    collect_backend_problem_pareto,
    pareto_front,
)


TAB10_COLORS = (
    "#1f77b4",
    "#ff7f0e",
    "#2ca02c",
    "#d62728",
    "#9467bd",
    "#8c564b",
    "#e377c2",
    "#7f7f7f",
    "#bcbd22",
    "#17becf",
)


def _parse_backend_run(value: str) -> tuple[str, Path]:
    if "=" not in value:
        raise argparse.ArgumentTypeError(f"Expected BACKEND=PATH, got {value!r}")
    backend, raw_path = value.split("=", 1)
    backend = backend.strip()
    path = Path(raw_path).expanduser().resolve()
    if not backend:
        raise argparse.ArgumentTypeError(f"Invalid backend label in {value!r}")
    return backend, path


def _safe_float(value: Any) -> float | None:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(parsed):
        return None
    return parsed


def _load_subset_problems(config_path: Path) -> list[tuple[str, str]]:
    payload = yaml.safe_load(config_path.read_text(encoding="utf-8"))
    selected = payload.get("selected_problems") or []
    problems: list[tuple[str, str]] = []
    for entry in selected:
        if not isinstance(entry, dict):
            continue
        benchmark = entry.get("benchmark")
        problem = entry.get("problem")
        if isinstance(benchmark, str) and isinstance(problem, str):
            problems.append((benchmark, problem))
    if not problems:
        raise ValueError(f"No selected problems found in subset config '{config_path}'.")
    return problems


def _write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def _axis_label(metric_name: str) -> str:
    labels = {
        "area": "area improvement",
        "power": "power improvement",
        "eff_clk_period": "effective period improvement",
    }
    return labels.get(metric_name, metric_name)


def _candidate_points(
    metrics: ProblemParetoMetrics,
    *,
    x_metric: str,
    y_metric: str,
) -> list[tuple[float, float]]:
    return [
        (candidate.improvements[x_metric], candidate.improvements[y_metric])
        for candidate in metrics.candidates
    ]


def _candidate_points_3d(
    metrics: ProblemParetoMetrics,
    metric_names: tuple[str, ...],
) -> list[tuple[float, float, float]]:
    if len(metric_names) != 3:
        return []
    return [
        (
            candidate.improvements[metric_names[0]],
            candidate.improvements[metric_names[1]],
            candidate.improvements[metric_names[2]],
        )
        for candidate in metrics.candidates
    ]


def _pareto_projection(points: list[tuple[float, float]]) -> list[tuple[float, float]]:
    if not points:
        return []
    front_points = [points[index] for index in pareto_front(points)]
    unique: list[tuple[float, float]] = []
    seen: set[tuple[float, float]] = set()
    for point in sorted(front_points, key=lambda item: (item[0], item[1])):
        key = (round(point[0], 12), round(point[1], 12))
        if key in seen:
            continue
        seen.add(key)
        unique.append(point)
    return unique


def _limits_from_values(values: list[float]) -> tuple[float, float]:
    if not values:
        return (-0.05, 0.05)
    lo = min(values + [0.0])
    hi = max(values + [0.0])
    if abs(hi - lo) < 1e-9:
        pad = max(abs(lo), 0.05) * 0.1 + 0.05
        return lo - pad, hi + pad
    pad = (hi - lo) * 0.08
    return lo - pad, hi + pad


def _write_placeholder_figure(path: Path, *, title: str, message: str) -> None:
    fig, ax = plt.subplots(figsize=(8, 4.5))
    ax.axis("off")
    ax.text(0.5, 0.6, title, ha="center", va="center", fontsize=14, weight="bold")
    ax.text(0.5, 0.4, message, ha="center", va="center", fontsize=11)
    fig.tight_layout()
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)


def _plot_pairwise_fronts(
    path: Path,
    *,
    benchmark: str,
    problem: str,
    per_backend: dict[str, ProblemParetoMetrics],
) -> None:
    representative = next(iter(per_backend.values()), None)
    if representative is None:
        _write_placeholder_figure(
            path,
            title=f"{benchmark} / {problem}",
            message="No synthesized-success candidates with PPA metrics were found.",
        )
        return
    metric_names = representative.objective_metrics
    metric_pairs = list(combinations(metric_names, 2))
    if not metric_pairs:
        _write_placeholder_figure(
            path,
            title=f"{benchmark} / {problem}",
            message="Not enough active objectives to draw pairwise Pareto fronts.",
        )
        return
    ncols = 2 if len(metric_pairs) > 1 else 1
    nrows = math.ceil(len(metric_pairs) / ncols)
    fig, axes = plt.subplots(nrows, ncols, figsize=(ncols * 6.2, nrows * 5.0))
    axes_list = list(axes.flatten()) if hasattr(axes, "flatten") else [axes]
    colors = TAB10_COLORS
    legend_items: list[Line2D] = []

    for axis, (x_metric, y_metric) in zip(axes_list, metric_pairs):
        x_values: list[float] = []
        y_values: list[float] = []
        for metrics in per_backend.values():
            x_values.extend(candidate.improvements[x_metric] for candidate in metrics.candidates)
            y_values.extend(candidate.improvements[y_metric] for candidate in metrics.candidates)
        axis.set_xlim(*_limits_from_values(x_values))
        axis.set_ylim(*_limits_from_values(y_values))
        axis.axhline(0.0, color="#999999", linewidth=0.8, linestyle="--", alpha=0.7)
        axis.axvline(0.0, color="#999999", linewidth=0.8, linestyle="--", alpha=0.7)
        axis.grid(True, alpha=0.22)
        axis.set_xlabel(_axis_label(x_metric))
        axis.set_ylabel(_axis_label(y_metric))
        axis.set_title(f"{_axis_label(x_metric)} vs {_axis_label(y_metric)}")

        for color_index, (backend, metrics) in enumerate(sorted(per_backend.items())):
            color = colors[color_index % len(colors)]
            points = _candidate_points(metrics, x_metric=x_metric, y_metric=y_metric)
            if points:
                axis.scatter(
                    [point[0] for point in points],
                    [point[1] for point in points],
                    s=22,
                    color=color,
                    alpha=0.18,
                    edgecolors="none",
                )
                front_points = _pareto_projection(points)
                if front_points:
                    axis.plot(
                        [point[0] for point in front_points],
                        [point[1] for point in front_points],
                        color=color,
                        linewidth=2.0,
                        alpha=0.95,
                    )
                    axis.scatter(
                        [point[0] for point in front_points],
                        [point[1] for point in front_points],
                        s=44,
                        color=color,
                        edgecolors="white",
                        linewidths=0.5,
                        alpha=0.95,
                    )
            if len(legend_items) < len(per_backend):
                legend_items.append(
                    Line2D(
                        [0],
                        [0],
                        color=color,
                        marker="o",
                        linestyle="-",
                        markersize=6,
                        linewidth=2.0,
                        label=backend,
                    )
                )

    for axis in axes_list[len(metric_pairs):]:
        axis.axis("off")

    fig.suptitle(
        f"{benchmark} / {problem}: projected Pareto fronts in normalized improvement space",
        fontsize=13,
    )
    if legend_items:
        fig.legend(handles=legend_items, loc="upper center", ncol=min(4, len(legend_items)))
    fig.tight_layout(rect=(0.0, 0.0, 1.0, 0.93))
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)


def _plot_3d_front(
    path: Path,
    *,
    benchmark: str,
    problem: str,
    per_backend: dict[str, ProblemParetoMetrics],
) -> None:
    sequential_backends = {
        backend: metrics
        for backend, metrics in per_backend.items()
        if len(metrics.objective_metrics) == 3
    }
    if not sequential_backends:
        _write_placeholder_figure(
            path,
            title=f"{benchmark} / {problem}",
            message="This problem does not use a 3-objective Pareto space.",
        )
        return
    metric_names = next(iter(sequential_backends.values())).objective_metrics
    all_points = [
        point
        for metrics in sequential_backends.values()
        for point in _candidate_points_3d(metrics, metric_names)
    ]
    x_limits = _limits_from_values([point[0] for point in all_points])
    y_limits = _limits_from_values([point[1] for point in all_points])
    z_limits = _limits_from_values([point[2] for point in all_points])

    fig = plt.figure(figsize=(13.5, 6.0))
    axes = [
        fig.add_subplot(1, 2, 1, projection="3d"),
        fig.add_subplot(1, 2, 2, projection="3d"),
    ]
    views = [(22, 42), (24, 132)]
    colors = TAB10_COLORS
    legend_items: list[Line2D] = []

    for axis_raw, (elev, azim) in zip(axes, views, strict=True):
        axis = cast(Axes3D, axis_raw)
        axis_any: Any = axis
        axis.view_init(elev=elev, azim=azim)
        axis.set_xlim(*x_limits)
        axis.set_ylim(*y_limits)
        axis.set_zlim(*z_limits)
        axis.set_xlabel(_axis_label(metric_names[0]))
        axis.set_ylabel(_axis_label(metric_names[1]))
        axis.set_zlabel(_axis_label(metric_names[2]))
        axis.set_title(f"view elev={elev}, azim={azim}")
        for color_index, (backend, metrics) in enumerate(sorted(sequential_backends.items())):
            color = colors[color_index % len(colors)]
            points = _candidate_points_3d(metrics, metric_names)
            pareto_points = [
                tuple(candidate.improvements[metric_name] for metric_name in metric_names)
                for candidate in metrics.pareto_candidates
            ]
            if points:
                axis_any.scatter(
                    xs=[point[0] for point in points],
                    ys=[point[1] for point in points],
                    zs=[point[2] for point in points],
                    s=16,
                    color=color,
                    alpha=0.10,
                    depthshade=False,
                )
            if pareto_points:
                axis_any.scatter(
                    xs=[point[0] for point in pareto_points],
                    ys=[point[1] for point in pareto_points],
                    zs=[point[2] for point in pareto_points],
                    s=42,
                    color=color,
                    edgecolors="white",
                    linewidths=0.35,
                    alpha=0.9,
                    depthshade=False,
                )
            if len(legend_items) < len(sequential_backends):
                legend_items.append(
                    Line2D(
                        [0],
                        [0],
                        color=color,
                        marker="o",
                        linestyle="None",
                        markersize=7,
                        label=backend,
                    )
                )

    fig.suptitle(
        f"{benchmark} / {problem}: 3D Pareto front views in normalized improvement space",
        fontsize=13,
    )
    if legend_items:
        fig.legend(handles=legend_items, loc="upper center", ncol=min(4, len(legend_items)))
    fig.tight_layout(rect=(0.0, 0.0, 1.0, 0.92))
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path, dpi=180)
    plt.close(fig)


def _problem_winners(problem_rows: list[dict[str, Any]]) -> dict[tuple[str, str], str]:
    grouped: dict[tuple[str, str], list[dict[str, Any]]] = {}
    for row in problem_rows:
        grouped.setdefault((str(row["benchmark"]), str(row["problem"])), []).append(row)
    winners: dict[tuple[str, str], str] = {}
    for key, group in grouped.items():
        valid = [row for row in group if int(row["candidate_count"]) > 0]
        if not valid:
            continue
        winner = max(
            valid,
            key=lambda row: (
                float(row["hypervolume"]),
                int(row["pareto_point_count"]),
                int(row["reference_beating_count"]),
            ),
        )
        winners[key] = str(winner["backend"])
    return winners


def _aggregate_backend_rows(problem_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    winners = _problem_winners(problem_rows)
    grouped: dict[tuple[str, str], list[dict[str, Any]]] = {}
    for row in problem_rows:
        backend = str(row["backend"])
        benchmark = str(row["benchmark"])
        grouped.setdefault((backend, benchmark), []).append(row)
        grouped.setdefault((backend, "ALL"), []).append(row)

    aggregate_rows: list[dict[str, Any]] = []
    for (backend, benchmark), group in sorted(grouped.items()):
        win_count = sum(
            1
            for (row_benchmark, _), winner_backend in winners.items()
            if winner_backend == backend and (benchmark == "ALL" or row_benchmark == benchmark)
        )
        aggregate_rows.append(
            {
                "backend": backend,
                "benchmark": benchmark,
                "problem_count": len(group),
                "pareto_valid_problem_count": sum(int(row["candidate_count"]) > 0 for row in group),
                "mean_hypervolume": sum(float(row["hypervolume"]) for row in group) / len(group),
                "mean_pareto_point_count": (
                    sum(float(row["pareto_point_count"]) for row in group) / len(group)
                ),
                "mean_reference_beating_count": (
                    sum(float(row["reference_beating_count"]) for row in group) / len(group)
                ),
                "hypervolume_win_count": win_count,
            }
        )
    return aggregate_rows


def _recommend_backend(aggregate_rows: list[dict[str, Any]]) -> str | None:
    overall_rows = [row for row in aggregate_rows if row["benchmark"] == "ALL"]
    if not overall_rows:
        return None
    winner = max(
        overall_rows,
        key=lambda row: (
            float(row["mean_hypervolume"]),
            int(row["hypervolume_win_count"]),
            float(row["mean_pareto_point_count"]),
        ),
    )
    return str(winner["backend"])


def _relative_path(path: Path, root: Path) -> str:
    return os.path.relpath(path, root).replace(os.sep, "/")


def _render_report(
    *,
    output_dir: Path,
    subset_config: Path | None,
    backends: list[str],
    problem_rows: list[dict[str, Any]],
    aggregate_rows: list[dict[str, Any]],
    figure_rows: list[dict[str, Any]],
) -> str:
    overall_winner = _recommend_backend(aggregate_rows)
    lines = [
        "# Pareto Analysis",
        "",
        f"- subset_config: `{subset_config}`" if subset_config is not None else "- subset_config: `N/A`",
        f"- backend_count: `{len(backends)}`",
        f"- overall_multi_objective_winner: `{overall_winner or 'N/A'}`",
        "",
        "## Aggregate Backend Metrics",
        "",
        "| Backend | Benchmark | Problems | Pareto-Valid Problems | Mean Hypervolume | Mean Pareto Points | Mean Ref-Beating | HV Wins |",
        "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for row in aggregate_rows:
        lines.append(
            f"| `{row['backend']}` | {row['benchmark']} | {row['problem_count']} | "
            f"{row['pareto_valid_problem_count']} | {float(row['mean_hypervolume']):.4f} | "
            f"{float(row['mean_pareto_point_count']):.2f} | "
            f"{float(row['mean_reference_beating_count']):.2f} | "
            f"{row['hypervolume_win_count']} |"
        )
    lines.extend(
        [
            "",
            "## Backend / Problem Metrics",
            "",
            "| Backend | Benchmark | Problem | Objectives | Candidates | Pareto Points | Hypervolume | Ref-Beating |",
            "| --- | --- | --- | ---: | ---: | ---: | ---: | ---: |",
        ]
    )
    for row in problem_rows:
        lines.append(
            f"| `{row['backend']}` | {row['benchmark']} | {row['problem']} | "
            f"{row['objective_count']} | {row['candidate_count']} | {row['pareto_point_count']} | "
            f"{float(row['hypervolume']):.4f} | {row['reference_beating_count']} |"
        )
    lines.extend(
        [
            "",
            "## Problem Figures",
            "",
            "| Benchmark | Problem | Pairwise | 3D |",
            "| --- | --- | --- | --- |",
        ]
    )
    for row in figure_rows:
        pairwise = f"[pairwise_fronts.png]({row['pairwise_path']})"
        front_3d = f"[front_3d.png]({row['front_3d_path']})" if row["front_3d_path"] else "n/a"
        lines.append(f"| {row['benchmark']} | {row['problem']} | {pairwise} | {front_3d} |")
    lines.append("")
    return "\n".join(lines)


def generate_pareto_analysis_report(
    *,
    backend_runs: list[tuple[str, Path]],
    output_dir: Path,
    subset_config: Path | None = None,
) -> dict[str, Any]:
    output_dir = output_dir.resolve()
    output_dir.mkdir(parents=True, exist_ok=True)
    selected_problems = _load_subset_problems(subset_config.resolve()) if subset_config else []
    allowed_problems = set(selected_problems) if selected_problems else None

    backend_metrics = {
        backend: collect_backend_problem_pareto(backend, root, allowed_problems=allowed_problems)
        for backend, root in backend_runs
    }
    if selected_problems:
        problem_keys = list(selected_problems)
    else:
        keys = {
            key
            for metrics_by_problem in backend_metrics.values()
            for key in metrics_by_problem
        }
        problem_keys = sorted(keys)

    problem_rows: list[dict[str, Any]] = []
    figure_rows: list[dict[str, Any]] = []

    for benchmark, problem in problem_keys:
        per_backend = {
            backend: metrics
            for backend, metrics_by_problem in backend_metrics.items()
            for key, metrics in metrics_by_problem.items()
            if key == (benchmark, problem)
        }
        problem_dir = output_dir / "problems" / benchmark / problem
        pairwise_path = problem_dir / "pairwise_fronts.png"
        front_3d_path = problem_dir / "front_3d.png"
        _plot_pairwise_fronts(
            pairwise_path,
            benchmark=benchmark,
            problem=problem,
            per_backend=per_backend,
        )
        if any(len(metrics.objective_metrics) == 3 for metrics in per_backend.values()):
            _plot_3d_front(
                front_3d_path,
                benchmark=benchmark,
                problem=problem,
                per_backend=per_backend,
            )
            front_3d_rel = _relative_path(front_3d_path, output_dir)
        else:
            front_3d_rel = None
        figure_rows.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "pairwise_path": _relative_path(pairwise_path, output_dir),
                "front_3d_path": front_3d_rel,
            }
        )

        representative = next(iter(per_backend.values()), None)
        for backend, _ in backend_runs:
            metrics = backend_metrics[backend].get((benchmark, problem))
            problem_rows.append(
                {
                    "backend": backend,
                    "benchmark": benchmark,
                    "problem": problem,
                    "objective_count": len(metrics.objective_metrics) if metrics is not None else (
                        len(representative.objective_metrics) if representative is not None else 0
                    ),
                    "candidate_count": metrics.candidate_count if metrics is not None else 0,
                    "pareto_point_count": metrics.pareto_point_count if metrics is not None else 0,
                    "hypervolume": metrics.hypervolume if metrics is not None else 0.0,
                    "reference_beating_count": (
                        metrics.reference_beating_count if metrics is not None else 0
                    ),
                    "best_area_improvement": (
                        metrics.best_improvements.get("area", 0.0) if metrics is not None else 0.0
                    ),
                    "best_power_improvement": (
                        metrics.best_improvements.get("power", 0.0) if metrics is not None else 0.0
                    ),
                    "best_period_improvement": (
                        metrics.best_improvements.get("eff_clk_period", 0.0)
                        if metrics is not None
                        else 0.0
                    ),
                    "problem_dir": metrics.problem_dir if metrics is not None else "",
                }
            )

    aggregate_rows = _aggregate_backend_rows(problem_rows)
    _write_csv(
        output_dir / "backend_problem_metrics.csv",
        problem_rows,
        [
            "backend",
            "benchmark",
            "problem",
            "objective_count",
            "candidate_count",
            "pareto_point_count",
            "hypervolume",
            "reference_beating_count",
            "best_area_improvement",
            "best_power_improvement",
            "best_period_improvement",
            "problem_dir",
        ],
    )
    _write_csv(
        output_dir / "aggregate_backend_metrics.csv",
        aggregate_rows,
        [
            "backend",
            "benchmark",
            "problem_count",
            "pareto_valid_problem_count",
            "mean_hypervolume",
            "mean_pareto_point_count",
            "mean_reference_beating_count",
            "hypervolume_win_count",
        ],
    )

    report_text = _render_report(
        output_dir=output_dir,
        subset_config=subset_config.resolve() if subset_config else None,
        backends=[backend for backend, _ in backend_runs],
        problem_rows=problem_rows,
        aggregate_rows=aggregate_rows,
        figure_rows=figure_rows,
    )
    report_path = output_dir / "report.md"
    report_path.write_text(report_text + "\n", encoding="utf-8")
    summary = {
        "subset_config": str(subset_config.resolve()) if subset_config else None,
        "backend_count": len(backend_runs),
        "problem_count": len(problem_keys),
        "overall_multi_objective_winner": _recommend_backend(aggregate_rows),
        "backend_problem_metrics": problem_rows,
        "aggregate_backend_metrics": aggregate_rows,
        "problem_figures": figure_rows,
        "report_path": str(report_path),
    }
    summary_path = output_dir / "summary.json"
    summary_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    return {
        "report_path": str(report_path),
        "summary_path": str(summary_path),
        "summary": summary,
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate per-problem and aggregate Pareto analysis for backend comparisons."
    )
    parser.add_argument(
        "--backend_run",
        action="append",
        default=[],
        type=_parse_backend_run,
        help="Backend label and experiment root in the form backend=/path/to/root",
    )
    parser.add_argument(
        "--subset-config",
        type=Path,
        default=None,
        help="Optional frozen subset config limiting which problems are analyzed.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        required=True,
        help="Directory to write pareto_analysis outputs into.",
    )
    args = parser.parse_args()
    generate_pareto_analysis_report(
        backend_runs=args.backend_run,
        output_dir=args.output_dir,
        subset_config=args.subset_config,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
