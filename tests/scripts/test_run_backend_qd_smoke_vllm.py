import os
import subprocess
from pathlib import Path


def test_qd_smoke_script_dry_run_prints_grid_and_cvt_commands(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "run_backend_qd_smoke_vllm.sh"
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
    env["SMOKE_SAVE_PATH"] = str(tmp_path / "smoke")
    env["PYTHON_BIN"] = str(Path(os.sys.executable))

    result = subprocess.run(
        ["bash", str(script_path), "--archive", "matrix", "--policy", "diff-heavy", "--dry-run"],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    normalized = " ".join(result.stdout.split())
    assert "Detected model: stub-model" in result.stdout
    assert "[grid] command:" in result.stdout
    assert "[cvt] command:" in result.stdout
    assert "--qd_archive_type grid" in normalized
    assert "--qd_archive_type cvt" in normalized
    assert "--qd_backfill_generation_mode diff" in normalized
    assert "--qd_refine_generation_mode diff" in normalized
    assert "--total_worker_slots 1" in normalized
    assert "--max_workers_per_problem 1" in normalized
    assert "--max_tokens 128000" in normalized
    assert "--diff_max_tokens 128000" in normalized
    assert "Dry run enabled; commands were not executed." in result.stdout
