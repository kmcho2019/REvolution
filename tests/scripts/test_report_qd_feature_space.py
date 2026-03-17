import csv
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
                "accumulated_success_rates": {
                    "functionality": functionality,
                    "synthesis_ppa": synthesis,
                },
                "final_population_ppa": {"best_score": best_score},
                "total_runtime_seconds": runtime_seconds,
            }
        ),
        encoding="utf-8",
    )


def _write_archive_summary(path: Path, *, archive_type: str, coverage: float, qd_score: float, best_quality: float) -> None:
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


def _write_archive_cells(path: Path, candidate_ids: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = ["cell_id,candidate_id,quality_score,generation,strategy,code_file_path,g_P,g_A,g_T,descriptors_json,parent_ids_json"]
    for index, candidate_id in enumerate(candidate_ids):
        lines.append(
            f"{index},{candidate_id},0.1,0,seed,/tmp/{candidate_id}.v,0.1,0.2,0.3,[],[]"
        )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _write_qd_event(
    path: Path,
    *,
    candidate_id: str,
    benchmark: str,
    problem: str,
    generation: int,
    quality_score: float,
    seq_ratio: float,
    mux_ratio: float,
    cell_count_log: float,
    assign_count: float,
    if_count: float,
    wire_count_log_est: float,
    active_signal_ratio_est: float,
    ctrl_depth_est: float,
    g_p: float,
    g_a: float,
    g_t: float,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "candidate_id": candidate_id,
        "generation": generation,
        "strategy": "M-I",
        "origin_pool": "success_pool",
        "generated_mode": "whole",
        "archive_type": "grid",
        "archive_axes": ["seq_ratio", "mux_ratio", "cell_count_log"],
        "quality_score": quality_score,
        "score_components": {
            "g_P": g_p,
            "g_A": g_a,
            "g_T": g_t,
        },
        "structural_metrics": {
            "seq_ratio": seq_ratio,
            "mux_ratio": mux_ratio,
            "cell_count_log": cell_count_log,
        },
        "rtl_metrics": {
            "assign_count": assign_count,
            "if_count": if_count,
            "wire_count_log_est": wire_count_log_est,
            "ctrl_depth_est": ctrl_depth_est,
            "collapsed_feature": 0.0,
        },
        "dynamic_metrics": {
            "active_signal_ratio_est": active_signal_ratio_est,
        },
        "physical_metrics": {},
        "descriptor_values": {
            "seq_ratio": seq_ratio,
            "mux_ratio": mux_ratio,
            "cell_count_log": cell_count_log,
        },
        "cell_id": f"{generation},0",
        "decision": "inserted",
        "inserted": True,
        "replaced": False,
        "current_cell_elite": {
            "code_file_path": f"/tmp/{benchmark}/{problem}/{candidate_id}/code.v"
        },
    }
    path.write_text(json.dumps(payload), encoding="utf-8")


def test_report_qd_feature_space_generates_feature_outputs(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_qd_feature_space.py"
    config_path = tmp_path / "hard_iteration_subset.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "selected_problems": [
                    {"benchmark": "RTLLM", "problem": "Prob001_accu"},
                    {"benchmark": "VerilogEval-Spec-to-RTL", "problem": "Prob153_gshare"},
                ],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )

    classic_root = tmp_path / "classic"
    qd_root = tmp_path / "grid_struct"

    _write_summary(
        classic_root / "RTLLM" / "Prob001_accu" / "Prob001_accu_summary.json",
        benchmark="RTLLM",
        problem="Prob001_accu",
        functionality=0.5,
        synthesis=0.5,
        best_score=0.1,
        runtime_seconds=10.0,
    )
    _write_summary(
        classic_root / "VerilogEval-Spec-to-RTL" / "Prob153_gshare" / "Prob153_gshare_summary.json",
        benchmark="VerilogEval-Spec-to-RTL",
        problem="Prob153_gshare",
        functionality=0.4,
        synthesis=0.4,
        best_score=0.2,
        runtime_seconds=12.0,
    )

    elite_ids = []
    counter = 0
    for benchmark, problem in [("RTLLM", "Prob001_accu"), ("VerilogEval-Spec-to-RTL", "Prob153_gshare")]:
        problem_root = qd_root / benchmark / problem
        _write_summary(
            problem_root / f"{problem}_summary.json",
            benchmark=benchmark,
            problem=problem,
            functionality=0.7,
            synthesis=0.6,
            best_score=0.35,
            runtime_seconds=15.0,
        )
        _write_archive_summary(problem_root / "archive_summary.json", archive_type="grid", coverage=0.4, qd_score=1.5, best_quality=0.8)
        local_elites = []
        for local_index in range(4):
            candidate_id = f"cand_{counter}"
            local_elites.append(candidate_id)
            elite_ids.append(candidate_id)
            candidate_dir = problem_root / f"Gen{local_index}" / f"{problem}_sample{local_index + 1}_M-I"
            _write_qd_event(
                candidate_dir / "qd_archive_event.json",
                candidate_id=candidate_id,
                benchmark=benchmark,
                problem=problem,
                generation=local_index,
                quality_score=0.1 + 0.05 * counter,
                seq_ratio=0.1 + 0.03 * counter,
                mux_ratio=0.2 + 0.02 * counter,
                cell_count_log=5.0 + 0.2 * counter,
                assign_count=1.0 + counter,
                if_count=2.0 + (counter % 4),
                wire_count_log_est=4.0 + 0.1 * counter,
                active_signal_ratio_est=0.1 + 0.05 * counter,
                ctrl_depth_est=1.0 + (counter % 3),
                g_p=0.2 + 0.03 * counter,
                g_a=0.1 + 0.02 * counter,
                g_t=0.05 + 0.01 * counter,
            )
            counter += 1
        _write_archive_cells(problem_root / "archive_cells.csv", local_elites[:2])

    output_dir = tmp_path / "analysis"
    env = os.environ.copy()
    env["MPLBACKEND"] = "Agg"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(config_path),
            "--backend_run",
            f"classic={classic_root}",
            "--backend_run",
            f"grid_struct={qd_root}",
            "--output-dir",
            str(output_dir),
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    report = (output_dir / "report.md").read_text(encoding="utf-8")
    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))
    recommended = json.loads((output_dir / "recommended_profile.json").read_text(encoding="utf-8"))

    assert "grid_struct" in report
    assert "collapsed_feature" in json.dumps(summary)
    assert len(recommended["selected_non_target_features"]) == 7
    assert "collapsed_feature" not in recommended["selected_non_target_features"]
    assert recommended["sequential_axes"][-3:] == ["g_P", "g_A", "g_T"]
    assert recommended["combinational_axes"][-2:] == ["g_P", "g_A"]
    assert (output_dir / "qd_successful_candidates.csv").is_file()
    assert (output_dir / "backends" / "grid_struct" / "feature_histograms.png").is_file()
    assert (output_dir / "backends" / "grid_struct" / "pca_fitness.png").is_file()
    assert (output_dir / "backends" / "grid_struct" / "tsne_fitness.png").is_file()
    assert (output_dir / "regression" / "quality_score_coefficients.csv").is_file()


def test_report_qd_feature_space_handles_classic_only_inputs(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_qd_feature_space.py"
    config_path = tmp_path / "hard_iteration_subset.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "selected_problems": [
                    {"benchmark": "RTLLM", "problem": "Prob001_accu"},
                ],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )
    classic_root = tmp_path / "classic"
    _write_summary(
        classic_root / "RTLLM" / "Prob001_accu" / "Prob001_accu_summary.json",
        benchmark="RTLLM",
        problem="Prob001_accu",
        functionality=0.5,
        synthesis=0.5,
        best_score=0.1,
        runtime_seconds=10.0,
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
            "--output-dir",
            str(output_dir),
        ],
        cwd=repo_root,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    recommended = json.loads((output_dir / "recommended_profile.json").read_text(encoding="utf-8"))
    assert recommended["selected_non_target_features"] == []
    assert recommended["sequential_axes"] == ["g_P", "g_A", "g_T"]


def test_report_qd_feature_space_fails_for_missing_backend_root(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_qd_feature_space.py"
    config_path = tmp_path / "hard_iteration_subset.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "selected_problems": [
                    {"benchmark": "RTLLM", "problem": "Prob001_accu"},
                ],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )
    classic_root = tmp_path / "classic"
    _write_summary(
        classic_root / "RTLLM" / "Prob001_accu" / "Prob001_accu_summary.json",
        benchmark="RTLLM",
        problem="Prob001_accu",
        functionality=0.5,
        synthesis=0.5,
        best_score=0.0,
        runtime_seconds=10.0,
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
            f"grid_struct={tmp_path / 'missing_grid'}",
            "--output-dir",
            str(output_dir),
        ],
        cwd=repo_root,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode != 0
    assert "No selected problem summaries found" in result.stderr or "does not exist" in result.stderr


def test_report_qd_feature_space_ignores_partial_dirs_and_malformed_json(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "report_qd_feature_space.py"
    config_path = tmp_path / "hard_iteration_subset.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "selected_problems": [
                    {"benchmark": "RTLLM", "problem": "Prob001_accu"},
                ],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )
    qd_root = tmp_path / "grid_struct"
    problem_root = qd_root / "RTLLM" / "Prob001_accu"
    _write_summary(
        problem_root / "Prob001_accu_summary.json",
        benchmark="RTLLM",
        problem="Prob001_accu",
        functionality=0.7,
        synthesis=0.6,
        best_score=0.0,
        runtime_seconds=15.0,
    )
    _write_archive_summary(
        problem_root / "archive_summary.json",
        archive_type="grid",
        coverage=0.4,
        qd_score=1.5,
        best_quality=0.8,
    )
    _write_archive_cells(problem_root / "archive_cells.csv", ["good_cand"])
    _write_qd_event(
        problem_root / "Gen0" / "Prob001_accu_sample1_M-I" / "qd_archive_event.json",
        candidate_id="good_cand",
        benchmark="RTLLM",
        problem="Prob001_accu",
        generation=0,
        quality_score=0.25,
        seq_ratio=0.2,
        mux_ratio=0.3,
        cell_count_log=5.1,
        assign_count=2.0,
        if_count=3.0,
        wire_count_log_est=4.1,
        active_signal_ratio_est=0.2,
        ctrl_depth_est=2.0,
        g_p=0.1,
        g_a=0.2,
        g_t=0.0,
    )

    partial_root = qd_root / "RTLLM" / "Prob001_accu_partial_pre_resume_20260317"
    _write_summary(
        partial_root / "Prob001_accu_summary.json",
        benchmark="RTLLM",
        problem="Prob001_accu",
        functionality=0.1,
        synthesis=0.1,
        best_score=0.9,
        runtime_seconds=999.0,
    )
    (partial_root / "archive_summary.json").write_text("{bad json", encoding="utf-8")
    bad_event_dir = partial_root / "Gen0" / "Prob001_accu_sample2_M-I"
    bad_event_dir.mkdir(parents=True, exist_ok=True)
    (bad_event_dir / "qd_archive_event.json").write_text("{bad json", encoding="utf-8")

    output_dir = tmp_path / "analysis"
    env = os.environ.copy()
    env["MPLBACKEND"] = "Agg"
    result = subprocess.run(
        [
            str(Path(os.sys.executable)),
            str(script_path),
            "--subset-config",
            str(config_path),
            "--backend_run",
            f"grid_struct={qd_root}",
            "--output-dir",
            str(output_dir),
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    summary = json.loads((output_dir / "summary.json").read_text(encoding="utf-8"))
    backend_rows = list(csv.DictReader((output_dir / "backend_problem_metrics.csv").open("r", encoding="utf-8")))
    candidate_rows = list(csv.DictReader((output_dir / "qd_successful_candidates.csv").open("r", encoding="utf-8")))

    assert summary["backend_aggregates"][0]["best_score_mean"] == 0.0
    assert len(candidate_rows) == 1
    assert candidate_rows[0]["candidate_id"] == "good_cand"
    assert backend_rows[0]["best_score"] == "0.0"
    assert any("Skipped non-canonical problem summary" in warning for warning in summary["warnings"])
    assert any("Skipped malformed qd archive event" in warning for warning in summary["warnings"])
