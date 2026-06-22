from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_rtllm_milestone_screen import METHODS, PROBLEMS, main, problem_gate_row


def test_package_rtllm_milestone_screen(tmp_path: Path) -> None:
    run_root = tmp_path / "screen"
    output_dir = tmp_path / "package"
    for method_index, method in enumerate(METHODS):
        for problem in PROBLEMS:
            _write_problem(run_root, method["mode"], problem, method_index)

    assert main(["--run-root", str(run_root), "--output-dir", str(output_dir)]) == 0

    rows = list(csv.DictReader((output_dir / "tables" / "screen_problem_metrics.csv").open()))
    aggregate = list(
        csv.DictReader((output_dir / "tables" / "screen_aggregate_metrics.csv").open())
    )
    report = (output_dir / "selection_report.md").read_text(encoding="utf-8")
    assert len(rows) == len(METHODS) * len(PROBLEMS)
    assert len(aggregate) == len(METHODS)
    assert "Selected full-run QD arm: `sr_raw_conservative_exploit_qd`" in report
    assert (output_dir / "figures" / "screen_problem_metrics.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "figures" / "screen_aggregate_metrics.png").read_bytes().startswith(
        b"\x89PNG"
    )


def test_problem_gate_row_keeps_classic_covered_loss() -> None:
    rows = {
        ("classic", "tiny"): {"valid_ppa_count": "5"},
        ("qd", "tiny"): {"valid_ppa_count": "0"},
        ("classic", "large"): {"valid_ppa_count": "12"},
        ("qd", "large"): {"valid_ppa_count": "0"},
        ("classic", "warning"): {"valid_ppa_count": "12"},
        ("qd", "warning"): {"valid_ppa_count": "5"},
        ("classic", "small_n"): {"valid_ppa_count": "5"},
        ("qd", "small_n"): {"valid_ppa_count": "1"},
    }

    assert (
        problem_gate_row(rows, "qd", "classic", "tiny")["gate_status"]
        == "classic_covered_loss"
    )
    assert (
        problem_gate_row(rows, "qd", "classic", "large")["gate_status"]
        == "classic_covered_loss"
    )
    assert (
        problem_gate_row(rows, "qd", "classic", "warning")["gate_status"]
        == "yield_warning"
    )
    assert (
        problem_gate_row(rows, "qd", "classic", "small_n")["gate_status"]
        == "small_n"
    )


def _write_problem(root: Path, mode: str, problem: str, method_index: int) -> None:
    problem_root = root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    area = 100.0 - method_index * 2.0
    power = 10.0 - method_index * 0.2
    if method_index == 1:
        area = 94.0
        power = 9.4
    details = [
        {
            "id": f"{problem}-{method_index}-0",
            "strategy": "initial",
            "score": method_index / 10.0,
            "ppa_metrics": {"area": area, "power": power},
        }
    ]
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps(
            {
                "benchmark_name": "RTLLM",
                "problem_name": problem,
                "total_candidates_generated": 2,
                "accumulated_success_rates": {"synthesis_ppa": 0.5},
                "final_population_ppa": {"best_score": method_index / 10.0},
                "final_population_ppa_details": details,
                "ref_ppa_metric": {"area": 100.0, "power": 10.0},
            }
        ),
        encoding="utf-8",
    )
