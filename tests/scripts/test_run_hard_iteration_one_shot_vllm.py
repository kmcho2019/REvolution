import os
import subprocess
from pathlib import Path


def test_run_hard_iteration_one_shot_script_dry_run_skips_completed_and_batches_pending(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "run_hard_iteration_one_shot_vllm.sh"
    model_dir = "_project_cad-team_LX_Semicon_models_openai-gpt-oss-120b"
    save_root = tmp_path / "one_shot"

    completed_rtllm = save_root / model_dir / "RTLLM" / "Prob001_accu"
    completed_rtllm.mkdir(parents=True, exist_ok=True)
    (completed_rtllm / "Prob001_accu_summary.json").write_text("{}", encoding="utf-8")

    completed_ve = save_root / model_dir / "VerilogEval-Spec-to-RTL" / "Prob001_zero"
    completed_ve.mkdir(parents=True, exist_ok=True)
    (completed_ve / "Prob001_zero_summary.json").write_text("{}", encoding="utf-8")

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
    env["PYTHON_BIN"] = str(Path(os.sys.executable))
    env["HARD_ONE_SHOT_SAVE_PATH"] = str(save_root)
    env["HARD_ONE_SHOT_BATCH_SIZE"] = "2"
    env["HARD_ONE_SHOT_NUM_WORKERS"] = "2"
    env["VLLM_HOST"] = "wrong-host"
    env["VLLM_PORT"] = "1234"

    result = subprocess.run(
        ["bash", str(script_path), "--benchmarks", "RTLLM", "VerilogEval-Spec-to-RTL", "--dry-run"],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    normalized = " ".join(result.stdout.split())
    assert "[RTLLM/batch1] command:" in result.stdout
    assert "[VerilogEval-Spec-to-RTL/batch1] command:" in result.stdout
    assert "--problems Prob002_adder_16bit Prob003_adder_32bit" in normalized
    assert "--problems Prob002_m2014_q4i Prob003_step_one" in normalized
    assert "--vllm_host host.docker.internal" in normalized
    assert "--vllm_port 8000" in normalized
    assert "Prob001_accu" not in normalized
    assert "Prob001_zero" not in normalized
    assert "--num_workers 2" in normalized
    assert "--num_samples 10" in normalized
    assert "--max_tokens 128000" in normalized
    assert "Dry run enabled; commands were not executed." in result.stdout
