#!/usr/bin/env python3
"""Package T84 front-slot screen results."""

from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any


PACKAGE = Path(__file__).resolve().parents[1]
ANALYSIS = PACKAGE / "analysis" / "pareto_analysis"
TABLES = PACKAGE / "tables"
FIGURES = PACKAGE / "figures"
RUN_ROOT = Path(
    "exp/useful_bd_push/prelim_rf_leafid_front_slot_delayed_20260626_062400_UTC/"
    "live/masterrtl_rf_leafid_front_slot_delayed_8x5/seed_1001/"
    "openai_gpt-oss-120b"
)
CLASSIC = "classic_revolution_8x5"
T83 = "masterrtl_rf_leafid_structural_delayed_8x5"
T84 = "masterrtl_rf_leafid_front_slot_delayed_8x5"


def main() -> None:
    TABLES.mkdir(exist_ok=True)
    FIGURES.mkdir(exist_ok=True)
    metrics = read_csv(ANALYSIS / "backend_problem_metrics.csv")
    aggregates = read_csv(ANALYSIS / "aggregate_backend_metrics.csv")
    write_screen_decision_metrics(aggregates)
    write_problem_hv_deltas(metrics)
    write_comparison_completeness(metrics)
    write_sensitivity_no_prob135(metrics)
    write_descriptor_health()
    write_summary_figure()


def write_screen_decision_metrics(aggregates: list[dict[str, str]]) -> None:
    by_backend = {
        row["backend"]: row for row in aggregates if row["benchmark"] == "ALL"
    }
    classic = by_backend[CLASSIC]
    t84 = by_backend[T84]
    rows = [
        {
            "metric": "mean_hypervolume",
            "classic_revolution_8x5": classic["mean_hypervolume"],
            "rf_leafid_front_slot_delayed_8x5": t84["mean_hypervolume"],
            "absolute_delta": as_float(t84["mean_hypervolume"])
            - as_float(classic["mean_hypervolume"]),
            "relative_delta": relative_delta(
                as_float(t84["mean_hypervolume"]),
                as_float(classic["mean_hypervolume"]),
            ),
        },
        {
            "metric": "mean_pareto_points",
            "classic_revolution_8x5": classic["mean_pareto_point_count"],
            "rf_leafid_front_slot_delayed_8x5": t84["mean_pareto_point_count"],
            "absolute_delta": as_float(t84["mean_pareto_point_count"])
            - as_float(classic["mean_pareto_point_count"]),
            "relative_delta": relative_delta(
                as_float(t84["mean_pareto_point_count"]),
                as_float(classic["mean_pareto_point_count"]),
            ),
        },
        {
            "metric": "mean_ref_beating",
            "classic_revolution_8x5": classic["mean_reference_beating_count"],
            "rf_leafid_front_slot_delayed_8x5": t84["mean_reference_beating_count"],
            "absolute_delta": as_float(t84["mean_reference_beating_count"])
            - as_float(classic["mean_reference_beating_count"]),
            "relative_delta": relative_delta(
                as_float(t84["mean_reference_beating_count"]),
                as_float(classic["mean_reference_beating_count"]),
            ),
        },
        {
            "metric": "hv_wins",
            "classic_revolution_8x5": classic["hypervolume_win_count"],
            "rf_leafid_front_slot_delayed_8x5": t84["hypervolume_win_count"],
            "absolute_delta": as_float(t84["hypervolume_win_count"])
            - as_float(classic["hypervolume_win_count"]),
            "relative_delta": relative_delta(
                as_float(t84["hypervolume_win_count"]),
                as_float(classic["hypervolume_win_count"]),
            ),
        },
    ]
    write_csv(TABLES / "screen_decision_metrics.csv", rows)


def write_problem_hv_deltas(metrics: list[dict[str, str]]) -> None:
    by_key = {
        (row["backend"], row["benchmark"], row["problem"]): row for row in metrics
    }
    rows = []
    for key, classic in sorted(by_key.items()):
        if key[0] != CLASSIC:
            continue
        qd = by_key[(T84, key[1], key[2])]
        rows.append(
            {
                "benchmark": key[1],
                "problem": key[2],
                "classic_hv": classic["hypervolume"],
                "qd_hv": qd["hypervolume"],
                "absolute_delta": as_float(qd["hypervolume"])
                - as_float(classic["hypervolume"]),
                "classic_pareto_points": classic["pareto_point_count"],
                "qd_pareto_points": qd["pareto_point_count"],
                "classic_ref_beating": classic["reference_beating_count"],
                "qd_ref_beating": qd["reference_beating_count"],
            }
        )
    write_csv(TABLES / "problem_hv_deltas.csv", rows)


def write_comparison_completeness(metrics: list[dict[str, str]]) -> None:
    by_key = {
        (row["backend"], row["benchmark"], row["problem"]): row for row in metrics
    }
    rows = []
    for key, classic in sorted(by_key.items()):
        if key[0] != CLASSIC:
            continue
        qd = by_key[(T84, key[1], key[2])]
        rows.append(
            {
                "benchmark": key[1],
                "problem": key[2],
                "classic_valid_ppa_candidates": classic["candidate_count"],
                "qd_valid_ppa_candidates": qd["candidate_count"],
                "reference_ppa_valid": "yes",
                "comparison_status": "headline_paired",
            }
        )
    write_csv(TABLES / "comparison_completeness.csv", rows)


def write_sensitivity_no_prob135(metrics: list[dict[str, str]]) -> None:
    rows = []
    for backend in [CLASSIC, T83, T84]:
        selected = [
            row
            for row in metrics
            if row["backend"] == backend and row["problem"] != "Prob135_m2014_q6b"
        ]
        rows.append(
            {
                "backend": backend,
                "problems": len(selected),
                "mean_hypervolume": mean(selected, "hypervolume"),
                "mean_pareto_points": mean(selected, "pareto_point_count"),
                "mean_ref_beating": mean(selected, "reference_beating_count"),
            }
        )
    write_csv(TABLES / "sensitivity_no_prob135.csv", rows)


def write_descriptor_health() -> None:
    rows = []
    for path in sorted(RUN_ROOT.glob("*/*/descriptor_health.json")):
        health = json.loads(path.read_text())
        summary = json.loads((path.parent / "archive_summary.json").read_text())
        axis_stats = {
            item["axis"]: item["archive_stats"] for item in health["axis_health"]
        }
        rows.append(
            {
                "benchmark": path.parent.parent.name,
                "problem": path.parent.name,
                "observations": health["observation_count"],
                "archive_members": summary["archive_member_count"],
                "occupied_cells": health["occupied_cells"],
                "active_effective_axes": health["active_effective_axes"],
                "collapsed_axes": ";".join(health["collapsed_axes"]),
                "rf_leaf_archive_unique": axis_stats[
                    "source_aligned_rf_timing_leaf_ids"
                ]["unique_count"],
                "branch_archive_unique": axis_stats[
                    "source_aligned_masterrtl_branching"
                ]["unique_count"],
                "wire_density_archive_unique": axis_stats[
                    "source_aligned_rtltimer_wire_density"
                ]["unique_count"],
            }
        )
    write_csv(TABLES / "descriptor_health_summary.csv", rows)


def write_summary_figure() -> None:
    import matplotlib.pyplot as plt

    aggregates = {
        row["backend"]: row
        for row in read_csv(ANALYSIS / "aggregate_backend_metrics.csv")
        if row["benchmark"] == "ALL"
    }
    delta_rows = read_csv(TABLES / "problem_hv_deltas.csv")
    problem_labels = [row["problem"].replace("Prob", "P") for row in delta_rows]
    t84_deltas = [as_float(row["absolute_delta"]) for row in delta_rows]

    fig, axes = plt.subplots(1, 2, figsize=(11.5, 4.4))
    names = ["Classic", "T83", "T84"]
    values = [
        as_float(aggregates[CLASSIC]["mean_hypervolume"]),
        as_float(aggregates[T83]["mean_hypervolume"]),
        as_float(aggregates[T84]["mean_hypervolume"]),
    ]
    colors = ["#4b5563", "#2563eb", "#d97706"]
    bars = axes[0].bar(names, values, color=colors)
    axes[0].set_title("Mean HV on frozen screen")
    axes[0].set_ylabel("Hypervolume")
    axes[0].set_ylim(0.0, max(values) * 1.22)
    for bar, value in zip(bars, values, strict=True):
        axes[0].text(
            bar.get_x() + bar.get_width() / 2,
            value + 0.004,
            f"{value:.3f}",
            ha="center",
            fontsize=9,
        )

    bar_colors = ["#059669" if value > 0 else "#dc2626" for value in t84_deltas]
    bars = axes[1].bar(problem_labels, t84_deltas, color=bar_colors)
    axes[1].axhline(0.0, color="#111827", linewidth=1)
    axes[1].set_title("T84 HV delta vs classic")
    axes[1].set_ylabel("QD minus classic HV")
    axes[1].set_ylim(min(t84_deltas) * 1.20, 0.012)
    axes[1].tick_params(axis="x", labelrotation=35)
    for tick in axes[1].get_xticklabels():
        tick.set_horizontalalignment("right")
    for bar, value in zip(bars, t84_deltas, strict=True):
        axes[1].text(
            bar.get_x() + bar.get_width() / 2,
            value - 0.004 if value < 0 else 0.002,
            f"{value:+.3f}",
            ha="center",
            va="top" if value < 0 else "bottom",
            fontsize=8,
        )

    fig.suptitle("T84 RF leaf-ID front-slot screen", fontsize=14)
    fig.tight_layout()
    fig.savefig(FIGURES / "rf_leafid_front_slot_delayed_summary.png", dpi=180)
    plt.close(fig)


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def as_float(value: str | float) -> float:
    return float(value)


def relative_delta(value: float, baseline: float) -> float:
    assert baseline != 0.0
    return (value - baseline) / baseline


def mean(rows: list[dict[str, str]], key: str) -> float:
    assert rows
    return sum(as_float(row[key]) for row in rows) / len(rows)


if __name__ == "__main__":
    main()
