import os
import subprocess
from pathlib import Path

import yaml


def test_run_hard_iteration_qd_script_dry_run_prints_expected_matrix(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "run_hard_iteration_qd_vllm.sh"
    config_path = tmp_path / "hard_iteration_subset.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "model": {
                    "api_backend": "vllm",
                    "model_name": "stub-model",
                    "vllm_host": "fake-host",
                    "vllm_port": 9999,
                },
                "benchmarks": {
                    "RTLLM": {"problems": ["Prob001_accu"]},
                    "VerilogEval-Spec-to-RTL": {"problems": ["Prob153_gshare"]},
                },
                "matrix_defaults": {
                    "population_size": 20,
                    "num_generations": 5,
                    "evaluation_mode": "search_accelerated",
                    "accelerated_synthesis_top_k": 1,
                    "total_worker_slots": 2,
                    "max_active_problems": 2,
                    "max_workers_per_problem": 2,
                    "temperature": 1.0,
                    "top_p": 1.0,
                    "max_tokens": 128000,
                    "diff_max_tokens": 128000,
                    "qd_num_cells": 16,
                    "qd_cvt_warmup_successes": 4,
                    "seed": 42,
                },
                "modes": {
                    "classic": {"search_mode": "revolution"},
                    "grid_struct": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "grid",
                        "qd_descriptor_profile": "implemented_structural_compact_3d",
                    },
                    "cvt_struct": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "implemented_structural_fixed_5d",
                    },
                    "cvt_size_control": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "size_control_3d",
                    },
                    "cvt_theory_grounded": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "theory_grounded_full_20d",
                    },
                },
                "selected_problems": [
                    {"benchmark": "RTLLM", "problem": "Prob001_accu"},
                    {"benchmark": "VerilogEval-Spec-to-RTL", "problem": "Prob153_gshare"},
                ],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )

    fake_bin = tmp_path / "bin"
    fake_bin.mkdir()
    fake_curl = fake_bin / "curl"
    fake_curl.write_text(
        "#!/usr/bin/env bash\n"
        "printf '%s' '{\"data\":[{\"id\":\"stub-model\",\"max_model_len\":131072}]}'\n",
        encoding="utf-8",
    )
    fake_curl.chmod(0o755)

    env = os.environ.copy()
    env["PATH"] = f"{fake_bin}:{env['PATH']}"
    env["HARD_SUBSET_SAVE_PATH"] = str(tmp_path / "runs")
    env["PYTHON_BIN"] = str(Path(os.sys.executable))
    env["VLLM_HOST"] = "wrong-host"
    env["VLLM_PORT"] = "1111"

    result = subprocess.run(
        ["bash", str(script_path), "--config", str(config_path), "--mode", "matrix", "--dry-run"],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    normalized = " ".join(result.stdout.split())
    assert "Detected model: stub-model" in result.stdout
    assert "[classic] command:" in result.stdout
    assert "[grid_struct] command:" in result.stdout
    assert "[cvt_struct] command:" in result.stdout
    assert "[cvt_size_control] command:" in result.stdout
    assert "[cvt_theory_grounded] command:" not in result.stdout
    assert "[report] command:" in result.stdout
    assert "--benchmarks RTLLM VerilogEval-Spec-to-RTL" in normalized
    assert "--problems Prob001_accu Prob153_gshare" in normalized
    assert "--vllm_host fake-host" in normalized
    assert "--vllm_port 9999" in normalized
    assert "--qd_descriptor_profile implemented_structural_compact_3d" in normalized
    assert "--qd_descriptor_profile implemented_structural_fixed_5d" in normalized
    assert "--qd_descriptor_profile size_control_3d" in normalized
    assert "--qd_num_cells 16" in normalized
    assert "--qd_cvt_warmup_successes 4" in normalized
    assert "--population_size 20" in normalized
    assert "--num_generations 5" in normalized
    assert "--total_worker_slots 2" in normalized
    assert "--max_active_problems 2" in normalized
    assert "--max_workers_per_problem 2" in normalized
    assert "--max_tokens 128000" in normalized
    assert "--diff_max_tokens 128000" in normalized
    run_dirs = [path for path in (tmp_path / "runs").iterdir() if path.is_dir()]
    assert len(run_dirs) == 1
    run_dir = run_dirs[0]
    assert (run_dir / "hard_iteration_manifest.txt").is_file()
    manifest = (run_dir / "hard_iteration_manifest.txt").read_text(encoding="utf-8")
    assert "subset_name=hard_iteration_subset_v1" in manifest
    assert "mode=matrix" in manifest
    assert "total_worker_slots=2" in manifest
    assert "qd_num_cells=16" in manifest
    assert "qd_cvt_warmup_successes=4" in manifest
    assert f"--output {run_dir / 'hard_iteration_backend_comparison.md'}" in normalized
    assert f"--backend_run classic={run_dir / 'classic'}" in normalized
    assert f"--backend_run grid_struct={run_dir / 'grid_struct'}" in normalized
    assert f"--backend_run cvt_struct={run_dir / 'cvt_struct'}" in normalized
    assert f"--backend_run cvt_size_control={run_dir / 'cvt_size_control'}" in normalized
    assert "Dry run enabled; commands were not executed." in result.stdout


def test_run_hard_iteration_qd_script_supports_theory_mode(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "run_hard_iteration_qd_vllm.sh"
    config_path = tmp_path / "hard_iteration_subset.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_v1",
                "model": {
                    "api_backend": "vllm",
                    "model_name": "stub-model",
                    "vllm_host": "fake-host",
                    "vllm_port": 9999,
                },
                "benchmarks": {
                    "RTLLM": {"problems": ["Prob001_accu"]},
                },
                "matrix_defaults": {
                    "population_size": 20,
                    "num_generations": 5,
                    "evaluation_mode": "search_accelerated",
                    "accelerated_synthesis_top_k": 1,
                    "total_worker_slots": 20,
                    "max_active_problems": 20,
                    "max_workers_per_problem": 20,
                    "temperature": 1.0,
                    "top_p": 1.0,
                    "max_tokens": 128000,
                    "diff_max_tokens": 128000,
                    "qd_num_cells": 16,
                    "qd_cvt_warmup_successes": 16,
                    "seed": 42,
                },
                "modes": {
                    "classic": {"search_mode": "revolution"},
                    "cvt_theory_grounded": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "theory_grounded_full_20d",
                    },
                },
                "selected_problems": [
                    {"benchmark": "RTLLM", "problem": "Prob001_accu"},
                ],
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )

    fake_bin = tmp_path / "bin"
    fake_bin.mkdir()
    fake_curl = fake_bin / "curl"
    fake_curl.write_text(
        "#!/usr/bin/env bash\n"
        "printf '%s' '{\"data\":[{\"id\":\"stub-model\",\"max_model_len\":131072}]}'\n",
        encoding="utf-8",
    )
    fake_curl.chmod(0o755)

    env = os.environ.copy()
    env["PATH"] = f"{fake_bin}:{env['PATH']}"
    env["HARD_SUBSET_SAVE_PATH"] = str(tmp_path / "runs")
    env["PYTHON_BIN"] = str(Path(os.sys.executable))

    result = subprocess.run(
        ["bash", str(script_path), "--config", str(config_path), "--mode", "cvt_theory_grounded", "--dry-run"],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    normalized = " ".join(result.stdout.split())
    assert "[cvt_theory_grounded] command:" in result.stdout
    assert "--qd_descriptor_profile theory_grounded_full_20d" in normalized
    assert "--qd_cvt_warmup_successes 16" in normalized
    assert "--total_worker_slots 20" in normalized
    assert "--max_active_problems 20" in normalized
    assert "--max_workers_per_problem 20" in normalized
