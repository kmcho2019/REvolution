from __future__ import annotations

from revolution.qd.visualization import (
    _grid_quantile_render_layout,
    _render_indices,
)


def _space(axes: list[tuple[str, int]]) -> dict:
    return {
        "axes": [{"name": name} for name, _ in axes],
        "effective_shape": [bins for _, bins in axes],
    }


def test_two_axis_profile_renders_via_virtual_flat_axis():
    render = _grid_quantile_render_layout(
        _space([("wire_count_log_est", 4), ("assign_count", 4)])
    )

    assert render["visualization_mode"] == "2d"
    assert render["axis_layout"] == {
        "x": "wire_count_log_est",
        "y": "assign_count",
        "z": "(flat)",
    }
    assert render["render_shape"] == [4, 4, 1]
    assert render["slice_axis"] == "(flat)"
    assert render["slice_count"] == 1
    assert _render_indices([2, 3], render) == [2, 3, 0]


def test_two_axis_profile_with_collapsed_axis_skips():
    render = _grid_quantile_render_layout(_space([("a", 4), ("b", 1)]))

    assert render["visualization_mode"] == "skipped"
    assert render["skip_reason"] == "fewer than two active axes"


def test_three_axis_journal_profile_layout_unchanged():
    render = _grid_quantile_render_layout(
        _space([("logic_depth", 4), ("ff_depth", 2), ("comb_width_log", 4)])
    )

    assert render["visualization_mode"] == "3d"
    assert render["axis_layout"]["y"] == "comb_width_log"
    assert render["slice_axis"] == "ff_depth"
    assert _render_indices([1, 0, 3], render) == [1, 3, 0]


def test_one_axis_profile_still_skips():
    render = _grid_quantile_render_layout(_space([("a", 4)]))

    assert render["visualization_mode"] == "skipped"
    assert "2- or 3-axis" in render["skip_reason"]
