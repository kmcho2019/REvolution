"""Tests for scripts/render_grade_summary.py (isolated-grade -> Markdown)."""
from __future__ import annotations

import importlib.util
from pathlib import Path

_SPEC = importlib.util.spec_from_file_location(
    "render_grade_summary",
    Path(__file__).resolve().parents[2] / "scripts" / "render_grade_summary.py",
)
render_grade_summary = importlib.util.module_from_spec(_SPEC)
assert _SPEC.loader is not None
_SPEC.loader.exec_module(render_grade_summary)


def test_cvdp_schema_renders_pass_fail_and_totals() -> None:
    merged = {
        "classic": {
            "task_a": {"n_total": 120, "n_checked": 30, "valid_found": 1, "any_pass": True},
            "task_b": {"n_total": 120, "n_checked": 30, "valid_found": 0, "any_pass": False},
        },
        "qd_v2": {
            "task_a": {"n_total": 120, "n_checked": 30, "valid_found": 1, "any_pass": True},
            "task_b": {"n_total": 120, "n_checked": 30, "valid_found": 1, "any_pass": True},
        },
    }
    assert render_grade_summary.is_cvdp_schema(merged)
    out = render_grade_summary.render(merged, "CVDP test", ["grade.json"])
    assert "| Task | classic | qd_v2 |" in out
    assert "| task_a | ✅ pass | ✅ pass |" in out
    assert "| task_b | ❌ fail | ✅ pass |" in out
    # classic solves 1/2, qd_v2 solves 2/2.
    assert "| **Solved** | **1/2** | **2/2** |" in out


def test_realbench_schema_renders_valid_best_and_totals() -> None:
    merged = {
        "classic": {
            "mod_x": {"n": 16, "valid": 2, "n_reached_sim": 6, "min_mismatch_frac": 0.0,
                      "distinct_mismatch_fracs": 1, "sample_fracs": [0.0]},
            "mod_y": {"n": 16, "valid": 0, "n_reached_sim": 5, "min_mismatch_frac": 0.206,
                      "distinct_mismatch_fracs": 2, "sample_fracs": [0.206, 0.5]},
        },
    }
    assert not render_grade_summary.is_cvdp_schema(merged)
    out = render_grade_summary.render(merged, "RealBench test", ["g.json"])
    assert "classic valid/n" in out
    assert "| mod_y | 0/16 | 0.206 | 5 |" in out
    # 2 + 0 valid out of 16 + 16.
    assert "| **Total valid** | **2/32** |" in out


def test_merge_combines_disjoint_arms() -> None:
    """Two grade files (classic+qd, then qd_v2) merge into one three-arm dict."""
    a = {"classic": {"t": {"any_pass": True}}, "qd": {"t": {"any_pass": False}}}
    b = {"qd_v2": {"t": {"any_pass": True}}}
    p1 = Path("/tmp/_grade_a.json")
    p2 = Path("/tmp/_grade_b.json")
    import json
    p1.write_text(json.dumps(a))
    p2.write_text(json.dumps(b))
    merged = render_grade_summary.load_merged([str(p1), str(p2)])
    assert list(merged) == ["classic", "qd", "qd_v2"]
