"""Prompt-profile tuning helpers for GEPA campaigns.

The architecture is intentionally narrow:

1. Convert one `PromptStore` profile into one strict concat bundle.
2. Let GEPA mutate that bundle as a single text candidate.
3. Materialize each candidate back into a temporary prompt profile.
4. Score the resulting RTL/QD artifacts with deterministic gates.

The GEPA runner imports DSPy and GEPA directly. This module stays dependency
agnostic in practice because it only owns prompt bundles, proxy settings,
artifact scoring, and final validation.
"""

from __future__ import annotations

import hashlib
import json
import math
import shutil
import statistics
import subprocess
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any, Mapping, Sequence

import yaml

from revolution.prompt_store import CONCAT_END_RE, CONCAT_START_RE, PromptStore, _normalize_key
from revolution.vllm_preflight import preflight_vllm_model


JOURNAL_THOUGHT_ONLY_KEYS: tuple[str, ...] = (
    "system/thought_spec",
    "thought_only/generate_thought",
    "thought_only/code/whole",
    "evolve/single_thought_operator/thought",
    "thought_only/repair/whole",
)

HARD_SUBSET_CONFIG = Path("data/configs/hard_iteration_subset.yaml")


@dataclass(frozen=True)
class PromptBundle:
    """One strict concatenated prompt profile and its parsed sections."""

    profile: str
    sections: dict[str, str]
    text: str
    sha256: str


@dataclass(frozen=True)
class PromptTuningProblem:
    """One benchmark/problem pair used by a tuning proxy or validation gate."""

    benchmark: str
    problem: str

    @staticmethod
    def from_mapping(item: Mapping[str, Any]) -> "PromptTuningProblem":
        benchmark = item["benchmark"]
        problem = item["problem"]
        assert isinstance(benchmark, str)
        assert isinstance(problem, str)
        return PromptTuningProblem(benchmark=benchmark, problem=problem)


@dataclass(frozen=True)
class ProxySettings:
    """Small RTL/QD budget used inside a GEPA prompt-tuning campaign."""

    population_size: int = 20
    num_generations: int = 5
    total_worker_slots: int = 8
    max_active_problems: int = 4
    max_workers_per_problem: int = 4
    seed: int = 42
    max_tokens: int = 128000
    vllm_host: str = "host.docker.internal"
    vllm_port: int = 8000
    vllm_min_model_len: int = 128000
    vllm_preflight_timeout_s: float = 5.0


@dataclass(frozen=True)
class PromptTuningConfig:
    """All profile-specific choices required for a tuning campaign."""

    required_prompt_keys: tuple[str, ...]
    proxy_problems: tuple[PromptTuningProblem, ...]
    proxy_settings: ProxySettings

    @property
    def problem_pairs(self) -> tuple[tuple[str, str], ...]:
        return tuple((item.benchmark, item.problem) for item in self.proxy_problems)


@dataclass(frozen=True)
class ProblemMetrics:
    """Metrics extracted for one completed RTL/QD problem run."""

    benchmark: str
    problem: str
    functionality_pass_rate: float
    synthesis_pass_rate: float
    valid_ppa_sample_count: int
    average_score: float | None
    average_ppa_improvement: float | None
    area_improvement: float | None
    power_improvement: float | None
    clock_improvement: float | None
    qd_coverage: float | None
    occupied_cells: int | None
    qd_score: float | None


@dataclass(frozen=True)
class CandidateScore:
    """Deterministic score and diagnostics for one candidate run root."""

    status: str
    scalar_score: float
    errors: list[str]
    warnings: list[str]
    problem_metrics: list[ProblemMetrics]
    aggregates: dict[str, float | int | None]


@dataclass(frozen=True)
class GateResult:
    """Strict final validation result for optimized-vs-baseline comparison."""

    passed: bool
    errors: list[str]
    warnings: list[str]
    aggregates: dict[str, dict[str, float | int | None]]
    deltas: dict[str, float | None]


def default_prompt_tuning_config(
    settings: ProxySettings,
    proxy_problems: Sequence[PromptTuningProblem],
) -> PromptTuningConfig:
    """Return the thought-only GEPA configuration for an explicit proxy set."""

    assert proxy_problems
    return PromptTuningConfig(
        required_prompt_keys=JOURNAL_THOUGHT_ONLY_KEYS,
        proxy_settings=settings,
        proxy_problems=tuple(proxy_problems),
    )


def load_prompt_tuning_problems(path: Path) -> tuple[PromptTuningProblem, ...]:
    """Load proxy problems from YAML/JSON.

    Accepted shapes are either a top-level list of `{benchmark, problem}` rows
    or a mapping with a `problems` key containing that list.
    """

    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    if isinstance(payload, dict):
        payload = payload["problems"]
    assert isinstance(payload, list)
    return tuple(PromptTuningProblem.from_mapping(item) for item in payload)


def prompt_bundle_hash(text: str) -> str:
    """Hash a bundle exactly as GEPA and reports see it."""

    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def format_prompt_bundle(sections: Mapping[str, str], ordered_keys: Sequence[str]) -> str:
    """Serialize prompt sections into the native `PromptStore` concat format."""

    blocks: list[str] = []
    for raw_key in ordered_keys:
        key = _normalize_key(raw_key)
        if key not in sections:
            raise ValueError(f"Missing prompt section: {key}")
        content = sections[key]
        if not content.strip():
            raise ValueError(f"Empty prompt section: {key}")
        blocks.append(
            f"===== PROMPT: {key} =====\n"
            f"{content.rstrip()}\n"
            "===== END PROMPT ====="
        )
    return "\n\n".join(blocks) + "\n"


def parse_prompt_bundle(text: str, expected_keys: Sequence[str]) -> dict[str, str]:
    """Parse a concat bundle and fail on any non-exact section shape."""

    expected = tuple(_normalize_key(key) for key in expected_keys)
    expected_set = set(expected)
    sections: dict[str, str] = {}
    lines = text.splitlines()
    i = 0
    while i < len(lines):
        start = CONCAT_START_RE.match(lines[i])
        if start is None:
            if lines[i].strip():
                raise ValueError(f"Unexpected text outside prompt block on line {i + 1}")
            i += 1
            continue
        key = _normalize_key(start.group(1))
        if key in sections:
            raise ValueError(f"Duplicate prompt section: {key}")
        if key not in expected_set:
            raise ValueError(f"Unexpected prompt section: {key}")
        i += 1
        body: list[str] = []
        while i < len(lines) and CONCAT_END_RE.match(lines[i]) is None:
            body.append(lines[i])
            i += 1
        if i == len(lines):
            raise ValueError(f"Unclosed prompt section: {key}")
        content = "\n".join(body).rstrip() + "\n"
        if not content.strip():
            raise ValueError(f"Empty prompt section: {key}")
        sections[key] = content
        i += 1

    missing = [key for key in expected if key not in sections]
    if missing:
        raise ValueError(f"Missing prompt sections: {', '.join(missing)}")
    return {key: sections[key] for key in expected}


def export_prompt_bundle(
    prompt_root: Path,
    profile: str,
    expected_keys: Sequence[str] = JOURNAL_THOUGHT_ONLY_KEYS,
) -> PromptBundle:
    """Read a profile from disk and return its strict concat bundle."""

    store = PromptStore(root_dir=str(prompt_root), profile=profile)
    sections: dict[str, str] = {}
    for raw_key in expected_keys:
        key = _normalize_key(raw_key)
        value = store.read(key)
        if value is None:
            raise FileNotFoundError(prompt_root / profile / f"{key}.txt")
        if not value.strip():
            raise ValueError(f"Empty prompt section: {key}")
        sections[key] = value
    text = format_prompt_bundle(sections, expected_keys)
    return PromptBundle(
        profile=profile,
        sections=parse_prompt_bundle(text, expected_keys),
        text=text,
        sha256=prompt_bundle_hash(text),
    )


def materialize_prompt_profile(
    *,
    prompt_root: Path,
    profile: str,
    bundle_text: str,
    expected_keys: Sequence[str] = JOURNAL_THOUGHT_ONLY_KEYS,
    overwrite: bool = False,
) -> PromptBundle:
    """Write a strict bundle back to `data/prompts/<profile>` style files."""

    target_dir = prompt_root / profile
    if target_dir.exists():
        if not overwrite:
            raise FileExistsError(target_dir)
        shutil.rmtree(target_dir)
    sections = parse_prompt_bundle(bundle_text, expected_keys)
    store = PromptStore(root_dir=str(prompt_root), profile=profile)
    for key, content in sections.items():
        store.write(key, content)
    written_keys = store.list_keys()
    expected = sorted(_normalize_key(key) for key in expected_keys)
    if written_keys != expected:
        raise ValueError(
            f"Materialized profile keys mismatch: got {written_keys}, expected {expected}"
        )
    text = format_prompt_bundle(sections, expected_keys)
    return PromptBundle(
        profile=profile,
        sections=sections,
        text=text,
        sha256=prompt_bundle_hash(text),
    )


def changed_prompt_sections(
    baseline: Mapping[str, str],
    candidate: Mapping[str, str],
) -> list[str]:
    """Return prompt keys whose text differs between two parsed bundles."""

    return [
        key
        for key in sorted(set(baseline) | set(candidate))
        if baseline.get(key) != candidate.get(key)
    ]


def load_env_file(path: Path = Path("/workspace/.env")) -> None:
    """Load the shared workspace environment file when it exists."""

    if path.is_file():
        from dotenv import load_dotenv

        load_dotenv(path)


def preflight_rtl_vllm(settings: ProxySettings) -> str:
    """Return the vLLM model id after enforcing the required context window."""

    result = preflight_vllm_model(
        host=settings.vllm_host,
        port=settings.vllm_port,
        min_model_len=settings.vllm_min_model_len,
        timeout_s=settings.vllm_preflight_timeout_s,
    )
    model_id = result.get("model_id")
    if not isinstance(model_id, str) or not model_id:
        raise RuntimeError(f"vLLM preflight did not report a model id: {result}")
    max_model_len = result.get("max_model_len")
    if isinstance(max_model_len, int) and max_model_len < settings.vllm_min_model_len:
        raise RuntimeError(
            f"vLLM max_model_len={max_model_len} below required "
            f"{settings.vllm_min_model_len}"
        )
    return model_id


def run_proxy_evaluation(
    *,
    repo_root: Path,
    prompt_root: Path,
    prompt_profile: str,
    run_root: Path,
    config: PromptTuningConfig,
    model_name: str,
) -> None:
    """Run the real RTL/QD proxy for one materialized prompt profile."""

    run_root.mkdir(parents=True, exist_ok=True)
    settings = config.proxy_settings
    benchmarks = list(dict.fromkeys(item.benchmark for item in config.proxy_problems))
    problems = [item.problem for item in config.proxy_problems]
    cmd = [
        sys.executable,
        str(repo_root / "scripts" / "run_backend.py"),
        "--backend",
        "revolution",
        "--search_mode",
        "revolution_qd",
        "--benchmarks",
        *benchmarks,
        "--problems",
        *problems,
        "--api_backend",
        "vllm",
        "--vllm_host",
        settings.vllm_host,
        "--vllm_port",
        str(settings.vllm_port),
        "--vllm_min_model_len",
        str(settings.vllm_min_model_len),
        "--model_name",
        model_name,
        "--population_size",
        str(settings.population_size),
        "--num_generations",
        str(settings.num_generations),
        "--total_worker_slots",
        str(settings.total_worker_slots),
        "--max_active_problems",
        str(settings.max_active_problems),
        "--max_workers_per_problem",
        str(settings.max_workers_per_problem),
        "--evaluation_mode",
        "search_accelerated",
        "--accelerated_synthesis_top_k",
        "1",
        "--temperature",
        "1.0",
        "--top_p",
        "1.0",
        "--max_tokens",
        str(settings.max_tokens),
        "--diff_max_tokens",
        str(settings.max_tokens),
        "--save_path",
        str(run_root),
        "--no-backend_subdir",
        "--seed",
        str(settings.seed),
        "--prompt_root",
        str(prompt_root),
        "--prompt_profile",
        prompt_profile,
        "--qd_archive_type",
        "grid_quantile",
        "--qd_descriptor_profile",
        "journal_logic_ff_width_3d",
        "--qd_num_cells",
        "16",
        "--qd_grid_quantile_warmup_successes",
        "20",
        "--qd_fill_target_fraction",
        "0.25",
        "--qd_cell_reservoir",
        "2",
        "--qd_cell_mode",
        "pareto_front",
        "--qd_max_elites_per_cell",
        "5",
        "--qd_objectives",
        "ppa",
        "--qd_two_parent_probability",
        "0.5",
        "--qd_operator_kind",
        "single_thought_operator",
        "--qd_operator_one_parent_fraction",
        "0.5",
        "--qd_operator_archive_context_size",
        "4",
        "--qd_operator_two_parent_allow_intra_bin",
        "--representation_kind",
        "thought_only",
        "--code_samples_per_thought",
        "4",
        "--representative_sample",
        "best_successful_quality",
        "--repair_kind",
        "none",
        "--repair_max_attempts_per_sample",
        "0",
        "--repair_max_attempts_per_thought",
        "0",
        "--repair_evidence",
        "stage_scoped_logs",
    ]
    completed = subprocess.run(cmd, cwd=repo_root, text=True)
    if completed.returncode != 0:
        raise RuntimeError(f"Proxy evaluation failed with exit code {completed.returncode}")


def load_subset_problems(config_path: Path) -> list[tuple[str, str]]:
    """Load the frozen hard-subset benchmark/problem list."""

    payload = yaml.safe_load(config_path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    selected = payload.get("selected_problems")
    assert isinstance(selected, list)
    problems: list[tuple[str, str]] = []
    for item in selected:
        assert isinstance(item, dict)
        benchmark = item["benchmark"]
        problem = item["problem"]
        assert isinstance(benchmark, str)
        assert isinstance(problem, str)
        problems.append((benchmark, problem))
    return problems


def _safe_float(value: Any) -> float | None:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(parsed):
        return None
    return parsed


def _safe_rate(value: Any) -> float:
    parsed = _safe_float(value)
    if parsed is None:
        return 0.0
    return max(0.0, min(1.0, parsed))


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _summary_paths(root: Path) -> list[Path]:
    return [
        path
        for path in sorted(root.rglob("*_summary.json"))
        if path.name not in {"archive_summary.json", "global_pareto_summary.json"}
    ]


def _problem_summary_path(run_root: Path, benchmark: str, problem: str) -> Path | None:
    direct = run_root / benchmark / problem / f"{problem}_summary.json"
    if direct.is_file():
        return direct
    matches = [
        path
        for path in _summary_paths(run_root)
        if path.parent.name == problem and path.parent.parent.name == benchmark
    ]
    return matches[-1] if matches else None


def _extract_rates(summary: Mapping[str, Any]) -> tuple[float, float]:
    rates = summary.get("accumulated_success_rates")
    if not isinstance(rates, dict):
        rates = summary.get("success_rates")
    if not isinstance(rates, dict):
        rates = {}
    functionality = rates.get("total_functionality", rates.get("functionality"))
    synthesis = rates.get("total_synthesis_ppa", rates.get("synthesis_ppa", rates.get("synthesis")))
    return _safe_rate(functionality), _safe_rate(synthesis)


def _generation_ppa_details(problem_root: Path) -> list[dict[str, Any]]:
    details: list[dict[str, Any]] = []
    generation_log = problem_root / "generation_log.jsonl"
    if not generation_log.is_file():
        return details
    for raw_line in generation_log.read_text(encoding="utf-8").splitlines():
        if not raw_line.strip():
            continue
        payload = json.loads(raw_line)
        assert isinstance(payload, dict)
        row_details = payload.get("population_ppa_details", [])
        assert isinstance(row_details, list)
        details.extend(item for item in row_details if isinstance(item, dict))
    return details


def _ppa_details(summary: Mapping[str, Any], summary_path: Path) -> list[dict[str, Any]]:
    generation_details = _generation_ppa_details(summary_path.parent)
    if generation_details:
        return generation_details
    raw_details = summary.get("final_population_ppa_details", [])
    if isinstance(raw_details, list):
        return [item for item in raw_details if isinstance(item, dict)]
    return []


def _best_detail_metrics(details: Sequence[Mapping[str, Any]]) -> dict[str, Any]:
    scored: list[tuple[float, Mapping[str, Any]]] = []
    for detail in details:
        score = _safe_float(detail.get("score"))
        if score is not None:
            scored.append((score, detail))
    if not scored:
        return {}
    metrics = max(scored, key=lambda item: item[0])[1].get("ppa_metrics", {})
    return metrics if isinstance(metrics, dict) else {}


def _mean_ppa_improvement(best_metrics: Mapping[str, Any], ref_metrics: Mapping[str, Any]) -> float | None:
    gains: list[float] = []
    for key in ("area", "power", "eff_clk_period"):
        gain = _metric_improvement(best_metrics, ref_metrics, key)
        if gain is not None:
            gains.append(gain)
    return statistics.fmean(gains) if gains else None


def _metric_improvement(
    best_metrics: Mapping[str, Any],
    ref_metrics: Mapping[str, Any],
    key: str,
) -> float | None:
    best = _safe_float(best_metrics.get(key))
    ref = _safe_float(ref_metrics.get(key))
    if best is None or ref is None or ref == 0.0:
        return None
    return (ref - best) / ref


def _average_score(summary: Mapping[str, Any], details: Sequence[Mapping[str, Any]]) -> float | None:
    final_ppa = summary.get("final_population_ppa", {})
    if isinstance(final_ppa, dict):
        score = _safe_float(final_ppa.get("average_score"))
        if score is not None:
            return score
    scores = [
        score
        for detail in details
        if (score := _safe_float(detail.get("score"))) is not None
    ]
    return statistics.fmean(scores) if scores else None


def _archive_metrics(summary_path: Path) -> tuple[float | None, int | None, float | None]:
    archive_path = summary_path.parent / "archive_summary.json"
    if not archive_path.is_file():
        return None, None, None
    payload = _load_json(archive_path)
    occupied = payload.get("occupied_cells")
    return (
        _safe_float(payload.get("coverage")),
        int(occupied) if isinstance(occupied, int) else None,
        _safe_float(payload.get("qd_score")),
    )


def _summary_errors(summary: Mapping[str, Any], summary_path: Path) -> list[str]:
    errors: list[str] = []
    for key in ("worker_errors", "errors"):
        value = summary.get(key)
        if isinstance(value, list) and value:
            errors.append(f"{summary_path}: {key} is non-empty")
    return errors


def _thought_json_errors(problem_root: Path) -> list[str]:
    errors: list[str] = []
    for path in sorted(problem_root.rglob("thought_evaluation.json")):
        try:
            payload = _load_json(path)
        except json.JSONDecodeError as exc:
            errors.append(f"{path}: malformed JSON: {exc}")
            continue
        if "aggregate_status" not in payload:
            errors.append(f"{path}: missing aggregate_status")
        if "code_samples_per_thought" not in payload:
            errors.append(f"{path}: missing code_samples_per_thought")
        sample_records = payload.get("sample_records", [])
        if not isinstance(sample_records, list):
            errors.append(f"{path}: sample_records is not a list")
    return errors


def load_problem_metrics(
    run_root: Path,
    benchmark: str,
    problem: str,
) -> tuple[ProblemMetrics | None, list[str], list[str]]:
    """Load one problem summary plus QD and thought-only sidecar diagnostics."""

    errors: list[str] = []
    warnings: list[str] = []
    summary_path = _problem_summary_path(run_root, benchmark, problem)
    if summary_path is None:
        return None, [f"Missing summary for {benchmark}/{problem} under {run_root}"], warnings
    summary = _load_json(summary_path)
    errors.extend(_summary_errors(summary, summary_path))
    errors.extend(_thought_json_errors(summary_path.parent))
    functionality, synthesis = _extract_rates(summary)
    details = _ppa_details(summary, summary_path)
    final_ppa = summary.get("final_population_ppa", {})
    best_metrics = {}
    if isinstance(final_ppa, dict) and isinstance(final_ppa.get("best_metrics"), dict):
        best_metrics = final_ppa["best_metrics"]
    if not best_metrics:
        best_metrics = _best_detail_metrics(details)
    ref_metrics = summary.get("ref_ppa_metric", {})
    if not isinstance(ref_metrics, dict):
        ref_metrics = {}
    qd_coverage, occupied_cells, qd_score = _archive_metrics(summary_path)
    metrics = ProblemMetrics(
        benchmark=benchmark,
        problem=problem,
        functionality_pass_rate=functionality,
        synthesis_pass_rate=synthesis,
        valid_ppa_sample_count=len(details),
        average_score=_average_score(summary, details),
        average_ppa_improvement=_mean_ppa_improvement(best_metrics, ref_metrics),
        area_improvement=_metric_improvement(best_metrics, ref_metrics, "area"),
        power_improvement=_metric_improvement(best_metrics, ref_metrics, "power"),
        clock_improvement=_metric_improvement(best_metrics, ref_metrics, "eff_clk_period"),
        qd_coverage=qd_coverage,
        occupied_cells=occupied_cells,
        qd_score=qd_score,
    )
    if qd_coverage is None:
        warnings.append(f"{benchmark}/{problem}: missing archive coverage")
    return metrics, errors, warnings


def aggregate_metrics(rows: Sequence[ProblemMetrics]) -> dict[str, float | int | None]:
    """Aggregate per-problem metrics into the campaign/validation score surface."""

    score_values = [row.average_score for row in rows if row.average_score is not None]
    ppa_values = [
        row.average_ppa_improvement
        for row in rows
        if row.average_ppa_improvement is not None
    ]
    area_values = [row.area_improvement for row in rows if row.area_improvement is not None]
    power_values = [row.power_improvement for row in rows if row.power_improvement is not None]
    clock_values = [row.clock_improvement for row in rows if row.clock_improvement is not None]
    coverage_values = [row.qd_coverage for row in rows if row.qd_coverage is not None]
    occupied_values = [row.occupied_cells for row in rows if row.occupied_cells is not None]
    qd_score_values = [row.qd_score for row in rows if row.qd_score is not None]
    return {
        "problem_count": len(rows),
        "functionality_pass_rate": statistics.fmean(
            [row.functionality_pass_rate for row in rows]
        )
        if rows
        else None,
        "synthesis_pass_rate": statistics.fmean([row.synthesis_pass_rate for row in rows])
        if rows
        else None,
        "valid_ppa_sample_count": sum(row.valid_ppa_sample_count for row in rows),
        "designs_with_valid_ppa": sum(1 for row in rows if row.valid_ppa_sample_count > 0),
        "average_score": statistics.fmean(score_values) if score_values else None,
        "average_ppa_improvement": statistics.fmean(ppa_values) if ppa_values else None,
        "area_improvement": statistics.fmean(area_values) if area_values else None,
        "power_improvement": statistics.fmean(power_values) if power_values else None,
        "clock_improvement": statistics.fmean(clock_values) if clock_values else None,
        "qd_coverage": statistics.fmean(coverage_values) if coverage_values else None,
        "occupied_cells": statistics.fmean(occupied_values) if occupied_values else None,
        "qd_score": statistics.fmean(qd_score_values) if qd_score_values else None,
    }


def score_run_root(
    run_root: Path,
    problems: Sequence[PromptTuningProblem],
    *,
    require_valid_ppa_each_problem: bool = True,
) -> CandidateScore:
    """Score a completed run root over an explicit problem list."""

    errors: list[str] = []
    warnings: list[str] = []
    rows: list[ProblemMetrics] = []
    for problem_ref in problems:
        metrics, problem_errors, problem_warnings = load_problem_metrics(
            run_root,
            problem_ref.benchmark,
            problem_ref.problem,
        )
        errors.extend(problem_errors)
        warnings.extend(problem_warnings)
        if metrics is None:
            continue
        if require_valid_ppa_each_problem and metrics.valid_ppa_sample_count == 0:
            errors.append(
                f"{problem_ref.benchmark}/{problem_ref.problem}: zero valid PPA samples"
            )
        rows.append(metrics)
    aggregates = aggregate_metrics(rows)
    scalar_score = _candidate_scalar_score(aggregates)
    return CandidateScore(
        status="failed" if errors else "ok",
        scalar_score=0.0 if errors else scalar_score,
        errors=errors,
        warnings=warnings,
        problem_metrics=rows,
        aggregates=aggregates,
    )


def _candidate_scalar_score(aggregates: Mapping[str, float | int | None]) -> float:
    functionality = float(aggregates.get("functionality_pass_rate") or 0.0)
    synthesis = float(aggregates.get("synthesis_pass_rate") or 0.0)
    valid_ppa = min(float(aggregates.get("valid_ppa_sample_count") or 0.0) / 32.0, 1.0)
    average_score = max(float(aggregates.get("average_score") or 0.0), 0.0)
    ppa = max(float(aggregates.get("average_ppa_improvement") or 0.0), 0.0)
    coverage = max(float(aggregates.get("qd_coverage") or 0.0), 0.0)
    qd_score = min(max(float(aggregates.get("qd_score") or 0.0) / 10.0, 0.0), 1.0)
    return (
        0.20 * functionality
        + 0.20 * synthesis
        + 0.20 * valid_ppa
        + 0.15 * average_score
        + 0.15 * ppa
        + 0.05 * coverage
        + 0.05 * qd_score
    )


def candidate_objective_scores(score: CandidateScore) -> dict[str, float]:
    """Return higher-is-better objective scores for GEPA Pareto tracking."""

    aggregates = score.aggregates
    problem_count = max(float(aggregates.get("problem_count") or 1.0), 1.0)
    designs_with_ppa = float(aggregates.get("designs_with_valid_ppa") or 0.0)
    valid_ppa = float(aggregates.get("valid_ppa_sample_count") or 0.0)
    return {
        "all_problems_have_valid_ppa": 1.0 if score.status == "ok" else 0.0,
        "designs_with_valid_ppa": designs_with_ppa / problem_count,
        "functionality_pass_rate": float(aggregates.get("functionality_pass_rate") or 0.0),
        "synthesis_pass_rate": float(aggregates.get("synthesis_pass_rate") or 0.0),
        "valid_ppa_sample_count": min(valid_ppa / 58.0, 1.0),
        "area_improvement": max(float(aggregates.get("area_improvement") or 0.0), 0.0),
        "power_improvement": max(float(aggregates.get("power_improvement") or 0.0), 0.0),
        "clock_improvement": max(float(aggregates.get("clock_improvement") or 0.0), 0.0),
        "average_score": max(float(aggregates.get("average_score") or 0.0), 0.0),
        "qd_coverage": max(float(aggregates.get("qd_coverage") or 0.0), 0.0),
    }


def validate_optimized_against_baselines(
    *,
    classic_root: Path,
    baseline_root: Path,
    optimized_root: Path,
    subset_config: Path,
    min_improvement_pp: float = 1.0,
    require_full_subset: bool = True,
) -> GateResult:
    problem_pairs = load_subset_problems(subset_config)
    if require_full_subset and len(problem_pairs) != 13:
        raise ValueError(f"Expected 13 hard-subset problems, got {len(problem_pairs)}")
    problems = tuple(
        PromptTuningProblem(benchmark, problem)
        for benchmark, problem in problem_pairs
    )
    scores = {
        "classic": score_run_root(
            classic_root,
            problems,
            require_valid_ppa_each_problem=False,
        ),
        "baseline_thought_only": score_run_root(
            baseline_root,
            problems,
            require_valid_ppa_each_problem=False,
        ),
        "optimized_thought_only": score_run_root(
            optimized_root,
            problems,
            require_valid_ppa_each_problem=True,
        ),
    }
    errors: list[str] = []
    warnings: list[str] = []
    for name, score in scores.items():
        for error in score.errors:
            errors.append(f"{name}: {error}")
        for warning in score.warnings:
            warnings.append(f"{name}: {warning}")

    baseline = scores["baseline_thought_only"].aggregates
    optimized = scores["optimized_thought_only"].aggregates
    deltas = _metric_deltas(optimized, baseline)
    _check_no_regression(
        errors=errors,
        optimized=optimized,
        baseline=baseline,
        metric="functionality_pass_rate",
        tolerance=0.05,
    )
    _check_no_regression(
        errors=errors,
        optimized=optimized,
        baseline=baseline,
        metric="synthesis_pass_rate",
        tolerance=0.05,
    )
    _check_no_regression(
        errors=errors,
        optimized=optimized,
        baseline=baseline,
        metric="valid_ppa_sample_count",
        tolerance=0.10,
    )
    for metric in ("qd_coverage", "occupied_cells", "qd_score"):
        _check_no_regression(
            errors=errors,
            optimized=optimized,
            baseline=baseline,
            metric=metric,
            tolerance=0.25,
        )
    if (
        (deltas.get("average_score_pp") or -1e9) < min_improvement_pp
        and (deltas.get("average_ppa_improvement_pp") or -1e9) < min_improvement_pp
    ):
        errors.append(
            "optimized profile did not improve mean score or mean PPA by "
            f"{min_improvement_pp:.1f} percentage point"
        )
    return GateResult(
        passed=not errors,
        errors=errors,
        warnings=warnings,
        aggregates={name: score.aggregates for name, score in scores.items()},
        deltas=deltas,
    )


def _metric_deltas(
    optimized: Mapping[str, float | int | None],
    baseline: Mapping[str, float | int | None],
) -> dict[str, float | None]:
    out: dict[str, float | None] = {}
    for metric in (
        "functionality_pass_rate",
        "synthesis_pass_rate",
        "average_score",
        "average_ppa_improvement",
        "qd_coverage",
    ):
        opt = _safe_float(optimized.get(metric))
        base = _safe_float(baseline.get(metric))
        out[f"{metric}_pp"] = None if opt is None or base is None else (opt - base) * 100.0
    for metric in ("valid_ppa_sample_count", "occupied_cells", "qd_score"):
        opt = _safe_float(optimized.get(metric))
        base = _safe_float(baseline.get(metric))
        out[metric] = None if opt is None or base is None else opt - base
    return out


def _check_no_regression(
    *,
    errors: list[str],
    optimized: Mapping[str, float | int | None],
    baseline: Mapping[str, float | int | None],
    metric: str,
    tolerance: float,
) -> None:
    opt = _safe_float(optimized.get(metric))
    base = _safe_float(baseline.get(metric))
    if opt is None or base is None:
        return
    allowed = base * (1.0 - tolerance)
    if opt < allowed:
        errors.append(
            f"{metric} regressed: optimized={opt:.4f}, baseline={base:.4f}, "
            f"allowed_min={allowed:.4f}"
        )


def write_json(path: Path, payload: Mapping[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True), encoding="utf-8")


def as_jsonable(value: Any) -> Any:
    if hasattr(value, "__dataclass_fields__"):
        return asdict(value)
    if isinstance(value, Path):
        return str(value)
    if isinstance(value, list):
        return [as_jsonable(item) for item in value]
    if isinstance(value, tuple):
        return [as_jsonable(item) for item in value]
    if isinstance(value, dict):
        return {str(key): as_jsonable(item) for key, item in value.items()}
    return value


def render_campaign_markdown(payload: Mapping[str, Any]) -> str:
    candidates = list(payload.get("candidates", []))
    selected = payload.get("selected_candidate", {})
    usage = payload.get("openai_usage_summary", {})
    lines = [
        "# GEPA Prompt Tuning Report",
        "",
        f"- Campaign root: `{payload.get('campaign_root', '')}`",
        f"- Baseline profile: `{payload.get('baseline_profile', '')}`",
        f"- Optimized profile: `{payload.get('optimized_profile', '')}`",
        f"- Optimizer model: `{payload.get('optimizer_model', '')}`",
        f"- Optimizer temperature: `{payload.get('optimizer_temperature', '')}`",
        f"- Optimizer max tokens: `{payload.get('optimizer_max_tokens', '')}`",
        f"- Selected hash: `{selected.get('bundle_hash', '') if isinstance(selected, dict) else ''}`",
        f"- OpenAI calls: `{usage.get('call_count', 'N/A') if isinstance(usage, dict) else 'N/A'}`",
        f"- OpenAI known cost USD: `{usage.get('total_known_cost_usd', 'N/A') if isinstance(usage, dict) else 'N/A'}`",
        "",
        "## Candidate Ranking",
        "",
        "| Candidate | Status | Score | Bundle Hash | Run Root | Failure Reasons |",
        "|:---|:---|---:|:---|:---|:---|",
    ]
    for row in sorted(
        candidates,
        key=lambda item: float(item.get("score", 0.0) or 0.0),
        reverse=True,
    ):
        errors = row.get("errors", [])
        reason = "; ".join(str(error) for error in errors) if errors else ""
        lines.append(
            f"| `{row.get('candidate_id', '')}` | `{row.get('status', '')}` | "
            f"{float(row.get('score', 0.0) or 0.0):.4f} | "
            f"`{row.get('bundle_hash', '')}` | `{row.get('run_root', '')}` | "
            f"{reason} |"
        )
    lines.extend(["", "## Selected Candidate", ""])
    if isinstance(selected, dict) and selected:
        for key in ("candidate_id", "bundle_hash", "profile_path", "score"):
            lines.append(f"- {key}: `{selected.get(key, '')}`")
    else:
        lines.append("- none")
    lines.append("")
    return "\n".join(lines)


def render_validation_markdown(payload: Mapping[str, Any]) -> str:
    lines = [
        "# GEPA Prompt Tuning Validation",
        "",
        f"- Passed: `{payload.get('passed')}`",
        "",
        "## Aggregates",
        "",
        "| Mode | Func | Synth | Valid PPA | Designs With PPA | Avg Score | Avg PPA | Coverage | Occupied | QD Score |",
        "|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|",
    ]
    aggregates = payload.get("aggregates", {})
    if isinstance(aggregates, dict):
        for name, row in aggregates.items():
            assert isinstance(row, dict)
            lines.append(
                f"| `{name}` | {_fmt(row.get('functionality_pass_rate'))} | "
                f"{_fmt(row.get('synthesis_pass_rate'))} | "
                f"{_fmt(row.get('valid_ppa_sample_count'), 0)} | "
                f"{_fmt(row.get('designs_with_valid_ppa'), 0)} | "
                f"{_fmt(row.get('average_score'))} | "
                f"{_fmt(row.get('average_ppa_improvement'))} | "
                f"{_fmt(row.get('qd_coverage'))} | "
                f"{_fmt(row.get('occupied_cells'))} | {_fmt(row.get('qd_score'))} |"
            )
    lines.extend(["", "## Deltas", ""])
    deltas = payload.get("deltas", {})
    if isinstance(deltas, dict):
        for key, value in deltas.items():
            lines.append(f"- {key}: `{_fmt(value)}`")
    lines.extend(["", "## Errors", ""])
    errors = payload.get("errors", [])
    if errors:
        lines.extend(f"- {error}" for error in errors)
    else:
        lines.append("- none")
    lines.extend(["", "## Warnings", ""])
    warnings = payload.get("warnings", [])
    if warnings:
        lines.extend(f"- {warning}" for warning in warnings)
    else:
        lines.append("- none")
    lines.append("")
    return "\n".join(lines)


def _fmt(value: Any, digits: int = 4) -> str:
    parsed = _safe_float(value)
    if parsed is None:
        return "N/A"
    return f"{parsed:.{digits}f}"
