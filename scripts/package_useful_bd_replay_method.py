#!/usr/bin/env python3
"""Package one useful-BD replay method from a central report JSON."""

from __future__ import annotations

import argparse
import csv
import json
import math
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

REFERENCE_METHOD = "classic_revolution"
MANUAL_METHOD = "landing_smooth_qd_manual_bd"
VALIDITY_GATE_MIN_BASELINE_PASSES = 10
METHOD_LABELS = {
    "classic_revolution": "Classic",
    "landing_smooth_qd_manual_bd": "Manual BD",
    "netlist_motif_occupancy": "Motif occupancy",
    "random_descriptor_qd": "Random BD",
    "synthesis_trajectory_nod": "ST-NOD",
    "synthesis_trajectory_motif_nod": "ST-NOD+motif",
    "sr_raw_pca_qd": "SR raw PCA",
    "sr_random_relu_pca_qd": "SR ReLU PCA",
    "sr_rff_pca_qd": "SR-RFF PCA",
    "sr_vq_codebook_qd": "SR VQ",
}
METRIC_LABELS = {
    "mean_hypervolume": "Mean HV",
    "mean_best_fitness": "Best fitness",
    "valid_ppa_candidate_count": "Valid PPA",
    "ppa_front_unique_netlist_count": "PPA-front nets",
    "unique_motif_signature_count": "Motif signatures",
    "common_audit_occupied_cells": "Audit cells",
    "common_audit_qd_score": "Audit QD score",
}

TABLE_NAMES = (
    "gate_matrix",
    "validity_funnel",
    "validity_gate",
    "leaderboard_comparison",
    "archive_metrics",
    "per_problem_deltas_vs_classic",
    "per_problem_ppa_diversity",
    "metric_deltas_vs_classic",
    "descriptor_correlations",
)

DELTA_METRICS = (
    "mean_hypervolume",
    "mean_best_fitness",
    "valid_ppa_candidate_count",
    "ppa_front_unique_netlist_count",
    "unique_motif_signature_count",
    "common_audit_occupied_cells",
    "common_audit_qd_score",
    "functionality_rate",
    "synthesis_rate",
    "valid_ppa_rate",
)


def build_package(report: dict[str, Any], method_name: str) -> dict[str, list[dict[str, Any]]]:
    """Return method-local tables for a useful-BD replay package."""

    methods = selected_methods(report, method_name)
    leaderboard = by_method(report["leaderboard"])
    robustness = by_method(report["robustness_funnel"])
    return {
        "gate_matrix": select_rows(report["gate_matrix"], methods),
        "validity_funnel": select_rows(report["robustness_funnel"], methods),
        "validity_gate": validity_gate_rows(robustness[REFERENCE_METHOD], robustness[method_name]),
        "leaderboard_comparison": select_rows(report["leaderboard"], methods),
        "archive_metrics": select_rows(report["qd_summary"], methods),
        "per_problem_deltas_vs_classic": [
            row
            for row in report["comparison_matrix"]
            if row["method_name"] == method_name
        ],
        "per_problem_ppa_diversity": select_rows(report["problem_metrics"], methods),
        "metric_deltas_vs_classic": metric_delta_rows(
            leaderboard[REFERENCE_METHOD],
            leaderboard[method_name],
            robustness[REFERENCE_METHOD],
            robustness[method_name],
        ),
        "descriptor_correlations": select_rows(
            report["descriptor_correlations"],
            [method_name],
        ),
    }


def selected_methods(report: dict[str, Any], method_name: str) -> list[str]:
    """Return classic/manual/method order, omitting missing manual baselines."""

    present = set(by_method(report["leaderboard"]))
    assert REFERENCE_METHOD in present, f"missing {REFERENCE_METHOD}"
    assert method_name in present, f"missing method: {method_name}"
    methods = [REFERENCE_METHOD]
    if MANUAL_METHOD in present and method_name != MANUAL_METHOD:
        methods.append(MANUAL_METHOD)
    if method_name != REFERENCE_METHOD:
        methods.append(method_name)
    return methods


def validity_gate_rows(
    classic: dict[str, Any],
    method: dict[str, Any],
) -> list[dict[str, Any]]:
    """Build small-n-aware validity regression rows."""

    stages = (
        ("functionality", "functionality_pass", "functionality_rate"),
        ("synthesis", "synthesis_pass", "synthesis_rate"),
        ("valid_ppa", "valid_ppa", "valid_ppa_rate"),
    )
    rows = []
    for stage, count_key, rate_key in stages:
        classic_count = int(classic[count_key])
        method_count = int(method[count_key])
        classic_rate = float(classic[rate_key])
        method_rate = float(method[rate_key])
        relative_delta = safe_relative_delta(method_rate, classic_rate)
        enforced = classic_count >= VALIDITY_GATE_MIN_BASELINE_PASSES
        collapse = bool(enforced and relative_delta <= -0.5)
        rows.append(
            {
                "stage": stage,
                "classic_pass_count": classic_count,
                "method_pass_count": method_count,
                "classic_rate": classic_rate,
                "method_rate": method_rate,
                "relative_delta": relative_delta,
                "gate_min_baseline_passes": VALIDITY_GATE_MIN_BASELINE_PASSES,
                "gate_enforced": enforced,
                "small_n_validity": not enforced,
                "collapse_50pct": collapse,
            }
        )
    return rows


def metric_delta_rows(
    classic_leaderboard: dict[str, Any],
    method_leaderboard: dict[str, Any],
    classic_robustness: dict[str, Any],
    method_robustness: dict[str, Any],
) -> list[dict[str, Any]]:
    """Compare headline metrics against classic."""

    rows = []
    merged_classic = {**classic_leaderboard, **classic_robustness}
    merged_method = {**method_leaderboard, **method_robustness}
    for metric in DELTA_METRICS:
        classic_value = float(merged_classic[metric])
        method_value = float(merged_method[metric])
        rows.append(
            {
                "metric": metric,
                "classic": classic_value,
                "method": method_value,
                "delta": method_value - classic_value,
                "relative_delta": safe_relative_delta(method_value, classic_value),
            }
        )
    return rows


def write_package(
    report: dict[str, Any],
    method_name: str,
    technique_dir: Path,
) -> None:
    """Write tables and figures for one useful-BD method package."""

    tables = build_package(report, method_name)
    table_dir = technique_dir / "tables"
    figure_dir = technique_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    for name in TABLE_NAMES:
        write_csv(table_dir / f"{name}.csv", tables[name])
    write_figures(report, tables, method_name, figure_dir)


def write_figures(
    report: dict[str, Any],
    tables: dict[str, list[dict[str, Any]]],
    method_name: str,
    figure_dir: Path,
) -> None:
    """Write method-local PNG figures."""

    methods = selected_methods(report, method_name)
    plot_anytime(
        select_rows(report["anytime_metrics"], methods),
        "mean_hypervolume",
        "Mean Hypervolume",
        figure_dir / "seed1_mean_hypervolume.png",
    )
    plot_method_bar(
        tables["archive_metrics"],
        "common_audit_coverage",
        "Common-Audit Coverage",
        figure_dir / "seed1_common_audit_coverage.png",
    )
    plot_method_bar(
        tables["leaderboard_comparison"],
        "mean_ppa_grid_coverage",
        "Mean PPA-Grid Coverage",
        figure_dir / "seed1_ppa_grid_coverage.png",
    )
    plot_archive_heatmap(
        select_rows(report["archive_metrics"], methods),
        "common_audit_occupied_cells",
        figure_dir / "seed1_common_audit_cells_heatmap.png",
    )
    plot_delta_bars(
        tables["metric_deltas_vs_classic"],
        figure_dir / "seed1_metric_deltas_vs_classic.png",
    )
    plot_validity_gate(
        tables["validity_gate"],
        figure_dir / "seed1_validity_funnel.png",
    )
    plot_duplicate_accounting(
        tables["leaderboard_comparison"],
        figure_dir / "duplicate_accounting.png",
    )


def plot_anytime(
    rows: list[dict[str, Any]],
    metric_name: str,
    ylabel: str,
    output_path: Path,
) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    fig, axis = plt.subplots(figsize=(7.2, 4.4))
    for method, group in frame.groupby("method_name", sort=False):
        group = group.sort_values("generation")
        axis.plot(
            group["generation"],
            group[metric_name],
            marker="o",
            linewidth=2.0,
            label=display_method(method),
        )
    axis.set_xlabel("Generation")
    axis.set_ylabel(ylabel)
    axis.grid(True, alpha=0.25)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_method_bar(
    rows: list[dict[str, Any]],
    metric_name: str,
    ylabel: str,
    output_path: Path,
) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    fig, axis = plt.subplots(figsize=(7.2, 4.2))
    labels = [display_method(method) for method in frame["method_name"]]
    x_positions = range(len(frame))
    axis.bar(x_positions, frame[metric_name].astype(float), color="#4C78A8")
    axis.set_ylabel(ylabel)
    axis.set_xticks(list(x_positions), labels, rotation=20, ha="right")
    axis.grid(True, axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_archive_heatmap(
    rows: list[dict[str, Any]],
    metric_name: str,
    output_path: Path,
) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    pivot = frame.pivot_table(
        index="method_name",
        columns="problem_id",
        values=metric_name,
        aggfunc="sum",
    ).fillna(0.0)
    fig, axis = plt.subplots(
        figsize=(max(7.5, len(pivot.columns) * 1.1), max(4.2, len(pivot.index) * 0.7))
    )
    image = axis.imshow(pivot.to_numpy(dtype=float), cmap="Blues", aspect="auto")
    axis.set_title("Common-Audit Occupied Cells")
    axis.set_xticks(
        range(len(pivot.columns)),
        [short_problem_name(problem) for problem in pivot.columns],
        rotation=25,
        ha="right",
    )
    axis.set_yticks(
        range(len(pivot.index)),
        [display_method(method) for method in pivot.index],
    )
    for y, method in enumerate(pivot.index):
        for x, problem in enumerate(pivot.columns):
            axis.text(x, y, str(int(pivot.loc[method, problem])), ha="center", va="center")
    fig.colorbar(image, ax=axis, fraction=0.025, pad=0.02)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_delta_bars(rows: list[dict[str, Any]], output_path: Path) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    frame = frame.loc[frame["metric"].isin(DELTA_METRICS[:7])].copy()
    frame["relative_percent"] = frame["relative_delta"].astype(float) * 100.0
    colors = ["#54A24B" if value >= 0 else "#E45756" for value in frame["relative_percent"]]
    fig, axis = plt.subplots(figsize=(7.4, 4.6))
    axis.barh(
        [display_metric(metric) for metric in frame["metric"]],
        frame["relative_percent"],
        color=colors,
    )
    axis.axvline(0.0, color="#333333", linewidth=1.0)
    axis.set_xlabel("Delta vs classic (%)")
    axis.grid(True, axis="x", alpha=0.25)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_validity_gate(rows: list[dict[str, Any]], output_path: Path) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    x_positions = range(len(frame))
    width = 0.36
    fig, axis = plt.subplots(figsize=(6.8, 4.0))
    axis.bar(
        [x - width / 2 for x in x_positions],
        frame["classic_rate"].astype(float),
        width=width,
        label="classic",
        color="#4C78A8",
    )
    axis.bar(
        [x + width / 2 for x in x_positions],
        frame["method_rate"].astype(float),
        width=width,
        label="method",
        color="#F58518",
    )
    axis.set_ylim(0.0, 1.0)
    axis.set_ylabel("Pass rate")
    axis.set_xticks(list(x_positions), frame["stage"])
    axis.grid(True, axis="y", alpha=0.25)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_duplicate_accounting(rows: list[dict[str, Any]], output_path: Path) -> None:
    frame = pd.DataFrame(rows)
    assert not frame.empty
    fig, axis = plt.subplots(figsize=(7.2, 4.2))
    labels = [display_method(method) for method in frame["method_name"]]
    x_positions = range(len(frame))
    axis.bar(
        x_positions,
        frame["unique_canonical_netlist_count"].astype(float),
        label="unique",
        color="#4C78A8",
    )
    axis.bar(
        x_positions,
        frame["duplicate_netlist_count"].astype(float),
        bottom=frame["unique_canonical_netlist_count"].astype(float),
        label="duplicate",
        color="#E45756",
    )
    axis.set_ylabel("Valid-PPA netlists")
    axis.set_xticks(list(x_positions), labels, rotation=20, ha="right")
    axis.grid(True, axis="y", alpha=0.25)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def select_rows(rows: list[dict[str, Any]], methods: list[str]) -> list[dict[str, Any]]:
    wanted = set(methods)
    return [row for row in rows if row["method_name"] in wanted]


def by_method(rows: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    return {row["method_name"]: row for row in rows}


def safe_relative_delta(method_value: float, classic_value: float) -> float:
    if math.isclose(classic_value, 0.0, abs_tol=1e-12):
        return 0.0 if math.isclose(method_value, 0.0, abs_tol=1e-12) else math.inf
    return (method_value - classic_value) / abs(classic_value)


def display_method(method: object) -> str:
    return METHOD_LABELS.get(str(method), str(method))


def display_metric(metric: object) -> str:
    return METRIC_LABELS.get(str(metric), str(metric))


def short_problem_name(problem_id: object) -> str:
    return str(problem_id).split("/")[-1]


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows, f"empty table: {path}"
    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0])
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def load_report(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--central-json", type=Path, required=True)
    parser.add_argument("--method-name", required=True)
    parser.add_argument("--technique-dir", type=Path, required=True)
    args = parser.parse_args(argv)

    report = load_report(args.central_json)
    write_package(
        report=report,
        method_name=args.method_name,
        technique_dir=args.technique_dir,
    )
    print(f"Packaged {args.method_name} into {args.technique_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
