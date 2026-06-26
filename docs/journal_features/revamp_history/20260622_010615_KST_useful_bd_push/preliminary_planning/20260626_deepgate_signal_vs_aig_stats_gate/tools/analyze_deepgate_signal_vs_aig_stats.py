"""Compare DeepGate transition embeddings with simple AIG statistics."""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


STAT_KEYS = (
    "aig_variables",
    "aig_inputs",
    "aig_outputs",
    "aig_ands",
    "embedded_nodes",
    "embedded_edges",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows-csv", required=True, type=Path)
    parser.add_argument("--embeddings-npy", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    return parser.parse_args()


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        rows = [row for row in csv.DictReader(handle) if row["status"] == "embedded"]
    assert rows
    return rows


def normalize_rows(values: np.ndarray) -> np.ndarray:
    norms = np.linalg.norm(values, axis=1)
    assert np.all(norms > 0.0)
    return values / norms[:, None]


def stats_matrix(rows: list[dict[str, str]]) -> np.ndarray:
    raw = np.asarray(
        [[np.log1p(float(row[key])) for key in STAT_KEYS] for row in rows],
        dtype=np.float64,
    )
    stdev = raw.std(axis=0)
    assert np.all(stdev > 0.0)
    return normalize_rows((raw - raw.mean(axis=0)) / stdev)


def residualize(target: np.ndarray, controls: np.ndarray) -> np.ndarray:
    design = np.column_stack([np.ones(len(controls)), controls])
    coef, *_ = np.linalg.lstsq(design, target, rcond=None)
    return normalize_rows(target - design @ coef)


def pair_mask(size: int) -> np.ndarray:
    return ~np.eye(size, dtype=bool)


def nearest_indices(sim: np.ndarray) -> np.ndarray:
    work = sim.copy()
    np.fill_diagonal(work, -2.0)
    return np.argmax(work, axis=1)


def metrics(name: str, rows: list[dict[str, str]], vectors: np.ndarray) -> dict[str, object]:
    sim = vectors @ vectors.T
    nearest = nearest_indices(sim)
    same_problem = [rows[i]["problem"] == rows[j]["problem"] for i, j in enumerate(nearest)]
    same_backend = [rows[i]["backend"] == rows[j]["backend"] for i, j in enumerate(nearest)]
    problem_pair = np.asarray(
        [
            rows[i]["problem"] == rows[j]["problem"]
            for i in range(len(rows))
            for j in range(len(rows))
        ],
        dtype=bool,
    ).reshape(len(rows), len(rows))
    mask = pair_mask(len(rows))
    return {
        "name": name,
        "pairwise_cosine_mean": float(sim[mask].mean()),
        "pairwise_cosine_min": float(sim[mask].min()),
        "pairwise_cosine_max": float(sim[mask].max()),
        "same_problem_nearest_ratio": float(np.mean(same_problem)),
        "same_backend_nearest_ratio": float(np.mean(same_backend)),
        "same_problem_pair_cosine_mean": float(sim[mask & problem_pair].mean()),
        "different_problem_pair_cosine_mean": float(sim[mask & ~problem_pair].mean()),
    }


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_neighbor_rows(
    path: Path,
    rows: list[dict[str, str]],
    vector_by_name: dict[str, np.ndarray],
) -> None:
    nearest_by_name = {
        name: nearest_indices(vectors @ vectors.T)
        for name, vectors in vector_by_name.items()
    }
    out_rows: list[dict[str, object]] = []
    for index, row in enumerate(rows):
        out_row: dict[str, object] = {
            "row_index": index,
            "problem": row["problem"],
            "backend": row["backend"],
            "candidate": row["candidate"],
        }
        for name, nearest in nearest_by_name.items():
            neighbor = rows[int(nearest[index])]
            out_row[f"{name}_neighbor_problem"] = neighbor["problem"]
            out_row[f"{name}_neighbor_backend"] = neighbor["backend"]
        out_rows.append(out_row)
    write_csv(path, out_rows)


def write_problem_rows(path: Path, rows: list[dict[str, str]]) -> None:
    problems = sorted({row["problem"] for row in rows})
    out_rows: list[dict[str, object]] = []
    for problem in problems:
        group = [row for row in rows if row["problem"] == problem]
        out_rows.append(
            {
                "problem": problem,
                "embedded_rows": len(group),
                "backends": len({row["backend"] for row in group}),
                "mean_aig_variables": float(np.mean([float(row["aig_variables"]) for row in group])),
                "mean_aig_ands": float(np.mean([float(row["aig_ands"]) for row in group])),
            }
        )
    write_csv(path, out_rows)


def metric_float(row: dict[str, object], key: str) -> float:
    value = row[key]
    assert isinstance(value, float)
    return value


def pca_xy(vectors: np.ndarray) -> np.ndarray:
    centered = vectors - vectors.mean(axis=0)
    _, _, vh = np.linalg.svd(centered, full_matrices=False)
    return centered @ vh[:2].T


def plot_summary(
    rows: list[dict[str, str]],
    metric_rows: list[dict[str, object]],
    vectors_by_name: dict[str, np.ndarray],
    path: Path,
) -> None:
    problems = sorted({row["problem"] for row in rows})
    colors = plt.get_cmap("tab10")(np.linspace(0, 1, len(problems)))
    color_by_problem = dict(zip(problems, colors))

    fig, axes = plt.subplots(2, 2, figsize=(13, 9))
    names = [str(row["name"]) for row in metric_rows]
    ratios = [metric_float(row, "same_problem_nearest_ratio") for row in metric_rows]
    axes[0, 0].bar(names, ratios, color=["#4c78a8", "#f58518", "#54a24b"])
    axes[0, 0].set_ylim(0, 1)
    axes[0, 0].set_title("Nearest Neighbor By Same Problem")
    axes[0, 0].set_ylabel("Ratio")
    axes[0, 0].tick_params(axis="x", rotation=15)

    gaps = [
        metric_float(row, "same_problem_pair_cosine_mean")
        - metric_float(row, "different_problem_pair_cosine_mean")
        for row in metric_rows
    ]
    axes[0, 1].bar(names, gaps, color=["#4c78a8", "#f58518", "#54a24b"])
    axes[0, 1].axhline(0, color="#777777", linewidth=0.8)
    axes[0, 1].set_title("Same-Problem Cosine Gap")
    axes[0, 1].tick_params(axis="x", rotation=15)

    for axis, name in zip(axes[1], ["deepgate", "deepgate_residual"]):
        xy = pca_xy(vectors_by_name[name])
        for problem in problems:
            indexes = [index for index, row in enumerate(rows) if row["problem"] == problem]
            axis.scatter(
                xy[indexes, 0],
                xy[indexes, 1],
                s=36,
                alpha=0.85,
                label=problem,
                color=color_by_problem[problem],
            )
        axis.axhline(0, color="#c8c8c8", linewidth=0.8)
        axis.axvline(0, color="#c8c8c8", linewidth=0.8)
        axis.set_title(f"{name.replace('_', ' ').title()} PCA")
        axis.set_xlabel("PC1")
        axis.set_ylabel("PC2")
    axes[1, 1].legend(loc="center left", bbox_to_anchor=(1.02, 0.5), fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def main() -> None:
    args = parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    for subdir in ["tables", "figures"]:
        (args.package_dir / subdir).mkdir(parents=True, exist_ok=True)

    rows = read_rows(args.rows_csv)
    deepgate = normalize_rows(np.load(args.embeddings_npy).astype(np.float64))
    assert len(rows) == len(deepgate)
    aig_stats = stats_matrix(rows)
    residual = residualize(deepgate, aig_stats)

    vectors_by_name = {
        "deepgate": deepgate,
        "aig_stats": aig_stats,
        "deepgate_residual": residual,
    }
    metric_rows = [metrics(name, rows, vectors) for name, vectors in vectors_by_name.items()]
    summary = {
        "rows_csv": str(args.rows_csv),
        "embeddings_npy": str(args.embeddings_npy),
        "embedded_rows": len(rows),
        "embedded_problems": len({row["problem"] for row in rows}),
        "embedded_backends": len({row["backend"] for row in rows}),
        "metrics": metric_rows,
    }

    summary_path = args.package_dir / "tables" / "deepgate_signal_summary.json"
    metrics_path = args.package_dir / "tables" / "deepgate_signal_metrics.csv"
    neighbors_path = args.package_dir / "tables" / "deepgate_nearest_neighbors.csv"
    problems_path = args.package_dir / "tables" / "deepgate_problem_summary.csv"
    figure_path = args.package_dir / "figures" / "deepgate_signal_vs_aig_stats.png"

    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    write_csv(metrics_path, metric_rows)
    write_neighbor_rows(neighbors_path, rows, vectors_by_name)
    write_problem_rows(problems_path, rows)
    plot_summary(rows, metric_rows, vectors_by_name, figure_path)


if __name__ == "__main__":
    main()
