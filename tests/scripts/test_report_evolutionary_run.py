from __future__ import annotations

import json
import os
import subprocess
from pathlib import Path

import yaml


def _write_problem_summary(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(
            {
                "benchmark_name": "RTLLM",
                "problem_name": "Prob001",
                "success_rates": {
                    "total_functionality": 0.8,
                    "total_synthesis_ppa": 0.6,
                },
                "best_score": 0.25,
                "total_runtime_seconds": 42.0,
                "total_llm_api_calls": 7,
            }
        ),
        encoding="utf-8",
    )


def _write_generation_log(path: Path) -> None:
    path.write_text(
        json.dumps(
            {
                "generation": 0,
                "success_rates": {
                    "total_functionality": 0.8,
                    "total_synthesis_ppa": 0.6,
                },
                "generation_ppa": {
                    "best_score": 0.25,
                    "average_score": 0.2,
                },
                "diff_stats": {"success_rate": 0.5},
                "status_counts_this_generation": {"success": 3},
                "strategy_counts_this_generation": {"M-I": 3},
            }
        )
        + "\n",
        encoding="utf-8",
    )


def _write_archive_history(path: Path) -> None:
    path.write_text(
        json.dumps(
            {
                "generation": 0,
                "coverage": 0.4,
                "qd_score": 1.2,
                "best_quality": 0.25,
                "new_filled_cells": 2,
                "replaced_cells": 1,
            }
        )
        + "\n",
        encoding="utf-8",
    )


def test_report_evolutionary_run_finds_nested_problem_roots(tmp_path: Path) -> None:
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_evolutionary_run.py"
    subset_config = tmp_path / "subset.yaml"
    subset_config.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "selected_problems": [{"benchmark": "RTLLM", "problem": "Prob001"}],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )

    backend_root = tmp_path / "cvt_theory_grounded"
    problem_root = backend_root / "_project_model_name" / "RTLLM" / "Prob001"
    _write_problem_summary(problem_root / "Prob001_summary.json")
    _write_generation_log(problem_root / "generation_log.jsonl")
    _write_archive_history(problem_root / "archive_history.jsonl")

    output_dir = tmp_path / "analysis"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(subset_config),
            "--backend-run",
            f"cvt_theory_grounded={backend_root}",
            "--output-dir",
            str(output_dir),
        ],
        cwd=repo_root,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 0, result.stderr

    payload = json.loads(
        (output_dir / "cvt_theory_grounded" / "summary.json").read_text(
            encoding="utf-8"
        )
    )
    summary = payload["summary"]

    assert summary["problem_count"] == 1
    assert summary["has_qd_archive"] is True
    assert summary["best_score_mean"] == 0.25
    assert summary["total_llm_api_calls"] == 7
    assert payload["generation_rows"][0]["problem_count"] == 1
