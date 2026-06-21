#!/usr/bin/env python3
"""Package the T29 SR raw front-recovery live audit."""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

from revolution.qd.pareto_analysis import analyze_problem_pareto
from scripts.package_t27_t26_live_qd_audit import (
    auc,
    front_spread,
    hypervolume_curve,
    load_json,
    load_jsonl,
    load_optional_json,
    optional_float,
    optional_int,
    parse_optional,
    relative_delta,
    success_count,
    success_rate,
    unique_improvement_points,
)
from scripts.package_t28_t26_family_audit import (
    FamilyCandidate,
    collect_problem_candidates,
    fmt,
    fmt_optional,
    metric_row,
    ratio,
    sum_int,
    write_csv,
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
        "color": "#4e79a7",
    },
    {
        "method": "landing_smooth_qd_manual_bd",
        "label": "Manual BD",
        "source": "t24",
        "mode": "landing_smooth_qd_manual_bd/seed_1001/openai_gpt-oss-120b",
        "color": "#b07aa1",
    },
    {
        "method": "random_descriptor_qd",
        "label": "Random",
        "source": "t24",
        "mode": "random_descriptor_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#8c8c8c",
    },
    {
        "method": "sr_raw_pca_qd",
        "label": "SR raw",
        "source": "t24",
        "mode": "sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#59a14f",
    },
    {
        "method": "guarded_sr_raw_pareto_qd",
        "label": "Guarded SR raw",
        "source": "t25",
        "mode": "guarded_sr_raw_pareto_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#9c755f",
    },
    {
        "method": "sr_raw_conservative_exploit_qd",
        "label": "Conservative exploit",
        "source": "t26",
        "mode": "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#e15759",
    },
    {
        "method": "sr_raw_front_recovery_qd",
        "label": "Front recovery",
        "source": "t29",
        "mode": "sr_raw_front_recovery_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#6f4e7c",
    },
)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--t24-run-root", required=True, type=Path)
    parser.add_argument("--t25-run-root", required=True, type=Path)
    parser.add_argument("--t26-run-root", required=True, type=Path)
    parser.add_argument("--t29-run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    run_roots = {
        "t24": args.t24_run_root,
        "t25": args.t25_run_root,
        "t26": args.t26_run_root,
        "t29": args.t29_run_root,
    }
    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    live_rows = [
        live_problem_row(run_roots, method, problem)
        for method in METHODS
        for problem in PROBLEMS
    ]
    live_aggregate_rows = aggregate_live_rows(live_rows)
    live_delta_rows = live_comparison_rows(live_aggregate_rows)
    family_candidates = [
        candidate
        for method in METHODS
        for problem in PROBLEMS
        for candidate in collect_problem_candidates(run_roots, method, problem)
    ]
    family_rows = family_problem_rows(family_candidates)
    family_aggregate_rows = aggregate_family_rows(family_rows)
    family_delta_rows = family_comparison_rows(family_aggregate_rows)

    write_csv(table_dir / "t29_live_problem_metrics.csv", live_rows)
    write_csv(table_dir / "t29_live_aggregate_metrics.csv", live_aggregate_rows)
    write_csv(table_dir / "t29_live_comparison_deltas.csv", live_delta_rows)
    write_csv(table_dir / "t29_family_candidate_rows.csv", family_candidate_rows(family_candidates))
    write_csv(table_dir / "t29_family_problem_metrics.csv", family_rows)
    write_csv(table_dir / "t29_family_aggregate_metrics.csv", family_aggregate_rows)
    write_csv(table_dir / "t29_family_comparison_deltas.csv", family_delta_rows)
    write_csv(table_dir / "t29_method_manifest.csv", manifest_rows(run_roots))
    write_figures(live_rows, live_aggregate_rows, family_candidates, family_aggregate_rows, figure_dir)
    return 0


def live_problem_row(
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
    spread = front_spread(pareto)
    unique_points = unique_improvement_points(pareto.candidates, pareto.objective_metrics)
    final_score = final_best_score(summary)
    return {
        "method": method["method"],
        "method_label": method["label"],
        "problem": problem,
        "candidate_count": str(pareto.candidate_count),
        "total_generated": str(int(summary["total_candidates_generated"])),
        "valid_ppa_count": str(success_count(summary, "synthesis_ppa")),
        "valid_ppa_rate": fmt(success_rate(summary, "synthesis_ppa")),
        "final_best_score": fmt_optional(final_score),
        "final_best_available": str(final_score is not None).lower(),
        "global_ppa_hypervolume": fmt(pareto.hypervolume),
        "hv_auc": fmt_optional(auc(hv_curve)),
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
        "active_qd_score_auc": fmt_optional(auc([float(row.get("qd_score") or 0.0) for row in history])),
        "active_coverage_auc": fmt_optional(auc([float(row.get("coverage") or 0.0) for row in history])),
    }


def final_best_score(summary: dict[str, Any]) -> float | None:
    value = summary["final_population_ppa"]["best_score"]
    if value is None:
        return None
    return float(value)


def aggregate_live_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    output = []
    for method in METHODS:
        subset = [row for row in rows if row["method"] == method["method"]]
        final_scores = [parse_optional(row["final_best_score"]) for row in subset]
        available_scores = [value for value in final_scores if value is not None]
        output.append(
            {
                "method": method["method"],
                "method_label": method["label"],
                "problem_count": str(len(subset)),
                "valid_ppa_count": str(sum(int(row["valid_ppa_count"]) for row in subset)),
                "final_best_problem_count": str(len(available_scores)),
                "mean_valid_ppa_rate": fmt(mean_required(subset, "valid_ppa_rate")),
                "mean_final_best_score": fmt_optional(mean_values(available_scores)),
                "mean_global_ppa_hypervolume": fmt(mean_required(subset, "global_ppa_hypervolume")),
                "mean_hv_auc": fmt(mean_required(subset, "hv_auc")),
                "total_ppa_front_points": str(sum(int(row["ppa_front_points"]) for row in subset)),
                "total_reference_beating_count": str(
                    sum(int(row["reference_beating_count"]) for row in subset)
                ),
                "total_unique_ppa_points": str(sum(int(row["unique_ppa_points"]) for row in subset)),
                "total_active_archive_members": fmt_optional(
                    sum_optional(subset, "active_archive_members")
                ),
                "total_active_global_pareto_members": fmt_optional(
                    sum_optional(subset, "active_global_pareto_members")
                ),
                "mean_active_qd_score_auc": fmt_optional(mean_optional(subset, "active_qd_score_auc")),
                "mean_active_coverage_auc": fmt_optional(mean_optional(subset, "active_coverage_auc")),
            }
        )
    return output


def live_comparison_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_method = {row["method"]: row for row in rows}
    metrics = (
        "valid_ppa_count",
        "final_best_problem_count",
        "mean_final_best_score",
        "mean_global_ppa_hypervolume",
        "mean_hv_auc",
        "total_ppa_front_points",
        "total_reference_beating_count",
        "total_active_global_pareto_members",
    )
    return comparison_rows(by_method, "sr_raw_front_recovery_qd", metrics)


def family_problem_rows(candidates: list[FamilyCandidate]) -> list[dict[str, str]]:
    rows = []
    for method in METHODS:
        for problem in PROBLEMS:
            subset = [
                candidate
                for candidate in candidates
                if candidate.method == method["method"] and candidate.problem == problem
            ]
            rows.append(metric_row(method, problem, subset))
    return rows


def aggregate_family_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    output = []
    for method in METHODS:
        subset = [row for row in rows if row["method"] == method["method"]]
        valid_count = sum_int(subset, "valid_ppa_count")
        front_count = sum_int(subset, "ppa_front_count")
        unique_family = sum_int(subset, "unique_family_count")
        front_unique_family = sum_int(subset, "front_unique_family_count")
        front_unique_netlist = sum_int(subset, "front_unique_netlist_count")
        output.append(
            {
                "method": method["method"],
                "method_label": method["label"],
                "problem_count": str(len(subset)),
                "valid_ppa_count": str(valid_count),
                "ppa_front_count": str(front_count),
                "unique_family_count": str(unique_family),
                "front_unique_family_count": str(front_unique_family),
                "front_unique_netlist_count": str(front_unique_netlist),
                "reference_beating_unique_family_count": str(
                    sum_int(subset, "reference_beating_unique_family_count")
                ),
                "valid_family_ratio": fmt(ratio(unique_family, valid_count)),
                "front_family_ratio": fmt(ratio(front_unique_family, front_count)),
                "front_netlist_ratio": fmt(ratio(front_unique_netlist, front_count)),
            }
        )
    return output


def family_comparison_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_method = {row["method"]: row for row in rows}
    metrics = (
        "valid_ppa_count",
        "front_unique_family_count",
        "front_unique_netlist_count",
        "reference_beating_unique_family_count",
        "valid_family_ratio",
        "front_family_ratio",
    )
    return comparison_rows(by_method, "sr_raw_front_recovery_qd", metrics)


def comparison_rows(
    by_method: dict[str, dict[str, str]],
    method: str,
    metrics: tuple[str, ...],
) -> list[dict[str, str]]:
    output = []
    for reference in (
        "classic_revolution",
        "landing_smooth_qd_manual_bd",
        "random_descriptor_qd",
        "sr_raw_pca_qd",
        "guarded_sr_raw_pareto_qd",
        "sr_raw_conservative_exploit_qd",
    ):
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


def family_candidate_rows(candidates: list[FamilyCandidate]) -> list[dict[str, str]]:
    return [
        {
            "method": candidate.method,
            "method_label": candidate.method_label,
            "problem": candidate.problem,
            "candidate_id": candidate.candidate_id,
            "generation": str(candidate.generation),
            "strategy": candidate.strategy,
            "score": fmt(candidate.score),
            "area": fmt_optional(candidate.ppa_metrics.get("area")),
            "power": fmt_optional(candidate.ppa_metrics.get("power")),
            "eff_clk_period": fmt_optional(candidate.ppa_metrics.get("eff_clk_period")),
            "is_pareto_front": str(candidate.is_front).lower(),
            "beats_reference": str(candidate.beats_reference).lower(),
            "rtl_hash": candidate.rtl_hash,
            "netlist_hash": candidate.netlist_hash,
            "family_hash": candidate.family_hash,
            "family_signature": candidate.family_signature,
            "code_file_path": str(candidate.code_file_path),
        }
        for candidate in candidates
    ]


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


def write_figures(
    live_rows: list[dict[str, str]],
    live_aggregate: list[dict[str, str]],
    family_candidates: list[FamilyCandidate],
    family_aggregate: list[dict[str, str]],
    figure_dir: Path,
) -> None:
    plot_live_aggregate(live_aggregate, figure_dir / "t29_live_aggregate_metrics.png")
    plot_live_problem_fronts(live_rows, figure_dir / "t29_live_problem_front_counts.png")
    plot_family_aggregate(family_aggregate, figure_dir / "t29_family_aggregate_counts.png")
    plot_ppa_fronts(
        family_candidates,
        figure_dir / "t29_ppa_fronts_area_power_zoom.png",
        use_improvements=False,
    )
    plot_ppa_fronts(
        family_candidates,
        figure_dir / "t29_ppa_fronts_improvement.png",
        use_improvements=True,
    )


def plot_live_aggregate(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [row["method_label"] for row in rows]
    x = list(range(len(rows)))
    fig, axes = plt.subplots(1, 3, figsize=(17.6, 4.9))
    aggregate_panel(axes[0], rows, x, "mean_global_ppa_hypervolume", "Mean HV")
    aggregate_panel(axes[1], rows, x, "mean_hv_auc", "Mean HV AUC")
    aggregate_panel(axes[2], rows, x, "total_ppa_front_points", "Front Points")
    for axis in axes:
        axis.set_xticks(x)
        axis.set_xticklabels(labels, rotation=24, ha="right")
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.8)
    fig.suptitle("T29 Live QD Metrics", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_live_problem_fronts(rows: list[dict[str, str]], output_path: Path) -> None:
    plot_problem_bars(
        rows,
        output_path,
        "T29 Candidate-Level Front Counts By Problem",
        ("ppa_front_points", "reference_beating_count", "valid_ppa_count"),
        ("Front Points", "Reference-Beating", "Valid PPA"),
    )


def plot_family_aggregate(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [row["method_label"] for row in rows]
    x = list(range(len(rows)))
    fig, axes = plt.subplots(1, 3, figsize=(17.6, 4.9))
    aggregate_panel(axes[0], rows, x, "front_unique_family_count", "Front Families")
    aggregate_panel(axes[1], rows, x, "front_unique_netlist_count", "Front Netlists")
    aggregate_panel(axes[2], rows, x, "valid_family_ratio", "Valid Family Ratio")
    for axis in axes:
        axis.set_xticks(x)
        axis.set_xticklabels(labels, rotation=24, ha="right")
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.8)
    fig.suptitle("T29 Family Audit Metrics", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_problem_bars(
    rows: list[dict[str, str]],
    output_path: Path,
    title: str,
    metrics: tuple[str, str, str],
    metric_titles: tuple[str, str, str],
) -> None:
    methods = [method["label"] for method in METHODS]
    by_key = {(row["method_label"], row["problem"]): row for row in rows}
    x_positions = list(range(len(PROBLEMS)))
    width = 0.84 / len(methods)
    fig, axes = plt.subplots(1, 3, figsize=(17.8, 5.0))
    for axis, metric, metric_title in zip(axes, metrics, metric_titles, strict=True):
        for method_index, method in enumerate(methods):
            offset = (method_index - (len(methods) - 1) / 2) * width
            values = [parse_optional(by_key[(method, problem)][metric]) or 0.0 for problem in PROBLEMS]
            axis.bar(
                [position + offset for position in x_positions],
                values,
                width,
                label=method,
                color=color_for_label(method),
                alpha=0.82,
            )
        axis.set_title(metric_title)
        axis.set_xticks(x_positions)
        axis.set_xticklabels([problem.replace("Prob", "P") for problem in PROBLEMS], rotation=25, ha="right")
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.8)
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="lower center", bbox_to_anchor=(0.5, -0.02), ncol=4, frameon=False)
    fig.suptitle(title, y=1.02)
    fig.tight_layout(rect=(0, 0.10, 1, 0.94))
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_ppa_fronts(
    candidates: list[FamilyCandidate],
    output_path: Path,
    *,
    use_improvements: bool,
) -> None:
    fig, axes = plt.subplots(1, len(PROBLEMS), figsize=(18.2, 5.6), sharey=False)
    for axis, problem in zip(axes, PROBLEMS, strict=True):
        subset = [candidate for candidate in candidates if candidate.problem == problem]
        for method in METHODS:
            points = [candidate for candidate in subset if candidate.method == method["method"]]
            xs = [plot_value(candidate, "area", use_improvements) for candidate in points]
            ys = [plot_value(candidate, "power", use_improvements) for candidate in points]
            front_flags = [candidate.is_front for candidate in points]
            axis.scatter(xs, ys, s=34, color=method["color"], alpha=0.36, edgecolors="none", label=method["label"])
            axis.scatter(
                [x for x, flag in zip(xs, front_flags, strict=True) if flag],
                [y for y, flag in zip(ys, front_flags, strict=True) if flag],
                s=86,
                facecolors="none",
                edgecolors=method["color"],
                linewidths=1.8,
            )
        axis.set_title(problem.replace("Prob", "P"))
        axis.grid(color="#e5e5e5", linewidth=0.8)
        if use_improvements:
            axis.set_xlabel("Area improvement g_A (higher is better)")
        else:
            axis.invert_xaxis()
            axis.invert_yaxis()
            axis.set_xlabel("Area (lower is better; axis inverted)")
        if problem == PROBLEMS[0]:
            axis.set_ylabel(
                "Power improvement g_P (higher is better)"
                if use_improvements
                else "Power (lower is better; axis inverted)"
            )
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(handles, labels, loc="upper center", bbox_to_anchor=(0.5, 0.93), ncol=4, frameon=False)
    title = "T29 PPA Fronts: Improvement Space" if use_improvements else "T29 PPA Fronts: Candidate-Zoomed Area-Power"
    fig.suptitle(title, y=0.995)
    fig.text(
        0.5,
        0.02,
        "Open circles mark each method's active-objective rank-1 PPA front. "
        "P015 also uses clock period as a third objective.",
        ha="center",
        fontsize=9,
        color="#444444",
    )
    fig.tight_layout(rect=(0, 0.08, 1, 0.86))
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def aggregate_panel(axis: Any, rows: list[dict[str, str]], x: list[int], metric: str, title: str) -> None:
    values = [parse_optional(row[metric]) or 0.0 for row in rows]
    colors = [color_for_label(row["method_label"]) for row in rows]
    axis.bar(x, values, color=colors, alpha=0.84)
    axis.set_title(title)


def plot_value(candidate: FamilyCandidate, metric: str, use_improvements: bool) -> float:
    if use_improvements:
        return candidate.improvements[metric]
    return candidate.ppa_metrics[metric]


def color_for_label(label: str) -> str:
    method = next(item for item in METHODS if item["label"] == label)
    return method["color"]


def mean_required(rows: list[dict[str, str]], key: str) -> float:
    values = [parse_optional(row[key]) for row in rows]
    parsed = [value for value in values if value is not None]
    assert parsed
    return sum(parsed) / len(parsed)


def mean_values(values: list[float]) -> float | None:
    if not values:
        return None
    return sum(values) / len(values)


def mean_optional(rows: list[dict[str, str]], key: str) -> float | None:
    values = [parse_optional(row[key]) for row in rows]
    return mean_values([value for value in values if value is not None])


def sum_optional(rows: list[dict[str, str]], key: str) -> float | None:
    values = [parse_optional(row[key]) for row in rows]
    parsed = [value for value in values if value is not None]
    if not parsed:
        return None
    return sum(parsed)


if __name__ == "__main__":
    raise SystemExit(main())
