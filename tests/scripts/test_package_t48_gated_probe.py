from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_t48_gated_probe import gate_row, main


def test_package_t48_gated_probe(tmp_path: Path) -> None:
    classic_root = tmp_path / "classic"
    qd_root = tmp_path / "qd"
    output_dir = tmp_path / "package"
    matrix = tmp_path / "probe_problem_matrix.csv"
    rows = []
    for seed in (1001, 1002):
        for benchmark, problem in (
            ("RTLLM", "Prob045_alu"),
            ("VerilogEval-Spec-to-RTL", "Prob153_gshare"),
        ):
            rows.append(
                {
                    "phase": "hard_tuning_sanity",
                    "subset": "data/configs/hard_iteration_subset.yaml",
                    "seed": str(seed),
                    "arm": "classic_revolution",
                    "benchmark": benchmark,
                    "problem": problem,
                    "reference_status": "reference_available",
                    "headline_eligible": "true",
                }
            )
            _write_problem(classic_root, seed, benchmark, problem, "classic_revolution")
            _write_problem(qd_root, seed, benchmark, problem, "t26_gated_near_front_fusion_qd")

    with matrix.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)

    assert (
        main(
            [
                "--classic-root",
                str(classic_root),
                "--qd-root",
                str(qd_root),
                "--matrix",
                str(matrix),
                "--output-dir",
                str(output_dir),
                "--package-tag",
                "t48",
                "--qd-method",
                "t26_gated_near_front_fusion_qd",
            ]
        )
        == 0
    )

    problem_rows = list(
        csv.DictReader((output_dir / "tables" / "t48_problem_seed_metrics.csv").open())
    )
    counter_rows = list(
        csv.DictReader((output_dir / "tables" / "t48_gate_counters.csv").open())
    )
    candidates = list(
        csv.DictReader((output_dir / "data" / "t48_ppa_candidates.csv").open())
    )
    report = (output_dir / "README.md").read_text(encoding="utf-8")
    assert len(problem_rows) == 8
    assert counter_rows[0]["qd_two_parent_gate"] == "near_front_descriptor"
    assert candidates
    assert "Two-parent gate accepts" in report
    for figure in (
        "t48_hv_delta_heatmap.png",
        "t48_metric_delta_summary.png",
        "t48_validity_funnel.png",
        "t48_front_counts.png",
        "t48_gate_counters.png",
        "t48_direct_ppa_fronts_seed1001.png",
        "t48_direct_ppa_fronts_seed1002.png",
    ):
        assert (output_dir / "figures" / figure).read_bytes().startswith(b"\x89PNG")

    t49_dir = tmp_path / "package_t49"
    assert (
        main(
            [
                "--classic-root",
                str(classic_root),
                "--qd-root",
                str(qd_root),
                "--matrix",
                str(matrix),
                "--output-dir",
                str(t49_dir),
                "--seed",
                "1001",
                "--package-tag",
                "t49",
                "--package-title",
                "T49",
                "--qd-method",
                "thought_k_role_separated_repair_qd",
                "--qd-label",
                "T49",
                "--counter-stem",
                "operator_counters",
                "--counter-title",
                "Operator Counters",
                "--counter-keys",
                "generated_thought_count,two_parent_attempts",
            ]
        )
        == 0
    )
    t49_rows = list(
        csv.DictReader((t49_dir / "tables" / "t49_problem_seed_metrics.csv").open())
    )
    t49_counters = list(
        csv.DictReader((t49_dir / "tables" / "t49_operator_counters.csv").open())
    )
    assert len(t49_rows) == 4
    assert t49_counters[0]["generated_thought_count"] == "3"
    assert (t49_dir / "figures" / "t49_operator_counters.png").read_bytes().startswith(
        b"\x89PNG"
    )


def test_gate_row_marks_sparse_cases() -> None:
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


def test_package_t48_gated_probe_derives_missing_summary(tmp_path: Path) -> None:
    classic_root = tmp_path / "classic"
    qd_root = tmp_path / "qd"
    output_dir = tmp_path / "package"
    matrix = tmp_path / "probe_problem_matrix.csv"
    row = {
        "phase": "hard_tuning_sanity",
        "subset": "data/configs/hard_iteration_subset.yaml",
        "seed": "1001",
        "arm": "classic_revolution",
        "benchmark": "RTLLM",
        "problem": "Prob004_adder_8bit",
        "reference_status": "reference_available",
        "headline_eligible": "true",
    }
    _write_problem(classic_root, 1001, "RTLLM", "Prob004_adder_8bit", "classic_revolution")
    _write_problem(qd_root, 1001, "RTLLM", "Prob004_adder_8bit", "t26_gated_near_front_fusion_qd")
    qd_problem = (
        qd_root
        / "seed_1001"
        / "openai_gpt-oss-120b"
        / "RTLLM"
        / "Prob004_adder_8bit"
    )
    (qd_problem / "Prob004_adder_8bit_summary.json").unlink()

    with matrix.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(row), lineterminator="\n")
        writer.writeheader()
        writer.writerow(row)

    assert (
        main(
            [
                "--classic-root",
                str(classic_root),
                "--qd-root",
                str(qd_root),
                "--matrix",
                str(matrix),
                "--output-dir",
                str(output_dir),
                "--package-tag",
                "t48",
                "--qd-method",
                "t26_gated_near_front_fusion_qd",
            ]
        )
        == 0
    )

    problem_rows = list(
        csv.DictReader((output_dir / "tables" / "t48_problem_seed_metrics.csv").open())
    )
    qd_rows = [row for row in problem_rows if row["method"] == "t26_gated_near_front_fusion_qd"]
    assert qd_rows[0]["total_generated"] == "10"
    assert qd_rows[0]["best_score"] == "4.000000"


def _write_problem(
    method_root: Path,
    seed: int,
    benchmark: str,
    problem: str,
    method: str,
) -> None:
    problem_root = method_root / f"seed_{seed}" / "openai_gpt-oss-120b" / benchmark / problem
    problem_root.mkdir(parents=True)
    method_offset = 40.0 if method == "t26_gated_near_front_fusion_qd" else 10.0
    details = [
        {
            "id": f"{seed}-{method}-{problem}",
            "strategy": "sample",
            "score": method_offset / 10.0,
            "ppa_metrics": {
                "area": 100.0 - method_offset,
                "power": 10.0 - method_offset / 20.0,
                "eff_clk_period": 5.0 - method_offset / 100.0,
            },
        }
    ]
    (problem_root / "generation_log.jsonl").write_text(
        json.dumps(
            {
                "generation": 0,
                "status_counts_this_generation": {"success": 10},
                "success_rates": {
                    "total_syntax": 1.0,
                    "total_functionality": 0.8,
                    "total_synthesis_ppa": 0.8,
                },
                "generation_ppa": {"best_score": method_offset / 10.0},
                "population_ppa_details": details,
            }
        )
        + "\n",
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
    if method == "t26_gated_near_front_fusion_qd":
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
        snapshot = {
            "qd_two_parent_gate": "near_front_descriptor",
            "success_parent_requests": 4,
            "two_parent_attempts": 2,
            "two_parent_fallbacks": 1,
            "two_parent_gate_attempts": 2,
            "two_parent_gate_accepts": 1,
            "two_parent_gate_rejects": 1,
            "generated_thought_count": 3,
        }
        (problem_root / "qd_metrics.json").write_text(
            json.dumps({"latest_snapshot": snapshot}),
            encoding="utf-8",
        )
        (problem_root / "archive_history.jsonl").write_text(
            json.dumps({"coverage": 0.1, "qd_score": 0.2, **snapshot}) + "\n",
            encoding="utf-8",
        )
