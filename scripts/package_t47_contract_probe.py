#!/usr/bin/env python3
"""Package the T47 two-seed hard/tuning contract probe."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path
import sys
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.ticker import PercentFormatter

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from revolution.qd.pareto_analysis import ProblemParetoMetrics, analyze_problem_pareto
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
    mean_optional,
    parse_optional,
    relative_delta,
    required_auc,
    success_count,
    success_rate,
    unique_improvement_points,
    write_csv,
)

MODEL_DIR = "openai_gpt-oss-120b"
PHASE = "hard_tuning_sanity"
METHODS = (
    {
        "method": "classic_revolution",
        "label": "Classic",
        "color": "#4e79a7",
    },
    {
        "method": "sr_raw_conservative_exploit_qd",
        "label": "Exact T26 QD",
        "color": "#e15759",
    },
)
COMPARISON_METRICS = (
    "global_ppa_hypervolume",
    "hv_auc",
    "best_score",
    "valid_ppa_count",
    "ppa_front_points",
    "unique_ppa_points",
    "reference_beating_count",
)
AGGREGATE_COMPARISON_METRICS = (
    "mean_global_ppa_hypervolume",
    "mean_hv_auc",
    "mean_best_score",
    "valid_ppa_count",
    "total_ppa_front_points",
    "total_unique_ppa_points",
    "total_reference_beating_count",
)
LABEL_OVERRIDES = {
    "Prob004_adder_8bit": "R004 adder8",
    "Prob015_multi_pipe_8bit": "R015 pipe8",
    "Prob024_fsm": "R024 fsm",
    "Prob037_parallel2serial": "R037 p2s",
    "Prob041_traffic_light": "R041 traffic",
    "Prob045_alu": "R045 alu",
    "Prob049_signal_generator": "R049 signal",
    "Prob098_circuit7": "V098 circuit7",
    "Prob116_m2014_q3": "V116 q3",
    "Prob135_m2014_q6b": "V135 q6b",
    "Prob150_review2015_fsmonehot": "V150 onehot",
    "Prob151_review2015_fsm": "V151 fsm",
    "Prob153_gshare": "V153 gshare",
}


Task = tuple[int, str, str, str]


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--matrix", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    data_dir = args.output_dir / "data"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    data_dir.mkdir(parents=True, exist_ok=True)

    tasks = read_tasks(args.matrix)
    problem_rows = [problem_seed_row(args.run_root, task) for task in tasks]
    aggregate = aggregate_rows(problem_rows)
    deltas = comparison_rows(problem_rows, aggregate)
    gates = gate_rows(problem_rows)
    candidates = ppa_candidate_rows(args.run_root, tasks)

    write_csv(table_dir / "t47_problem_seed_metrics.csv", problem_rows)
    write_csv(table_dir / "t47_aggregate_metrics.csv", aggregate)
    write_csv(table_dir / "t47_comparison_deltas.csv", deltas)
    write_csv(table_dir / "t47_validity_gates.csv", gates)
    write_csv(data_dir / "t47_ppa_candidates.csv", candidates)
    write_figures(problem_rows, figure_dir)
    write_report(args.output_dir / "README.md", args.run_root, aggregate, deltas, gates)
    write_visual_notes(figure_dir / "visual_inspection_notes.md")
    return 0


def read_tasks(matrix_path: Path) -> list[Task]:
    with matrix_path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    tasks = {
        (
            int(row["seed"]),
            row["arm"],
            row["benchmark"],
            row["problem"],
        )
        for row in rows
        if row["phase"] == PHASE
    }
    assert tasks
    for row in rows:
        if row["phase"] != PHASE:
            continue
        assert row["reference_status"] == "reference_available"
        assert row["headline_eligible"] == "true"
    return sorted(tasks)


def problem_seed_row(run_root: Path, task: Task) -> dict[str, str]:
    seed, method, benchmark, problem = task
    problem_root = run_root / method / f"seed_{seed}" / MODEL_DIR / benchmark / problem
    summary = load_json(problem_root / f"{problem}_summary.json")
    pareto = analyze_problem_pareto(problem_root, benchmark=benchmark, problem=problem)
    archive = load_optional_json(problem_root / "archive_summary.json")
    global_pareto = load_optional_json(problem_root / "global_pareto_summary.json")
    history = load_jsonl(problem_root / "archive_history.jsonl")
    spread = front_spread(pareto)
    unique_points = unique_improvement_points(pareto.candidates, pareto.objective_metrics)
    best_score = summary["final_population_ppa"].get("best_score")
    qd_scores = [float(row.get("qd_score") or 0.0) for row in history]
    coverages = [float(row.get("coverage") or 0.0) for row in history]
    return {
        "seed": str(seed),
        "method": method,
        "method_label": method_label(method),
        "benchmark": benchmark,
        "problem": problem,
        "total_generated": str(int(summary["total_candidates_generated"])),
        "syntax_count": str(success_count(summary, "syntax")),
        "functionality_count": str(success_count(summary, "functionality")),
        "valid_ppa_count": str(success_count(summary, "synthesis_ppa")),
        "syntax_rate": fmt(success_rate(summary, "syntax")),
        "functionality_rate": fmt(success_rate(summary, "functionality")),
        "valid_ppa_rate": fmt(success_rate(summary, "synthesis_ppa")),
        "best_score": fmt_optional(None if best_score is None else float(best_score)),
        "global_ppa_hypervolume": fmt(pareto.hypervolume),
        "hv_auc": fmt(required_auc(hypervolume_curve(pareto))),
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
        "active_qd_score_auc": fmt_optional(auc(qd_scores)),
        "active_coverage_auc": fmt_optional(auc(coverages)),
    }


def ppa_candidate_rows(run_root: Path, tasks: list[Task]) -> list[dict[str, str]]:
    rows = []
    for seed, method, benchmark, problem in tasks:
        problem_root = run_root / method / f"seed_{seed}" / MODEL_DIR / benchmark / problem
        pareto = analyze_problem_pareto(problem_root, benchmark=benchmark, problem=problem)
        front_ids = {candidate.candidate_id for candidate in pareto.pareto_candidates}
        for candidate in pareto.candidates:
            rows.append(candidate_row(seed, method, benchmark, problem, candidate, pareto, front_ids))
    assert rows
    return rows


def candidate_row(
    seed: int,
    method: str,
    benchmark: str,
    problem: str,
    candidate: Any,
    pareto: ProblemParetoMetrics,
    front_ids: set[str],
) -> dict[str, str]:
    return {
        "seed": str(seed),
        "method": method,
        "method_label": method_label(method),
        "benchmark": benchmark,
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


def aggregate_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    output = []
    seeds = sorted({row["seed"] for row in rows})
    cohorts = {"all": rows}
    for benchmark in sorted({row["benchmark"] for row in rows}):
        cohorts[benchmark] = [row for row in rows if row["benchmark"] == benchmark]
    for seed_group in ["all", *seeds]:
        for cohort, cohort_rows in cohorts.items():
            seed_rows = [
                row for row in cohort_rows if seed_group == "all" or row["seed"] == seed_group
            ]
            for method in method_names():
                method_rows = [row for row in seed_rows if row["method"] == method]
                output.append(aggregate_row(seed_group, cohort, method_rows))
    return output


def aggregate_row(seed_group: str, cohort: str, rows: list[dict[str, str]]) -> dict[str, str]:
    assert rows
    return {
        "seed_group": seed_group,
        "cohort": cohort,
        "method": rows[0]["method"],
        "method_label": rows[0]["method_label"],
        "row_count": str(len(rows)),
        "unique_problem_count": str(len({(row["benchmark"], row["problem"]) for row in rows})),
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
        "mean_front_nn_distance": fmt(mean_float(rows, "front_nn_distance")),
        "mean_front_bbox_volume": fmt(mean_float(rows, "front_bbox_volume")),
        "mean_active_archive_coverage": fmt_optional(
            mean_optional(rows, "active_archive_coverage")
        ),
        "mean_active_archive_qd_score": fmt_optional(
            mean_optional(rows, "active_archive_qd_score")
        ),
        "total_active_archive_members": fmt_optional(sum_optional(rows, "active_archive_members")),
        "total_active_global_pareto_members": fmt_optional(
            sum_optional(rows, "active_global_pareto_members")
        ),
        "mean_active_qd_score_auc": fmt_optional(mean_optional(rows, "active_qd_score_auc")),
        "mean_active_coverage_auc": fmt_optional(mean_optional(rows, "active_coverage_auc")),
    }


def comparison_rows(
    problem_rows: list[dict[str, str]],
    aggregate: list[dict[str, str]],
) -> list[dict[str, str]]:
    output = []
    problem_index = {
        (row["seed"], row["benchmark"], row["problem"], row["method"]): row
        for row in problem_rows
    }
    problem_keys = sorted({key[:-1] for key in problem_index})
    for seed, benchmark, problem in problem_keys:
        name = f"{seed}:{benchmark}:{problem}"
        qd = problem_index[(seed, benchmark, problem, "sr_raw_conservative_exploit_qd")]
        classic = problem_index[(seed, benchmark, problem, "classic_revolution")]
        for metric in COMPARISON_METRICS:
            output.append(comparison_row("problem_seed", name, metric, qd, classic))

    aggregate_index = {
        (row["seed_group"], row["cohort"], row["method"]): row
        for row in aggregate
    }
    aggregate_keys = sorted({key[:-1] for key in aggregate_index})
    for seed_group, cohort in aggregate_keys:
        name = f"{seed_group}:{cohort}"
        qd = aggregate_index[(seed_group, cohort, "sr_raw_conservative_exploit_qd")]
        classic = aggregate_index[(seed_group, cohort, "classic_revolution")]
        for metric in AGGREGATE_COMPARISON_METRICS:
            output.append(comparison_row("aggregate", name, metric, qd, classic))
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


def gate_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    index = {
        (row["seed"], row["benchmark"], row["problem"], row["method"]): row
        for row in rows
    }
    output = []
    for seed, benchmark, problem in sorted({key[:-1] for key in index}):
        qd = index[(seed, benchmark, problem, "sr_raw_conservative_exploit_qd")]
        classic = index[(seed, benchmark, problem, "classic_revolution")]
        for metric in ("functionality_count", "valid_ppa_count"):
            output.append(gate_row(seed, benchmark, problem, metric, qd, classic))
    return output


def gate_row(
    seed: str,
    benchmark: str,
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
    elif metric == "functionality_count" and reference > 0 and value == 0:
        status = "functionality_loss"
    elif reference >= 10 and value * 2 <= reference:
        status = "yield_warning"
    elif 0 < reference < 10:
        status = "small_n"
    return {
        "seed": seed,
        "benchmark": benchmark,
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


def write_figures(rows: list[dict[str, str]], figure_dir: Path) -> None:
    plot_hv_delta_heatmap(rows, figure_dir / "t47_hv_delta_heatmap.png")
    plot_metric_delta_summary(rows, figure_dir / "t47_metric_delta_summary.png")
    plot_validity_funnel(rows, figure_dir / "t47_validity_funnel.png")
    plot_front_counts(rows, figure_dir / "t47_front_counts.png")


def plot_hv_delta_heatmap(rows: list[dict[str, str]], output_path: Path) -> None:
    values, labels, seeds = heatmap_values(rows, "global_ppa_hypervolume")
    fig, axis = plt.subplots(figsize=(max(10.0, len(labels) * 0.55), 3.4))
    image = axis.imshow(values, aspect="auto", cmap="RdBu", vmin=-1.0, vmax=1.0)
    axis.set_title("T47 Relative HV Delta: Exact T26 QD vs Classic")
    axis.set_yticks(range(len(seeds)))
    axis.set_yticklabels(seeds)
    axis.set_xticks(range(len(labels)))
    axis.set_xticklabels(labels, rotation=50, ha="right", fontsize=8)
    fig.colorbar(image, ax=axis, fraction=0.025, pad=0.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_metric_delta_summary(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = ("HV", "HV-AUC", "Best", "Valid PPA", "Front")
    metrics = (
        "global_ppa_hypervolume",
        "hv_auc",
        "best_score",
        "valid_ppa_count",
        "ppa_front_points",
    )
    values = [mean_relative_delta(rows, metric) for metric in metrics]
    colors = ["#e15759" if value >= 0.0 else "#4e79a7" for value in values]
    fig, axis = plt.subplots(figsize=(7.2, 4.4))
    axis.axhline(0.0, color="#222222", linewidth=1.0)
    axis.bar(labels, values, color=colors, alpha=0.86)
    for index, value in enumerate(values):
        va = "bottom" if value >= 0.0 else "top"
        offset = 0.015 if value >= 0.0 else -0.015
        axis.text(index, value + offset, f"{value:+.0%}", ha="center", va=va, fontsize=9)
    axis.set_title("T47 Mean Relative Paired Delta")
    axis.set_ylabel("Exact T26 QD vs Classic")
    axis.yaxis.set_major_formatter(PercentFormatter(1.0))
    axis.grid(axis="y", color="#e6e6e6", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_validity_funnel(rows: list[dict[str, str]], output_path: Path) -> None:
    stages = ("total_generated", "syntax_count", "functionality_count", "valid_ppa_count")
    labels = ("Generated", "Syntax", "Functional", "Valid PPA")
    x = list(range(len(stages)))
    fig, axis = plt.subplots(figsize=(7.6, 4.6))
    for index, method in enumerate(METHODS):
        method_rows = [row for row in rows if row["method"] == method["method"]]
        values = [sum(int(row[stage]) for row in method_rows) for stage in stages]
        offset = (index - 0.5) * 0.36
        axis.bar(
            [position + offset for position in x],
            values,
            0.34,
            label=method["label"],
            color=method["color"],
            alpha=0.86,
        )
    axis.set_xticks(x)
    axis.set_xticklabels(labels)
    axis.set_title("T47 Validity Funnel")
    axis.set_ylabel("Candidates across two seeds")
    axis.legend(frameon=False)
    axis.grid(axis="y", color="#e6e6e6", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_front_counts(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = problem_labels(rows)
    x = list(range(len(labels)))
    fig, axis = plt.subplots(figsize=(max(10.5, len(labels) * 0.55), 4.6))
    for index, method in enumerate(METHODS):
        values = [
            mean_problem_value(rows, label, method["method"], "ppa_front_points")
            for label in labels
        ]
        offset = (index - 0.5) * 0.36
        axis.bar(
            [position + offset for position in x],
            values,
            0.34,
            label=method["label"],
            color=method["color"],
            alpha=0.86,
        )
    axis.set_xticks(x)
    axis.set_xticklabels(labels, rotation=50, ha="right", fontsize=8)
    axis.set_title("T47 Mean PPA-Front Points By Problem")
    axis.set_ylabel("Mean front points across seeds")
    axis.legend(frameon=False)
    axis.grid(axis="y", color="#e6e6e6", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def write_report(
    path: Path,
    run_root: Path,
    aggregate: list[dict[str, str]],
    deltas: list[dict[str, str]],
    gates: list[dict[str, str]],
) -> None:
    aggregate_index = {
        (row["seed_group"], row["cohort"], row["method"]): row
        for row in aggregate
    }
    all_classic = aggregate_index[("all", "all", "classic_revolution")]
    all_qd = aggregate_index[("all", "all", "sr_raw_conservative_exploit_qd")]
    hard_losses = [row for row in gates if row["gate_status"] == "classic_covered_loss"]
    yield_warnings = [row for row in gates if row["gate_status"] == "yield_warning"]
    small_n = [row for row in gates if row["gate_status"] == "small_n"]
    lines = [
        "# T47 Contract Probe Package",
        "",
        f"Run root: `{run_root}`",
        "",
        "## Headline",
        "",
        f"- Claim status: `{claim_status(gates)}`.",
        f"- Mean HV delta: `{aggregate_delta(deltas, 'all:all', 'mean_global_ppa_hypervolume')}`.",
        f"- Mean HV-AUC delta: `{aggregate_delta(deltas, 'all:all', 'mean_hv_auc')}`.",
        f"- Mean best-score delta: `{aggregate_delta(deltas, 'all:all', 'mean_best_score')}`.",
        f"- Classic-covered valid-PPA losses: `{len(hard_losses)}`.",
        f"- Yield warnings: `{len(yield_warnings)}`.",
        f"- Small-n labels: `{len(small_n)}`.",
        "",
        "## Aggregate Metrics",
        "",
        "| Method | Rows | Problems | Mean HV | Mean HV-AUC | Mean Best | Valid PPA | Front Points |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
        aggregate_line(all_classic),
        aggregate_line(all_qd),
        "",
        "## Files",
        "",
        "- `tables/t47_problem_seed_metrics.csv`",
        "- `tables/t47_aggregate_metrics.csv`",
        "- `tables/t47_comparison_deltas.csv`",
        "- `tables/t47_validity_gates.csv`",
        "- `data/t47_ppa_candidates.csv`",
        "- `figures/t47_hv_delta_heatmap.png`",
        "- `figures/t47_metric_delta_summary.png`",
        "- `figures/t47_validity_funnel.png`",
        "- `figures/t47_front_counts.png`",
        "",
        "## Discipline",
        "",
        "This is a hard/tuning screen, not a held-out claim. Use it to decide",
        "whether exact T26 deserves a held-out launch or whether a narrow T26.1",
        "variant is needed. Do not assign T1 or higher from this package alone.",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_visual_notes(path: Path) -> None:
    path.write_text(
        "\n".join(
            [
                "# T47 Visual Inspection Notes",
                "",
                "Status: generated; manual screenshot inspection pending.",
                "",
                "- `t47_hv_delta_heatmap.png` should make seed/problem HV wins and",
                "  losses readable at a glance.",
                "- `t47_metric_delta_summary.png` should show whether the aggregate",
                "  signal is carried by HV, best score, validity, or front count.",
                "- `t47_validity_funnel.png` should expose any yield collapse.",
                "- `t47_front_counts.png` should show problem-level front material.",
            ]
        )
        + "\n",
        encoding="utf-8",
    )


def aggregate_line(row: dict[str, str]) -> str:
    return (
        f"| {row['method_label']} | {row['row_count']} | {row['unique_problem_count']} | "
        f"{row['mean_global_ppa_hypervolume']} | {row['mean_hv_auc']} | "
        f"{row['mean_best_score']} | {row['valid_ppa_count']} | "
        f"{row['total_ppa_front_points']} |"
    )


def claim_status(gates: list[dict[str, str]]) -> str:
    if any(row["gate_status"] == "classic_covered_loss" for row in gates):
        return "blocked"
    return "diagnostic_pending_review"


def aggregate_delta(deltas: list[dict[str, str]], name: str, metric: str) -> str:
    for row in deltas:
        if row["scope"] == "aggregate" and row["name"] == name and row["metric"] == metric:
            return row["delta"]
    raise AssertionError(f"Missing aggregate delta {name} {metric}")


def heatmap_values(rows: list[dict[str, str]], metric: str) -> tuple[list[list[float]], list[str], list[str]]:
    labels = problem_labels(rows)
    seeds = sorted({row["seed"] for row in rows})
    values = []
    for seed in seeds:
        seed_values = []
        for label in labels:
            qd = parse_optional(value_for(rows, seed, label, "sr_raw_conservative_exploit_qd", metric))
            classic = parse_optional(value_for(rows, seed, label, "classic_revolution", metric))
            delta = relative_delta(qd, classic)
            seed_values.append(0.0 if delta is None else max(-1.0, min(1.0, delta)))
        values.append(seed_values)
    return values, labels, seeds


def mean_relative_delta(rows: list[dict[str, str]], metric: str) -> float:
    values = []
    for seed in sorted({row["seed"] for row in rows}):
        for label in problem_labels(rows):
            qd = parse_optional(value_for(rows, seed, label, "sr_raw_conservative_exploit_qd", metric))
            classic = parse_optional(value_for(rows, seed, label, "classic_revolution", metric))
            delta = relative_delta(qd, classic)
            if delta is not None:
                values.append(delta)
    assert values
    return sum(values) / len(values)


def mean_problem_value(
    rows: list[dict[str, str]],
    label: str,
    method: str,
    metric: str,
) -> float:
    values = [
        parse_optional(row[metric])
        for row in rows
        if problem_label(row) == label and row["method"] == method
    ]
    parsed = [value for value in values if value is not None]
    assert parsed
    return sum(parsed) / len(parsed)


def value_for(rows: list[dict[str, str]], seed: str, label: str, method: str, metric: str) -> str:
    matches = [
        row[metric]
        for row in rows
        if row["seed"] == seed and problem_label(row) == label and row["method"] == method
    ]
    assert len(matches) == 1
    return matches[0]


def problem_labels(rows: list[dict[str, str]]) -> list[str]:
    return sorted({problem_label(row) for row in rows})


def problem_label(row: dict[str, str]) -> str:
    label = LABEL_OVERRIDES.get(row["problem"])
    assert label is not None
    return label


def method_names() -> list[str]:
    return [method["method"] for method in METHODS]


def method_label(method_name: str) -> str:
    for method in METHODS:
        if method["method"] == method_name:
            return method["label"]
    raise AssertionError(f"Unknown method {method_name}")


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


def sum_optional(rows: list[dict[str, str]], key: str) -> float | None:
    values = [parse_optional(row[key]) for row in rows]
    parsed = [value for value in values if value is not None]
    if not parsed:
        return None
    return sum(parsed)


if __name__ == "__main__":
    raise SystemExit(main())
