import json
from pathlib import Path

from revolution.runtime import (
    CVDPEvaluator,
    CandidateWorkItem,
    build_cvdp_problem_context,
    load_cvdp_record,
    select_cvdp_ids,
)


def _write_dataset(path: Path) -> None:
    record_a = {
        "id": "cvdp_a",
        "categories": ["cid002", "medium"],
        "input": {"prompt": "Build A", "context": {}},
        "output": {"response": "", "context": {"rtl/a.sv": ""}},
        "harness": {
            "files": {
                "src/.env": "VERILOG_SOURCES=\nPYTHONPATH=\n",
                "src/test_runner.py": "def test_smoke():\n    assert True\n",
            }
        },
    }
    record_b = {
        "id": "cvdp_b",
        "categories": ["cid003"],
        "input": {"prompt": "Build B", "context": {}},
        "output": {"response": "", "context": {"rtl/b.sv": ""}},
        "harness": {
            "files": {
                "src/.env": "VERILOG_SOURCES=\nPYTHONPATH=\n",
                "src/test_runner.py": "def test_smoke():\n    assert True\n",
            }
        },
    }
    path.write_text(
        json.dumps(record_a) + "\n" + json.dumps(record_b) + "\n",
        encoding="utf-8",
    )


def test_cvdp_record_lookup_and_selection(tmp_path):
    dataset = tmp_path / "cvdp.jsonl"
    _write_dataset(dataset)

    record = load_cvdp_record(dataset, "cvdp_a")
    assert record is not None
    assert record["id"] == "cvdp_a"

    ids = select_cvdp_ids(dataset, ["cid003"], None)
    assert ids == ["cvdp_b"]


def test_build_cvdp_problem_context(tmp_path):
    dataset = tmp_path / "cvdp.jsonl"
    _write_dataset(dataset)
    record = load_cvdp_record(dataset, "cvdp_a")
    assert record is not None

    context = build_cvdp_problem_context(
        benchmark_name="cvdp",
        cvdp_id="cvdp_a",
        jsonl_path=dataset,
        cvdp_record=record,
    )

    assert context.problem_name == "cvdp_a"
    assert context.problem_description == "Build A"
    assert context.benchmark_name == "cvdp"


def test_cvdp_evaluator_success_path(monkeypatch, tmp_path):
    dataset = tmp_path / "cvdp.jsonl"
    _write_dataset(dataset)
    record = load_cvdp_record(dataset, "cvdp_a")
    assert record is not None
    context = build_cvdp_problem_context(
        benchmark_name="cvdp",
        cvdp_id="cvdp_a",
        jsonl_path=dataset,
        cvdp_record=record,
    )

    evaluator = CVDPEvaluator(
        context=context,
        cvdp_jsonl_path=str(dataset),
        cvdp_id="cvdp_a",
    )

    monkeypatch.setattr(
        evaluator,
        "_run_pytest",
        lambda **kwargs: ("success", "ok", "", 0),
    )
    monkeypatch.setattr(
        evaluator.rtl_descriptor_evaluator,
        "extract_metrics",
        lambda **kwargs: {"assign_count": 1.0, "if_count": 0.0},
    )

    code_file = tmp_path / "candidate" / "code.sv"
    code_file.parent.mkdir(parents=True, exist_ok=True)
    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="module a; endmodule\n", code_file_path=str(code_file))
    )

    assert result.status == "success"
    assert result.score == 1.0
    assert result.stage_statuses["functionality"] is True
    assert result.rtl_metrics["assign_count"] == 1.0


def test_cvdp_evaluator_marks_syntax_failure(monkeypatch, tmp_path):
    dataset = tmp_path / "cvdp.jsonl"
    _write_dataset(dataset)
    record = load_cvdp_record(dataset, "cvdp_a")
    assert record is not None
    context = build_cvdp_problem_context(
        benchmark_name="cvdp",
        cvdp_id="cvdp_a",
        jsonl_path=dataset,
        cvdp_record=record,
    )

    evaluator = CVDPEvaluator(
        context=context,
        cvdp_jsonl_path=str(dataset),
        cvdp_id="cvdp_a",
    )

    monkeypatch.setattr(
        evaluator,
        "_run_pytest",
        lambda **kwargs: ("simulation_error", "", "syntax error near module", 1),
    )

    code_file = tmp_path / "candidate2" / "code.sv"
    code_file.parent.mkdir(parents=True, exist_ok=True)
    result = evaluator.evaluate_candidate(
        CandidateWorkItem(code="bad", code_file_path=str(code_file))
    )

    assert result.status == "failed_syntax"
    assert result.stage_statuses["syntax"] is False
