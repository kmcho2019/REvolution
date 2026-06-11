from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import yaml

_SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_realbench_long_probe.py"
)
_SPEC = importlib.util.spec_from_file_location("build_realbench_long_probe", _SCRIPT_PATH)
assert _SPEC is not None and _SPEC.loader is not None
build_realbench_long_probe = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_realbench_long_probe", build_realbench_long_probe)
_SPEC.loader.exec_module(build_realbench_long_probe)


def _manifest() -> dict:
    problems = []
    for idx in range(12):
        problems.append(
            {
                "problem_name": f"mod_{idx:02d}",
                "subset": "module",
                "family": "e203_hbirdv2" if idx % 2 else "sdc",
                "harness_validated": idx != 11,
                "size_signals": {
                    "prompt_bytes": idx * 1000,
                    "test_sv_bytes": idx * 100,
                    "support_bytes": idx * 10,
                },
            }
        )
    return {"version": 1, "manifest_sha256": "a" * 64, "problems": problems}


def test_select_probe_tasks_ranks_by_size_and_filters_unvalidated():
    selected = build_realbench_long_probe.select_probe_tasks(
        _manifest(), probe_size=3
    )

    names = [entry["problem_name"] for entry in selected]
    # mod_11 is the largest but not validated; the next largest win.
    assert names == ["mod_10", "mod_09", "mod_08"]


def test_main_writes_locked_probe(tmp_path, capsys):
    root = tmp_path / "RealBench"
    root.mkdir(parents=True)
    (root / "module_manifest.json").write_text(json.dumps(_manifest()), encoding="utf-8")
    output = tmp_path / "configs" / "probe.yaml"

    code = build_realbench_long_probe.main(
        [
            "--realbench-root",
            str(root),
            "--output-config",
            str(output),
            "--probe-size",
            "8",
        ]
    )

    assert code == 0
    payload = yaml.safe_load(output.read_text(encoding="utf-8"))
    assert payload["subset_name"] == "realbench_long_model_probe_v1"
    assert payload["selection"]["subset_size"] == 8
    assert payload["selection"]["manifest_sha256"] == "a" * 64
    problems = payload["benchmarks"]["RealBench"]["problems"]
    assert len(problems) == 8
    assert sorted(problems) == problems
    ranks = [entry["size_rank_bytes"] for entry in payload["tasks"]]
    assert ranks == sorted(ranks, reverse=True)
    assert "Locked RealBench long-model probe: 8 tasks" in capsys.readouterr().out


def test_main_fails_when_pool_too_small(tmp_path):
    manifest = _manifest()
    manifest["problems"] = manifest["problems"][:4]
    root = tmp_path / "RealBench"
    root.mkdir(parents=True)
    (root / "module_manifest.json").write_text(json.dumps(manifest), encoding="utf-8")

    code = build_realbench_long_probe.main(
        [
            "--realbench-root",
            str(root),
            "--output-config",
            str(tmp_path / "probe.yaml"),
            "--probe-size",
            "8",
        ]
    )

    assert code == 2
