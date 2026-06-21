#!/usr/bin/env python3
"""Package a focused validation matrix for useful-BD lead methods."""

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

FOCUS_METHODS = (
    "classic_revolution",
    "landing_smooth_qd_manual_bd",
    "random_descriptor_qd",
    "sr_random_relu_pca_qd",
    "sr_rff_pca_qd",
)

METHOD_LABELS = {
    "classic_revolution": "Classic",
    "landing_smooth_qd_manual_bd": "Manual BD",
    "random_descriptor_qd": "Random BD",
    "sr_random_relu_pca_qd": "SR ReLU PCA",
    "sr_rff_pca_qd": "SR-RFF PCA",
}

PACKAGE_IDS = {
    "classic_revolution": "baseline",
    "landing_smooth_qd_manual_bd": "baseline",
    "random_descriptor_qd": "T22",
    "sr_random_relu_pca_qd": "T19",
    "sr_rff_pca_qd": "T04",
}

TIER_READS = {
    "classic_revolution": "reference",
    "landing_smooth_qd_manual_bd": "reference",
    "random_descriptor_qd": "T0_control",
    "sr_random_relu_pca_qd": "T0_hv_lead",
    "sr_rff_pca_qd": "T1_near_classic_candidate",
}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--central-json", required=True, type=Path)
    parser.add_argument("--mome-aggregate", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    central = json.loads(args.central_json.read_text(encoding="utf-8"))
    aggregate = pd.read_csv(args.mome_aggregate)
    tables = build_tables(central, aggregate)
    write_package(tables, args.output_dir)
    return 0


def build_tables(
    central: dict[str, Any],
    aggregate: pd.DataFrame,
) -> dict[str, list[dict[str, Any]]]:
    leaderboard = {row["method_name"]: row for row in central["leaderboard"]}
    anytime = {row["method_name"]: row for row in central["anytime_summary"]}
    by_method_mode = {
        (str(row["method_name"]), str(row["retention_mode"])): row
        for row in aggregate.to_dict("records")
    }
    validation = [
        validation_row(method, leaderboard[method], anytime[method], by_method_mode)
        for method in FOCUS_METHODS
    ]
    retention = [
        retention_row(method, by_method_mode)
        for method in FOCUS_METHODS
    ]
    comparisons = comparison_rows(validation)
    return {
        "validation_matrix": validation,
        "local_pareto_retention": retention,
        "comparison_deltas": comparisons,
    }


def validation_row(
    method: str,
    leaderboard: dict[str, Any],
    anytime: dict[str, Any],
    by_method_mode: dict[tuple[str, str], dict[str, Any]],
) -> dict[str, Any]:
    scalar = by_method_mode[(method, "scalar_cell_elite")]
    local = by_method_mode[(method, "bounded_local_pareto")]
    return {
        "package_id": PACKAGE_IDS[method],
        "method_name": method,
        "method_label": METHOD_LABELS[method],
        "tier_read": TIER_READS[method],
        "final_mean_hypervolume": float(leaderboard["mean_hypervolume"]),
        "hv_auc": float(anytime["auc_mean_hypervolume"]),
        "final_mean_best_fitness": float(leaderboard["mean_best_fitness"]),
        "best_fitness_auc": float(anytime["auc_mean_best_fitness"]),
        "valid_ppa_candidate_count": int(leaderboard["valid_ppa_candidate_count"]),
        "common_audit_occupied_cells": int(leaderboard["common_audit_occupied_cells"]),
        "common_audit_qd_score": float(leaderboard["common_audit_qd_score"]),
        "ppa_front_unique_netlist_count": int(
            leaderboard["ppa_front_unique_netlist_count"]
        ),
        "local_retained_candidate_count": int(local["retained_candidate_count"]),
        "local_global_pareto_point_count": int(local["global_pareto_point_count"]),
        "local_ppa_front_unique_netlist_count": int(
            local["ppa_front_unique_netlist_count"]
        ),
        "local_ppa_grid_occupied_cells": int(local["ppa_grid_occupied_cells"]),
        "local_unique_canonical_netlist_count": int(
            local["unique_canonical_netlist_count"]
        ),
        "local_unique_motif_signature_count": int(
            local["unique_motif_signature_count"]
        ),
        "scalar_retained_candidate_count": int(scalar["retained_candidate_count"]),
        "scalar_ppa_front_unique_netlist_count": int(
            scalar["ppa_front_unique_netlist_count"]
        ),
    }


def retention_row(
    method: str,
    by_method_mode: dict[tuple[str, str], dict[str, Any]],
) -> dict[str, Any]:
    scalar = by_method_mode[(method, "scalar_cell_elite")]
    local = by_method_mode[(method, "bounded_local_pareto")]
    return {
        "package_id": PACKAGE_IDS[method],
        "method_name": method,
        "method_label": METHOD_LABELS[method],
        "scalar_retained_candidate_count": int(scalar["retained_candidate_count"]),
        "local_retained_candidate_count": int(local["retained_candidate_count"]),
        "retained_delta": int(local["retained_candidate_count"])
        - int(scalar["retained_candidate_count"]),
        "scalar_global_pareto_point_count": int(scalar["global_pareto_point_count"]),
        "local_global_pareto_point_count": int(local["global_pareto_point_count"]),
        "global_pareto_delta": int(local["global_pareto_point_count"])
        - int(scalar["global_pareto_point_count"]),
        "scalar_ppa_front_unique_netlist_count": int(
            scalar["ppa_front_unique_netlist_count"]
        ),
        "local_ppa_front_unique_netlist_count": int(
            local["ppa_front_unique_netlist_count"]
        ),
        "ppa_front_netlist_delta": int(local["ppa_front_unique_netlist_count"])
        - int(scalar["ppa_front_unique_netlist_count"]),
        "scalar_ppa_grid_occupied_cells": int(scalar["ppa_grid_occupied_cells"]),
        "local_ppa_grid_occupied_cells": int(local["ppa_grid_occupied_cells"]),
        "ppa_grid_cell_delta": int(local["ppa_grid_occupied_cells"])
        - int(scalar["ppa_grid_occupied_cells"]),
        "scalar_mean_hypervolume": float(scalar["mean_hypervolume"]),
        "local_mean_hypervolume": float(local["mean_hypervolume"]),
        "mean_hypervolume_delta": float(local["mean_hypervolume"])
        - float(scalar["mean_hypervolume"]),
    }


def comparison_rows(validation: list[dict[str, Any]]) -> list[dict[str, Any]]:
    by_method = {row["method_name"]: row for row in validation}
    references = ("classic_revolution", "random_descriptor_qd")
    metrics = (
        "final_mean_hypervolume",
        "hv_auc",
        "final_mean_best_fitness",
        "valid_ppa_candidate_count",
        "common_audit_qd_score",
        "local_ppa_front_unique_netlist_count",
        "local_global_pareto_point_count",
    )
    rows = []
    for method in FOCUS_METHODS:
        if method in references:
            continue
        for reference in references:
            for metric in metrics:
                value = float(by_method[method][metric])
                ref_value = float(by_method[reference][metric])
                rows.append(
                    {
                        "method_name": method,
                        "method_label": METHOD_LABELS[method],
                        "reference_method": reference,
                        "reference_label": METHOD_LABELS[reference],
                        "metric": metric,
                        "value": value,
                        "reference_value": ref_value,
                        "delta": value - ref_value,
                        "relative_delta": relative_delta(value, ref_value),
                    }
                )
    return rows


def write_package(tables: dict[str, list[dict[str, Any]]], output_dir: Path) -> None:
    table_dir = output_dir / "tables"
    figure_dir = output_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    for name, rows in tables.items():
        write_csv(table_dir / f"{name}.csv", rows)
    write_figures(tables, figure_dir)


def write_figures(tables: dict[str, list[dict[str, Any]]], figure_dir: Path) -> None:
    validation = pd.DataFrame(tables["validation_matrix"])
    retention = pd.DataFrame(tables["local_pareto_retention"])
    plot_hv_summary(validation, figure_dir / "validation_hv_summary.png")
    plot_local_front_material(retention, figure_dir / "local_pareto_front_material.png")
    plot_control_deltas(
        pd.DataFrame(tables["comparison_deltas"]),
        figure_dir / "deltas_vs_classic_random.png",
    )


def plot_hv_summary(frame: pd.DataFrame, output_path: Path) -> None:
    labels = frame["method_label"].tolist()
    x = list(range(len(labels)))
    fig, axes = plt.subplots(1, 2, figsize=(11.0, 4.2))
    for axis, metric, title in [
        (axes[0], "final_mean_hypervolume", "Final Mean HV"),
        (axes[1], "hv_auc", "HV AUC"),
    ]:
        axis.bar(x, frame[metric], color="#4c78a8")
        axis.set_title(title)
        axis.set_xticks(x)
        axis.set_xticklabels(labels, rotation=30, ha="right")
        axis.grid(axis="y", color="#e0e0e0", linewidth=0.8)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_local_front_material(frame: pd.DataFrame, output_path: Path) -> None:
    labels = frame["method_label"].tolist()
    x = list(range(len(labels)))
    width = 0.36
    fig, axis = plt.subplots(figsize=(10.0, 4.8))
    axis.bar(
        [value - width / 2 for value in x],
        frame["local_global_pareto_point_count"],
        width,
        label="Global Pareto points",
        color="#59a14f",
    )
    axis.bar(
        [value + width / 2 for value in x],
        frame["local_ppa_front_unique_netlist_count"],
        width,
        label="PPA-front netlists",
        color="#f28e2b",
    )
    axis.set_xticks(x)
    axis.set_xticklabels(labels, rotation=30, ha="right")
    axis.set_ylabel("Count under local Pareto retention")
    axis.grid(axis="y", color="#e0e0e0", linewidth=0.8)
    axis.legend(frameon=False)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_control_deltas(frame: pd.DataFrame, output_path: Path) -> None:
    selected = frame.loc[
        frame["method_name"].isin(["sr_random_relu_pca_qd", "sr_rff_pca_qd"])
        & frame["reference_method"].isin(["classic_revolution", "random_descriptor_qd"])
        & frame["metric"].isin(["final_mean_hypervolume", "hv_auc", "common_audit_qd_score"])
    ].copy()
    selected["series"] = selected["method_label"] + " vs " + selected["reference_label"]
    series = selected["series"].drop_duplicates().tolist()
    metrics = ["final_mean_hypervolume", "hv_auc", "common_audit_qd_score"]
    fig, axes = plt.subplots(len(metrics), 1, figsize=(9.8, 7.2), sharex=True)
    for axis, metric in zip(axes, metrics, strict=True):
        values = [
            float(selected.loc[
                selected["series"].eq(name) & selected["metric"].eq(metric),
                "relative_delta",
            ].iloc[0])
            for name in series
        ]
        colors = ["#2d7f5e" if value >= 0.0 else "#b64d4d" for value in values]
        axis.bar(range(len(series)), values, color=colors)
        axis.axhline(0.0, color="#404040", linewidth=0.8)
        axis.set_ylabel(metric.replace("_", "\n"))
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.7)
    axes[-1].set_xticks(range(len(series)))
    axes[-1].set_xticklabels(series, rotation=25, ha="right")
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows, path
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def relative_delta(value: float, reference: float) -> float | None:
    if math.isclose(reference, 0.0):
        return None
    return (value - reference) / abs(reference)


if __name__ == "__main__":
    raise SystemExit(main())
