from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_t40_sparse_warmup_control_matrix import METHODS, PROBLEMS, main


def test_package_t40_sparse_warmup_control_matrix(tmp_path: Path) -> None:
    t40_root = tmp_path / "t40"
    t39_root = tmp_path / "t39"
    output_dir = tmp_path / "package"
    roots = {"t40": t40_root, "t39": t39_root}

    for method_index, method in enumerate(METHODS):
        for problem in PROBLEMS:
            _write_problem(roots[method.source], method.mode, problem, method_index)

    assert (
        main(
            [
                "--t40-run-root",
                str(t40_root),
                "--t39-run-root",
                str(t39_root),
                "--output-dir",
                str(output_dir),
            ]
        )
        == 0
    )

    rows = list(csv.DictReader((output_dir / "tables" / "t40_candidate_ppa_points.csv").open()))
    summary = list(
        csv.DictReader((output_dir / "tables" / "t40_problem_method_summary.csv").open())
    )
    assert len(rows) == len(METHODS) * len(PROBLEMS) * 2
    assert len(summary) == len(METHODS) * len(PROBLEMS)
    assert all(int(row["area_power_front_count"]) >= 1 for row in summary)
    assert (output_dir / "figures" / "t40_raw_area_power_fronts.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "figures" / "t40_front_count_summary.png").read_bytes().startswith(
        b"\x89PNG"
    )
    html = (output_dir / "visualizations" / "direct_ppa_pareto" / "index.html").read_text(
        encoding="utf-8"
    )
    assert "T40 Direct PPA Fronts" in html


def _write_problem(root: Path, mode: str, problem: str, method_index: int) -> None:
    problem_root = root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    ref = {"power": 10.0, "area": 100.0, "eff_clk_period": 6.0}
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps({"ref_ppa_metric": ref}),
        encoding="utf-8",
    )
    generated = []
    details = []
    for index in range(2):
        candidate_id = f"{problem}-{method_index}-{index}"
        generated.append(
            {
                "id": candidate_id,
                "strategy": "initial",
                "status": "success",
                "code_file_path": str(problem_root / f"{candidate_id}.sv"),
            }
        )
        details.append(
            {
                "id": candidate_id,
                "strategy": "initial",
                "score": 0.4 + method_index / 10.0 - index / 100.0,
                "ppa_metrics": {
                    "area": 100.0 - method_index - index,
                    "power": 10.0 - index / 10.0,
                    "eff_clk_period": 6.0 - index / 10.0,
                },
            }
        )
    payload = {
        "generation": 0,
        "generated_candidates": generated,
        "population_ppa_details": details,
    }
    (problem_root / "generation_log.jsonl").write_text(
        json.dumps(payload) + "\n",
        encoding="utf-8",
    )
