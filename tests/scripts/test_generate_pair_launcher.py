from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import yaml

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent / "scripts" / "generate_pair_launcher.py"
)
_SPEC = importlib.util.spec_from_file_location("gpl", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("gpl", mod)
_SPEC.loader.exec_module(mod)


def test_launcher_carries_exact_problem_list(tmp_path):
    config = tmp_path / "subset.yaml"
    config.write_text(
        yaml.safe_dump(
            {
                "benchmarks": {
                    "RTLLM": {"problems": ["Prob_a", "Prob_b"]},
                    "VerilogEval-Spec-to-RTL": {"problems": ["Prob_c"]},
                }
            }
        ),
        encoding="utf-8",
    )
    out = tmp_path / "launch.sh"
    code = mod.main(
        [
            "--subset-config", str(config),
            "--tag", "k_ablation_test",
            "--purpose", "k_ablation",
            "--variant-flags", "--code_samples_per_thought 2",
            "--output", str(out),
        ]
    )
    assert code == 0
    script = out.read_text(encoding="utf-8")
    for problem in ("Prob_a", "Prob_b", "Prob_c"):
        assert problem in script
    assert "openrouter" in script  # GPU-handoff default
    assert "openai/gpt-oss-120b" in script
    assert "--code_samples_per_thought 2" in script
    assert "vllm_host" not in script  # no local endpoint flags on openrouter
    assert script.count("journal_rerun_ledger.py append") == 2


def test_openrouter_caps_completion_budget(tmp_path):
    config = tmp_path / "subset.yaml"
    config.write_text(
        yaml.safe_dump({"benchmarks": {"RTLLM": {"problems": ["Prob048_pe"]}}}),
        encoding="utf-8",
    )
    out = tmp_path / "launch.sh"

    mod.main(
        [
            "--subset-config", str(config),
            "--tag", "t", "--purpose", "p",
            "--variant-flags", "--qd_objectives ppa",
            "--output", str(out),
        ]
    )
    script = out.read_text(encoding="utf-8")
    assert "--max_tokens 32768" in script
    assert "PYTHONUNBUFFERED=1" in script

    mod.main(
        [
            "--subset-config", str(config),
            "--tag", "t", "--purpose", "p",
            "--api-backend", "vllm",
            "--variant-flags", "--qd_objectives ppa",
            "--output", str(out),
        ]
    )
    assert "--max_tokens 128000" in out.read_text(encoding="utf-8")
