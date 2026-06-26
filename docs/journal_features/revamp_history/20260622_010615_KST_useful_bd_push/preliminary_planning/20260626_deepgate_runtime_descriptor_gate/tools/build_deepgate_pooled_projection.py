"""Freeze the T91 pooled DeepGate candidate vectors as runtime PCA axes."""

from __future__ import annotations

import argparse
import csv
import json
from collections import defaultdict
from pathlib import Path

import numpy as np


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--transition-rows-csv", required=True, type=Path)
    parser.add_argument("--transition-embeddings-npy", required=True, type=Path)
    parser.add_argument("--cone-rows-csv", required=True, type=Path)
    parser.add_argument("--cone-embeddings-npy", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    return parser.parse_args()


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def key(row: dict[str, str]) -> tuple[str, str, str]:
    return row["backend"], row["problem"], row["candidate"]


def normalized_mean(vectors: list[np.ndarray]) -> np.ndarray:
    assert vectors
    vector = np.mean(np.asarray(vectors), axis=0)
    norm = np.linalg.norm(vector)
    assert norm > 0.0
    return vector / norm


def candidate_vectors(
    transition_rows: list[dict[str, str]],
    transition_vectors: np.ndarray,
    cone_rows: list[dict[str, str]],
    cone_vectors: np.ndarray,
) -> tuple[list[dict[str, str]], np.ndarray]:
    embedded_rows = [row for row in transition_rows if row["status"] == "embedded"]
    assert len(embedded_rows) == len(transition_vectors)
    full_by_key = {
        key(row): vector for row, vector in zip(embedded_rows, transition_vectors)
    }
    cones_by_key: dict[tuple[str, str, str], list[np.ndarray]] = defaultdict(list)
    for row, vector in zip(cone_rows, cone_vectors):
        cones_by_key[key(row)].append(vector)

    rows = []
    vectors = []
    for row in transition_rows:
        row_key = key(row)
        rows.append(row)
        if row["status"] == "embedded":
            vectors.append(full_by_key[row_key])
        else:
            vectors.append(normalized_mean(cones_by_key[row_key]))
    return rows, np.asarray(vectors, dtype=np.float64)


def main() -> None:
    args = parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    transition_rows = read_csv(args.transition_rows_csv)
    cone_rows = read_csv(args.cone_rows_csv)
    _, vectors = candidate_vectors(
        transition_rows,
        np.load(args.transition_embeddings_npy),
        cone_rows,
        np.load(args.cone_embeddings_npy),
    )
    mean = vectors.mean(axis=0)
    centered = vectors - mean
    _, _, vh = np.linalg.svd(centered, full_matrices=False)
    axes = ["deepgate_pool_pc0", "deepgate_pool_pc1", "deepgate_pool_pc2"]
    artifact = {
        "artifact_kind": "deepgate_pooled_projection_v0",
        "source": "T91 pooled full-transition plus bounded-cone DeepGate embeddings",
        "candidate_count": int(vectors.shape[0]),
        "embedding_dim": int(vectors.shape[1]),
        "axes": axes,
        "mean": [float(value) for value in mean],
        "components": [
            [float(value) for value in component]
            for component in vh[: len(axes)]
        ],
    }
    (args.output_dir / "deepgate_pooled_projection.json").write_text(
        json.dumps(artifact, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    (args.output_dir / "deepgate_descriptor_profiles.yaml").write_text(
        "deepgate_projection_artifact: deepgate_pooled_projection.json\n"
        "profiles:\n"
        "  deepgate_pooled_pc3:\n"
        "    - deepgate_pool_pc0\n"
        "    - deepgate_pool_pc1\n"
        "    - deepgate_pool_pc2\n"
        "grid_axes:\n"
        "  deepgate_pool_pc0:\n"
        "    bins: 4\n"
        "    lower_bound: -1.0\n"
        "    upper_bound: 1.0\n"
        "  deepgate_pool_pc1:\n"
        "    bins: 4\n"
        "    lower_bound: -1.0\n"
        "    upper_bound: 1.0\n"
        "  deepgate_pool_pc2:\n"
        "    bins: 4\n"
        "    lower_bound: -1.0\n"
        "    upper_bound: 1.0\n",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
