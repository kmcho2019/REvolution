import pytest

from revolution.auto_bd.method_specs import (
    AUTO_BD_METHODS_DIR,
    FORBIDDEN_DESCRIPTOR_INPUTS,
    method_directory,
    method_spec,
    method_specs,
    validate_method_registry,
)


def test_method_registry_is_valid_and_ordered():
    validate_method_registry()

    assert [spec.family for spec in method_specs()] == [
        "random_descriptor",
        "yosys_stat_bd",
        "netlist_motif_occupancy",
        "synthesis_trajectory_nod",
        "contrastive_synthesis_response",
        "aurora_netlist_encoder",
        "vq_implementation_codebook",
    ]


def test_method_lookup_fails_on_unknown_family():
    with pytest.raises(ValueError, match="Unknown Auto-BD method family"):
        method_spec("ppa_leaking_descriptor")


def test_method_directories_stay_under_scaffold():
    directory = method_directory("synthesis_trajectory_nod")

    assert directory == AUTO_BD_METHODS_DIR / "03_synthesis_trajectory_nod"


def test_method_specs_exclude_forbidden_descriptor_inputs():
    forbidden = set(FORBIDDEN_DESCRIPTOR_INPUTS)

    for spec in method_specs():
        assert not forbidden.intersection(spec.descriptor_inputs)


def test_learned_methods_require_fitting_artifacts():
    learned = {
        spec.family: spec
        for spec in method_specs()
        if spec.family in {"aurora_netlist_encoder", "vq_implementation_codebook"}
    }

    assert learned["aurora_netlist_encoder"].requires_fitting_artifacts
    assert learned["vq_implementation_codebook"].requires_fitting_artifacts
    assert method_spec("netlist_motif_occupancy").fitting_protocol == "none"
