#!/usr/bin/env python3
"""Replay DeepGate-family graph-surrogate descriptors for T07."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import math
import re
import sys
from collections import Counter, deque
from pathlib import Path
from typing import Any, cast

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
QWEN_AUDIT_PATH = REPO_ROOT / "scripts/run_rtl_diversity_wp1_qwen_common_audit.py"
T33_REPLAY_PATH = REPO_ROOT / "scripts/analyze_t33_qwen_replay.py"

INSTANCE_RE = re.compile(r"^\s*([A-Za-z_][\w$]*)\s+([\\\w$.\[\]]+)\s*\((.*?)\);", re.MULTILINE | re.DOTALL)
PIN_RE = re.compile(r"\.([A-Za-z_][\w$]*)\s*\((.*?)\)", re.DOTALL)
NET_RE = re.compile(r"\\[^\s,{}()]+|[A-Za-z_][\w$]*(?:\[[^\]]+\])?")
OUTPUT_PINS = {"Y", "Z", "ZN", "Q", "QN", "S", "CO", "COUT", "SUM"}
FAMILIES = (
    "INV",
    "BUF",
    "NAND",
    "NOR",
    "AND",
    "OR",
    "XOR",
    "XNOR",
    "AOI",
    "OAI",
    "MUX",
    "DFF",
    "LATCH",
    "ADD",
    "OTHER",
)
HASH_DIMS = 128
WL_ROUNDS = 3


def import_module(path: Path, name: str) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault(name, module)
    spec.loader.exec_module(module)
    return module


qwen_audit = import_module(QWEN_AUDIT_PATH, "run_rtl_diversity_wp1_qwen_common_audit")
t33_replay = import_module(T33_REPLAY_PATH, "analyze_t33_qwen_replay")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidates-csv", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--retention-fraction", type=float, default=0.5)
    parser.add_argument("--random-seed", type=int, default=0)
    args = parser.parse_args(argv)

    run_analysis(
        candidates_csv=args.candidates_csv,
        package_dir=args.package_dir,
        retention_fraction=args.retention_fraction,
        random_seed=args.random_seed,
    )
    return 0


def run_analysis(
    candidates_csv: Path,
    package_dir: Path,
    retention_fraction: float,
    random_seed: int,
) -> None:
    assert 0.0 < retention_fraction <= 1.0
    candidates = pd.read_csv(candidates_csv)
    graph_rows, graph_matrix, stats_matrix = graph_features(candidates)
    matrices = {
        "lexical_farthest": qwen_audit.lexical_matrix(candidates),
        "t07_graph_wl_farthest": qwen_audit.standardize(graph_matrix),
        "t07_graph_stats_farthest": qwen_audit.standardize(stats_matrix),
        "t07_graph_combo_farthest": qwen_audit.standardize(np.hstack([graph_matrix, stats_matrix])),
    }
    replay = qwen_audit.replay_rows(
        candidates,
        matrices,
        retention_fraction=retention_fraction,
        random_seed=random_seed,
    )
    aggregate = qwen_audit.aggregate_replay(replay)
    selected = t33_replay.selected_candidate_rows(candidates, matrices, retention_fraction, random_seed)
    front_metrics = t33_replay.ppa_front_metrics(candidates, selected)
    collapse = collapse_metrics(candidates, matrices)
    vs_controls = deltas(aggregate, front_metrics, collapse)

    table_dir = package_dir / "tables"
    figure_dir = package_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    pd.DataFrame(graph_rows).to_csv(table_dir / "netlist_graph_manifest.csv", index=False)
    replay.to_csv(table_dir / "replay_rows.csv", index=False)
    aggregate.to_csv(table_dir / "ppa_comparison.csv", index=False)
    selected.to_csv(table_dir / "selected_candidates.csv", index=False)
    front_metrics.to_csv(table_dir / "ppa_front_metrics.csv", index=False)
    collapse.to_csv(table_dir / "collapse_diagnostics.csv", index=False)
    vs_controls.to_csv(table_dir / "archive_metrics.csv", index=False)
    dependency_status().to_csv(table_dir / "dependency_status.csv", index=False)
    ppa_front_plot_points(candidates, selected, aggregate).to_csv(
        table_dir / "ppa_front_plot_points.csv",
        index=False,
    )

    plot_hypervolume(aggregate, figure_dir / "deepgate_surrogate_hypervolume.png")
    plot_projection(graph_matrix, candidates, figure_dir / "deepgate_projection.png")
    plot_size_vs_hv(graph_rows, replay, figure_dir / "graph_size_vs_embedding.png")
    plot_multi_problem_area_power_front(
        candidates,
        selected,
        aggregate,
        figure_dir / "deepgate_multi_problem_ppa_pareto_fronts.png",
    )
    plot_raw_area_power_front(
        candidates,
        selected,
        aggregate,
        figure_dir / "deepgate_raw_area_power_pareto_front.png",
    )


def graph_features(candidates: pd.DataFrame) -> tuple[list[dict[str, object]], np.ndarray, np.ndarray]:
    rows = []
    graph_vectors = []
    stat_vectors = []
    for row in candidates.to_dict("records"):
        netlist_path = Path(str(row["netlist_path"]))
        assert netlist_path.is_file(), netlist_path
        graph = parse_netlist(netlist_path.read_text(encoding="utf-8", errors="ignore"))
        rows.append(manifest_row(row, graph, netlist_path))
        graph_vectors.append(wl_vector(graph))
        stat_vectors.append(stat_vector(graph))
    return rows, np.asarray(graph_vectors, dtype=float), np.asarray(stat_vectors, dtype=float)


def parse_netlist(text: str) -> dict[str, object]:
    cells = []
    producers: dict[str, int] = {}
    consumers: dict[str, list[int]] = {}
    for match in INSTANCE_RE.finditer(text):
        cell_type = match.group(1)
        body = match.group(3)
        if "." not in body or cell_type in {"module", "assign"}:
            continue
        pins = [(pin, net_tokens(expr)) for pin, expr in PIN_RE.findall(body)]
        outputs = [net for pin, nets in pins if is_output_pin(pin) for net in nets]
        inputs = [net for pin, nets in pins if not is_output_pin(pin) for net in nets]
        index = len(cells)
        cells.append({"family": gate_family(cell_type), "inputs": inputs, "outputs": outputs})
        for net in outputs:
            producers[net] = index
        for net in inputs:
            consumers.setdefault(net, []).append(index)
    edges = set()
    for net, source in producers.items():
        for target in consumers.get(net, []):
            if source != target:
                edges.add((source, target))
    return {"cells": cells, "edges": sorted(edges), "net_count": len(set(producers) | set(consumers))}


def net_tokens(expr: str) -> list[str]:
    tokens = []
    for token in NET_RE.findall(expr):
        if token in {"1'b0", "1'b1", "1'h0", "1'h1"}:
            continue
        if token.isdigit():
            continue
        tokens.append(token)
    return tokens


def is_output_pin(pin: str) -> bool:
    return pin.upper() in OUTPUT_PINS or pin.upper().startswith("Q")


def gate_family(cell_type: str) -> str:
    upper = cell_type.upper()
    if upper.startswith("SDFF") or upper.startswith("DFF") or upper.startswith("$_DFF"):
        return "DFF"
    if "LATCH" in upper or upper.startswith("DLH"):
        return "LATCH"
    if upper.startswith("AOI"):
        return "AOI"
    if upper.startswith("OAI"):
        return "OAI"
    if upper.startswith("XNOR"):
        return "XNOR"
    if upper.startswith("XOR"):
        return "XOR"
    if upper.startswith("NAND"):
        return "NAND"
    if upper.startswith("NOR"):
        return "NOR"
    if upper.startswith("INV"):
        return "INV"
    if upper.startswith("BUF"):
        return "BUF"
    if upper.startswith("MUX"):
        return "MUX"
    if upper.startswith("AND"):
        return "AND"
    if upper.startswith("OR"):
        return "OR"
    if upper.startswith("ADD") or upper.startswith("FA") or upper.startswith("HA"):
        return "ADD"
    return "OTHER"


def manifest_row(row: dict[str, object], graph: dict[str, object], netlist_path: Path) -> dict[str, object]:
    cells = cast(list[dict[str, object]], graph["cells"])
    edges = cast(list[tuple[int, int]], graph["edges"])
    levels, unresolved = graph_levels(len(cells), edges)
    family_counts = Counter(str(cell["family"]) for cell in cells)
    return {
        "sample_index": to_int(row["sample_index"]),
        "candidate_id": row["candidate_id"],
        "corpus": row["corpus"],
        "problem_id": row["problem_id"],
        "netlist_path": netlist_path.as_posix(),
        "parse_status": "parsed",
        "node_count": len(cells),
        "edge_count": len(edges),
        "net_count": to_int(graph["net_count"]),
        "max_level": max(levels) if levels else 0,
        "unresolved_cycle_nodes": unresolved,
        **{f"family_{family.lower()}": family_counts[family] for family in FAMILIES},
    }


def stat_vector(graph: dict[str, object]) -> np.ndarray:
    cells = cast(list[dict[str, object]], graph["cells"])
    edges = cast(list[tuple[int, int]], graph["edges"])
    levels, unresolved = graph_levels(len(cells), edges)
    fanin, fanout = degrees(len(cells), edges)
    family_counts = Counter(str(cell["family"]) for cell in cells)
    scalars = [
        math.log1p(len(cells)),
        math.log1p(len(edges)),
        math.log1p(to_int(graph["net_count"])),
        mean(fanin),
        max(fanin) if fanin else 0.0,
        mean(fanout),
        max(fanout) if fanout else 0.0,
        math.log1p(max(levels) if levels else 0),
        unresolved / max(len(cells), 1),
    ]
    family_values = [math.log1p(family_counts[family]) for family in FAMILIES]
    family_share = [family_counts[family] / max(len(cells), 1) for family in FAMILIES]
    return np.asarray([*scalars, *family_values, *family_share], dtype=float)


def wl_vector(graph: dict[str, object]) -> np.ndarray:
    cells = cast(list[dict[str, object]], graph["cells"])
    edges = cast(list[tuple[int, int]], graph["edges"])
    predecessors = [[] for _ in cells]
    successors = [[] for _ in cells]
    fanin, fanout = degrees(len(cells), edges)
    for source, target in edges:
        successors[source].append(target)
        predecessors[target].append(source)
    colors = [f"{cell['family']}:{bucket(fanin[i])}:{bucket(fanout[i])}" for i, cell in enumerate(cells)]
    vector = np.zeros(HASH_DIMS, dtype=float)
    add_colors(vector, colors)
    for _ in range(WL_ROUNDS):
        colors = [
            stable_hash(
                "|".join(
                    [
                        colors[index],
                        ",".join(sorted(colors[item] for item in predecessors[index])),
                        ",".join(sorted(colors[item] for item in successors[index])),
                    ]
                )
            )
            for index in range(len(cells))
        ]
        add_colors(vector, colors)
    return vector / max(len(cells), 1)


def add_colors(vector: np.ndarray, colors: list[str]) -> None:
    for color in colors:
        vector[hash_index(color)] += 1.0


def graph_levels(node_count: int, edges: list[tuple[int, int]]) -> tuple[list[int], int]:
    incoming = [0 for _ in range(node_count)]
    outgoing = [[] for _ in range(node_count)]
    for source, target in edges:
        incoming[target] += 1
        outgoing[source].append(target)
    levels = [0 for _ in range(node_count)]
    queue = deque(index for index, count in enumerate(incoming) if count == 0)
    visited = 0
    while queue:
        node = queue.popleft()
        visited += 1
        for target in outgoing[node]:
            levels[target] = max(levels[target], levels[node] + 1)
            incoming[target] -= 1
            if incoming[target] == 0:
                queue.append(target)
    return levels, node_count - visited


def degrees(node_count: int, edges: list[tuple[int, int]]) -> tuple[list[int], list[int]]:
    fanin = [0 for _ in range(node_count)]
    fanout = [0 for _ in range(node_count)]
    for source, target in edges:
        fanout[source] += 1
        fanin[target] += 1
    return fanin, fanout


def bucket(value: int) -> str:
    if value <= 1:
        return str(value)
    if value <= 3:
        return "2_3"
    return "4p"


def stable_hash(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()[:16]


def hash_index(text: str) -> int:
    return int(stable_hash(text), 16) % HASH_DIMS


def collapse_metrics(candidates: pd.DataFrame, matrices: dict[str, np.ndarray]) -> pd.DataFrame:
    rows = []
    for name, matrix in matrices.items():
        if name in {"lexical_farthest"}:
            continue
        nearest = nearest_indices(matrix)
        same_problem = []
        same_corpus = []
        same_netlist = []
        same_motif = []
        for index, other_index in enumerate(nearest):
            row = candidates.iloc[index]
            other = candidates.iloc[int(other_index)]
            same_problem.append(row["problem_id"] == other["problem_id"])
            same_corpus.append(row["corpus"] == other["corpus"])
            same_netlist.append(t33_replay.text_field(row.to_dict(), "canonical_netlist_hash") == t33_replay.text_field(other.to_dict(), "canonical_netlist_hash"))
            same_motif.append(t33_replay.text_field(row.to_dict(), "motif_signature_hash") == t33_replay.text_field(other.to_dict(), "motif_signature_hash"))
        rows.append(
            {
                "representation": name,
                "same_problem_fraction": float(np.mean(same_problem)),
                "same_corpus_fraction": float(np.mean(same_corpus)),
                "same_canonical_netlist_fraction": float(np.mean(same_netlist)),
                "same_motif_signature_fraction": float(np.mean(same_motif)),
            }
        )
    return pd.DataFrame(rows)


def nearest_indices(matrix: np.ndarray) -> np.ndarray:
    normalized = normalize_rows(matrix)
    cosine = normalized @ normalized.T
    np.fill_diagonal(cosine, -np.inf)
    return cosine.argmax(axis=1)


def normalize_rows(matrix: np.ndarray) -> np.ndarray:
    norms = np.linalg.norm(matrix, axis=1, keepdims=True)
    norms[norms == 0.0] = 1.0
    return matrix / norms


def deltas(aggregate: pd.DataFrame, front: pd.DataFrame, collapse: pd.DataFrame) -> pd.DataFrame:
    lexical = aggregate.loc[aggregate["representation"].eq("lexical_farthest")].iloc[0]
    merged = aggregate.merge(front, on="representation", how="left").merge(collapse, on="representation", how="left")
    rows = []
    for row in merged.to_dict("records"):
        rows.append(
            {
                "representation": row["representation"],
                "selected_hypervolume": float(row["selected_hypervolume"]),
                "delta_hv_vs_lexical": float(row["selected_hypervolume"]) - float(lexical["selected_hypervolume"]),
                "selected_pareto_size": int(row["selected_pareto_size"]),
                "front_hits": optional_int(row.get("selected_all_valid_front_hits")),
                "unique_ppa_points": optional_int(row.get("unique_ppa_points")),
                "same_problem_fraction": optional_float(row.get("same_problem_fraction")),
                "same_corpus_fraction": optional_float(row.get("same_corpus_fraction")),
                "unique_canonical_netlists": int(row["unique_canonical_netlists"]),
                "unique_motif_signatures": int(row["unique_motif_signatures"]),
            }
        )
    return pd.DataFrame(rows)


def dependency_status() -> pd.DataFrame:
    return pd.DataFrame(
        [
            {
                "check": "prior_deepgate3_aig_probe",
                "status": "success_tiny_probe",
                "detail": "9 AIG exports, 6 latch-free parses, 3 latch-bearing rejects in exp/diversity_check/deepgate3_aig_probe_20260621_034421_UTC",
            },
            {
                "check": "prior_deepgate3_embedding_probe",
                "status": "collapsed_tiny_probe",
                "detail": "3 tokenizer embeddings, pairwise cosine mean 0.999970734; not usable as a full replay descriptor",
            },
            {
                "check": "current_deepgate_env_import",
                "status": "partial",
                "detail": "deepgate 2.0.1 and torch import in exp/diversity_check/encoder_envs/deepgate3_probe; deepgate3 and dgl are not importable",
            },
            {
                "check": "t07_surrogate_route",
                "status": "used",
                "detail": "standard-cell graph WL surrogate over all 768 synthesized netlists",
            },
        ]
    )


def optional_float(value: object) -> float:
    if value is None:
        return math.nan
    if isinstance(value, int | float | np.integer | np.floating):
        return float(value)
    return math.nan


def optional_int(value: object) -> int:
    if value is None:
        return 0
    if isinstance(value, int | float | np.integer | np.floating):
        return int(value)
    return 0


def to_int(value: object) -> int:
    assert isinstance(value, int | float | np.integer | np.floating)
    return int(value)


def to_float(value: object) -> float:
    assert isinstance(value, int | float | np.integer | np.floating)
    return float(value)


def plot_hypervolume(aggregate: pd.DataFrame, path: Path) -> None:
    frame = aggregate.copy()
    frame["label"] = frame["representation"].map(label)
    frame = frame.sort_values("selected_hypervolume", ascending=False)
    colors = ["#54A24B" if str(rep).startswith("t07_") else "#4C78A8" for rep in frame["representation"]]
    fig, axis = plt.subplots(figsize=(8.6, 4.8))
    axis.barh(frame["label"], frame["selected_hypervolume"], color=colors)
    lexical = frame.loc[frame["representation"].eq("lexical_farthest")].iloc[0]
    axis.axvline(float(lexical["selected_hypervolume"]), color="#333333", linestyle="--", linewidth=1.0)
    axis.set_xlabel("Selected Hypervolume")
    axis.grid(True, axis="x", alpha=0.24)
    axis.invert_yaxis()
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_projection(matrix: np.ndarray, candidates: pd.DataFrame, path: Path) -> None:
    projection = pca2(qwen_audit.standardize(matrix))
    fig, axis = plt.subplots(figsize=(7.2, 5.6))
    for corpus, group in candidates.assign(pc1=projection[:, 0], pc2=projection[:, 1]).groupby("corpus"):
        axis.scatter(group["pc1"], group["pc2"], s=24, alpha=0.72, label=str(corpus))
    axis.set_xlabel("Graph WL PC1")
    axis.set_ylabel("Graph WL PC2")
    axis.grid(True, alpha=0.22)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_size_vs_hv(graph_rows: list[dict[str, object]], replay: pd.DataFrame, path: Path) -> None:
    graph_frame = pd.DataFrame(graph_rows)
    sizes = graph_frame.groupby("problem_id", as_index=False).agg(node_count=("node_count", "mean"))
    hv = replay.loc[replay["representation"].eq("t07_graph_wl_farthest")]
    frame = hv.merge(sizes, on="problem_id", how="left")
    fig, axis = plt.subplots(figsize=(7.2, 5.2))
    axis.scatter(frame["node_count"], frame["selected_hypervolume"], s=32, alpha=0.72, color="#54A24B")
    axis.set_xlabel("Mean parsed graph nodes")
    axis.set_ylabel("Selected Hypervolume")
    axis.grid(True, alpha=0.24)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_raw_area_power_front(candidates: pd.DataFrame, selected: pd.DataFrame, aggregate: pd.DataFrame, path: Path) -> None:
    focus = t33_replay.focus_group(candidates)
    all_valid = focus_candidates(candidates, focus)
    selected_group = focus_candidates(selected, focus)
    best = best_t07(aggregate)
    reps = ["lexical_farthest", "random", best]
    fig, axes = plt.subplots(1, 2, figsize=(13.2, 5.6))
    for panel_index, axis in enumerate(axes):
        axis.scatter(
            all_valid["area"],
            all_valid["power"],
            color="#B8B8B8",
            s=28,
            alpha=0.32,
            label="all valid candidates" if panel_index == 0 else "_nolegend_",
        )
        t33_replay.draw_front(axis, all_valid, "#111111", "all-valid Pareto front" if panel_index == 0 else "_nolegend_")
        for representation in reps:
            rows = selected_group.loc[selected_group["representation"].eq(representation)]
            if rows.empty:
                continue
            color = "#54A24B" if representation.startswith("t07_") else "#4C78A8" if representation == "lexical_farthest" else "#BAB0AC"
            axis.scatter(
                rows["area"],
                rows["power"],
                s=58,
                label=label(representation) if panel_index == 0 else "_nolegend_",
                color=color,
                edgecolor="#222222",
                linewidth=0.4,
            )
            t33_replay.draw_front(axis, rows, color, "_nolegend_")
        axis.set_xlabel("Area (lower is better)")
        axis.set_ylabel("Power (lower is better)")
        axis.grid(True, alpha=0.22)
    t33_replay.set_pareto_zoom(axes[1], all_valid)
    axes[0].set_title("Full valid-PPA range")
    axes[1].set_title("Lower-left Pareto zoom")
    title = str(focus["problem_id"]).split("/")[-1]
    fig.suptitle(f"T07 Direct Area-Power Pareto Front: {title}")
    axes[0].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_multi_problem_area_power_front(candidates: pd.DataFrame, selected: pd.DataFrame, aggregate: pd.DataFrame, path: Path) -> None:
    best = best_t07(aggregate)
    reps = ["lexical_farthest", "random", best]
    groups = front_groups(candidates, limit=4)
    fig, axes = plt.subplots(2, 2, figsize=(13.0, 9.2), squeeze=False)
    handles = []
    labels = []
    for axis, focus_row in zip(axes.ravel(), groups, strict=False):
        focus = pd.Series(focus_row)
        all_valid = focus_candidates(candidates, focus)
        selected_group = focus_candidates(selected, focus)
        axis.scatter(all_valid["area"], all_valid["power"], color="#B8B8B8", s=20, alpha=0.28, label="all valid")
        t33_replay.draw_front(axis, all_valid, "#111111", "all-valid front")
        for representation in reps:
            rows = selected_group.loc[selected_group["representation"].eq(representation)]
            if rows.empty:
                continue
            color = representation_color(representation)
            axis.scatter(
                rows["area"],
                rows["power"],
                s=42,
                label=label(representation),
                color=color,
                edgecolor="#222222",
                linewidth=0.35,
            )
            t33_replay.draw_front(axis, rows, color, "_nolegend_")
        title = str(focus["problem_id"]).split("/")[-1]
        axis.set_title(title, fontsize=10)
        axis.set_xlabel("Area (lower is better)")
        axis.set_ylabel("Power (lower is better)")
        axis.grid(True, alpha=0.2)
        axis.text(
            0.02,
            0.96,
            "lower-left is better",
            transform=axis.transAxes,
            fontsize=8,
            color="#333333",
            va="top",
            bbox={"facecolor": "white", "edgecolor": "none", "alpha": 0.7, "pad": 2.0},
        )
        axis_handles, axis_labels = axis.get_legend_handles_labels()
        handles.extend(axis_handles)
        labels.extend(axis_labels)
    for axis in axes.ravel()[len(groups) :]:
        axis.axis("off")
    unique = dict(zip(labels, handles, strict=True))
    fig.legend(unique.values(), unique.keys(), loc="lower center", ncol=min(len(unique), 4), fontsize=8)
    fig.suptitle("T07 Raw Area-Power Pareto Fronts Across Representative Problems")
    fig.tight_layout(rect=(0, 0.06, 1, 0.96))
    fig.savefig(path, dpi=180)
    plt.close(fig)


def ppa_front_plot_points(candidates: pd.DataFrame, selected: pd.DataFrame, aggregate: pd.DataFrame) -> pd.DataFrame:
    best = best_t07(aggregate)
    rows = []
    for focus_row in front_groups(candidates, limit=4):
        focus = pd.Series(focus_row)
        all_valid = focus_candidates(candidates, focus)
        all_front = t33_replay.all_valid_area_power_front(all_valid)
        for row in all_valid.to_dict("records"):
            rows.append(plot_point_row(row, "all_valid", "all_valid", all_front))
        selected_group = focus_candidates(selected, focus)
        for representation in ("lexical_farthest", "random", best):
            for row in selected_group.loc[selected_group["representation"].eq(representation)].to_dict("records"):
                rows.append(plot_point_row(row, representation, "selected", all_front))
    return pd.DataFrame(rows)


def front_groups(candidates: pd.DataFrame, limit: int) -> list[dict[str, object]]:
    assert "valid_ppa" in candidates
    valid = candidates.loc[candidates["valid_ppa"].astype(bool)]
    rows = []
    groups = valid.groupby(["corpus", "method", "seed", "problem_id"], sort=True)
    for key, group in groups:
        corpus, method, seed, problem = cast(tuple[str, str, int, str], key)
        rows.append(
            {
                "corpus": corpus,
                "method": method,
                "seed": int(seed),
                "problem_id": problem,
                "unique_ppa_points": t33_replay.unique_ppa_points(group),
                "front_points": len(t33_replay.pareto_rows(group)),
                "area_span": float(group["area"].max() - group["area"].min()),
                "power_span": float(group["power"].max() - group["power"].min()),
            }
        )
    frame = pd.DataFrame(rows)
    assert not frame.empty
    frame = frame.sort_values(
        ["unique_ppa_points", "front_points", "area_span", "power_span"],
        ascending=False,
    ).head(limit)
    return frame.to_dict("records")


def plot_point_row(row: dict[str, object], representation: str, point_type: str, all_front: set[tuple[float, float]]) -> dict[str, object]:
    point = (round(to_float(row["area"]), 9), round(to_float(row["power"]), 12))
    return {
        "representation": representation,
        "point_type": point_type,
        "corpus": row["corpus"],
        "method": row["method"],
        "seed": to_int(row["seed"]),
        "problem_id": row["problem_id"],
        "candidate_id": row["candidate_id"],
        "area": to_float(row["area"]),
        "power": to_float(row["power"]),
        "eff_clk_period": to_float(row["eff_clk_period"]),
        "fitness": to_float(row["fitness"]),
        "is_all_valid_area_power_front": point in all_front,
    }


def focus_candidates(frame: pd.DataFrame, focus: pd.Series) -> pd.DataFrame:
    return frame.loc[
        frame["corpus"].eq(focus["corpus"])
        & frame["method"].eq(focus["method"])
        & frame["seed"].eq(focus["seed"])
        & frame["problem_id"].eq(focus["problem_id"])
    ]


def pca2(matrix: np.ndarray) -> np.ndarray:
    centered = matrix - matrix.mean(axis=0, keepdims=True)
    _, _, basis = np.linalg.svd(centered, full_matrices=False)
    return centered @ basis[:2].T


def best_t07(aggregate: pd.DataFrame) -> str:
    rows = aggregate.loc[aggregate["representation"].astype(str).str.startswith("t07_")]
    assert not rows.empty
    return str(rows.sort_values("selected_hypervolume", ascending=False).iloc[0]["representation"])


def label(representation: str) -> str:
    return representation.replace("_farthest", "").replace("t07_", "").replace("_", " ")


def representation_color(representation: str) -> str:
    if representation.startswith("t07_"):
        return "#54A24B"
    if representation == "lexical_farthest":
        return "#4C78A8"
    if representation == "random":
        return "#BAB0AC"
    return "#F58518"


def mean(values: list[int]) -> float:
    if not values:
        return 0.0
    return float(sum(values) / len(values))


if __name__ == "__main__":
    raise SystemExit(main())
