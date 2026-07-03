#!/usr/bin/env python3
"""Replay T35 T11 descriptors with Pareto-preserving retention."""

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
QWEN_AUDIT_PATH = REPO_ROOT / "scripts/run_rtl_diversity_wp1_qwen_common_audit.py"
T11_PATH = REPO_ROOT / "scripts/analyze_t11_mgvga_contrastive.py"
T14_PATH = REPO_ROOT / "scripts/analyze_t14_dehnn_hypergraph.py"
T33_PATH = REPO_ROOT / "scripts/analyze_t33_qwen_replay.py"

DISPLAY = {
    "fitness_top": "Fitness top",
    "generation_prefix": "Generation",
    "lexical_farthest": "Lexical",
    "random": "Random",
    "t11_contrast_top64_farthest": "T11 top-64",
    "t11_contrast_weighted_farthest": "T11 weighted",
    "t35_top64_cell_pareto": "T35 cell Pareto top-64",
    "t35_weighted_cell_pareto": "T35 cell Pareto weighted",
    "t35_top64_front_seeded": "T35 front seeded top-64",
}
PLOT_REPS = (
    "lexical_farthest",
    "random",
    "t11_contrast_top64_farthest",
    "t35_top64_cell_pareto",
    "t35_weighted_cell_pareto",
    "t35_top64_front_seeded",
)
COLORS = {
    "all_valid": "#B8B8B8",
    "lexical_farthest": "#4C78A8",
    "random": "#9D9DA1",
    "t11_contrast_top64_farthest": "#54A24B",
    "t11_contrast_weighted_farthest": "#72B7B2",
    "t35_top64_cell_pareto": "#E45756",
    "t35_weighted_cell_pareto": "#F58518",
    "t35_top64_front_seeded": "#B279A2",
}


def import_module(path: Path, name: str) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault(name, module)
    spec.loader.exec_module(module)
    return module


qwen_audit = import_module(QWEN_AUDIT_PATH, "run_rtl_diversity_wp1_qwen_common_audit")
t11 = import_module(T11_PATH, "analyze_t11_mgvga_contrastive")
t14 = import_module(T14_PATH, "analyze_t14_dehnn_hypergraph")
t33 = import_module(T33_PATH, "analyze_t33_qwen_replay")


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
    local = pareto_selected_candidate_rows(candidates, matrices, retention_fraction, cell_bins)
    selected = pd.concat([selected, local], ignore_index=True)
    replay = replay_rows_from_selected(candidates, selected)
    aggregate = qwen_audit.aggregate_replay(replay)
    front_metrics = t33.ppa_front_metrics(candidates, selected)
    comparison = comparison_table(aggregate, front_metrics)
    front_points = ppa_front_plot_points(candidates, selected, comparison)

    table_dir = package_dir / "tables"
    figure_dir = package_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    t11.feature_manifest(manifest, weights).to_csv(table_dir / "feature_manifest.csv", index=False)
    cell_summary(candidates, matrices, cell_bins).to_csv(table_dir / "cell_summary.csv", index=False)
    selected.to_csv(table_dir / "selected_candidates.csv", index=False)
    replay.to_csv(table_dir / "replay_rows.csv", index=False)
    aggregate.to_csv(table_dir / "ppa_comparison.csv", index=False)
    front_metrics.to_csv(table_dir / "ppa_front_metrics.csv", index=False)
    comparison.to_csv(table_dir / "archive_comparison.csv", index=False)
    front_points.to_csv(table_dir / "ppa_front_plot_points.csv", index=False)

    plot_hypervolume(comparison, figure_dir / "t35_hypervolume.png")
    plot_front_hits(comparison, figure_dir / "t35_front_hits.png")
    plot_multi_problem_area_power_front(
        candidates,
        selected,
        figure_dir / "t35_multi_problem_ppa_pareto_fronts.png",
    )
    plot_raw_area_power_front(
        candidates,
        selected,
        figure_dir / "t35_raw_area_power_pareto_front.png",
    )
    export_direct_ppa_viewer(front_points, comparison, package_dir)


def pareto_selected_candidate_rows(
    candidates: pd.DataFrame,
    matrices: dict[str, np.ndarray],
    retention_fraction: float,
    cell_bins: int,
) -> pd.DataFrame:
    cells = {
        name: descriptor_cells(matrix, cell_bins)
        for name, matrix in matrices.items()
        if name.startswith("t11_")
    }
    rows = []
    groups = candidates.groupby(["corpus", "method", "seed", "problem_id"], sort=True)
    for key, group in groups:
        if len(group) < 4:
            continue
        ordered = group.sort_values(["generation", "candidate_id"], kind="mergesort")
        positions = ordered["sample_index"].to_numpy(dtype=int)
        k = max(1, math.ceil(len(positions) * retention_fraction))
        selectors = {
            "t35_top64_cell_pareto": cell_pareto_positions(
                ordered,
                cells["t11_contrast_top64_farthest"],
                k,
            ),
            "t35_weighted_cell_pareto": cell_pareto_positions(
                ordered,
                cells["t11_contrast_weighted_farthest"],
                k,
            ),
            "t35_top64_front_seeded": front_seeded_positions(
                ordered,
                matrices["t11_contrast_top64_farthest"],
                k,
            ),
        }
        corpus, method, seed, problem = cast(tuple[str, str, int, str], key)
        for representation, selected_positions in selectors.items():
            selected = ordered.loc[ordered["sample_index"].isin(selected_positions.tolist())]
            rows.extend(selected_rows(representation, corpus, method, int(seed), problem, selected))
    return pd.DataFrame(rows)


def descriptor_cells(matrix: np.ndarray, bins: int) -> np.ndarray:
    projection = t14.pca2(matrix)
    parts = []
    for axis in range(2):
        values = projection[:, axis]
        quantiles = [index / bins for index in range(1, bins)]
        edges = np.quantile(values, quantiles)
        parts.append(np.searchsorted(edges, values, side="right"))
    return np.asarray([f"{x}:{y}" for x, y in zip(parts[0], parts[1], strict=True)])


def cell_pareto_positions(ordered: pd.DataFrame, cells: np.ndarray, k: int) -> np.ndarray:
    candidates = []
    for cell_id in sorted(set(cells[ordered["sample_index"].to_numpy(dtype=int)])):
        cell_rows = ordered.loc[cells[ordered["sample_index"].to_numpy(dtype=int)] == cell_id]
        candidates.extend(layered_cell_candidates(cell_rows, str(cell_id)))
    ranked = sorted(candidates, key=cell_candidate_key)
    return np.asarray([row["sample_index"] for row in ranked[:k]], dtype=int)


def layered_cell_candidates(rows: pd.DataFrame, cell_id: str) -> list[dict[str, Any]]:
    remaining = rows.copy()
    output = []
    layer = 0
    while not remaining.empty:
        front_indexes = t33.lower_left_front(
            list(zip(remaining["area"].astype(float), remaining["power"].astype(float), strict=True))
        )
        front = remaining.iloc[front_indexes].copy()
        distances = crowding_distances(front)
        for distance, row in zip(distances, front.to_dict("records"), strict=True):
            output.append(
                {
                    "cell_id": cell_id,
                    "front_layer": layer,
                    "crowding_distance": distance,
                    "fitness": float(row["fitness"]),
                    "generation": int(row["generation"]),
                    "candidate_id": str(row["candidate_id"]),
                    "sample_index": int(row["sample_index"]),
                }
            )
        remaining = remaining.drop(index=front.index)
        layer += 1
    return output


def cell_candidate_key(row: dict[str, Any]) -> tuple[int, int, float, float, int, str]:
    return (
        int(row["front_layer"]),
        int(row["cell_id"].split(":", 1)[0]),
        -float(row["crowding_distance"]),
        -float(row["fitness"]),
        int(row["generation"]),
        str(row["candidate_id"]),
    )


def front_seeded_positions(ordered: pd.DataFrame, matrix: np.ndarray, k: int) -> np.ndarray:
    positions = ordered["sample_index"].to_numpy(dtype=int)
    front = t33.lower_left_front(list(zip(ordered["area"].astype(float), ordered["power"].astype(float), strict=True)))
    front_positions = ordered.iloc[front]["sample_index"].to_numpy(dtype=int)
    if len(front_positions) >= k:
        front_rows = ordered.loc[ordered["sample_index"].isin(front_positions)]
        distances = crowding_distances(front_rows)
        ranked = sorted(
            zip(front_positions, distances, strict=True),
            key=lambda item: (-item[1], int(item[0])),
        )
        return np.asarray([position for position, _ in ranked[:k]], dtype=int)
    selected = list(front_positions)
    remaining = np.asarray([position for position in positions if position not in set(selected)], dtype=int)
    if len(remaining) == 0:
        return np.asarray(selected, dtype=int)
    selected.extend(remaining[qwen_audit.farthest_first(matrix[remaining], k - len(selected))].tolist())
    return np.asarray(selected, dtype=int)


def crowding_distances(rows: pd.DataFrame) -> list[float]:
    if rows.empty:
        return []
    points = list(zip(rows["area"].astype(float), rows["power"].astype(float), strict=True))
    distances = [0.0 for _ in points]
    for axis in range(2):
        order = sorted(range(len(points)), key=lambda index: points[index][axis])
        distances[order[0]] = float("inf")
        distances[order[-1]] = float("inf")
        low = points[order[0]][axis]
        high = points[order[-1]][axis]
        if math.isclose(high, low):
            continue
        for offset in range(1, len(order) - 1):
            distances[order[offset]] += (
                points[order[offset + 1]][axis] - points[order[offset - 1]][axis]
            ) / (high - low)
    return distances


def selected_rows(
    representation: str,
    corpus: str,
    method: str,
    seed: int,
    problem: str,
    selected: pd.DataFrame,
) -> list[dict[str, Any]]:
    return [
        {
            "representation": representation,
            "corpus": corpus,
            "method": method,
            "seed": seed,
            "problem_id": problem,
            "sample_index": int(row["sample_index"]),
            "candidate_id": row["candidate_id"],
            "area": float(row["area"]),
            "power": float(row["power"]),
            "eff_clk_period": float(row["eff_clk_period"]),
            "fitness": float(row["fitness"]),
            "canonical_netlist_hash": t11.text_field(row, "canonical_netlist_hash"),
            "motif_signature_hash": t11.text_field(row, "motif_signature_hash"),
        }
        for row in selected.to_dict("records")
    ]


def replay_rows_from_selected(candidates: pd.DataFrame, selected: pd.DataFrame) -> pd.DataFrame:
    rows = []
    groups = candidates.groupby(["corpus", "method", "seed", "problem_id"], sort=True)
    for key, group in groups:
        if len(group) < 4:
            continue
        ordered = group.sort_values(["generation", "candidate_id"], kind="mergesort")
        baseline_points = qwen_audit.improvement_points(ordered)
        corpus, method, seed, problem = cast(tuple[str, str, int, str], key)
        selected_group = selected.loc[
            selected["corpus"].eq(corpus)
            & selected["method"].eq(method)
            & selected["seed"].eq(seed)
            & selected["problem_id"].eq(problem)
        ]
        for representation, rep_rows in selected_group.groupby("representation", sort=True):
            selected_positions = set(rep_rows["sample_index"].astype(int))
            selected_source = ordered.loc[ordered["sample_index"].isin(list(selected_positions))]
            selected_points = qwen_audit.improvement_points(selected_source)
            rows.append(
                {
                    "corpus": corpus,
                    "method": method,
                    "seed": int(seed),
                    "problem_id": problem,
                    "representation": representation,
                    "valid_ppa_count": int(len(ordered)),
                    "selected_count": int(len(selected_source)),
                    "baseline_hypervolume": qwen_audit.hypervolume(baseline_points),
                    "selected_hypervolume": qwen_audit.hypervolume(selected_points),
                    "baseline_pareto_size": len(qwen_audit.pareto_front(baseline_points)),
                    "selected_pareto_size": len(qwen_audit.pareto_front(selected_points)),
                    "baseline_best_fitness": qwen_audit.numeric_max(ordered, "fitness"),
                    "selected_best_fitness": qwen_audit.numeric_max(selected_source, "fitness"),
                    "unique_canonical_netlists": qwen_audit.unique_nonempty(
                        selected_source,
                        "canonical_netlist_hash",
                    ),
                    "unique_motif_signatures": qwen_audit.unique_nonempty(
                        selected_source,
                        "motif_signature_hash",
                    ),
                }
            )
    return pd.DataFrame(rows)


def comparison_table(aggregate: pd.DataFrame, front_metrics: pd.DataFrame) -> pd.DataFrame:
    merged = aggregate.merge(
        front_metrics[["representation", "area_power_front_points", "selected_all_valid_front_hits", "unique_ppa_points"]],
        on="representation",
        validate="one_to_one",
    )
    lexical = merged.loc[merged["representation"].eq("lexical_farthest")].iloc[0]
    merged["front_hit_delta_vs_lexical"] = (
        merged["selected_all_valid_front_hits"] - int(lexical["selected_all_valid_front_hits"])
    )
    merged["unique_ppa_delta_vs_lexical"] = merged["unique_ppa_points"] - int(lexical["unique_ppa_points"])
    return merged


def ppa_front_plot_points(
    candidates: pd.DataFrame,
    selected: pd.DataFrame,
    comparison: pd.DataFrame,
) -> pd.DataFrame:
    rows = []
    for focus_row in t14.front_groups(candidates, limit=4):
        focus = pd.Series(focus_row)
        all_valid = t14.focus_candidates(candidates, focus)
        all_front = t33.all_valid_area_power_front(all_valid)
        for row in all_valid.to_dict("records"):
            rows.append(t14.plot_point_row(row, "all_valid", "all_valid", all_front))
        selected_group = t14.focus_candidates(selected, focus)
        for representation in plot_representations(comparison):
            rows.extend(
                t14.plot_point_row(row, representation, "selected", all_front)
                for row in selected_group.loc[selected_group["representation"].eq(representation)].to_dict("records")
            )
    return pd.DataFrame(rows)


def plot_representations(comparison: pd.DataFrame) -> list[str]:
    available = set(comparison["representation"])
    return [representation for representation in PLOT_REPS if representation in available]


def cell_summary(candidates: pd.DataFrame, matrices: dict[str, np.ndarray], cell_bins: int) -> pd.DataFrame:
    rows = []
    groups = candidates.groupby(["corpus", "method", "seed", "problem_id"], sort=True)
    for representation, matrix in matrices.items():
        if not representation.startswith("t11_"):
            continue
        cells = descriptor_cells(matrix, cell_bins)
        for key, group in groups:
            corpus, method, seed, problem = cast(tuple[str, str, int, str], key)
            positions = group["sample_index"].to_numpy(dtype=int)
            rows.append(
                {
                    "representation": representation,
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


def plot_hypervolume(comparison: pd.DataFrame, path: Path) -> None:
    frame = comparison.copy()
    frame["label"] = frame["representation"].map(label)
    frame = frame.sort_values("selected_hypervolume", ascending=False)
    fig, axis = plt.subplots(figsize=(9.4, 5.2))
    axis.barh(frame["label"], frame["selected_hypervolume"], color=[color(row) for row in frame["representation"]])
    lexical = frame.loc[frame["representation"].eq("lexical_farthest")].iloc[0]
    axis.axvline(float(lexical["selected_hypervolume"]), color="#333333", linestyle="--", linewidth=1.0)
    axis.set_xlabel("Selected Hypervolume")
    axis.grid(True, axis="x", alpha=0.24)
    axis.invert_yaxis()
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_front_hits(comparison: pd.DataFrame, path: Path) -> None:
    frame = comparison.copy()
    frame["label"] = frame["representation"].map(label)
    frame = frame.sort_values("selected_all_valid_front_hits", ascending=False)
    fig, axis = plt.subplots(figsize=(9.4, 5.2))
    axis.barh(
        frame["label"],
        frame["selected_all_valid_front_hits"],
        color=[color(row) for row in frame["representation"]],
    )
    lexical = frame.loc[frame["representation"].eq("lexical_farthest")].iloc[0]
    axis.axvline(int(lexical["selected_all_valid_front_hits"]), color="#333333", linestyle="--", linewidth=1.0)
    axis.set_xlabel("Selected All-Valid Front Hits")
    axis.grid(True, axis="x", alpha=0.24)
    axis.invert_yaxis()
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_raw_area_power_front(
    candidates: pd.DataFrame,
    selected: pd.DataFrame,
    path: Path,
) -> None:
    focus = t33.focus_group(candidates)
    all_valid = t14.focus_candidates(candidates, focus)
    selected_group = t14.focus_candidates(selected, focus)
    reps = [rep for rep in PLOT_REPS if rep in set(selected_group["representation"])]
    fig, axes = plt.subplots(1, 2, figsize=(13.2, 5.6))
    for panel_index, axis in enumerate(axes):
        draw_area_power_panel(axis, all_valid, selected_group, reps, panel_index == 0)
    t33.set_pareto_zoom(axes[1], all_valid)
    axes[0].set_title("Full valid-PPA range")
    axes[1].set_title("Lower-left Pareto zoom")
    title = str(focus["problem_id"]).split("/")[-1]
    fig.suptitle(f"T35 Direct Area-Power Pareto Front: {title}")
    axes[0].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_multi_problem_area_power_front(
    candidates: pd.DataFrame,
    selected: pd.DataFrame,
    path: Path,
) -> None:
    reps = [rep for rep in PLOT_REPS if rep in set(selected["representation"])]
    groups = t14.front_groups(candidates, limit=4)
    fig, axes = plt.subplots(2, 2, figsize=(13.0, 9.2), squeeze=False)
    handles = []
    names = []
    for axis, focus_row in zip(axes.ravel(), groups, strict=False):
        focus = pd.Series(focus_row)
        all_valid = t14.focus_candidates(candidates, focus)
        selected_group = t14.focus_candidates(selected, focus)
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
    unique = dict(zip(names, handles, strict=True))
    fig.legend(unique.values(), unique.keys(), loc="lower center", ncol=3, fontsize=8)
    fig.suptitle("T35 Raw Area-Power Pareto Fronts Across Representative Problems")
    fig.tight_layout(rect=(0, 0.08, 1, 0.96))
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
        color=COLORS["all_valid"],
        s=24,
        alpha=0.3,
        label="all valid" if with_labels else "_nolegend_",
    )
    t33.draw_front(axis, all_valid, "#111111", "all-valid front" if with_labels else "_nolegend_")
    for representation in reps:
        rows = selected_group.loc[selected_group["representation"].eq(representation)]
        if rows.empty:
            continue
        axis.scatter(
            rows["area"],
            rows["power"],
            s=42,
            label=label(representation) if with_labels else "_nolegend_",
            color=color(representation),
            edgecolor="#222222",
            linewidth=0.35,
        )
        t33.draw_front(axis, rows, color(representation), "_nolegend_")
    axis.set_xlabel("Area (lower is better)")
    axis.set_ylabel("Power (lower is better)")
    axis.grid(True, alpha=0.2)


def export_direct_ppa_viewer(front_points: pd.DataFrame, comparison: pd.DataFrame, package_dir: Path) -> None:
    viewer_dir = package_dir / "visualizations" / "direct_ppa_pareto"
    viewer_dir.mkdir(parents=True, exist_ok=True)
    points = front_points.to_json(orient="records")
    metrics = comparison.to_json(orient="records")
    assert isinstance(points, str)
    assert isinstance(metrics, str)
    labels_json = json.dumps({key: label(key) for key in set(front_points["representation"])})
    colors_json = json.dumps({key: color(key) for key in set(front_points["representation"])})
    (viewer_dir / "points.json").write_text(json.dumps(json.loads(points), indent=2) + "\n", encoding="utf-8")
    (viewer_dir / "metrics.json").write_text(json.dumps(json.loads(metrics), indent=2) + "\n", encoding="utf-8")
    (viewer_dir / "manifest.json").write_text(
        json.dumps(
            {
                "schema": "t35_direct_ppa_pareto.v1",
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
        "# T35 Direct PPA Pareto Viewer\n\n"
        "`index.html` opens from the filesystem and plots raw area versus power\n"
        "from `points.json`, regenerated from `tables/ppa_front_plot_points.csv`.\n",
        encoding="utf-8",
    )
    html = VIEWER_HTML
    html = html.replace("__POINTS_JSON__", points)
    html = html.replace("__METRICS_JSON__", metrics)
    html = html.replace("__LABELS_JSON__", labels_json)
    html = html.replace("__COLORS_JSON__", colors_json)
    (viewer_dir / "index.html").write_text(html, encoding="utf-8")


def label(representation: str) -> str:
    return DISPLAY.get(representation, representation.replace("_", " "))


def color(representation: str) -> str:
    return COLORS.get(representation, "#6F4E7C")


VIEWER_HTML = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>T35 Direct PPA Pareto Front</title>
  <style>
    body { margin: 0; color: #172026; font-family: Inter, system-ui, sans-serif; }
    main { max-width: 1180px; margin: 0 auto; padding: 24px; }
    header { display: flex; justify-content: space-between; gap: 16px; align-items: flex-start; }
    h1 { margin: 0 0 6px; font-size: 24px; letter-spacing: 0; }
    p { margin: 0; color: #5b6770; line-height: 1.45; }
    .controls, .metric, .plot-shell { border: 1px solid #d5dce2; border-radius: 8px; background: #f7f9fb; }
    .controls { padding: 12px; display: flex; gap: 10px; align-items: center; }
    label { color: #5b6770; font-size: 13px; font-weight: 650; }
    select { min-width: 280px; padding: 7px 9px; border: 1px solid #d5dce2; border-radius: 6px; font: inherit; }
    .summary { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 10px; margin: 14px 0 16px; }
    .metric { padding: 10px 12px; }
    .metric b { display: block; font-size: 18px; margin-bottom: 2px; }
    .metric span { color: #5b6770; font-size: 12px; }
    .plot-shell { overflow: hidden; background: white; }
    svg { display: block; width: 100%; height: min(68vh, 680px); min-height: 460px; }
    .axis { stroke: #7d8790; stroke-width: 1; }
    .grid { stroke: #e6eaee; stroke-width: 1; }
    .tick { fill: #5b6770; font-size: 12px; }
    .axis-label { fill: #172026; font-size: 13px; font-weight: 700; }
    .front-line { fill: none; stroke-width: 2.3; stroke-linejoin: round; stroke-linecap: round; }
    .legend { display: flex; gap: 12px; flex-wrap: wrap; padding: 12px 16px; border-top: 1px solid #d5dce2; color: #5b6770; font-size: 13px; }
    .legend span { display: inline-flex; align-items: center; gap: 6px; }
    .swatch { width: 11px; height: 11px; border-radius: 50%; display: inline-block; }
    @media (max-width: 760px) { main { padding: 14px; } header { display: block; } .summary { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
  </style>
</head>
<body>
<main>
  <header>
    <div>
      <h1>T35 Direct Raw PPA Pareto Front</h1>
      <p>Raw area-power projection from committed replay points. Lower area and lower power are better.</p>
    </div>
    <div class="controls"><label for="problem">Problem</label><select id="problem"></select></div>
  </header>
  <section class="summary" id="summary"></section>
  <section class="plot-shell">
    <svg id="plot" viewBox="0 0 1100 660" role="img" aria-label="Raw area-power Pareto front"></svg>
    <div class="legend" id="legend"></div>
  </section>
</main>
<script>
const POINTS = __POINTS_JSON__;
const METRICS = __METRICS_JSON__;
const LABELS = __LABELS_JSON__;
const COLORS = __COLORS_JSON__;
const REPS = Object.keys(LABELS).filter((name) => name !== 'all_valid');
const plot = document.getElementById('plot');
const select = document.getElementById('problem');
const summary = document.getElementById('summary');
const legend = document.getElementById('legend');
const problems = [...new Set(POINTS.map((row) => row.problem_id))];
for (const problem of problems) {
  const option = document.createElement('option');
  option.value = problem;
  option.textContent = shortProblem(problem);
  select.appendChild(option);
}
select.addEventListener('change', draw);
drawSummary();
drawLegend();
draw();

function shortProblem(problem) { return String(problem).split('/').at(-1); }
function metric(name) { return METRICS.find((row) => row.representation === name); }
function bestT35() {
  return METRICS.filter((row) => String(row.representation).startsWith('t35_'))
    .sort((a, b) => b.selected_hypervolume - a.selected_hypervolume)[0];
}
function drawSummary() {
  const best = bestT35();
  const lexical = metric('lexical_farthest');
  const delta = 100 * (best.selected_hypervolume / lexical.selected_hypervolume - 1);
  const cells = [
    ['Best T35 HV', best.selected_hypervolume.toFixed(6)],
    ['HV gain vs lexical', `${delta >= 0 ? '+' : ''}${delta.toFixed(2)}%`],
    ['Best T35 front hits', String(best.selected_all_valid_front_hits)],
    ['Lexical front hits', String(lexical.selected_all_valid_front_hits)],
  ];
  summary.innerHTML = cells.map(([name, value]) => `<div class="metric"><b>${value}</b><span>${name}</span></div>`).join('');
}
function drawLegend() {
  const rows = ['all_valid', ...REPS].map((name) => `<span><i class="swatch" style="background:${COLORS[name] || '#b5bdc6'}"></i>${LABELS[name] || name}</span>`);
  rows.push('<span>hollow circles and lines mark area-power nondominated front points</span>');
  legend.innerHTML = rows.join('');
}
function draw() {
  plot.replaceChildren();
  const rows = POINTS.filter((row) => row.problem_id === select.value);
  const bounds = paddedBounds(rows);
  drawGrid(bounds);
  drawRepresentation(rows, bounds, 'all_valid');
  for (const representation of REPS) drawRepresentation(rows, bounds, representation);
  drawAxisLabels();
}
function paddedBounds(rows) {
  const areas = rows.map((row) => Number(row.area));
  const powers = rows.map((row) => Number(row.power));
  const minArea = Math.min(...areas);
  const maxArea = Math.max(...areas);
  const minPower = Math.min(...powers);
  const maxPower = Math.max(...powers);
  return {
    minArea: minArea - Math.max((maxArea - minArea) * 0.08, 1),
    maxArea: maxArea + Math.max((maxArea - minArea) * 0.08, 1),
    minPower: Math.max(0, minPower - Math.max((maxPower - minPower) * 0.08, 0.001)),
    maxPower: maxPower + Math.max((maxPower - minPower) * 0.08, 0.001),
  };
}
function drawGrid(bounds) {
  for (let index = 0; index <= 5; index += 1) {
    const t = index / 5;
    const x = 82 + t * 950;
    const y = 574 - t * 498;
    line(x, 76, x, 574, 'grid');
    line(82, y, 1032, y, 'grid');
    text(x, 604, valueAt(bounds.minArea, bounds.maxArea, t), 'tick', 'middle');
    text(60, y + 4, valueAt(bounds.minPower, bounds.maxPower, t), 'tick', 'end');
  }
  line(82, 574, 1032, 574, 'axis');
  line(82, 76, 82, 574, 'axis');
  text(130, 548, 'lower-left is better', 'tick', 'start');
}
function valueAt(minValue, maxValue, t) {
  const value = minValue + (maxValue - minValue) * t;
  return Math.abs(value) >= 100 ? value.toFixed(0) : value.toFixed(3);
}
function drawRepresentation(rows, bounds, representation) {
  const repRows = rows.filter((row) => row.representation === representation);
  if (repRows.length === 0) return;
  const color = COLORS[representation] || '#6F4E7C';
  for (const row of repRows) point(row, bounds, color, representation === 'all_valid' ? 4 : 7);
  const front = nondominated(repRows).sort((a, b) => a.area - b.area);
  polyline(front, bounds, color);
  for (const row of front) frontPoint(row, bounds, color);
}
function nondominated(rows) {
  return rows.filter((row) => !rows.some((other) => {
    const dominates = Number(other.area) <= Number(row.area) && Number(other.power) <= Number(row.power);
    const strict = Number(other.area) < Number(row.area) || Number(other.power) < Number(row.power);
    return dominates && strict;
  }));
}
function project(row, bounds) {
  const x = 82 + ((Number(row.area) - bounds.minArea) / (bounds.maxArea - bounds.minArea)) * 950;
  const y = 574 - ((Number(row.power) - bounds.minPower) / (bounds.maxPower - bounds.minPower)) * 498;
  return [x, y];
}
function point(row, bounds, color, radius) {
  const [x, y] = project(row, bounds);
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
  node.setAttribute('cx', x);
  node.setAttribute('cy', y);
  node.setAttribute('r', radius);
  node.setAttribute('fill', color);
  node.setAttribute('opacity', row.representation === 'all_valid' ? 0.38 : 0.78);
  node.appendChild(title(row));
  plot.appendChild(node);
}
function frontPoint(row, bounds, color) {
  const [x, y] = project(row, bounds);
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
  node.setAttribute('cx', x);
  node.setAttribute('cy', y);
  node.setAttribute('r', 10);
  node.setAttribute('fill', 'none');
  node.setAttribute('stroke', color);
  node.setAttribute('stroke-width', 2.4);
  node.appendChild(title(row));
  plot.appendChild(node);
}
function polyline(rows, bounds, color) {
  if (rows.length < 2) return;
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'polyline');
  node.setAttribute('points', rows.map((row) => project(row, bounds).join(',')).join(' '));
  node.setAttribute('stroke', color);
  node.setAttribute('class', 'front-line');
  plot.appendChild(node);
}
function title(row) {
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'title');
  node.textContent = `${LABELS[row.representation] || row.representation} area=${row.area} power=${row.power}`;
  return node;
}
function line(x1, y1, x2, y2, cls) {
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'line');
  node.setAttribute('x1', x1);
  node.setAttribute('y1', y1);
  node.setAttribute('x2', x2);
  node.setAttribute('y2', y2);
  node.setAttribute('class', cls);
  plot.appendChild(node);
}
function text(x, y, value, cls, anchor) {
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'text');
  node.setAttribute('x', x);
  node.setAttribute('y', y);
  node.setAttribute('class', cls);
  node.setAttribute('text-anchor', anchor);
  node.textContent = value;
  plot.appendChild(node);
}
function drawAxisLabels() {
  text(557, 640, 'Area', 'axis-label', 'middle');
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'text');
  node.setAttribute('x', -325);
  node.setAttribute('y', 20);
  node.setAttribute('class', 'axis-label');
  node.setAttribute('text-anchor', 'middle');
  node.setAttribute('transform', 'rotate(-90)');
  node.textContent = 'Power';
  plot.appendChild(node);
}
</script>
</body>
</html>
"""


if __name__ == "__main__":
    raise SystemExit(main())
