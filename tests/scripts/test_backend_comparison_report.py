import json
import subprocess
import sys
from pathlib import Path


def _write_summary(root: Path, benchmark: str, problem: str, payload: dict) -> None:
    problem_dir = root / "model-x" / benchmark / problem
    problem_dir.mkdir(parents=True, exist_ok=True)
    (problem_dir / f"{problem}_summary.json").write_text(
        json.dumps(payload, indent=2),
        encoding="utf-8",
    )


def test_backend_comparison_report_generates_markdown(tmp_path):
    rev_root = tmp_path / "revolution"
    fs_root = tmp_path / "funsearch"
    _write_summary(
        rev_root,
        "Bench",
        "Prob001",
        {
            "benchmark_name": "Bench",
            "problem_name": "Prob001",
            "accumulated_success_rates": {"functionality": 1.0, "synthesis_ppa": 0.5},
            "final_population_ppa": {"best_score": 0.1},
            "total_runtime_seconds": 2.0,
            "total_llm_api_calls": 3,
        },
    )
    _write_summary(
        fs_root,
        "Bench",
        "Prob001",
        {
            "benchmark_name": "Bench",
            "problem_name": "Prob001",
            "stage_success_rates": {"functionality": 1.0, "synthesis": 1.0},
            "final_population_ppa": {"best_score": 0.2},
            "total_runtime_seconds": 1.0,
            "total_llm_api_calls": 2,
        },
    )

    output_path = tmp_path / "comparison.md"
    cmd = [
        sys.executable,
        "scripts/backend_comparison_report.py",
        "--backend_run",
        f"revolution={rev_root}",
        "--backend_run",
        f"funsearch={fs_root}",
        "--output",
        str(output_path),
    ]
    subprocess.run(cmd, check=True, cwd=Path(__file__).resolve().parents[2])
    text = output_path.read_text(encoding="utf-8")
    assert "`revolution`" in text
    assert "`funsearch`" in text
    assert "Prob001" in text
