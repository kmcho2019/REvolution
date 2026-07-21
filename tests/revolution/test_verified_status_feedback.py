import hashlib
import json
from pathlib import Path
from types import SimpleNamespace
from typing import Any, cast

import pytest

from revolution.algorithm import EoHEngine, Heuristic, HeuristicStatus
from revolution.verified_status_feedback.engine import (
    DEFAULT_PROMPT_ROOT,
    TELEMETRY_FILE,
    USE_TELEMETRY_FILE,
    VerifiedStatusFeedbackEngine,
)


FAILURE_STATUSES: tuple[HeuristicStatus, ...] = (
    "failed_format",
    "failed_diff",
    "failed_syntax",
    "failed_functionality",
    "failed_synthesis",
    "failed_synthesis_functionality",
)


def _fake_classic_init(self: Any, **kwargs: Any) -> None:
    self.population_pool_mode = kwargs["population_pool_mode"]
    self.classic_operator_kind = kwargs["classic_operator_kind"]
    self.eoh_success_operator_set = kwargs["eoh_success_operator_set"]
    self.strategy_selection_method = kwargs["strategy_selection_method"]
    self.generation_mode = kwargs["generation_mode"]
    self.require_strict_format = kwargs["require_strict_format"]
    root = kwargs["prompt_root"] or DEFAULT_PROMPT_ROOT
    self.prompts = SimpleNamespace(root_dir=str(root), profile=kwargs["prompt_profile"])
    self.diff_compact_context = True
    self.current_generation = 0
    self.logger = None


def _contract() -> dict[str, object]:
    return {
        "population_pool_mode": "dual",
        "classic_operator_kind": "eoh_strategies",
        "eoh_success_operator_set": "classic",
        "strategy_selection_method": "ucb",
        "generation_mode": "whole",
        "require_strict_format": True,
        "prompt_profile": "default",
        "prompt_root": None,
    }


def _candidate(tmp_path: Path, status: HeuristicStatus) -> Heuristic:
    sample = tmp_path / status
    sample.mkdir()
    code = sample / "code.sv"
    code.write_text("module test; endmodule\n", encoding="utf-8")
    candidate = Heuristic("thought", code.read_text(), "before", status=status)
    candidate.id = status
    candidate.code_file_path = str(code)
    return candidate


def _fake_evaluate(self: Any, candidates: list[Heuristic]) -> None:
    for candidate in candidates:
        analysis = f"analysis:{candidate.id}"
        candidate.feedback = analysis
        artifact = Path(candidate.code_file_path.rsplit(".", 1)[0] + "_feedback.txt")
        artifact.write_text(
            f"Score: 7\nJustification: test\n\nANALYSIS:\n{analysis}",
            encoding="utf-8",
        )


def test_verified_status_feedback_transforms_only_failures(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)
    monkeypatch.setattr(EoHEngine, "_evaluate_candidates", _fake_evaluate)
    engine = VerifiedStatusFeedbackEngine(**_contract())
    engine.logger = SimpleNamespace(log_dir=str(tmp_path))
    candidates = [_candidate(tmp_path, status) for status in (*FAILURE_STATUSES, "success")]

    engine._evaluate_candidates(candidates)

    rows = [
        json.loads(line)
        for line in (tmp_path / TELEMETRY_FILE).read_text().splitlines()
    ]
    assert len(rows) == len(candidates)
    for candidate, row in zip(candidates, rows, strict=True):
        analysis = f"analysis:{candidate.id}"
        expected = (
            analysis
            if candidate.status == "success"
            else f"Verified terminal status: {candidate.status}\n{analysis}"
        )
        assert candidate.feedback == expected
        assert row["prefix_applied"] is (candidate.status != "success")
        assert row["critic_analysis_sha256"] == hashlib.sha256(
            analysis.encode()
        ).hexdigest()
        assert row["consumed_feedback_sha256"] == hashlib.sha256(
            expected.encode()
        ).hexdigest()
        artifact = Path(candidate.code_file_path.rsplit(".", 1)[0] + "_feedback.txt")
        assert artifact.read_text().endswith(analysis)
        assert row["code_feedback_sha256"] == hashlib.sha256(
            artifact.read_bytes()
        ).hexdigest()
    assert (tmp_path / USE_TELEMETRY_FILE).read_text() == ""


@pytest.mark.parametrize("status", ["new", "unexpected"])
def test_verified_status_feedback_rejects_unresolved_status(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, status: str
) -> None:
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)
    monkeypatch.setattr(EoHEngine, "_evaluate_candidates", _fake_evaluate)
    engine = VerifiedStatusFeedbackEngine(**_contract())
    engine.logger = SimpleNamespace(log_dir=str(tmp_path))
    candidate = _candidate(tmp_path, cast(HeuristicStatus, status))
    candidate.status = cast(Any, status)

    with pytest.raises(AssertionError):
        engine._evaluate_candidates([candidate])


def test_verified_status_feedback_clears_stale_telemetry_before_gen0(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)

    def fail_evaluation(self: Any, candidates: list[Heuristic]) -> None:
        raise RuntimeError("evaluation failed")

    monkeypatch.setattr(EoHEngine, "_evaluate_candidates", fail_evaluation)
    engine = VerifiedStatusFeedbackEngine(**_contract())
    engine.logger = SimpleNamespace(log_dir=str(tmp_path))
    for name in (TELEMETRY_FILE, USE_TELEMETRY_FILE):
        (tmp_path / name).write_text('{"stale": true}\n', encoding="utf-8")

    with pytest.raises(RuntimeError, match="evaluation failed"):
        engine._evaluate_candidates([])

    assert (tmp_path / TELEMETRY_FILE).read_text() == ""
    assert (tmp_path / USE_TELEMETRY_FILE).read_text() == ""


def test_verified_status_feedback_records_exact_failed_parent_payload(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)
    engine = VerifiedStatusFeedbackEngine(**_contract())
    engine.current_generation = 1
    engine.logger = SimpleNamespace(log_dir=str(tmp_path))
    path = tmp_path / USE_TELEMETRY_FILE
    path.write_text("", encoding="utf-8")
    parent = _candidate(tmp_path, "failed_syntax")
    parent.feedback = "Verified terminal status: failed_syntax\nanalysis"

    payload = engine._format_parent_for_prompt(parent)

    assert json.loads(payload)["feedback"] == parent.feedback
    row = json.loads(path.read_text())
    feedback = parent.feedback.encode()
    serialized = payload.encode()
    assert row == {
        "generation": 1,
        "parent_id": parent.id,
        "feedback_utf8_bytes": len(feedback),
        "feedback_sha256": hashlib.sha256(feedback).hexdigest(),
        "serialized_parent_utf8_bytes": len(serialized),
        "serialized_parent_sha256": hashlib.sha256(serialized).hexdigest(),
        "serialized_parent_payload": payload,
    }

    success = _candidate(tmp_path, "success")
    engine._format_parent_for_prompt(success)
    assert len(path.read_text().splitlines()) == 1


@pytest.mark.parametrize(
    ("field", "value"),
    [
        ("population_pool_mode", "single"),
        ("classic_operator_kind", "single_thought_operator"),
        ("eoh_success_operator_set", "one_parent"),
        ("strategy_selection_method", "random"),
        ("generation_mode", "diff"),
        ("require_strict_format", False),
        ("prompt_profile", "custom"),
    ],
)
def test_verified_status_feedback_asserts_classic_contract(
    monkeypatch: pytest.MonkeyPatch, field: str, value: object
) -> None:
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)
    contract = _contract()
    contract[field] = value

    with pytest.raises(AssertionError):
        VerifiedStatusFeedbackEngine(**contract)


def test_verified_status_feedback_rejects_prompt_root_override(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    monkeypatch.setattr(EoHEngine, "__init__", _fake_classic_init)
    contract = _contract()
    contract["prompt_root"] = str(tmp_path)

    with pytest.raises(AssertionError):
        VerifiedStatusFeedbackEngine(**contract)
