from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_t29_front_recovery_audit import METHODS, PROBLEMS, main


def test_package_t29_front_recovery_audit(tmp_path: Path) -> None:
    roots = {
        "t24": tmp_path / "t24",
        "t25": tmp_path / "t25",
        "t26": tmp_path / "t26",
        "t29": tmp_path / "t29",
    }
    for method_index, method in enumerate(METHODS):
        for problem in PROBLEMS:
            _write_problem(roots[method["source"]], method["mode"], problem, method_index)

    output_dir = tmp_path / "package"
    assert (
        main(
            [
                "--t24-run-root",
                str(roots["t24"]),
                "--t25-run-root",
                str(roots["t25"]),
                "--t26-run-root",
                str(roots["t26"]),
                "--t29-run-root",
                str(roots["t29"]),
                "--output-dir",
                str(output_dir),
            ]
        )
        == 0
    )

    live_rows = list(csv.DictReader((output_dir / "tables" / "t29_live_problem_metrics.csv").open()))
    family_rows = list(csv.DictReader((output_dir / "tables" / "t29_family_aggregate_metrics.csv").open()))
    t29 = next(row for row in family_rows if row["method"] == "sr_raw_front_recovery_qd")
    assert len(live_rows) == len(METHODS) * len(PROBLEMS)
    assert int(t29["valid_ppa_count"]) == len(PROBLEMS) * 2
    assert (output_dir / "figures" / "t29_live_aggregate_metrics.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "figures" / "t29_ppa_fronts_area_power_zoom.png").read_bytes().startswith(
        b"\x89PNG"
    )


def _write_problem(root: Path, mode: str, problem: str, method_index: int) -> None:
    problem_root = root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    final_best = None if method_index == len(METHODS) - 1 and problem == PROBLEMS[-1] else 1.0
    summary = {
        "problem_name": problem,
        "benchmark_name": "RTLLM",
        "total_candidates_generated": 2,
        "accumulated_success_rates": {
            "functionality": 1.0,
            "synthesis_ppa": 1.0,
        },
        "ref_ppa_metric": {
            "tns": 0.0,
            "wns": 0.0,
            "eff_clk_period": 10.0 if problem == PROBLEMS[-1] else 0.0,
            "power": 10.0,
            "area": 100.0,
        },
        "final_population_ppa": {
            "best_score": final_best,
            "best_metrics": {"area": 80.0, "power": 8.0, "eff_clk_period": 0.0},
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
        code_path.write_text(f"module {problem}; endmodule\n", encoding="utf-8")
        (candidate_dir / "code.syn.v").write_text(
            f"module {problem}();\n  AND2_X1 _{index}_ ();\nendmodule\n",
            encoding="utf-8",
        )
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
                "score": 1.0,
                "ppa_metrics": {
                    "area": 90.0 - method_index - index,
                    "power": 8.0 - index / 10.0,
                    "eff_clk_period": 9.0 - index if problem == PROBLEMS[-1] else 0.0,
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
    (problem_root / "archive_summary.json").write_text(
        json.dumps(
            {
                "coverage": 0.125,
                "qd_score": 1.5,
                "total_archive_members": 2,
                "occupied_cells": 2,
                "max_front_size": 1,
            }
        ),
        encoding="utf-8",
    )
    (problem_root / "global_pareto_summary.json").write_text(
        json.dumps({"total_global_pareto_members": 1}),
        encoding="utf-8",
    )
    (problem_root / "archive_history.jsonl").write_text(
        json.dumps({"generation": 0, "coverage": 0.125, "qd_score": 1.5}) + "\n",
        encoding="utf-8",
    )
