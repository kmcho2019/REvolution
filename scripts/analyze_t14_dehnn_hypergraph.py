#!/usr/bin/env python3
"""Replay T14 DE-HNN-style hypergraph descriptors."""

from __future__ import annotations

import argparse
import importlib.util
import math
import sys
from collections import Counter
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
T07_PATH = REPO_ROOT / "scripts/analyze_t07_deepgate_surrogate.py"
T13_PATH = REPO_ROOT / "scripts/analyze_t13_aurora_autoencoder.py"

HASH_DIMS = 160
DISPLAY = {
    "fitness_top": "Fitness top",
    "generation_prefix": "Generation",
    "lexical_farthest": "Lexical",
    "random": "Random",
    "t14_hyper_stats_farthest": "Hypergraph stats",
    "t14_hyper_hash_farthest": "Hypergraph hash",
    "t14_hyper_combo_farthest": "Hypergraph combo",
    "t14_hyper_impl_combo_farthest": "Hypergraph + impl",
}


def import_module(path: Path, name: str) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault(name, module)
    spec.loader.exec_module(module)
    return module


qwen_audit = import_module(QWEN_AUDIT_PATH, "run_rtl_diversity_wp1_qwen_common_audit")
t33_replay = import_module(T33_REPLAY_PATH, "analyze_t33_qwen_replay")
t07 = import_module(T07_PATH, "analyze_t07_deepgate_surrogate")
t13 = import_module(T13_PATH, "analyze_t13_aurora_autoencoder")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidates-csv", required=True, type=Path)
    parser.add_argument("--graph-manifest-csv", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--retention-fraction", type=float, default=0.5)
    parser.add_argument("--random-seed", type=int, default=0)
    args = parser.parse_args(argv)
    run_analysis(
        candidates_csv=args.candidates_csv,
        graph_manifest_csv=args.graph_manifest_csv,
        package_dir=args.package_dir,
        retention_fraction=args.retention_fraction,
        random_seed=args.random_seed,
    )
    return 0


def run_analysis(
    candidates_csv: Path,
    graph_manifest_csv: Path,
    package_dir: Path,
    retention_fraction: float,
    random_seed: int,
) -> None:
    assert 0.0 < retention_fraction <= 1.0
    candidates = pd.read_csv(candidates_csv)
    graph_manifest = pd.read_csv(graph_manifest_csv)
    hyper_rows, hash_matrix, stats_matrix = hypergraph_features(candidates)
    impl_features, feature_manifest = t13.implementation_features(candidates, graph_manifest)
    impl_matrix = qwen_audit.standardize(impl_features.to_numpy(dtype=float))
    combo = np.hstack([hash_matrix, stats_matrix])
    matrices = {
        "lexical_farthest": qwen_audit.lexical_matrix(candidates),
        "t14_hyper_stats_farthest": qwen_audit.standardize(stats_matrix),
        "t14_hyper_hash_farthest": qwen_audit.standardize(hash_matrix),
        "t14_hyper_combo_farthest": qwen_audit.standardize(combo),
        "t14_hyper_impl_combo_farthest": qwen_audit.standardize(np.hstack([combo, impl_matrix])),
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
    archive = archive_metrics(aggregate, front_metrics, collapse)

    table_dir = package_dir / "tables"
    figure_dir = package_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    pd.DataFrame(hyper_rows).to_csv(table_dir / "hypergraph_features.csv", index=False)
    extraction_funnel(hyper_rows).to_csv(table_dir / "extraction_funnel.csv", index=False)
    feature_manifest.assign(source_family="t13_implementation").to_csv(
        table_dir / "implementation_feature_manifest.csv",
        index=False,
    )
    replay.to_csv(table_dir / "replay_rows.csv", index=False)
    aggregate.to_csv(table_dir / "ppa_comparison.csv", index=False)
    selected.to_csv(table_dir / "selected_candidates.csv", index=False)
    front_metrics.to_csv(table_dir / "ppa_front_metrics.csv", index=False)
    collapse.to_csv(table_dir / "collapse_diagnostics.csv", index=False)
    archive.to_csv(table_dir / "archive_metrics.csv", index=False)
    ppa_front_plot_points(candidates, selected, aggregate).to_csv(
        table_dir / "ppa_front_plot_points.csv",
        index=False,
    )

    plot_hypervolume(aggregate, figure_dir / "dehnn_hypervolume.png")
    plot_projection(hash_matrix, candidates, figure_dir / "hypergraph_projection.png")
    plot_fanout_vs_hv(hyper_rows, replay, figure_dir / "fanout_entropy_vs_hypervolume.png")
    plot_multi_problem_area_power_front(
        candidates,
        selected,
        aggregate,
        figure_dir / "hypergraph_multi_problem_ppa_pareto_fronts.png",
    )
    plot_raw_area_power_front(
        candidates,
        selected,
        aggregate,
        figure_dir / "hypergraph_raw_area_power_pareto_front.png",
    )


def hypergraph_features(candidates: pd.DataFrame) -> tuple[list[dict[str, object]], np.ndarray, np.ndarray]:
    rows = []
    hash_vectors = []
    stat_vectors = []
    for row in candidates.to_dict("records"):
        netlist_path = Path(str(row["netlist_path"]))
        assert netlist_path.is_file(), netlist_path
        graph = parse_hypergraph(netlist_path.read_text(encoding="utf-8", errors="ignore"))
        rows.append(feature_row(row, graph, netlist_path))
        hash_vectors.append(hash_vector(graph))
        stat_vectors.append(stat_vector(graph))
    return rows, np.asarray(hash_vectors, dtype=float), np.asarray(stat_vectors, dtype=float)


def parse_hypergraph(text: str) -> dict[str, object]:
    cells = []
    nets: dict[str, dict[str, list[int]]] = {}
    for match in t07.INSTANCE_RE.finditer(text):
        cell_type = match.group(1)
        body = match.group(3)
        if "." not in body or cell_type in {"module", "assign"}:
            continue
        pins = [(pin, t07.net_tokens(expr)) for pin, expr in t07.PIN_RE.findall(body)]
        outputs = [net for pin, items in pins if t07.is_output_pin(pin) for net in items]
        inputs = [net for pin, items in pins if not t07.is_output_pin(pin) for net in items]
        index = len(cells)
        cells.append({"family": t07.gate_family(cell_type), "input_count": len(inputs), "output_count": len(outputs)})
        for net in outputs:
            nets.setdefault(net, {"drivers": [], "sinks": []})["drivers"].append(index)
        for net in inputs:
            nets.setdefault(net, {"drivers": [], "sinks": []})["sinks"].append(index)
    edges = {
        (source, target)
        for net in nets.values()
        for source in net["drivers"]
        for target in net["sinks"]
        if source != target
    }
    return {"cells": cells, "nets": nets, "edges": sorted(edges)}


def feature_row(row: dict[str, object], graph: dict[str, object], netlist_path: Path) -> dict[str, object]:
    cells = cast(list[dict[str, object]], graph["cells"])
    nets = cast(dict[str, dict[str, list[int]]], graph["nets"])
    edges = cast(list[tuple[int, int]], graph["edges"])
    levels, unresolved = t07.graph_levels(len(cells), edges)
    fanouts = [len(net["sinks"]) for net in nets.values()]
    drivers = [len(net["drivers"]) for net in nets.values()]
    long_edges = level_deltas(nets, levels)
    return {
        "sample_index": to_int(row["sample_index"]),
        "candidate_id": row["candidate_id"],
        "corpus": row["corpus"],
        "problem_id": row["problem_id"],
        "netlist_path": netlist_path.as_posix(),
        "parse_status": "parsed",
        "cell_count": len(cells),
        "net_count": len(nets),
        "directed_edge_count": len(edges),
        "driven_net_count": sum(1 for value in drivers if value > 0),
        "sink_net_count": sum(1 for value in fanouts if value > 0),
        "multi_driver_net_count": sum(1 for value in drivers if value > 1),
        "max_fanout": max(fanouts) if fanouts else 0,
        "mean_fanout": mean(fanouts),
        "fanout_entropy": entropy(fanouts),
        "long_range_edge_share": share_at_least(long_edges, 4),
        "max_level_delta": max(long_edges) if long_edges else 0,
        "max_level": max(levels) if levels else 0,
        "unresolved_cycle_nodes": unresolved,
    }


def stat_vector(graph: dict[str, object]) -> np.ndarray:
    cells = cast(list[dict[str, object]], graph["cells"])
    nets = cast(dict[str, dict[str, list[int]]], graph["nets"])
    edges = cast(list[tuple[int, int]], graph["edges"])
    levels, unresolved = t07.graph_levels(len(cells), edges)
    fanouts = [len(net["sinks"]) for net in nets.values()]
    drivers = [len(net["drivers"]) for net in nets.values()]
    level_delta = level_deltas(nets, levels)
    family_counts = Counter(str(cell["family"]) for cell in cells)
    source_counts, sink_counts = role_family_counts(cells, nets)
    scalars = [
        math.log1p(len(cells)),
        math.log1p(len(nets)),
        math.log1p(len(edges)),
        mean(fanouts),
        max(fanouts) if fanouts else 0.0,
        entropy(fanouts),
        mean(drivers),
        share_at_least(drivers, 2),
        share_equal(drivers, 0),
        share_equal(fanouts, 0),
        mean(level_delta),
        max(level_delta) if level_delta else 0.0,
        share_at_least(level_delta, 4),
        unresolved / max(len(cells), 1),
    ]
    buckets = fanout_buckets(fanouts) + fanout_buckets(drivers)
    families = [
        family_counts[family] / max(len(cells), 1)
        for family in t07.FAMILIES
    ]
    source_share = [
        source_counts[family] / max(sum(source_counts.values()), 1)
        for family in t07.FAMILIES
    ]
    sink_share = [
        sink_counts[family] / max(sum(sink_counts.values()), 1)
        for family in t07.FAMILIES
    ]
    return np.asarray([*scalars, *buckets, *families, *source_share, *sink_share], dtype=float)


def hash_vector(graph: dict[str, object]) -> np.ndarray:
    cells = cast(list[dict[str, object]], graph["cells"])
    nets = cast(dict[str, dict[str, list[int]]], graph["nets"])
    edges = cast(list[tuple[int, int]], graph["edges"])
    levels, _unresolved = t07.graph_levels(len(cells), edges)
    vector = np.zeros(HASH_DIMS, dtype=float)
    for net in nets.values():
        fanout = len(net["sinks"])
        driver_bucket = t07.bucket(len(net["drivers"]))
        fanout_bucket = t07.bucket(fanout)
        deltas = [
            max(levels[sink] - levels[source], 0)
            for source in net["drivers"]
            for sink in net["sinks"]
            if source != sink
        ]
        level_bucket = t07.bucket(max(deltas) if deltas else 0)
        driver_families = role_families(cells, net["drivers"], "PI")
        sink_families = role_families(cells, net["sinks"], "PO")
        add_hash(vector, f"net:{driver_bucket}:{fanout_bucket}:{level_bucket}")
        for family in driver_families:
            add_hash(vector, f"source:{family}:{fanout_bucket}")
        for family in sink_families:
            add_hash(vector, f"sink:{family}:{driver_bucket}")
        for source_family in driver_families:
            for sink_family in sink_families:
                add_hash(vector, f"flow:{source_family}>{sink_family}:{level_bucket}")
    return vector / max(len(nets), 1)


def role_family_counts(
    cells: list[dict[str, object]],
    nets: dict[str, dict[str, list[int]]],
) -> tuple[Counter[str], Counter[str]]:
    source_counts: Counter[str] = Counter()
    sink_counts: Counter[str] = Counter()
    for net in nets.values():
        source_counts.update(role_families(cells, net["drivers"], "PI"))
        sink_counts.update(role_families(cells, net["sinks"], "PO"))
    return source_counts, sink_counts


def role_families(cells: list[dict[str, object]], indexes: list[int], empty: str) -> list[str]:
    if not indexes:
        return [empty]
    return [str(cells[index]["family"]) for index in indexes]


def level_deltas(nets: dict[str, dict[str, list[int]]], levels: list[int]) -> list[int]:
    return [
        max(levels[sink] - levels[source], 0)
        for net in nets.values()
        for source in net["drivers"]
        for sink in net["sinks"]
        if source != sink
    ]


def fanout_buckets(values: list[int]) -> list[float]:
    total = max(len(values), 1)
    return [
        sum(1 for value in values if value == 0) / total,
        sum(1 for value in values if value == 1) / total,
        sum(1 for value in values if 2 <= value <= 3) / total,
        sum(1 for value in values if 4 <= value <= 7) / total,
        sum(1 for value in values if value >= 8) / total,
    ]


def collapse_metrics(candidates: pd.DataFrame, matrices: dict[str, np.ndarray]) -> pd.DataFrame:
    rows = []
    for name, matrix in matrices.items():
        if name == "lexical_farthest":
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
            same_netlist.append(
                text_field(row.to_dict(), "canonical_netlist_hash")
                == text_field(other.to_dict(), "canonical_netlist_hash")
            )
            same_motif.append(
                text_field(row.to_dict(), "motif_signature_hash")
                == text_field(other.to_dict(), "motif_signature_hash")
            )
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


def archive_metrics(aggregate: pd.DataFrame, front: pd.DataFrame, collapse: pd.DataFrame) -> pd.DataFrame:
    lexical = aggregate.loc[aggregate["representation"].eq("lexical_farthest")].iloc[0]
    merged = aggregate.merge(front, on="representation", how="left").merge(collapse, on="representation", how="left")
    rows = []
    for row in merged.to_dict("records"):
        rows.append(
            {
                "representation": row["representation"],
                "selected_hypervolume": to_float(row["selected_hypervolume"]),
                "delta_hv_vs_lexical": to_float(row["selected_hypervolume"])
                - to_float(lexical["selected_hypervolume"]),
                "selected_pareto_size": to_int(row["selected_pareto_size"]),
                "front_hits": optional_int(row.get("selected_all_valid_front_hits")),
                "unique_ppa_points": optional_int(row.get("unique_ppa_points")),
                "same_problem_fraction": optional_float(row.get("same_problem_fraction")),
                "same_corpus_fraction": optional_float(row.get("same_corpus_fraction")),
                "unique_canonical_netlists": to_int(row["unique_canonical_netlists"]),
                "unique_motif_signatures": to_int(row["unique_motif_signatures"]),
            }
        )
    return pd.DataFrame(rows)


def extraction_funnel(rows: list[dict[str, object]]) -> pd.DataFrame:
    frame = pd.DataFrame(rows)
    return pd.DataFrame(
        [
            {"stage": "candidate_rows", "count": len(frame)},
            {"stage": "parsed", "count": int(frame["parse_status"].eq("parsed").sum())},
            {"stage": "has_cells", "count": int(frame["cell_count"].gt(0).sum())},
            {"stage": "has_hyperedges", "count": int(frame["net_count"].gt(0).sum())},
            {"stage": "has_directed_edges", "count": int(frame["directed_edge_count"].gt(0).sum())},
        ]
    )


def ppa_front_plot_points(candidates: pd.DataFrame, selected: pd.DataFrame, aggregate: pd.DataFrame) -> pd.DataFrame:
    rows = []
    best = best_t14(aggregate)
    for focus_row in front_groups(candidates, limit=4):
        focus = pd.Series(focus_row)
        all_valid = focus_candidates(candidates, focus)
        all_front = t33_replay.all_valid_area_power_front(all_valid)
        for row in all_valid.to_dict("records"):
            rows.append(plot_point_row(row, "all_valid", "all_valid", all_front))
        selected_group = focus_candidates(selected, focus)
        for representation in ("lexical_farthest", "random", best):
            rows.extend(
                plot_point_row(row, representation, "selected", all_front)
                for row in selected_group.loc[selected_group["representation"].eq(representation)].to_dict("records")
            )
    return pd.DataFrame(rows)


def front_groups(candidates: pd.DataFrame, limit: int) -> list[dict[str, object]]:
    valid = candidates.loc[candidates["valid_ppa"].astype(bool)]
    rows = []
    for key, group in valid.groupby(["corpus", "method", "seed", "problem_id"], sort=True):
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
    return (
        frame.sort_values(
            ["unique_ppa_points", "front_points", "area_span", "power_span"],
            ascending=False,
        )
        .head(limit)
        .to_dict("records")
    )


def focus_candidates(frame: pd.DataFrame, focus: pd.Series) -> pd.DataFrame:
    return frame.loc[
        frame["corpus"].eq(focus["corpus"])
        & frame["method"].eq(focus["method"])
        & frame["seed"].eq(focus["seed"])
        & frame["problem_id"].eq(focus["problem_id"])
    ]


def plot_point_row(
    row: dict[str, object],
    representation: str,
    point_type: str,
    all_front: set[tuple[float, float]],
) -> dict[str, object]:
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


def plot_hypervolume(aggregate: pd.DataFrame, path: Path) -> None:
    frame = aggregate.copy()
    frame["label"] = frame["representation"].map(label)
    frame = frame.sort_values("selected_hypervolume", ascending=False)
    colors = ["#54A24B" if str(rep).startswith("t14_") else "#4C78A8" for rep in frame["representation"]]
    fig, axis = plt.subplots(figsize=(8.8, 5.0))
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
    axis.set_xlabel("Hypergraph hash PC1")
    axis.set_ylabel("Hypergraph hash PC2")
    axis.grid(True, alpha=0.22)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_fanout_vs_hv(rows: list[dict[str, object]], replay: pd.DataFrame, path: Path) -> None:
    hyper = pd.DataFrame(rows)
    sizes = hyper.groupby("problem_id", as_index=False).agg(fanout_entropy=("fanout_entropy", "mean"))
    best = replay.loc[replay["representation"].eq("t14_hyper_combo_farthest")]
    frame = best.merge(sizes, on="problem_id", how="left")
    fig, axis = plt.subplots(figsize=(7.2, 5.2))
    axis.scatter(frame["fanout_entropy"], frame["selected_hypervolume"], s=32, alpha=0.72, color="#54A24B")
    axis.set_xlabel("Mean Fanout Entropy")
    axis.set_ylabel("Selected Hypervolume")
    axis.grid(True, alpha=0.24)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_raw_area_power_front(
    candidates: pd.DataFrame,
    selected: pd.DataFrame,
    aggregate: pd.DataFrame,
    path: Path,
) -> None:
    focus = t33_replay.focus_group(candidates)
    all_valid = focus_candidates(candidates, focus)
    selected_group = focus_candidates(selected, focus)
    reps = ["lexical_farthest", "random", best_t14(aggregate)]
    fig, axes = plt.subplots(1, 2, figsize=(13.2, 5.6))
    for panel_index, axis in enumerate(axes):
        draw_area_power_panel(axis, all_valid, selected_group, reps, panel_index == 0)
    t33_replay.set_pareto_zoom(axes[1], all_valid)
    axes[0].set_title("Full valid-PPA range")
    axes[1].set_title("Lower-left Pareto zoom")
    title = str(focus["problem_id"]).split("/")[-1]
    fig.suptitle(f"T14 Direct Area-Power Pareto Front: {title}")
    axes[0].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_multi_problem_area_power_front(
    candidates: pd.DataFrame,
    selected: pd.DataFrame,
    aggregate: pd.DataFrame,
    path: Path,
) -> None:
    reps = ["lexical_farthest", "random", best_t14(aggregate)]
    groups = front_groups(candidates, limit=4)
    fig, axes = plt.subplots(2, 2, figsize=(13.0, 9.2), squeeze=False)
    handles = []
    names = []
    for axis, focus_row in zip(axes.ravel(), groups, strict=False):
        focus = pd.Series(focus_row)
        all_valid = focus_candidates(candidates, focus)
        selected_group = focus_candidates(selected, focus)
        draw_area_power_panel(axis, all_valid, selected_group, reps, True)
        axis.set_title(str(focus["problem_id"]).split("/")[-1], fontsize=10)
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
        axis_handles, axis_names = axis.get_legend_handles_labels()
        handles.extend(axis_handles)
        names.extend(axis_names)
    for axis in axes.ravel()[len(groups) :]:
        axis.axis("off")
    unique = dict(zip(names, handles, strict=True))
    fig.legend(unique.values(), unique.keys(), loc="lower center", ncol=min(len(unique), 4), fontsize=8)
    fig.suptitle("T14 Raw Area-Power Pareto Fronts Across Representative Problems")
    fig.tight_layout(rect=(0, 0.06, 1, 0.96))
    fig.savefig(path, dpi=180)
    plt.close(fig)


def draw_area_power_panel(
    axis: Any,
    all_valid: pd.DataFrame,
    selected_group: pd.DataFrame,
    reps: list[str],
    with_labels: bool,
) -> None:
    axis.scatter(
        all_valid["area"],
        all_valid["power"],
        color="#B8B8B8",
        s=24,
        alpha=0.3,
        label="all valid" if with_labels else "_nolegend_",
    )
    t33_replay.draw_front(axis, all_valid, "#111111", "all-valid front" if with_labels else "_nolegend_")
    for representation in reps:
        rows = selected_group.loc[selected_group["representation"].eq(representation)]
        if rows.empty:
            continue
        color = representation_color(representation)
        axis.scatter(
            rows["area"],
            rows["power"],
            s=44,
            label=label(representation) if with_labels else "_nolegend_",
            color=color,
            edgecolor="#222222",
            linewidth=0.35,
        )
        t33_replay.draw_front(axis, rows, color, "_nolegend_")
    axis.set_xlabel("Area (lower is better)")
    axis.set_ylabel("Power (lower is better)")
    axis.grid(True, alpha=0.2)


def nearest_indices(matrix: np.ndarray) -> np.ndarray:
    normalized = normalize_rows(matrix)
    cosine = normalized @ normalized.T
    np.fill_diagonal(cosine, -np.inf)
    return cosine.argmax(axis=1)


def normalize_rows(matrix: np.ndarray) -> np.ndarray:
    norms = np.linalg.norm(matrix, axis=1, keepdims=True)
    norms[norms == 0.0] = 1.0
    return matrix / norms


def pca2(matrix: np.ndarray) -> np.ndarray:
    centered = matrix - matrix.mean(axis=0, keepdims=True)
    _, _, basis = np.linalg.svd(centered, full_matrices=False)
    return centered @ basis[:2].T


def best_t14(aggregate: pd.DataFrame) -> str:
    rows = aggregate.loc[aggregate["representation"].astype(str).str.startswith("t14_")]
    assert not rows.empty
    return str(rows.sort_values("selected_hypervolume", ascending=False).iloc[0]["representation"])


def label(representation: str) -> str:
    return DISPLAY.get(
        representation,
        representation.replace("_farthest", "").replace("t14_", "").replace("_", " "),
    )


def representation_color(representation: str) -> str:
    if representation.startswith("t14_"):
        return "#54A24B"
    if representation == "lexical_farthest":
        return "#4C78A8"
    if representation == "random":
        return "#BAB0AC"
    return "#F58518"


def add_hash(vector: np.ndarray, token: str) -> None:
    index = int(t07.stable_hash(token), 16) % len(vector)
    vector[index] += 1.0


def entropy(values: list[int]) -> float:
    total = len(values)
    if total == 0:
        return 0.0
    counts = Counter(values)
    return float(-sum((count / total) * math.log2(count / total) for count in counts.values()))


def share_at_least(values: list[int], threshold: int) -> float:
    if not values:
        return 0.0
    return sum(1 for value in values if value >= threshold) / len(values)


def share_equal(values: list[int], expected: int) -> float:
    if not values:
        return 0.0
    return sum(1 for value in values if value == expected) / len(values)


def mean(values: list[int]) -> float:
    if not values:
        return 0.0
    return float(sum(values) / len(values))


def text_field(row: dict[str, Any], key: str) -> str:
    value = row.get(key, "")
    if pd.isna(value):
        return ""
    return str(value)


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


if __name__ == "__main__":
    raise SystemExit(main())
