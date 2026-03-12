import os
import subprocess
from pathlib import Path


def test_evolution_smoke_script_dry_run_uses_large_token_defaults(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "run_evolution_smoke_vllm.sh"
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
        ["bash", str(script_path), "--suite", "rtllm", "--dry-run"],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    normalized = " ".join(result.stdout.split())
    assert "Detected model: stub-model" in result.stdout
    assert "--max_tokens 128000" in normalized
    assert "--diff_max_tokens 128000" in normalized
    assert "Dry run enabled; command was not executed." in result.stdout
