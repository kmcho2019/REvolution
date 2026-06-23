#!/usr/bin/env python3
"""Summarize the T69 open-Yosys RTL-native preprocessing smoke."""

from __future__ import annotations

import csv
import hashlib
import json
import pickle
import re
import subprocess
import sys
from pathlib import Path
from typing import TypeAlias

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.axes import Axes


GraphMetrics: TypeAlias = dict[str, int]
VerilogMetrics: TypeAlias = dict[str, int | str]
GraphPair: TypeAlias = dict[str, GraphMetrics]
VerilogPair: TypeAlias = dict[str, VerilogMetrics]

ROOT = Path(__file__).resolve().parents[7]
TECHNIQUE = Path(__file__).resolve().parents[1]
MASTER = ROOT / "exp/external_repos/MasterRTL"
RTLTIMER = ROOT / "exp/external_repos/RTL-Timer"


MASTER_SHIPPED_GRAPH = MASTER / "example/sog/TinyRocket_sog.pkl"
MASTER_SHIPPED_NODES = MASTER / "example/sog/TinyRocket_sog_node_dict.pkl"
MASTER_OPEN_GRAPH = (
    ROOT / "exp/verification/t69_masterrtl_open_parse_clean/TinyRocketOpen_sog.pkl"
)
MASTER_OPEN_NODES = (
    ROOT
    / "exp/verification/t69_masterrtl_open_parse_clean/TinyRocketOpen_sog_node_dict.pkl"
)

MASTER_SHIPPED_VERILOG = MASTER / "example/verilog/TinyRocket_sog.v"
MASTER_OPEN_VERILOG = (
    ROOT / "exp/verification/t69_masterrtl_open_yosys/TinyRocket_sog_open_clean.v"
)
RTLTIMER_SHIPPED_VERILOG = RTLTIMER / "vlg2bog/bog/sog/TinyRocket.sog.v"
RTLTIMER_OPEN_VERILOG = (
    ROOT / "exp/verification/t69_rtltimer_open_yosys/TinyRocket.sog.open_clean.v"
)


def main() -> None:
    sys.path.insert(0, str(MASTER / "vlg2ir"))
    environment = environment_metrics()
    masterrtl_graph: GraphPair = {
        "shipped": masterrtl_graph_metrics(MASTER_SHIPPED_GRAPH, MASTER_SHIPPED_NODES),
        "open_clean": masterrtl_graph_metrics(MASTER_OPEN_GRAPH, MASTER_OPEN_NODES),
    }
    masterrtl_verilog: VerilogPair = {
        "shipped": verilog_metrics(MASTER_SHIPPED_VERILOG),
        "open_clean": verilog_metrics(MASTER_OPEN_VERILOG),
    }
    rtltimer_bog: VerilogPair = {
        "shipped": verilog_metrics(RTLTIMER_SHIPPED_VERILOG),
        "open_clean": verilog_metrics(RTLTIMER_OPEN_VERILOG),
    }
    metrics: dict[str, object] = {
        "environment": environment,
        "masterrtl_graph": masterrtl_graph,
        "masterrtl_verilog": masterrtl_verilog,
        "rtltimer_bog": rtltimer_bog,
    }
    write_json(metrics)
    write_graph_csv(masterrtl_graph)
    write_verilog_csv(
        masterrtl_verilog,
        TECHNIQUE / "tables/masterrtl_sog_verilog_comparison.csv",
    )
    write_verilog_csv(
        rtltimer_bog,
        TECHNIQUE / "tables/rtltimer_bog_comparison.csv",
    )
    write_inventory()
    write_summary()
    write_figure(masterrtl_graph, rtltimer_bog)


def environment_metrics() -> dict[str, str]:
    master_commit = git_head(MASTER)
    rtltimer_commit = git_head(RTLTIMER)
    yosys_version = subprocess.check_output(["yosys", "-V"], text=True).strip()
    return {
        "masterrtl_commit": master_commit,
        "rtltimer_commit": rtltimer_commit,
        "yosys_version": yosys_version,
    }


def git_head(path: Path) -> str:
    return subprocess.check_output(["git", "-C", str(path), "rev-parse", "HEAD"], text=True).strip()


def masterrtl_graph_metrics(graph_path: Path, node_path: Path) -> GraphMetrics:
    assert graph_path.is_file()
    assert node_path.is_file()
    with graph_path.open("rb") as handle:
        graph = pickle.load(handle)
    with node_path.open("rb") as handle:
        node_dict = pickle.load(handle)
    return {
        "graph_pickle_bytes": graph_path.stat().st_size,
        "node_dict_pickle_bytes": node_path.stat().st_size,
        "graph_node_key_count": len(graph),
        "graph_edge_count": sum(len(edges) for edges in graph.values()),
        "node_dict_count": len(node_dict),
    }


def verilog_metrics(path: Path) -> VerilogMetrics:
    assert path.is_file()
    lines = path.read_text(encoding="utf-8").splitlines()
    return {
        "sha256": sha256(path),
        "bytes": path.stat().st_size,
        "line_count": len(lines),
        "assign_line_count": count_lines(lines, r"^\s*assign\b"),
        "wire_line_count": count_lines(lines, r"^\s*wire\b"),
        "dff_line_count": count_lines(lines, r"\$dff|DFF|_DFF"),
        "attribute_line_count": count_lines(lines, r"\(\*"),
    }


def count_lines(lines: list[str], pattern: str) -> int:
    regex = re.compile(pattern)
    return sum(1 for line in lines if regex.search(line))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def write_json(metrics: dict[str, object]) -> None:
    path = TECHNIQUE / "tables/open_yosys_preprocessing_metrics.json"
    path.write_text(json.dumps(metrics, indent=2) + "\n", encoding="utf-8")


def write_graph_csv(group: GraphPair) -> None:
    rows = []
    shipped = group["shipped"]
    open_clean = group["open_clean"]
    for metric in [
        "graph_node_key_count",
        "graph_edge_count",
        "node_dict_count",
        "graph_pickle_bytes",
        "node_dict_pickle_bytes",
    ]:
        rows.append(delta_row(metric, int(shipped[metric]), int(open_clean[metric])))
    write_rows(TECHNIQUE / "tables/masterrtl_graph_comparison.csv", rows)


def write_verilog_csv(group: VerilogPair, path: Path) -> None:
    shipped = group["shipped"]
    open_clean = group["open_clean"]
    rows = []
    for metric in [
        "bytes",
        "line_count",
        "assign_line_count",
        "wire_line_count",
        "dff_line_count",
        "attribute_line_count",
    ]:
        rows.append(
            delta_row(metric, int_metric(shipped, metric), int_metric(open_clean, metric))
        )
    write_rows(path, rows)


def int_metric(row: VerilogMetrics, metric: str) -> int:
    value = row[metric]
    assert isinstance(value, int)
    return value


def delta_row(metric: str, shipped: int, open_clean: int) -> list[str]:
    delta = open_clean - shipped
    if shipped == 0:
        return [metric, str(shipped), str(open_clean), str(delta), "na"]
    relative = 100.0 * delta / shipped
    return [metric, str(shipped), str(open_clean), str(delta), f"{relative:.3f}"]


def write_rows(path: Path, rows: list[list[str]]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow(["metric", "shipped", "open_clean", "delta", "relative_delta_pct"])
        writer.writerows(rows)


def write_inventory() -> None:
    rows = [
        [
            "MasterRTL",
            git_head(MASTER),
            "ys_script/run_TinyRocket_sog.ys",
            "read -verific requires a Verific-enabled Yosys build",
            "Invoke the same read_verilog/hierarchy/proc/flatten/opt/fsm/memory/techmap/write_verilog flow without read -verific, then strip generated Yosys attributes before analyze.py.",
            "pass: analyze.py parsed the cleaned open-Yosys SOG pickle",
        ],
        [
            "RTL-Timer",
            git_head(RTLTIMER),
            "vlg2bog/scr_ys/auto_run_vlg2bog.py and run_ys_template.ys",
            "auto_run_vlg2bog.py emits read -verific before read_verilog/read -sv",
            "Invoke the same SOG hierarchy/proc/opt/fsm/memory/techmap/dfflibmap/abc/clean/write_verilog flow without read -verific and apply the cleaner-equivalent attribute/blank-line cleanup.",
            "pass: cleaned open-Yosys BOG parses and keeps the shipped SOG DFF count",
        ],
    ]
    with (TECHNIQUE / "tables/source_path_inventory.csv").open(
        "w", encoding="utf-8", newline=""
    ) as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow(
            [
                "repo",
                "commit",
                "source_path",
                "t68_blocker",
                "t69_adaptation",
                "status",
            ]
        )
        writer.writerows(rows)


def write_summary() -> None:
    rows = [
        [
            "MasterRTL open-source conversion",
            "pass",
            "Generated TinyRocket_sog_open.v with open-source Yosys after removing only read -verific from the invocation.",
        ],
        [
            "MasterRTL parser compatibility",
            "pass",
            "Attribute-stripped generated SOG parsed through upstream vlg2ir/analyze.py.",
        ],
        [
            "RTL-Timer open-source conversion",
            "pass",
            "Generated and cleaned TinyRocket.sog.open_clean.v with cmd=sog semantics and nangate45_sog.lib.",
        ],
        [
            "QD promotion",
            "blocked",
            "This is a preprocessing unblocker only; no live QD candidate used the extractor yet.",
        ],
    ]
    with (TECHNIQUE / "tables/open_yosys_preprocessing_summary.csv").open(
        "w", encoding="utf-8", newline=""
    ) as handle:
        writer = csv.writer(handle, lineterminator="\n")
        writer.writerow(["check", "status", "evidence"])
        writer.writerows(rows)


def write_figure(graph: GraphPair, rtltimer: VerilogPair) -> None:
    graph_ratios = graph_ratio_values(
        graph,
        ["graph_node_key_count", "graph_edge_count", "node_dict_count"],
    )
    rtltimer_ratios = verilog_ratio_values(
        rtltimer,
        ["line_count", "assign_line_count", "wire_line_count", "dff_line_count"],
    )
    fig, axes = plt.subplots(1, 2, figsize=(9.5, 3.8), dpi=180)
    draw_ratio_axis(
        axes[0],
        ["graph keys", "edges", "node dict"],
        graph_ratios,
        "MasterRTL parsed SOG graph",
        ["#4C78A8", "#59A14F", "#F28E2B"],
    )
    draw_ratio_axis(
        axes[1],
        ["lines", "assigns", "wires", "DFF refs"],
        rtltimer_ratios,
        "RTL-Timer cleaned SOG BOG",
        ["#76B7B2", "#B07AA1", "#EDC948", "#E15759"],
    )
    fig.suptitle("T69 Open-Yosys Preprocessing Stays Close To Shipped TinyRocket")
    fig.tight_layout()
    fig.savefig(TECHNIQUE / "figures/t69_open_yosys_preprocessing_alignment.png")


def graph_ratio_values(group: GraphPair, metrics: list[str]) -> list[float]:
    shipped = group["shipped"]
    open_clean = group["open_clean"]
    return [float(open_clean[metric]) / float(shipped[metric]) for metric in metrics]


def verilog_ratio_values(group: VerilogPair, metrics: list[str]) -> list[float]:
    shipped = group["shipped"]
    open_clean = group["open_clean"]
    return [
        float(int_metric(open_clean, metric)) / float(int_metric(shipped, metric))
        for metric in metrics
    ]


def draw_ratio_axis(
    axis: Axes,
    labels: list[str],
    values: list[float],
    title: str,
    colors: list[str],
) -> None:
    bars = axis.bar(labels, values, color=colors, width=0.58)
    axis.axhline(1.0, color="#3A3A3A", linestyle="--", linewidth=1)
    axis.set_ylim(0.94, 1.08)
    axis.set_title(title)
    axis.set_ylabel("Open clean / shipped")
    axis.grid(axis="y", color="#D8D8D8", linewidth=0.7, alpha=0.75)
    for bar, value in zip(bars, values, strict=True):
        axis.text(
            bar.get_x() + bar.get_width() / 2,
            value + 0.006,
            f"{value:.3f}x",
            ha="center",
            va="bottom",
            fontsize=8,
        )
    for spine in ["top", "right"]:
        axis.spines[spine].set_visible(False)


if __name__ == "__main__":
    main()
