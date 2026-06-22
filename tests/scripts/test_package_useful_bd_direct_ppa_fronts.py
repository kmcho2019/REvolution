from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_useful_bd_direct_ppa_fronts import METHODS, PROBLEMS, main


def test_package_useful_bd_direct_ppa_fronts(tmp_path: Path) -> None:
    t24_root = tmp_path / "t24"
    t25_root = tmp_path / "t25"
    t26_root = tmp_path / "t26"
    output_dir = tmp_path / "direct_fronts"
    roots = {"t24": t24_root, "t25": t25_root, "t26": t26_root}

    for method_index, method in enumerate(METHODS):
        for problem in PROBLEMS:
            _write_problem(roots[method.source], method.mode, problem, method_index)

    assert (
        main(
            [
                "--t24-run-root",
                str(t24_root),
                "--t25-run-root",
                str(t25_root),
                "--t26-run-root",
                str(t26_root),
                "--output-dir",
                str(output_dir),
            ]
        )
        == 0
    )

    candidate_rows = list(csv.DictReader((output_dir / "tables" / "candidate_ppa_points.csv").open()))
    front_rows = list(csv.DictReader((output_dir / "tables" / "problem_front_counts.csv").open()))
    assert len(candidate_rows) == len(METHODS) * len(PROBLEMS) * 2
    assert len(front_rows) == len(METHODS) * len(PROBLEMS)
    assert all(int(row["area_power_front_count"]) >= 1 for row in front_rows)
    assert all(int(row["active_objective_front_count"]) >= 1 for row in front_rows)
    assert (output_dir / "figures" / "live_key_ppa_fronts_area_power.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (
        output_dir / "figures" / "live_key_ppa_fronts_area_power_zoom.png"
    ).read_bytes().startswith(b"\x89PNG")
    assert (output_dir / "figures" / "live_key_ppa_fronts_improvement.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "figures" / "live_all_ppa_fronts_area_power.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (
        output_dir / "figures" / "live_all_ppa_fronts_area_power_zoom.png"
    ).read_bytes().startswith(b"\x89PNG")
    assert (output_dir / "figures" / "live_all_ppa_fronts_improvement.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "figures" / "live_front_count_summary.png").read_bytes().startswith(
        b"\x89PNG"
    )


def _write_problem(
    root: Path,
    mode: str,
    problem: str,
    method_index: int,
) -> None:
    problem_root = root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    summary = {
        "problem_name": problem,
        "benchmark_name": "RTLLM",
        "ref_ppa_metric": {
            "tns": 0.0,
            "wns": 0.0,
            "eff_clk_period": 10.0 if problem == "Prob015_multi_pipe_8bit" else 0.0,
            "power": 10.0,
            "area": 100.0,
        },
    }
    (problem_root / f"{problem}_summary.json").write_text(json.dumps(summary), encoding="utf-8")

    generated = []
    details = []
    for index in range(2):
        candidate_id = f"{problem}-{method_index}-{index}"
        candidate_dir = problem_root / "Gen0" / f"{candidate_id}_initial"
        candidate_dir.mkdir(parents=True)
        code_path = candidate_dir / "code.sv"
        code_path.write_text("module top; endmodule\n", encoding="utf-8")
        generated.append(
            {
                "id": candidate_id,
                "strategy": "initial",
                "status": "success",
                "code_file_path": str(code_path),
            }
        )
        details.append(
            {
                "id": candidate_id,
                "strategy": "initial",
                "score": 1.0 + method_index / 10.0 - index / 100.0,
                "ppa_metrics": {
                    "area": 100.0 - method_index - index,
                    "power": 10.0 - index / 10.0,
                    "eff_clk_period": 10.0 - index if problem == "Prob015_multi_pipe_8bit" else 0.0,
                },
            }
        )
    row = {
        "generation": 0,
        "generated_candidates": generated,
        "population_ppa_details": details,
    }
    (problem_root / "generation_log.jsonl").write_text(json.dumps(row) + "\n", encoding="utf-8")
