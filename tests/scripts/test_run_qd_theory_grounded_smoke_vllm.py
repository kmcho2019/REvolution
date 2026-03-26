import os
import subprocess
from pathlib import Path


def test_theory_grounded_smoke_script_dry_run_prints_compare_matrix(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "run_qd_theory_grounded_smoke_vllm.sh"
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
    env["THEORY_SMOKE_SAVE_PATH"] = str(tmp_path / "theory-smoke")
    env["PYTHON_BIN"] = str(Path(os.sys.executable))

    result = subprocess.run(
        [
            "bash",
            str(script_path),
            "--suite",
            "matrix",
            "--mode",
            "compare",
            "--policy",
            "diff-heavy",
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
    assert "Detected model: stub-model" in result.stdout
    assert "Mode: compare" in result.stdout
    assert "[rtllm/cvt_structural_fixed] command:" in result.stdout
    assert "[rtllm/cvt_size_control] command:" in result.stdout
    assert "[rtllm/cvt_theory_grounded] command:" in result.stdout
    assert "[verilogeval/cvt_theory_grounded] command:" in result.stdout
    assert "--qd_archive_type cvt" in normalized
    assert "--qd_descriptor_profile implemented_structural_fixed_5d" in normalized
    assert "--qd_descriptor_profile size_control_3d" in normalized
    assert "--qd_descriptor_profile theory_grounded_full_20d" in normalized
    assert "--qd_backfill_generation_mode diff" in normalized
    assert "--qd_refine_generation_mode diff" in normalized
    assert "--max_tokens 128000" in normalized
    assert "--diff_max_tokens 128000" in normalized
    assert "Dry run enabled; commands were not executed." in result.stdout
