#!/usr/bin/env python3
"""Summarize one staged PCN experiment."""

from __future__ import annotations

import argparse
import csv
import json
import math
from pathlib import Path
import sys

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

sys.path.insert(0, str(Path(__file__).resolve().parents[7] / "src"))

from revolution.qd.pareto_analysis import hypervolume, pareto_front  # noqa: E402


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def write_csv(path: Path, fields: list[str], rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def fmt(value: float) -> str:
    assert math.isfinite(value)
    return f"{value:.12g}"


def budget_for_stage(stage: str) -> str:
    if stage in {"smoke", "screen"}:
        return "8x5"
    if stage == "smoke_credit025":
        return "8x5_credit025"
    if stage == "long_20x10":
        return "20x10"
    if stage == "long_10x20":
        return "10x20"
    raise AssertionError(f"unknown stage: {stage}")


def generation_count(stage: str) -> int:
    if stage in {"smoke", "screen"}:
        return 5
    if stage == "smoke_credit025":
        return 5
    if stage == "long_20x10":
        return 10
    if stage == "long_10x20":
        return 20
    raise AssertionError(f"unknown stage: {stage}")


def subset_name(stage: str) -> str:
    if stage == "smoke_credit025":
        return "smoke"
    if stage.startswith("long_"):
        return "long_budget"
    return stage


def objective_keys(circuit_type: str) -> tuple[str, ...]:
    if circuit_type == "sequential":
        return ("g_P", "g_A", "g_T")
    if circuit_type == "combinational":
        return ("g_P", "g_A")
    raise AssertionError(f"unknown circuit type: {circuit_type}")


def hv_at_step(rows: list[dict[str, str]], step: int) -> float:
    visible = [row for row in rows if int(row["generation"]) <= step]
    if not visible:
        return 0.0
    keys = objective_keys(visible[0]["circuit_type"])
    points = [tuple(float(row[key]) for key in keys) for row in visible]
    front = [points[index] for index in pareto_front(points)]
    return hypervolume(front)


def auc(values: list[float]) -> float:
    assert len(values) >= 2
    total = 0.0
    for left, right in zip(values[:-1], values[1:], strict=True):
        total += (left + right) / 2.0
    return total / (len(values) - 1)


def method_label(method: str) -> str:
    label = method
    for suffix in ("_8x5", "_20x10", "_10x20"):
        label = label.removesuffix(suffix)
    replacements = {
        "classic_revolution": "classic",
        "classic_revolution_credit025": "classic",
        "pcn_passive_archive": "PCN passive",
        "pcn_rf_leafid_quality_memory": "PCN RF",
        "pcn_rf_leafid_quality_memory_credit025": "PCN RF",
        "pcn_random_quality_memory": "PCN random",
        "pcn_random_quality_memory_credit025": "PCN random",
        "pcn_sr_quality_memory": "PCN SR",
    }
    return replacements.get(label, label)


def bar(path: Path, rows: list[dict[str, str]], field: str, title: str, ylabel: str) -> None:
    labels = [method_label(row["method"]) for row in rows]
    values = [float(row[field]) for row in rows]
    colors = ["#4c78a8", "#f58518", "#54a24b", "#e45756", "#72b7b2"]
    fig, ax = plt.subplots(figsize=(9, 4.8))
    ax.bar(labels, values, color=colors[: len(rows)], edgecolor="#222222", linewidth=0.7)
    ax.set_title(title)
    ax.set_ylabel(ylabel)
    ax.tick_params(axis="x", labelrotation=20)
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def grouped_problem_bar(
    path: Path,
    problem_rows: list[dict[str, str]],
    methods: list[str],
    problems: list[str],
    field: str,
    title: str,
    ylabel: str,
) -> None:
    values = {(row["method"], row["problem"]): float(row[field]) for row in problem_rows}
    width = 0.78 / len(methods)
    xs = list(range(len(problems)))
    colors = ["#4c78a8", "#f58518", "#54a24b", "#e45756", "#72b7b2"]
    fig, ax = plt.subplots(figsize=(10.5, 5.2))
    for index, method in enumerate(methods):
        offset = (index - (len(methods) - 1) / 2.0) * width
        ax.bar(
            [x + offset for x in xs],
            [values[(method, problem)] for problem in problems],
            width=width,
            label=method_label(method),
            color=colors[index % len(colors)],
            edgecolor="#222222",
            linewidth=0.55,
        )
    ax.set_title(title)
    ax.set_ylabel(ylabel)
    ax.set_xticks(xs, problems, rotation=18, ha="right")
    ax.grid(axis="y", alpha=0.25)
    ax.legend(ncols=3, fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def heatmap(
    path: Path,
    problem_rows: list[dict[str, str]],
    methods: list[str],
    problems: list[str],
    field: str,
    title: str,
) -> None:
    values = {(row["method"], row["problem"]): float(row[field]) for row in problem_rows}
    matrix = [[values[(method, problem)] for problem in problems] for method in methods]
    limit = max(abs(value) for row in matrix for value in row) or 1.0
    fig, ax = plt.subplots(figsize=(9.5, 4.8))
    image = ax.imshow(matrix, cmap="RdBu", vmin=-limit, vmax=limit, aspect="auto")
    ax.set_title(title)
    ax.set_xticks(range(len(problems)), problems, rotation=18, ha="right")
    ax.set_yticks(range(len(methods)), [method_label(method) for method in methods])
    for y, row in enumerate(matrix):
        for x, value in enumerate(row):
            ax.text(x, y, f"{value:+.3f}", ha="center", va="center", fontsize=8)
    fig.colorbar(image, ax=ax, shrink=0.82, label=field)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def lane_value(metrics: dict[str, object], field: str, lane: str) -> int:
    lanes = metrics.get(field) or {}
    assert isinstance(lanes, dict)
    value = lanes.get(lane, 0)
    assert isinstance(value, int)
    return value


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--doc-root", type=Path, required=True)
    parser.add_argument("--stage", required=True)
    args = parser.parse_args()

    doc_root = args.doc_root.resolve()
    budget = budget_for_stage(args.stage)
    max_generation = generation_count(args.stage)
    analysis_root = doc_root / "analysis" / args.stage
    figures_root = doc_root / "figures" / args.stage
    figures_root.mkdir(parents=True, exist_ok=True)

    manifest = read_csv(doc_root / "tables" / "method_manifest.csv")
    methods = [row["method"] for row in manifest if row["budget"] == budget]
    families = {row["method"]: row["family"] for row in manifest}
    problems = [
        row["problem"]
        for row in read_csv(doc_root / "tables" / f"{subset_name(args.stage)}_subset.csv")
    ]
    classic = next(method for method in methods if method.startswith("classic_revolution"))

    pareto_rows = read_csv(analysis_root / "pareto_analysis" / "backend_problem_metrics.csv")
    pareto = {(row["backend"], row["problem"]): row for row in pareto_rows}

    candidate_rows = read_csv(analysis_root / "ppa_distribution" / "data" / "ppa_candidates.csv")
    candidates: dict[tuple[str, str], list[dict[str, str]]] = {}
    for row in candidate_rows:
        candidates.setdefault((row["backend"], row["problem"]), []).append(row)

    hv_auc: dict[tuple[str, str], float] = {}
    for method in methods:
        for problem in problems:
            rows = candidates.get((method, problem), [])
            values = [hv_at_step(rows, step) for step in range(max_generation + 1)]
            hv_auc[(method, problem)] = auc(values)

    problem_summary: list[dict[str, str]] = []
    classic_hv = {
        problem: float(pareto.get((classic, problem), {}).get("hypervolume", 0.0))
        for problem in problems
    }
    classic_auc = {problem: hv_auc[(classic, problem)] for problem in problems}

    for method in methods:
        for problem in problems:
            row = pareto.get((method, problem))
            hv = float(row["hypervolume"]) if row else 0.0
            auc_value = hv_auc[(method, problem)]
            valid = int(row["candidate_count"]) if row else 0
            pareto_count = int(row["pareto_point_count"]) if row else 0
            problem_summary.append(
                {
                    "method": method,
                    "problem": problem,
                    "hypervolume": fmt(hv),
                    "hv_auc": fmt(auc_value),
                    "valid_ppa_count": str(valid),
                    "pareto_point_count": str(pareto_count),
                    "hv_delta_vs_classic": fmt(hv - classic_hv[problem]),
                    "hv_auc_delta_vs_classic": fmt(auc_value - classic_auc[problem]),
                }
            )

    method_summary: list[dict[str, str]] = []
    for method in methods:
        rows = [row for row in problem_summary if row["method"] == method]
        hv_values = [float(row["hypervolume"]) for row in rows]
        auc_values = [float(row["hv_auc"]) for row in rows]
        valid_counts = [int(row["valid_ppa_count"]) for row in rows]
        pareto_counts = [int(row["pareto_point_count"]) for row in rows]
        covered = sum(1 for value in valid_counts if value > 0)
        mean_hv = sum(hv_values) / len(problems)
        mean_auc = sum(auc_values) / len(problems)
        classic_mean_hv = sum(classic_hv.values()) / len(problems)
        classic_mean_auc = sum(classic_auc.values()) / len(problems)
        retention = 100.0 * mean_hv / classic_mean_hv if classic_mean_hv > 0 else 0.0
        method_summary.append(
            {
                "method": method,
                "family": families[method],
                "budget": budget,
                "covered_problem_count": str(covered),
                "headline_problem_count": str(len(problems)),
                "mean_hv": fmt(mean_hv),
                "mean_hv_auc": fmt(mean_auc),
                "mean_valid_ppa_count": fmt(sum(valid_counts) / len(problems)),
                "mean_pareto_point_count": fmt(sum(pareto_counts) / len(problems)),
                "classic_delta_mean_hv": fmt(mean_hv - classic_mean_hv),
                "classic_delta_mean_hv_auc": fmt(mean_auc - classic_mean_auc),
                "mean_hv_retention_pct": fmt(retention),
            }
        )

    method_summary.sort(key=lambda row: float(row["mean_hv"]), reverse=True)
    write_csv(analysis_root / "pcn_method_summary.csv", list(method_summary[0]), method_summary)
    write_csv(analysis_root / "pcn_problem_summary.csv", list(problem_summary[0]), problem_summary)

    memory_summary: list[dict[str, str]] = []
    for row in pareto_rows:
        method = row["backend"]
        if method == classic or method not in methods:
            continue
        metrics_path = Path(row["problem_dir"]) / "qd_metrics.json"
        assert metrics_path.exists()
        metrics = json.loads(metrics_path.read_text(encoding="utf-8"))
        memory_summary.append(
            {
                "method": method,
                "problem": row["problem"],
                "qd_memory_active": str(bool(metrics.get("qd_memory_active", False))).lower(),
                "qd_memory_valid_ppa_seen": str(metrics.get("qd_memory_valid_ppa_seen", 0)),
                "sampleable_memory_cells": str(metrics.get("sampleable_memory_cells", 0)),
                "mean_cell_credit": fmt(float(metrics.get("mean_cell_credit", 0.0))),
                "classic_generated": str(lane_value(metrics, "qd_memory_lane_generated", "classic")),
                "memory_refine_generated": str(lane_value(metrics, "qd_memory_lane_generated", "memory_refine")),
                "memory_refine_valid_ppa": str(lane_value(metrics, "qd_memory_lane_valid_ppa", "memory_refine")),
                "memory_refine_global_front_adds": str(lane_value(metrics, "qd_memory_lane_global_front_adds", "memory_refine")),
                "memory_refine_local_front_adds": str(lane_value(metrics, "qd_memory_lane_local_front_adds", "memory_refine")),
            }
        )
    if memory_summary:
        write_csv(analysis_root / "pcn_memory_summary.csv", list(memory_summary[0]), memory_summary)

    bar(figures_root / "mean_hv_by_method.png", method_summary, "mean_hv", f"{args.stage}: mean HV", "Mean HV")
    bar(figures_root / "mean_hv_auc_by_method.png", method_summary, "mean_hv_auc", f"{args.stage}: mean HV-AUC", "Mean HV-AUC")
    bar(figures_root / "coverage_by_method.png", method_summary, "covered_problem_count", f"{args.stage}: valid-PPA coverage", "Covered designs")
    bar(figures_root / "hv_retention_by_method.png", method_summary, "mean_hv_retention_pct", f"{args.stage}: HV retention", "Retention vs classic (%)")
    ordered_methods = [row["method"] for row in method_summary]
    grouped_problem_bar(
        figures_root / "problem_hv_by_method.png",
        problem_summary,
        ordered_methods,
        problems,
        "hypervolume",
        f"{args.stage}: per-problem HV",
        "HV",
    )
    grouped_problem_bar(
        figures_root / "problem_valid_ppa_by_method.png",
        problem_summary,
        ordered_methods,
        problems,
        "valid_ppa_count",
        f"{args.stage}: valid-PPA count by problem",
        "Valid-PPA candidates",
    )
    heatmap(
        figures_root / "hv_delta_vs_classic_heatmap.png",
        problem_summary,
        ordered_methods,
        problems,
        "hv_delta_vs_classic",
        f"{args.stage}: HV delta vs classic",
    )
    if memory_summary:
        memory_methods = [method for method in ordered_methods if method != classic]
        grouped_problem_bar(
            figures_root / "memory_refine_generated_by_problem.png",
            memory_summary,
            memory_methods,
            problems,
            "memory_refine_generated",
            f"{args.stage}: memory-refine generated calls",
            "Generated calls",
        )

    lines = [
        f"# PCN Stage Summary: {args.stage}",
        "",
        "| Method | Covered | Mean HV | Mean HV-AUC | HV retention | Delta HV |",
        "| --- | ---: | ---: | ---: | ---: | ---: |",
    ]
    for row in method_summary:
        lines.append(
            "| "
            + " | ".join(
                [
                    f"`{row['method']}`",
                    f"{row['covered_problem_count']}/{row['headline_problem_count']}",
                    f"{float(row['mean_hv']):.4f}",
                    f"{float(row['mean_hv_auc']):.4f}",
                    f"{float(row['mean_hv_retention_pct']):.1f}%",
                    f"{float(row['classic_delta_mean_hv']):.4f}",
                ]
            )
            + " |"
        )
    (analysis_root / "summary.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
