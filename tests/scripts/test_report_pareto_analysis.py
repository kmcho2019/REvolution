from __future__ import annotations

import csv
import json
import os
import subprocess
from pathlib import Path

import yaml


def _write_problem(
    root: Path,
    *,
    benchmark: str,
    problem: str,
    ref_ppa_metric: dict[str, float],
    generation_payloads: list[dict],
) -> None:
    problem_dir = root / benchmark / problem
    problem_dir.mkdir(parents=True, exist_ok=True)
    (problem_dir / f"{problem}_summary.json").write_text(
        json.dumps(
            {
                "benchmark_name": benchmark,
                "problem_name": problem,
                "ref_ppa_metric": ref_ppa_metric,
                "accumulated_success_rates": {"functionality": 1.0, "synthesis_ppa": 1.0},
                "final_population_ppa": {
                    "best_score": 0.2,
                    "best_metrics": {
                        "area": ref_ppa_metric["area"] * 0.9,
                        "power": ref_ppa_metric["power"] * 0.9,
                        "eff_clk_period": ref_ppa_metric["eff_clk_period"] * 0.9,
                    },
                },
                "final_population_ppa_details": [
                    detail
                    for payload in generation_payloads
                    for detail in payload.get("population_ppa_details", [])
                ],
            },
            indent=2,
        ),
        encoding="utf-8",
    )
    (problem_dir / "generation_log.jsonl").write_text(
        "\n".join(json.dumps(payload) for payload in generation_payloads) + "\n",
        encoding="utf-8",
    )


def _generation_payload(generation: int, candidates: list[tuple[str, float, float, float]]) -> dict:
    return {
        "generation": generation,
        "population_ppa_details": [
            {
                "id": candidate_id,
                "strategy": "mutate",
                "score": 0.1,
                "ppa_metrics": {
                    "area": area,
                    "power": power,
                    "eff_clk_period": period,
                    "report_path": f"/tmp/{candidate_id}.rpt",
                },
            }
            for candidate_id, area, power, period in candidates
        ],
    }


def test_report_pareto_analysis_generates_outputs(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_pareto_analysis.py"
    subset_config = tmp_path / "subset.yaml"
    subset_config.write_text(
        yaml.safe_dump(
            {
                "selected_problems": [
                    {"benchmark": "RTLLM", "problem": "Prob001"},
                    {"benchmark": "RTLLM", "problem": "Prob002"},
                ]
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )

    classic_root = tmp_path / "classic"
    cvt_root = tmp_path / "cvt_struct"
    ref = {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0}
    _write_problem(
        classic_root,
        benchmark="RTLLM",
        problem="Prob001",
        ref_ppa_metric=ref,
        generation_payloads=[
            _generation_payload(0, [("classic_a", 95.0, 0.95, 0.95)]),
            _generation_payload(1, [("classic_b", 92.0, 0.93, 0.94)]),
        ],
    )
    _write_problem(
        cvt_root,
        benchmark="RTLLM",
        problem="Prob001",
        ref_ppa_metric=ref,
        generation_payloads=[
            _generation_payload(0, [("cvt_a", 90.0, 0.92, 0.93)]),
            _generation_payload(1, [("cvt_b", 88.0, 0.89, 0.9)]),
        ],
    )
    _write_problem(
        classic_root,
        benchmark="RTLLM",
        problem="Prob002",
        ref_ppa_metric=ref,
        generation_payloads=[
            _generation_payload(0, [("classic_valid", 101.0, 1.01, 1.01)]),
        ],
    )
    _write_problem(
        cvt_root,
        benchmark="RTLLM",
        problem="Prob002",
        ref_ppa_metric=ref,
        generation_payloads=[
            _generation_payload(0, [("cvt_valid", 102.0, 1.02, 1.02)]),
        ],
    )

    output_dir = tmp_path / "pareto_analysis"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(subset_config),
            "--backend_run",
            f"classic={classic_root}",
            "--backend_run",
            f"cvt_struct={cvt_root}",
            "--output-dir",
            str(output_dir),
        ],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 0, result.stderr
    assert (output_dir / "report.md").is_file()
    assert (output_dir / "summary.json").is_file()
    assert (output_dir / "backend_problem_metrics.csv").is_file()
    assert (output_dir / "aggregate_backend_metrics.csv").is_file()
    assert (output_dir / "problems" / "RTLLM" / "Prob001" / "pairwise_fronts.png").is_file()
    assert (output_dir / "problems" / "RTLLM" / "Prob001" / "front_3d.png").is_file()

    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))
    assert summary["overall_multi_objective_winner"] == "cvt_struct"
    rows = list(
        csv.DictReader(
            (output_dir / "aggregate_backend_metrics.csv").open(encoding="utf-8")
        )
    )
    classic = next(
        row for row in rows if row["backend"] == "classic" and row["benchmark"] == "ALL"
    )
    assert classic["pareto_valid_problem_count"] == "2"
    assert classic["reference_beating_problem_count"] == "1"
    assert classic["positive_hv_problem_count"] == "1"
