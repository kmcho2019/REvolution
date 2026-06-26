"""Build candidate-level pooled DeepGate descriptors and replay PPA cells."""

from __future__ import annotations

import argparse
import csv
import json
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


RowValue = str | int | float


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--transition-rows-csv", required=True, type=Path)
    parser.add_argument("--transition-embeddings-npy", required=True, type=Path)
    parser.add_argument("--cone-rows-csv", required=True, type=Path)
    parser.add_argument("--cone-embeddings-npy", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    return parser.parse_args()


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def candidate_key(row: dict[str, str]) -> tuple[str, str, str]:
    return row["backend"], row["problem"], row["candidate"]


def normalized_mean(vectors: list[np.ndarray]) -> np.ndarray:
    assert vectors
    vector = np.mean(np.asarray(vectors), axis=0)
    norm = np.linalg.norm(vector)
    assert norm > 0.0
    return vector / norm


def ppa_for_code(code_path: str) -> dict[str, float]:
    path = Path(code_path).with_name("code_synthesis_report.ppa")
    with path.open(newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert len(rows) == 1
    row = rows[0]
    return {
        "area": float(row["area"]),
        "power": float(row["power"]),
        "tns": float(row["tns"]),
        "wns": float(row["wns"]),
    }


def pca(values: np.ndarray, dims: int) -> np.ndarray:
    centered = values - values.mean(axis=0)
    _, _, vh = np.linalg.svd(centered, full_matrices=False)
    return centered @ vh[:dims].T


def quantile_bins(values: list[float]) -> list[int]:
    cuts = np.quantile(np.asarray(values), [0.25, 0.5, 0.75])
    return [sum(value > cut for cut in cuts) for value in values]


def mark_area_power_pareto(rows: list[dict[str, RowValue]]) -> None:
    for row in rows:
        row["pareto_area_power"] = 0
    for row in rows:
        dominated = False
        for other in rows:
            if row is other:
                continue
            no_worse = float(other["area"]) <= float(row["area"]) and float(other["power"]) <= float(row["power"])
            better = float(other["area"]) < float(row["area"]) or float(other["power"]) < float(row["power"])
            if no_worse and better:
                dominated = True
                break
        row["pareto_area_power"] = 0 if dominated else 1


def write_csv(path: Path, rows: list[dict[str, RowValue]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def nearest_summary(rows: list[dict[str, RowValue]], vectors: np.ndarray) -> dict[str, float]:
    sim = vectors @ vectors.T
    np.fill_diagonal(sim, -2.0)
    nearest = np.argmax(sim, axis=1)
    same_problem = [
        rows[index]["problem"] == rows[int(neighbor)] for index, neighbor in enumerate(nearest)
    ]
    same_backend = [
        rows[index]["backend"] == rows[int(neighbor)] for index, neighbor in enumerate(nearest)
    ]
    return {
        "same_problem_nearest_ratio": float(np.mean(same_problem)),
        "same_backend_nearest_ratio": float(np.mean(same_backend)),
    }


def build_candidate_rows(
    transition_rows: list[dict[str, str]],
    transition_vectors: np.ndarray,
    cone_rows: list[dict[str, str]],
    cone_vectors: np.ndarray,
) -> tuple[list[dict[str, RowValue]], np.ndarray]:
    embedded_rows = [row for row in transition_rows if row["status"] == "embedded"]
    assert len(embedded_rows) == len(transition_vectors)
    cone_by_key: dict[tuple[str, str, str], list[np.ndarray]] = defaultdict(list)
    for row, vector in zip(cone_rows, cone_vectors):
        cone_by_key[candidate_key(row)].append(vector)

    full_vector_by_key = {
        candidate_key(row): vector for row, vector in zip(embedded_rows, transition_vectors)
    }
    rows: list[dict[str, RowValue]] = []
    vectors: list[np.ndarray] = []
    for row in transition_rows:
        key = candidate_key(row)
        if row["status"] == "embedded":
            vector = full_vector_by_key[key]
            source = "full_transition"
            cone_count = 0
        else:
            vector = normalized_mean(cone_by_key[key])
            source = "cone_pool"
            cone_count = len(cone_by_key[key])
        ppa = ppa_for_code(row["code_path"])
        rows.append(
            {
                "backend": row["backend"],
                "benchmark": row["benchmark"],
                "problem": row["problem"],
                "candidate": row["candidate"],
                "source": source,
                "cone_count": cone_count,
                **ppa,
            }
        )
        vectors.append(vector)
    return rows, np.asarray(vectors)


def add_descriptor_cells(rows: list[dict[str, RowValue]], coords: np.ndarray) -> None:
    for index, row in enumerate(rows):
        row["deepgate_pc1"] = float(coords[index, 0])
        row["deepgate_pc2"] = float(coords[index, 1])
        row["deepgate_pc3"] = float(coords[index, 2])
    for problem in sorted({str(row["problem"]) for row in rows}):
        indexes = [index for index, row in enumerate(rows) if row["problem"] == problem]
        for axis in range(3):
            bins = quantile_bins([float(rows[index][f"deepgate_pc{axis + 1}"]) for index in indexes])
            for index, bin_id in zip(indexes, bins):
                rows[index][f"cell_axis_{axis + 1}"] = bin_id
        for index in indexes:
            rows[index]["cell_id"] = (
                f"{rows[index]['cell_axis_1']}:"
                f"{rows[index]['cell_axis_2']}:"
                f"{rows[index]['cell_axis_3']}"
            )


def problem_summary(rows: list[dict[str, RowValue]]) -> list[dict[str, RowValue]]:
    out: list[dict[str, RowValue]] = []
    for problem in sorted({str(row["problem"]) for row in rows}):
        group = [row for row in rows if row["problem"] == problem]
        pareto = [row for row in group if row["pareto_area_power"] == 1]
        out.append(
            {
                "problem": problem,
                "candidates": len(group),
                "full_transition": sum(row["source"] == "full_transition" for row in group),
                "cone_pool": sum(row["source"] == "cone_pool" for row in group),
                "occupied_cells": len({row["cell_id"] for row in group}),
                "pareto_members": len(pareto),
                "pareto_cells": len({row["cell_id"] for row in pareto}),
                "min_area": min(float(row["area"]) for row in group),
                "min_power": min(float(row["power"]) for row in group),
            }
        )
    return out


def plot_replay(rows: list[dict[str, RowValue]], path: Path) -> None:
    problems = sorted({str(row["problem"]) for row in rows})
    colors = plt.get_cmap("tab10")(np.linspace(0, 1, len(problems)))
    color_by_problem = dict(zip(problems, colors))
    fig, axes = plt.subplots(1, 2, figsize=(14, 5.4))
    for problem in problems:
        group = [row for row in rows if row["problem"] == problem]
        axes[0].scatter(
            [float(row["deepgate_pc1"]) for row in group],
            [float(row["deepgate_pc2"]) for row in group],
            s=[70 if row["pareto_area_power"] == 1 else 28 for row in group],
            alpha=0.82,
            color=color_by_problem[problem],
            label=problem,
        )
    axes[0].axhline(0, color="#c8c8c8", linewidth=0.8)
    axes[0].axvline(0, color="#c8c8c8", linewidth=0.8)
    axes[0].set_title("Pooled DeepGate Candidate Descriptors")
    axes[0].set_xlabel("PC1")
    axes[0].set_ylabel("PC2")
    axes[0].legend(fontsize=7, loc="center left", bbox_to_anchor=(1.02, 0.5))

    summary = problem_summary(rows)
    x = np.arange(len(summary))
    axes[1].bar(x - 0.18, [int(row["occupied_cells"]) for row in summary], width=0.36, label="Occupied cells")
    axes[1].bar(x + 0.18, [int(row["pareto_cells"]) for row in summary], width=0.36, label="Pareto cells")
    axes[1].set_xticks(x)
    axes[1].set_xticklabels([str(row["problem"]) for row in summary], rotation=25, ha="right", fontsize=8)
    axes[1].set_title("Descriptor Cells Per Problem")
    axes[1].set_ylabel("Cells")
    axes[1].legend()
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def main() -> None:
    args = parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    for subdir in ["tables", "figures"]:
        (args.package_dir / subdir).mkdir(parents=True, exist_ok=True)

    transition_rows = read_csv(args.transition_rows_csv)
    cone_rows = read_csv(args.cone_rows_csv)
    transition_vectors = np.load(args.transition_embeddings_npy)
    cone_vectors = np.load(args.cone_embeddings_npy)
    rows, vectors = build_candidate_rows(transition_rows, transition_vectors, cone_rows, cone_vectors)
    coords = pca(vectors, 3)
    add_descriptor_cells(rows, coords)
    for problem in sorted({str(row["problem"]) for row in rows}):
        mark_area_power_pareto([row for row in rows if row["problem"] == problem])

    summary_rows = problem_summary(rows)
    nearest = nearest_summary(rows, vectors.copy())
    summary = {
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "candidate_count": len(rows),
        "problem_count": len({row["problem"] for row in rows}),
        "full_transition_candidates": sum(row["source"] == "full_transition" for row in rows),
        "cone_pool_candidates": sum(row["source"] == "cone_pool" for row in rows),
        "mean_occupied_cells": float(np.mean([int(row["occupied_cells"]) for row in summary_rows])),
        "mean_pareto_cells": float(np.mean([int(row["pareto_cells"]) for row in summary_rows])),
        "mean_pareto_members": float(np.mean([int(row["pareto_members"]) for row in summary_rows])),
        **nearest,
    }
    (args.package_dir / "tables" / "deepgate_pooled_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n"
    )
    write_csv(args.package_dir / "tables" / "deepgate_pooled_candidates.csv", rows)
    write_csv(args.package_dir / "tables" / "deepgate_pooled_problem_summary.csv", summary_rows)
    plot_replay(rows, args.package_dir / "figures" / "deepgate_pooled_descriptor_replay.png")


if __name__ == "__main__":
    main()
