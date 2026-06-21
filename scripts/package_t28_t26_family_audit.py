#!/usr/bin/env python3
"""Package the T28 canonical family audit for the T26 active lead."""

from __future__ import annotations

import argparse
import csv
from collections import Counter
from dataclasses import dataclass
import hashlib
import json
import math
from pathlib import Path
import re
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

from revolution.qd.pareto_analysis import (
    compute_candidate_improvements,
    objective_metrics_for_reference,
    pareto_front,
)
from revolution.qd.ppa_visualization_export import BackendRun, export_qd_ppa_visualization

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
VIEWER_METHODS = ("classic_revolution", "sr_raw_conservative_exploit_qd")

COMMENT_RE = re.compile(r"/\*.*?\*/|//[^\n]*", re.DOTALL)
INSTANCE_RE = re.compile(
    r"^\s*([A-Za-z_][A-Za-z0-9_$]*)\s+(?:\\?[A-Za-z0-9_$.\[\]\\\\]+)\s*\(",
    re.MULTILINE,
)
NON_INSTANCE_KEYWORDS = {
    "module",
    "input",
    "output",
    "inout",
    "wire",
    "reg",
    "assign",
    "always",
    "initial",
    "parameter",
    "localparam",
}


@dataclass(frozen=True)
class GeneratedCandidate:
    candidate_id: str
    generation: int
    strategy: str
    status: str
    code_file_path: Path


@dataclass(frozen=True)
class FamilyCandidate:
    method: str
    method_label: str
    problem: str
    candidate_id: str
    generation: int
    strategy: str
    score: float
    ppa_metrics: dict[str, float]
    improvements: dict[str, float]
    code_file_path: Path
    rtl_hash: str
    netlist_hash: str
    family_hash: str
    family_signature: str
    is_front: bool
    beats_reference: bool


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

    candidates = [
        candidate
        for method in METHODS
        for problem in PROBLEMS
        for candidate in collect_problem_candidates(run_roots, method, problem)
    ]
    candidate_rows = candidate_table_rows(candidates)
    problem_rows = problem_metric_rows(candidates)
    aggregate_rows = aggregate_metric_rows(problem_rows)
    delta_rows = comparison_rows(aggregate_rows)

    write_csv(table_dir / "family_candidate_rows.csv", candidate_rows)
    write_csv(table_dir / "family_problem_metrics.csv", problem_rows)
    write_csv(table_dir / "family_aggregate_metrics.csv", aggregate_rows)
    write_csv(table_dir / "family_comparison_deltas.csv", delta_rows)
    write_csv(table_dir / "family_method_manifest.csv", manifest_rows(run_roots))
    write_figures(candidates, problem_rows, aggregate_rows, figure_dir)
    write_viewer_bundle(candidates, run_roots, args.output_dir)
    return 0


def collect_problem_candidates(
    run_roots: dict[str, Path],
    method: dict[str, str],
    problem: str,
) -> list[FamilyCandidate]:
    problem_root = run_roots[method["source"]] / method["mode"] / "RTLLM" / problem
    summary = load_json(problem_root / f"{problem}_summary.json")
    ref_metrics = summary["ref_ppa_metric"]
    assert isinstance(ref_metrics, dict)
    objective_metrics = objective_metrics_for_reference(ref_metrics)
    generated_by_id: dict[str, GeneratedCandidate] = {}
    ppa_details: list[tuple[int, dict[str, Any]]] = []

    for payload in load_jsonl(problem_root / "generation_log.jsonl"):
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


def candidate_table_rows(candidates: list[FamilyCandidate]) -> list[dict[str, str]]:
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


def problem_metric_rows(candidates: list[FamilyCandidate]) -> list[dict[str, str]]:
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


def metric_row(
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
        "unique_rtl_count": str(unique_count(candidates, "rtl_hash")),
        "unique_netlist_count": str(unique_count(candidates, "netlist_hash")),
        "unique_family_count": str(unique_count(candidates, "family_hash")),
        "front_unique_rtl_count": str(unique_count(front, "rtl_hash")),
        "front_unique_netlist_count": str(unique_count(front, "netlist_hash")),
        "front_unique_family_count": str(unique_count(front, "family_hash")),
        "reference_beating_unique_family_count": str(unique_count(beating, "family_hash")),
        "netlist_duplicate_count": str(valid_count - unique_count(candidates, "netlist_hash")),
        "family_duplicate_count": str(valid_count - unique_count(candidates, "family_hash")),
        "front_family_duplicate_count": str(front_count - unique_count(front, "family_hash")),
        "valid_family_ratio": fmt(ratio(unique_count(candidates, "family_hash"), valid_count)),
        "front_family_ratio": fmt(ratio(unique_count(front, "family_hash"), front_count)),
        "front_netlist_ratio": fmt(ratio(unique_count(front, "netlist_hash"), front_count)),
    }


def aggregate_metric_rows(problem_rows: list[dict[str, str]]) -> list[dict[str, str]]:
    rows = []
    for method in METHODS:
        subset = [row for row in problem_rows if row["method"] == method["method"]]
        valid_count = sum_int(subset, "valid_ppa_count")
        front_count = sum_int(subset, "ppa_front_count")
        unique_family = sum_int(subset, "unique_family_count")
        front_unique_family = sum_int(subset, "front_unique_family_count")
        front_unique_netlist = sum_int(subset, "front_unique_netlist_count")
        rows.append(
            {
                "method": method["method"],
                "method_label": method["label"],
                "problem_count": str(len(subset)),
                "valid_ppa_count": str(valid_count),
                "ppa_front_count": str(front_count),
                "unique_rtl_count": str(sum_int(subset, "unique_rtl_count")),
                "unique_netlist_count": str(sum_int(subset, "unique_netlist_count")),
                "unique_family_count": str(unique_family),
                "front_unique_rtl_count": str(sum_int(subset, "front_unique_rtl_count")),
                "front_unique_netlist_count": str(front_unique_netlist),
                "front_unique_family_count": str(front_unique_family),
                "reference_beating_unique_family_count": str(
                    sum_int(subset, "reference_beating_unique_family_count")
                ),
                "netlist_duplicate_count": str(sum_int(subset, "netlist_duplicate_count")),
                "family_duplicate_count": str(sum_int(subset, "family_duplicate_count")),
                "front_family_duplicate_count": str(
                    sum_int(subset, "front_family_duplicate_count")
                ),
                "valid_family_ratio": fmt(ratio(unique_family, valid_count)),
                "front_family_ratio": fmt(ratio(front_unique_family, front_count)),
                "front_netlist_ratio": fmt(ratio(front_unique_netlist, front_count)),
            }
        )
    return rows


def comparison_rows(aggregate_rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_method = {row["method"]: row for row in aggregate_rows}
    metrics = (
        "unique_family_count",
        "front_unique_family_count",
        "front_unique_netlist_count",
        "reference_beating_unique_family_count",
        "family_duplicate_count",
        "front_family_ratio",
        "valid_family_ratio",
    )
    output = []
    method = "sr_raw_conservative_exploit_qd"
    for reference in (
        "classic_revolution",
        "landing_smooth_qd_manual_bd",
        "random_descriptor_qd",
        "sr_raw_pca_qd",
        "guarded_sr_raw_pareto_qd",
    ):
        for metric in metrics:
            value = float(by_method[method][metric])
            ref_value = float(by_method[reference][metric])
            output.append(
                {
                    "method": method,
                    "method_label": by_method[method]["method_label"],
                    "reference": reference,
                    "reference_label": by_method[reference]["method_label"],
                    "metric": metric,
                    "value": fmt(value),
                    "reference_value": fmt(ref_value),
                    "delta": fmt(value - ref_value),
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


def write_figures(
    candidates: list[FamilyCandidate],
    problem_rows: list[dict[str, str]],
    aggregate_rows_: list[dict[str, str]],
    figure_dir: Path,
) -> None:
    plot_aggregate_family(aggregate_rows_, figure_dir / "family_aggregate_counts.png")
    plot_problem_family(problem_rows, figure_dir / "family_problem_front_counts.png")
    plot_ppa_fronts(
        candidates,
        figure_dir / "ppa_pareto_fronts_area_power.png",
        x_metric="area",
        y_metric="power",
        x_label="Area (lower is better)",
        y_label="Power (lower is better)",
        title="T28 PPA Pareto Fronts: Raw Area-Power Projection",
        use_improvements=False,
    )
    plot_ppa_fronts(
        candidates,
        figure_dir / "ppa_pareto_fronts_improvement.png",
        x_metric="area",
        y_metric="power",
        x_label="Area improvement g_A (higher is better)",
        y_label="Power improvement g_P (higher is better)",
        title="T28 PPA Pareto Fronts: Normalized Improvement Projection",
        use_improvements=True,
    )


def plot_aggregate_family(rows: list[dict[str, str]], output_path: Path) -> None:
    labels = [row["method_label"] for row in rows]
    x = list(range(len(rows)))
    fig, axes = plt.subplots(1, 3, figsize=(16.8, 4.8))
    aggregate_panel(axes[0], rows, x, "front_unique_family_count", "Front Families")
    aggregate_panel(axes[1], rows, x, "front_unique_netlist_count", "Front Netlists")
    aggregate_panel(axes[2], rows, x, "valid_family_ratio", "Valid Family Ratio")
    for axis in axes:
        axis.set_xticks(x)
        axis.set_xticklabels(labels, rotation=25, ha="right")
        axis.grid(axis="y", color="#e3e3e3", linewidth=0.8)
    fig.suptitle("T28 Canonical Family Audit Aggregate", y=1.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_problem_family(rows: list[dict[str, str]], output_path: Path) -> None:
    methods = [method["label"] for method in METHODS]
    by_key = {(row["method_label"], row["problem"]): row for row in rows}
    x_positions = list(range(len(PROBLEMS)))
    width = 0.84 / len(methods)
    fig, axes = plt.subplots(1, 3, figsize=(17.8, 5.0))
    problem_panel(
        axes[0],
        methods,
        by_key,
        x_positions,
        width,
        "front_unique_family_count",
        "Front Families",
    )
    problem_panel(
        axes[1],
        methods,
        by_key,
        x_positions,
        width,
        "front_unique_netlist_count",
        "Front Netlists",
    )
    problem_panel(
        axes[2],
        methods,
        by_key,
        x_positions,
        width,
        "front_family_ratio",
        "Front Family Ratio",
    )
    for axis in axes:
        axis.set_xticks(x_positions)
        axis.set_xticklabels([problem.replace("Prob", "P") for problem in PROBLEMS], rotation=25, ha="right")
        axis.grid(axis="y", color="#e3e3e3", linewidth=0.8)
        axis.legend(frameon=False, fontsize=7)
    fig.suptitle("T28 Canonical Family Audit By Problem", y=1.02)
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
    values = [float(row[metric]) for row in rows]
    colors = [COLORS[row["method_label"]] for row in rows]
    axis.bar(x, values, color=colors, alpha=0.84)
    axis.set_title(title)


def problem_panel(
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
        values = [float(by_key[(method, problem)][metric]) for problem in PROBLEMS]
        axis.bar(
            [position + offset for position in x_positions],
            values,
            width,
            label=method,
            color=COLORS[method],
            alpha=0.82,
        )
    axis.set_title(title)


def plot_ppa_fronts(
    candidates: list[FamilyCandidate],
    output_path: Path,
    *,
    x_metric: str,
    y_metric: str,
    x_label: str,
    y_label: str,
    title: str,
    use_improvements: bool,
) -> None:
    methods = [method["label"] for method in METHODS]
    fig, axes = plt.subplots(1, len(PROBLEMS), figsize=(17.6, 5.2), sharey=False)
    for axis, problem in zip(axes, PROBLEMS, strict=True):
        subset = [candidate for candidate in candidates if candidate.problem == problem]
        for method in methods:
            method_points = [candidate for candidate in subset if candidate.method_label == method]
            xs = [plot_value(candidate, x_metric, use_improvements) for candidate in method_points]
            ys = [plot_value(candidate, y_metric, use_improvements) for candidate in method_points]
            front_flags = [candidate.is_front for candidate in method_points]
            axis.scatter(
                xs,
                ys,
                s=40,
                color=COLORS[method],
                alpha=0.44,
                edgecolors="none",
                label=method,
            )
            front_xs = [x for x, is_front in zip(xs, front_flags, strict=True) if is_front]
            front_ys = [y for y, is_front in zip(ys, front_flags, strict=True) if is_front]
            axis.scatter(
                front_xs,
                front_ys,
                s=92,
                facecolors="none",
                edgecolors=COLORS[method],
                linewidths=1.8,
            )
        axis.set_title(problem.replace("Prob", "P"))
        axis.set_xlabel(x_label)
        axis.grid(color="#e5e5e5", linewidth=0.8)
        if not use_improvements:
            axis.invert_xaxis()
            axis.invert_yaxis()
        if problem == PROBLEMS[0]:
            axis.set_ylabel(y_label)
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(
        handles,
        labels,
        loc="upper center",
        bbox_to_anchor=(0.5, 0.93),
        ncol=6,
        frameon=False,
    )
    fig.suptitle(title, y=0.995)
    fig.text(
        0.5,
        0.02,
        "Open circles mark each method's active-objective rank-1 PPA front. "
        "P015 also uses clock period in the front; use the HTML viewer for the 3D view.",
        ha="center",
        fontsize=9,
        color="#444444",
    )
    fig.tight_layout(rect=(0, 0.08, 1, 0.88))
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_value(candidate: FamilyCandidate, metric: str, use_improvements: bool) -> float:
    if use_improvements:
        return candidate.improvements[metric]
    return candidate.ppa_metrics[metric]


def write_viewer_bundle(
    candidates: list[FamilyCandidate],
    run_roots: dict[str, Path],
    output_dir: Path,
) -> None:
    source_root = output_dir / "visualizations" / "qd_ppa_viewer_source"
    viewer_root = output_dir / "visualizations" / "qd_ppa_viewer"
    viewer_candidates = [
        candidate for candidate in candidates if candidate.method in VIEWER_METHODS
    ]
    write_viewer_source_tables(viewer_candidates, run_roots, source_root)
    backend_runs = tuple(
        BackendRun(
            name=viewer_backend_name(method["method"]),
            path=run_roots[method["source"]] / method["mode"],
        )
        for method in METHODS
        if method["method"] in VIEWER_METHODS
    )
    export_qd_ppa_visualization(
        run_root=source_root,
        backend_runs=backend_runs,
        archive_source_backend="sr_raw_conservative_exploit_qd",
        output_dir=viewer_root,
        subset_config=None,
        selected_problem=None,
        asset_mode="inline",
        strict=True,
        recover_classic_descriptors=False,
    )


def write_viewer_source_tables(
    candidates: list[FamilyCandidate],
    run_roots: dict[str, Path],
    source_root: Path,
) -> None:
    data_dir = source_root / "final_analysis" / "ppa_distribution" / "data"
    design_dir = source_root / "final_analysis" / "design_space_analysis"
    data_dir.mkdir(parents=True, exist_ok=True)
    design_dir.mkdir(parents=True, exist_ok=True)
    references = reference_metrics_by_problem(run_roots)
    write_csv(data_dir / "ppa_candidates.csv", ppa_viewer_rows(candidates, references))
    write_csv(
        data_dir / "reference_ppa_metrics.csv",
        reference_viewer_rows(references),
    )
    write_csv(
        design_dir / "successful_candidates.csv",
        design_space_viewer_rows(candidates),
    )


def ppa_viewer_rows(
    candidates: list[FamilyCandidate],
    references: dict[str, dict[str, float]],
) -> list[dict[str, str]]:
    rows = []
    for candidate in candidates:
        ref = references[candidate.problem]
        rows.append(
            {
                "backend": viewer_backend_name(candidate.method),
                "benchmark": "RTLLM",
                "problem": candidate.problem,
                "circuit_type": circuit_type(ref),
                "generation": str(candidate.generation),
                "candidate_id": candidate.candidate_id,
                "strategy": candidate.strategy,
                "source": "t28_family_audit",
                "score_from_run": fmt(candidate.score),
                "ppa_score": fmt(candidate.score),
                "area": fmt(candidate.ppa_metrics["area"]),
                "power": fmt(candidate.ppa_metrics["power"]),
                "eff_clk_period": fmt(candidate.ppa_metrics.get("eff_clk_period", 0.0)),
                "ref_area": fmt(ref["area"]),
                "ref_power": fmt(ref["power"]),
                "ref_eff_clk_period": fmt(ref.get("eff_clk_period", 0.0)),
                "g_A": fmt(candidate.improvements["area"]),
                "g_P": fmt(candidate.improvements["power"]),
                "g_T": fmt(candidate.improvements.get("eff_clk_period", 0.0)),
                "candidate_dir": str(candidate.code_file_path.parent),
                "code_file_path": str(candidate.code_file_path),
                "report_path": "",
            }
        )
    return rows


def reference_viewer_rows(references: dict[str, dict[str, float]]) -> list[dict[str, str]]:
    return [
        {
            "benchmark": "RTLLM",
            "problem": problem,
            "circuit_type": circuit_type(ref),
            "ref_area": fmt(ref["area"]),
            "ref_power": fmt(ref["power"]),
            "ref_eff_clk_period": fmt(ref.get("eff_clk_period", 0.0)),
            "summary_path": "",
        }
        for problem, ref in sorted(references.items())
    ]


def design_space_viewer_rows(candidates: list[FamilyCandidate]) -> list[dict[str, str]]:
    rows = []
    for candidate in candidates:
        descriptors = descriptor_values(candidate)
        rows.append(
            {
                "backend": viewer_backend_name(candidate.method),
                "benchmark": "RTLLM",
                "problem": candidate.problem,
                "candidate_id": candidate.candidate_id,
                "quality_score": fmt(candidate.score),
                "candidate_dir": str(candidate.code_file_path.parent),
                "code_file_path": str(candidate.code_file_path),
                "sr_pca_0": fmt_optional(descriptors.get("sr_pca_0")),
                "sr_pca_1": fmt_optional(descriptors.get("sr_pca_1")),
                "sr_pca_2": fmt_optional(descriptors.get("sr_pca_2")),
            }
        )
    return rows


def descriptor_values(candidate: FamilyCandidate) -> dict[str, float]:
    event_path = candidate.code_file_path.with_name("qd_archive_event.json")
    if not event_path.is_file():
        return {}
    raw = load_json(event_path).get("descriptor_values", {})
    assert isinstance(raw, dict)
    return {key: float(value) for key, value in raw.items()}


def viewer_backend_name(method: str) -> str:
    if method == "classic_revolution":
        return "classic"
    return method


def reference_metrics_by_problem(run_roots: dict[str, Path]) -> dict[str, dict[str, float]]:
    method = next(item for item in METHODS if item["method"] == "classic_revolution")
    references = {}
    for problem in PROBLEMS:
        summary_path = (
            run_roots[method["source"]]
            / method["mode"]
            / "RTLLM"
            / problem
            / f"{problem}_summary.json"
        )
        ref = load_json(summary_path)["ref_ppa_metric"]
        assert isinstance(ref, dict)
        references[problem] = {
            "area": float(ref["area"]),
            "power": float(ref["power"]),
            "eff_clk_period": float(ref.get("eff_clk_period", 0.0)),
        }
    return references


def circuit_type(reference: dict[str, float]) -> str:
    return "sequential" if reference.get("eff_clk_period", 0.0) > 0.0 else "combinational"


def synthesized_cell_counts(netlist_path: Path) -> Counter[str]:
    counts: Counter[str] = Counter()
    text = netlist_path.read_text(encoding="utf-8")
    for match in INSTANCE_RE.finditer(text):
        cell_type = match.group(1)
        if cell_type in NON_INSTANCE_KEYWORDS:
            continue
        counts[cell_type] += 1
    assert counts
    return counts


def family_signature(cell_counts: Counter[str]) -> str:
    return "|".join(f"{cell_type}:{cell_counts[cell_type]}" for cell_type in sorted(cell_counts))


def normalized_verilog(path: Path) -> str:
    text = path.read_text(encoding="utf-8")
    text = COMMENT_RE.sub(" ", text)
    return " ".join(text.split())


def hash_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def unique_count(candidates: list[FamilyCandidate], attr: str) -> int:
    return len({str(getattr(candidate, attr)) for candidate in candidates})


def beats_reference(improvements: dict[str, float], objective_metrics: tuple[str, ...]) -> bool:
    values = [improvements[metric] for metric in objective_metrics]
    return all(value >= -1e-12 for value in values) and any(value > 1e-12 for value in values)


def ratio(numerator: int, denominator: int) -> float:
    if denominator == 0:
        return 0.0
    return numerator / denominator


def sum_int(rows: list[dict[str, str]], key: str) -> int:
    return sum(int(row[key]) for row in rows)


def relative_delta(value: float, reference: float) -> float | None:
    if math.isclose(reference, 0.0):
        return None
    return (value - reference) / abs(reference)


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        payload = json.loads(line)
        assert isinstance(payload, dict)
        rows.append(payload)
    return rows


def fmt(value: float) -> str:
    return f"{value:.6f}"


def fmt_optional(value: float | None) -> str:
    if value is None:
        return ""
    return fmt(value)


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    raise SystemExit(main())
