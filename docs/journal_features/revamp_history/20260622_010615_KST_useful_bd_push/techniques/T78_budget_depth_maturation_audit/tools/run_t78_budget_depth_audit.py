"""Build the T78 budget-depth maturation audit from existing T75 logs."""

from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any

import matplotlib.pyplot as plt


WORKSPACE = Path("/workspace")
PACKAGE = Path(__file__).resolve().parents[1]
RUN_ROOT = (
    WORKSPACE
    / "exp/useful_bd_push/t75_shape_density_front_pressure_20260624_024005_UTC"
    / "hard_tuning"
)
REPORT_ROOT = RUN_ROOT / "final_analysis/evolutionary_reports"
QD_PROBLEM_ROOT = (
    RUN_ROOT
    / "shape_density_front_pressure_qd/seed_1001/openai_gpt-oss-120b"
)
BACKENDS = ("classic_revolution", "shape_density_front_pressure_qd")


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def as_float(value: str | None) -> float | None:
    if value in ("", None):
        return None
    return float(value)


def read_generation_metrics() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for backend in BACKENDS:
        path = REPORT_ROOT / backend / "generation_metrics.csv"
        for row in read_csv(path):
            rows.append(
                {
                    "backend": backend,
                    "generation": int(row["generation"]),
                    "problem_count": int(row["problem_count"]),
                    "functionality_mean": float(row["functionality_mean"]),
                    "synthesis_mean": float(row["synthesis_mean"]),
                    "best_score_mean": float(row["best_score_mean"]),
                    "average_score_mean": float(row["average_score_mean"]),
                    "coverage_mean": as_float(row["coverage_mean"]),
                    "qd_score_mean": as_float(row["qd_score_mean"]),
                    "best_quality_mean": as_float(row["best_quality_mean"]),
                    "new_filled_cells_mean": as_float(row["new_filled_cells_mean"]),
                    "replaced_cells_mean": as_float(row["replaced_cells_mean"]),
                }
            )
    return rows


def archive_paths() -> list[Path]:
    paths = sorted(QD_PROBLEM_ROOT.glob("*/*/archive_history.jsonl"))
    assert len(paths) == 13
    return paths


def read_archive_history(path: Path) -> list[dict[str, Any]]:
    rows = [json.loads(line) for line in path.read_text().splitlines()]
    assert rows
    return rows


def build_archive_rows() -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    by_problem: list[dict[str, Any]] = []
    by_generation: dict[int, list[dict[str, Any]]] = {}
    for path in archive_paths():
        benchmark = path.parents[1].name
        problem = path.parent.name
        rows = read_archive_history(path)
        final = rows[-1]
        occupied_generations = [
            int(row["generation"]) for row in rows if int(row["occupied_cells"]) > 0
        ]
        active_late = any(
            int(row["generation"]) >= 2
            and (int(row["new_filled_cells"]) + int(row["replaced_cells"])) > 0
            for row in rows
        )
        new_generations = [
            int(row["generation"]) for row in rows if int(row["new_filled_cells"]) > 0
        ]
        replacement_generations = [
            int(row["generation"]) for row in rows if int(row["replaced_cells"]) > 0
        ]
        by_problem.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "archive_generations": len(rows),
                "first_occupied_generation": min(occupied_generations)
                if occupied_generations
                else "",
                "first_replacement_generation": (
                    min(replacement_generations) if replacement_generations else ""
                ),
                "last_new_filled_generation": max(new_generations)
                if new_generations
                else "",
                "last_replaced_generation": (
                    max(replacement_generations) if replacement_generations else ""
                ),
                "active_gen2_or_later": active_late,
                "final_occupied_cells": int(final["occupied_cells"]),
                "final_archive_members": int(final["total_archive_members"]),
                "final_coverage": float(final["coverage"]),
                "final_qd_score": float(final["qd_score"]),
                "final_best_quality": ""
                if final["best_quality"] is None
                else float(final["best_quality"]),
                "total_new_filled_cells": sum(int(row["new_filled_cells"]) for row in rows),
                "total_replaced_cells": sum(int(row["replaced_cells"]) for row in rows),
            }
        )
        for row in rows:
            by_generation.setdefault(int(row["generation"]), []).append(row)

    aggregate_rows: list[dict[str, Any]] = []
    for generation, rows in sorted(by_generation.items()):
        count = len(rows)
        aggregate_rows.append(
            {
                "generation": generation,
                "problem_count": count,
                "occupied_cells_mean": sum(int(row["occupied_cells"]) for row in rows)
                / count,
                "archive_members_mean": sum(
                    int(row["total_archive_members"]) for row in rows
                )
                / count,
                "coverage_mean": sum(float(row["coverage"]) for row in rows) / count,
                "qd_score_mean": sum(float(row["qd_score"]) for row in rows) / count,
                "new_filled_cells_mean": sum(
                    int(row["new_filled_cells"]) for row in rows
                )
                / count,
                "replaced_cells_mean": sum(int(row["replaced_cells"]) for row in rows)
                / count,
                "front_slot_requests_sum": sum(
                    int(row["front_slot_lane_parent_requests"]) for row in rows
                ),
                "front_slot_hits_sum": sum(
                    int(row["front_slot_lane_parent_hits"]) for row in rows
                ),
            }
        )
    return by_problem, aggregate_rows


def write_budget_shapes() -> None:
    rows = [
        {
            "shape": "12 x 3",
            "candidate_budget": 48,
            "role": "current_baseline",
            "hypothesis": "wide_shallow_advantages_classic",
        },
        {
            "shape": "8 x 5",
            "candidate_budget": 48,
            "role": "balanced_depth",
            "hypothesis": "archive_cells_get_more_maturation_time",
        },
        {
            "shape": "6 x 7",
            "candidate_budget": 48,
            "role": "deeper_archive_test",
            "hypothesis": "qd_benefits_more_than_classic_if_cells_mature",
        },
        {
            "shape": "4 x 11",
            "candidate_budget": 48,
            "role": "deep_control",
            "hypothesis": "low_initial_diversity_may_hurt_validity",
        },
        {
            "shape": "16 x 2",
            "candidate_budget": 48,
            "role": "wide_control",
            "hypothesis": "strong_validity_search_but_weak_evolution",
        },
    ]
    write_csv(PACKAGE / "tables/t78_budget_shape_recommendation.csv", rows)


def plot_generation_curves(rows: list[dict[str, Any]]) -> None:
    fig, axes = plt.subplots(1, 3, figsize=(13, 4), constrained_layout=True)
    labels = {
        "classic_revolution": "Classic",
        "shape_density_front_pressure_qd": "T75 QD",
    }
    for backend in BACKENDS:
        backend_rows = [row for row in rows if row["backend"] == backend]
        generations = [int(row["generation"]) for row in backend_rows]
        axes[0].plot(
            generations,
            [float(row["best_score_mean"]) for row in backend_rows],
            marker="o",
            label=labels[backend],
        )
        axes[1].plot(
            generations,
            [float(row["synthesis_mean"]) for row in backend_rows],
            marker="o",
            label=labels[backend],
        )
    qd_rows = [row for row in rows if row["backend"] == "shape_density_front_pressure_qd"]
    axes[2].bar(
        [int(row["generation"]) for row in qd_rows],
        [float(row["new_filled_cells_mean"] or 0.0) for row in qd_rows],
        label="New cells",
        color="#4c78a8",
    )
    axes[2].bar(
        [int(row["generation"]) for row in qd_rows],
        [float(row["replaced_cells_mean"] or 0.0) for row in qd_rows],
        bottom=[float(row["new_filled_cells_mean"] or 0.0) for row in qd_rows],
        label="Replaced cells",
        color="#f58518",
    )
    axes[0].set_title("Best Score Mean")
    axes[1].set_title("Synthesis-PPA Yield Mean")
    axes[2].set_title("T75 Archive Activity")
    for axis in axes:
        axis.set_xlabel("Generation")
        axis.grid(alpha=0.25)
    axes[0].set_ylabel("Mean")
    axes[2].set_ylabel("Mean cells/problem")
    axes[0].legend(frameon=False)
    axes[2].legend(frameon=False)
    fig.suptitle("T78: Existing 12 x 3 Runs Still Change Late")
    fig.savefig(PACKAGE / "figures/t78_generation_metric_curves.png", dpi=180)
    plt.close(fig)


def plot_archive_maturation(rows: list[dict[str, Any]]) -> None:
    generations = [int(row["generation"]) for row in rows]
    fig, axes = plt.subplots(2, 2, figsize=(11, 8), constrained_layout=True)
    axes[0, 0].plot(
        generations,
        [float(row["occupied_cells_mean"]) for row in rows],
        marker="o",
        color="#4c78a8",
    )
    axes[0, 1].plot(
        generations,
        [float(row["archive_members_mean"]) for row in rows],
        marker="o",
        color="#54a24b",
    )
    axes[1, 0].plot(
        generations,
        [float(row["coverage_mean"]) for row in rows],
        marker="o",
        color="#b279a2",
    )
    axes[1, 1].bar(
        generations,
        [float(row["front_slot_requests_sum"]) for row in rows],
        color="#4c78a8",
        label="Requests",
    )
    axes[1, 1].bar(
        generations,
        [float(row["front_slot_hits_sum"]) for row in rows],
        color="#f58518",
        label="Hits",
    )
    titles = [
        "Occupied Cells",
        "Archive Members",
        "Coverage",
        "Front-Slot Parent Traffic",
    ]
    for axis, title in zip(axes.ravel(), titles, strict=True):
        axis.set_title(title)
        axis.set_xlabel("Generation")
        axis.grid(alpha=0.25)
    axes[0, 0].set_ylabel("Mean/problem")
    axes[0, 1].set_ylabel("Mean/problem")
    axes[1, 0].set_ylabel("Mean")
    axes[1, 1].set_ylabel("Count across problems")
    axes[1, 1].legend(frameon=False)
    fig.suptitle("T78: T75 Archive Maturation Under 12 x 3")
    fig.savefig(PACKAGE / "figures/t78_archive_maturation.png", dpi=180)
    plt.close(fig)


def main() -> None:
    tables = PACKAGE / "tables"
    figures = PACKAGE / "figures"
    tables.mkdir(exist_ok=True)
    figures.mkdir(exist_ok=True)

    generation_rows = read_generation_metrics()
    by_problem, archive_rows = build_archive_rows()
    write_csv(tables / "t78_generation_metrics.csv", generation_rows)
    write_csv(tables / "t78_archive_maturation_by_problem.csv", by_problem)
    write_csv(tables / "t78_archive_generation_aggregate.csv", archive_rows)
    write_budget_shapes()

    late_active_count = sum(row["active_gen2_or_later"] for row in by_problem)
    final_classic = [
        row for row in generation_rows if row["backend"] == BACKENDS[0] and row["generation"] == 3
    ][0]
    final_qd = [
        row for row in generation_rows if row["backend"] == BACKENDS[1] and row["generation"] == 3
    ][0]
    summary = {
        "audit_source": str(RUN_ROOT),
        "problem_count": len(by_problem),
        "late_active_problem_count": late_active_count,
        "late_active_problem_fraction": late_active_count / len(by_problem),
        "classic_final_best_score_mean": final_classic["best_score_mean"],
        "qd_final_best_score_mean": final_qd["best_score_mean"],
        "classic_final_synthesis_mean": final_classic["synthesis_mean"],
        "qd_final_synthesis_mean": final_qd["synthesis_mean"],
        "interpretation": "diagnostic_budget_shape_support_not_live_ablation",
    }
    (tables / "t78_summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    plot_generation_curves(generation_rows)
    plot_archive_maturation(archive_rows)


if __name__ == "__main__":
    main()
