from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_t47_contract_probe import gate_row, main


def test_package_t47_contract_probe(tmp_path: Path) -> None:
    run_root = tmp_path / "run"
    output_dir = tmp_path / "package"
    matrix = tmp_path / "probe_problem_matrix.csv"
    rows = []
    for seed in (1001, 1002):
        for benchmark, problem in (
            ("RTLLM", "Prob045_alu"),
            ("VerilogEval-Spec-to-RTL", "Prob153_gshare"),
        ):
            for arm in ("classic_revolution", "sr_raw_conservative_exploit_qd"):
                rows.append(
                    {
                        "phase": "hard_tuning_sanity",
                        "subset": "data/configs/hard_iteration_subset.yaml",
                        "seed": str(seed),
                        "arm": arm,
                        "benchmark": benchmark,
                        "problem": problem,
                        "reference_status": "reference_available",
                        "headline_eligible": "true",
                    }
                )
                _write_problem(run_root, seed, arm, benchmark, problem)
    with matrix.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)

    assert (
        main(
            [
                "--run-root",
                str(run_root),
                "--matrix",
                str(matrix),
                "--output-dir",
                str(output_dir),
            ]
        )
        == 0
    )

    problem_rows = list(
        csv.DictReader((output_dir / "tables" / "t47_problem_seed_metrics.csv").open())
    )
    aggregate_rows = list(
        csv.DictReader((output_dir / "tables" / "t47_aggregate_metrics.csv").open())
    )
    candidates = list(
        csv.DictReader((output_dir / "data" / "t47_ppa_candidates.csv").open())
    )
    report = (output_dir / "README.md").read_text(encoding="utf-8")
    assert len(problem_rows) == 8
    assert aggregate_rows
    assert candidates
    assert "Claim status" in report
    assert "Mean HV delta" in report
    for figure in (
        "t47_hv_delta_heatmap.png",
        "t47_metric_delta_summary.png",
        "t47_validity_funnel.png",
        "t47_front_counts.png",
    ):
        assert (output_dir / "figures" / figure).read_bytes().startswith(b"\x89PNG")


def test_gate_row_relaxes_small_valid_ppa_denominator() -> None:
    classic = {"valid_ppa_count": "8", "functionality_count": "8"}
    qd_one = {"valid_ppa_count": "1", "functionality_count": "1"}
    qd_zero = {"valid_ppa_count": "0", "functionality_count": "0"}
    classic_large = {"valid_ppa_count": "12", "functionality_count": "12"}
    qd_warning = {"valid_ppa_count": "6", "functionality_count": "6"}

    assert (
        gate_row("1001", "RTLLM", "p", "valid_ppa_count", qd_one, classic)[
            "gate_status"
        ]
        == "small_n"
    )
    assert (
        gate_row("1001", "RTLLM", "p", "valid_ppa_count", qd_zero, classic)[
            "gate_status"
        ]
        == "classic_covered_loss"
    )
    assert (
        gate_row("1001", "RTLLM", "p", "valid_ppa_count", qd_warning, classic_large)[
            "gate_status"
        ]
        == "yield_warning"
    )


def _write_problem(
    run_root: Path,
    seed: int,
    method: str,
    benchmark: str,
    problem: str,
) -> None:
    problem_root = run_root / method / f"seed_{seed}" / "openai_gpt-oss-120b" / benchmark / problem
    problem_root.mkdir(parents=True)
    method_offset = 40.0 if method == "sr_raw_conservative_exploit_qd" else 10.0
    area = 100.0 - method_offset
    power = 10.0 - method_offset / 20.0
    eff_clk_period = 5.0 - method_offset / 100.0
    details = [
        {
            "id": f"{seed}-{method}-{problem}",
            "strategy": "sample",
            "score": method_offset / 10.0,
            "ppa_metrics": {
                "area": area,
                "power": power,
                "eff_clk_period": eff_clk_period,
            },
        }
    ]
    (problem_root / "generation_log.jsonl").write_text(
        json.dumps({"generation": 0, "population_ppa_details": details}) + "\n",
        encoding="utf-8",
    )
    (problem_root / f"{problem}_summary.json").write_text(
        json.dumps(
            {
                "benchmark_name": benchmark,
                "problem_name": problem,
                "total_candidates_generated": 10,
                "accumulated_success_rates": {
                    "syntax": 1.0,
                    "functionality": 0.8,
                    "synthesis_ppa": 0.8,
                },
                "final_population_ppa": {"best_score": method_offset / 10.0},
                "final_population_ppa_details": details,
                "ref_ppa_metric": {
                    "area": 100.0,
                    "power": 10.0,
                    "eff_clk_period": 5.0,
                },
            }
        ),
        encoding="utf-8",
    )
    if method == "sr_raw_conservative_exploit_qd":
        (problem_root / "archive_summary.json").write_text(
            json.dumps(
                {
                    "coverage": 0.1,
                    "qd_score": 0.2,
                    "total_archive_members": 2,
                }
            ),
            encoding="utf-8",
        )
        (problem_root / "global_pareto_summary.json").write_text(
            json.dumps({"total_global_pareto_members": 1}),
            encoding="utf-8",
        )
        (problem_root / "archive_history.jsonl").write_text(
            json.dumps({"coverage": 0.1, "qd_score": 0.2}) + "\n",
            encoding="utf-8",
        )
