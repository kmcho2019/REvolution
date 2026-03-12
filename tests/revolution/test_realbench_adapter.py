from __future__ import annotations

import json
from pathlib import Path

from revolution.runtime.realbench_adapter import (
    build_realbench_problem_context,
    build_realbench_problem_spec,
    load_realbench_record,
    load_realbench_reference_ppa_metrics,
    select_realbench_problem_ids,
)


def _build_realbench_root(tmp_path: Path) -> tuple[Path, dict[str, object]]:
    root = tmp_path / "RealBench"
    problem_dir = root / "module_a"
    problem_dir.mkdir(parents=True, exist_ok=True)
    (problem_dir / "prompt.txt").write_text("module prompt", encoding="utf-8")
    (problem_dir / "test.sv").write_text("module tb; endmodule", encoding="utf-8")
    (problem_dir / "ref.sv").write_text("module dut; endmodule", encoding="utf-8")
    (problem_dir / "ref_ppa.txt").write_text(
        "tns,wns,eff_clk_period,power,area\n-1.0,-0.1,1.2,0.5,120.0\n",
        encoding="utf-8",
    )
    record: dict[str, object] = {
        "problem_name": "rb_mod_a",
        "subset": "module",
        "prompt_path": "module_a/prompt.txt",
        "test_sv_path": "module_a/test.sv",
        "ref_sv_path": "module_a/ref.sv",
        "ppa_path": "module_a/ref_ppa.txt",
        "top_module": "rb_top",
        "supports_formal": True,
        "supports_synthesis": True,
        "aux_files": ["module_a/spec.md"],
    }
    (root / "module_manifest.json").write_text(
        json.dumps({"problems": [record]}, indent=2),
        encoding="utf-8",
    )
    return root, record


def test_select_realbench_problem_ids_filters_to_module_subset(tmp_path):
    root, _ = _build_realbench_root(tmp_path)
    ids = select_realbench_problem_ids(root, subset="module")
    assert ids == ["rb_mod_a"]


def test_build_realbench_problem_context_and_spec(tmp_path):
    root, record = _build_realbench_root(tmp_path)
    loaded = load_realbench_record(root, "rb_mod_a")
    assert loaded is not None

    context = build_realbench_problem_context(
        benchmark_name="RealBench",
        problem_name="rb_mod_a",
        realbench_root=root,
        realbench_record=loaded,
    )
    ppa = load_realbench_reference_ppa_metrics(root, loaded)
    spec = build_realbench_problem_spec(
        context,
        realbench_record=loaded,
        supports_reference_ppa=bool(ppa),
    )

    assert context.problem_description == "module prompt"
    assert spec.top_module == "rb_top"
    assert spec.quality_mode == "ppa"
    assert spec.supports_formal is True
    assert spec.default_descriptor_profile == "hybrid_phys_seq"
    assert spec.phase_generation_defaults["backfill"] == "diff"
    assert ppa["area"] == 120.0
