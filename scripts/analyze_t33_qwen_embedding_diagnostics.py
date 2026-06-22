#!/usr/bin/env python3
"""Analyze T33 Qwen embedding collapse and view stability."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path

import numpy as np

T06_SAME_PROBLEM_FRACTION = 0.93359375
T06_SAME_CORPUS_FRACTION = 0.9479166666666666


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--embedding-manifest", required=True, type=Path)
    parser.add_argument("--view-manifest", required=True, type=Path)
    parser.add_argument("--candidates-csv", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    analyze(
        embedding_manifest=args.embedding_manifest,
        view_manifest=args.view_manifest,
        candidates_csv=args.candidates_csv,
        package_dir=args.package_dir,
    )
    return 0


def analyze(
    embedding_manifest: Path,
    view_manifest: Path,
    candidates_csv: Path,
    package_dir: Path,
) -> None:
    embeddings = load_embeddings(embedding_manifest)
    view_rows = rows_by_view(read_rows(view_manifest))
    candidates = {row["sample_index"]: row for row in read_rows(candidates_csv)}
    table_dir = package_dir / "tables"
    table_dir.mkdir(parents=True, exist_ok=True)

    nearest_rows = []
    summary_rows = []
    for view, matrix in embeddings.items():
        rows = view_rows[view]
        assert len(rows) == matrix.shape[0]
        nearest = nearest_neighbors(matrix)
        nearest_rows.extend(nearest_detail_rows(view, rows, candidates, nearest))
        summary_rows.append(summary_row(view, rows, candidates, nearest))

    write_csv(table_dir / "t33_nearest_neighbors.csv", nearest_rows)
    write_csv(table_dir / "t33_collapse_diagnostics.csv", summary_rows)
    write_csv(table_dir / "t33_view_stability.csv", stability_rows(embeddings))


def load_embeddings(path: Path) -> dict[str, np.ndarray]:
    rows = read_rows(path)
    embeddings = {}
    for row in rows:
        matrix = np.load(row["embedding_path"])
        assert matrix.ndim == 2
        embeddings[row["view"]] = matrix.astype(np.float32)
    return embeddings


def nearest_neighbors(matrix: np.ndarray) -> list[dict[str, object]]:
    similarity = matrix @ matrix.T
    np.fill_diagonal(similarity, -np.inf)
    indices = np.argmax(similarity, axis=1)
    return [
        {"nearest_index": int(index), "nearest_cosine": float(similarity[row_index, index])}
        for row_index, index in enumerate(indices)
    ]


def nearest_detail_rows(
    view: str,
    view_rows: list[dict[str, str]],
    candidates: dict[str, dict[str, str]],
    nearest: list[dict[str, object]],
) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for row_index, item in enumerate(nearest):
        source = candidates[view_rows[row_index]["sample_index"]]
        nearest_index = int_value(item["nearest_index"])
        target = candidates[view_rows[nearest_index]["sample_index"]]
        rows.append(
            {
                "view": view,
                "sample_index": source["sample_index"],
                "candidate_id": source["candidate_id"],
                "nearest_sample_index": target["sample_index"],
                "nearest_candidate_id": target["candidate_id"],
                "nearest_cosine": f"{float_value(item['nearest_cosine']):.9f}",
                "same_problem": same_nonempty(source, target, "problem_id"),
                "same_corpus": same_nonempty(source, target, "corpus"),
                "same_normalized_rtl": same_nonempty(source, target, "normalized_rtl_sha256"),
                "same_canonical_netlist": same_nonempty(source, target, "canonical_netlist_hash"),
                "same_motif_signature": same_nonempty(source, target, "motif_signature_hash"),
                "same_style_cluster": same_nonempty(source, target, "style_cluster"),
            }
        )
    return rows


def summary_row(
    view: str,
    view_rows: list[dict[str, str]],
    candidates: dict[str, dict[str, str]],
    nearest: list[dict[str, object]],
) -> dict[str, object]:
    detail = nearest_detail_rows(view, view_rows, candidates, nearest)
    same_problem = mean_bool(detail, "same_problem")
    same_corpus = mean_bool(detail, "same_corpus")
    return {
        "view": view,
        "candidate_count": len(detail),
        "nearest_cosine_mean": f"{mean_float(detail, 'nearest_cosine'):.9f}",
        "same_problem_fraction": f"{same_problem:.9f}",
        "same_problem_delta_vs_t06": f"{same_problem - T06_SAME_PROBLEM_FRACTION:.9f}",
        "same_corpus_fraction": f"{same_corpus:.9f}",
        "same_corpus_delta_vs_t06": f"{same_corpus - T06_SAME_CORPUS_FRACTION:.9f}",
        "same_normalized_rtl_fraction": f"{mean_bool(detail, 'same_normalized_rtl'):.9f}",
        "same_canonical_netlist_fraction": f"{mean_bool(detail, 'same_canonical_netlist'):.9f}",
        "same_motif_signature_fraction": f"{mean_bool(detail, 'same_motif_signature'):.9f}",
        "same_style_cluster_fraction": f"{mean_bool(detail, 'same_style_cluster'):.9f}",
    }


def stability_rows(embeddings: dict[str, np.ndarray]) -> list[dict[str, object]]:
    rows = []
    views = sorted(embeddings)
    for left_index, left in enumerate(views):
        for right in views[left_index + 1 :]:
            cosine = np.sum(embeddings[left] * embeddings[right], axis=1)
            rows.append(
                {
                    "left_view": left,
                    "right_view": right,
                    "candidate_count": embeddings[left].shape[0],
                    "cosine_mean": f"{float(np.mean(cosine)):.9f}",
                    "cosine_min": f"{float(np.min(cosine)):.9f}",
                    "cosine_max": f"{float(np.max(cosine)):.9f}",
                }
            )
    return rows


def rows_by_view(rows: list[dict[str, str]]) -> dict[str, list[dict[str, str]]]:
    by_view: dict[str, list[dict[str, str]]] = {}
    for row in rows:
        by_view.setdefault(row["view"], []).append(row)
    return by_view


def same_nonempty(left: dict[str, str], right: dict[str, str], key: str) -> bool:
    return bool(left[key] and right[key] and left[key] == right[key])


def mean_bool(rows: list[dict[str, object]], key: str) -> float:
    assert rows
    return sum(row[key] is True for row in rows) / len(rows)


def mean_float(rows: list[dict[str, object]], key: str) -> float:
    assert rows
    return sum(float(str(row[key])) for row in rows) / len(rows)


def int_value(value: object) -> int:
    assert isinstance(value, int)
    return value


def float_value(value: object) -> float:
    assert isinstance(value, float)
    return value


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def write_csv(path: Path, rows: list[dict[str, object]]) -> None:
    assert rows
    fieldnames = list(rows[0])
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    raise SystemExit(main())
