#!/usr/bin/env python3
"""Package the T41 adaptive sparse-yield gate screen."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scripts.package_t40_sparse_warmup_control_matrix import (
    MethodSpec,
    PROBLEMS,
    candidate_rows,
    collect_candidates,
    manifest_rows,
    mark_pooled_fronts,
    plot_count_summary,
    plot_raw_fronts,
    problem_summary_rows,
    write_csv,
    write_viewer,
)

METHODS = (
    MethodSpec(
        "classic_revolution",
        "T41 Classic",
        "t41",
        "classic_revolution/seed_1001/openai_gpt-oss-120b",
        "#1f77b4",
    ),
    MethodSpec(
        "adaptive_sparse_yield_gate_qd",
        "T41 adaptive gate",
        "t41",
        "adaptive_sparse_yield_gate_qd/seed_1001/openai_gpt-oss-120b",
        "#d62728",
    ),
    MethodSpec(
        "manual_sparse_pareto_qd",
        "T40 manual BD",
        "t40",
        "manual_sparse_pareto_qd/seed_1001/openai_gpt-oss-120b",
        "#9467bd",
    ),
    MethodSpec(
        "random_sparse_elite_slot_qd",
        "T40 random one-slot",
        "t40",
        "random_sparse_elite_slot_qd/seed_1001/openai_gpt-oss-120b",
        "#7f7f7f",
    ),
    MethodSpec(
        "graph_full_pareto_sparse_qd",
        "T40 graph full Pareto",
        "t40",
        "graph_full_pareto_sparse_qd/seed_1001/openai_gpt-oss-120b",
        "#ff7f0e",
    ),
    MethodSpec(
        "t39_sparse_warmup_elite_slot_qd",
        "T39 one-slot",
        "t39",
        "sparse_warmup_elite_slot_qd/seed_1001/openai_gpt-oss-120b",
        "#2ca02c",
    ),
)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--t41-run-root", required=True, type=Path)
    parser.add_argument("--t40-run-root", required=True, type=Path)
    parser.add_argument("--t39-run-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args(argv)

    roots = {
        "t41": args.t41_run_root,
        "t40": args.t40_run_root,
        "t39": args.t39_run_root,
    }
    table_dir = args.output_dir / "tables"
    figure_dir = args.output_dir / "figures"
    viewer_dir = args.output_dir / "visualizations" / "direct_ppa_pareto"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)
    viewer_dir.mkdir(parents=True, exist_ok=True)

    candidates = [
        candidate
        for method in METHODS
        for problem in PROBLEMS
        for candidate in collect_candidates(roots, method, problem)
    ]
    candidates = mark_pooled_fronts(candidates)
    summary_rows = problem_summary_rows(candidates, METHODS)
    write_csv(table_dir / "t41_candidate_ppa_points.csv", candidate_rows(candidates))
    write_csv(table_dir / "t41_problem_method_summary.csv", summary_rows)
    write_csv(table_dir / "t41_method_manifest.csv", manifest_rows(roots, METHODS))
    plot_raw_fronts(
        candidates,
        figure_dir / "t41_raw_area_power_fronts.png",
        METHODS,
        "T41 Adaptive Sparse-Yield Gate",
    )
    plot_count_summary(
        summary_rows,
        figure_dir / "t41_front_count_summary.png",
        METHODS,
        "T41 Adaptive Sparse-Yield Gate",
    )
    write_viewer(
        viewer_dir / "index.html",
        summary_rows,
        title="T41 Direct PPA Fronts",
        image_name="t41_raw_area_power_fronts.png",
    )
    (viewer_dir / "metrics.json").write_text(
        json.dumps(summary_rows, indent=2) + "\n",
        encoding="utf-8",
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
