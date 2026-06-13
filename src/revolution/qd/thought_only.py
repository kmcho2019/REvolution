from __future__ import annotations

import json
import re
from dataclasses import asdict, dataclass, field
from typing import Any, Literal


RepresentationKind = Literal["code_individual", "thought_only"]
RepairKind = Literal["none", "bounded_local_repair"]
ThoughtAggregateStatus = Literal[
    "invalid_thought",
    "all_failed",
    "partial_success",
    "all_success",
]

THOUGHT_SPEC_FORMAT = "thought_spec_v1"
REQUIRED_THOUGHT_FIELDS = (
    "summary",
    "interface_contract",
    "timing_and_protocol",
    "state_and_datapath_plan",
    "edge_cases",
    "ppa_intent",
    "implementation_constraints",
)
_NON_ANSWERS = {"", "unknown", "n/a", "na", "none", "not sure", "unspecified"}
_JUSTIFIED_PLACEHOLDER_PREFIXES = (
    "not applicable because",
    "not specified by problem; assume",
)


@dataclass(frozen=True)
class ThoughtIndividual:
    """Thought-level genotype produced before any RTL sample is generated."""

    thought_id: str
    generation: int
    thought_spec: dict[str, str]
    raw_response: str
    parent_ids: list[str]
    parent_count: int
    parent_source: str
    qd_operator_kind: str
    strategy: str
    prompt_text: str
    parent_code: str = ""
    """Best successful parent's RTL, stashed for code-seeded realization
    (thought-guided incremental realization, doc 15 Fix B); empty when no
    successful coded parent exists (e.g. seed thoughts)."""


@dataclass(frozen=True)
class CodeSample:
    """One evaluated RTL realization of a thought genotype."""

    thought_id: str
    sample_index: int
    candidate_id: str
    status: str
    code_file_path: str
    quality_score: float | None
    ppa_success: bool
    ppa_metrics: dict[str, float]
    descriptor_values: dict[str, float]
    repair_attempts: int

    def to_json_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass(frozen=True)
class ThoughtEvaluation:
    """Aggregate archive/fail-pool decision for one thought genotype."""

    thought_id: str
    generation: int
    code_samples_per_thought: int
    sample_ids: list[str]
    sample_statuses: list[str]
    success_count: int
    success_rate: float
    aggregate_status: ThoughtAggregateStatus
    repair_kind: RepairKind
    repair_attempts_used: int
    representative_sample_id: str | None
    representative_quality_score: float | None
    representative_ppa_metrics: dict[str, float]
    representative_descriptor_values: dict[str, float]
    parent_ids: list[str]
    parent_source: str
    strategy: str
    qd_operator_kind: str
    prompt_profile: str
    representation_kind: str
    population_size: int
    thought_population_size: int
    validation_errors: list[str] = field(default_factory=list)
    sample_records: list[dict[str, Any]] = field(default_factory=list)
    repair_config: dict[str, Any] = field(default_factory=dict)

    def to_json_dict(self) -> dict[str, Any]:
        return asdict(self)


def parse_thought_spec(raw_text: str) -> tuple[dict[str, str] | None, list[str]]:
    """Parse and validate a strict `thought_spec_v1` JSON payload."""

    obj = _extract_json_obj(raw_text)
    if obj is None:
        return None, ["no JSON object found"]
    if not isinstance(obj, dict):
        return None, ["top-level value must be an object"]

    errors: list[str] = []
    if obj.get("format") != THOUGHT_SPEC_FORMAT:
        errors.append('missing/invalid "format":"thought_spec_v1"')
    if "code" in obj:
        errors.append('thought_spec_v1 must not contain "code"')

    spec: dict[str, str] = {"format": THOUGHT_SPEC_FORMAT}
    for field_name in REQUIRED_THOUGHT_FIELDS:
        value = obj.get(field_name)
        if not isinstance(value, str):
            errors.append(f'{field_name} must be a non-empty string')
            continue
        stripped = value.strip()
        if _is_non_answer(stripped):
            errors.append(f"{field_name} must not be empty or a non-answer")
            continue
        spec[field_name] = stripped

    if errors:
        return None, errors
    return spec, []


def render_thought_spec(spec: dict[str, str]) -> str:
    """Render a validated thought spec for prompts and human artifacts."""

    lines = [f"format: {spec['format']}"]
    for field_name in REQUIRED_THOUGHT_FIELDS:
        lines.append(f"{field_name}: {spec[field_name]}")
    return "\n".join(lines)


def _is_non_answer(value: str) -> bool:
    lowered = value.strip().lower()
    if lowered.startswith(_JUSTIFIED_PLACEHOLDER_PREFIXES):
        return False
    return lowered in _NON_ANSWERS


def _extract_json_obj(text: str) -> dict[str, Any] | None:
    candidate = text.strip()
    if candidate.startswith("```"):
        candidate = re.sub(r"^```[a-zA-Z0-9]*\s*", "", candidate)
        candidate = re.sub(r"\s*```$", "", candidate)
    try:
        parsed = json.loads(candidate)
        return parsed if isinstance(parsed, dict) else None
    except json.JSONDecodeError:
        pass

    start = candidate.find("{")
    end = candidate.rfind("}")
    if start == -1 or end <= start:
        return None
    try:
        parsed = json.loads(candidate[start : end + 1])
    except json.JSONDecodeError:
        return None
    return parsed if isinstance(parsed, dict) else None
