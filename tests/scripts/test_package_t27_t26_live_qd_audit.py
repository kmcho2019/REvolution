from __future__ import annotations

import csv
import json
from pathlib import Path

from scripts.package_t27_t26_live_qd_audit import main


def test_package_t27_t26_live_qd_audit(tmp_path: Path) -> None:
    t24_root = tmp_path / "t24"
    t25_root = tmp_path / "t25"
    t26_root = tmp_path / "t26"
    output_dir = tmp_path / "package"
    for problem in ("Prob045_alu", "Prob041_traffic_light", "Prob015_multi_pipe_8bit"):
        _write_problem(
            t24_root,
            "classic_revolution/seed_1001/openai_gpt-oss-120b",
            problem,
            area_values=(90.0, 80.0),
        )
        _write_problem(
            t24_root,
            "landing_smooth_qd_manual_bd/seed_1001/openai_gpt-oss-120b",
            problem,
            area_values=(85.0, 75.0),
            archive=True,
        )
        _write_problem(
            t24_root,
            "random_descriptor_qd/seed_1001/openai_gpt-oss-120b",
            problem,
            area_values=(95.0, 70.0),
            archive=True,
        )
        _write_problem(
            t24_root,
            "sr_raw_pca_qd/seed_1001/openai_gpt-oss-120b",
            problem,
            area_values=(75.0, 65.0),
            archive=True,
        )
        _write_problem(
            t25_root,
            "guarded_sr_raw_pareto_qd/seed_1001/openai_gpt-oss-120b",
            problem,
            area_values=(88.0, 78.0),
            archive=True,
        )
        _write_problem(
            t26_root,
            "sr_raw_conservative_exploit_qd/seed_1001/openai_gpt-oss-120b",
            problem,
            area_values=(70.0, 60.0),
            archive=True,
        )

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

    problem_rows = list(csv.DictReader((output_dir / "tables" / "live_qd_problem_metrics.csv").open()))
    aggregate_rows = list(
        csv.DictReader((output_dir / "tables" / "live_qd_aggregate_metrics.csv").open())
    )
    t26 = next(row for row in aggregate_rows if row["method"] == "sr_raw_conservative_exploit_qd")
    classic = next(row for row in aggregate_rows if row["method"] == "classic_revolution")
    assert len(problem_rows) == 18
    assert float(t26["mean_global_ppa_hypervolume"]) > float(classic["mean_global_ppa_hypervolume"])
    assert t26["total_active_archive_members"] == "6.000000"
    assert (output_dir / "figures" / "live_qd_problem_metrics.png").read_bytes().startswith(
        b"\x89PNG"
    )
    assert (output_dir / "figures" / "live_qd_aggregate_metrics.png").read_bytes().startswith(
        b"\x89PNG"
    )


def _write_problem(
    root: Path,
    mode: str,
    problem: str,
    *,
    area_values: tuple[float, float],
    archive: bool = False,
) -> None:
    problem_root = root / mode / "RTLLM" / problem
    problem_root.mkdir(parents=True)
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
            "eff_clk_period": 0.0,
            "power": 10.0,
            "area": 100.0,
        },
        "final_population_ppa": {
            "best_score": 1.0,
            "best_metrics": {"area": area_values[1], "power": 8.0, "eff_clk_period": 0.0},
        },
    }
    (problem_root / f"{problem}_summary.json").write_text(json.dumps(summary), encoding="utf-8")
    generation_rows = [
        {
            "generation": index,
            "population_ppa_details": [
                {
                    "id": f"{problem}-{index}",
                    "strategy": "initial" if index == 0 else "M-E",
                    "score": 1.0,
                    "ppa_metrics": {
                        "area": area,
                        "power": 8.0 - index,
                        "eff_clk_period": 0.0,
                    },
                }
            ],
        }
        for index, area in enumerate(area_values)
    ]
    (problem_root / "generation_log.jsonl").write_text(
        "\n".join(json.dumps(row) for row in generation_rows) + "\n",
        encoding="utf-8",
    )
    if not archive:
        return
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
        "\n".join(
            [
                json.dumps({"generation": 0, "coverage": 0.0, "qd_score": 0.0}),
                json.dumps({"generation": 1, "coverage": 0.125, "qd_score": 1.5}),
            ]
        )
        + "\n",
        encoding="utf-8",
    )
