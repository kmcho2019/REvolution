#!/usr/bin/env python3
"""Build the T80 MasterRTL structural-mix descriptor gate."""

from __future__ import annotations

import csv
import json
import math
from pathlib import Path
from typing import Any

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
T77 = (
    ROOT
    / "docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push"
    / "techniques/T77_masterrtl_area_leaf_variation_gate"
)
T77_FEATURES = T77 / "tables/t77_area_candidate_features.csv"

STRUCTURAL_COLUMNS = (
    "dff_bits",
    "and_ops",
    "or_ops",
    "not_ops",
    "xor_ops",
    "mux_ops",
)
AXES = (
    "source_aligned_masterrtl_seq_fraction",
    "source_aligned_masterrtl_mux_fraction",
    "source_aligned_masterrtl_xor_fraction",
)


def main() -> None:
    assert T77_FEATURES.is_file()
    (TECHNIQUE / "tables").mkdir(exist_ok=True)
    (TECHNIQUE / "figures").mkdir(exist_ok=True)

    rows = descriptor_rows(read_rows(T77_FEATURES))
    occupancy = occupancy_rows(rows)
    summary = summary_row(rows, occupancy)

    write_csv(TECHNIQUE / "tables/t80_candidate_descriptors.csv", rows)
    write_csv(TECHNIQUE / "tables/t80_cell_occupancy.csv", occupancy)
    write_json(TECHNIQUE / "tables/t80_summary.json", summary)
    write_figure(rows, occupancy)


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open() as handle:
        rows = list(csv.DictReader(handle))
    assert len(rows) == 19
    return rows


def descriptor_rows(rows: list[dict[str, str]]) -> list[dict[str, Any]]:
    axis_values = []
    for row in rows:
        values = {name: float(row[name]) for name in STRUCTURAL_COLUMNS}
        operator_count = sum(
            values[name] for name in ("and_ops", "or_ops", "not_ops", "xor_ops", "mux_ops")
        )
        seq_fraction = ratio(values["dff_bits"], values["dff_bits"] + operator_count)
        mux_fraction = ratio(values["mux_ops"], operator_count)
        xor_fraction = ratio(values["xor_ops"], operator_count)
        axis_values.append((seq_fraction, mux_fraction, xor_fraction))

    quantile_cells = quantile_cell_ids(axis_values)
    output = []
    for row, axes, quantile_cell in zip(rows, axis_values, quantile_cells, strict=True):
        static_cell = (
            min(3, int(axes[0] * 4)),
            min(3, int(axes[1] * 4)),
            min(3, int(axes[2] * 4)),
        )
        operator_count = sum(float(row[name]) for name in STRUCTURAL_COLUMNS[1:])
        output.append(
            {
                "candidate_id": row["candidate_id"],
                "problem": row["problem"],
                "kind": row["kind"],
                "code_sha256": row["code_sha256"],
                "operator_count": operator_count,
                "source_aligned_masterrtl_operator_log_count": math.log1p(operator_count),
                AXES[0]: axes[0],
                AXES[1]: axes[1],
                AXES[2]: axes[2],
                "static_cell": cell_name(static_cell),
                "quantile_cell": cell_name(quantile_cell),
                "t77_predicted_area": row["predicted_area"],
                "t77_leaf_row_hash": row["leaf_row_hash"],
            }
        )
    return output


def quantile_cell_ids(axis_values: list[tuple[float, float, float]]) -> list[tuple[int, int, int]]:
    matrix = np.array(axis_values, dtype=float)
    cells = np.zeros(matrix.shape, dtype=int)
    for axis_index in range(matrix.shape[1]):
        order = np.argsort(matrix[:, axis_index], kind="mergesort")
        for rank, row_index in enumerate(order):
            cells[row_index, axis_index] = min(3, int(rank * 4 / len(order)))
    return [
        (int(row[0]), int(row[1]), int(row[2]))
        for row in cells
    ]


def occupancy_rows(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    output = []
    for mode in ("static_cell", "quantile_cell"):
        counts: dict[str, int] = {}
        for row in rows:
            cell = str(row[mode])
            counts[cell] = counts.get(cell, 0) + 1
        for cell, count in sorted(counts.items()):
            output.append({"mode": mode, "cell": cell, "count": count})
    return output


def summary_row(
    rows: list[dict[str, Any]],
    occupancy: list[dict[str, Any]],
) -> dict[str, Any]:
    static_cells = {row["static_cell"] for row in rows}
    quantile_cells = {row["quantile_cell"] for row in rows}
    descriptor_rows_unique = {
        tuple(round(float(row[axis]), 8) for axis in AXES) for row in rows
    }
    leaf_rows = {row["t77_leaf_row_hash"] for row in rows}
    return {
        "tier": "T0_descriptor_gate_positive_not_live",
        "candidate_count": len(rows),
        "unique_descriptor_rows": len(descriptor_rows_unique),
        "static_occupied_cells": len(static_cells),
        "quantile_occupied_cells": len(quantile_cells),
        "static_entropy_bits": entropy([row for row in occupancy if row["mode"] == "static_cell"]),
        "quantile_entropy_bits": entropy(
            [row for row in occupancy if row["mode"] == "quantile_cell"]
        ),
        "t77_unique_leaf_rows": len(leaf_rows),
        "decision": (
            "Advance the raw MasterRTL structural-mix profile to a registered "
            "live candidate only with grid_quantile cells and matched classic "
            "comparison. This gate is not a QD performance result."
        ),
    }


def write_figure(rows: list[dict[str, Any]], occupancy: list[dict[str, Any]]) -> None:
    matrix = np.array([[float(row[axis]) for axis in AXES] for row in rows], dtype=float)
    fig = plt.figure(figsize=(12.5, 7.2))
    grid = fig.add_gridspec(2, 2, width_ratios=[1.4, 1.0])
    ax = fig.add_subplot(grid[:, 0])
    scatter = ax.scatter(
        matrix[:, 1],
        matrix[:, 0],
        c=matrix[:, 2],
        s=90,
        cmap="cividis",
        edgecolors="#202020",
        linewidths=0.5,
    )
    ax.set_title("MasterRTL Structural-Mix Descriptor Space")
    ax.set_xlabel("mux fraction")
    ax.set_ylabel("sequential fraction")
    ax.grid(alpha=0.25)
    fig.colorbar(scatter, ax=ax, label="xor fraction")

    ax2 = fig.add_subplot(grid[0, 1])
    unique_counts = [
        len({tuple(round(float(row[axis]), 8) for axis in AXES) for row in rows}),
        len({row["static_cell"] for row in rows}),
        len({row["quantile_cell"] for row in rows}),
        len({row["t77_leaf_row_hash"] for row in rows}),
    ]
    ax2.bar(
        ["descriptor rows", "static cells", "quantile cells", "T77 leaf rows"],
        unique_counts,
        color=["#3d6f8e", "#71965a", "#c58f39", "#8a4f74"],
    )
    ax2.set_title("Variation Gate")
    ax2.set_ylabel("unique count")
    ax2.tick_params(axis="x", rotation=28)
    ax2.grid(axis="y", alpha=0.25)

    ax3 = fig.add_subplot(grid[1, 1])
    by_mode = {"static_cell": [], "quantile_cell": []}
    for item in occupancy:
        by_mode[str(item["mode"])].append(int(item["count"]))
    ax3.boxplot(
        [by_mode["static_cell"], by_mode["quantile_cell"]],
        tick_labels=["static", "quantile"],
        patch_artist=True,
        boxprops={"facecolor": "#d8e3df"},
        medianprops={"color": "#202020"},
    )
    ax3.set_title("Cell Load Distribution")
    ax3.set_ylabel("candidates per occupied cell")
    ax3.grid(axis="y", alpha=0.25)

    fig.tight_layout()
    fig.savefig(TECHNIQUE / "figures/t80_masterrtl_structural_mix_gate.png", dpi=180)
    plt.close(fig)


def ratio(numerator: float, denominator: float) -> float:
    if denominator == 0:
        return 0.0
    return numerator / denominator


def entropy(rows: list[dict[str, Any]]) -> float:
    total = sum(int(row["count"]) for row in rows)
    assert total > 0
    values = []
    for row in rows:
        probability = int(row["count"]) / total
        values.append(-probability * math.log2(probability))
    return float(sum(values))


def cell_name(cell: tuple[int, int, int]) -> str:
    return f"{cell[0]}:{cell[1]}:{cell[2]}"


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=list(rows[0].keys()),
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
