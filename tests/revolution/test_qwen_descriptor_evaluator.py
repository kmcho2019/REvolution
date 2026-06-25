import json
from pathlib import Path
from typing import cast

import numpy as np
import pytest

from revolution.algorithm import Heuristic
from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator
from revolution.qd.engine import QDEngine
from revolution.qwen_descriptor_evaluator import (
    QwenProjectionArtifact,
    canonical_qwen_rtl,
    load_qwen_projection_artifact,
    qwen_projection_values,
)
from revolution.runtime import CandidateEvaluator, CandidateWorkItem, ProblemContext


class _FakeVerilogEvaluator:
    def __init__(self, result: dict[str, object]) -> None:
        self.result = result

    def evaluate(self, *args: object, **kwargs: object) -> dict[str, object]:
        return dict(self.result)


class _FakeSynthesisEvaluator:
    def __init__(self, result: dict[str, object]) -> None:
        self.result = result

    def evaluate(self, *args: object, **kwargs: object) -> dict[str, object]:
        return dict(self.result)


def _context(tmp_path: Path) -> ProblemContext:
    bench = tmp_path / "bench"
    bench.mkdir()
    prompt = bench / "Prob_prompt.txt"
    test_sv = bench / "Prob_test.sv"
    ref_sv = bench / "Prob_ref.sv"
    prompt.write_text("desc", encoding="utf-8")
    test_sv.write_text("module tb; endmodule\n", encoding="utf-8")
    ref_sv.write_text("module ref; endmodule\n", encoding="utf-8")
    (bench / "synthesis_top_module_names.json").write_text(
        '{"Prob":"TopA"}',
        encoding="utf-8",
    )
    return ProblemContext(
        benchmark_name="Bench",
        problem_name="Prob",
        benchmark_path=bench,
        prompt_path=prompt,
        problem_description="desc",
        test_sv_path=test_sv,
        ref_sv_path=ref_sv,
        top_module_names_path=bench / "synthesis_top_module_names.json",
        testbench_top_module="tb",
    )


def test_canonical_qwen_rtl_normalizes_identifier_roles() -> None:
    left = """
    module Foo(input a, output y);
      wire temp;
      assign temp = a;
      assign y = temp;
    endmodule
    """
    right = """
    module Bar(input in0, output out0);
      wire n42;
      assign n42 = in0;
      assign out0 = n42;
    endmodule
    """

    assert canonical_qwen_rtl(left) == canonical_qwen_rtl(right)


def test_qwen_projection_values_use_frozen_artifact() -> None:
    artifact = QwenProjectionArtifact(
        model_id="fake",
        axes=("qwen_pc0", "qwen_pc1"),
        mean=(1.0, 2.0, 3.0),
        components=((1.0, 0.0, 0.0), (0.0, 0.5, -0.5)),
    )

    values = qwen_projection_values(np.asarray([2.0, 4.0, 1.0]), artifact)

    assert values == pytest.approx({"qwen_pc0": 1.0, "qwen_pc1": 2.0})


def test_load_qwen_projection_artifact_checks_shape(tmp_path: Path) -> None:
    path = tmp_path / "qwen_projection.json"
    path.write_text(
        json.dumps(
            {
                "artifact_kind": "qwen_canonical_rtl_projection_v0",
                "model_id": "fake",
                "axes": ["qwen_pc0"],
                "mean": [0.0, 0.0],
                "components": [[1.0, 0.0]],
            }
        ),
        encoding="utf-8",
    )

    artifact = load_qwen_projection_artifact(path)

    assert artifact.axes == ("qwen_pc0",)
    assert artifact.mean == (0.0, 0.0)


def test_qd_engine_extracts_qwen_descriptor_values(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    descriptor_file = _qwen_descriptor_file(tmp_path)

    class FakeQwenEvaluator:
        def __init__(self, artifact_path: Path) -> None:
            assert artifact_path.name == "qwen_projection.json"

        def extract_metrics(self, code: str) -> dict[str, float]:
            assert "module" in code
            return {"qwen_pc0": 0.25, "qwen_pc1": -0.5}

    monkeypatch.setattr(
        "revolution.qd.engine.QwenCanonicalRTLEmbeddingEvaluator",
        FakeQwenEvaluator,
    )
    engine = object.__new__(QDEngine)
    engine.qd_descriptor_file = str(descriptor_file)
    engine._qwen_rtl_embedding_evaluator = None
    engine._archive_axes = lambda: ("qwen_pc0", "qwen_pc1")
    candidate = Heuristic("thought", "module Top; endmodule", "feedback")

    values = QDEngine._extract_candidate_descriptor_values(
        engine,
        candidate,
        {"synthesis_success": True, "ppa_success": True},
    )

    assert values == {"qwen_pc0": 0.25, "qwen_pc1": -0.5}


def test_candidate_evaluator_extracts_qwen_descriptor_values(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    descriptor_file = _qwen_descriptor_file(tmp_path)
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module TopA; endmodule\n", encoding="utf-8")

    class FakeQwenEvaluator:
        def __init__(self, artifact_path: Path) -> None:
            assert artifact_path.name == "qwen_projection.json"

        def extract_metrics(self, code: str) -> dict[str, float]:
            assert "TopA" in code
            return {"qwen_pc0": 0.75, "qwen_pc1": -0.25}

    monkeypatch.setattr(
        "revolution.runtime.candidate_evaluator.QwenCanonicalRTLEmbeddingEvaluator",
        FakeQwenEvaluator,
    )
    evaluator = CandidateEvaluator(
        context=_context(tmp_path),
        problem_description="desc",
        verilog_evaluator=cast(
            VerilogEvaluator,
            _FakeVerilogEvaluator(
                {
                    "status": "success",
                    "simulation_stdout": "Mismatches: 0\n",
                    "simulation_stderr": "",
                    "compilation_stderr": "",
                }
            ),
        ),
        synthesis_evaluator=cast(
            SynthesisEvaluator,
            _FakeSynthesisEvaluator(
                {
                    "synthesis_success": True,
                    "synthesis_functionality_success": True,
                    "ppa_success": True,
                    "ppa_metrics": {"power": 0.9, "area": 90.0, "eff_clk_period": 0.9},
                    "structural_metrics": {"total_cells": 2.0},
                }
            ),
        ),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        descriptor_profile="qwen_test",
        descriptor_file=str(descriptor_file),
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module TopA; endmodule", code_file_path=str(code_path))
    )

    assert result.status == "success"
    assert result.descriptor_values["qwen_pc0"] == pytest.approx(0.75)
    assert result.descriptor_values["qwen_pc1"] == pytest.approx(-0.25)


def _qwen_descriptor_file(tmp_path: Path) -> Path:
    artifact_path = tmp_path / "qwen_projection.json"
    artifact_path.write_text(
        json.dumps(
            {
                "artifact_kind": "qwen_canonical_rtl_projection_v0",
                "model_id": "fake",
                "axes": ["qwen_pc0", "qwen_pc1"],
                "mean": [0.0, 0.0],
                "components": [[1.0, 0.0], [0.0, 1.0]],
            }
        ),
        encoding="utf-8",
    )
    descriptor_file = tmp_path / "profiles.yaml"
    descriptor_file.write_text(
        "qwen_projection_artifact: qwen_projection.json\n"
        "profiles:\n"
        "  qwen_test:\n"
        "    - qwen_pc0\n"
        "    - qwen_pc1\n",
        encoding="utf-8",
    )
    return descriptor_file
