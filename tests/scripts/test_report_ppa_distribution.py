from __future__ import annotations

import json
import os
import subprocess
from pathlib import Path

import yaml


def _write_subset_config(path: Path) -> None:
    path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "ppa_distribution_subset",
                "selected_problems": [{"benchmark": "RTLLM", "problem": "Prob001"}],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )


def _candidate_detail(candidate_id: str, area: float, power: float, period: float) -> dict:
    return {
        "id": candidate_id,
        "strategy": "mutate",
        "score": 0.1,
        "ppa_metrics": {
            "area": area,
            "power": power,
            "eff_clk_period": period,
            "report_path": f"/tmp/{candidate_id}.ppa",
        },
    }


def _write_problem(root: Path, *, backend: str, candidates: list[dict]) -> None:
    problem_root = root / "RTLLM" / "Prob001"
    problem_root.mkdir(parents=True, exist_ok=True)
    generation_payloads = [
        {"generation": index, "population_ppa_details": [candidate]}
        for index, candidate in enumerate(candidates)
    ]
    summary = {
        "benchmark_name": "RTLLM",
        "problem_name": "Prob001",
        "ref_ppa_metric": {"area": 100.0, "power": 1.0, "eff_clk_period": 1.0},
        "accumulated_success_rates": {"functionality": 1.0, "synthesis_ppa": 1.0},
        "final_population_ppa": {"best_score": 0.2},
        "final_population_ppa_details": candidates,
        "backend_details": {"search_mode": backend},
    }
    (problem_root / "Prob001_summary.json").write_text(
        json.dumps(summary, indent=2),
        encoding="utf-8",
    )
    (problem_root / "generation_log.jsonl").write_text(
        "\n".join(json.dumps(payload) for payload in generation_payloads) + "\n",
        encoding="utf-8",
    )


def test_report_ppa_distribution_generates_outputs(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_ppa_distribution.py"
    subset_config = tmp_path / "subset.yaml"
    _write_subset_config(subset_config)

    classic_root = tmp_path / "classic"
    qd_root = tmp_path / "cvt_struct"
    _write_problem(
        classic_root,
        backend="revolution",
        candidates=[
            _candidate_detail("classic_a", 95.0, 0.95, 0.96),
            _candidate_detail("classic_b", 93.0, 0.94, 0.95),
        ],
    )
    _write_problem(
        qd_root,
        backend="revolution_qd",
        candidates=[
            _candidate_detail("qd_a", 90.0, 0.92, 0.93),
            _candidate_detail("qd_b", 88.0, 0.89, 0.9),
        ],
    )

    output_dir = tmp_path / "ppa_distribution"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(subset_config),
            "--backend_run",
            f"classic={classic_root}",
            "--backend_run",
            f"cvt_struct={qd_root}",
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
    assert (output_dir / "data" / "ppa_candidates.csv").is_file()
    assert (output_dir / "data" / "reference_ppa_metrics.csv").is_file()
    assert (output_dir / "data" / "best_candidate_by_backend_problem.csv").is_file()
    assert (
        output_dir
        / "figures"
        / "all_backends"
        / "RTLLM"
        / "Prob001"
        / "absolute"
        / "power_vs_area.png"
    ).is_file()
    assert (
        output_dir
        / "figures"
        / "classic_vs"
        / "cvt_struct"
        / "RTLLM"
        / "Prob001"
        / "gain"
        / "area_vs_effective_clock_period.png"
    ).is_file()

    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))
    assert summary["candidate_count"] == 4
    assert summary["reference_problem_count"] == 1
    assert summary["best_backend_problem_count"] == 2
    assert summary["figure_count"] == 12
    report = (output_dir / "report.md").read_text(encoding="utf-8")
    assert "filled score contours" in report
    assert "projected Pareto-front lines" in report
