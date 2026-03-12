from pathlib import Path

import pytest

from revolution.qd.descriptors import (
    descriptor_requirements,
    extract_descriptor_values,
    load_descriptor_profiles,
    resolve_descriptor_axes,
)


def test_load_descriptor_profiles_includes_hybrid_defaults():
    profiles = load_descriptor_profiles()
    assert "hybrid_seq_default" in profiles
    assert "rtl_core" in profiles


def test_resolve_descriptor_axes_prefers_explicit_axes():
    axes = resolve_descriptor_axes(
        profile_name="rtl_core",
        explicit_axes=["seq_ratio", "g_A"],
        descriptor_file=None,
        archive_type="grid",
        circuit_type="sequential",
    )
    assert axes == ["seq_ratio", "g_A"]


def test_resolve_descriptor_axes_uses_grid_defaults_for_comb_logic():
    axes = resolve_descriptor_axes(
        profile_name=None,
        explicit_axes=None,
        descriptor_file=None,
        archive_type="grid",
        circuit_type="combinational",
    )
    assert axes == ["g_A", "g_P"]


def test_extract_descriptor_values_applies_log1p_transform():
    values = extract_descriptor_values(
        {"cell_count_log": 99.0, "g_A": 0.2},
        ["cell_count_log", "g_A"],
    )
    assert values["cell_count_log"] > 0.0
    assert values["g_A"] == pytest.approx(0.2)


def test_descriptor_requirements_detect_ppa_and_synthesis_needs():
    reqs = descriptor_requirements(["seq_ratio", "g_A"])
    assert reqs["requires_synthesis"] is True
    assert reqs["requires_ppa"] is True


def test_load_descriptor_profiles_accepts_custom_file(tmp_path: Path):
    cfg = tmp_path / "profiles.yaml"
    cfg.write_text("profiles:\n  mini:\n    - g_A\n    - g_T\n", encoding="utf-8")
    profiles = load_descriptor_profiles(cfg)
    assert profiles["mini"] == ["g_A", "g_T"]
