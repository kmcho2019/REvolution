#!/usr/bin/env python3
"""Package the 20260623 RTLLM milestone screen."""

from __future__ import annotations

import argparse
import math
from pathlib import Path
import sys
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scripts.package_t27_t26_live_qd_audit import (
    auc,
    fmt,
    fmt_optional,
    front_spread,
    hypervolume_curve,
    load_json,
    load_jsonl,
    load_optional_json,
    mean_float,
    parse_optional,
    required_auc,
    success_count,
    success_rate,
    unique_improvement_points,
    write_csv,
)
from revolution.qd.pareto_analysis import analyze_problem_pareto

PROBLEMS = (
    "Prob045_alu",
    "Prob041_traffic_light",
    "Prob015_multi_pipe_8bit",
)

METHODS = (
    {
        "method": "classic_revolution",
        "label": "Classic",
        "mode": "classic_revolution/seed_1001/openai_gpt-oss-120b",
        "color": "#4e79a7",
    },
    {
        "method": "sr_raw_conservative_exploit_qd",
        "label": "Exact T26",
        "mode": "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#e15759",
    },
    {
        "method": "sr_raw_conservative_exploit_low_fusion_qd",
        "label": "T26.1 Low Fusion",
        "mode": "sr_raw_conservative_exploit_low_fusion_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#59a14f",
    },
    {
        "method": "sr_raw_conservative_exploit_mid_fusion_qd",
        "label": "T26.1 Mid Fusion",
        "mode": "sr_raw_conservative_exploit_mid_fusion_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#f28e2b",
    },
)

COLORS = {method["label"]: method["color"] for method in METHODS}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    rows = [problem_row(args.run_root, method, problem) for method in METHODS for problem in PROBLEMS]
    aggregates = aggregate_rows(rows)
    deltas = delta_rows(rows, aggregates)
    write_csv(table_dir / "screen_problem_metrics.csv", rows)
    write_csv(table_dir / "screen_aggregate_metrics.csv", aggregates)
    write_csv(table_dir / "screen_selection_deltas.csv", deltas)
    write_csv(table_dir / "screen_method_manifest.csv", manifest_rows(args.run_root))
    plot_problem_metrics(rows, figure_dir / "screen_problem_metrics.png")
    plot_aggregate_metrics(aggregates, figure_dir / "screen_aggregate_metrics.png")
    write_selection_report(args.output_dir / "selection_report.md", args.run_root, aggregates, deltas)
    return 0


def problem_row(run_root: Path, method: dict[str, str], problem: str) -> dict[str, str]:
    problem_root = run_root / method["mode"] / "RTLLM" / problem
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
        "active_global_pareto_members": fmt_optional(
            optional_int(global_pareto, "total_global_pareto_members")
        ),
        "active_qd_score_auc": fmt_optional(auc(qd_scores) if qd_scores else None),
        "active_coverage_auc": fmt_optional(auc(coverages) if coverages else None),
    }


def aggregate_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    output = []
    for method in METHODS:
        method_rows = [row for row in rows if row["method"] == method["method"]]
        output.append(
            {
                "method": method["method"],
                "method_label": method["label"],
                "problem_count": str(len(method_rows)),
                "valid_ppa_count": str(sum(int(row["valid_ppa_count"]) for row in method_rows)),
                "mean_valid_ppa_rate": fmt(mean_float(method_rows, "valid_ppa_rate")),
                "mean_best_score": fmt(mean_float(method_rows, "best_score")),
                "mean_global_ppa_hypervolume": fmt(
                    mean_float(method_rows, "global_ppa_hypervolume")
                ),
                "mean_hv_auc": fmt(mean_float(method_rows, "hv_auc")),
                "total_ppa_front_points": str(sum(int(row["ppa_front_points"]) for row in method_rows)),
                "total_reference_beating_count": str(
                    sum(int(row["reference_beating_count"]) for row in method_rows)
                ),
                "total_unique_ppa_points": str(sum(int(row["unique_ppa_points"]) for row in method_rows)),
                "total_duplicate_ppa_point_count": str(
                    sum(int(row["duplicate_ppa_point_count"]) for row in method_rows)
                ),
                "mean_front_nn_distance": fmt(mean_float(method_rows, "front_nn_distance")),
                "mean_active_archive_coverage": fmt_optional(
                    mean_optional(method_rows, "active_archive_coverage")
                ),
                "mean_active_archive_qd_score": fmt_optional(
                    mean_optional(method_rows, "active_archive_qd_score")
                ),
                "total_active_archive_members": fmt_optional(
                    sum_optional(method_rows, "active_archive_members")
                ),
                "total_active_global_pareto_members": fmt_optional(
                    sum_optional(method_rows, "active_global_pareto_members")
                ),
                "mean_active_qd_score_auc": fmt_optional(
                    mean_optional(method_rows, "active_qd_score_auc")
                ),
                "mean_active_coverage_auc": fmt_optional(
                    mean_optional(method_rows, "active_coverage_auc")
                ),
            }
        )
    return output


def delta_rows(rows: list[dict[str, str]], aggregates: list[dict[str, str]]) -> list[dict[str, str]]:
    aggregate_by_method = {row["method"]: row for row in aggregates}
    problem_by_key = {(row["method"], row["problem"]): row for row in rows}
    output = []
    for method in METHODS[1:]:
        method_name = method["method"]
        for metric in (
            "mean_global_ppa_hypervolume",
            "mean_hv_auc",
            "valid_ppa_count",
            "total_ppa_front_points",
            "total_unique_ppa_points",
            "total_reference_beating_count",
        ):
            output.append(delta_row(aggregate_by_method, method_name, "classic_revolution", metric))
        for problem in PROBLEMS:
            output.append(
                problem_gate_row(problem_by_key, method_name, "classic_revolution", problem)
            )
    return output


def delta_row(
    by_method: dict[str, dict[str, str]],
    method: str,
    reference: str,
    metric: str,
) -> dict[str, str]:
    value = parse_optional(by_method[method][metric])
    ref_value = parse_optional(by_method[reference][metric])
    delta = None if value is None or ref_value is None else value - ref_value
    return {
        "scope": "aggregate",
        "method": method,
        "reference": reference,
        "problem": "",
        "metric": metric,
        "value": fmt_optional(value),
        "reference_value": fmt_optional(ref_value),
        "delta": fmt_optional(delta),
        "relative_delta": fmt_optional(relative_delta(value, ref_value)),
        "gate_status": "",
    }


def problem_gate_row(
    by_key: dict[tuple[str, str], dict[str, str]],
    method: str,
    reference: str,
    problem: str,
) -> dict[str, str]:
    """Return the highest-severity valid-PPA launch gate for one problem."""

    value = int(by_key[(method, problem)]["valid_ppa_count"])
    ref_value = int(by_key[(reference, problem)]["valid_ppa_count"])
    status = "pass"
    if ref_value > 0 and value == 0:
        status = "classic_covered_loss"
    elif ref_value >= 10 and value * 2 <= ref_value:
        status = "yield_warning"
    elif 0 < ref_value < 10:
        status = "small_n"
    return {
        "scope": "problem",
        "method": method,
        "reference": reference,
        "problem": problem,
        "metric": "valid_ppa_count",
        "value": str(value),
        "reference_value": str(ref_value),
        "delta": str(value - ref_value),
        "relative_delta": fmt_optional(relative_delta(float(value), float(ref_value))),
        "gate_status": status,
    }


def manifest_rows(run_root: Path) -> list[dict[str, str]]:
    return [
        {
            "method": method["method"],
            "method_label": method["label"],
            "run_root": str(run_root),
            "mode": method["mode"],
        }
        for method in METHODS
    ]


def plot_problem_metrics(rows: list[dict[str, str]], output_path: Path) -> None:
    methods = [method["label"] for method in METHODS]
    by_key = {(row["method_label"], row["problem"]): row for row in rows}
    x_positions = list(range(len(PROBLEMS)))
    width = 0.78 / len(methods)
    fig, axes = plt.subplots(1, 3, figsize=(15.8, 4.8))
    problem_metric_panel(
        axes[0], methods, by_key, x_positions, width, "global_ppa_hypervolume", "PPA Hypervolume"
    )
    problem_metric_panel(
        axes[1], methods, by_key, x_positions, width, "hv_auc", "HV AUC"
    )
    problem_metric_panel(
        axes[2], methods, by_key, x_positions, width, "ppa_front_points", "PPA Front Points"
    )
    for axis in axes:
        axis.set_xticks(x_positions)
        axis.set_xticklabels(problem_labels(), rotation=25, ha="right")
        axis.grid(axis="y", color="#e3e3e3", linewidth=0.8)
        axis.legend(frameon=False, fontsize=8)
    fig.suptitle("RTLLM Milestone Screen By Problem", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_aggregate_metrics(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [row["method_label"] for row in rows]
    x = list(range(len(rows)))
    fig, axes = plt.subplots(1, 3, figsize=(13.8, 4.6))
    aggregate_panel(axes[0], rows, x, "mean_global_ppa_hypervolume", "Mean HV")
    aggregate_panel(axes[1], rows, x, "mean_hv_auc", "Mean HV AUC")
    aggregate_panel(axes[2], rows, x, "total_ppa_front_points", "Front Points")
    for axis in axes:
        axis.set_xticks(x)
        axis.set_xticklabels(labels, rotation=20, ha="right")
        axis.grid(axis="y", color="#e3e3e3", linewidth=0.8)
    fig.suptitle("RTLLM Milestone Screen Aggregate", y=1.02)
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
        values = [
            parse_optional(by_key[(method, problem)][metric]) or 0.0
            for problem in PROBLEMS
        ]
        axis.bar(
            [position + offset for position in x_positions],
            values,
            width,
            label=method,
            color=COLORS[method],
            alpha=0.84,
        )
    axis.set_title(title)


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


def write_selection_report(
    path: Path,
    run_root: Path,
    aggregates: list[dict[str, str]],
    deltas: list[dict[str, str]],
) -> None:
    by_method = {row["method"]: row for row in aggregates}
    chosen = choose_method(aggregates, deltas)
    lines = [
        "# RTLLM Milestone Screen Selection",
        "",
        f"Run root: `{run_root}`",
        "",
        "## Decision",
        "",
        f"Selected full-run QD arm: `{chosen}`.",
        "",
        "This is a screen decision, not a final research claim. The full RTLLM",
        "one-seed run remains the first deadline milestone, with multi-seed",
        "replication deferred until after the presentation package.",
        "",
        "## Aggregate Metrics",
        "",
        "| Method | Mean HV | Mean HV-AUC | Valid PPA | Front Points | Unique PPA Points |",
        "| --- | ---: | ---: | ---: | ---: | ---: |",
    ]
    for method in METHODS:
        row = by_method[method["method"]]
        lines.append(
            f"| {row['method_label']} | {row['mean_global_ppa_hypervolume']} | "
            f"{row['mean_hv_auc']} | {row['valid_ppa_count']} | "
            f"{row['total_ppa_front_points']} | {row['total_unique_ppa_points']} |"
        )
    lines.extend(
        [
            "",
        "## Gate Notes",
        "",
        "- Exact T26's screen edge is narrow and must be presented with its",
        "  yield and breadth warnings.",
        "- Full-run selection must still be reviewed adversarially before launch.",
            "- Any one-seed win is paired engineering evidence, not seed-stable",
            "  significance.",
            "- The hard launch gate is classic-covered retention: if classic has",
            "  at least one valid-PPA sample for a problem, the selected QD arm",
            "  must also have at least one.",
            "- A 50% or larger valid-PPA drop is reported as a yield warning,",
            "  not a launch blocker, because the deadline milestone prioritizes",
            "  PPA optimization and design coverage.",
            "",
        ]
    )
    path.write_text("\n".join(lines), encoding="utf-8")


def choose_method(aggregates: list[dict[str, str]], deltas: list[dict[str, str]]) -> str:
    blocked = {
        row["method"]
        for row in deltas
        if row["scope"] == "problem" and row["gate_status"] == "classic_covered_loss"
    }
    candidates = [row for row in aggregates if row["method"] != "classic_revolution" and row["method"] not in blocked]
    assert candidates
    return max(
        candidates,
        key=lambda row: (
            float(row["mean_global_ppa_hypervolume"]),
            float(row["mean_hv_auc"]),
            int(row["total_ppa_front_points"]),
        ),
    )["method"]


def problem_labels() -> list[str]:
    return ["P045 ALU", "P041 traffic", "P015 pipe"]


def optional_float(payload: dict[str, object] | None, key: str) -> float | None:
    if payload is None:
        return None
    value = payload.get(key)
    if value is None:
        return None
    assert isinstance(value, int | float | str)
    return float(value)


def optional_int(payload: dict[str, object] | None, key: str) -> int | None:
    value = optional_float(payload, key)
    if value is None:
        return None
    return int(value)


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


def relative_delta(value: float | None, reference: float | None) -> float | None:
    if value is None or reference is None or math.isclose(reference, 0.0):
        return None
    return (value - reference) / abs(reference)


if __name__ == "__main__":
    raise SystemExit(main())
