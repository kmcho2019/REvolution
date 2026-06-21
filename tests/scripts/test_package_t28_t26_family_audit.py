from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_t28_t26_family_audit import main


def test_package_t28_t26_family_audit(tmp_path: Path) -> None:
    t24_root = tmp_path / "t24"
    t25_root = tmp_path / "t25"
    t26_root = tmp_path / "t26"
    output_dir = tmp_path / "package"
    methods = (
        (t24_root, "classic_revolution/seed_1001/openai_gpt-oss-120b", ("AND2_X1", "AND2_X1")),
        (
            t24_root,
            "landing_smooth_qd_manual_bd/seed_1001/openai_gpt-oss-120b",
            ("OR2_X1", "OR2_X1"),
        ),
        (t24_root, "random_descriptor_qd/seed_1001/openai_gpt-oss-120b", ("INV_X1", "INV_X1")),
        (t24_root, "sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b", ("NAND2_X1", "NOR2_X1")),
        (
            t25_root,
            "guarded_sr_raw_pareto_qd/seed_1001/openai_gpt-oss-120b",
            ("BUF_X1", "BUF_X2"),
        ),
        (
            t26_root,
            "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b",
            ("XOR2_X1", "XNOR2_X1"),
        ),
    )
    for problem in ("Prob045_alu", "Prob041_traffic_light", "Prob015_multi_pipe_8bit"):
        for root, mode, cell_types in methods:
            _write_problem(root, mode, problem, cell_types)

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

    aggregate_rows = list(
        csv.DictReader((output_dir / "tables" / "family_aggregate_metrics.csv").open())
    )
    classic = next(row for row in aggregate_rows if row["method"] == "classic_revolution")
    t26 = next(row for row in aggregate_rows if row["method"] == "sr_raw_conservative_exploit_qd")
    assert classic["front_unique_family_count"] == "3"
    assert t26["front_unique_family_count"] == "6"
    assert t26["front_family_ratio"] == "1.000000"
    assert (output_dir / "figures" / "family_aggregate_counts.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "figures" / "family_problem_front_counts.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "figures" / "ppa_pareto_fronts_area_power.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "figures" / "ppa_pareto_fronts_improvement.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "visualizations" / "qd_ppa_viewer" / "index.html").is_file()
    assert (
        output_dir / "visualizations" / "qd_ppa_viewer_source" / "final_analysis"
        / "ppa_distribution" / "data" / "ppa_candidates.csv"
    ).is_file()


def _write_problem(
    root: Path,
    mode: str,
    problem: str,
    cell_types: tuple[str, str],
) -> None:
    problem_root = root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
    summary = {
        "problem_name": problem,
        "benchmark_name": "RTLLM",
        "ref_ppa_metric": {
            "tns": 0.0,
            "wns": 0.0,
            "eff_clk_period": 0.0,
            "power": 10.0,
            "area": 100.0,
        },
    }
    (problem_root / f"{problem}_summary.json").write_text(json.dumps(summary), encoding="utf-8")
    generated = []
    details = []
    for index, cell_type in enumerate(cell_types):
        candidate_id = f"{problem}-{index}"
        candidate_dir = problem_root / "Gen0" / f"{problem}_sample{index + 1}_initial"
        candidate_dir.mkdir(parents=True)
        code_path = candidate_dir / "code.sv"
        code_path.write_text(f"module {problem}; assign y = 1'b{index}; endmodule\n", encoding="utf-8")
        (candidate_dir / "code.syn.v").write_text(
            "\n".join(
                [
                    f"module {problem}();",
                    f"  {cell_type} _{index}_ (",
                    "  );",
                    "endmodule",
                    "",
                ]
            ),
            encoding="utf-8",
        )
        if mode == "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b":
            (candidate_dir / "qd_archive_event.json").write_text(
                json.dumps(
                    {
                        "candidate_id": candidate_id,
                        "generation": 0,
                        "strategy": "initial",
                        "quality_score": 1.0,
                        "descriptor_values": {
                            "sr_pca_0": float(index),
                            "sr_pca_1": 0.0,
                            "sr_pca_2": float(index + 1),
                        },
                        "cell_id": f"{index},0,{index}",
                    }
                ),
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
                    "area": 90.0 - index,
                    "power": 9.0 + index,
                    "eff_clk_period": 0.0,
                },
            }
        )
    row = {
        "generation": 0,
        "generated_candidates": generated,
        "population_ppa_details": details,
    }
    (problem_root / "generation_log.jsonl").write_text(json.dumps(row) + "\n", encoding="utf-8")
    if mode == "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b":
        _write_archive_files(problem_root, problem, [detail["id"] for detail in details])


def _write_archive_files(problem_root: Path, problem: str, candidate_ids: list[str]) -> None:
    (problem_root / "archive_space.json").write_text(
        json.dumps(
            {
                "archive_type": "grid_quantile",
                "initialized": True,
                "num_cells": 4,
                "axes": [
                    {"name": "sr_pca_0", "effective_bins": 2, "quantile_boundaries": [0.5]},
                    {"name": "sr_pca_1", "effective_bins": 1, "quantile_boundaries": []},
                    {"name": "sr_pca_2", "effective_bins": 2, "quantile_boundaries": [1.5]},
                ],
                "effective_shape": [2, 1, 2],
            }
        ),
        encoding="utf-8",
    )
    rows = [
        "cell_id,member_index,front_size,pareto_rank,candidate_id,quality_score,generation,"
        "strategy,code_file_path,g_P,g_A,g_T,descriptors_json,parent_ids_json"
    ]
    for index, candidate_id in enumerate(candidate_ids):
        code_path = problem_root / "Gen0" / f"{problem}_sample{index + 1}_initial" / "code.sv"
        rows.append(
            f'"{index},0,{index}",0,1,1,{candidate_id},1.0,0,initial,'
            f'{code_path},0.1,0.1,0.0,"[{float(index)}, 0.0, {float(index + 1)}]",[]'
        )
    (problem_root / "archive_cells.csv").write_text("\n".join(rows) + "\n", encoding="utf-8")
