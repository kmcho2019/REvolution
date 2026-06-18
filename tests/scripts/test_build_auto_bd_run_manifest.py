from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import yaml

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_auto_bd_run_manifest.py"
)
_SPEC = importlib.util.spec_from_file_location("build_auto_bd_run_manifest", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_auto_bd_run_manifest", mod)
_SPEC.loader.exec_module(mod)


def test_build_manifest_uses_locked_phase_policy(tmp_path):
    paths = _write_inputs(tmp_path)

    manifest = mod.build_manifest(
        mod.ManifestInputs(
            config_path=paths["method_dir"],
            phase="development",
            run_policy_path=paths["run_policy"],
            subset_lock_path=paths["subset_lock"],
        ),
        {
            "yosys_version": "Yosys 0.test",
            "abc_version": "ABC 0.test",
            "openroad_version": "OpenROAD 0.test",
        },
    )

    assert manifest["seed_list"] == [1001]
    assert manifest["model_id"] == "openai/gpt-oss-120b"
    assert manifest["endpoint"] == "http://20.0.0.103:8000/v1"
    assert manifest["worker_count"] == 12
    assert manifest["timeout_policy"]["synthesis_timeout_s"] == 300
    assert len(manifest["config_hash"]) == 64
    assert len(manifest["subset_hash"]) == 64
    assert len(manifest["prompt_policy_hash"]) == 64
    assert len(manifest["constraints_hash"]) == 64


def test_write_manifest_outputs_standard_json(tmp_path):
    output = tmp_path / "run_manifest.json"
    manifest = {field: field for field in mod.RUN_MANIFEST_FIELDS}

    mod.write_manifest(manifest, output)

    assert json.loads(output.read_text(encoding="utf-8"))["git_commit"] == "git_commit"


def _write_inputs(tmp_path: Path) -> dict[str, Path]:
    method_dir = tmp_path / "method"
    method_dir.mkdir()
    (method_dir / "config.yaml").write_text("method: test\n", encoding="utf-8")
    prompt_dir = tmp_path / "prompts"
    prompt_dir.mkdir()
    (prompt_dir / "system.txt").write_text("system prompt\n", encoding="utf-8")
    pdk_dir = tmp_path / "pdk"
    pdk_dir.mkdir()
    liberty = pdk_dir / "Nangate45_typ.lib"
    liberty.write_text("library(test) {}\n", encoding="utf-8")
    constraint = tmp_path / "ref.yosys.tcl"
    constraint.write_text("synth\n", encoding="utf-8")
    subset_lock = tmp_path / "subset.yaml"
    subset_lock.write_text("development:\n  problem_count: 1\n", encoding="utf-8")
    run_policy = tmp_path / "run_policy.yaml"
    run_policy.write_text(
        yaml.safe_dump(
            {
                "model_policy": {
                    "endpoint": "http://20.0.0.103:8000/v1",
                    "model_id": "openai/gpt-oss-120b",
                },
                "seed_policy": {"preliminary_seed1": [1001]},
                "phase_policy": {"development": {"seeds": "preliminary_seed1"}},
                "timeout_policy": {
                    "rtl_simulation_timeout_s": 60,
                    "synthesis_timeout_s": 300,
                    "post_synthesis_simulation_timeout_s": 300,
                },
                "budget_policy": {"main_reported_total_budget_per_problem": 240},
                "worker_policy": {
                    "rule": "same_for_all_methods",
                    "development": {"total_worker_slots": 12},
                },
                "prompt_policy": {"hash_paths": [str(prompt_dir)]},
                "toolchain_policy": {
                    "liberty_file": str(liberty),
                    "pdk_or_tech_config_path": str(pdk_dir),
                    "constraint_hash_paths": [str(constraint)],
                },
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )
    return {
        "method_dir": method_dir,
        "run_policy": run_policy,
        "subset_lock": subset_lock,
    }
