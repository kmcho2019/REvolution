#!/usr/bin/env python3
"""Package the T30 T26 holdout front audit."""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

from revolution.qd.pareto_analysis import (
    analyze_problem_pareto,
    compute_candidate_improvements,
    objective_metrics_for_reference,
    pareto_front,
)
from scripts.package_t27_t26_live_qd_audit import (
    auc,
    front_spread,
    hypervolume_curve,
    load_json,
    load_jsonl,
    parse_optional,
    relative_delta,
    success_count,
    success_rate,
    unique_improvement_points,
)
from scripts.package_t28_t26_family_audit import (
    FamilyCandidate,
    GeneratedCandidate,
    beats_reference,
    family_signature,
    fmt,
    fmt_optional,
    hash_text,
    normalized_verilog,
    ratio,
    sum_int,
    synthesized_cell_counts,
    unique_count,
    write_csv,
)

BENCHMARK = "VerilogEval-Spec-to-RTL"
PROBLEMS = (
    "Prob150_review2015_fsmonehot",
    "Prob098_circuit7",
    "Prob135_m2014_q6b",
)
METHODS: tuple[dict[str, str], ...] = (
    {
        "method": "classic_revolution",
        "label": "Classic",
        "mode": "classic_revolution/seed_1001/openai_gpt-oss-120b",
        "color": "#4e79a7",
    },
    {
        "method": "sr_raw_conservative_exploit_qd",
        "label": "T26 conservative exploit",
        "mode": "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b",
        "color": "#e15759",
    },
)
OUTPUT_PREFIX: str = "t30_holdout"
FIGURE_TITLE_PREFIX: str = "T30 Holdout"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    live_rows = [
        live_problem_row(args.run_root, method, problem)
        for method in METHODS
        for problem in PROBLEMS
    ]
    live_aggregate_rows = aggregate_live_rows(live_rows)
    live_delta_rows = live_comparison_rows(live_aggregate_rows)
    candidates = [
        candidate
        for method in METHODS
        for problem in PROBLEMS
        for candidate in collect_problem_candidates(args.run_root, method, problem)
    ]
    family_rows = family_problem_rows(candidates)
    family_aggregate_rows = aggregate_family_rows(family_rows)
    family_delta_rows = family_comparison_rows(family_aggregate_rows)

    write_csv(table_dir / f"{OUTPUT_PREFIX}_live_problem_metrics.csv", live_rows)
    write_csv(table_dir / f"{OUTPUT_PREFIX}_live_aggregate_metrics.csv", live_aggregate_rows)
    write_csv(table_dir / f"{OUTPUT_PREFIX}_live_comparison_deltas.csv", live_delta_rows)
    write_csv(table_dir / f"{OUTPUT_PREFIX}_family_candidate_rows.csv", candidate_rows(candidates))
    write_csv(table_dir / f"{OUTPUT_PREFIX}_family_problem_metrics.csv", family_rows)
    write_csv(table_dir / f"{OUTPUT_PREFIX}_family_aggregate_metrics.csv", family_aggregate_rows)
    write_csv(table_dir / f"{OUTPUT_PREFIX}_family_comparison_deltas.csv", family_delta_rows)
    write_csv(table_dir / f"{OUTPUT_PREFIX}_method_manifest.csv", manifest_rows(args.run_root))
    write_figures(live_rows, live_aggregate_rows, candidates, family_aggregate_rows, figure_dir)
    return 0


def problem_root(run_root: Path, method: dict[str, str], problem: str) -> Path:
    return run_root / method["mode"] / BENCHMARK / problem


def live_problem_row(
    run_root: Path,
    method: dict[str, str],
    problem: str,
) -> dict[str, str]:
    root = problem_root(run_root, method, problem)
    summary = load_json(root / f"{problem}_summary.json")
    ref_metrics = summary["ref_ppa_metric"]
    assert isinstance(ref_metrics, dict)
    pareto = analyze_problem_pareto(root, benchmark=BENCHMARK, problem=problem)
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
        "reference_area": fmt(float(ref_metrics["area"])),
        "reference_power": fmt(float(ref_metrics["power"])),
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
    }


def collect_problem_candidates(
    run_root: Path,
    method: dict[str, str],
    problem: str,
) -> list[FamilyCandidate]:
    root = problem_root(run_root, method, problem)
    summary = load_json(root / f"{problem}_summary.json")
    ref_metrics = summary["ref_ppa_metric"]
    assert isinstance(ref_metrics, dict)
    objective_metrics = objective_metrics_for_reference(ref_metrics)
    generated_by_id: dict[str, GeneratedCandidate] = {}
    ppa_details: list[tuple[int, dict[str, Any]]] = []

    for payload in load_jsonl(root / "generation_log.jsonl"):
        generation = int(payload["generation"])
        generated = payload["generated_candidates"]
        assert isinstance(generated, list)
        for row in generated:
            assert isinstance(row, dict)
            candidate_id = str(row["id"])
            generated_by_id[candidate_id] = GeneratedCandidate(
                candidate_id=candidate_id,
                generation=generation,
                strategy=str(row["strategy"]),
                status=str(row["status"]),
                code_file_path=Path(str(row["code_file_path"])),
            )
        details = payload["population_ppa_details"]
        assert isinstance(details, list)
        for detail in details:
            assert isinstance(detail, dict)
            ppa_details.append((generation, detail))

    candidates = []
    seen_ids: set[str] = set()
    for generation, detail in ppa_details:
        candidate_id = str(detail["id"])
        if candidate_id in seen_ids:
            continue
        seen_ids.add(candidate_id)
        generated = generated_by_id[candidate_id]
        assert generated.status == "success"
        ppa_metrics = detail["ppa_metrics"]
        assert isinstance(ppa_metrics, dict)
        improvements = compute_candidate_improvements(
            ppa_metrics,
            {key: float(value) for key, value in ref_metrics.items()},
            objective_metrics,
        )
        assert improvements is not None
        code_path = generated.code_file_path
        assert code_path.is_file()
        netlist_path = code_path.with_name("code.syn.v")
        assert netlist_path.is_file()
        cell_counts = synthesized_cell_counts(netlist_path)
        candidates.append(
            FamilyCandidate(
                method=method["method"],
                method_label=method["label"],
                problem=problem,
                candidate_id=candidate_id,
                generation=generation,
                strategy=generated.strategy,
                score=float(detail["score"]),
                ppa_metrics={
                    metric: float(ppa_metrics[metric])
                    for metric in objective_metrics
                },
                improvements=improvements,
                code_file_path=code_path,
                rtl_hash=hash_text(normalized_verilog(code_path)),
                netlist_hash=hash_text(normalized_verilog(netlist_path)),
                family_hash=hash_text(family_signature(cell_counts)),
                family_signature=family_signature(cell_counts),
                is_front=False,
                beats_reference=beats_reference(improvements, objective_metrics),
            )
        )

    front_ids = pareto_candidate_ids(candidates, objective_metrics)
    return [
        FamilyCandidate(
            method=candidate.method,
            method_label=candidate.method_label,
            problem=candidate.problem,
            candidate_id=candidate.candidate_id,
            generation=candidate.generation,
            strategy=candidate.strategy,
            score=candidate.score,
            ppa_metrics=candidate.ppa_metrics,
            improvements=candidate.improvements,
            code_file_path=candidate.code_file_path,
            rtl_hash=candidate.rtl_hash,
            netlist_hash=candidate.netlist_hash,
            family_hash=candidate.family_hash,
            family_signature=candidate.family_signature,
            is_front=candidate.candidate_id in front_ids,
            beats_reference=candidate.beats_reference,
        )
        for candidate in candidates
    ]


def pareto_candidate_ids(
    candidates: list[FamilyCandidate],
    objective_metrics: tuple[str, ...],
) -> set[str]:
    points = [
        tuple(candidate.improvements[metric] for metric in objective_metrics)
        for candidate in candidates
    ]
    return {candidates[index].candidate_id for index in pareto_front(points)}


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
    )
    return comparison_rows(by_method, "sr_raw_conservative_exploit_qd", metrics)


def family_problem_rows(candidates: list[FamilyCandidate]) -> list[dict[str, str]]:
    rows = []
    for method in METHODS:
        for problem in PROBLEMS:
            subset = [
                candidate
                for candidate in candidates
                if candidate.method == method["method"] and candidate.problem == problem
            ]
            rows.append(family_metric_row(method, problem, subset))
    return rows


def family_metric_row(
    method: dict[str, str],
    problem: str,
    candidates: list[FamilyCandidate],
) -> dict[str, str]:
    front = [candidate for candidate in candidates if candidate.is_front]
    beating = [candidate for candidate in candidates if candidate.beats_reference]
    valid_count = len(candidates)
    front_count = len(front)
    return {
        "method": method["method"],
        "method_label": method["label"],
        "problem": problem,
        "valid_ppa_count": str(valid_count),
        "ppa_front_count": str(front_count),
        "unique_family_count": str(unique_count(candidates, "family_hash")),
        "front_unique_family_count": str(unique_count(front, "family_hash")),
        "front_unique_netlist_count": str(unique_count(front, "netlist_hash")),
        "reference_beating_unique_family_count": str(unique_count(beating, "family_hash")),
        "valid_family_ratio": fmt(ratio(unique_count(candidates, "family_hash"), valid_count)),
        "front_family_ratio": fmt(ratio(unique_count(front, "family_hash"), front_count)),
        "front_netlist_ratio": fmt(ratio(unique_count(front, "netlist_hash"), front_count)),
    }


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
    return comparison_rows(by_method, "sr_raw_conservative_exploit_qd", metrics)


def comparison_rows(
    by_method: dict[str, dict[str, str]],
    method: str,
    metrics: tuple[str, ...],
) -> list[dict[str, str]]:
    reference = "classic_revolution"
    output = []
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


def candidate_rows(candidates: list[FamilyCandidate]) -> list[dict[str, str]]:
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


def manifest_rows(run_root: Path) -> list[dict[str, str]]:
    return [
        {
            "method": method["method"],
            "method_label": method["label"],
            "source_run_root": str(run_root),
            "mode": method["mode"],
            "benchmark": BENCHMARK,
        }
        for method in METHODS
    ]


def write_figures(
    live_rows: list[dict[str, str]],
    live_aggregate: list[dict[str, str]],
    candidates: list[FamilyCandidate],
    family_aggregate: list[dict[str, str]],
    figure_dir: Path,
) -> None:
    plot_live_aggregate(live_aggregate, figure_dir / f"{OUTPUT_PREFIX}_live_aggregate.png")
    plot_problem_counts(live_rows, figure_dir / f"{OUTPUT_PREFIX}_problem_counts.png")
    plot_family_aggregate(family_aggregate, figure_dir / f"{OUTPUT_PREFIX}_family_counts.png")
    plot_raw_ppa_pareto_fronts(
        candidates,
        live_rows,
        figure_dir / f"{OUTPUT_PREFIX}_ppa_pareto_area_power.png",
        title=f"{FIGURE_TITLE_PREFIX} Raw PPA Pareto Fronts With Reference",
        show_reference=True,
    )
    plot_raw_ppa_pareto_fronts(
        candidates,
        live_rows,
        figure_dir / f"{OUTPUT_PREFIX}_ppa_pareto_area_power_candidate_zoom.png",
        title=f"{FIGURE_TITLE_PREFIX} Raw PPA Pareto Fronts",
        show_reference=False,
    )
    plot_ppa_fronts(
        candidates,
        figure_dir / f"{OUTPUT_PREFIX}_ppa_fronts_area_power_zoom.png",
        use_improvements=False,
    )
    plot_ppa_fronts(
        candidates,
        figure_dir / f"{OUTPUT_PREFIX}_ppa_fronts_improvement.png",
        use_improvements=True,
    )


def plot_live_aggregate(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [row["method_label"] for row in rows]
    x = list(range(len(rows)))
    fig, axes = plt.subplots(1, 3, figsize=(13.5, 4.6))
    bar_panel(axes[0], rows, x, "mean_global_ppa_hypervolume", "Mean HV")
    bar_panel(axes[1], rows, x, "mean_hv_auc", "Mean HV AUC")
    bar_panel(axes[2], rows, x, "total_ppa_front_points", "Front Points")
    for axis in axes:
        axis.set_xticks(x)
        axis.set_xticklabels(labels, rotation=18, ha="right")
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.8)
    fig.suptitle(f"{FIGURE_TITLE_PREFIX} Live Metrics", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_problem_counts(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [method["label"] for method in METHODS]
    by_key = {(row["method_label"], row["problem"]): row for row in rows}
    x_positions = list(range(len(PROBLEMS)))
    width = 0.34
    fig, axes = plt.subplots(1, 3, figsize=(16.4, 4.8))
    metrics = ("ppa_front_points", "reference_beating_count", "valid_ppa_count")
    titles = ("Front Points", "Reference-Beating", "Valid PPA")
    for axis, metric, title in zip(axes, metrics, titles, strict=True):
        for index, label in enumerate(labels):
            offset = (index - 0.5) * width
            values = [parse_optional(by_key[(label, problem)][metric]) or 0.0 for problem in PROBLEMS]
            axis.bar(
                [position + offset for position in x_positions],
                values,
                width,
                color=color_for_label(label),
                label=label,
                alpha=0.86,
            )
        axis.set_title(title)
        axis.set_xticks(x_positions)
        axis.set_xticklabels(short_problem_names(), rotation=25, ha="right")
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.8)
    handles, legend_labels = axes[0].get_legend_handles_labels()
    fig.legend(handles, legend_labels, loc="lower center", ncol=2, frameon=False)
    fig.suptitle(f"{FIGURE_TITLE_PREFIX} Counts By Problem", y=1.02)
    fig.tight_layout(rect=(0, 0.12, 1, 0.94))
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_family_aggregate(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [row["method_label"] for row in rows]
    x = list(range(len(rows)))
    fig, axes = plt.subplots(1, 3, figsize=(13.5, 4.6))
    bar_panel(axes[0], rows, x, "front_unique_family_count", "Front Families")
    bar_panel(axes[1], rows, x, "front_unique_netlist_count", "Front Netlists")
    bar_panel(axes[2], rows, x, "valid_family_ratio", "Valid Family Ratio")
    for axis in axes:
        axis.set_xticks(x)
        axis.set_xticklabels(labels, rotation=18, ha="right")
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.8)
    fig.suptitle(f"{FIGURE_TITLE_PREFIX} Family Metrics", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_raw_ppa_pareto_fronts(
    candidates: list[FamilyCandidate],
    live_rows: list[dict[str, str]],
    output_path: Path,
    *,
    title: str,
    show_reference: bool,
) -> None:
    references = {
        row["problem"]: (float(row["reference_area"]), float(row["reference_power"]))
        for row in live_rows
        if row["method"] == "classic_revolution"
    }
    fig, axes = plt.subplots(1, len(PROBLEMS), figsize=(17.4, 5.4), sharey=False)
    for axis, problem, short_title in zip(axes, PROBLEMS, short_problem_names(), strict=True):
        subset = [candidate for candidate in candidates if candidate.problem == problem]
        if show_reference:
            reference_area, reference_power = references[problem]
            axis.scatter(
                [reference_area],
                [reference_power],
                marker="*",
                s=145,
                color="#111111",
                edgecolors="white",
                linewidths=0.9,
                label="Reference",
                zorder=6,
            )
        for method in METHODS:
            points = [candidate for candidate in subset if candidate.method == method["method"]]
            axis.scatter(
                [candidate.ppa_metrics["area"] for candidate in points],
                [candidate.ppa_metrics["power"] for candidate in points],
                s=38,
                color=method["color"],
                alpha=0.38,
                edgecolors="none",
                label=method["label"],
            )
            front_points = sorted(
                (
                    candidate.ppa_metrics["area"],
                    candidate.ppa_metrics["power"],
                )
                for candidate in points
                if candidate.is_front
            )
            if front_points:
                front_xs = [point[0] for point in front_points]
                front_ys = [point[1] for point in front_points]
                if len(front_points) > 1:
                    axis.plot(
                        front_xs,
                        front_ys,
                        color=method["color"],
                        linewidth=1.4,
                        alpha=0.82,
                        zorder=4,
                    )
                axis.scatter(
                    front_xs,
                    front_ys,
                    s=96,
                    facecolors="none",
                    edgecolors=method["color"],
                    linewidths=1.9,
                    zorder=5,
                )
        axis.set_title(short_title)
        axis.set_xlabel("Area (lower is better)")
        axis.grid(color="#e5e5e5", linewidth=0.8)
        axis.annotate(
            "better",
            xy=(0.05, 0.08),
            xytext=(0.22, 0.24),
            xycoords="axes fraction",
            arrowprops={"arrowstyle": "->", "color": "#444444", "linewidth": 1.0},
            fontsize=9,
            color="#444444",
        )
        if problem == PROBLEMS[0]:
            axis.set_ylabel("Power (lower is better)")
    handles, labels = axes[0].get_legend_handles_labels()
    unique = dict(zip(labels, handles, strict=True))
    fig.legend(
        unique.values(),
        unique.keys(),
        loc="upper center",
        bbox_to_anchor=(0.5, 0.93),
        ncol=3,
        frameon=False,
    )
    fig.suptitle(title, y=0.995)
    scope = "Conventional raw area-power projection" if show_reference else "Candidate-only raw area-power projection"
    fig.text(
        0.5,
        0.02,
        f"{scope}: lower-left is better. "
        "Open circles mark each method's active-objective rank-1 front.",
        ha="center",
        fontsize=9,
        color="#444444",
    )
    fig.tight_layout(rect=(0, 0.08, 1, 0.84))
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_ppa_fronts(
    candidates: list[FamilyCandidate],
    output_path: Path,
    *,
    use_improvements: bool,
) -> None:
    fig, axes = plt.subplots(1, len(PROBLEMS), figsize=(17.4, 5.2), sharey=False)
    for axis, problem, title in zip(axes, PROBLEMS, short_problem_names(), strict=True):
        subset = [candidate for candidate in candidates if candidate.problem == problem]
        for method in METHODS:
            points = [candidate for candidate in subset if candidate.method == method["method"]]
            xs = [plot_value(candidate, "area", use_improvements) for candidate in points]
            ys = [plot_value(candidate, "power", use_improvements) for candidate in points]
            axis.scatter(
                xs,
                ys,
                s=36,
                color=method["color"],
                alpha=0.42,
                edgecolors="none",
                label=method["label"],
            )
            front = [candidate for candidate in points if candidate.is_front]
            axis.scatter(
                [plot_value(candidate, "area", use_improvements) for candidate in front],
                [plot_value(candidate, "power", use_improvements) for candidate in front],
                s=90,
                facecolors="none",
                edgecolors=method["color"],
                linewidths=1.9,
            )
        axis.set_title(title)
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
    fig.legend(handles, labels, loc="upper center", bbox_to_anchor=(0.5, 0.93), ncol=2, frameon=False)
    title = (
        f"{FIGURE_TITLE_PREFIX} PPA Fronts: Improvement Space"
        if use_improvements
        else f"{FIGURE_TITLE_PREFIX} PPA Fronts: Area-Power"
    )
    fig.suptitle(title, y=0.995)
    fig.text(
        0.5,
        0.02,
        "Open circles mark each method's active-objective rank-1 PPA front.",
        ha="center",
        fontsize=9,
        color="#444444",
    )
    fig.tight_layout(rect=(0, 0.08, 1, 0.84))
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def bar_panel(axis: Any, rows: list[dict[str, str]], x: list[int], metric: str, title: str) -> None:
    values = [parse_optional(row[metric]) or 0.0 for row in rows]
    colors = [color_for_label(row["method_label"]) for row in rows]
    axis.bar(x, values, color=colors, alpha=0.86)
    axis.set_title(title)


def final_best_score(summary: dict[str, Any]) -> float | None:
    value = summary["final_population_ppa"]["best_score"]
    if value is None:
        return None
    return float(value)


def mean_required(rows: list[dict[str, str]], key: str) -> float:
    values = [parse_optional(row[key]) for row in rows]
    parsed = [value for value in values if value is not None]
    assert parsed
    return sum(parsed) / len(parsed)


def mean_values(values: list[float]) -> float | None:
    if not values:
        return None
    return sum(values) / len(values)


def plot_value(candidate: FamilyCandidate, metric: str, use_improvements: bool) -> float:
    if use_improvements:
        return candidate.improvements[metric]
    return candidate.ppa_metrics[metric]


def color_for_label(label: str) -> str:
    method = next(item for item in METHODS if item["label"] == label)
    return method["color"]


def short_problem_names() -> list[str]:
    return [
        "P150_fsmonehot",
        "P098_circuit7",
        "P135_m2014_q6b",
    ]


if __name__ == "__main__":
    raise SystemExit(main())
