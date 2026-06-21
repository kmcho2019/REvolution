#!/usr/bin/env python3
"""Package a passive local-Pareto archive audit for useful-BD T17."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

from revolution.qd.pareto_analysis import (
    compute_candidate_improvements,
    hypervolume,
    objective_metrics_for_reference,
    pareto_front,
)

REFERENCE_METHOD = "classic_revolution"
MANUAL_METHOD = "landing_smooth_qd_manual_bd"
DEFAULT_CAPACITY = 4
PPA_GRID_BINS = 4
PPA_GRID_MIN = 0.0
PPA_GRID_MAX = 1.0

METHOD_LABELS = {
    "classic_revolution": "Classic",
    "landing_smooth_qd_manual_bd": "Manual BD",
    "random_descriptor_qd": "Random BD",
    "simple_yosys_stat_bd": "Yosys stat",
    "netlist_motif_occupancy": "Motif",
    "synthesis_trajectory_nod": "ST-NOD",
    "synthesis_trajectory_motif_nod": "ST-NOD+motif",
    "sr_raw_pca_qd": "SR raw PCA",
    "sr_random_relu_pca_qd": "SR ReLU PCA",
    "sr_rff_pca_qd": "SR-RFF PCA",
    "sr_vq_codebook_qd": "SR VQ",
}


def build_audit(
    central_report: dict[str, Any],
    *,
    repo_root: Path,
    capacity: int,
) -> dict[str, list[dict[str, Any]]]:
    """Build passive scalar-vs-local-Pareto audit tables."""

    assert capacity > 0
    roots = {
        method: Path(path)
        for method, path in central_report["artifact_roots"].items()
    }
    problem_rows: list[dict[str, Any]] = []
    retained_rows: list[dict[str, Any]] = []
    manifest_rows: list[dict[str, Any]] = []
    for method, result_dir in sorted(
        roots.items(),
        key=lambda item: method_sort_key(item[0]),
    ):
        candidates_path = result_dir / "candidates.parquet"
        candidates = pd.read_parquet(candidates_path)
        manifest_rows.append(source_manifest_row(method, result_dir, candidates_path))
        for problem_id, group in candidates.groupby("problem_id", sort=True):
            rows = archiveable_rows(method, str(problem_id), group, repo_root)
            problem_rows.extend(
                problem_mode_rows(method, str(problem_id), rows, capacity)
            )
            retained_rows.extend(retained_candidate_rows(method, str(problem_id), rows, capacity))
    aggregate_rows = aggregate_rows_from_problem_rows(problem_rows, retained_rows)
    return {
        "source_manifest": manifest_rows,
        "problem_metrics": problem_rows,
        "retained_candidates": retained_rows,
        "aggregate": aggregate_rows,
        "deltas": delta_rows(aggregate_rows),
    }


def archiveable_rows(
    method: str,
    problem_id: str,
    candidates: pd.DataFrame,
    repo_root: Path,
) -> list[dict[str, Any]]:
    benchmark, problem = problem_id.split("/", 1)
    ref_metrics = load_reference_ppa(repo_root, benchmark, problem)
    objective_metrics = objective_metrics_for_reference(ref_metrics)
    rows = []
    valid = candidates.loc[candidates["valid_ppa"].eq(True)].copy()
    for record in valid.to_dict("records"):
        ppa = {
            "area": record["area"],
            "power": record["power"],
            "eff_clk_period": record["timing_or_clock_period"],
        }
        improvements = compute_candidate_improvements(ppa, ref_metrics, objective_metrics)
        fitness = finite_float_or_none(record["fitness"])
        if improvements is None or fitness is None:
            continue
        point = tuple(improvements[metric] for metric in objective_metrics)
        rows.append(
            {
                "method_name": method,
                "problem_id": problem_id,
                "candidate_id": str(record["candidate_id"]),
                "generation": int(record["generation"]),
                "operator_name": str(record["operator_name"]),
                "cell_id": str(record["common_audit_cell_id"] or "missing"),
                "point": point,
                "objective_metrics": objective_metrics,
                "fitness": fitness,
                "area": finite_float(record["area"]),
                "power": finite_float(record["power"]),
                "timing_or_clock_period": finite_float(record["timing_or_clock_period"]),
                "canonical_netlist_hash": str(record["canonical_netlist_hash"]),
                "motif_signature_hash": str(record["motif_signature_hash"]),
            }
        )
    return rows


def problem_mode_rows(
    method: str,
    problem_id: str,
    rows: list[dict[str, Any]],
    capacity: int,
) -> list[dict[str, Any]]:
    scalar = scalar_archive(rows)
    local = local_pareto_archive(rows, capacity)
    return [
        problem_metric_row(method, problem_id, "scalar_cell_elite", rows, scalar),
        problem_metric_row(method, problem_id, "bounded_local_pareto", rows, local),
    ]


def retained_candidate_rows(
    method: str,
    problem_id: str,
    rows: list[dict[str, Any]],
    capacity: int,
) -> list[dict[str, Any]]:
    retained = {
        "scalar_cell_elite": scalar_archive(rows),
        "bounded_local_pareto": local_pareto_archive(rows, capacity),
    }
    output = []
    for mode, mode_rows in retained.items():
        for row in mode_rows:
            output.append(
                {
                    "method_name": method,
                    "problem_id": problem_id,
                    "retention_mode": mode,
                    "candidate_id": row["candidate_id"],
                    "generation": row["generation"],
                    "operator_name": row["operator_name"],
                    "cell_id": row["cell_id"],
                    "fitness": row["fitness"],
                    "area": row["area"],
                    "power": row["power"],
                    "timing_or_clock_period": row["timing_or_clock_period"],
                    "improvement_point": json.dumps(list(row["point"])),
                    "objective_metrics": json.dumps(list(row["objective_metrics"])),
                    "canonical_netlist_hash": row["canonical_netlist_hash"],
                    "motif_signature_hash": row["motif_signature_hash"],
                }
            )
    return output


def scalar_archive(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    best: dict[str, dict[str, Any]] = {}
    for row in rows:
        current = best.get(row["cell_id"])
        if current is None or scalar_key(row) > scalar_key(current):
            best[row["cell_id"]] = row
    return [best[cell_id] for cell_id in sorted(best)]


def local_pareto_archive(rows: list[dict[str, Any]], capacity: int) -> list[dict[str, Any]]:
    retained: list[dict[str, Any]] = []
    by_cell: dict[str, list[dict[str, Any]]] = {}
    for row in rows:
        by_cell.setdefault(row["cell_id"], []).append(row)
    for cell_id in sorted(by_cell):
        retained.extend(bounded_front(by_cell[cell_id], capacity))
    return retained


def bounded_front(rows: list[dict[str, Any]], capacity: int) -> list[dict[str, Any]]:
    if len(rows) <= capacity:
        return sorted(rows, key=member_sort_key)
    points = [row["point"] for row in rows]
    front = [rows[index] for index in pareto_front(points)]
    if len(front) <= capacity:
        return sorted(front, key=member_sort_key)
    distances = crowding_distances([row["point"] for row in front])
    ranked = sorted(
        zip(front, distances, strict=True),
        key=lambda item: (
            math.isinf(item[1]),
            item[1],
            item[0]["fitness"],
            -item[0]["generation"],
            item[0]["candidate_id"],
        ),
        reverse=True,
    )
    return sorted([row for row, _ in ranked[:capacity]], key=member_sort_key)


def crowding_distances(points: list[tuple[float, ...]]) -> list[float]:
    if not points:
        return []
    distances = [0.0 for _ in points]
    for axis in range(len(points[0])):
        order = sorted(range(len(points)), key=lambda index: points[index][axis])
        distances[order[0]] = float("inf")
        distances[order[-1]] = float("inf")
        low = points[order[0]][axis]
        high = points[order[-1]][axis]
        if math.isclose(high, low):
            continue
        for offset in range(1, len(order) - 1):
            prev_value = points[order[offset - 1]][axis]
            next_value = points[order[offset + 1]][axis]
            distances[order[offset]] += (next_value - prev_value) / (high - low)
    return distances


def problem_metric_row(
    method: str,
    problem_id: str,
    mode: str,
    source_rows: list[dict[str, Any]],
    retained: list[dict[str, Any]],
) -> dict[str, Any]:
    points = [row["point"] for row in retained]
    front_indexes = pareto_front(points) if points else []
    front = [retained[index] for index in front_indexes]
    front_hashes = unique_values(front, "canonical_netlist_hash")
    front_sizes = cell_sizes(retained)
    ppa_cells = {ppa_grid_cell(row["point"]) for row in retained}
    objective_count = len(retained[0]["point"]) if retained else 2
    return {
        "method_name": method,
        "problem_id": problem_id,
        "retention_mode": mode,
        "source_valid_ppa": len(source_rows),
        "retained_candidate_count": len(retained),
        "retained_fraction": safe_div(len(retained), len(source_rows)),
        "occupied_cells": len(front_sizes),
        "mean_front_size": mean(front_sizes.values()),
        "max_front_size": max(front_sizes.values(), default=0),
        "hypervolume": hypervolume([row["point"] for row in front]),
        "global_pareto_point_count": len(front),
        "best_fitness": max((row["fitness"] for row in retained), default=0.0),
        "ppa_grid_occupied_cells": len(ppa_cells),
        "ppa_grid_total_cells": PPA_GRID_BINS ** objective_count,
        "ppa_grid_coverage": safe_div(len(ppa_cells), PPA_GRID_BINS ** objective_count),
        "unique_canonical_netlist_count": len(unique_values(retained, "canonical_netlist_hash")),
        "duplicate_netlist_count": (
            len(retained) - len(unique_values(retained, "canonical_netlist_hash"))
        ),
        "unique_motif_signature_count": len(unique_values(retained, "motif_signature_hash")),
        "ppa_front_unique_netlist_count": len(front_hashes),
    }


def aggregate_rows_from_problem_rows(
    problem_rows: list[dict[str, Any]],
    retained_rows: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    retained_by_key: dict[tuple[str, str], list[dict[str, Any]]] = {}
    for row in retained_rows:
        key = (row["method_name"], row["retention_mode"])
        retained_by_key.setdefault(key, []).append(row)
    output = []
    frame = pd.DataFrame(problem_rows)
    groupby = frame.groupby(["method_name", "retention_mode"], sort=False)
    for key, group in groupby:
        method, mode = assert_group_key(key)
        retained = retained_by_key[(method, mode)]
        output.append(
            {
                "method_name": method,
                "retention_mode": mode,
                "problem_count": int(group["problem_id"].nunique()),
                "source_valid_ppa": int(group["source_valid_ppa"].sum()),
                "retained_candidate_count": int(group["retained_candidate_count"].sum()),
                "retained_fraction": safe_div(
                    int(group["retained_candidate_count"].sum()),
                    int(group["source_valid_ppa"].sum()),
                ),
                "occupied_cells": int(group["occupied_cells"].sum()),
                "mean_front_size": float(group["mean_front_size"].mean()),
                "max_front_size": int(group["max_front_size"].max()),
                "mean_hypervolume": float(group["hypervolume"].mean()),
                "mean_best_fitness": float(group["best_fitness"].mean()),
                "global_pareto_point_count": int(group["global_pareto_point_count"].sum()),
                "ppa_grid_occupied_cells": int(group["ppa_grid_occupied_cells"].sum()),
                "mean_ppa_grid_coverage": float(group["ppa_grid_coverage"].mean()),
                "unique_canonical_netlist_count": len(
                    unique_values(retained, "canonical_netlist_hash")
                ),
                "duplicate_netlist_count": int(group["duplicate_netlist_count"].sum()),
                "unique_motif_signature_count": len(
                    unique_values(retained, "motif_signature_hash")
                ),
                "ppa_front_unique_netlist_count": int(
                    group["ppa_front_unique_netlist_count"].sum()
                ),
            }
        )
    return output


def delta_rows(aggregate_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    by_method: dict[str, dict[str, dict[str, Any]]] = {}
    for row in aggregate_rows:
        by_method.setdefault(str(row["method_name"]), {})[str(row["retention_mode"])] = row
    metrics = (
        "mean_hypervolume",
        "mean_best_fitness",
        "retained_candidate_count",
        "global_pareto_point_count",
        "ppa_grid_occupied_cells",
        "ppa_front_unique_netlist_count",
        "unique_canonical_netlist_count",
        "unique_motif_signature_count",
    )
    rows = []
    for method, modes in sorted(by_method.items(), key=lambda item: method_sort_key(item[0])):
        scalar = modes["scalar_cell_elite"]
        local = modes["bounded_local_pareto"]
        for metric in metrics:
            scalar_value = float(scalar[metric])
            local_value = float(local[metric])
            rows.append(
                {
                    "method_name": method,
                    "metric": metric,
                    "scalar_cell_elite": scalar_value,
                    "bounded_local_pareto": local_value,
                    "delta": local_value - scalar_value,
                    "relative_delta": safe_relative_delta(local_value, scalar_value),
                }
            )
    return rows


def write_package(
    tables: dict[str, list[dict[str, Any]]],
    technique_dir: Path,
) -> None:
    table_dir = technique_dir / "tables"
    figure_dir = technique_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    for name, rows in tables.items():
        write_csv(table_dir / f"{name}.csv", rows)
    write_figures(tables, figure_dir)


def write_figures(tables: dict[str, list[dict[str, Any]]], figure_dir: Path) -> None:
    aggregate = tables["aggregate"]
    deltas = tables["deltas"]
    problems = tables["problem_metrics"]
    plot_mode_bars(
        aggregate,
        "mean_hypervolume",
        "Mean Hypervolume",
        figure_dir / "mome_retention_hypervolume.png",
    )
    plot_mode_bars(
        aggregate,
        "global_pareto_point_count",
        "Global Pareto Points",
        figure_dir / "mome_global_pareto_points.png",
    )
    plot_delta_bars(
        deltas,
        ["mean_hypervolume", "ppa_front_unique_netlist_count", "ppa_grid_occupied_cells"],
        figure_dir / "mome_vs_scalar_deltas.png",
    )
    plot_problem_heatmap(
        problems,
        "retained_candidate_count",
        figure_dir / "mome_retained_candidates_heatmap.png",
    )


def plot_mode_bars(
    rows: list[dict[str, Any]],
    metric: str,
    ylabel: str,
    output_path: Path,
) -> None:
    frame = pd.DataFrame(rows)
    methods = sorted(frame["method_name"].unique(), key=method_sort_key)
    x = list(range(len(methods)))
    width = 0.38
    fig, axis = plt.subplots(figsize=(10.4, 4.8))
    for offset, mode in [(-width / 2, "scalar_cell_elite"), (width / 2, "bounded_local_pareto")]:
        values = [
            float(frame.loc[
                frame["method_name"].eq(method) & frame["retention_mode"].eq(mode),
                metric,
            ].iloc[0])
            for method in methods
        ]
        axis.bar(
            [value + offset for value in x],
            values,
            width,
            label=mode.replace("_", " "),
        )
    axis.set_ylabel(ylabel)
    axis.set_xticks(x)
    axis.set_xticklabels([display_method(method) for method in methods], rotation=35, ha="right")
    axis.grid(axis="y", color="#d9d9d9", linewidth=0.8)
    axis.legend(frameon=False)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_delta_bars(
    rows: list[dict[str, Any]],
    metrics: list[str],
    output_path: Path,
) -> None:
    frame = pd.DataFrame([row for row in rows if row["metric"] in metrics])
    methods = sorted(frame["method_name"].unique(), key=method_sort_key)
    fig, axes = plt.subplots(len(metrics), 1, figsize=(9.6, 7.6), sharex=True)
    for axis, metric in zip(axes, metrics, strict=True):
        values = [
            float(frame.loc[
                frame["method_name"].eq(method) & frame["metric"].eq(metric),
                "relative_delta",
            ].iloc[0])
            for method in methods
        ]
        colors = ["#2d7f5e" if value >= 0.0 else "#b64d4d" for value in values]
        axis.bar(range(len(methods)), values, color=colors)
        axis.axhline(0.0, color="#404040", linewidth=0.8)
        axis.set_ylabel(metric.replace("_", "\n"))
        axis.grid(axis="y", color="#e5e5e5", linewidth=0.7)
    axes[-1].set_xticks(range(len(methods)))
    axes[-1].set_xticklabels(
        [display_method(method) for method in methods],
        rotation=35,
        ha="right",
    )
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def plot_problem_heatmap(
    rows: list[dict[str, Any]],
    metric: str,
    output_path: Path,
) -> None:
    frame = pd.DataFrame(rows)
    local = frame.loc[frame["retention_mode"].eq("bounded_local_pareto")].copy()
    methods = sorted(local["method_name"].unique(), key=method_sort_key)
    problems = sorted(local["problem_id"].unique())
    matrix = [
        [
            float(local.loc[
                local["method_name"].eq(method) & local["problem_id"].eq(problem),
                metric,
            ].iloc[0])
            for problem in problems
        ]
        for method in methods
    ]
    fig, axis = plt.subplots(figsize=(10.0, 5.2))
    image = axis.imshow(matrix, cmap="YlGnBu", aspect="auto")
    axis.set_xticks(range(len(problems)))
    axis.set_xticklabels(
        [problem.split("/", 1)[1] for problem in problems],
        rotation=35,
        ha="right",
    )
    axis.set_yticks(range(len(methods)))
    axis.set_yticklabels([display_method(method) for method in methods])
    axis.set_title("Bounded Local-Pareto Retained Candidates")
    fig.colorbar(image, ax=axis, shrink=0.82)
    fig.tight_layout()
    fig.savefig(output_path, dpi=180)
    plt.close(fig)


def load_reference_ppa(repo_root: Path, benchmark: str, problem: str) -> dict[str, float]:
    path = repo_root / "data" / "bench" / benchmark / f"{problem}_ppa.txt"
    lines = path.read_text(encoding="utf-8").splitlines()
    assert len(lines) >= 2, path
    values = lines[1].split(",")
    assert len(values) >= 5, path
    return {
        "tns": float(values[0]),
        "wns": float(values[1]),
        "eff_clk_period": float(values[2]),
        "power": float(values[3]),
        "area": float(values[4]),
    }


def ppa_grid_cell(point: tuple[float, ...]) -> str:
    width = (PPA_GRID_MAX - PPA_GRID_MIN) / PPA_GRID_BINS
    parts = []
    for value in point:
        clipped = min(max(float(value), PPA_GRID_MIN), PPA_GRID_MAX)
        bin_index = min(int((clipped - PPA_GRID_MIN) / width), PPA_GRID_BINS - 1)
        parts.append(str(bin_index))
    return "ppa_grid:" + ",".join(parts)


def source_manifest_row(method: str, result_dir: Path, candidates_path: Path) -> dict[str, Any]:
    summary_path = result_dir / "method_summary.json"
    run_manifest_path = result_dir / "run_manifest.json"
    return {
        "method_name": method,
        "result_dir": result_dir.as_posix(),
        "candidates_parquet_sha256": sha256_file(candidates_path),
        "method_summary_sha256": sha256_file(summary_path),
        "run_manifest_sha256": sha256_file(run_manifest_path),
    }


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows, path
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def method_sort_key(method: str) -> tuple[int, str]:
    order = list(METHOD_LABELS)
    return (order.index(method) if method in order else len(order), method)


def member_sort_key(row: dict[str, Any]) -> tuple[str, int, str]:
    return (row["cell_id"], int(row["generation"]), row["candidate_id"])


def scalar_key(row: dict[str, Any]) -> tuple[float, int, str]:
    return (float(row["fitness"]), -int(row["generation"]), row["candidate_id"])


def cell_sizes(rows: list[dict[str, Any]]) -> dict[str, int]:
    sizes: dict[str, int] = {}
    for row in rows:
        sizes[row["cell_id"]] = sizes.get(row["cell_id"], 0) + 1
    return sizes


def unique_values(rows: list[dict[str, Any]], column: str) -> set[str]:
    return {str(row[column]) for row in rows if str(row[column])}


def finite_float(value: object) -> float:
    assert isinstance(value, str | int | float)
    parsed = float(value)
    assert math.isfinite(parsed)
    return parsed


def finite_float_or_none(value: object) -> float | None:
    assert isinstance(value, str | int | float)
    parsed = float(value)
    if not math.isfinite(parsed):
        return None
    return parsed


def mean(values: Any) -> float:
    items = list(values)
    return float(sum(items) / len(items)) if items else 0.0


def assert_group_key(key: object) -> tuple[str, str]:
    assert isinstance(key, tuple)
    assert len(key) == 2
    first, second = key
    assert isinstance(first, str)
    assert isinstance(second, str)
    return first, second


def safe_div(numerator: float, denominator: float) -> float:
    return float(numerator / denominator) if denominator else 0.0


def safe_relative_delta(value: float, reference: float) -> float | None:
    if math.isclose(reference, 0.0):
        return None
    return (value - reference) / abs(reference)


def display_method(method: str) -> str:
    return METHOD_LABELS.get(method, method)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--central-json", type=Path, required=True)
    parser.add_argument("--technique-dir", type=Path, required=True)
    parser.add_argument("--repo-root", type=Path, default=Path.cwd())
    parser.add_argument("--capacity", type=int, default=DEFAULT_CAPACITY)
    args = parser.parse_args(argv)

    central_report = json.loads(args.central_json.read_text(encoding="utf-8"))
    tables = build_audit(
        central_report,
        repo_root=args.repo_root,
        capacity=args.capacity,
    )
    write_package(tables, args.technique_dir)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
