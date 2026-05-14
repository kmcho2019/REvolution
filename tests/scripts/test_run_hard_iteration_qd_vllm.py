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
                    "qd_grid_quantile_warmup_successes": 8,
                    "qd_fill_target_fraction": 0.35,
                    "qd_cell_reservoir": 3,
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
                    "grid_quantile_journal_bd": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "grid_quantile",
                        "qd_descriptor_profile": "journal_logic_ff_width_3d",
                        "qd_operator_kind": "single_thought_operator",
                        "qd_operator_one_parent_fraction": 0.5,
                        "qd_operator_archive_context_size": 4,
                        "qd_operator_two_parent_allow_intra_bin": True,
                        "qd_rebinning_kind": "ks_triggered",
                        "qd_rebinning_recent_generations": 3,
                        "qd_rebinning_min_archive_members": 20,
                        "qd_rebinning_cooldown_generations": 3,
                        "qd_rebinning_base_p_threshold": 0.05,
                        "prompt_profile": "journal_thought_only",
                        "representation": {
                            "kind": "thought_only",
                            "code_samples_per_thought": 4,
                            "representative_sample": "best_successful_quality",
                        },
                        "repair": {
                            "kind": "none",
                            "max_attempts_per_sample": 0,
                            "max_attempts_per_thought": 0,
                            "evidence": "stage_scoped_logs",
                        },
                    },
                    "cvt_theory_grounded": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "theory_grounded_full_20d",
                    },
                    "cvt_theory_grounded_compact": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "theory_grounded_compact_8d",
                    },
                },
                "matrix_modes": [
                    "classic",
                    "grid_struct",
                    "cvt_struct",
                    "cvt_size_control",
                    "grid_quantile_journal_bd",
                ],
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
    assert "[grid_quantile_journal_bd] command:" in result.stdout
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
    assert "--qd_grid_quantile_warmup_successes 8" in normalized
    assert "--qd_fill_target_fraction 0.35" in normalized
    assert "--qd_cell_reservoir 3" in normalized
    assert "--qd_cell_mode scalar_elite" in normalized
    assert "--qd_max_elites_per_cell 1" in normalized
    assert "--qd_objectives ppa" in normalized
    assert "--qd_operator_kind single_thought_operator" in normalized
    assert "--qd_operator_one_parent_fraction 0.5" in normalized
    assert "--qd_operator_archive_context_size 4" in normalized
    assert "--qd_operator_two_parent_allow_intra_bin" in normalized
    assert "--qd_rebinning_kind ks_triggered" in normalized
    assert "--qd_rebinning_recent_generations 3" in normalized
    assert "--qd_rebinning_min_archive_members 20" in normalized
    assert "--qd_rebinning_cooldown_generations 3" in normalized
    assert "--qd_rebinning_base_p_threshold 0.05" in normalized
    assert "--prompt_profile journal_thought_only" in normalized
    assert "--representation_kind thought_only" in normalized
    assert "--code_samples_per_thought 4" in normalized
    assert "--representative_sample best_successful_quality" in normalized
    assert "--repair_kind none" in normalized
    assert "--repair_max_attempts_per_sample 0" in normalized
    assert "--repair_max_attempts_per_thought 0" in normalized
    assert "--repair_evidence stage_scoped_logs" in normalized
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
    assert "qd_grid_quantile_warmup_successes=8" in manifest
    assert "qd_fill_target_fraction=0.35" in manifest
    assert "qd_cell_reservoir=3" in manifest
    assert "qd_cell_mode=scalar_elite" in manifest
    assert "qd_max_elites_per_cell=1" in manifest
    assert "qd_objectives=ppa" in manifest
    assert "mode.grid_quantile_journal_bd.qd_operator_kind=single_thought_operator" in manifest
    assert "mode.grid_quantile_journal_bd.qd_operator_one_parent_fraction=0.5" in manifest
    assert "mode.grid_quantile_journal_bd.qd_operator_archive_context_size=4" in manifest
    assert "mode.grid_quantile_journal_bd.qd_operator_two_parent_allow_intra_bin=true" in manifest
    assert "mode.grid_quantile_journal_bd.qd_rebinning_kind=ks_triggered" in manifest
    assert "mode.grid_quantile_journal_bd.qd_rebinning_recent_generations=3" in manifest
    assert "mode.grid_quantile_journal_bd.qd_rebinning_min_archive_members=20" in manifest
    assert "mode.grid_quantile_journal_bd.qd_rebinning_cooldown_generations=3" in manifest
    assert "mode.grid_quantile_journal_bd.qd_rebinning_base_p_threshold=0.05" in manifest
    assert "mode.grid_quantile_journal_bd.prompt_profile=journal_thought_only" in manifest
    assert "mode.grid_quantile_journal_bd.representation.kind=thought_only" in manifest
    assert "mode.grid_quantile_journal_bd.representation.code_samples_per_thought=4" in manifest
    assert "mode.grid_quantile_journal_bd.repair.kind=none" in manifest
    assert f"--output {run_dir / 'hard_iteration_backend_comparison.md'}" in normalized
    assert f"--backend_run classic={run_dir / 'classic'}" in normalized
    assert f"--backend_run grid_struct={run_dir / 'grid_struct'}" in normalized
    assert f"--backend_run cvt_struct={run_dir / 'cvt_struct'}" in normalized
    assert f"--backend_run grid_quantile_journal_bd={run_dir / 'grid_quantile_journal_bd'}" in normalized
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
                    "qd_fill_target_fraction": 0.25,
                    "qd_cell_reservoir": 2,
                    "seed": 42,
                },
                "modes": {
                    "classic": {"search_mode": "revolution"},
                    "cvt_theory_grounded": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "theory_grounded_full_20d",
                    },
                    "cvt_theory_grounded_compact": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "theory_grounded_compact_8d",
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
    assert "--qd_num_cells 16" in normalized
    assert "--qd_cvt_warmup_successes 16" in normalized
    assert "--qd_fill_target_fraction 0.25" in normalized
    assert "--qd_cell_reservoir 2" in normalized
    assert "--total_worker_slots 20" in normalized
    assert "--max_active_problems 20" in normalized
    assert "--max_workers_per_problem 20" in normalized


def test_run_hard_iteration_qd_script_supports_compact_theory_mode(tmp_path):
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
                    "qd_fill_target_fraction": 0.25,
                    "qd_cell_reservoir": 2,
                    "seed": 42,
                },
                "modes": {
                    "classic": {"search_mode": "revolution"},
                    "cvt_theory_grounded_compact": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "theory_grounded_compact_8d",
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
        [
            "bash",
            str(script_path),
            "--config",
            str(config_path),
            "--mode",
            "cvt_theory_grounded_compact",
            "--dry-run",
        ],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    normalized = " ".join(result.stdout.split())
    assert "[cvt_theory_grounded_compact] command:" in result.stdout
    assert "--qd_descriptor_profile theory_grounded_compact_8d" in normalized
    assert "--qd_num_cells 16" in normalized
    assert "--qd_cvt_warmup_successes 16" in normalized
    assert "--qd_fill_target_fraction 0.25" in normalized
    assert "--qd_cell_reservoir 2" in normalized
    assert "--total_worker_slots 20" in normalized


def test_run_hard_iteration_qd_script_supports_custom_matrix_modes_and_overrides(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "run_hard_iteration_qd_vllm.sh"
    config_path = tmp_path / "hard_iteration_subset_tuning.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "subset_name": "hard_iteration_subset_tuning",
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
                    "population_size": 12,
                    "num_generations": 3,
                    "evaluation_mode": "search_accelerated",
                    "accelerated_synthesis_top_k": 1,
                    "total_worker_slots": 4,
                    "max_active_problems": 4,
                    "max_workers_per_problem": 4,
                    "temperature": 1.0,
                    "top_p": 1.0,
                    "max_tokens": 128000,
                    "diff_max_tokens": 128000,
                    "qd_num_cells": 16,
                    "qd_cvt_warmup_successes": 4,
                    "qd_fill_target_fraction": 0.25,
                    "qd_cell_reservoir": 2,
                    "seed": 42,
                },
                "matrix_modes": [
                    "grid_struct",
                    "cvt_size_control_fill50",
                    "cvt_size_control_dense",
                ],
                "modes": {
                    "grid_struct": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "grid",
                        "qd_descriptor_profile": "implemented_structural_compact_3d",
                    },
                    "cvt_size_control_fill50": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "size_control_3d",
                        "qd_fill_target_fraction": 0.5,
                    },
                    "cvt_size_control_dense": {
                        "search_mode": "revolution_qd",
                        "qd_archive_type": "cvt",
                        "qd_descriptor_profile": "size_control_3d",
                        "qd_num_cells": 24,
                        "qd_cvt_warmup_successes": 6,
                        "qd_cell_reservoir": 4,
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
        ["bash", str(script_path), "--config", str(config_path), "--mode", "matrix", "--dry-run"],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    normalized = " ".join(result.stdout.split())
    assert "[grid_struct] command:" in result.stdout
    assert "[cvt_size_control_fill50] command:" in result.stdout
    assert "[cvt_size_control_dense] command:" in result.stdout
    assert "--qd_fill_target_fraction 0.5" in normalized
    assert "--qd_num_cells 24" in normalized
    assert "--qd_cvt_warmup_successes 6" in normalized
    assert "--qd_cell_reservoir 4" in normalized

    run_dirs = [path for path in (tmp_path / "runs").iterdir() if path.is_dir()]
    assert len(run_dirs) == 1
    manifest = (run_dirs[0] / "hard_iteration_manifest.txt").read_text(encoding="utf-8")
    assert "mode.cvt_size_control_fill50.qd_fill_target_fraction=0.5" in manifest
    assert "mode.cvt_size_control_dense.qd_num_cells=24" in manifest
    assert "mode.cvt_size_control_dense.qd_cvt_warmup_successes=6" in manifest
    assert "mode.cvt_size_control_dense.qd_cell_reservoir=4" in manifest
