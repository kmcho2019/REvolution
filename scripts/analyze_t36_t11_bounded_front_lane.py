#!/usr/bin/env python3
"""Replay T11 descriptors with a bounded local-front retention lane."""

from __future__ import annotations

import argparse
import importlib.util
import json
import math
import sys
from pathlib import Path
from typing import Any, cast

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
T35_PATH = REPO_ROOT / "scripts/analyze_t35_t11_pareto_coupling.py"

DISPLAY = {
    "fitness_top": "Fitness top",
    "generation_prefix": "Generation",
    "lexical_farthest": "Lexical",
    "random": "Random",
    "t11_contrast_top64_farthest": "T11 top-64",
    "t11_contrast_weighted_farthest": "T11 weighted",
    "t35_top64_cell_pareto": "T35 cell Pareto",
    "t35_top64_front_seeded": "T35 front seeded",
    "t36_top64_lane_05": "T36 top-64 5%",
    "t36_top64_lane_10": "T36 top-64 10%",
    "t36_top64_lane_15": "T36 top-64 15%",
    "t36_top64_lane_20": "T36 top-64 20%",
    "t36_weighted_lane_10": "T36 weighted 10%",
    "t36_weighted_lane_20": "T36 weighted 20%",
}
PLOT_REPS = (
    "lexical_farthest",
    "t11_contrast_top64_farthest",
    "t35_top64_cell_pareto",
    "t36_top64_lane_05",
    "t36_top64_lane_10",
    "t36_top64_lane_20",
    "t35_top64_front_seeded",
)
COLORS = {
    "all_valid": "#B8B8B8",
    "lexical_farthest": "#4C78A8",
    "random": "#9D9DA1",
    "t11_contrast_top64_farthest": "#54A24B",
    "t11_contrast_weighted_farthest": "#72B7B2",
    "t35_top64_cell_pareto": "#E45756",
    "t35_top64_front_seeded": "#B279A2",
    "t36_top64_lane_05": "#F58518",
    "t36_top64_lane_10": "#FF9DA6",
    "t36_top64_lane_15": "#A0CBE8",
    "t36_top64_lane_20": "#8CD17D",
    "t36_weighted_lane_10": "#B6992D",
    "t36_weighted_lane_20": "#499894",
}
LANES = (
    ("t36_top64_lane_05", "t11_contrast_top64_farthest", 0.05),
    ("t36_top64_lane_10", "t11_contrast_top64_farthest", 0.10),
    ("t36_top64_lane_15", "t11_contrast_top64_farthest", 0.15),
    ("t36_top64_lane_20", "t11_contrast_top64_farthest", 0.20),
    ("t36_weighted_lane_10", "t11_contrast_weighted_farthest", 0.10),
    ("t36_weighted_lane_20", "t11_contrast_weighted_farthest", 0.20),
)


def import_module(path: Path, name: str) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault(name, module)
    spec.loader.exec_module(module)
    return module


t35 = import_module(T35_PATH, "analyze_t35_t11_pareto_coupling")
qwen_audit = t35.qwen_audit
t11 = t35.t11
t33 = t35.t33


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidates-csv", required=True, type=Path)
    parser.add_argument("--graph-manifest-csv", required=True, type=Path)
    parser.add_argument("--hypergraph-features-csv", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--retention-fraction", type=float, default=0.5)
    parser.add_argument("--random-seed", type=int, default=0)
    parser.add_argument("--cell-bins", type=int, default=2)
    args = parser.parse_args(argv)
    run_analysis(
        candidates_csv=args.candidates_csv,
        graph_manifest_csv=args.graph_manifest_csv,
        hypergraph_features_csv=args.hypergraph_features_csv,
        package_dir=args.package_dir,
        retention_fraction=args.retention_fraction,
        random_seed=args.random_seed,
        cell_bins=args.cell_bins,
    )
    return 0


def run_analysis(
    candidates_csv: Path,
    graph_manifest_csv: Path,
    hypergraph_features_csv: Path,
    package_dir: Path,
    retention_fraction: float,
    random_seed: int,
    cell_bins: int,
) -> None:
    assert 0.0 < retention_fraction <= 1.0
    assert cell_bins >= 2
    configure_t35_plotting()
    candidates = pd.read_csv(candidates_csv)
    graph_manifest = pd.read_csv(graph_manifest_csv)
    hypergraph_features = pd.read_csv(hypergraph_features_csv)
    features, manifest = t11.contrastive_features(candidates, graph_manifest, hypergraph_features)
    weights, _ = t11.contrastive_weights(candidates, features)
    t11_matrices = t11.descriptor_matrices(features, weights)
    matrices = {
        "lexical_farthest": qwen_audit.lexical_matrix(candidates),
        "t11_contrast_top64_farthest": t11_matrices["t11_contrast_top64_farthest"],
        "t11_contrast_weighted_farthest": t11_matrices["t11_contrast_weighted_farthest"],
    }

    selected = t33.selected_candidate_rows(candidates, matrices, retention_fraction, random_seed)
    selected = pd.concat(
        [
            selected,
            t35.pareto_selected_candidate_rows(candidates, matrices, retention_fraction, cell_bins),
            bounded_lane_rows(candidates, matrices, retention_fraction, cell_bins),
        ],
        ignore_index=True,
    )
    replay = t35.replay_rows_from_selected(candidates, selected)
    aggregate = qwen_audit.aggregate_replay(replay)
    front_metrics = t33.ppa_front_metrics(candidates, selected)
    comparison = t35.comparison_table(aggregate, front_metrics)
    front_points = t35.ppa_front_plot_points(candidates, selected, comparison)

    table_dir = package_dir / "tables"
    figure_dir = package_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    t11.feature_manifest(manifest, weights).to_csv(table_dir / "feature_manifest.csv", index=False)
    lane_summary(candidates, matrices, retention_fraction, cell_bins).to_csv(
        table_dir / "lane_summary.csv",
        index=False,
    )
    selected.to_csv(table_dir / "selected_candidates.csv", index=False)
    replay.to_csv(table_dir / "replay_rows.csv", index=False)
    aggregate.to_csv(table_dir / "ppa_comparison.csv", index=False)
    front_metrics.to_csv(table_dir / "ppa_front_metrics.csv", index=False)
    comparison.to_csv(table_dir / "archive_comparison.csv", index=False)
    front_points.to_csv(table_dir / "ppa_front_plot_points.csv", index=False)

    t35.plot_hypervolume(comparison, figure_dir / "t36_hypervolume.png")
    t35.plot_front_hits(comparison, figure_dir / "t36_front_hits.png")
    plot_multi_problem_area_power_front(candidates, selected, figure_dir / "t36_multi_problem_ppa_pareto_fronts.png")
    plot_raw_area_power_front(candidates, selected, figure_dir / "t36_raw_area_power_pareto_front.png")
    export_direct_ppa_viewer(front_points, comparison, package_dir)


def configure_t35_plotting() -> None:
    t35.DISPLAY = DISPLAY
    t35.PLOT_REPS = PLOT_REPS
    t35.COLORS = COLORS


def bounded_lane_rows(
    candidates: pd.DataFrame,
    matrices: dict[str, np.ndarray],
    retention_fraction: float,
    cell_bins: int,
) -> pd.DataFrame:
    cells = {
        name: t35.descriptor_cells(matrix, cell_bins)
        for name, matrix in matrices.items()
        if name.startswith("t11_")
    }
    rows = []
    groups = candidates.groupby(["corpus", "method", "seed", "problem_id"], sort=True)
    for key, group in groups:
        if len(group) < 4:
            continue
        ordered = group.sort_values(["generation", "candidate_id"], kind="mergesort")
        k = max(1, math.ceil(len(ordered) * retention_fraction))
        corpus, method, seed, problem = cast(tuple[str, str, int, str], key)
        for representation, matrix_name, quota in LANES:
            selected_positions = bounded_positions(ordered, matrices[matrix_name], cells[matrix_name], k, quota)
            selected = ordered.loc[ordered["sample_index"].isin(selected_positions.tolist())]
            rows.extend(t35.selected_rows(representation, corpus, method, int(seed), problem, selected))
    return pd.DataFrame(rows)


def bounded_positions(
    ordered: pd.DataFrame,
    matrix: np.ndarray,
    cells: np.ndarray,
    k: int,
    quota: float,
) -> np.ndarray:
    positions = ordered["sample_index"].to_numpy(dtype=int)
    base_order = positions[qwen_audit.farthest_first(matrix[positions], k)]
    front_quota = min(k, max(1, math.ceil(k * quota)))
    selected = list(base_order[: k - front_quota])
    selected_set = set(selected)
    for position in t35.cell_pareto_positions(ordered, cells, len(positions)):
        if int(position) not in selected_set:
            selected.append(int(position))
            selected_set.add(int(position))
        if len(selected) == k:
            return np.asarray(selected, dtype=int)
    for position in base_order:
        if int(position) not in selected_set:
            selected.append(int(position))
            selected_set.add(int(position))
        if len(selected) == k:
            return np.asarray(selected, dtype=int)
    assert len(selected) == k
    return np.asarray(selected, dtype=int)


def lane_summary(
    candidates: pd.DataFrame,
    matrices: dict[str, np.ndarray],
    retention_fraction: float,
    cell_bins: int,
) -> pd.DataFrame:
    rows = []
    groups = candidates.groupby(["corpus", "method", "seed", "problem_id"], sort=True)
    for representation, matrix_name, quota in LANES:
        cells = t35.descriptor_cells(matrices[matrix_name], cell_bins)
        for key, group in groups:
            if len(group) < 4:
                continue
            corpus, method, seed, problem = cast(tuple[str, str, int, str], key)
            positions = group["sample_index"].to_numpy(dtype=int)
            k = max(1, math.ceil(len(group) * retention_fraction))
            rows.append(
                {
                    "representation": representation,
                    "source_descriptor": matrix_name,
                    "front_lane_quota": quota,
                    "front_lane_slots": min(k, max(1, math.ceil(k * quota))),
                    "corpus": corpus,
                    "method": method,
                    "seed": int(seed),
                    "problem_id": problem,
                    "candidate_count": len(group),
                    "occupied_descriptor_cells": len(set(cells[positions])),
                    "cell_bins": cell_bins,
                }
            )
    return pd.DataFrame(rows)


def plot_raw_area_power_front(candidates: pd.DataFrame, selected: pd.DataFrame, path: Path) -> None:
    focus = t33.focus_group(candidates)
    all_valid = t35.t14.focus_candidates(candidates, focus)
    selected_group = t35.t14.focus_candidates(selected, focus)
    reps = [rep for rep in PLOT_REPS if rep in set(selected_group["representation"])]
    fig, axes = plt.subplots(1, 2, figsize=(13.2, 5.6))
    for panel_index, axis in enumerate(axes):
        t35.draw_area_power_panel(axis, all_valid, selected_group, reps, panel_index == 0)
    t33.set_pareto_zoom(axes[1], all_valid)
    axes[0].set_title("Full valid-PPA range")
    axes[1].set_title("Lower-left Pareto zoom")
    title = str(focus["problem_id"]).split("/")[-1]
    fig.suptitle(f"T36 Direct Area-Power Pareto Front: {title}")
    axes[0].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_multi_problem_area_power_front(candidates: pd.DataFrame, selected: pd.DataFrame, path: Path) -> None:
    reps = [rep for rep in PLOT_REPS if rep in set(selected["representation"])]
    groups = t35.t14.front_groups(candidates, limit=4)
    fig, axes = plt.subplots(2, 2, figsize=(13.0, 9.2), squeeze=False)
    handles = []
    names = []
    for axis, focus_row in zip(axes.ravel(), groups, strict=False):
        focus = pd.Series(focus_row)
        all_valid = t35.t14.focus_candidates(candidates, focus)
        selected_group = t35.t14.focus_candidates(selected, focus)
        t35.draw_area_power_panel(axis, all_valid, selected_group, reps, True)
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
    unique = dict(zip(names, handles, strict=True))
    fig.legend(unique.values(), unique.keys(), loc="lower center", ncol=3, fontsize=8)
    fig.suptitle("T36 Raw Area-Power Pareto Fronts Across Representative Problems")
    fig.tight_layout(rect=(0, 0.08, 1, 0.96))
    fig.savefig(path, dpi=180)
    plt.close(fig)


def export_direct_ppa_viewer(front_points: pd.DataFrame, comparison: pd.DataFrame, package_dir: Path) -> None:
    viewer_dir = package_dir / "visualizations" / "direct_ppa_pareto"
    viewer_dir.mkdir(parents=True, exist_ok=True)
    points = front_points.to_json(orient="records")
    metrics = comparison.to_json(orient="records")
    assert isinstance(points, str)
    assert isinstance(metrics, str)
    labels_json = json.dumps({key: t35.label(key) for key in set(front_points["representation"])})
    colors_json = json.dumps({key: t35.color(key) for key in set(front_points["representation"])})
    (viewer_dir / "points.json").write_text(json.dumps(json.loads(points), indent=2) + "\n", encoding="utf-8")
    (viewer_dir / "metrics.json").write_text(json.dumps(json.loads(metrics), indent=2) + "\n", encoding="utf-8")
    (viewer_dir / "manifest.json").write_text(
        json.dumps(
            {
                "schema": "t36_direct_ppa_pareto.v1",
                "points": "points.json",
                "metrics": "metrics.json",
                "source_table": "../../tables/ppa_front_plot_points.csv",
                "axis_definition": "area on x, power on y, lower-left is better",
            },
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    (viewer_dir / "README.md").write_text(
        "# T36 Direct PPA Pareto Viewer\n\n"
        "`index.html` opens from the filesystem and plots raw area versus power\n"
        "from `points.json`, regenerated from `tables/ppa_front_plot_points.csv`.\n",
        encoding="utf-8",
    )
    html = t35.VIEWER_HTML.replace("T35", "T36").replace("t35_", "t36_")
    html = html.replace("__POINTS_JSON__", points)
    html = html.replace("__METRICS_JSON__", metrics)
    html = html.replace("__LABELS_JSON__", labels_json)
    html = html.replace("__COLORS_JSON__", colors_json)
    (viewer_dir / "index.html").write_text(html, encoding="utf-8")


if __name__ == "__main__":
    raise SystemExit(main())
