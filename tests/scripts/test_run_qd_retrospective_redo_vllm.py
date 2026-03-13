import os
import subprocess
from pathlib import Path


def test_qd_retrospective_redo_script_dry_run_prints_expected_matrix(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "run_qd_retrospective_redo_vllm.sh"
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
    env["VLLM_HOST"] = "fake-host"
    env["VLLM_PORT"] = "9999"
    env["REDO_SAVE_PATH"] = str(tmp_path / "redo")
    env["PYTHON_BIN"] = str(Path(os.sys.executable))

    result = subprocess.run(
        ["bash", str(script_path), "--preset", "follow-on", "--suite", "rtllm", "--dry-run"],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    normalized = " ".join(result.stdout.split())
    assert "Detected model: stub-model" in result.stdout
    assert "Preset: follow-on" in result.stdout
    assert "[rtllm/grid_wire_ctrl_assign] command:" in result.stdout
    assert "[rtllm/cvt_size_control] command:" in result.stdout
    assert "[rtllm/cvt_hybrid_phys] command:" in result.stdout
    assert "[rtllm/grid_activity_control] command:" in result.stdout
    assert "[rtllm/report] command:" in result.stdout
    assert "--qd_descriptor_profile wire_ctrl_assign_3d" in normalized
    assert "--qd_descriptor_profile size_control_3d" in normalized
    assert "--qd_descriptor_profile hybrid_phys_seq" in normalized
    assert "--qd_descriptor_profile activity_control_3d" in normalized
    assert "--population_size 20" in normalized
    assert "--num_generations 5" in normalized
    assert "--max_tokens 128000" in normalized
    assert "--diff_max_tokens 128000" in normalized
    assert "Dry run enabled; commands were not executed." in result.stdout
