#!/usr/bin/env python3
"""Build the T71 source-aligned RTL-native feature map."""

from __future__ import annotations

import csv
import json
import math
from collections import Counter, defaultdict
from pathlib import Path
from typing import TypeAlias

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D


ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
T70_TABLE = (
    TECHNIQUE.parent
    / "T70_generated_rtl_extractor_smoke/tables/t70_extractor_results.csv"
)
TABLE_DIR = TECHNIQUE / "tables"
FIGURE_DIR = TECHNIQUE / "figures"
FIELDS = [
    "candidate_id",
    "problem",
    "kind",
    "has_synthesis",
    "code_relpath",
    "masterrtl_graph_keys",
    "masterrtl_graph_edges",
    "masterrtl_node_dict",
    "rtltimer_lines",
    "rtltimer_assigns",
    "rtltimer_wires",
    "rtltimer_dff_refs",
    "graph_log_edges",
    "state_log_dff",
    "graph_branching",
    "wire_pressure",
    "timing_state_density",
    "assign_density",
    "operator_scale_bin",
    "state_timing_class",
    "archive_cell",
]
STATE_CLASSES = ["comb", "low_seq", "mid_seq", "high_seq"]
OP_BINS = ["op_q0", "op_q1", "op_q2", "op_q3"]
COLORS = [
    "#1f77b4",
    "#ff7f0e",
    "#2ca02c",
    "#d62728",
    "#9467bd",
    "#8c564b",
    "#e377c2",
]
Value: TypeAlias = str | int | float
FeatureRow: TypeAlias = dict[str, Value]


def main() -> None:
    assert T70_TABLE.is_file()
    TABLE_DIR.mkdir(parents=True, exist_ok=True)
    FIGURE_DIR.mkdir(parents=True, exist_ok=True)

    rows = read_t70_rows()
    feature_rows = build_feature_rows(rows)
    cell_rows = build_cell_rows(feature_rows)
    summary_rows = build_summary_rows(feature_rows)
    metrics = build_metrics(feature_rows, cell_rows)

    write_csv(TABLE_DIR / "t71_source_aligned_feature_table.csv", FIELDS, feature_rows)
    write_csv(
        TABLE_DIR / "t71_archive_cells.csv",
        [
            "archive_cell",
            "operator_scale_bin",
            "state_timing_class",
            "count",
            "problem_count",
            "problems",
            "kinds",
            "candidates",
            "min_graph_edges",
            "max_graph_edges",
            "min_dff_refs",
            "max_dff_refs",
        ],
        cell_rows,
    )
    write_csv(
        TABLE_DIR / "t71_feature_summary.csv",
        ["feature", "min", "median", "max", "unique_values", "meaning"],
        summary_rows,
    )
    (TABLE_DIR / "t71_metrics.json").write_text(
        json.dumps(metrics, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    write_scatter(feature_rows)
    write_heatmap(feature_rows)


def read_t70_rows() -> list[dict[str, str]]:
    with T70_TABLE.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    for row in rows:
        assert row["masterrtl_parse_ok"] == "True"
        assert row["rtltimer_parse_ok"] == "True"
        assert row["masterrtl_graph_edges"]
        assert row["rtltimer_dff_refs"]
    return rows


def build_feature_rows(rows: list[dict[str, str]]) -> list[FeatureRow]:
    ranked = sorted(rows, key=lambda row: (int(row["masterrtl_graph_edges"]), row["candidate_id"]))
    op_bin_by_id = {
        row["candidate_id"]: OP_BINS[min(3, index * 4 // len(ranked))]
        for index, row in enumerate(ranked)
    }
    feature_rows: list[FeatureRow] = []
    for row in rows:
        graph_keys = int(row["masterrtl_graph_keys"])
        graph_edges = int(row["masterrtl_graph_edges"])
        lines = int(row["rtltimer_lines"])
        assigns = int(row["rtltimer_assigns"])
        wires = int(row["rtltimer_wires"])
        dff_refs = int(row["rtltimer_dff_refs"])
        state_class = state_timing_class(dff_refs)
        op_bin = op_bin_by_id[row["candidate_id"]]
        feature_rows.append(
            {
                "candidate_id": row["candidate_id"],
                "problem": row["problem"],
                "kind": row["kind"],
                "has_synthesis": row["has_synthesis"],
                "code_relpath": row["code_relpath"],
                "masterrtl_graph_keys": graph_keys,
                "masterrtl_graph_edges": graph_edges,
                "masterrtl_node_dict": int(row["masterrtl_node_dict"]),
                "rtltimer_lines": lines,
                "rtltimer_assigns": assigns,
                "rtltimer_wires": wires,
                "rtltimer_dff_refs": dff_refs,
                "graph_log_edges": round(math.log1p(graph_edges), 6),
                "state_log_dff": round(math.log1p(dff_refs), 6),
                "graph_branching": round(graph_edges / graph_keys, 6),
                "wire_pressure": round(wires / lines, 6),
                "timing_state_density": round(dff_refs / max(1, wires), 6),
                "assign_density": round(assigns / lines, 6),
                "operator_scale_bin": op_bin,
                "state_timing_class": state_class,
                "archive_cell": f"{op_bin}__{state_class}",
            }
        )
    return feature_rows


def as_int(value: Value) -> int:
    return int(value)


def as_float(value: Value) -> float:
    return float(value)


def state_timing_class(dff_refs: int) -> str:
    if dff_refs == 0:
        return "comb"
    if dff_refs <= 7:
        return "low_seq"
    if dff_refs <= 20:
        return "mid_seq"
    return "high_seq"


def problem_label(problem: str) -> str:
    parts = problem.split("_")
    assert parts[0].startswith("Prob")
    return f"P{parts[0][4:]}"


def build_cell_rows(feature_rows: list[FeatureRow]) -> list[FeatureRow]:
    cells: dict[str, list[FeatureRow]] = defaultdict(list)
    for row in feature_rows:
        cells[str(row["archive_cell"])].append(row)

    cell_rows: list[FeatureRow] = []
    for cell, rows in sorted(cells.items()):
        graph_edges = [as_int(row["masterrtl_graph_edges"]) for row in rows]
        dff_refs = [as_int(row["rtltimer_dff_refs"]) for row in rows]
        cell_rows.append(
            {
                "archive_cell": cell,
                "operator_scale_bin": rows[0]["operator_scale_bin"],
                "state_timing_class": rows[0]["state_timing_class"],
                "count": len(rows),
                "problem_count": len({row["problem"] for row in rows}),
                "problems": ";".join(sorted({str(row["problem"]) for row in rows})),
                "kinds": ";".join(sorted({str(row["kind"]) for row in rows})),
                "candidates": ";".join(str(row["candidate_id"]) for row in rows),
                "min_graph_edges": min(graph_edges),
                "max_graph_edges": max(graph_edges),
                "min_dff_refs": min(dff_refs),
                "max_dff_refs": max(dff_refs),
            }
        )
    return cell_rows


def build_summary_rows(feature_rows: list[FeatureRow]) -> list[FeatureRow]:
    meanings = {
        "masterrtl_graph_edges": "MasterRTL SOG edge count; operator/control/dataflow scale.",
        "masterrtl_node_dict": "MasterRTL parsed node dictionary size.",
        "rtltimer_dff_refs": "RTL-Timer BOG DFF reference count; state/timing morphology.",
        "graph_branching": "MasterRTL edges divided by graph keys.",
        "wire_pressure": "RTL-Timer wires divided by cleaned BOG lines.",
        "timing_state_density": "DFF references divided by wires.",
        "assign_density": "Assignments divided by cleaned BOG lines.",
    }
    rows: list[FeatureRow] = []
    for feature, meaning in meanings.items():
        values = sorted(as_float(row[feature]) for row in feature_rows)
        rows.append(
            {
                "feature": feature,
                "min": round(values[0], 6),
                "median": round(values[len(values) // 2], 6),
                "max": round(values[-1], 6),
                "unique_values": len(set(values)),
                "meaning": meaning,
            }
        )
    return rows


def build_metrics(
    feature_rows: list[FeatureRow], cell_rows: list[FeatureRow]
) -> dict[str, object]:
    cell_counts = Counter(str(row["archive_cell"]) for row in feature_rows)
    entropy = 0.0
    for count in cell_counts.values():
        probability = count / len(feature_rows)
        entropy -= probability * math.log2(probability)
    by_class = Counter(str(row["state_timing_class"]) for row in feature_rows)
    return {
        "candidate_count": len(feature_rows),
        "problem_count": len({row["problem"] for row in feature_rows}),
        "source_table": str(T70_TABLE.relative_to(ROOT)),
        "descriptor_inputs": [
            "masterrtl_graph_edges",
            "masterrtl_graph_keys",
            "masterrtl_node_dict",
            "rtltimer_lines",
            "rtltimer_assigns",
            "rtltimer_wires",
            "rtltimer_dff_refs",
        ],
        "leakage_exclusions": [
            "ppa",
            "fitness",
            "test_pass",
            "pareto_rank",
            "hypervolume",
            "reference_ppa",
        ],
        "possible_cells": len(OP_BINS) * len(STATE_CLASSES),
        "occupied_cells": len(cell_rows),
        "occupancy_fraction": round(len(cell_rows) / (len(OP_BINS) * len(STATE_CLASSES)), 6),
        "largest_cell_count": max(cell_counts.values()),
        "archive_entropy_bits": round(entropy, 6),
        "state_class_counts": dict(sorted(by_class.items())),
        "operator_bin_counts": dict(
            sorted(Counter(str(row["operator_scale_bin"]) for row in feature_rows).items())
        ),
    }


def write_csv(path: Path, fields: list[str], rows: list[FeatureRow]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_scatter(feature_rows: list[FeatureRow]) -> None:
    problems = sorted({str(row["problem"]) for row in feature_rows})
    colors = {problem: COLORS[index % len(COLORS)] for index, problem in enumerate(problems)}
    markers = {"first_raw": "o", "first_synthesized": "s", "last_synthesized": "^"}
    fig, ax = plt.subplots(figsize=(11, 7))
    for row in feature_rows:
        ax.scatter(
            as_float(row["graph_log_edges"]),
            as_float(row["state_log_dff"]),
            s=90,
            marker=markers[str(row["kind"])],
            color=colors[str(row["problem"])],
            edgecolor="#1f2933",
            linewidth=0.8,
            alpha=0.9,
        )
    x_min, x_max = ax.get_xlim()
    label_x = x_min + 0.02 * (x_max - x_min)
    for y_value, label in [
        (math.log1p(1), "seq"),
        (math.log1p(8), "mid seq"),
        (math.log1p(21), "high seq"),
    ]:
        ax.axhline(y_value, color="#8a99a8", linewidth=0.8, linestyle="--")
        ax.text(label_x, y_value + 0.03, label, color="#4b5563", fontsize=9)
    ax.set_title("T71 source-aligned RTL-native descriptor map", fontsize=15)
    ax.set_xlabel("MasterRTL log(1 + graph edges)")
    ax.set_ylabel("RTL-Timer log(1 + DFF references)")
    ax.grid(True, color="#d7dde5", linewidth=0.7, alpha=0.7)
    problem_handles = [
        Line2D(
            [0],
            [0],
            marker="o",
            color="w",
            label=problem_label(problem),
            markerfacecolor=colors[problem],
            markersize=8,
        )
        for problem in problems
    ]
    kind_handles = [
        Line2D([0], [0], marker=marker, color="#1f2933", label=kind, linestyle="", markersize=8)
        for kind, marker in markers.items()
    ]
    legend1 = ax.legend(handles=problem_handles, title="Problem", loc="upper left", bbox_to_anchor=(1.02, 1.0))
    ax.add_artist(legend1)
    ax.legend(handles=kind_handles, title="Sample", loc="lower left", bbox_to_anchor=(1.02, 0.0))
    fig.tight_layout()
    fig.savefig(FIGURE_DIR / "t71_descriptor_scatter.png", dpi=180, bbox_inches="tight")
    plt.close(fig)


def write_heatmap(feature_rows: list[FeatureRow]) -> None:
    counts = Counter(
        (str(row["state_timing_class"]), str(row["operator_scale_bin"]))
        for row in feature_rows
    )
    matrix = [
        [counts[(state_class, op_bin)] for op_bin in OP_BINS]
        for state_class in STATE_CLASSES
    ]
    fig, ax = plt.subplots(figsize=(8.5, 5.8))
    image = ax.imshow(matrix, cmap="YlGnBu", vmin=0)
    ax.set_xticks(range(len(OP_BINS)), OP_BINS)
    ax.set_yticks(range(len(STATE_CLASSES)), STATE_CLASSES)
    ax.set_xlabel("MasterRTL operator-scale quartile")
    ax.set_ylabel("RTL-Timer state/timing class")
    ax.set_title("T71 archive-cell occupancy")
    for y_index, row in enumerate(matrix):
        for x_index, value in enumerate(row):
            text_color = "white" if value >= 3 else "#0f172a"
            ax.text(
                x_index,
                y_index,
                str(value),
                ha="center",
                va="center",
                color=text_color,
                fontsize=12,
            )
    fig.colorbar(image, ax=ax, label="Candidate count", fraction=0.046, pad=0.04)
    fig.tight_layout()
    fig.savefig(FIGURE_DIR / "t71_archive_cell_heatmap.png", dpi=180)
    plt.close(fig)


if __name__ == "__main__":
    main()
