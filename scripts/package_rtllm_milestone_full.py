#!/usr/bin/env python3
"""Package the 20260623 full RTLLM milestone comparison."""

from __future__ import annotations

import argparse
import csv
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
from revolution.qd.pareto_analysis import ProblemParetoMetrics, analyze_problem_pareto

METHODS = (
    {
        "method": "classic_revolution",
        "label": "Classic",
        "mode": "classic_revolution/seed_1001/openai_gpt-oss-120b",
        "color": "#4e79a7",
    },
    {
        "method": "sr_raw_conservative_exploit_qd",
        "label": "Exact T26 QD",
        "mode": "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#e15759",
    },
)

SCREEN_PROBLEMS = {
    "Prob045_alu",
    "Prob041_traffic_light",
    "Prob015_multi_pipe_8bit",
}

REPRESENTATIVE_PROBLEMS = (
    "Prob045_alu",
    "Prob041_traffic_light",
    "Prob015_multi_pipe_8bit",
    "Prob006_adder_pipe_64bit",
    "Prob013_multi_booth_8bit",
    "Prob043_RAM",
)

COLORS = {method["method"]: method["color"] for method in METHODS}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    problems = read_manifest(args.manifest)
    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    data_dir = args.output_dir / "data"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    data_dir.mkdir(parents=True, exist_ok=True)

    rows = [problem_row(args.run_root, method, problem) for method in METHODS for problem in problems]
    candidate_rows = ppa_candidate_rows(args.run_root, problems)
    aggregates = aggregate_rows(rows, problems)
    deltas = delta_rows(rows, aggregates, problems)
    gates = gate_rows(rows, problems)
    write_csv(table_dir / "full_problem_metrics.csv", rows)
    write_csv(table_dir / "full_aggregate_metrics.csv", aggregates)
    write_csv(table_dir / "full_comparison_deltas.csv", deltas)
    write_csv(table_dir / "full_validity_gates.csv", gates)
    write_csv(table_dir / "full_method_manifest.csv", manifest_rows(args.run_root))
    write_csv(data_dir / "full_ppa_candidates.csv", candidate_rows)
    write_figures(rows, candidate_rows, problems, figure_dir)
    write_report(args.output_dir / "README.md", args.run_root, rows, aggregates, deltas, gates)
    return 0


def read_manifest(path: Path) -> list[str]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    problems = [row["problem"] for row in rows]
    assert problems
    assert len(problems) == len(set(problems))
    return problems


def problem_row(run_root: Path, method: dict[str, str], problem: str) -> dict[str, str]:
    problem_root = run_root / method["mode"] / "RTLLM" / problem
    summary = load_json(problem_root / f"{problem}_summary.json")
    best_score = summary["final_population_ppa"].get("best_score")
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
        "is_screen_problem": str(problem in SCREEN_PROBLEMS),
        "total_generated": str(int(summary["total_candidates_generated"])),
        "syntax_count": str(success_count(summary, "syntax")),
        "functionality_count": str(success_count(summary, "functionality")),
        "valid_ppa_count": str(success_count(summary, "synthesis_ppa")),
        "syntax_rate": fmt(success_rate(summary, "syntax")),
        "functionality_rate": fmt(success_rate(summary, "functionality")),
        "valid_ppa_rate": fmt(success_rate(summary, "synthesis_ppa")),
        "best_score": fmt_optional(None if best_score is None else float(best_score)),
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


def ppa_candidate_rows(run_root: Path, problems: list[str]) -> list[dict[str, str]]:
    rows = []
    for method in METHODS:
        for problem in problems:
            problem_root = run_root / method["mode"] / "RTLLM" / problem
            pareto = analyze_problem_pareto(problem_root, benchmark="RTLLM", problem=problem)
            front_ids = {candidate.candidate_id for candidate in pareto.pareto_candidates}
            for candidate in pareto.candidates:
                rows.append(candidate_row(method, problem, candidate, pareto, front_ids))
    assert rows
    return rows


def candidate_row(
    method: dict[str, str],
    problem: str,
    candidate: Any,
    pareto: ProblemParetoMetrics,
    front_ids: set[str],
) -> dict[str, str]:
    return {
        "method": method["method"],
        "method_label": method["label"],
        "problem": problem,
        "candidate_id": candidate.candidate_id,
        "generation": "" if candidate.generation is None else str(candidate.generation),
        "is_pareto_front": str(candidate.candidate_id in front_ids),
        "area": fmt_optional(candidate.ppa_metrics.get("area")),
        "power": fmt_optional(candidate.ppa_metrics.get("power")),
        "eff_clk_period": fmt_optional(candidate.ppa_metrics.get("eff_clk_period")),
        "area_improvement": fmt_optional(candidate.improvements.get("area")),
        "power_improvement": fmt_optional(candidate.improvements.get("power")),
        "eff_clk_period_improvement": fmt_optional(
            candidate.improvements.get("eff_clk_period")
        ),
        "objective_metrics": "|".join(pareto.objective_metrics),
    }


def aggregate_rows(rows: list[dict[str, str]], problems: list[str]) -> list[dict[str, str]]:
    cohorts = (
        ("all_rtllm", set(problems)),
        ("screen", SCREEN_PROBLEMS & set(problems)),
        ("screen_excluded", set(problems) - SCREEN_PROBLEMS),
    )
    output = []
    for cohort, cohort_problems in cohorts:
        assert cohort_problems
        for method in METHODS:
            method_rows = [
                row
                for row in rows
                if row["method"] == method["method"] and row["problem"] in cohort_problems
            ]
            output.append(aggregate_row(method, cohort, method_rows))
    return output


def aggregate_row(method: dict[str, str], cohort: str, rows: list[dict[str, str]]) -> dict[str, str]:
    assert rows
    return {
        "cohort": cohort,
        "method": method["method"],
        "method_label": method["label"],
        "problem_count": str(len(rows)),
        "total_generated": str(sum(int(row["total_generated"]) for row in rows)),
        "syntax_count": str(sum(int(row["syntax_count"]) for row in rows)),
        "functionality_count": str(sum(int(row["functionality_count"]) for row in rows)),
        "valid_ppa_count": str(sum(int(row["valid_ppa_count"]) for row in rows)),
        "mean_functionality_rate": fmt(mean_float(rows, "functionality_rate")),
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
        "mean_active_archive_coverage": fmt_optional(
            mean_optional(rows, "active_archive_coverage")
        ),
        "mean_active_archive_qd_score": fmt_optional(
            mean_optional(rows, "active_archive_qd_score")
        ),
        "total_active_archive_members": fmt_optional(
            sum_optional(rows, "active_archive_members")
        ),
        "total_active_global_pareto_members": fmt_optional(
            sum_optional(rows, "active_global_pareto_members")
        ),
        "mean_active_qd_score_auc": fmt_optional(mean_optional(rows, "active_qd_score_auc")),
        "mean_active_coverage_auc": fmt_optional(mean_optional(rows, "active_coverage_auc")),
    }


def delta_rows(
    rows: list[dict[str, str]],
    aggregates: list[dict[str, str]],
    problems: list[str],
) -> list[dict[str, str]]:
    by_key = {(row["method"], row["problem"]): row for row in rows}
    by_aggregate = {(row["cohort"], row["method"]): row for row in aggregates}
    output = []
    metrics = (
        "global_ppa_hypervolume",
        "hv_auc",
        "best_score",
        "valid_ppa_count",
        "ppa_front_points",
        "unique_ppa_points",
    )
    for problem in problems:
        for metric in metrics:
            output.append(
                comparison_row(
                    "problem",
                    problem,
                    metric,
                    by_key[("sr_raw_conservative_exploit_qd", problem)],
                    by_key[("classic_revolution", problem)],
                )
            )
    for cohort in ("all_rtllm", "screen", "screen_excluded"):
        for metric in (
            "mean_global_ppa_hypervolume",
            "mean_hv_auc",
            "mean_best_score",
            "valid_ppa_count",
            "total_ppa_front_points",
            "total_unique_ppa_points",
        ):
            output.append(
                comparison_row(
                    "aggregate",
                    cohort,
                    metric,
                    by_aggregate[(cohort, "sr_raw_conservative_exploit_qd")],
                    by_aggregate[(cohort, "classic_revolution")],
                )
            )
    return output


def comparison_row(
    scope: str,
    name: str,
    metric: str,
    value_row: dict[str, str],
    reference_row: dict[str, str],
) -> dict[str, str]:
    value = parse_optional(value_row[metric])
    reference = parse_optional(reference_row[metric])
    delta = None if value is None or reference is None else value - reference
    return {
        "scope": scope,
        "name": name,
        "method": "sr_raw_conservative_exploit_qd",
        "reference": "classic_revolution",
        "metric": metric,
        "value": fmt_optional(value),
        "reference_value": fmt_optional(reference),
        "delta": fmt_optional(delta),
        "relative_delta": fmt_optional(relative_delta(value, reference)),
    }


def gate_rows(rows: list[dict[str, str]], problems: list[str]) -> list[dict[str, str]]:
    by_key = {(row["method"], row["problem"]): row for row in rows}
    output = []
    for problem in problems:
        classic = by_key[("classic_revolution", problem)]
        qd = by_key[("sr_raw_conservative_exploit_qd", problem)]
        for metric in ("functionality_count", "valid_ppa_count"):
            output.append(gate_row(problem, metric, qd, classic))
    return output


def gate_row(
    problem: str,
    metric: str,
    value_row: dict[str, str],
    reference_row: dict[str, str],
) -> dict[str, str]:
    value = int(value_row[metric])
    reference = int(reference_row[metric])
    status = "pass"
    if metric == "valid_ppa_count" and reference > 0 and value == 0:
        status = "classic_covered_loss"
    elif reference >= 10 and value * 2 <= reference:
        status = "yield_warning"
    elif 0 < reference < 10:
        status = "small_n"
    return {
        "problem": problem,
        "metric": metric,
        "method": "sr_raw_conservative_exploit_qd",
        "reference": "classic_revolution",
        "value": str(value),
        "reference_value": str(reference),
        "delta": str(value - reference),
        "relative_delta": fmt_optional(relative_delta(float(value), float(reference))),
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


def write_figures(
    rows: list[dict[str, str]],
    candidates: list[dict[str, str]],
    problems: list[str],
    figure_dir: Path,
) -> None:
    plot_delta_distribution(rows, "global_ppa_hypervolume", "PPA HV Delta", figure_dir / "full_hv_delta_distribution.png")
    plot_delta_distribution(rows, "hv_auc", "HV-AUC Delta", figure_dir / "full_hv_auc_delta_distribution.png")
    plot_hv_scatter(rows, figure_dir / "full_hv_scatter.png")
    plot_metric_heatmap(rows, problems, figure_dir / "full_win_loss_heatmap.png")
    plot_validity_funnel(rows, figure_dir / "full_validity_funnel.png")
    plot_front_counts(rows, problems, figure_dir / "full_front_counts.png")
    plot_ppa_representatives(candidates, problems, figure_dir / "full_representative_ppa_fronts.png")


def plot_delta_distribution(
    rows: list[dict[str, str]],
    metric: str,
    title: str,
    output_path: Path,
) -> None:
    deltas = paired_values(rows, metric)
    wins = sum(1 for value in deltas if value > 0.0)
    losses = sum(1 for value in deltas if value < 0.0)
    fig, axis = plt.subplots(figsize=(7.2, 4.4))
    axis.hist(deltas, bins=18, color="#6b8fb3", edgecolor="white", alpha=0.9)
    axis.axvline(0.0, color="#222222", linewidth=1.1)
    axis.axvline(sum(deltas) / len(deltas), color="#e15759", linewidth=1.6, linestyle="--")
    axis.set_title(f"{title} Across RTLLM Problems")
    axis.set_xlabel("Exact T26 QD minus Classic")
    axis.set_ylabel("Problem count")
    axis.text(
        0.98,
        0.95,
        f"wins {wins} / losses {losses}",
        ha="right",
        va="top",
        transform=axis.transAxes,
        fontsize=9,
    )
    axis.grid(axis="y", color="#e6e6e6", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_hv_scatter(rows: list[dict[str, str]], output_path: Path) -> None:
    by_key = {(row["method"], row["problem"]): row for row in rows}
    problems = sorted({row["problem"] for row in rows})
    classic = [float(by_key[("classic_revolution", problem)]["global_ppa_hypervolume"]) for problem in problems]
    qd = [
        float(by_key[("sr_raw_conservative_exploit_qd", problem)]["global_ppa_hypervolume"])
        for problem in problems
    ]
    limit = max(classic + qd + [0.01])
    fig, axis = plt.subplots(figsize=(6.2, 6.0))
    axis.scatter(classic, qd, color="#e15759", alpha=0.82, edgecolor="white", linewidth=0.5)
    axis.plot([0.0, limit], [0.0, limit], color="#222222", linewidth=1.0)
    axis.set_title("Per-Problem PPA HV: Classic vs Exact T26")
    axis.set_xlabel("Classic HV")
    axis.set_ylabel("Exact T26 QD HV")
    axis.grid(color="#e6e6e6", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_metric_heatmap(rows: list[dict[str, str]], problems: list[str], output_path: Path) -> None:
    metrics = (
        ("global_ppa_hypervolume", "HV"),
        ("hv_auc", "HV-AUC"),
        ("best_score", "Best"),
        ("valid_ppa_count", "Valid PPA"),
        ("ppa_front_points", "Front"),
    )
    values = [[relative_paired_delta(rows, problem, metric) for problem in problems] for metric, _ in metrics]
    fig, axis = plt.subplots(figsize=(max(12.0, len(problems) * 0.24), 3.8))
    image = axis.imshow(values, aspect="auto", cmap="RdBu", vmin=-1.0, vmax=1.0)
    axis.set_yticks(range(len(metrics)))
    axis.set_yticklabels([label for _, label in metrics])
    axis.set_xticks(range(len(problems)))
    axis.set_xticklabels(short_problem_labels(problems), rotation=90, fontsize=7)
    axis.set_title("Exact T26 Relative Delta By Problem")
    fig.colorbar(image, ax=axis, fraction=0.025, pad=0.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_validity_funnel(rows: list[dict[str, str]], output_path: Path) -> None:
    stages = ("total_generated", "syntax_count", "functionality_count", "valid_ppa_count")
    labels = ("Generated", "Syntax", "Functional", "Valid PPA")
    fig, axis = plt.subplots(figsize=(7.4, 4.6))
    x = list(range(len(stages)))
    width = 0.34
    for index, method in enumerate(METHODS):
        method_rows = [row for row in rows if row["method"] == method["method"]]
        values = [sum(int(row[stage]) for row in method_rows) for stage in stages]
        offset = (index - 0.5) * width
        axis.bar([position + offset for position in x], values, width, label=method["label"], color=method["color"], alpha=0.86)
    axis.set_xticks(x)
    axis.set_xticklabels(labels)
    axis.set_title("RTLLM Validity Funnel")
    axis.set_ylabel("Candidates")
    axis.legend(frameon=False)
    axis.grid(axis="y", color="#e6e6e6", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_front_counts(rows: list[dict[str, str]], problems: list[str], output_path: Path) -> None:
    by_key = {(row["method"], row["problem"]): row for row in rows}
    x = list(range(len(problems)))
    fig, axis = plt.subplots(figsize=(max(12.0, len(problems) * 0.24), 4.6))
    for index, method in enumerate(METHODS):
        offset = (index - 0.5) * 0.36
        values = [int(by_key[(method["method"], problem)]["ppa_front_points"]) for problem in problems]
        axis.bar([position + offset for position in x], values, 0.34, label=method["label"], color=method["color"], alpha=0.86)
    axis.set_xticks(x)
    axis.set_xticklabels(short_problem_labels(problems), rotation=90, fontsize=7)
    axis.set_title("PPA-Front Points By RTLLM Problem")
    axis.set_ylabel("Unique nondominated PPA points")
    axis.legend(frameon=False)
    axis.grid(axis="y", color="#e6e6e6", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_ppa_representatives(
    candidates: list[dict[str, str]],
    problems: list[str],
    output_path: Path,
) -> None:
    chosen = [problem for problem in REPRESENTATIVE_PROBLEMS if problem in problems]
    assert chosen
    fig, axes = plt.subplots(2, math.ceil(len(chosen) / 2), figsize=(15.0, 7.4))
    flat_axes = axes.flatten() if hasattr(axes, "flatten") else [axes]
    for axis, problem in zip(flat_axes, chosen, strict=False):
        plot_problem_ppa(axis, candidates, problem)
    for axis in flat_axes[len(chosen):]:
        axis.axis("off")
    fig.suptitle("Representative Raw Area-Power Fronts", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_problem_ppa(axis: Any, candidates: list[dict[str, str]], problem: str) -> None:
    axis.set_title(problem.replace("Prob", "P"))
    for method in METHODS:
        rows = [
            row
            for row in candidates
            if row["method"] == method["method"] and row["problem"] == problem and row["area"] and row["power"]
        ]
        if not rows:
            continue
        axis.scatter(
            [float(row["area"]) for row in rows],
            [float(row["power"]) for row in rows],
            s=18,
            color=method["color"],
            alpha=0.35,
            label=method["label"],
        )
        front = [row for row in rows if row["is_pareto_front"] == "True"]
        axis.scatter(
            [float(row["area"]) for row in front],
            [float(row["power"]) for row in front],
            s=46,
            color=method["color"],
            edgecolor="#202020",
            linewidth=0.5,
            alpha=0.95,
        )
    axis.set_xlabel("Area")
    axis.set_ylabel("Power")
    axis.grid(color="#e6e6e6", linewidth=0.8)
    axis.legend(frameon=False, fontsize=7)


def write_report(
    path: Path,
    run_root: Path,
    rows: list[dict[str, str]],
    aggregates: list[dict[str, str]],
    deltas: list[dict[str, str]],
    gates: list[dict[str, str]],
) -> None:
    aggregate = {
        (row["cohort"], row["method"]): row
        for row in aggregates
        if row["cohort"] in {"all_rtllm", "screen_excluded"}
    }
    all_delta = aggregate_delta(deltas, "all_rtllm", "mean_global_ppa_hypervolume")
    auc_delta = aggregate_delta(deltas, "all_rtllm", "mean_hv_auc")
    hard_failures = [row for row in gates if row["gate_status"] == "classic_covered_loss"]
    yield_warnings = [row for row in gates if row["gate_status"] == "yield_warning"]
    small_n = [row for row in gates if row["gate_status"] == "small_n"]
    lines = [
        "# Full RTLLM Milestone Package",
        "",
        f"Run root: `{run_root}`",
        "",
        "## Headline",
        "",
        f"- Claim status: `{claim_status(gates)}`.",
        f"- Mean HV delta, all RTLLM: `{all_delta}`.",
        f"- Mean HV-AUC delta, all RTLLM: `{auc_delta}`.",
        f"- Hard retention failures: `{len(hard_failures)}` rows.",
        f"- Yield warnings: `{len(yield_warnings)}` rows.",
        f"- Small-n validity labels: `{len(small_n)}` rows.",
        "",
        "## Aggregate Metrics",
        "",
        "| Cohort | Method | Problems | Mean HV | Mean HV-AUC | Valid PPA | Front Points |",
        "| --- | --- | ---: | ---: | ---: | ---: | ---: |",
    ]
    for key in sorted(aggregate):
        row = aggregate[key]
        lines.append(
            f"| {row['cohort']} | {row['method_label']} | {row['problem_count']} | "
            f"{row['mean_global_ppa_hypervolume']} | {row['mean_hv_auc']} | "
            f"{row['valid_ppa_count']} | {row['total_ppa_front_points']} |"
        )
    lines.extend(
        [
            "",
            "## Retention Gate",
            "",
            "| Problem | Metric | Classic | Exact T26 QD | Status |",
            "| --- | --- | ---: | ---: | --- |",
        ]
    )
    for row in gates:
        lines.append(
            f"| {row['problem']} | {row['metric']} | {row['reference_value']} | "
            f"{row['value']} | {row['gate_status']} |"
        )
    lines.extend(
        [
            "",
            "## Files",
            "",
            "- `tables/full_problem_metrics.csv`",
            "- `tables/full_aggregate_metrics.csv`",
            "- `tables/full_comparison_deltas.csv`",
            "- `tables/full_validity_gates.csv`",
            "- `data/full_ppa_candidates.csv`",
            "- `figures/full_hv_delta_distribution.png`",
            "- `figures/full_hv_auc_delta_distribution.png`",
            "- `figures/full_hv_scatter.png`",
            "- `figures/full_win_loss_heatmap.png`",
            "- `figures/full_validity_funnel.png`",
            "- `figures/full_front_counts.png`",
            "- `figures/full_representative_ppa_fronts.png`",
            "",
            "## Claim Discipline",
            "",
            "This is one-seed paired engineering evidence. A QD claim must preserve",
            "classic-covered designs and report yield warnings instead of hiding",
            "them. Multi-seed replication remains a follow-on milestone.",
        ]
    )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def claim_status(gates: list[dict[str, str]]) -> str:
    if any(row["gate_status"] == "classic_covered_loss" for row in gates):
        return "blocked"
    return "reviewable"


def paired_values(rows: list[dict[str, str]], metric: str) -> list[float]:
    by_key = {(row["method"], row["problem"]): row for row in rows}
    problems = sorted({row["problem"] for row in rows})
    values = []
    for problem in problems:
        qd = float(by_key[("sr_raw_conservative_exploit_qd", problem)][metric])
        classic = float(by_key[("classic_revolution", problem)][metric])
        values.append(qd - classic)
    return values


def relative_paired_delta(rows: list[dict[str, str]], problem: str, metric: str) -> float:
    by_key = {(row["method"], row["problem"]): row for row in rows}
    qd = parse_optional(by_key[("sr_raw_conservative_exploit_qd", problem)][metric])
    classic = parse_optional(by_key[("classic_revolution", problem)][metric])
    delta = relative_delta(qd, classic)
    if delta is None:
        return 0.0
    return max(-1.0, min(1.0, delta))


def aggregate_delta(deltas: list[dict[str, str]], cohort: str, metric: str) -> str:
    for row in deltas:
        if row["scope"] == "aggregate" and row["name"] == cohort and row["metric"] == metric:
            return row["delta"]
    raise AssertionError(f"Missing aggregate delta for {cohort} {metric}")


def short_problem_labels(problems: list[str]) -> list[str]:
    return [problem.replace("Prob", "P").replace("_", "\n", 1) for problem in problems]


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
