import os
import subprocess
from pathlib import Path


def test_theory_followup_script_dry_run_prints_compare_matrix(tmp_path):
    repo_root = Path(__file__).resolve().parents[2]
    script_path = repo_root / "scripts" / "run_qd_theory_followup_vllm.sh"
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
    env["THEORY_FOLLOWUP_SAVE_PATH"] = str(tmp_path / "theory-followup")
    env["PYTHON_BIN"] = str(Path(os.sys.executable))

    result = subprocess.run(
        ["bash", str(script_path), "--suite", "matrix", "--dry-run"],
        cwd=repo_root,
        env=env,
        check=False,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    normalized = " ".join(result.stdout.split())
    assert "Detected model: stub-model" in result.stdout
    assert "[rtllm/cvt_structural_fixed] command:" in result.stdout
    assert "[rtllm/cvt_size_control] command:" in result.stdout
    assert "[rtllm/cvt_theory_grounded] command:" in result.stdout
    assert "[rtllm/cvt_theory_compact] command:" in result.stdout
    assert "[verilogeval/cvt_theory_grounded] command:" in result.stdout
    assert "[verilogeval/cvt_theory_compact] command:" in result.stdout
    assert "--qd_descriptor_profile implemented_structural_fixed_5d" in normalized
    assert "--qd_descriptor_profile size_control_3d" in normalized
    assert "--qd_descriptor_profile theory_grounded_full_20d" in normalized
    assert "--qd_descriptor_profile theory_grounded_compact_8d" in normalized
    assert "--problems Prob001_accu Prob002_adder_16bit" in normalized
    assert "--problems Prob001_zero Prob017_mux2to1v" in normalized
    assert "--population_size 4" in normalized
    assert "--num_generations 2" in normalized
    assert "--max_tokens 128000" in normalized
    assert "--diff_max_tokens 128000" in normalized
    assert "Dry run enabled; commands were not executed." in result.stdout
