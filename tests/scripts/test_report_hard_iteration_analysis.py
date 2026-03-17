import json
import os
import subprocess
from pathlib import Path

import yaml


def _write_summary(
    path: Path,
    *,
    benchmark: str,
    problem: str,
    functionality: float,
    synthesis: float,
    best_score: float,
    runtime_seconds: float,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(
            {
                "benchmark_name": benchmark,
                "problem_name": problem,
                "success_rates": {
                    "total_functionality": functionality,
                    "total_synthesis_ppa": synthesis,
                },
                "best_score": best_score,
                "total_runtime_seconds": runtime_seconds,
            }
        ),
        encoding="utf-8",
    )


def _write_archive_summary(
    path: Path,
    *,
    archive_type: str,
    coverage: float,
    qd_score: float,
    best_quality: float,
) -> None:
    path.write_text(
        json.dumps(
            {
                "archive_type": archive_type,
                "coverage": coverage,
                "qd_score": qd_score,
                "best_quality": best_quality,
            }
        ),
        encoding="utf-8",
    )


def test_report_hard_iteration_analysis_generates_report_and_summary(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_hard_iteration_analysis.py"
    config_path = tmp_path / "hard_iteration_subset.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "selected_problems": [
                    {"benchmark": "RTLLM", "problem": "Prob045_alu"},
                    {"benchmark": "VerilogEval-Spec-to-RTL", "problem": "Prob153_gshare"},
                ],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )

    classic_root = tmp_path / "classic"
    qd_score_root = tmp_path / "cvt_struct"
    qd_archive_root = tmp_path / "cvt_size_control"

    _write_summary(
        classic_root / "RTLLM" / "Prob045_alu" / "Prob045_alu_summary.json",
        benchmark="RTLLM",
        problem="Prob045_alu",
        functionality=0.5,
        synthesis=0.5,
        best_score=0.12,
        runtime_seconds=10.0,
    )
    _write_summary(
        classic_root
        / "VerilogEval-Spec-to-RTL"
        / "Prob153_gshare"
        / "Prob153_gshare_summary.json",
        benchmark="VerilogEval-Spec-to-RTL",
        problem="Prob153_gshare",
        functionality=0.4,
        synthesis=0.0,
        best_score=0.0,
        runtime_seconds=8.0,
    )

    _write_summary(
        qd_score_root / "RTLLM" / "Prob045_alu" / "Prob045_alu_summary.json",
        benchmark="RTLLM",
        problem="Prob045_alu",
        functionality=0.7,
        synthesis=0.7,
        best_score=0.22,
        runtime_seconds=14.0,
    )
    _write_archive_summary(
        qd_score_root / "RTLLM" / "Prob045_alu" / "archive_summary.json",
        archive_type="cvt",
        coverage=0.25,
        qd_score=1.1,
        best_quality=0.8,
    )
    _write_summary(
        qd_score_root
        / "VerilogEval-Spec-to-RTL"
        / "Prob153_gshare"
        / "Prob153_gshare_summary.json",
        benchmark="VerilogEval-Spec-to-RTL",
        problem="Prob153_gshare",
        functionality=0.6,
        synthesis=0.6,
        best_score=0.18,
        runtime_seconds=16.0,
    )
    _write_archive_summary(
        qd_score_root
        / "VerilogEval-Spec-to-RTL"
        / "Prob153_gshare"
        / "archive_summary.json",
        archive_type="cvt",
        coverage=0.30,
        qd_score=1.2,
        best_quality=0.85,
    )

    _write_summary(
        qd_archive_root / "RTLLM" / "Prob045_alu" / "Prob045_alu_summary.json",
        benchmark="RTLLM",
        problem="Prob045_alu",
        functionality=0.6,
        synthesis=0.6,
        best_score=0.18,
        runtime_seconds=15.0,
    )
    _write_archive_summary(
        qd_archive_root / "RTLLM" / "Prob045_alu" / "archive_summary.json",
        archive_type="cvt",
        coverage=0.45,
        qd_score=1.3,
        best_quality=0.75,
    )
    _write_summary(
        qd_archive_root
        / "VerilogEval-Spec-to-RTL"
        / "Prob153_gshare"
        / "Prob153_gshare_summary.json",
        benchmark="VerilogEval-Spec-to-RTL",
        problem="Prob153_gshare",
        functionality=0.5,
        synthesis=0.5,
        best_score=0.14,
        runtime_seconds=17.0,
    )
    _write_archive_summary(
        qd_archive_root
        / "VerilogEval-Spec-to-RTL"
        / "Prob153_gshare"
        / "archive_summary.json",
        archive_type="cvt",
        coverage=0.50,
        qd_score=1.4,
        best_quality=0.7,
    )

    output_dir = tmp_path / "analysis"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(config_path),
            "--backend_run",
            f"classic={classic_root}",
            "--backend_run",
            f"cvt_struct={qd_score_root}",
            "--backend_run",
            f"cvt_size_control={qd_archive_root}",
            "--output-dir",
            str(output_dir),
        ],
        cwd=repo_root,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    report = (output_dir / "report.md").read_text(encoding="utf-8")
    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))

    assert "`cvt_struct`" in report
    assert "`cvt_size_control`" in report
    assert summary["recommendations"]["overall"] == "cvt_struct"
    assert summary["recommendations"]["score_qd"] == "cvt_struct"
    assert summary["recommendations"]["archive_qd"] == "cvt_size_control"


def test_report_hard_iteration_analysis_handles_four_backends_with_partial_results(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_hard_iteration_analysis.py"
    config_path = tmp_path / "hard_iteration_subset.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "selected_problems": [
                    {"benchmark": "RTLLM", "problem": "Prob045_alu"},
                    {"benchmark": "VerilogEval-Spec-to-RTL", "problem": "Prob153_gshare"},
                ],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )

    classic_root = tmp_path / "classic"
    grid_root = tmp_path / "grid_struct"
    cvt_struct_root = tmp_path / "cvt_struct"
    cvt_size_root = tmp_path / "cvt_size_control"

    _write_summary(
        classic_root / "RTLLM" / "Prob045_alu" / "Prob045_alu_summary.json",
        benchmark="RTLLM",
        problem="Prob045_alu",
        functionality=0.4,
        synthesis=0.4,
        best_score=0.10,
        runtime_seconds=10.0,
    )
    _write_summary(
        classic_root / "VerilogEval-Spec-to-RTL" / "Prob153_gshare" / "Prob153_gshare_summary.json",
        benchmark="VerilogEval-Spec-to-RTL",
        problem="Prob153_gshare",
        functionality=0.3,
        synthesis=0.0,
        best_score=0.0,
        runtime_seconds=8.0,
    )

    _write_summary(
        grid_root / "RTLLM" / "Prob045_alu" / "Prob045_alu_summary.json",
        benchmark="RTLLM",
        problem="Prob045_alu",
        functionality=0.5,
        synthesis=0.5,
        best_score=0.14,
        runtime_seconds=12.0,
    )
    _write_archive_summary(
        grid_root / "RTLLM" / "Prob045_alu" / "archive_summary.json",
        archive_type="grid",
        coverage=0.35,
        qd_score=1.0,
        best_quality=0.7,
    )

    _write_summary(
        cvt_struct_root / "RTLLM" / "Prob045_alu" / "Prob045_alu_summary.json",
        benchmark="RTLLM",
        problem="Prob045_alu",
        functionality=0.7,
        synthesis=0.7,
        best_score=0.25,
        runtime_seconds=14.0,
    )
    _write_archive_summary(
        cvt_struct_root / "RTLLM" / "Prob045_alu" / "archive_summary.json",
        archive_type="cvt",
        coverage=0.30,
        qd_score=1.1,
        best_quality=0.82,
    )
    _write_summary(
        cvt_struct_root / "VerilogEval-Spec-to-RTL" / "Prob153_gshare" / "Prob153_gshare_summary.json",
        benchmark="VerilogEval-Spec-to-RTL",
        problem="Prob153_gshare",
        functionality=0.6,
        synthesis=0.6,
        best_score=0.18,
        runtime_seconds=16.0,
    )
    _write_archive_summary(
        cvt_struct_root / "VerilogEval-Spec-to-RTL" / "Prob153_gshare" / "archive_summary.json",
        archive_type="cvt",
        coverage=0.32,
        qd_score=1.2,
        best_quality=0.84,
    )

    _write_summary(
        cvt_size_root / "RTLLM" / "Prob045_alu" / "Prob045_alu_summary.json",
        benchmark="RTLLM",
        problem="Prob045_alu",
        functionality=0.6,
        synthesis=0.6,
        best_score=0.18,
        runtime_seconds=15.0,
    )
    _write_archive_summary(
        cvt_size_root / "RTLLM" / "Prob045_alu" / "archive_summary.json",
        archive_type="cvt",
        coverage=0.45,
        qd_score=1.3,
        best_quality=0.75,
    )
    _write_summary(
        cvt_size_root / "VerilogEval-Spec-to-RTL" / "Prob153_gshare" / "Prob153_gshare_summary.json",
        benchmark="VerilogEval-Spec-to-RTL",
        problem="Prob153_gshare",
        functionality=0.5,
        synthesis=0.5,
        best_score=0.14,
        runtime_seconds=17.0,
    )
    _write_archive_summary(
        cvt_size_root / "VerilogEval-Spec-to-RTL" / "Prob153_gshare" / "archive_summary.json",
        archive_type="cvt",
        coverage=0.50,
        qd_score=1.4,
        best_quality=0.7,
    )

    output_dir = tmp_path / "analysis"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(config_path),
            "--backend_run",
            f"classic={classic_root}",
            "--backend_run",
            f"grid_struct={grid_root}",
            "--backend_run",
            f"cvt_struct={cvt_struct_root}",
            "--backend_run",
            f"cvt_size_control={cvt_size_root}",
            "--output-dir",
            str(output_dir),
        ],
        cwd=repo_root,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    report = (output_dir / "report.md").read_text(encoding="utf-8")
    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))

    assert "`grid_struct`" in report
    assert len(summary["aggregates"]) == 4
    aggregates = {entry["backend"]: entry for entry in summary["aggregates"]}
    assert aggregates["grid_struct"]["problem_count"] == 2
    assert aggregates["grid_struct"]["solved_problem_count"] == 1
    assert summary["recommendations"]["overall"] == "cvt_struct"
    assert summary["recommendations"]["score_qd"] == "cvt_struct"
    assert summary["recommendations"]["archive_qd"] == "cvt_size_control"
