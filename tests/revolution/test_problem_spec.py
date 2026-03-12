from pathlib import Path

from revolution.runtime.problem_context import ProblemContext
from revolution.runtime.problem_spec import (
    build_cvdp_problem_spec,
    build_problem_spec,
)


def _context(tmp_path: Path, benchmark_name: str, problem_name: str = "Prob001") -> ProblemContext:
    bench = tmp_path / benchmark_name
    bench.mkdir(parents=True, exist_ok=True)
    top_names = bench / "synthesis_top_module_names.json"
    top_names.write_text('{"Prob001":"TopA"}', encoding="utf-8")
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
    spec = build_problem_spec(_context(tmp_path, "RTLLM"), supports_reference_ppa=True)

    assert spec.quality_mode == "ppa"
    assert spec.circuit_type == "sequential"
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
