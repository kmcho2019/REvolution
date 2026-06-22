#!/usr/bin/env python3
"""Package the T38 elite-Pareto-slot live arm."""

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
MODE_ROOT = Path("elite_pareto_slot_qd/seed_1001/openai_gpt-oss-120b/RTLLM")


@dataclass(frozen=True)
class PackageConfig:
    mode_root: Path
    file_prefix: str
    plot_title_prefix: str
    viewer_title: str


@dataclass(frozen=True)
class Candidate:
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
    is_front: bool
    is_global_front: bool
    is_archive_member: bool
    code_file_path: str


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--mode-root", type=Path, default=MODE_ROOT)
    parser.add_argument("--file-prefix", default="t38_live")
    parser.add_argument("--plot-title-prefix", default="T38 Elite Pareto Slot")
    parser.add_argument(
        "--viewer-title",
        default="T38 Elite Pareto Slot Direct PPA Fronts",
    )
    args = parser.parse_args(argv)
    config = PackageConfig(
        mode_root=args.mode_root,
        file_prefix=args.file_prefix,
        plot_title_prefix=args.plot_title_prefix,
        viewer_title=args.viewer_title,
    )

    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    viewer_dir = args.output_dir / "visualizations" / "direct_ppa_pareto"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    viewer_dir.mkdir(parents=True, exist_ok=True)

    candidates: list[Candidate] = []
    archive_rows: list[dict[str, str]] = []
    for problem in PROBLEMS:
        problem_root = args.run_root / config.mode_root / problem
        problem_candidates = collect_candidates(problem_root, problem)
        candidates.extend(problem_candidates)
        archive_rows.append(
            archive_summary_row(problem_root, problem, problem_candidates)
        )

    write_csv(
        table_dir / f"{config.file_prefix}_candidate_ppa_points.csv",
        candidate_rows(candidates),
    )
    write_csv(
        table_dir / f"{config.file_prefix}_problem_summary.csv",
        problem_summary_rows(candidates, archive_rows),
    )
    write_csv(table_dir / f"{config.file_prefix}_archive_summary.csv", archive_rows)
    plot_raw_fronts(
        candidates,
        figure_dir / f"{config.file_prefix}_raw_area_power_fronts.png",
        config,
    )
    plot_improvement_fronts(
        candidates,
        figure_dir / f"{config.file_prefix}_improvement_fronts.png",
        config,
    )
    plot_counts(
        archive_rows,
        figure_dir / f"{config.file_prefix}_archive_counts.png",
        config,
    )
    write_viewer(viewer_dir / "index.html", archive_rows, config)
    write_json(viewer_dir / "metrics.json", archive_rows)
    return 0


def collect_candidates(problem_root: Path, problem: str) -> list[Candidate]:
    summary = load_json(problem_root / f"{problem}_summary.json")
    ref_metrics = {key: float(value) for key, value in summary["ref_ppa_metric"].items()}
    objective_metrics = objective_metrics_for_reference(ref_metrics)
    archive_ids = ids_from_csv(problem_root / "archive_cells.csv")
    global_front_ids = ids_from_csv(problem_root / "global_pareto_archive.csv")
    generated = generated_candidate_metadata(problem_root / "generation_log.jsonl")
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
                problem=problem,
                candidate_id=candidate_id,
                generation=metadata["generation"],
                strategy=metadata["strategy"],
                score=float(detail["score"]),
                area=float(ppa_metrics["area"]),
                power=float(ppa_metrics["power"]),
                eff_clk_period=float(ppa_metrics.get("eff_clk_period", 0.0)),
                g_a=float(improvements["area"]),
                g_p=float(improvements["power"]),
                g_t=float(improvements.get("eff_clk_period", 0.0)),
                objective_metrics=objective_metrics,
                is_front=False,
                is_global_front=candidate_id in global_front_ids,
                is_archive_member=candidate_id in archive_ids,
                code_file_path=metadata["code_file_path"],
            )
        )
    front_ids = local_front_ids(candidates)
    return [
        Candidate(
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
            is_front=candidate.candidate_id in front_ids,
            is_global_front=candidate.is_global_front,
            is_archive_member=candidate.is_archive_member,
            code_file_path=candidate.code_file_path,
        )
        for candidate in candidates
    ]


def generated_candidate_metadata(path: Path) -> dict[str, dict[str, Any]]:
    rows: dict[str, dict[str, Any]] = {}
    for payload in load_jsonl(path):
        generation = int(payload["generation"])
        for row in payload["generated_candidates"]:
            rows[str(row["id"])] = {
                "generation": generation,
                "strategy": str(row["strategy"]),
                "code_file_path": str(row["code_file_path"]),
            }
    return rows


def ppa_details(path: Path) -> list[dict[str, Any]]:
    rows = []
    for payload in load_jsonl(path):
        rows.extend(payload["population_ppa_details"])
    return rows


def local_front_ids(candidates: list[Candidate]) -> set[str]:
    if not candidates:
        return set()
    objective_metrics = candidates[0].objective_metrics
    points = [
        tuple(improvement_value(candidate, metric) for metric in objective_metrics)
        for candidate in candidates
    ]
    return {candidates[index].candidate_id for index in pareto_front(points)}


def improvement_value(candidate: Candidate, metric: str) -> float:
    if metric == "area":
        return candidate.g_a
    if metric == "power":
        return candidate.g_p
    if metric == "eff_clk_period":
        return candidate.g_t
    raise ValueError(f"Unsupported metric '{metric}'.")


def archive_summary_row(
    problem_root: Path,
    problem: str,
    candidates: list[Candidate],
) -> dict[str, str]:
    archive = load_json(problem_root / "archive_summary.json")
    global_summary = load_json(problem_root / "global_pareto_summary.json")
    return {
        "problem": problem,
        "valid_ppa_count": str(len(candidates)),
        "local_front_count": str(sum(candidate.is_front for candidate in candidates)),
        "global_front_count": str(sum(candidate.is_global_front for candidate in candidates)),
        "archive_member_count": str(archive["total_archive_members"]),
        "occupied_cells": str(archive["occupied_cells"]),
        "max_front_size": str(archive["max_front_size"]),
        "best_quality": fmt(archive["best_quality"]),
        "global_pareto_size": str(global_summary["total_global_pareto_members"]),
    }


def candidate_rows(candidates: list[Candidate]) -> list[dict[str, str]]:
    return [
        {
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
            "is_local_pareto_front": str(candidate.is_front).lower(),
            "is_global_pareto_front": str(candidate.is_global_front).lower(),
            "is_archive_member": str(candidate.is_archive_member).lower(),
            "code_file_path": candidate.code_file_path,
        }
        for candidate in candidates
    ]


def problem_summary_rows(
    candidates: list[Candidate],
    archive_rows: list[dict[str, str]],
) -> list[dict[str, str]]:
    rows = []
    for archive_row in archive_rows:
        subset = [
            candidate
            for candidate in candidates
            if candidate.problem == archive_row["problem"]
        ]
        rows.append(
            {
                **archive_row,
                "reference_beating_count": str(
                    sum(
                        candidate.g_a > 0.0 and candidate.g_p > 0.0
                        for candidate in subset
                    )
                ),
                "best_score": fmt(
                    max((candidate.score for candidate in subset), default=None)
                ),
                "min_area": fmt(
                    min((candidate.area for candidate in subset), default=None)
                ),
                "min_power": fmt(
                    min((candidate.power for candidate in subset), default=None)
                ),
            }
        )
    return rows


def plot_raw_fronts(
    candidates: list[Candidate],
    path: Path,
    config: PackageConfig,
) -> None:
    fig, axes = plt.subplots(1, len(PROBLEMS), figsize=(17.5, 5.4), sharey=False)
    for axis, problem in zip(axes, PROBLEMS, strict=True):
        subset = [candidate for candidate in candidates if candidate.problem == problem]
        draw_problem(axis, subset, raw=True)
        axis.set_title(problem.replace("Prob", "P"))
    axes[0].set_ylabel("Power (lower is better; axis inverted)")
    fig.suptitle(f"{config.plot_title_prefix}: Direct Raw Area-Power Fronts", y=0.98)
    fig.text(
        0.5,
        0.02,
        "Open circles mark local active-objective rank-1 points. "
        "Orange crosses mark global Pareto archive members; "
        "green squares mark active archive members.",
        ha="center",
        fontsize=9,
        color="#444444",
    )
    fig.tight_layout(rect=(0, 0.08, 1, 0.92))
    fig.savefig(path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def plot_improvement_fronts(
    candidates: list[Candidate],
    path: Path,
    config: PackageConfig,
) -> None:
    fig, axes = plt.subplots(1, len(PROBLEMS), figsize=(17.5, 5.4), sharey=False)
    for axis, problem in zip(axes, PROBLEMS, strict=True):
        subset = [candidate for candidate in candidates if candidate.problem == problem]
        draw_problem(axis, subset, raw=False)
        axis.set_title(problem.replace("Prob", "P"))
    axes[0].set_ylabel("Power improvement g_P (higher is better)")
    fig.suptitle(f"{config.plot_title_prefix}: Normalized Improvement Fronts", y=0.98)
    fig.tight_layout(rect=(0, 0.06, 1, 0.92))
    fig.savefig(path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def draw_problem(axis: Any, candidates: list[Candidate], *, raw: bool) -> None:
    if not candidates:
        axis.text(0.5, 0.5, "No valid PPA candidates", ha="center", va="center")
        axis.set_xticks([])
        axis.set_yticks([])
        return
    x_values = [candidate.area if raw else candidate.g_a for candidate in candidates]
    y_values = [candidate.power if raw else candidate.g_p for candidate in candidates]
    axis.scatter(
        x_values,
        y_values,
        s=36,
        color="#64748b",
        alpha=0.35,
        label="Valid PPA",
    )
    draw_subset(
        axis,
        candidates,
        raw=raw,
        attr="is_front",
        marker="o",
        color="#2563eb",
        label="Local front",
    )
    draw_subset(
        axis,
        candidates,
        raw=raw,
        attr="is_global_front",
        marker="x",
        color="#f97316",
        label="Global front",
    )
    draw_subset(
        axis,
        candidates,
        raw=raw,
        attr="is_archive_member",
        marker="s",
        color="#16a34a",
        label="Archive",
    )
    axis.grid(color="#e5e7eb", linewidth=0.8)
    axis.set_xlabel("Area (lower is better; axis inverted)" if raw else "Area improvement g_A")
    if raw:
        axis.invert_xaxis()
        axis.invert_yaxis()


def draw_subset(
    axis: Any,
    candidates: list[Candidate],
    *,
    raw: bool,
    attr: str,
    marker: str,
    color: str,
    label: str,
) -> None:
    subset = [candidate for candidate in candidates if getattr(candidate, attr)]
    if not subset:
        return
    xs = [candidate.area if raw else candidate.g_a for candidate in subset]
    ys = [candidate.power if raw else candidate.g_p for candidate in subset]
    if marker == "o":
        axis.scatter(
            xs,
            ys,
            s=90,
            facecolors="none",
            edgecolors=color,
            linewidths=1.8,
            label=label,
        )
        return
    axis.scatter(xs, ys, s=70, marker=marker, color=color, alpha=0.9, label=label)


def plot_counts(
    rows: list[dict[str, str]],
    path: Path,
    config: PackageConfig,
) -> None:
    problems = [row["problem"].replace("Prob", "P") for row in rows]
    metrics = (
        ("valid_ppa_count", "Valid PPA"),
        ("local_front_count", "Local front"),
        ("global_front_count", "Global front"),
        ("archive_member_count", "Archive members"),
    )
    fig, axis = plt.subplots(figsize=(10.8, 5.2))
    width = 0.18
    x_positions = list(range(len(rows)))
    for offset, (metric, label) in enumerate(metrics):
        axis.bar(
            [position + (offset - 1.5) * width for position in x_positions],
            [float(row[metric]) for row in rows],
            width,
            label=label,
        )
    axis.set_xticks(x_positions)
    axis.set_xticklabels(problems)
    axis.set_ylabel("Candidates")
    axis.set_title(f"{config.plot_title_prefix}: Valid PPA and Front Material")
    axis.grid(axis="y", color="#e5e7eb", linewidth=0.8)
    axis.legend(frameon=False, ncol=4, loc="upper center", bbox_to_anchor=(0.5, -0.12))
    fig.tight_layout()
    fig.savefig(path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def write_viewer(
    path: Path,
    rows: list[dict[str, str]],
    config: PackageConfig,
) -> None:
    table_rows = "\n".join(
        "<tr>"
        f"<td>{row['problem']}</td>"
        f"<td>{row['valid_ppa_count']}</td>"
        f"<td>{row['local_front_count']}</td>"
        f"<td>{row['global_front_count']}</td>"
        f"<td>{row['archive_member_count']}</td>"
        f"<td>{row['best_quality']}</td>"
        "</tr>"
        for row in rows
    )
    path.write_text(
        f"""<!doctype html>
<html lang=\"en\">
<head>
  <meta charset=\"utf-8\">
  <title>{config.viewer_title}</title>
  <style>
    body {{ font-family: Inter, system-ui, sans-serif; margin: 28px; color: #111827; }}
    img {{ max-width: 100%; border: 1px solid #d1d5db; }}
    table {{ border-collapse: collapse; margin-top: 18px; }}
    th, td {{ border-bottom: 1px solid #d1d5db; padding: 8px 12px; text-align: right; }}
    th:first-child, td:first-child {{ text-align: left; }}
  </style>
</head>
<body>
  <h1>{config.viewer_title}</h1>
  <img src=\"../../figures/{config.file_prefix}_raw_area_power_fronts.png\" alt=\"{config.viewer_title}\">
  <table>
    <thead>
      <tr><th>Problem</th><th>Valid PPA</th><th>Local front</th><th>Global front</th><th>Archive</th><th>Best quality</th></tr>
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


def ids_from_csv(path: Path) -> set[str]:
    with path.open(encoding="utf-8", newline="") as handle:
        return {row["candidate_id"] for row in csv.DictReader(handle)}


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, payload: Any) -> None:
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def fmt(value: float | int | str | None) -> str:
    if value is None:
        return ""
    if isinstance(value, str):
        return value
    return f"{float(value):.12g}"


if __name__ == "__main__":
    raise SystemExit(main())
