from __future__ import annotations

import json
from pathlib import Path

from revolution.qd.pareto_analysis import (
    analyze_problem_pareto,
    hypervolume,
    objective_metrics_for_reference,
)


def test_hypervolume_exact_in_2d() -> None:
    points = [(1.0, 3.0), (2.0, 2.0), (3.0, 1.0)]
    assert hypervolume(points) == 6.0


def test_hypervolume_exact_in_3d() -> None:
    points = [(1.0, 1.0, 1.0), (2.0, 1.0, 0.5)]
    assert hypervolume(points) == 1.5


def test_objective_metrics_switch_for_combinational_reference() -> None:
    assert objective_metrics_for_reference(
        {"area": 100.0, "power": 1.0, "eff_clk_period": 0.0}
    ) == ("area", "power")


def test_analyze_problem_pareto_loads_generation_log_and_deduplicates(tmp_path: Path) -> None:
    problem_dir = tmp_path / "Bench" / "Prob001"
    problem_dir.mkdir(parents=True, exist_ok=True)
    (problem_dir / "Prob001_summary.json").write_text(
        json.dumps(
            {
                "benchmark_name": "Bench",
                "problem_name": "Prob001",
                "ref_ppa_metric": {
                    "area": 100.0,
                    "power": 1.0,
                    "eff_clk_period": 1.0,
                },
            },
            indent=2,
        ),
        encoding="utf-8",
    )
    (problem_dir / "generation_log.jsonl").write_text(
        "\n".join(
            [
                json.dumps(
                    {
                        "generation": 0,
                        "population_ppa_details": [
                            {
                                "id": "cand_a",
                                "strategy": "seed",
                                "score": 0.1,
                                "ppa_metrics": {
                                    "area": 90.0,
                                    "power": 0.9,
                                    "eff_clk_period": 0.95,
                                    "report_path": "/tmp/r1.rpt",
                                },
                            },
                            {
                                "id": "cand_a_dup",
                                "strategy": "seed",
                                "score": 0.05,
                                "ppa_metrics": {
                                    "area": 92.0,
                                    "power": 0.92,
                                    "eff_clk_period": 0.97,
                                    "report_path": "/tmp/r1.rpt",
                                },
                            },
                        ],
                    }
                ),
                json.dumps(
                    {
                        "generation": 1,
                        "population_ppa_details": [
                            {
                                "id": "cand_b",
                                "strategy": "mutate",
                                "score": 0.2,
                                "ppa_metrics": {
                                    "area": 80.0,
                                    "power": 1.0,
                                    "eff_clk_period": 1.0,
                                    "report_path": "/tmp/r2.rpt",
                                },
                            },
                            {
                                "id": "cand_c",
                                "strategy": "mutate",
                                "score": 0.2,
                                "ppa_metrics": {
                                    "area": 100.0,
                                    "power": 0.8,
                                    "eff_clk_period": 0.9,
                                    "report_path": "/tmp/r3.rpt",
                                },
                            },
                        ],
                    }
                ),
            ]
        )
        + "\n",
        encoding="utf-8",
    )

    metrics = analyze_problem_pareto(problem_dir)

    assert metrics.objective_metrics == ("area", "power", "eff_clk_period")
    assert metrics.candidate_count == 3
    assert metrics.reference_beating_count == 3
    assert metrics.pareto_point_count >= 2
    assert metrics.hypervolume > 0.0
