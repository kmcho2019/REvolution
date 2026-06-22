from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_t44_t11_runtime_graph_bridge import METHODS, PROBLEMS, main


def test_package_t44_t11_runtime_graph_bridge(tmp_path: Path) -> None:
    roots = {
        "t44": tmp_path / "t44",
        "t43": tmp_path / "t43",
        "t39": tmp_path / "t39",
    }
    output_dir = tmp_path / "package"
    for method_index, method in enumerate(METHODS):
        for problem in PROBLEMS:
            _write_problem(roots[method.source], method.mode, problem, method_index)

    assert (
        main(
            [
                "--t44-run-root",
                str(roots["t44"]),
                "--t43-run-root",
                str(roots["t43"]),
                "--t39-run-root",
                str(roots["t39"]),
                "--output-dir",
                str(output_dir),
            ]
        )
        == 0
    )

    rows = list(csv.DictReader((output_dir / "tables" / "t44_candidate_ppa_points.csv").open()))
    summary = list(
        csv.DictReader((output_dir / "tables" / "t44_problem_method_summary.csv").open())
    )
    assert len(rows) == len(METHODS) * len(PROBLEMS) * 2
    assert len(summary) == len(METHODS) * len(PROBLEMS)
    assert (output_dir / "figures" / "t44_raw_area_power_fronts.png").read_bytes().startswith(
        b"\x89PNG"
    )
    html = (output_dir / "visualizations" / "direct_ppa_pareto" / "index.html").read_text(
        encoding="utf-8"
    )
    assert "T44 Direct PPA Fronts" in html
    assert "t44_raw_area_power_fronts.png" in html
    readme = (output_dir / "visualizations" / "direct_ppa_pareto" / "README.md").read_text(
        encoding="utf-8"
    )
    assert "not the full Phase 03.1" in readme


def _write_problem(root: Path, mode: str, problem: str, method_index: int) -> None:
    problem_root = root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps({"ref_ppa_metric": {"power": 10.0, "area": 100.0}}),
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
                },
            }
        )
    (problem_root / "generation_log.jsonl").write_text(
        json.dumps(
            {
                "generation": 0,
                "generated_candidates": generated,
                "population_ppa_details": details,
            }
        )
        + "\n",
        encoding="utf-8",
    )
