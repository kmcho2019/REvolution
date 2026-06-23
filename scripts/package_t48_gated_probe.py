#!/usr/bin/env python3
"""Package the T48 gated-fusion hard/tuning probe."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path
import sys
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
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
from scripts.package_t47_contract_probe import LABEL_OVERRIDES, MODEL_DIR, PHASE

CLASSIC_METHOD = "classic_revolution"
QD_METHOD = "t26_gated_near_front_fusion_qd"
PACKAGE_TAG = "t48"
PACKAGE_TITLE = "T48"
QD_LABEL = "T48 gated QD"
COUNTER_STEM = "gate_counters"
COUNTER_TITLE = "Gated Fusion Counters"
METHODS = (
    {"method": CLASSIC_METHOD, "label": "Classic", "color": "#4e79a7"},
    {"method": QD_METHOD, "label": QD_LABEL, "color": "#f28e2b"},
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
COUNTER_KEYS = (
    "success_parent_requests",
    "two_parent_attempts",
    "two_parent_fallbacks",
    "two_parent_gate_attempts",
    "two_parent_gate_accepts",
    "two_parent_gate_rejects",
)
COUNTER_LABELS = {
    "success_parent_requests": "Success-parent requests",
    "two_parent_attempts": "Two-parent attempts",
    "two_parent_fallbacks": "Two-parent fallbacks",
    "two_parent_gate_attempts": "Two-parent gate attempts",
    "two_parent_gate_accepts": "Two-parent gate accepts",
    "two_parent_gate_rejects": "Two-parent gate rejects",
}

Task = tuple[int, str, str]


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--classic-root", required=True, type=Path)
    parser.add_argument("--qd-root", required=True, type=Path)
    parser.add_argument("--matrix", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--seed", action="append", type=int)
    parser.add_argument("--package-tag", default=PACKAGE_TAG)
    parser.add_argument("--package-title", default=PACKAGE_TITLE)
    parser.add_argument("--qd-method", default=QD_METHOD)
    parser.add_argument("--qd-label", default=QD_LABEL)
    parser.add_argument("--counter-stem", default=COUNTER_STEM)
    parser.add_argument("--counter-title", default=COUNTER_TITLE)
    parser.add_argument("--counter-keys", default=",".join(COUNTER_KEYS))
    args = parser.parse_args(argv)
    configure_package(args)

    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    data_dir = args.output_dir / "data"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    data_dir.mkdir(parents=True, exist_ok=True)

    roots = {CLASSIC_METHOD: args.classic_root, QD_METHOD: args.qd_root}
    tasks = read_tasks(args.matrix, args.seed)
    problem_rows = [
        problem_seed_row(roots[method], method, task)
        for task in tasks
        for method in method_names()
    ]
    aggregate = aggregate_rows(problem_rows)
    deltas = comparison_rows(problem_rows, aggregate)
    gates = gate_rows(problem_rows)
    counters = gate_counter_rows(problem_rows)
    candidates = ppa_candidate_rows(roots, tasks)

    write_csv(table_dir / f"{PACKAGE_TAG}_problem_seed_metrics.csv", problem_rows)
    write_csv(table_dir / f"{PACKAGE_TAG}_aggregate_metrics.csv", aggregate)
    write_csv(table_dir / f"{PACKAGE_TAG}_comparison_deltas.csv", deltas)
    write_csv(table_dir / f"{PACKAGE_TAG}_validity_gates.csv", gates)
    write_csv(table_dir / f"{PACKAGE_TAG}_{COUNTER_STEM}.csv", counters)
    write_csv(data_dir / f"{PACKAGE_TAG}_ppa_candidates.csv", candidates)
    write_figures(problem_rows, candidates, deltas, figure_dir)
    write_report(
        args.output_dir / "README.md",
        args.classic_root,
        args.qd_root,
        aggregate,
        deltas,
        gates,
        counters,
    )
    write_visual_notes(figure_dir / "visual_inspection_notes.md")
    return 0


def configure_package(args: argparse.Namespace) -> None:
    global QD_METHOD, PACKAGE_TAG, PACKAGE_TITLE, QD_LABEL
    global COUNTER_STEM, COUNTER_TITLE, COUNTER_KEYS, METHODS

    QD_METHOD = args.qd_method
    PACKAGE_TAG = args.package_tag
    PACKAGE_TITLE = args.package_title
    QD_LABEL = args.qd_label
    COUNTER_STEM = args.counter_stem
    COUNTER_TITLE = args.counter_title
    COUNTER_KEYS = tuple(key for key in args.counter_keys.split(",") if key)
    METHODS = (
        {"method": CLASSIC_METHOD, "label": "Classic", "color": "#4e79a7"},
        {"method": QD_METHOD, "label": QD_LABEL, "color": "#f28e2b"},
    )


def read_tasks(matrix_path: Path, seeds: list[int] | None) -> list[Task]:
    with matrix_path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    tasks = {
        (int(row["seed"]), row["benchmark"], row["problem"])
        for row in rows
        if row["phase"] == PHASE and row["arm"] == CLASSIC_METHOD
        and (seeds is None or int(row["seed"]) in seeds)
    }
    assert tasks
    for row in rows:
        if row["phase"] != PHASE:
            continue
        assert row["reference_status"] == "reference_available"
        assert row["headline_eligible"] == "true"
    return sorted(tasks)


def problem_seed_row(method_root: Path, method: str, task: Task) -> dict[str, str]:
    seed, benchmark, problem = task
    problem_root = method_root / f"seed_{seed}" / MODEL_DIR / benchmark / problem
    summary = load_problem_summary(problem_root, benchmark, problem)
    pareto = analyze_problem_pareto(problem_root, benchmark=benchmark, problem=problem)
    archive = load_optional_json(problem_root / "archive_summary.json")
    global_pareto = load_optional_json(problem_root / "global_pareto_summary.json")
    history = load_jsonl(problem_root / "archive_history.jsonl")
    qd_metrics = load_optional_json(problem_root / "qd_metrics.json")
    latest = latest_snapshot(qd_metrics)
    spread = front_spread(pareto)
    unique_points = unique_improvement_points(pareto.candidates, pareto.objective_metrics)
    best_score = summary["final_population_ppa"].get("best_score")
    qd_scores = [float(row.get("qd_score") or 0.0) for row in history]
    coverages = [float(row.get("coverage") or 0.0) for row in history]
    row = {
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
        "qd_two_parent_gate": "" if latest is None else str(latest["qd_two_parent_gate"]),
    }
    for key in COUNTER_KEYS:
        row[key] = fmt_optional(optional_int(latest, key))
    return row


def load_problem_summary(problem_root: Path, benchmark: str, problem: str) -> dict[str, Any]:
    summary_path = problem_root / f"{problem}_summary.json"
    if summary_path.is_file():
        return load_json(summary_path)
    summaries = [
        path
        for path in sorted(problem_root.glob("*_summary.json"))
        if path.name not in {"archive_summary.json", "global_pareto_summary.json"}
    ]
    if summaries:
        return load_json(summaries[0])
    rows = load_jsonl(problem_root / "generation_log.jsonl")
    assert rows
    total = sum(generation_candidate_count(row) for row in rows)
    assert total
    counts = {
        key: sum(
            round(generation_candidate_count(row) * generation_success_rate(row, key))
            for row in rows
        )
        for key in ("syntax", "functionality", "synthesis_ppa")
    }
    return {
        "benchmark_name": benchmark,
        "problem_name": problem,
        "total_candidates_generated": total,
        "accumulated_success_rates": {
            key: counts[key] / total
            for key in ("syntax", "functionality", "synthesis_ppa")
        },
        "final_population_ppa": rows[-1]["generation_ppa"],
        "final_population_ppa_details": rows[-1]["population_ppa_details"],
    }


def generation_candidate_count(row: dict[str, Any]) -> int:
    status_counts = row.get("status_counts_this_generation")
    if isinstance(status_counts, dict):
        return sum(int(value) for value in status_counts.values())
    details = row["population_ppa_details"]
    assert isinstance(details, list)
    return len(details)


def generation_success_rate(row: dict[str, Any], key: str) -> float:
    rates = row["success_rates"]
    assert isinstance(rates, dict)
    return float(rates[f"total_{key}"])


def ppa_candidate_rows(roots: dict[str, Path], tasks: list[Task]) -> list[dict[str, str]]:
    rows = []
    for seed, benchmark, problem in tasks:
        for method in method_names():
            problem_root = roots[method] / f"seed_{seed}" / MODEL_DIR / benchmark / problem
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
        "problem_label": LABEL_OVERRIDES[problem],
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
                output.append(aggregate_row(seed_group, cohort, method_rows(seed_rows, method)))
    return output


def aggregate_row(seed_group: str, cohort: str, rows: list[dict[str, str]]) -> dict[str, str]:
    assert rows
    row = {
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
    for key in COUNTER_KEYS:
        row[f"total_{key}"] = fmt_optional(sum_optional(rows, key))
    return row


def comparison_rows(
    problem_rows: list[dict[str, str]],
    aggregate: list[dict[str, str]],
) -> list[dict[str, str]]:
    output = []
    problem_index = {
        (row["seed"], row["benchmark"], row["problem"], row["method"]): row
        for row in problem_rows
    }
    for seed, benchmark, problem in sorted({key[:-1] for key in problem_index}):
        name = f"{seed}:{benchmark}:{problem}"
        qd = problem_index[(seed, benchmark, problem, QD_METHOD)]
        classic = problem_index[(seed, benchmark, problem, CLASSIC_METHOD)]
        for metric in COMPARISON_METRICS:
            output.append(comparison_row("problem_seed", name, metric, qd, classic))

    aggregate_index = {
        (row["seed_group"], row["cohort"], row["method"]): row
        for row in aggregate
    }
    for seed_group, cohort in sorted({key[:-1] for key in aggregate_index}):
        name = f"{seed_group}:{cohort}"
        qd = aggregate_index[(seed_group, cohort, QD_METHOD)]
        classic = aggregate_index[(seed_group, cohort, CLASSIC_METHOD)]
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
        "method": QD_METHOD,
        "reference": CLASSIC_METHOD,
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
        qd = index[(seed, benchmark, problem, QD_METHOD)]
        classic = index[(seed, benchmark, problem, CLASSIC_METHOD)]
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
        "method": QD_METHOD,
        "reference": CLASSIC_METHOD,
        "value": str(value),
        "reference_value": str(reference),
        "delta": str(value - reference),
        "relative_delta": fmt_optional(relative_delta(float(value), float(reference))),
        "gate_status": status,
    }


def gate_counter_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    output = []
    for row in rows:
        if row["method"] != QD_METHOD:
            continue
        counter_row = {
            "seed": row["seed"],
            "benchmark": row["benchmark"],
            "problem": row["problem"],
            "qd_two_parent_gate": row["qd_two_parent_gate"],
        }
        for key in COUNTER_KEYS:
            counter_row[key] = row[key]
        output.append(counter_row)
    assert output
    return output


def write_figures(
    problem_rows: list[dict[str, str]],
    candidates: list[dict[str, str]],
    deltas: list[dict[str, str]],
    figure_dir: Path,
) -> None:
    plot_hv_delta_heatmap(problem_rows, figure_dir / f"{PACKAGE_TAG}_hv_delta_heatmap.png")
    plot_metric_delta_summary(deltas, figure_dir / f"{PACKAGE_TAG}_metric_delta_summary.png")
    plot_validity_funnel(problem_rows, figure_dir / f"{PACKAGE_TAG}_validity_funnel.png")
    plot_front_counts(problem_rows, figure_dir / f"{PACKAGE_TAG}_front_counts.png")
    plot_gate_counters(problem_rows, figure_dir / f"{PACKAGE_TAG}_{COUNTER_STEM}.png")
    for seed in sorted({row["seed"] for row in candidates}):
        plot_direct_ppa_fronts(
            [row for row in candidates if row["seed"] == seed],
            figure_dir / f"{PACKAGE_TAG}_direct_ppa_fronts_seed{seed}.png",
        )


def plot_hv_delta_heatmap(rows: list[dict[str, str]], output_path: Path) -> None:
    values, labels, seeds = heatmap_values(rows, "global_ppa_hypervolume")
    fig, axis = plt.subplots(figsize=(max(10.0, len(labels) * 0.55), 3.4))
    image = axis.imshow(values, aspect="auto", cmap="RdBu", vmin=-1.0, vmax=1.0)
    axis.set_title(f"{PACKAGE_TITLE} Relative HV Delta: QD vs Classic")
    axis.set_yticks(range(len(seeds)))
    axis.set_yticklabels(seeds)
    axis.set_xticks(range(len(labels)))
    axis.set_xticklabels(labels, rotation=50, ha="right", fontsize=8)
    fig.colorbar(image, ax=axis, fraction=0.025, pad=0.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_metric_delta_summary(deltas: list[dict[str, str]], output_path: Path) -> None:
    labels = ("HV", "HV-AUC", "Best", "Valid PPA", "Front")
    metrics = (
        "mean_global_ppa_hypervolume",
        "mean_hv_auc",
        "mean_best_score",
        "valid_ppa_count",
        "total_ppa_front_points",
    )
    values = [aggregate_relative_delta(deltas, metric) for metric in metrics]
    colors = ["#f28e2b" if value >= 0.0 else "#4e79a7" for value in values]
    fig, axis = plt.subplots(figsize=(7.2, 4.4))
    axis.axhline(0.0, color="#222222", linewidth=1.0)
    axis.bar(labels, values, color=colors, alpha=0.88)
    y_min = min([0.0, *values])
    y_max = max([0.0, *values])
    y_span = max(y_max - y_min, 0.08)
    axis.set_ylim(y_min - y_span * 0.16, y_max + y_span * 0.34)
    for index, value in enumerate(values):
        va = "bottom" if value >= 0.0 else "top"
        offset = y_span * 0.045 if value >= 0.0 else -y_span * 0.045
        axis.text(index, value + offset, f"{value:+.0%}", ha="center", va=va, fontsize=9)
    axis.set_title(f"{PACKAGE_TITLE} Aggregate Relative Delta")
    axis.set_ylabel("QD vs Classic")
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
        rows_for_method = method_rows(rows, method["method"])
        values = [sum(int(row[stage]) for row in rows_for_method) for stage in stages]
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
    axis.set_title(f"{PACKAGE_TITLE} Validity Funnel")
    axis.set_ylabel("Candidates across available seeds")
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
    axis.set_title(f"{PACKAGE_TITLE} Mean PPA-Front Points By Problem")
    axis.set_ylabel("Mean front points across seeds")
    axis.legend(frameon=False)
    axis.grid(axis="y", color="#e6e6e6", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_gate_counters(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [counter_label(key) for key in COUNTER_KEYS]
    keys = COUNTER_KEYS
    qd_rows = method_rows(rows, QD_METHOD)
    values = [sum(int(parse_optional(row[key]) or 0) for row in qd_rows) for key in keys]
    fig, axis = plt.subplots(figsize=(7.6, 4.4))
    axis.bar(labels, values, color="#f28e2b", alpha=0.88)
    for index, value in enumerate(values):
        axis.text(index, value, str(value), ha="center", va="bottom", fontsize=9)
    axis.set_title(f"{PACKAGE_TITLE} {COUNTER_TITLE}")
    axis.set_ylabel("Events across available seeds")
    axis.grid(axis="y", color="#e6e6e6", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_direct_ppa_fronts(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = sorted({row["problem_label"] for row in rows})
    columns = 4
    fig, axes = plt.subplots(
        (len(labels) + columns - 1) // columns,
        columns,
        figsize=(13.5, 10.0),
        squeeze=False,
    )
    for axis in axes.flat:
        axis.axis("off")
    for index, label in enumerate(labels):
        axis = axes.flat[index]
        axis.axis("on")
        axis.axhline(0.0, color="#dddddd", linewidth=0.8)
        axis.axvline(0.0, color="#dddddd", linewidth=0.8)
        for method in METHODS:
            plot_rows = [
                row
                for row in rows
                if row["problem_label"] == label and row["method"] == method["method"]
            ]
            non_front = [row for row in plot_rows if row["is_pareto_front"] != "True"]
            front = [row for row in plot_rows if row["is_pareto_front"] == "True"]
            scatter_points(axis, non_front, method["color"], 10, 0.25, ".")
            scatter_points(axis, front, method["color"], 28, 0.9, "o")
        axis.set_title(label, fontsize=8)
        axis.tick_params(labelsize=7)
        axis.grid(color="#eeeeee", linewidth=0.6)
    handles = [
        Line2D([0], [0], marker="o", color="w", label=method["label"],
               markerfacecolor=method["color"], markersize=6)
        for method in METHODS
    ]
    fig.legend(
        handles=handles,
        loc="upper center",
        bbox_to_anchor=(0.5, 0.955),
        ncol=2,
        frameon=False,
    )
    fig.supxlabel("Area improvement vs reference", y=0.025)
    fig.supylabel("Power improvement vs reference", x=0.012)
    fig.suptitle(
        f"{PACKAGE_TITLE} Direct Area-Power Fronts, Seed {rows[0]['seed']}",
        y=0.99,
    )
    fig.tight_layout(rect=(0.0, 0.04, 1.0, 0.92))
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def scatter_points(
    axis: Any,
    rows: list[dict[str, str]],
    color: str,
    size: int,
    alpha: float,
    marker: str,
) -> None:
    points = [
        (parse_optional(row["area_improvement"]), parse_optional(row["power_improvement"]))
        for row in rows
    ]
    parsed = [(area, power) for area, power in points if area is not None and power is not None]
    if not parsed:
        return
    axis.scatter(
        [area for area, _ in parsed],
        [power for _, power in parsed],
        s=size,
        marker=marker,
        color=color,
        alpha=alpha,
        linewidths=0.2,
        edgecolors="#222222" if marker == "o" else "none",
    )


def write_report(
    path: Path,
    classic_root: Path,
    qd_root: Path,
    aggregate: list[dict[str, str]],
    deltas: list[dict[str, str]],
    gates: list[dict[str, str]],
    counters: list[dict[str, str]],
) -> None:
    aggregate_index = {
        (row["seed_group"], row["cohort"], row["method"]): row
        for row in aggregate
    }
    all_classic = aggregate_index[("all", "all", CLASSIC_METHOD)]
    all_qd = aggregate_index[("all", "all", QD_METHOD)]
    hard_losses = [row for row in gates if row["gate_status"] == "classic_covered_loss"]
    yield_warnings = [row for row in gates if row["gate_status"] == "yield_warning"]
    lines = [
        f"# {PACKAGE_TITLE} Hard/Tuning Probe Package",
        "",
        f"Classic root: `{classic_root}`",
        f"{PACKAGE_TITLE} root: `{qd_root}`",
        "",
        "## Headline",
        "",
        f"- Claim status: `{claim_status(gates)}`.",
        f"- Mean HV delta: `{aggregate_delta(deltas, 'all:all', 'mean_global_ppa_hypervolume')}`.",
        f"- Mean HV-AUC delta: `{aggregate_delta(deltas, 'all:all', 'mean_hv_auc')}`.",
        f"- Mean best-score delta: `{aggregate_delta(deltas, 'all:all', 'mean_best_score')}`.",
        f"- Classic-covered valid-PPA losses: `{len(hard_losses)}`.",
        f"- Yield warnings: `{len(yield_warnings)}`.",
        *counter_report_lines(counters),
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
        f"- `tables/{PACKAGE_TAG}_problem_seed_metrics.csv`",
        f"- `tables/{PACKAGE_TAG}_aggregate_metrics.csv`",
        f"- `tables/{PACKAGE_TAG}_comparison_deltas.csv`",
        f"- `tables/{PACKAGE_TAG}_validity_gates.csv`",
        f"- `tables/{PACKAGE_TAG}_{COUNTER_STEM}.csv`",
        f"- `data/{PACKAGE_TAG}_ppa_candidates.csv`",
        f"- `figures/{PACKAGE_TAG}_hv_delta_heatmap.png`",
        f"- `figures/{PACKAGE_TAG}_metric_delta_summary.png`",
        f"- `figures/{PACKAGE_TAG}_validity_funnel.png`",
        f"- `figures/{PACKAGE_TAG}_front_counts.png`",
        f"- `figures/{PACKAGE_TAG}_{COUNTER_STEM}.png`",
        f"- `figures/{PACKAGE_TAG}_direct_ppa_fronts_seed*.png`",
        "",
        "## Discipline",
        "",
        "This package compares a hard/tuning screen against the T47 classic",
        "roots. It is not a held-out RTLLM claim. The direct PPA-front plots are",
        "reader-facing supplements; they do not replace the Phase 03.1 viewer if",
        f"{PACKAGE_TITLE} advances to a larger archive-backed run.",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_visual_notes(path: Path) -> None:
    path.write_text(
        "\n".join(
            [
                f"# {PACKAGE_TITLE} Visual Inspection Notes",
                "",
                "Status: generated; manual screenshot inspection pending.",
                "",
                f"- `{PACKAGE_TAG}_hv_delta_heatmap.png` should expose seed/problem HV wins",
                "  and losses without hiding paired failures.",
                f"- `{PACKAGE_TAG}_metric_delta_summary.png` should show whether the method",
                "  wins through HV/front material or only through best score.",
                f"- `{PACKAGE_TAG}_validity_funnel.png` should make yield collapse visible.",
                f"- `{PACKAGE_TAG}_{COUNTER_STEM}.png` should show whether the",
                "  configured counters are active or degenerate.",
                f"- `{PACKAGE_TAG}_direct_ppa_fronts_seed*.png` should make raw area-power",
                "  distribution differences easy to inspect by problem.",
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


def aggregate_relative_delta(deltas: list[dict[str, str]], metric: str) -> float:
    for row in deltas:
        if row["scope"] == "aggregate" and row["name"] == "all:all" and row["metric"] == metric:
            return parse_optional(row["relative_delta"]) or 0.0
    raise AssertionError(f"Missing aggregate relative delta {metric}")


def counter_total(rows: list[dict[str, str]], key: str) -> str:
    return str(sum(int(parse_optional(row[key]) or 0) for row in rows))


def counter_report_lines(rows: list[dict[str, str]]) -> list[str]:
    return [f"- {counter_label(key)}: `{counter_total(rows, key)}`." for key in COUNTER_KEYS]


def counter_label(key: str) -> str:
    label = COUNTER_LABELS.get(key)
    if label is not None:
        return label
    return key.replace("_", " ")


def heatmap_values(rows: list[dict[str, str]], metric: str) -> tuple[list[list[float]], list[str], list[str]]:
    labels = problem_labels(rows)
    seeds = sorted({row["seed"] for row in rows})
    values = []
    for seed in seeds:
        seed_values = []
        for label in labels:
            qd = parse_optional(value_for(rows, seed, label, QD_METHOD, metric))
            classic = parse_optional(value_for(rows, seed, label, CLASSIC_METHOD, metric))
            delta = relative_delta(qd, classic)
            seed_values.append(0.0 if delta is None else max(-1.0, min(1.0, delta)))
        values.append(seed_values)
    return values, labels, seeds


def mean_relative_delta(rows: list[dict[str, str]], metric: str) -> float:
    values = []
    for seed in sorted({row["seed"] for row in rows}):
        for label in problem_labels(rows):
            qd = parse_optional(value_for(rows, seed, label, QD_METHOD, metric))
            classic = parse_optional(value_for(rows, seed, label, CLASSIC_METHOD, metric))
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


def method_rows(rows: list[dict[str, str]], method: str) -> list[dict[str, str]]:
    return [row for row in rows if row["method"] == method]


def method_names() -> list[str]:
    return [method["method"] for method in METHODS]


def method_label(method_name: str) -> str:
    for method in METHODS:
        if method["method"] == method_name:
            return method["label"]
    raise AssertionError(f"Unknown method {method_name}")


def latest_snapshot(payload: dict[str, Any] | None) -> dict[str, Any] | None:
    if payload is None:
        return None
    latest = payload["latest_snapshot"]
    assert isinstance(latest, dict)
    return latest


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
