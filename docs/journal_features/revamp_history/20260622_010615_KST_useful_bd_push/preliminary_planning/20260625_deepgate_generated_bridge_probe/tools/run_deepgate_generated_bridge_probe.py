"""Probe official DeepGate2 embeddings on generated REvolution RTL."""

from __future__ import annotations

import argparse
import csv
import json
import shutil
import subprocess
import time
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import torch
import deepgate


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--live-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--max-per-backend-problem", required=True, type=int)
    parser.add_argument("--max-aig-vars", required=True, type=int)
    parser.add_argument("--state-policy", required=True, choices=["latch_free", "transition"])
    return parser.parse_args()


def collect_candidates(live_root: Path, max_per_backend_problem: int) -> list[Path]:
    counts: dict[tuple[str, str], int] = defaultdict(int)
    paths: list[Path] = []
    for code_path in sorted(live_root.glob("*/seed_1001/*/*/*/Gen*/*/code.sv")):
        parts = code_path.relative_to(live_root).parts
        backend = parts[0]
        problem = parts[4]
        key = (backend, problem)
        if counts[key] >= max_per_backend_problem:
            continue
        if not (code_path.parent / "code_synthesis_report.ppa").exists():
            continue
        counts[key] += 1
        paths.append(code_path)
    return paths


def yosys_script(code_path: Path, aig_path: Path, state_policy: str) -> str:
    if state_policy == "latch_free":
        return (
            f"read_verilog -sv {code_path}; hierarchy -auto-top; proc; "
            f"flatten; opt; setundef -zero; techmap; opt; aigmap; "
            f"write_aiger -ascii {aig_path}"
        )
    if state_policy == "transition":
        return (
            f"read_verilog -sv {code_path}; hierarchy -auto-top; proc; "
            f"async2sync; clk2fflogic; flatten; opt; setundef -zero; "
            f"techmap; opt; aigmap; write_aiger -ascii {aig_path}"
        )
    raise AssertionError(state_policy)


def abstract_latches_as_transition(aig_path: Path) -> None:
    lines = aig_path.read_text().splitlines()
    header = lines[0].split()
    assert header[0] == "aag"
    _, inputs, latches, outputs, ands = map(int, header[1:6])
    input_literals = [int(line.split()[0]) for line in lines[1 : 1 + inputs]]
    latch_lines = lines[1 + inputs : 1 + inputs + latches]
    output_literals = [int(line.split()[0]) for line in lines[1 + inputs + latches : 1 + inputs + latches + outputs]]
    and_lines = [line.split() for line in lines[1 + inputs + latches + outputs : 1 + inputs + latches + outputs + ands]]
    latch_current_literals = [int(line.split()[0]) for line in latch_lines]
    latch_next_literals = [int(line.split()[1]) for line in latch_lines]
    old_input_vars = [literal // 2 for literal in [*input_literals, *latch_current_literals]]
    var_map = {old_var: index + 1 for index, old_var in enumerate(old_input_vars)}
    constant_literals = [
        literal
        for literal in [
            *output_literals,
            *latch_next_literals,
            *(int(item) for line in and_lines for item in line[1:]),
        ]
        if literal < 2
    ]
    constant_var = len(old_input_vars) + 1 if constant_literals else None
    next_var = len(old_input_vars) + 1
    if constant_var is not None:
        next_var += 1
    for line in and_lines:
        var_map[int(line[0]) // 2] = next_var
        next_var += 1

    def remap_literal(literal: int) -> int:
        if literal < 2:
            assert constant_var is not None
            return constant_var * 2 + literal
        return var_map[literal // 2] * 2 + literal % 2

    new_input_count = len(old_input_vars) + int(constant_var is not None)
    new_inputs = [str((index + 1) * 2) for index in range(new_input_count)]
    new_outputs = [str(remap_literal(literal)) for literal in [*output_literals, *latch_next_literals]]
    new_ands = [
        f"{remap_literal(int(line[0]))} {remap_literal(int(line[1]))} {remap_literal(int(line[2]))}"
        for line in and_lines
    ]
    aig_path.write_text(
        "\n".join(
            [
                f"aag {next_var - 1} {len(new_inputs)} 0 {len(new_outputs)} {len(new_ands)}",
                *new_inputs,
                *new_outputs,
                *new_ands,
            ]
        )
        + "\n"
    )


def export_aig(code_path: Path, aig_path: Path, state_policy: str) -> tuple[str, str]:
    command = [
        "yosys",
        "-q",
        "-p",
        yosys_script(code_path, aig_path, state_policy),
    ]
    result = subprocess.run(command, check=False, capture_output=True, text=True, timeout=60)
    if result.returncode == 0 and state_policy == "transition":
        abstract_latches_as_transition(aig_path)
    return ("exported", result.stderr[-600:]) if result.returncode == 0 else ("export_failed", result.stderr[-600:])


def read_aig_header(aig_path: Path) -> dict[str, int]:
    header = aig_path.read_text().splitlines()[0].split()
    assert header[0] == "aag"
    return {
        "variables": int(header[1]),
        "inputs": int(header[2]),
        "latches": int(header[3]),
        "outputs": int(header[4]),
        "ands": int(header[5]),
    }


def metadata(code_path: Path, live_root: Path) -> dict[str, str]:
    parts = code_path.relative_to(live_root).parts
    return {
        "backend": parts[0],
        "benchmark": parts[3],
        "problem": parts[4],
        "generation": parts[5],
        "candidate": parts[6],
        "code_path": str(code_path),
    }


def embed_rows(rows: list[dict[str, str]], output_dir: Path) -> np.ndarray:
    model = deepgate.Model()
    model.load_pretrained()
    model.eval()
    parser = deepgate.AigParser()
    vectors: list[np.ndarray] = []
    torch.set_num_threads(1)
    for row in rows:
        start = time.monotonic()
        graph = parser.read_aiger(row["aig_path"])
        assert graph.edge_index is not None
        with torch.no_grad():
            hs, hf = model(graph)
        vector = torch.cat([hs.mean(dim=0), hf.mean(dim=0)]).detach().cpu().numpy()
        row["embedded_nodes"] = str(int(len(graph.gate)))
        row["embedded_edges"] = str(int(graph.edge_index.shape[1]))
        row["embedding_seconds"] = f"{time.monotonic() - start:.6f}"
        row["status"] = "embedded"
        vectors.append(vector / np.linalg.norm(vector))
    embeddings = np.asarray(vectors, dtype=np.float32)
    np.save(output_dir / "deepgate_embeddings.npy", embeddings)
    return embeddings


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    fieldnames = sorted({key for row in rows for key in row})
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def cosine_summary(rows: list[dict[str, str]], embeddings: np.ndarray) -> dict[str, object]:
    if len(embeddings) < 2:
        return {
            "embedding_count": int(len(embeddings)),
            "pairwise_cosine_mean": None,
            "pairwise_cosine_min": None,
            "pairwise_cosine_max": None,
            "same_problem_nearest_ratio": None,
            "same_backend_nearest_ratio": None,
        }
    sim = embeddings @ embeddings.T
    mask = ~np.eye(sim.shape[0], dtype=bool)
    nearest_scores = sim.copy()
    np.fill_diagonal(nearest_scores, -2.0)
    nearest = np.argmax(nearest_scores, axis=1)
    same_problem = [rows[i]["problem"] == rows[j]["problem"] for i, j in enumerate(nearest)]
    same_backend = [rows[i]["backend"] == rows[j]["backend"] for i, j in enumerate(nearest)]
    return {
        "embedding_count": int(len(embeddings)),
        "pairwise_cosine_mean": float(sim[mask].mean()),
        "pairwise_cosine_min": float(sim[mask].min()),
        "pairwise_cosine_max": float(sim[mask].max()),
        "same_problem_nearest_ratio": float(np.mean(same_problem)),
        "same_backend_nearest_ratio": float(np.mean(same_backend)),
    }


def plot_projection(rows: list[dict[str, str]], embeddings: np.ndarray, path: Path) -> None:
    assert len(embeddings) >= 2
    centered = embeddings - embeddings.mean(axis=0)
    _, _, vh = np.linalg.svd(centered, full_matrices=False)
    xy = centered @ vh[:2].T
    problems = sorted({row["problem"] for row in rows})
    colors = plt.get_cmap("tab10")(np.linspace(0, 1, len(problems)))
    color_by_problem = dict(zip(problems, colors))
    plt.figure(figsize=(9, 6))
    for problem in problems:
        idx = [i for i, row in enumerate(rows) if row["problem"] == problem]
        plt.scatter(xy[idx, 0], xy[idx, 1], s=45, alpha=0.82, label=problem, color=color_by_problem[problem])
    plt.axhline(0, color="#c8c8c8", linewidth=0.8)
    plt.axvline(0, color="#c8c8c8", linewidth=0.8)
    plt.title("DeepGate2 Embeddings Of Generated RTL AIGs")
    plt.xlabel("PC1")
    plt.ylabel("PC2")
    plt.legend(loc="center left", bbox_to_anchor=(1.02, 0.5), fontsize=8)
    plt.tight_layout()
    plt.savefig(path, dpi=180)
    plt.close()


def main() -> None:
    args = parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "aigs").mkdir(exist_ok=True)
    for subdir in ["tables", "figures", "logs"]:
        (args.package_dir / subdir).mkdir(parents=True, exist_ok=True)

    rows: list[dict[str, str]] = []
    embed_ready: list[dict[str, str]] = []
    for index, code_path in enumerate(collect_candidates(args.live_root, args.max_per_backend_problem)):
        row = metadata(code_path, args.live_root)
        aig_path = args.output_dir / "aigs" / f"candidate_{index:04d}.aag"
        status, stderr_tail = export_aig(code_path, aig_path, args.state_policy)
        row.update({"aig_path": str(aig_path), "status": status, "stderr_tail": stderr_tail})
        if status == "exported":
            header = read_aig_header(aig_path)
            row.update({f"aig_{key}": str(value) for key, value in header.items()})
            if header["latches"] != 0:
                row["status"] = "skipped_latch_aig"
            elif header["variables"] > args.max_aig_vars:
                row["status"] = "skipped_too_large"
            elif header["ands"] == 0:
                row["status"] = "skipped_no_and"
            else:
                embed_ready.append(row)
        rows.append(row)

    embeddings = embed_rows(embed_ready, args.output_dir)
    summary = {
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "live_root": str(args.live_root),
        "output_dir": str(args.output_dir),
        "max_per_backend_problem": args.max_per_backend_problem,
        "max_aig_vars": args.max_aig_vars,
        "state_policy": args.state_policy,
        "candidate_count": len(rows),
        "export_success_count": sum(row["status"] != "export_failed" for row in rows),
        "embedded_problem_count": len({row["problem"] for row in embed_ready}),
        "embedded_backend_count": len({row["backend"] for row in embed_ready}),
        "status_counts": dict(sorted((status, sum(row["status"] == status for row in rows)) for status in {row["status"] for row in rows})),
    }
    summary.update(cosine_summary(embed_ready, embeddings))

    rows_path = args.output_dir / "deepgate_bridge_rows.csv"
    summary_path = args.output_dir / "deepgate_bridge_summary.json"
    write_csv(rows_path, rows)
    summary_path.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    if len(embeddings) >= 2:
        plot_projection(embed_ready, embeddings, args.output_dir / "deepgate_embedding_pca.png")

    shutil.copy2(rows_path, args.package_dir / "tables" / rows_path.name)
    shutil.copy2(summary_path, args.package_dir / "tables" / summary_path.name)
    if (args.output_dir / "deepgate_embedding_pca.png").exists():
        shutil.copy2(args.output_dir / "deepgate_embedding_pca.png", args.package_dir / "figures" / "deepgate_embedding_pca.png")


if __name__ == "__main__":
    main()
