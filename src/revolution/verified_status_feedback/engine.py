"""REvolution engine that preserves failed candidates' terminal status."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any, assert_never

from revolution.algorithm import EoHEngine, Heuristic


DEFAULT_PROMPT_ROOT = Path(__file__).resolve().parents[3] / "data/prompts"
TELEMETRY_FILE = "verified_status_feedback_telemetry.jsonl"
USE_TELEMETRY_FILE = "verified_status_feedback_use_telemetry.jsonl"


class VerifiedStatusFeedbackEngine(EoHEngine):
    """Prepend the authoritative terminal status to failed-parent feedback."""

    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)
        assert self.population_pool_mode == "dual"
        assert self.classic_operator_kind == "eoh_strategies"
        assert self.eoh_success_operator_set == "classic"
        assert self.strategy_selection_method == "ucb"
        assert self.generation_mode == "whole"
        assert self.require_strict_format
        assert self.prompts.profile == "default"
        assert Path(self.prompts.root_dir).resolve() == DEFAULT_PROMPT_ROOT

    def _evaluate_candidates(self, candidates_to_evaluate: list[Heuristic]) -> None:
        """Run classic evaluation, preserve status, and record exact feedback bytes."""

        assert self.logger is not None
        telemetry_path = Path(self.logger.log_dir) / TELEMETRY_FILE
        use_telemetry_path = Path(self.logger.log_dir) / USE_TELEMETRY_FILE
        if self.current_generation == 0:
            telemetry_path.write_text("", encoding="utf-8")
            use_telemetry_path.write_text("", encoding="utf-8")

        super()._evaluate_candidates(candidates_to_evaluate)
        records = []
        for candidate in candidates_to_evaluate:
            analysis = candidate.feedback
            match candidate.status:
                case "success":
                    prefix_applied = False
                case (
                    "failed_format"
                    | "failed_diff"
                    | "failed_syntax"
                    | "failed_functionality"
                    | "failed_synthesis"
                    | "failed_synthesis_functionality"
                ):
                    candidate.feedback = (
                        f"Verified terminal status: {candidate.status}\n{analysis}"
                    )
                    prefix_applied = True
                case "new":
                    raise AssertionError("evaluated candidate retained status=new")
                case unknown:
                    assert_never(unknown)

            analysis_bytes = analysis.encode("utf-8")
            consumed_bytes = candidate.feedback.encode("utf-8")
            artifact = Path(
                candidate.code_file_path.rsplit(".", 1)[0] + "_feedback.txt"
            )
            assert artifact.is_file()
            records.append(
                {
                    "generation": candidate.generation,
                    "candidate_id": candidate.id,
                    "status": candidate.status,
                    "prefix_applied": prefix_applied,
                    "critic_analysis_utf8_bytes": len(analysis_bytes),
                    "critic_analysis_sha256": hashlib.sha256(
                        analysis_bytes
                    ).hexdigest(),
                    "consumed_feedback_utf8_bytes": len(consumed_bytes),
                    "consumed_feedback_sha256": hashlib.sha256(
                        consumed_bytes
                    ).hexdigest(),
                    "code_feedback_sha256": hashlib.sha256(
                        artifact.read_bytes()
                    ).hexdigest(),
                }
            )

        with telemetry_path.open("a", encoding="utf-8") as handle:
            for record in records:
                handle.write(json.dumps(record, sort_keys=True) + "\n")

    def _format_parent_for_prompt(
        self,
        parent: Heuristic,
        example_num: int = 1,
        include_code: bool = True,
        code_override: str | None = None,
    ) -> str:
        """Record the exact failed-parent payload returned by classic formatting."""

        payload = super()._format_parent_for_prompt(
            parent,
            example_num,
            include_code,
            code_override,
        )
        match parent.status:
            case "success":
                return payload
            case (
                "failed_format"
                | "failed_diff"
                | "failed_syntax"
                | "failed_functionality"
                | "failed_synthesis"
                | "failed_synthesis_functionality"
            ):
                pass
            case "new":
                raise AssertionError("unevaluated candidate selected as a parent")
            case unknown:
                assert_never(unknown)

        assert self.logger is not None
        feedback_bytes = parent.feedback.encode("utf-8")
        payload_bytes = payload.encode("utf-8")
        record = {
            "generation": self.current_generation,
            "parent_id": parent.id,
            "feedback_utf8_bytes": len(feedback_bytes),
            "feedback_sha256": hashlib.sha256(feedback_bytes).hexdigest(),
            "serialized_parent_utf8_bytes": len(payload_bytes),
            "serialized_parent_sha256": hashlib.sha256(payload_bytes).hexdigest(),
            "serialized_parent_payload": payload,
        }
        path = Path(self.logger.log_dir) / USE_TELEMETRY_FILE
        with path.open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(record, sort_keys=True) + "\n")
        return payload
