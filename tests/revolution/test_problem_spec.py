from pathlib import Path

from revolution.runtime.problem_context import (
    ProblemContext,
    load_problem_context,
    resolve_testbench_top_module_from_path,
)
from revolution.runtime.problem_spec import (
    build_cvdp_problem_spec,
    build_problem_spec,
    infer_circuit_type_from_reference_ppa_path,
)


def _context(tmp_path: Path, benchmark_name: str, problem_name: str = "Prob001") -> ProblemContext:
    bench = tmp_path / benchmark_name
    bench.mkdir(parents=True, exist_ok=True)
    top_names = bench / "synthesis_top_module_names.json"
    top_names.write_text('{"Prob001":"TopA"}', encoding="utf-8")
    (bench / f"{problem_name}_prompt.txt").write_text("desc", encoding="utf-8")
    (bench / f"{problem_name}_test.sv").write_text("module tb; endmodule\n", encoding="utf-8")
    (bench / f"{problem_name}_ref.sv").write_text("module ref; endmodule\n", encoding="utf-8")
    return ProblemContext(
        benchmark_name=benchmark_name,
        problem_name=problem_name,
        benchmark_path=bench,
        prompt_path=bench / f"{problem_name}_prompt.txt",
        problem_description="desc",
        test_sv_path=bench / f"{problem_name}_test.sv",
        ref_sv_path=bench / f"{problem_name}_ref.sv",
        top_module_names_path=top_names,
    )


def test_build_problem_spec_defaults_rtllm_to_ppa_and_small_problem_modes(tmp_path):
    bench = tmp_path / "RTLLM"
    bench.mkdir(parents=True, exist_ok=True)
    (bench / "Prob001_ppa.txt").write_text(
        "tns,wns,eff_clk_period,power,area\n0,0,0.55,1,1\n",
        encoding="utf-8",
    )
    spec = build_problem_spec(_context(tmp_path, "RTLLM"), supports_reference_ppa=True)

    assert spec.quality_mode == "ppa"
    assert spec.circuit_type == "sequential"
    assert spec.top_module == "TopA"
    assert spec.testbench_top_module == "tb"
    assert spec.default_descriptor_profile == "hybrid_seq_default"
    assert spec.phase_generation_defaults == {
        "fail": "whole",
        "seed": "whole",
        "backfill": "whole",
        "refine": "diff",
        "crossover": "whole",
    }


def test_build_problem_spec_defaults_realbench_to_diff_heavy_large_problem_modes(tmp_path):
    spec = build_problem_spec(
        _context(tmp_path, "RealBench"),
        supports_reference_ppa=False,
    )

    assert spec.quality_mode == "functional_only"
    assert spec.default_descriptor_profile == "rtl_core"
    assert spec.phase_generation_defaults["backfill"] == "diff"
    assert spec.phase_generation_defaults["refine"] == "diff"


def test_build_problem_spec_infers_combinational_circuit_type_from_reference_ppa(tmp_path):
    bench = tmp_path / "VerilogEval-Spec-to-RTL"
    bench.mkdir(parents=True, exist_ok=True)
    (bench / "Prob001_ppa.txt").write_text(
        "tns,wns,eff_clk_period,power,area\n0,0,0.0,1,1\n",
        encoding="utf-8",
    )

    spec = build_problem_spec(
        _context(tmp_path, "VerilogEval-Spec-to-RTL"),
        supports_reference_ppa=True,
    )

    assert spec.circuit_type == "combinational"
    assert spec.default_descriptor_profile == "hybrid_comb_default"


def test_build_problem_spec_uses_unknown_when_reference_ppa_is_missing(tmp_path):
    spec = build_problem_spec(_context(tmp_path, "RTLLM"), supports_reference_ppa=True)

    assert spec.circuit_type == "unknown"
    assert spec.default_descriptor_profile == "hybrid_seq_default"


def test_build_cvdp_problem_spec_keeps_functional_only_and_large_problem_modes(tmp_path):
    spec = build_cvdp_problem_spec(
        _context(tmp_path, "cvdp", "cid002_demo"),
        cvdp_record={"categories": ["cid002"]},
        supports_reference_ppa=False,
    )

    assert spec.quality_mode == "functional_only"
    assert spec.supports_synthesis is False
    assert spec.phase_generation_defaults["backfill"] == "diff"
    assert spec.metadata["categories"] == "cid002"
    assert spec.testbench_top_module == "tb"


def test_load_problem_context_resolves_tb_module(tmp_path):
    bench = tmp_path / "RTLLM"
    bench.mkdir(parents=True, exist_ok=True)
    (bench / "Prob001_prompt.txt").write_text("desc", encoding="utf-8")
    (bench / "Prob001_test.sv").write_text("module tb; endmodule\n", encoding="utf-8")

    context = load_problem_context("RTLLM", "Prob001", tmp_path)

    assert context.testbench_top_module == "tb"


def test_load_problem_context_prefers_tb_when_helper_module_appears_first(tmp_path):
    bench = tmp_path / "VerilogEval-Spec-to-RTL"
    bench.mkdir(parents=True, exist_ok=True)
    (bench / "Prob001_prompt.txt").write_text("desc", encoding="utf-8")
    (bench / "Prob001_test.sv").write_text(
        "module stimulus_gen; endmodule\nmodule tb; endmodule\n",
        encoding="utf-8",
    )

    context = load_problem_context("VerilogEval-Spec-to-RTL", "Prob001", tmp_path)

    assert context.testbench_top_module == "tb"


def test_testbench_top_resolution_falls_back_to_last_module(tmp_path):
    test_sv = tmp_path / "fallback_test.sv"
    test_sv.write_text(
        "module helper; endmodule\nmodule harness; endmodule\n",
        encoding="utf-8",
    )

    assert resolve_testbench_top_module_from_path(test_sv) == "harness"


def test_infer_circuit_type_from_reference_ppa_path_handles_invalid_content(tmp_path):
    ppa_path = tmp_path / "invalid_ppa.txt"
    ppa_path.write_text("bad\ncontent\n", encoding="utf-8")

    assert infer_circuit_type_from_reference_ppa_path(ppa_path) == "unknown"
