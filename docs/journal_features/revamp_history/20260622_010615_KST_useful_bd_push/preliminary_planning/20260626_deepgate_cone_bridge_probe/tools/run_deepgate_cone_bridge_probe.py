"""Embed bounded output cones from large transition AIGs with DeepGate."""

from __future__ import annotations

import argparse
import csv
import json
import time
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Union

import deepgate
import matplotlib.pyplot as plt
import numpy as np
import torch


RowValue = Union[str, int, float]


@dataclass(frozen=True)
class ConeCandidate:
    output_index: int
    output_literal: int
    cone_vars: set[int]
    input_vars: set[int]
    and_lines: list[tuple[int, int, int]]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows-csv", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--max-cone-ands", required=True, type=int)
    parser.add_argument("--max-cones-per-row", required=True, type=int)
    return parser.parse_args()


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def parse_aag(path: Path) -> tuple[list[int], list[int], list[tuple[int, int, int]]]:
    lines = path.read_text().splitlines()
    header = lines[0].split()
    assert header[0] == "aag"
    _, inputs, latches, outputs, ands = map(int, header[1:6])
    assert latches == 0
    input_literals = [int(lines[1 + index].split()[0]) for index in range(inputs)]
    output_start = 1 + inputs
    output_literals = [int(lines[output_start + index].split()[0]) for index in range(outputs)]
    and_start = output_start + outputs
    and_lines: list[tuple[int, int, int]] = []
    for index in range(ands):
        items = tuple(map(int, lines[and_start + index].split()))
        assert len(items) == 3
        and_lines.append(items)
    return input_literals, output_literals, and_lines


def collect_cone_vars(literal: int, gates: dict[int, tuple[int, int]], seen: set[int]) -> None:
    if literal < 2:
        return
    var = literal // 2
    if var not in gates or var in seen:
        return
    seen.add(var)
    left, right = gates[var]
    collect_cone_vars(left, gates, seen)
    collect_cone_vars(right, gates, seen)


def write_cone_aag(
    path: Path,
    output_literal: int,
    cone_vars: set[int],
    input_vars: set[int],
    and_lines: list[tuple[int, int, int]],
) -> dict[str, int]:
    cone_lines = [line for line in and_lines if line[0] // 2 in cone_vars]
    literals = [output_literal, *(item for line in cone_lines for item in line[1:])]
    constant_var = len(input_vars) + 1 if any(literal < 2 for literal in literals) else None
    var_map = {var: index + 1 for index, var in enumerate(sorted(input_vars))}
    next_var = len(var_map) + 1
    if constant_var is not None:
        next_var += 1
    for line in cone_lines:
        var_map[line[0] // 2] = next_var
        next_var += 1

    def remap_literal(literal: int) -> int:
        if literal < 2:
            assert constant_var is not None
            return constant_var * 2 + literal
        return var_map[literal // 2] * 2 + literal % 2

    new_inputs = [str((index + 1) * 2) for index in range(len(input_vars))]
    if constant_var is not None:
        new_inputs.append(str(constant_var * 2))
    new_ands = [
        f"{remap_literal(line[0])} {remap_literal(line[1])} {remap_literal(line[2])}"
        for line in cone_lines
    ]
    path.write_text(
        "\n".join(
            [
                f"aag {next_var - 1} {len(new_inputs)} 0 1 {len(new_ands)}",
                *new_inputs,
                str(remap_literal(output_literal)),
                *new_ands,
            ]
        )
        + "\n"
    )
    return {
        "cone_variables": next_var - 1,
        "cone_inputs": len(new_inputs),
        "cone_ands": len(new_ands),
    }


def candidate_cones(row: dict[str, str], max_cone_ands: int) -> list[ConeCandidate]:
    _, output_literals, and_lines = parse_aag(Path(row["aig_path"]))
    gates = {line[0] // 2: (line[1], line[2]) for line in and_lines}
    cones: list[ConeCandidate] = []
    for output_index, output_literal in enumerate(output_literals):
        cone_vars: set[int] = set()
        collect_cone_vars(output_literal, gates, cone_vars)
        if not cone_vars or len(cone_vars) > max_cone_ands:
            continue
        cone_lines = [line for line in and_lines if line[0] // 2 in cone_vars]
        boundary_literals = [output_literal, *(item for line in cone_lines for item in line[1:])]
        input_vars = {
            literal // 2
            for literal in boundary_literals
            if literal >= 2 and literal // 2 not in cone_vars
        }
        cones.append(
            ConeCandidate(
                output_index=output_index,
                output_literal=output_literal,
                cone_vars=cone_vars,
                input_vars=input_vars,
                and_lines=and_lines,
            )
        )
    return sorted(cones, key=lambda cone: (len(cone.cone_vars), cone.output_index))


def embed_cone(model: deepgate.Model, parser: deepgate.AigParser, path: Path) -> tuple[np.ndarray, int, int, float]:
    start = time.monotonic()
    graph = parser.read_aiger(str(path))
    assert graph.edge_index is not None
    with torch.no_grad():
        hs, hf = model(graph)
    vector = torch.cat([hs.mean(dim=0), hf.mean(dim=0)]).detach().cpu().numpy()
    norm = np.linalg.norm(vector)
    assert norm > 0.0
    seconds = time.monotonic() - start
    return vector / norm, int(len(graph.gate)), int(graph.edge_index.shape[1]), seconds


def write_csv(path: Path, rows: list[dict[str, RowValue]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def cosine_summary(rows: list[dict[str, RowValue]], embeddings: np.ndarray) -> dict[str, object]:
    sim = embeddings @ embeddings.T
    mask = ~np.eye(len(rows), dtype=bool)
    nearest = sim.copy()
    np.fill_diagonal(nearest, -2.0)
    nearest_index = np.argmax(nearest, axis=1)
    same_problem = [
        rows[index]["problem"] == rows[int(neighbor)] for index, neighbor in enumerate(nearest_index)
    ]
    return {
        "pairwise_cosine_mean": float(sim[mask].mean()),
        "pairwise_cosine_min": float(sim[mask].min()),
        "pairwise_cosine_max": float(sim[mask].max()),
        "same_problem_nearest_ratio": float(np.mean(same_problem)),
    }


def pca_xy(embeddings: np.ndarray) -> np.ndarray:
    centered = embeddings - embeddings.mean(axis=0)
    _, _, vh = np.linalg.svd(centered, full_matrices=False)
    return centered @ vh[:2].T


def plot_cones(rows: list[dict[str, RowValue]], embeddings: np.ndarray, path: Path) -> None:
    problems = sorted({str(row["problem"]) for row in rows})
    counts = Counter(str(row["problem"]) for row in rows)
    xy = pca_xy(embeddings)
    colors = plt.get_cmap("tab10")(np.linspace(0, 1, len(problems)))
    color_by_problem = dict(zip(problems, colors))
    fig, axes = plt.subplots(1, 2, figsize=(13, 5))
    for problem in problems:
        indexes = [index for index, row in enumerate(rows) if row["problem"] == problem]
        axes[0].scatter(
            xy[indexes, 0],
            xy[indexes, 1],
            s=38,
            alpha=0.85,
            color=color_by_problem[problem],
            label=problem,
        )
    axes[0].axhline(0, color="#c8c8c8", linewidth=0.8)
    axes[0].axvline(0, color="#c8c8c8", linewidth=0.8)
    axes[0].set_title("DeepGate Cone Embedding PCA")
    axes[0].set_xlabel("PC1")
    axes[0].set_ylabel("PC2")
    axes[0].legend(fontsize=8)
    axes[1].bar(problems, [counts[problem] for problem in problems], color="#4c78a8")
    axes[1].set_title("Embedded Cone Count")
    axes[1].set_ylabel("Cones")
    axes[1].tick_params(axis="x", rotation=20)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def main() -> None:
    args = parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "cones").mkdir(exist_ok=True)
    for subdir in ["tables", "figures"]:
        (args.package_dir / subdir).mkdir(parents=True, exist_ok=True)

    rows = read_rows(args.rows_csv)
    skipped_rows = [row for row in rows if row["status"] == "skipped_too_large"]
    assert skipped_rows
    torch.set_num_threads(1)
    model = deepgate.Model()
    model.load_pretrained()
    model.eval()
    parser = deepgate.AigParser()

    out_rows: list[dict[str, RowValue]] = []
    vectors: list[np.ndarray] = []
    for row_index, row in enumerate(skipped_rows):
        cones = candidate_cones(row, args.max_cone_ands)[: args.max_cones_per_row]
        for cone_index, cone in enumerate(cones):
            cone_path = args.output_dir / "cones" / f"row_{row_index:03d}_cone_{cone_index:02d}.aag"
            cone_header = write_cone_aag(
                cone_path,
                cone.output_literal,
                cone.cone_vars,
                cone.input_vars,
                cone.and_lines,
            )
            vector, nodes, edges, seconds = embed_cone(model, parser, cone_path)
            vectors.append(vector)
            out_rows.append(
                {
                    "problem": row["problem"],
                    "backend": row["backend"],
                    "candidate": row["candidate"],
                    "source_aig_variables": int(row["aig_variables"]),
                    "source_aig_ands": int(row["aig_ands"]),
                    "output_index": cone.output_index,
                    **cone_header,
                    "embedded_nodes": nodes,
                    "embedded_edges": edges,
                    "embedding_seconds": f"{seconds:.6f}",
                    "cone_path": str(cone_path),
                }
            )

    assert vectors
    embeddings = np.asarray(vectors, dtype=np.float32)
    np.save(args.output_dir / "deepgate_cone_embeddings.npy", embeddings)
    summary = {
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "rows_csv": str(args.rows_csv),
        "output_dir": str(args.output_dir),
        "max_cone_ands": args.max_cone_ands,
        "max_cones_per_row": args.max_cones_per_row,
        "skipped_large_rows": len(skipped_rows),
        "cone_embedding_count": len(out_rows),
        "cone_problem_count": len({row["problem"] for row in out_rows}),
        "cone_problems": sorted({str(row["problem"]) for row in out_rows}),
        "max_selected_cone_ands": max(int(row["cone_ands"]) for row in out_rows),
        "max_embedding_seconds": max(float(row["embedding_seconds"]) for row in out_rows),
        "mean_embedding_seconds": float(np.mean([float(row["embedding_seconds"]) for row in out_rows])),
        "full_transition_problem_count": len({row["problem"] for row in rows if row["status"] == "embedded"}),
        "combined_problem_count": len({row["problem"] for row in rows if row["status"] == "embedded"} | {row["problem"] for row in out_rows}),
        "combined_problems": sorted({row["problem"] for row in rows if row["status"] == "embedded"} | {str(row["problem"]) for row in out_rows}),
    }
    summary.update(cosine_summary(out_rows, embeddings))

    rows_path = args.package_dir / "tables" / "deepgate_cone_rows.csv"
    summary_path = args.package_dir / "tables" / "deepgate_cone_summary.json"
    write_csv(rows_path, out_rows)
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    plot_cones(out_rows, embeddings, args.package_dir / "figures" / "deepgate_cone_embedding_pca.png")


if __name__ == "__main__":
    main()
