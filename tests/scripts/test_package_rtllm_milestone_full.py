from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_rtllm_milestone_full import METHODS, gate_row, main


def test_package_rtllm_milestone_full(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    output_dir = tmp_path / "package"
    manifest = tmp_path / "manifest.csv"
    problems = ["Prob045_alu", "Prob001_accu", "Prob043_RAM"]
    manifest.write_text(
        "index,benchmark,problem,prompt_path\n"
        + "\n".join(
            f"{index},RTLLM,{problem},bench/RTLLM/{problem}_prompt.txt"
            for index, problem in enumerate(problems, start=1)
        )
        + "\n",
        encoding="utf-8",
    )
    for method_index, method in enumerate(METHODS):
        for problem in problems:
            _write_problem(run_root, method["mode"], problem, method_index)

    assert (
        main(
            [
                "--run-root",
                str(run_root),
                "--manifest",
                str(manifest),
                "--output-dir",
                str(output_dir),
            ]
        )
        == 0
    )

    rows = list(csv.DictReader((output_dir / "tables" / "full_problem_metrics.csv").open()))
    aggregates = list(
        csv.DictReader((output_dir / "tables" / "full_aggregate_metrics.csv").open())
    )
    candidates = list(csv.DictReader((output_dir / "data" / "full_ppa_candidates.csv").open()))
    report = (output_dir / "README.md").read_text(encoding="utf-8")
    assert len(rows) == len(METHODS) * len(problems)
    assert len(aggregates) == len(METHODS) * 3
    assert candidates
    assert "Mean HV delta, all RTLLM" in report
    for figure in (
        "full_hv_delta_distribution.png",
        "full_hv_auc_delta_distribution.png",
        "full_hv_scatter.png",
        "full_win_loss_heatmap.png",
        "full_validity_funnel.png",
        "full_front_counts.png",
        "full_representative_ppa_fronts.png",
    ):
        assert (output_dir / "figures" / figure).read_bytes().startswith(b"\x89PNG")


def test_gate_row_keeps_zero_valid_ppa_as_hard_loss() -> None:
    classic = {"valid_ppa_count": "8", "functionality_count": "8"}
    qd_zero = {"valid_ppa_count": "0", "functionality_count": "0"}
    qd_one = {"valid_ppa_count": "1", "functionality_count": "1"}
    classic_large = {"valid_ppa_count": "12", "functionality_count": "12"}
    qd_warning = {"valid_ppa_count": "5", "functionality_count": "5"}

    assert gate_row("p", "valid_ppa_count", qd_zero, classic)["gate_status"] == "classic_covered_loss"
    assert gate_row("p", "valid_ppa_count", qd_one, classic)["gate_status"] == "small_n"
    assert gate_row("p", "valid_ppa_count", qd_warning, classic_large)["gate_status"] == "yield_warning"


def _write_problem(root: Path, mode: str, problem: str, method_index: int) -> None:
    problem_root = root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    area = 100.0 - method_index * 5.0
    power = 10.0 - method_index * 0.5
    details = [
        {
            "id": f"{problem}-{method_index}-0",
            "strategy": "initial",
            "score": method_index / 10.0,
            "ppa_metrics": {"area": area, "power": power},
        }
    ]
    generation_rows = [
        {
            "generation": 0,
            "population_ppa_details": details,
        }
    ]
    (problem_root / "generation_log.jsonl").write_text(
        "\n".join(json.dumps(row) for row in generation_rows) + "\n",
        encoding="utf-8",
    )
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps(
            {
                "benchmark_name": "RTLLM",
                "problem_name": problem,
                "total_candidates_generated": 2,
                "accumulated_success_rates": {
                    "syntax": 1.0,
                    "functionality": 0.5,
                    "synthesis_ppa": 0.5,
                },
                "final_population_ppa": {"best_score": method_index / 10.0},
                "final_population_ppa_details": details,
                "ref_ppa_metric": {"area": 100.0, "power": 10.0},
            }
        ),
        encoding="utf-8",
    )
