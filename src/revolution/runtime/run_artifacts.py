from __future__ import annotations

import datetime as dt
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any


def _json_default(value: Any) -> Any:
    if hasattr(value, "item"):
        return value.item()
    raise TypeError(f"Object of type {type(value).__name__} is not JSON serializable")


def add_legacy_strategy_key_alias(summary: dict[str, Any]) -> dict[str, Any]:
    """
    Ensure both summary strategy keys are present:
      - legacy: `accumulated_strategy_counts:`
      - canonical: `accumulated_strategy_counts`
    """
    fixed = dict(summary)
    canonical = fixed.get("accumulated_strategy_counts")
    legacy = fixed.get("accumulated_strategy_counts:")
    if canonical is None and isinstance(legacy, dict):
        fixed["accumulated_strategy_counts"] = legacy
    if legacy is None and isinstance(canonical, dict):
        fixed["accumulated_strategy_counts:"] = canonical
    return fixed


@dataclass(frozen=True)
class ArtifactPaths:
    log_dir: Path
    generation_log_path: Path
    summary_path: Path


class ArtifactWriter:
    """Backend-agnostic writer for run artifacts."""

    def __init__(
        self,
        save_path: str | Path,
        model_name: str,
        benchmark_name: str,
        problem_name: str,
    ) -> None:
        root = Path(save_path).resolve()
        model_dir = model_name.replace("/", "_")
        log_dir = root / model_dir / benchmark_name / problem_name
        log_dir.mkdir(parents=True, exist_ok=True)
        generation_log_path = log_dir / "generation_log.jsonl"
        summary_path = log_dir / f"{problem_name}_summary.json"
        if generation_log_path.exists():
            generation_log_path.unlink()
        self.paths = ArtifactPaths(
            log_dir=log_dir,
            generation_log_path=generation_log_path,
            summary_path=summary_path,
        )

    def candidate_dir(self, generation: int, label: str) -> Path:
        directory = self.paths.log_dir / f"Gen{generation}" / label
        directory.mkdir(parents=True, exist_ok=True)
        return directory

    def write_candidate(
        self,
        *,
        generation: int,
        label: str,
        code: str,
        thought: str,
        metadata: dict[str, Any] | None = None,
    ) -> tuple[str, str]:
        """
        Write candidate artifacts and return (code_path, thought_path).
        """
        directory = self.candidate_dir(generation, label)
        code_path = directory / "code.sv"
        thought_path = directory / "thought.txt"
        code_path.write_text(str(code), encoding="utf-8")
        thought_path.write_text(str(thought), encoding="utf-8")
        if metadata:
            meta_path = directory / "candidate_metadata.json"
            payload = {"written_at": dt.datetime.now(dt.timezone.utc).isoformat(), **metadata}
            meta_path.write_text(
                json.dumps(payload, indent=2, default=_json_default),
                encoding="utf-8",
            )
        return str(code_path), str(thought_path)

    def append_generation_log(self, payload: dict[str, Any]) -> None:
        serializable = dict(payload)
        serializable.setdefault(
            "timestamp_utc", dt.datetime.now(dt.timezone.utc).isoformat()
        )
        with self.paths.generation_log_path.open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(serializable, default=_json_default) + "\n")

    def write_summary(self, summary: dict[str, Any]) -> str:
        payload = add_legacy_strategy_key_alias(summary)
        payload.setdefault("generated_at", dt.datetime.now(dt.timezone.utc).isoformat())
        self.paths.summary_path.write_text(
            json.dumps(payload, indent=2, default=_json_default),
            encoding="utf-8",
        )
        return str(self.paths.summary_path)
