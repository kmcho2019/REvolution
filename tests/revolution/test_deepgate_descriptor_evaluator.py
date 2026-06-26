import json
import subprocess
from pathlib import Path
from typing import cast

import numpy as np
import pytest

from revolution.algorithm import Heuristic
from revolution.deepgate_descriptor_evaluator import (
    DeepGatePooledDescriptorEvaluator,
    DeepGateProjectionArtifact,
    deepgate_projection_values,
    load_deepgate_projection_artifact,
)
from revolution.evaluation import SynthesisEvaluator, VerilogEvaluator
from revolution.qd.descriptors import (
    descriptor_requirements,
    load_deepgate_projection_artifact_path,
    resolve_descriptor_axes,
)
from revolution.qd.engine import QDEngine
from revolution.runtime import CandidateEvaluator, CandidateWorkItem, ProblemContext


class _FakeVerilogEvaluator:
    def evaluate(self, *args: object, **kwargs: object) -> dict[str, object]:
        return {
            "status": "success",
            "simulation_stdout": "Mismatches: 0\n",
            "simulation_stderr": "",
            "compilation_stderr": "",
        }


class _FakeSynthesisEvaluator:
    def evaluate(self, *args: object, **kwargs: object) -> dict[str, object]:
        return {
            "synthesis_success": True,
            "synthesis_functionality_success": True,
            "ppa_success": True,
            "ppa_metrics": {"power": 0.9, "area": 90.0, "eff_clk_period": 0.9},
            "structural_metrics": {"total_cells": 2.0},
        }


def test_deepgate_projection_values_use_frozen_artifact() -> None:
    artifact = DeepGateProjectionArtifact(
        axes=("deepgate_pool_pc0", "deepgate_pool_pc1"),
        mean=(1.0, 2.0),
        components=((1.0, 0.0), (0.0, 0.5)),
    )

    values = deepgate_projection_values(np.asarray([3.0, 6.0]), artifact)

    assert values == pytest.approx(
        {"deepgate_pool_pc0": 2.0, "deepgate_pool_pc1": 2.0}
    )


def test_load_deepgate_projection_artifact_checks_shape(tmp_path: Path) -> None:
    path = _projection_artifact(tmp_path)

    artifact = load_deepgate_projection_artifact(path)

    assert artifact.axes == ("deepgate_pool_pc0", "deepgate_pool_pc1")
    assert artifact.mean == (0.0, 0.0)


def test_deepgate_descriptor_profile_resolves_without_ppa(tmp_path: Path) -> None:
    descriptor_file = _deepgate_descriptor_file(tmp_path)

    axes = resolve_descriptor_axes(
        profile_name="deepgate_test",
        explicit_axes=None,
        descriptor_file=descriptor_file,
        archive_type="grid",
        circuit_type="sequential",
    )
    requirements = descriptor_requirements(axes)

    assert axes == ["deepgate_pool_pc0", "deepgate_pool_pc1"]
    assert requirements["requires_deepgate_pooled_embedding"] is True
    assert requirements["requires_ppa"] is False
    assert load_deepgate_projection_artifact_path(descriptor_file).name == (
        "deepgate_projection.json"
    )


def test_deepgate_evaluator_reads_subprocess_metrics(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    artifact_path = _projection_artifact(tmp_path)
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module Top; endmodule\n", encoding="utf-8")
    (tmp_path / "exp/diversity_check/encoder_envs/deepgate3_probe/bin").mkdir(
        parents=True
    )
    deepgate_python = (
        tmp_path / "exp/diversity_check/encoder_envs/deepgate3_probe/bin/python"
    )
    deepgate_python.write_text("", encoding="utf-8")
    (tmp_path / "scripts").mkdir()
    (tmp_path / "scripts/extract_deepgate_pooled_metrics.py").write_text(
        "",
        encoding="utf-8",
    )
    evaluator = DeepGatePooledDescriptorEvaluator(
        artifact_path,
        repo_root=tmp_path,
    )

    def fake_run(args: list[str]) -> subprocess.CompletedProcess[str]:
        output_path = Path(args[args.index("--output-json") + 1])
        output_path.write_text(
            json.dumps(
                {
                    "metrics": {
                        "deepgate_pool_pc0": 0.25,
                        "deepgate_pool_pc1": -0.5,
                    }
                }
            ),
            encoding="utf-8",
        )
        return subprocess.CompletedProcess(args, 0, "", "")

    monkeypatch.setattr(evaluator, "_run", fake_run)

    metrics = evaluator.extract_metrics(
        code_file_path=code_path,
        top_module_name="Top",
    )

    assert metrics == {"deepgate_pool_pc0": 0.25, "deepgate_pool_pc1": -0.5}


def test_qd_engine_extracts_deepgate_descriptor_values(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    descriptor_file = _deepgate_descriptor_file(tmp_path)

    class FakeDeepGateEvaluator:
        def __init__(self, artifact_path: Path) -> None:
            assert artifact_path.name == "deepgate_projection.json"

        def extract_metrics(
            self,
            *,
            code_file_path: str,
            top_module_name: str,
        ) -> dict[str, float]:
            assert Path(code_file_path).name == "candidate.sv"
            assert top_module_name == "Top"
            return {"deepgate_pool_pc0": 0.5, "deepgate_pool_pc1": -0.25}

    monkeypatch.setattr(
        "revolution.qd.engine.DeepGatePooledDescriptorEvaluator",
        FakeDeepGateEvaluator,
    )
    engine = object.__new__(QDEngine)
    engine.qd_descriptor_file = str(descriptor_file)
    engine._deepgate_pooled_evaluator = None
    engine._archive_axes = lambda: ("deepgate_pool_pc0", "deepgate_pool_pc1")

    def refresh_candidate_code_path(candidate: Heuristic) -> str:
        assert candidate.code
        return str(tmp_path / "candidate.sv")

    engine._refresh_candidate_code_path = refresh_candidate_code_path
    engine._resolve_synthesis_top_module_name = lambda: "Top"
    (tmp_path / "candidate.sv").write_text("module Top; endmodule\n", encoding="utf-8")
    candidate = Heuristic("thought", "module Top; endmodule", "feedback")

    values = QDEngine._extract_candidate_descriptor_values(
        engine,
        candidate,
        {"synthesis_success": True, "ppa_success": True},
    )

    assert values == {"deepgate_pool_pc0": 0.5, "deepgate_pool_pc1": -0.25}


def test_candidate_evaluator_extracts_deepgate_descriptor_values(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    descriptor_file = _deepgate_descriptor_file(tmp_path)
    code_path = tmp_path / "candidate.sv"
    code_path.write_text("module TopA; endmodule\n", encoding="utf-8")

    class FakeDeepGateEvaluator:
        def __init__(self, artifact_path: Path) -> None:
            assert artifact_path.name == "deepgate_projection.json"

        def extract_metrics(
            self,
            *,
            code_file_path: str,
            top_module_name: str,
        ) -> dict[str, float]:
            assert Path(code_file_path).name == "candidate.sv"
            assert top_module_name == "TopA"
            return {"deepgate_pool_pc0": 0.75, "deepgate_pool_pc1": -0.125}

    monkeypatch.setattr(
        "revolution.runtime.candidate_evaluator.DeepGatePooledDescriptorEvaluator",
        FakeDeepGateEvaluator,
    )
    evaluator = CandidateEvaluator(
        context=_context(tmp_path),
        problem_description="desc",
        verilog_evaluator=cast(VerilogEvaluator, _FakeVerilogEvaluator()),
        synthesis_evaluator=cast(SynthesisEvaluator, _FakeSynthesisEvaluator()),
        ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 1.0},
        descriptor_profile="deepgate_test",
        descriptor_file=str(descriptor_file),
    )

    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module TopA; endmodule", code_file_path=str(code_path))
    )

    assert result.status == "success"
    assert result.descriptor_values["deepgate_pool_pc0"] == pytest.approx(0.75)
    assert result.descriptor_values["deepgate_pool_pc1"] == pytest.approx(-0.125)


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


def _projection_artifact(tmp_path: Path) -> Path:
    path = tmp_path / "deepgate_projection.json"
    path.write_text(
        json.dumps(
            {
                "artifact_kind": "deepgate_pooled_projection_v0",
                "axes": ["deepgate_pool_pc0", "deepgate_pool_pc1"],
                "mean": [0.0, 0.0],
                "components": [[1.0, 0.0], [0.0, 1.0]],
            }
        ),
        encoding="utf-8",
    )
    return path


def _deepgate_descriptor_file(tmp_path: Path) -> Path:
    _projection_artifact(tmp_path)
    descriptor_file = tmp_path / "profiles.yaml"
    descriptor_file.write_text(
        "deepgate_projection_artifact: deepgate_projection.json\n"
        "profiles:\n"
        "  deepgate_test:\n"
        "    - deepgate_pool_pc0\n"
        "    - deepgate_pool_pc1\n",
        encoding="utf-8",
    )
    return descriptor_file
