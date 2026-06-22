from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_t30_holdout_front_audit import METHODS, PROBLEMS, main


def test_package_t30_holdout_front_audit(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    for method_index, method in enumerate(METHODS):
        for problem in PROBLEMS:
            _write_problem(run_root, method["mode"], problem, method_index)

    output_dir = tmp_path / "package"
    assert (
        main(
            [
                "--run-root",
                str(run_root),
                "--output-dir",
                str(output_dir),
            ]
        )
        == 0
    )

    live_rows = list(
        csv.DictReader(
            (output_dir / "tables" / "t30_holdout_live_problem_metrics.csv").open()
        )
    )
    family_rows = list(
        csv.DictReader(
            (output_dir / "tables" / "t30_holdout_family_aggregate_metrics.csv").open()
        )
    )
    t26 = next(row for row in family_rows if row["method"] == "sr_raw_conservative_exploit_qd")
    assert len(live_rows) == len(METHODS) * len(PROBLEMS)
    assert int(t26["valid_ppa_count"]) == len(PROBLEMS) * 2
    assert (output_dir / "figures" / "t30_holdout_live_aggregate.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (
        output_dir / "figures" / "t30_holdout_ppa_pareto_area_power.png"
    ).read_bytes().startswith(b"\x89PNG")
    assert (
        output_dir / "figures" / "t30_holdout_ppa_pareto_area_power_candidate_zoom.png"
    ).read_bytes().startswith(b"\x89PNG")
    assert (
        output_dir / "figures" / "t30_holdout_ppa_fronts_improvement.png"
    ).read_bytes().startswith(b"\x89PNG")


def _write_problem(root: Path, mode: str, problem: str, method_index: int) -> None:
    problem_root = root / mode / "VerilogEval-Spec-to-RTL" / problem
    problem_root.mkdir(parents=True)
    summary = {
        "problem_name": problem,
        "benchmark_name": "VerilogEval-Spec-to-RTL",
        "total_candidates_generated": 2,
        "accumulated_success_rates": {
            "functionality": 1.0,
            "synthesis_ppa": 1.0,
        },
        "ref_ppa_metric": {
            "tns": 0.0,
            "wns": 0.0,
            "eff_clk_period": 0.0,
            "power": 10.0,
            "area": 100.0,
        },
        "final_population_ppa": {
            "best_score": 1.0 + method_index,
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
            f"module {problem}();\n  NAND2_X1 _{index}_ ();\nendmodule\n",
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
                    "eff_clk_period": 0.0,
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
