from pathlib import Path

import pytest

from revolution.qd.descriptors import (
    descriptor_requirements,
    extract_descriptor_values,
    load_grid_axis_specs,
    load_descriptor_profiles,
    resolve_descriptor_axes,
    resolve_grid_axis_specs,
)


def test_load_descriptor_profiles_includes_hybrid_defaults():
    profiles = load_descriptor_profiles()
    assert "hybrid_seq_default" in profiles
    assert "rtl_core" in profiles
    assert "implemented_structural_fixed_5d" in profiles
    assert "implemented_structural_compact_3d" in profiles


def test_load_descriptor_profiles_includes_retrospective_structural_profiles():
    profiles = load_descriptor_profiles()
    assert profiles["implemented_structural_fixed_5d"] == [
        "seq_ratio",
        "comb_ratio",
        "mux_ratio",
        "adder_ratio",
        "cell_count_log",
    ]
    assert profiles["implemented_structural_compact_3d"] == [
        "comb_ratio",
        "adder_ratio",
        "cell_count_log",
    ]


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


def test_resolve_descriptor_axes_uses_grid_defaults_for_sequential_logic():
    axes = resolve_descriptor_axes(
        profile_name=None,
        explicit_axes=None,
        descriptor_file=None,
        archive_type="grid",
        circuit_type="sequential",
    )
    assert axes == ["g_A", "g_P", "g_T"]


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


def test_load_grid_axis_specs_accepts_custom_file(tmp_path: Path):
    cfg = tmp_path / "profiles.yaml"
    cfg.write_text(
        "profiles:\n  mini:\n    - g_A\n"
        "grid_axes:\n"
        "  g_A:\n"
        "    bins: 5\n"
        "    lower_bound: -0.5\n"
        "    upper_bound: 0.75\n",
        encoding="utf-8",
    )
    specs = load_grid_axis_specs(cfg)
    assert specs["g_A"].bins == 5
    assert specs["g_A"].lower_bound == pytest.approx(-0.5)
    assert specs["g_A"].upper_bound == pytest.approx(0.75)


def test_resolve_grid_axis_specs_uses_configured_and_fallback_specs(tmp_path: Path):
    cfg = tmp_path / "profiles.yaml"
    cfg.write_text(
        "grid_axes:\n"
        "  seq_ratio:\n"
        "    bins: 3\n"
        "    lower_bound: 0.1\n"
        "    upper_bound: 0.9\n",
        encoding="utf-8",
    )
    specs = resolve_grid_axis_specs(
        ["seq_ratio", "g_A"],
        num_cells=16,
        descriptor_file=cfg,
    )
    assert specs[0].bins == 3
    assert specs[0].lower_bound == pytest.approx(0.1)
    assert specs[0].upper_bound == pytest.approx(0.9)
    assert specs[1].bins == 4
    assert specs[1].lower_bound == pytest.approx(-1.0)
    assert specs[1].upper_bound == pytest.approx(1.0)


def test_default_descriptor_file_exposes_retrospective_structural_grid_specs():
    specs = load_grid_axis_specs()
    assert specs["seq_ratio"].bins == 2
    assert specs["seq_ratio"].lower_bound == pytest.approx(0.0)
    assert specs["seq_ratio"].upper_bound == pytest.approx(0.2918918918918919)
    assert specs["comb_ratio"].bins == 2
    assert specs["comb_ratio"].lower_bound == pytest.approx(0.7081081081081081)
    assert specs["comb_ratio"].upper_bound == pytest.approx(1.0)
    assert specs["mux_ratio"].bins == 2
    assert specs["mux_ratio"].lower_bound == pytest.approx(0.026345721755332695)
    assert specs["mux_ratio"].upper_bound == pytest.approx(0.37158469945355194)
    assert specs["adder_ratio"].bins == 2
    assert specs["adder_ratio"].lower_bound == pytest.approx(0.0)
    assert specs["adder_ratio"].upper_bound == pytest.approx(0.11588330632090761)
    assert specs["cell_count_log"].bins == 2
    assert specs["cell_count_log"].lower_bound == pytest.approx(5.1152555343856845)
    assert specs["cell_count_log"].upper_bound == pytest.approx(7.605890001053122)
