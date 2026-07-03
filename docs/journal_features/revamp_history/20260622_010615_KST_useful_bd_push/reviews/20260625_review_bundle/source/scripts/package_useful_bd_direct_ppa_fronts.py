#!/usr/bin/env python3
"""Package direct PPA-front visualizations for useful-BD live runs."""

from __future__ import annotations

import argparse
import csv
from dataclasses import dataclass
import json
import math
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

from revolution.qd.pareto_analysis import (
    compute_candidate_improvements,
    objective_metrics_for_reference,
    pareto_front,
)

PROBLEMS = (
    "Prob045_alu",
    "Prob041_traffic_light",
    "Prob015_multi_pipe_8bit",
)


@dataclass(frozen=True)
class MethodSpec:
    method: str
    label: str
    source: str
    mode: str
    color: str


METHODS = (
    MethodSpec(
        "classic_revolution",
        "Classic",
        "t24",
        "classic_revolution/seed_1001/openai_gpt-oss-120b",
        "#4e79a7",
    ),
    MethodSpec(
        "landing_smooth_qd_manual_bd",
        "Manual BD",
        "t24",
        "landing_smooth_qd_manual_bd/seed_1001/openai_gpt-oss-120b",
        "#b07aa1",
    ),
    MethodSpec(
        "random_descriptor_qd",
        "Random",
        "t24",
        "random_descriptor_qd/seed_1001/openai_gpt-oss-120b",
        "#8c8c8c",
    ),
    MethodSpec(
        "sr_rff_pca_qd",
        "SR-RFF",
        "t24",
        "sr_rff_pca_qd/seed_1001/openai_gpt-oss-120b",
        "#f28e2b",
    ),
    MethodSpec(
        "sr_random_relu_pca_qd",
        "SR ReLU",
        "t24",
        "sr_random_relu_pca_qd/seed_1001/openai_gpt-oss-120b",
        "#17becf",
    ),
    MethodSpec(
        "sr_raw_pca_qd",
        "SR raw",
        "t24",
        "sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b",
        "#59a14f",
    ),
    MethodSpec(
        "guarded_sr_raw_pareto_qd",
        "Guarded SR raw",
        "t25",
        "guarded_sr_raw_pareto_qd/seed_1001/openai_gpt-oss-120b",
        "#9c755f",
    ),
    MethodSpec(
        "sr_raw_conservative_exploit_qd",
        "Conservative exploit",
        "t26",
        "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b",
        "#e15759",
    ),
)

KEY_METHODS = frozenset(
    {
        "classic_revolution",
        "landing_smooth_qd_manual_bd",
        "random_descriptor_qd",
        "sr_raw_pca_qd",
        "sr_raw_conservative_exploit_qd",
    }
)


@dataclass(frozen=True)
class GeneratedCandidate:
    candidate_id: str
    generation: int
    strategy: str
    status: str
    code_file_path: str


@dataclass(frozen=True)
class PpaCandidate:
    method: str
    method_label: str
    problem: str
    candidate_id: str
    generation: int
    strategy: str
    score: float
    ppa_metrics: dict[str, float]
    reference_metrics: dict[str, float]
    improvements: dict[str, float]
    objective_metrics: tuple[str, ...]
    is_area_power_front: bool
    is_active_objective_front: bool
    beats_reference: bool
    code_file_path: str


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
    problem_rows = problem_summary_rows(candidates)
    write_csv(table_dir / "candidate_ppa_points.csv", candidate_rows(candidates))
    write_csv(table_dir / "problem_front_counts.csv", problem_rows)
    write_csv(table_dir / "method_manifest.csv", manifest_rows(run_roots))
    write_figures(candidates, problem_rows, figure_dir)
    return 0


def collect_problem_candidates(
    run_roots: dict[str, Path],
    method: MethodSpec,
    problem: str,
) -> list[PpaCandidate]:
    problem_root = run_roots[method.source] / method.mode / "RTLLM" / problem
    summary = load_json(problem_root / f"{problem}_summary.json")
    ref_metrics = {
        key: float(value)
        for key, value in required_dict(summary["ref_ppa_metric"]).items()
    }
    objective_metrics = objective_metrics_for_reference(ref_metrics)
    generated_by_id: dict[str, GeneratedCandidate] = {}
    ppa_details: list[dict[str, Any]] = []

    for payload in load_jsonl(problem_root / "generation_log.jsonl"):
        generation = int(payload["generation"])
        for row in required_list(payload["generated_candidates"]):
            row_dict = required_dict(row)
            candidate_id = str(row_dict["id"])
            generated_by_id[candidate_id] = GeneratedCandidate(
                candidate_id=candidate_id,
                generation=generation,
                strategy=str(row_dict["strategy"]),
                status=str(row_dict["status"]),
                code_file_path=str(row_dict["code_file_path"]),
            )
        for detail in required_list(payload["population_ppa_details"]):
            ppa_details.append(required_dict(detail))

    candidates = []
    seen_ids: set[str] = set()
    for detail in ppa_details:
        candidate_id = str(detail["id"])
        if candidate_id in seen_ids:
            continue
        seen_ids.add(candidate_id)
        generated = generated_by_id[candidate_id]
        assert generated.status == "success"
        ppa_metrics = {
            key: float(value)
            for key, value in required_dict(detail["ppa_metrics"]).items()
        }
        improvements = compute_candidate_improvements(
            ppa_metrics,
            ref_metrics,
            objective_metrics,
        )
        assert improvements is not None
        candidates.append(
            PpaCandidate(
                method=method.method,
                method_label=method.label,
                problem=problem,
                candidate_id=candidate_id,
                generation=generated.generation,
                strategy=generated.strategy,
                score=float(detail["score"]),
                ppa_metrics=ppa_metrics,
                reference_metrics=ref_metrics,
                improvements=improvements,
                objective_metrics=objective_metrics,
                is_area_power_front=False,
                is_active_objective_front=False,
                beats_reference=beats_reference(improvements, objective_metrics),
                code_file_path=generated.code_file_path,
            )
        )

    area_power_ids = area_power_front_ids(candidates)
    active_ids = active_objective_front_ids(candidates, objective_metrics)
    return [
        PpaCandidate(
            method=candidate.method,
            method_label=candidate.method_label,
            problem=candidate.problem,
            candidate_id=candidate.candidate_id,
            generation=candidate.generation,
            strategy=candidate.strategy,
            score=candidate.score,
            ppa_metrics=candidate.ppa_metrics,
            reference_metrics=candidate.reference_metrics,
            improvements=candidate.improvements,
            objective_metrics=candidate.objective_metrics,
            is_area_power_front=candidate.candidate_id in area_power_ids,
            is_active_objective_front=candidate.candidate_id in active_ids,
            beats_reference=candidate.beats_reference,
            code_file_path=candidate.code_file_path,
        )
        for candidate in candidates
    ]


def area_power_front_ids(candidates: list[PpaCandidate]) -> set[str]:
    points: list[tuple[float, ...]] = [
        (-candidate.ppa_metrics["area"], -candidate.ppa_metrics["power"])
        for candidate in candidates
    ]
    return {candidates[index].candidate_id for index in pareto_front(points)}


def active_objective_front_ids(
    candidates: list[PpaCandidate],
    objective_metrics: tuple[str, ...],
) -> set[str]:
    points: list[tuple[float, ...]] = [
        tuple(candidate.improvements[metric] for metric in objective_metrics)
        for candidate in candidates
    ]
    return {candidates[index].candidate_id for index in pareto_front(points)}


def candidate_rows(candidates: list[PpaCandidate]) -> list[dict[str, str]]:
    return [
        {
            "method": candidate.method,
            "method_label": candidate.method_label,
            "problem": candidate.problem,
            "candidate_id": candidate.candidate_id,
            "generation": str(candidate.generation),
            "strategy": candidate.strategy,
            "score": fmt(candidate.score),
            "area": fmt(candidate.ppa_metrics["area"]),
            "power": fmt(candidate.ppa_metrics["power"]),
            "eff_clk_period": fmt(candidate.ppa_metrics.get("eff_clk_period", 0.0)),
            "g_A": fmt(candidate.improvements["area"]),
            "g_P": fmt(candidate.improvements["power"]),
            "g_T": fmt(candidate.improvements.get("eff_clk_period", 0.0)),
            "active_objectives": ";".join(candidate.objective_metrics),
            "is_area_power_front": str(candidate.is_area_power_front).lower(),
            "is_active_objective_front": str(candidate.is_active_objective_front).lower(),
            "beats_reference": str(candidate.beats_reference).lower(),
            "code_file_path": candidate.code_file_path,
        }
        for candidate in candidates
    ]


def problem_summary_rows(candidates: list[PpaCandidate]) -> list[dict[str, str]]:
    rows = []
    for method in METHODS:
        for problem in PROBLEMS:
            subset = [
                candidate
                for candidate in candidates
                if candidate.method == method.method and candidate.problem == problem
            ]
            area_power_front = [
                candidate for candidate in subset if candidate.is_area_power_front
            ]
            active_front = [
                candidate for candidate in subset if candidate.is_active_objective_front
            ]
            beating = [candidate for candidate in subset if candidate.beats_reference]
            rows.append(
                {
                    "method": method.method,
                    "method_label": method.label,
                    "problem": problem,
                    "valid_ppa_count": str(len(subset)),
                    "area_power_front_count": str(len(area_power_front)),
                    "active_objective_front_count": str(len(active_front)),
                    "reference_beating_count": str(len(beating)),
                    "best_score": fmt(max(candidate.score for candidate in subset)),
                    "min_area": fmt(min(candidate.ppa_metrics["area"] for candidate in subset)),
                    "min_power": fmt(min(candidate.ppa_metrics["power"] for candidate in subset)),
                    "min_eff_clk_period": fmt(
                        min(candidate.ppa_metrics.get("eff_clk_period", 0.0) for candidate in subset)
                    ),
                }
            )
    return rows


def manifest_rows(run_roots: dict[str, Path]) -> list[dict[str, str]]:
    return [
        {
            "method": method.method,
            "method_label": method.label,
            "source_run_root": str(run_roots[method.source]),
            "mode": method.mode,
        }
        for method in METHODS
    ]


def write_figures(
    candidates: list[PpaCandidate],
    problem_rows: list[dict[str, str]],
    figure_dir: Path,
) -> None:
    plot_fronts(
        candidates,
        figure_dir / "live_key_ppa_fronts_area_power.png",
        title="Useful-BD Live Screen: Key Method Area-Power Fronts",
        methods=[method for method in METHODS if method.method in KEY_METHODS],
        use_improvements=False,
        show_reference=True,
    )
    plot_fronts(
        candidates,
        figure_dir / "live_key_ppa_fronts_area_power_zoom.png",
        title="Useful-BD Live Screen: Key Method Area-Power Fronts (Candidate Zoom)",
        methods=[method for method in METHODS if method.method in KEY_METHODS],
        use_improvements=False,
        show_reference=False,
    )
    plot_fronts(
        candidates,
        figure_dir / "live_key_ppa_fronts_improvement.png",
        title="Useful-BD Live Screen: Key Method Improvement Fronts",
        methods=[method for method in METHODS if method.method in KEY_METHODS],
        use_improvements=True,
        show_reference=True,
    )
    plot_fronts(
        candidates,
        figure_dir / "live_all_ppa_fronts_area_power.png",
        title="Useful-BD Live Screen: All Method Area-Power Fronts",
        methods=list(METHODS),
        use_improvements=False,
        show_reference=True,
    )
    plot_fronts(
        candidates,
        figure_dir / "live_all_ppa_fronts_area_power_zoom.png",
        title="Useful-BD Live Screen: All Method Area-Power Fronts (Candidate Zoom)",
        methods=list(METHODS),
        use_improvements=False,
        show_reference=False,
    )
    plot_fronts(
        candidates,
        figure_dir / "live_all_ppa_fronts_improvement.png",
        title="Useful-BD Live Screen: All Method Improvement Fronts",
        methods=list(METHODS),
        use_improvements=True,
        show_reference=True,
    )
    plot_front_count_summary(problem_rows, figure_dir / "live_front_count_summary.png")


def plot_fronts(
    candidates: list[PpaCandidate],
    output_path: Path,
    *,
    title: str,
    methods: list[MethodSpec],
    use_improvements: bool,
    show_reference: bool,
) -> None:
    fig, axes = plt.subplots(1, len(PROBLEMS), figsize=(18.2, 5.6), sharey=False)
    for axis, problem in zip(axes, PROBLEMS, strict=True):
        subset = [candidate for candidate in candidates if candidate.problem == problem]
        reference = subset[0].reference_metrics
        if show_reference and use_improvements:
            axis.scatter(
                [0.0],
                [0.0],
                marker="*",
                s=130,
                color="#111111",
                edgecolors="white",
                linewidths=0.8,
                label="Reference",
                zorder=5,
            )
        elif show_reference:
            axis.scatter(
                [reference["area"]],
                [reference["power"]],
                marker="*",
                s=130,
                color="#111111",
                edgecolors="white",
                linewidths=0.8,
                label="Reference",
                zorder=5,
            )
        for method in methods:
            method_points = [candidate for candidate in subset if candidate.method == method.method]
            xs = [plot_value(candidate, "area", use_improvements) for candidate in method_points]
            ys = [plot_value(candidate, "power", use_improvements) for candidate in method_points]
            if use_improvements:
                front_flags = [
                    candidate.is_active_objective_front for candidate in method_points
                ]
            else:
                front_flags = [
                    candidate.is_area_power_front for candidate in method_points
                ]
            axis.scatter(
                xs,
                ys,
                s=34,
                color=method.color,
                alpha=0.36,
                edgecolors="none",
                label=method.label,
            )
            front_xs = [x for x, is_front in zip(xs, front_flags, strict=True) if is_front]
            front_ys = [y for y, is_front in zip(ys, front_flags, strict=True) if is_front]
            axis.scatter(
                front_xs,
                front_ys,
                s=86,
                facecolors="none",
                edgecolors=method.color,
                linewidths=1.8,
            )
        axis.set_title(problem.replace("Prob", "P"))
        axis.grid(color="#e5e5e5", linewidth=0.8)
        if use_improvements:
            axis.set_xlabel("Area improvement g_A (higher is better)")
        else:
            axis.set_xlabel("Area (lower is better)")
        if problem == PROBLEMS[0]:
            if use_improvements:
                axis.set_ylabel("Power improvement g_P (higher is better)")
            else:
                axis.set_ylabel("Power (lower is better)")
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(
        handles,
        labels,
        loc="upper center",
        bbox_to_anchor=(0.5, 0.93),
        ncol=5,
        frameon=False,
    )
    fig.suptitle(title, y=0.995)
    if use_improvements:
        note = "Open circles mark each method's active-objective rank-1 front. "
    else:
        note = "Lower-left is better. Open circles mark each method's raw area-power front. "
    if show_reference:
        note += "Reference star included; P015 also uses clock period as a third objective."
    else:
        note += "Candidate zoom omits the reference star so the area-power geometry stays readable."
    fig.text(0.5, 0.02, note, ha="center", fontsize=9, color="#444444")
    fig.tight_layout(rect=(0, 0.08, 1, 0.86))
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_front_count_summary(rows: list[dict[str, str]], output_path: Path) -> None:
    methods = list(METHODS)
    by_key = {(row["method"], row["problem"]): row for row in rows}
    x_positions = list(range(len(PROBLEMS)))
    width = 0.84 / len(methods)
    fig, axes = plt.subplots(1, 3, figsize=(18.6, 5.2))
    for axis, metric, title in (
        (axes[0], "area_power_front_count", "Raw Area-Power Front Points"),
        (axes[1], "active_objective_front_count", "Active-Objective Front Points"),
        (axes[2], "reference_beating_count", "Reference-Beating Candidates"),
    ):
        for method_index, method in enumerate(methods):
            offset = (method_index - (len(methods) - 1) / 2) * width
            values = [float(by_key[(method.method, problem)][metric]) for problem in PROBLEMS]
            axis.bar(
                [position + offset for position in x_positions],
                values,
                width,
                label=method.label,
                color=method.color,
                alpha=0.82,
            )
        axis.set_title(title)
        axis.set_xticks(x_positions)
        axis.set_xticklabels([problem.replace("Prob", "P") for problem in PROBLEMS])
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.8)
    axes[0].set_ylabel("Candidates")
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(
        handles,
        labels,
        loc="lower center",
        bbox_to_anchor=(0.5, 0.0),
        ncol=4,
        frameon=False,
    )
    fig.suptitle("Useful-BD Live Screen: Direct Front Count Summary", y=0.98)
    fig.tight_layout(rect=(0, 0.12, 1, 0.90))
    fig.savefig(output_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_value(candidate: PpaCandidate, metric: str, use_improvements: bool) -> float:
    if use_improvements:
        return candidate.improvements[metric]
    return candidate.ppa_metrics[metric]


def beats_reference(improvements: dict[str, float], objective_metrics: tuple[str, ...]) -> bool:
    values = [improvements[metric] for metric in objective_metrics]
    return all(value >= -1e-12 for value in values) and any(value > 1e-12 for value in values)


def required_dict(value: Any) -> dict[str, Any]:
    assert isinstance(value, dict)
    return value


def required_list(value: Any) -> list[Any]:
    assert isinstance(value, list)
    return value


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
    if math.isclose(value, 0.0, abs_tol=1e-12):
        return "0.000000"
    return f"{value:.6f}"


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    raise SystemExit(main())
