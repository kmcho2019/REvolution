#!/usr/bin/env python3
"""Build compact T79 aggregate figures from tracked final-analysis tables."""

from __future__ import annotations

import csv
import json
from pathlib import Path

import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[1]
TABLE_DIR = ROOT / "tables" / "final_analysis"
FIGURE_DIR = ROOT / "figures" / "final_analysis"
SHAPES = ("12x3", "8x5", "6x7")


def _shape(backend: str) -> str:
    return backend.rsplit("_", 1)[1]


def _kind(backend: str) -> str:
    return "classic" if backend.startswith("classic_") else "qd"


def _float(value: object) -> float | None:
    return None if value is None else float(value)


def _load_hard_rows() -> dict[tuple[str, str], dict[str, float | None]]:
    payload = json.loads((TABLE_DIR / "hard_iteration_summary.json").read_text())
    rows: dict[tuple[str, str], dict[str, float | None]] = {}
    for item in payload["aggregates"]:
        shape = _shape(item["backend"])
        kind = _kind(item["backend"])
        rows[(shape, kind)] = {
            "functionality_mean": _float(item["functionality_mean"]),
            "synthesis_mean": _float(item["synthesis_mean"]),
            "best_score_mean": _float(item["best_score_mean"]),
            "qd_coverage_mean": _float(item["qd_coverage_mean"]),
            "qd_score_mean": _float(item["qd_score_mean"]),
        }
    return rows


def _load_pareto_rows() -> dict[tuple[str, str], dict[str, float]]:
    rows: dict[tuple[str, str], dict[str, float]] = {}
    with (TABLE_DIR / "pareto_aggregate_backend_metrics.csv").open(newline="") as f:
        for item in csv.DictReader(f):
            if item["benchmark"] != "ALL":
                continue
            shape = _shape(item["backend"])
            kind = _kind(item["backend"])
            rows[(shape, kind)] = {
                "mean_hypervolume": float(item["mean_hypervolume"]),
                "mean_pareto_point_count": float(item["mean_pareto_point_count"]),
                "mean_reference_beating_count": float(item["mean_reference_beating_count"]),
                "hypervolume_win_count": float(item["hypervolume_win_count"]),
            }
    return rows


def _write_summary_csv(
    hard_rows: dict[tuple[str, str], dict[str, float | None]],
    pareto_rows: dict[tuple[str, str], dict[str, float]],
) -> list[dict[str, float | str | None]]:
    rows: list[dict[str, float | str | None]] = []
    for shape in SHAPES:
        classic_hard = hard_rows[(shape, "classic")]
        qd_hard = hard_rows[(shape, "qd")]
        classic_pareto = pareto_rows[(shape, "classic")]
        qd_pareto = pareto_rows[(shape, "qd")]
        rows.append(
            {
                "shape": shape,
                "classic_mean_hv": classic_pareto["mean_hypervolume"],
                "qd_mean_hv": qd_pareto["mean_hypervolume"],
                "qd_minus_classic_hv": qd_pareto["mean_hypervolume"]
                - classic_pareto["mean_hypervolume"],
                "classic_pareto_points": classic_pareto["mean_pareto_point_count"],
                "qd_pareto_points": qd_pareto["mean_pareto_point_count"],
                "qd_minus_classic_pareto_points": qd_pareto["mean_pareto_point_count"]
                - classic_pareto["mean_pareto_point_count"],
                "classic_ref_beating": classic_pareto["mean_reference_beating_count"],
                "qd_ref_beating": qd_pareto["mean_reference_beating_count"],
                "qd_minus_classic_ref_beating": qd_pareto[
                    "mean_reference_beating_count"
                ]
                - classic_pareto["mean_reference_beating_count"],
                "classic_best_score": classic_hard["best_score_mean"],
                "qd_best_score": qd_hard["best_score_mean"],
                "qd_minus_classic_best_score": qd_hard["best_score_mean"]
                - classic_hard["best_score_mean"],
                "classic_synthesis_mean": classic_hard["synthesis_mean"],
                "qd_synthesis_mean": qd_hard["synthesis_mean"],
                "qd_minus_classic_synthesis": qd_hard["synthesis_mean"]
                - classic_hard["synthesis_mean"],
                "qd_coverage_mean": qd_hard["qd_coverage_mean"],
                "qd_score_mean": qd_hard["qd_score_mean"],
            }
        )
    path = TABLE_DIR / "shape_pair_summary.csv"
    with path.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    return rows


def _bar_pair(ax: plt.Axes, rows: list[dict[str, float | str | None]], key: str) -> None:
    x = range(len(rows))
    classic_key = f"classic_{key}"
    qd_key = f"qd_{key}"
    ax.bar([i - 0.18 for i in x], [float(row[classic_key]) for row in rows], 0.34, label="Classic")
    ax.bar([i + 0.18 for i in x], [float(row[qd_key]) for row in rows], 0.34, label="QD")
    ax.set_xticks(list(x), [str(row["shape"]) for row in rows])
    ax.grid(axis="y", alpha=0.25)


def _save_hv_figure(rows: list[dict[str, float | str | None]]) -> None:
    fig, ax = plt.subplots(figsize=(7.0, 4.2), constrained_layout=True)
    _bar_pair(ax, rows, "mean_hv")
    ax.set_title("T79 Mean Pareto Hypervolume By Budget Shape")
    ax.set_ylabel("Mean hypervolume")
    ax.legend(loc="upper right", frameon=False)
    for index, row in enumerate(rows):
        delta = float(row["qd_minus_classic_hv"])
        ax.text(index, 0.01, f"Δ {delta:+.3f}", ha="center", va="bottom", fontsize=9)
    fig.savefig(FIGURE_DIR / "summary_mean_hypervolume.png", dpi=180)
    plt.close(fig)


def _save_validity_score_figure(rows: list[dict[str, float | str | None]]) -> None:
    fig, axes = plt.subplots(1, 2, figsize=(9.0, 4.0), constrained_layout=True)
    _bar_pair(axes[0], rows, "synthesis_mean")
    axes[0].set_title("Synthesis Yield")
    axes[0].set_ylabel("Mean synthesis pass rate")
    axes[0].set_ylim(0.0, 0.7)
    _bar_pair(axes[1], rows, "best_score")
    axes[1].set_title("Best Score")
    axes[1].set_ylabel("Mean best score")
    axes[1].legend(loc="upper right", frameon=False)
    fig.savefig(FIGURE_DIR / "summary_yield_and_score.png", dpi=180)
    plt.close(fig)


def _save_archive_tradeoff_figure(rows: list[dict[str, float | str | None]]) -> None:
    fig, ax = plt.subplots(figsize=(6.4, 4.2), constrained_layout=True)
    for row in rows:
        ax.scatter(
            float(row["qd_coverage_mean"]),
            float(row["qd_minus_classic_hv"]),
            s=90,
        )
        ax.text(
            float(row["qd_coverage_mean"]) + 0.002,
            float(row["qd_minus_classic_hv"]),
            str(row["shape"]),
            va="center",
        )
    ax.axhline(0.0, color="0.35", linewidth=1.0, linestyle="--")
    ax.set_title("Archive Coverage Did Not Convert To HV Gain")
    ax.set_xlabel("QD archive coverage mean")
    ax.set_ylabel("QD minus classic mean HV")
    ax.grid(alpha=0.25)
    fig.savefig(FIGURE_DIR / "summary_archive_coverage_vs_hv_delta.png", dpi=180)
    plt.close(fig)


def main() -> None:
    FIGURE_DIR.mkdir(parents=True, exist_ok=True)
    hard_rows = _load_hard_rows()
    pareto_rows = _load_pareto_rows()
    rows = _write_summary_csv(hard_rows, pareto_rows)
    _save_hv_figure(rows)
    _save_validity_score_figure(rows)
    _save_archive_tradeoff_figure(rows)


if __name__ == "__main__":
    main()
