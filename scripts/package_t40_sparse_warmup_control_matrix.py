#!/usr/bin/env python3
"""Package the T40 sparse-warmup control matrix."""

from __future__ import annotations

import argparse
import csv
from dataclasses import dataclass
import json
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
        "t40",
        "classic_revolution/seed_1001/openai_gpt-oss-120b",
        "#1f77b4",
    ),
    MethodSpec(
        "manual_sparse_pareto_qd",
        "Manual BD",
        "t40",
        "manual_sparse_pareto_qd/seed_1001/openai_gpt-oss-120b",
        "#9467bd",
    ),
    MethodSpec(
        "random_sparse_elite_slot_qd",
        "Random one-slot",
        "t40",
        "random_sparse_elite_slot_qd/seed_1001/openai_gpt-oss-120b",
        "#7f7f7f",
    ),
    MethodSpec(
        "graph_full_pareto_sparse_qd",
        "Graph full Pareto",
        "t40",
        "graph_full_pareto_sparse_qd/seed_1001/openai_gpt-oss-120b",
        "#ff7f0e",
    ),
    MethodSpec(
        "t39_sparse_warmup_elite_slot_qd",
        "T39 one-slot",
        "t39",
        "sparse_warmup_elite_slot_qd/seed_1001/openai_gpt-oss-120b",
        "#2ca02c",
    ),
)


@dataclass(frozen=True)
class Candidate:
    method: str
    method_label: str
    problem: str
    candidate_id: str
    generation: int
    strategy: str
    score: float
    area: float
    power: float
    eff_clk_period: float
    g_a: float
    g_p: float
    g_t: float
    objective_metrics: tuple[str, ...]
    is_area_power_front: bool
    is_active_objective_front: bool
    is_pooled_area_power_front: bool
    code_file_path: str


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--t40-run-root", required=True, type=Path)
    parser.add_argument("--t39-run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    roots = {"t40": args.t40_run_root, "t39": args.t39_run_root}
    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    viewer_dir = args.output_dir / "visualizations" / "direct_ppa_pareto"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    viewer_dir.mkdir(parents=True, exist_ok=True)

    candidates = [
        candidate
        for method in METHODS
        for problem in PROBLEMS
        for candidate in collect_candidates(roots, method, problem)
    ]
    candidates = mark_pooled_fronts(candidates)
    summary_rows = problem_summary_rows(candidates, METHODS)
    write_csv(table_dir / "t40_candidate_ppa_points.csv", candidate_rows(candidates))
    write_csv(table_dir / "t40_problem_method_summary.csv", summary_rows)
    write_csv(table_dir / "t40_method_manifest.csv", manifest_rows(roots, METHODS))
    plot_raw_fronts(
        candidates,
        figure_dir / "t40_raw_area_power_fronts.png",
        METHODS,
        "T40 Sparse-Warmup Control Matrix",
    )
    plot_count_summary(
        summary_rows,
        figure_dir / "t40_front_count_summary.png",
        METHODS,
        "T40 Sparse-Warmup Control Matrix",
    )
    write_viewer(
        viewer_dir / "index.html",
        summary_rows,
        title="T40 Direct PPA Fronts",
        image_name="t40_raw_area_power_fronts.png",
    )
    (viewer_dir / "metrics.json").write_text(
        json.dumps(summary_rows, indent=2) + "\n",
        encoding="utf-8",
    )
    return 0


def collect_candidates(
    roots: dict[str, Path],
    method: MethodSpec,
    problem: str,
) -> list[Candidate]:
    problem_root = roots[method.source] / method.mode / "RTLLM" / problem
    summary = load_json(problem_root / f"{problem}_summary.json")
    ref_metrics = {key: float(value) for key, value in summary["ref_ppa_metric"].items()}
    objective_metrics = objective_metrics_for_reference(ref_metrics)
    generated = generated_candidates(problem_root / "generation_log.jsonl")
    details = ppa_details(problem_root / "generation_log.jsonl")
    candidates = []
    seen_ids: set[str] = set()
    for detail in details:
        candidate_id = str(detail["id"])
        if candidate_id in seen_ids:
            continue
        seen_ids.add(candidate_id)
        ppa_metrics = detail["ppa_metrics"]
        improvements = compute_candidate_improvements(
            ppa_metrics,
            ref_metrics,
            objective_metrics,
        )
        assert improvements is not None
        metadata = generated[candidate_id]
        candidates.append(
            Candidate(
                method=method.method,
                method_label=method.label,
                problem=problem,
                candidate_id=candidate_id,
                generation=int(metadata["generation"]),
                strategy=str(metadata["strategy"]),
                score=float(detail["score"]),
                area=float(ppa_metrics["area"]),
                power=float(ppa_metrics["power"]),
                eff_clk_period=float(ppa_metrics.get("eff_clk_period", 0.0)),
                g_a=float(improvements["area"]),
                g_p=float(improvements["power"]),
                g_t=float(improvements.get("eff_clk_period", 0.0)),
                objective_metrics=objective_metrics,
                is_area_power_front=False,
                is_active_objective_front=False,
                is_pooled_area_power_front=False,
                code_file_path=str(metadata["code_file_path"]),
            )
        )
    area_power_front = front_ids(candidates, ("area", "power"), raw=True)
    active_front = front_ids(candidates, objective_metrics, raw=False)
    return [
        replace_front_flags(
            candidate,
            is_area_power_front=candidate.candidate_id in area_power_front,
            is_active_objective_front=candidate.candidate_id in active_front,
            is_pooled_area_power_front=False,
        )
        for candidate in candidates
    ]


def generated_candidates(path: Path) -> dict[str, dict[str, str | int]]:
    rows: dict[str, dict[str, str | int]] = {}
    for payload in load_jsonl(path):
        for row in payload["generated_candidates"]:
            rows[str(row["id"])] = {
                "generation": int(payload["generation"]),
                "strategy": str(row["strategy"]),
                "code_file_path": str(row["code_file_path"]),
            }
    return rows


def ppa_details(path: Path) -> list[dict[str, Any]]:
    rows = []
    for payload in load_jsonl(path):
        rows.extend(payload["population_ppa_details"])
    return rows


def mark_pooled_fronts(candidates: list[Candidate]) -> list[Candidate]:
    front_keys: set[tuple[str, str]] = set()
    for problem in PROBLEMS:
        subset = [candidate for candidate in candidates if candidate.problem == problem]
        for candidate_id in front_ids(subset, ("area", "power"), raw=True):
            front_keys.add((problem, candidate_id))
    return [
        replace_front_flags(
            candidate,
            is_area_power_front=candidate.is_area_power_front,
            is_active_objective_front=candidate.is_active_objective_front,
            is_pooled_area_power_front=(candidate.problem, candidate.candidate_id)
            in front_keys,
        )
        for candidate in candidates
    ]


def replace_front_flags(
    candidate: Candidate,
    *,
    is_area_power_front: bool,
    is_active_objective_front: bool,
    is_pooled_area_power_front: bool,
) -> Candidate:
    return Candidate(
        method=candidate.method,
        method_label=candidate.method_label,
        problem=candidate.problem,
        candidate_id=candidate.candidate_id,
        generation=candidate.generation,
        strategy=candidate.strategy,
        score=candidate.score,
        area=candidate.area,
        power=candidate.power,
        eff_clk_period=candidate.eff_clk_period,
        g_a=candidate.g_a,
        g_p=candidate.g_p,
        g_t=candidate.g_t,
        objective_metrics=candidate.objective_metrics,
        is_area_power_front=is_area_power_front,
        is_active_objective_front=is_active_objective_front,
        is_pooled_area_power_front=is_pooled_area_power_front,
        code_file_path=candidate.code_file_path,
    )


def front_ids(
    candidates: list[Candidate],
    metrics: tuple[str, ...],
    *,
    raw: bool,
) -> set[str]:
    if not candidates:
        return set()
    points = [tuple(front_value(candidate, metric, raw) for metric in metrics) for candidate in candidates]
    return {candidates[index].candidate_id for index in pareto_front(points)}


def front_value(candidate: Candidate, metric: str, raw: bool) -> float:
    if raw and metric == "area":
        return -candidate.area
    if raw and metric == "power":
        return -candidate.power
    if metric == "area":
        return candidate.g_a
    if metric == "power":
        return candidate.g_p
    if metric == "eff_clk_period":
        return candidate.g_t
    raise ValueError(f"Unsupported metric '{metric}'.")


def candidate_rows(candidates: list[Candidate]) -> list[dict[str, str]]:
    return [
        {
            "method": candidate.method,
            "method_label": candidate.method_label,
            "problem": candidate.problem,
            "candidate_id": candidate.candidate_id,
            "generation": str(candidate.generation),
            "strategy": candidate.strategy,
            "score": fmt(candidate.score),
            "area": fmt(candidate.area),
            "power": fmt(candidate.power),
            "eff_clk_period": fmt(candidate.eff_clk_period),
            "g_A": fmt(candidate.g_a),
            "g_P": fmt(candidate.g_p),
            "g_T": fmt(candidate.g_t),
            "active_objectives": ";".join(candidate.objective_metrics),
            "is_area_power_front": str(candidate.is_area_power_front).lower(),
            "is_active_objective_front": str(candidate.is_active_objective_front).lower(),
            "is_pooled_area_power_front": str(candidate.is_pooled_area_power_front).lower(),
            "code_file_path": candidate.code_file_path,
        }
        for candidate in candidates
    ]


def problem_summary_rows(
    candidates: list[Candidate],
    methods: tuple[MethodSpec, ...],
) -> list[dict[str, str]]:
    rows = []
    for method in methods:
        for problem in PROBLEMS:
            subset = [
                candidate
                for candidate in candidates
                if candidate.method == method.method and candidate.problem == problem
            ]
            assert subset
            rows.append(
                {
                    "method": method.method,
                    "method_label": method.label,
                    "problem": problem,
                    "valid_ppa_count": str(len(subset)),
                    "area_power_front_count": str(
                        sum(candidate.is_area_power_front for candidate in subset)
                    ),
                    "active_objective_front_count": str(
                        sum(candidate.is_active_objective_front for candidate in subset)
                    ),
                    "pooled_area_power_front_count": str(
                        sum(candidate.is_pooled_area_power_front for candidate in subset)
                    ),
                    "best_score": fmt(max(candidate.score for candidate in subset)),
                    "min_area": fmt(min(candidate.area for candidate in subset)),
                    "min_power": fmt(min(candidate.power for candidate in subset)),
                }
            )
    return rows


def manifest_rows(
    roots: dict[str, Path],
    methods: tuple[MethodSpec, ...],
) -> list[dict[str, str]]:
    return [
        {
            "method": method.method,
            "method_label": method.label,
            "source_run_root": str(roots[method.source]),
            "mode": method.mode,
        }
        for method in methods
    ]


def plot_raw_fronts(
    candidates: list[Candidate],
    path: Path,
    methods: tuple[MethodSpec, ...],
    title: str,
) -> None:
    fig, axes = plt.subplots(1, len(PROBLEMS), figsize=(18.4, 6.4), sharey=False)
    for axis, problem in zip(axes, PROBLEMS, strict=True):
        subset = [candidate for candidate in candidates if candidate.problem == problem]
        for method in methods:
            method_points = [candidate for candidate in subset if candidate.method == method.method]
            axis.scatter(
                [candidate.area for candidate in method_points],
                [candidate.power for candidate in method_points],
                s=34,
                color=method.color,
                alpha=0.32,
                edgecolors="none",
                label=method.label,
            )
            front = [candidate for candidate in method_points if candidate.is_area_power_front]
            axis.scatter(
                [candidate.area for candidate in front],
                [candidate.power for candidate in front],
                s=86,
                facecolors="none",
                edgecolors=method.color,
                linewidths=1.8,
            )
        pooled = [candidate for candidate in subset if candidate.is_pooled_area_power_front]
        axis.scatter(
            [candidate.area for candidate in pooled],
            [candidate.power for candidate in pooled],
            s=120,
            marker="*",
            color="#111111",
            linewidths=0.0,
            label="Pooled front",
        )
        axis.set_title(problem.replace("Prob", "P"))
        axis.set_xlabel("Area (lower is better)")
        axis.grid(color="#e5e7eb", linewidth=0.8)
    axes[0].set_ylabel("Power (lower is better)")
    handles, labels = axes[0].get_legend_handles_labels()
    fig.suptitle(f"{title}: Raw Area-Power Fronts", y=0.985)
    fig.legend(
        handles,
        labels,
        loc="upper center",
        bbox_to_anchor=(0.5, 0.925),
        ncol=6,
        frameon=False,
    )
    fig.text(
        0.5,
        0.02,
        "Lower-left is better. Open circles mark each method's raw area-power front; "
        "black stars mark the pooled front across methods.",
        ha="center",
        fontsize=9,
        color="#444444",
    )
    fig.tight_layout(rect=(0, 0.08, 1, 0.82))
    fig.savefig(path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_count_summary(
    rows: list[dict[str, str]],
    path: Path,
    methods: tuple[MethodSpec, ...],
    title: str,
) -> None:
    x_positions = list(range(len(PROBLEMS)))
    width = 0.84 / len(methods)
    fig, axes = plt.subplots(1, 2, figsize=(17.8, 5.2), sharey=False)
    row_by_key = {(row["method"], row["problem"]): row for row in rows}
    for axis, metric, panel_title in (
        (axes[0], "valid_ppa_count", "Valid PPA Candidates"),
        (axes[1], "pooled_area_power_front_count", "Pooled Front Hits"),
    ):
        for method_index, method in enumerate(methods):
            offset = (method_index - (len(methods) - 1) / 2) * width
            axis.bar(
                [position + offset for position in x_positions],
                [float(row_by_key[(method.method, problem)][metric]) for problem in PROBLEMS],
                width,
                color=method.color,
                alpha=0.82,
                label=method.label,
            )
        axis.set_title(panel_title)
        axis.set_xticks(x_positions)
        axis.set_xticklabels([problem.replace("Prob", "P") for problem in PROBLEMS])
        axis.grid(axis="y", color="#e5e7eb", linewidth=0.8)
    axes[0].set_ylabel("Candidates")
    handles, labels = axes[0].get_legend_handles_labels()
    fig.legend(
        handles,
        labels,
        loc="lower center",
        bbox_to_anchor=(0.5, 0),
        ncol=5,
        frameon=False,
    )
    fig.suptitle(f"{title}: Direct PPA Counts", y=0.98)
    fig.tight_layout(rect=(0, 0.13, 1, 0.90))
    fig.savefig(path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def write_viewer(
    path: Path,
    rows: list[dict[str, str]],
    *,
    title: str,
    image_name: str,
) -> None:
    table_rows = "\n".join(
        "<tr>"
        f"<td>{row['method_label']}</td>"
        f"<td>{row['problem']}</td>"
        f"<td>{row['valid_ppa_count']}</td>"
        f"<td>{row['area_power_front_count']}</td>"
        f"<td>{row['pooled_area_power_front_count']}</td>"
        f"<td>{row['best_score']}</td>"
        "</tr>"
        for row in rows
    )
    path.write_text(
        f"""<!doctype html>
<html lang=\"en\">
<head>
  <meta charset=\"utf-8\">
  <title>{title}</title>
  <style>
    body {{ font-family: Inter, system-ui, sans-serif; margin: 28px; color: #111827; }}
    img {{ max-width: 100%; border: 1px solid #d1d5db; }}
    table {{ border-collapse: collapse; margin-top: 18px; }}
    th, td {{ border-bottom: 1px solid #d1d5db; padding: 8px 12px; text-align: right; }}
    th:first-child, td:first-child {{ text-align: left; }}
  </style>
</head>
<body>
  <h1>{title}</h1>
  <img src=\"../../figures/{image_name}\" alt=\"{title}\">
  <table>
    <thead>
      <tr><th>Method</th><th>Problem</th><th>Valid PPA</th><th>Method front</th><th>Pooled front</th><th>Best score</th></tr>
    </thead>
    <tbody>
      {table_rows}
    </tbody>
  </table>
</body>
</html>
""",
        encoding="utf-8",
    )


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        payload = json.loads(line)
        assert isinstance(payload, dict)
        rows.append(payload)
    return rows


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def fmt(value: float) -> str:
    return f"{value:.12g}"


if __name__ == "__main__":
    raise SystemExit(main())
