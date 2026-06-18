from revolution.runtime.benchmark_capabilities import (
    canonical_benchmark_family,
    derive_quality_mode,
    family_infers_circuit_type,
    is_known_benchmark_family,
    resolve_benchmark_capabilities,
)


def test_rtllm_with_reference_ppa_uses_reference_normalized_mode():
    caps = resolve_benchmark_capabilities("RTLLM", supports_reference_ppa=True)

    assert caps.benchmark_family == "rtllm"
    assert caps.supports_functional is True
    assert caps.functional_harness_kind == "iverilog_testbench"
    assert caps.supports_synthesis is True
    assert caps.supports_post_synth_check is True
    assert caps.supports_reference_ppa is True
    assert caps.ppa_mode == "reference_normalized"
    assert caps.workload_class == "small"
    assert caps.clock_metadata["clock_period_ns"] == "0.01"
    assert derive_quality_mode(caps) == "ppa"


def test_rtllm_without_reference_ppa_falls_back_to_absolute_only():
    caps = resolve_benchmark_capabilities("RTLLM", supports_reference_ppa=False)

    assert caps.supports_reference_ppa is False
    assert caps.ppa_mode == "absolute_only"
    assert derive_quality_mode(caps) == "functional_only"


def test_cvdp_suppresses_reference_normalized_ppa_with_note():
    caps = resolve_benchmark_capabilities("cvdp", supports_reference_ppa=True)

    assert caps.allows_reference_normalized_ppa is False
    assert caps.supports_reference_ppa is False
    assert caps.supports_synthesis is False
    assert caps.ppa_mode == "none"
    assert caps.functional_harness_kind == "cocotb_pytest"
    assert caps.workload_class == "large"
    assert caps.license_tag == "no_commercial"
    assert derive_quality_mode(caps) == "functional_only"
    assert any("reference_normalized_ppa_suppressed" in note for note in caps.notes)


def test_cvdp_with_synthesis_override_is_absolute_only_never_reference():
    caps = resolve_benchmark_capabilities(
        "cvdp",
        supports_reference_ppa=True,
        supports_synthesis=True,
    )

    assert caps.supports_synthesis is True
    assert caps.ppa_mode == "absolute_only"
    assert derive_quality_mode(caps) == "functional_only"


def test_verilogeval_code_complete_keeps_functional_objective_with_reference():
    caps = resolve_benchmark_capabilities(
        "VerilogEval-Code-Complete",
        supports_reference_ppa=True,
    )

    assert caps.supports_reference_ppa is True
    assert caps.quality_objective_policy == "functional_only"
    assert caps.ppa_mode == "absolute_only"
    assert derive_quality_mode(caps) == "functional_only"


def test_realbench_without_synthesis_reports_no_ppa():
    caps = resolve_benchmark_capabilities(
        "RealBench",
        supports_reference_ppa=True,
        supports_synthesis=False,
    )

    assert caps.supports_synthesis is False
    assert caps.supports_post_synth_check is False
    assert caps.ppa_mode == "none"
    assert caps.workload_class == "large"
    assert derive_quality_mode(caps) == "functional_only"


def test_realbench_overrides_carry_problem_facts():
    caps = resolve_benchmark_capabilities(
        "RealBench",
        supports_reference_ppa=True,
        supports_synthesis=True,
        top_module="aes_core",
        aux_files=("rtl/aes_sbox.v",),
        default_timeout_s=900.0,
        clock_metadata={"clock_port": "clk", "clock_period_ns": "2.0"},
        reset_metadata={"reset_port": "rst_n", "active": "low"},
        license_tag="realbench-upstream",
    )

    assert caps.ppa_mode == "reference_normalized"
    assert caps.top_module == "aes_core"
    assert caps.aux_files == ("rtl/aes_sbox.v",)
    assert caps.default_timeout_s == 900.0
    assert caps.clock_metadata == {"clock_port": "clk", "clock_period_ns": "2.0"}
    assert caps.reset_metadata == {"reset_port": "rst_n", "active": "low"}
    assert caps.license_tag == "realbench-upstream"


def test_realbench_uses_sanity_check_not_gate_level_functional_recheck():
    """RealBench accepts PPA on the pre-synth RTL gate + a non-degeneracy sanity
    check (its large sequential modules mismatch at gate level), so the gate-level
    functional re-check is OFF; other synthesizable suites keep it ON."""
    realbench = resolve_benchmark_capabilities("RealBench", supports_reference_ppa=True)
    assert realbench.gate_level_functional_recheck is False
    rtllm = resolve_benchmark_capabilities("RTLLM", supports_reference_ppa=True)
    assert rtllm.gate_level_functional_recheck is True


def test_unknown_family_uses_generic_defaults():
    caps = resolve_benchmark_capabilities("SomeNewSuite", supports_reference_ppa=True)

    assert is_known_benchmark_family("SomeNewSuite") is False
    assert caps.benchmark_family == "somenewsuite"
    assert caps.supports_synthesis is True
    assert caps.quality_objective_policy == "functional_only"
    assert caps.ppa_mode == "absolute_only"
    assert derive_quality_mode(caps) == "functional_only"


def test_family_helpers_match_known_suites():
    assert canonical_benchmark_family("RTLLM") == "rtllm"
    assert family_infers_circuit_type("VerilogEval-Spec-to-RTL") is True
    assert family_infers_circuit_type("VerilogEval-Code-Complete") is False
    assert family_infers_circuit_type("cvdp") is False
    assert is_known_benchmark_family("cvdp") is True


def test_as_dict_round_trip_is_json_friendly():
    caps = resolve_benchmark_capabilities(
        "cvdp",
        supports_reference_ppa=True,
        aux_files=("docs/spec.md",),
    )
    payload = caps.as_dict()

    assert payload["benchmark_family"] == "cvdp"
    assert payload["ppa_mode"] == "none"
    assert payload["aux_files"] == ["docs/spec.md"]
    assert isinstance(payload["clock_metadata"], dict)
    assert isinstance(payload["notes"], list)
    assert payload["license_tag"] == "no_commercial"
    expected_keys = {
        "benchmark_name",
        "benchmark_family",
        "supports_functional",
        "functional_harness_kind",
        "supports_synthesis",
        "supports_post_synth_check",
        "gate_level_functional_recheck",
        "supports_reference_ppa",
        "ppa_mode",
        "quality_objective_policy",
        "allows_reference_normalized_ppa",
        "workload_class",
        "top_module",
        "clock_metadata",
        "reset_metadata",
        "aux_files",
        "default_timeout_s",
        "license_tag",
        "notes",
    }
    assert set(payload) == expected_keys
