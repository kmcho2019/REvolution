from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import yaml

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_holdout_reference_subset.py"
)
_SPEC = importlib.util.spec_from_file_location("build_holdout_reference_subset", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_holdout_reference_subset", mod)
_SPEC.loader.exec_module(mod)


def test_locked_holdout_is_disjoint_and_deterministic(tmp_path):
    """The generated repo config must be disjoint from every tuning set."""
    out = tmp_path / "holdout.yaml"
    assert mod.main(["--output-config", str(out)]) == 0
    payload = yaml.safe_load(out.read_text(encoding="utf-8"))
    problems = {
        p for body in payload["benchmarks"].values() for p in body["problems"]
    }
    assert len(problems) == 20
    excluded = set(payload["selection"]["excluded_problems"])
    assert excluded, "exclusion list must be embedded"
    assert not problems & excluded
    # Determinism: a second build is byte-identical.
    out2 = tmp_path / "holdout2.yaml"
    assert mod.main(["--output-config", str(out2)]) == 0
    assert out.read_text(encoding="utf-8") == out2.read_text(encoding="utf-8")
