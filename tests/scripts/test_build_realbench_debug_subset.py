from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import yaml

_SCRIPT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_realbench_debug_subset.py"
)
_SPEC = importlib.util.spec_from_file_location(
    "build_realbench_debug_subset", _SCRIPT_PATH
)
assert _SPEC is not None and _SPEC.loader is not None
build_realbench_debug_subset = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_realbench_debug_subset", build_realbench_debug_subset)
_SPEC.loader.exec_module(build_realbench_debug_subset)


def _manifest() -> dict:
    problems = []
    for idx in range(3):
        problems.append(
            {
                "problem_name": f"aes_mod_{idx}",
                "subset": "module",
                "family": "aes",
                "harness_validated": True,
            }
        )
    problems.append(
        {
            "problem_name": "aes_bad",
            "subset": "module",
            "family": "aes",
            "harness_validated": False,
        }
    )
    for idx in range(6):
        problems.append(
            {
                "problem_name": f"sdc_mod_{idx}",
                "subset": "module",
                "family": "sdc",
                "harness_validated": True,
            }
        )
    for idx in range(20):
        problems.append(
            {
                "problem_name": f"e203_mod_{idx:02d}",
                "subset": "module",
                "family": "e203_hbirdv2",
                "harness_validated": True,
            }
        )
    return {
        "version": 1,
        "manifest_sha256": "f" * 64,
        "problems": problems,
    }


def test_select_balanced_subset_filters_unvalidated_and_balances():
    selection = build_realbench_debug_subset.select_balanced_subset(
        _manifest(), per_family=2, seed=42, subset_size=None
    )

    assert set(selection) == {"aes", "sdc", "e203_hbirdv2"}
    assert all(len(ids) == 2 for ids in selection.values())
    assert "aes_bad" not in selection["aes"]


def test_select_balanced_subset_tops_up_small_families_deterministically():
    first = build_realbench_debug_subset.select_balanced_subset(
        _manifest(), per_family=4, seed=42, subset_size=12
    )
    second = build_realbench_debug_subset.select_balanced_subset(
        _manifest(), per_family=4, seed=42, subset_size=12
    )

    assert first == second
    total = sum(len(ids) for ids in first.values())
    assert total == 12
    # aes only has 3 validated tasks; shortfall is topped up elsewhere.
    assert len(first["aes"]) == 3
    assert len(first["sdc"]) + len(first["e203_hbirdv2"]) == 9


def test_main_writes_locked_manifest(tmp_path, capsys):
    root = tmp_path / "RealBench"
    root.mkdir(parents=True)
    (root / "module_manifest.json").write_text(
        json.dumps(_manifest()), encoding="utf-8"
    )
    output = tmp_path / "configs" / "realbench_debug_subset.yaml"

    code = build_realbench_debug_subset.main(
        [
            "--realbench-root",
            str(root),
            "--output-config",
            str(output),
            "--per-family",
            "4",
            "--subset-size",
            "12",
            "--seed",
            "42",
        ]
    )

    assert code == 0
    payload = yaml.safe_load(output.read_text(encoding="utf-8"))
    assert payload["subset_name"] == "realbench_debug_subset_v1"
    assert payload["selection"]["manifest_sha256"] == "f" * 64
    assert payload["selection"]["subset_size"] == 12
    problems = payload["benchmarks"]["RealBench"]["problems"]
    assert len(problems) == 12
    assert sorted(problems) == problems
    out = capsys.readouterr().out
    assert "Locked RealBench debug subset: 12 tasks" in out


def test_main_fails_without_manifest(tmp_path):
    code = build_realbench_debug_subset.main(
        [
            "--realbench-root",
            str(tmp_path / "missing"),
            "--output-config",
            str(tmp_path / "out.yaml"),
        ]
    )

    assert code == 2
