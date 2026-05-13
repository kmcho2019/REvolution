#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import importlib
import json
import math
import statistics
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any


SINGLE_OPERATOR = "single_thought_operator"
MAX_ACCEPTANCE_WORKERS = 16
FORBIDDEN_PROMPT_KEYS = {
    "code",
    "feedback",
    "individual_feedback",
    "simulation_log",
    "testbench_log",
    "synthesis_log",
    "compilation_log",
    "error_log",
    "logs",
}
ARCHIVE_CONTEXT_KEYS = {"thought", "evaluation_status", "quality_score"}


@dataclass
class ProblemMetrics:
    benchmark: str
    problem: str
    problem_root: str | None
    functionality_rate: float | None
    synthesis_rate: float | None
    valid_ppa_sample_count: int
    average_quality_score: float | None
    average_ppa_improvement: float | None
    errors: list[str]


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    if not path.is_file():
        return rows
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        payload = json.loads(line)
        assert isinstance(payload, dict)
        rows.append(payload)
    return rows


def _load_yaml(path: Path) -> dict[str, Any]:
    yaml = importlib.import_module("yaml")
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _csv_rows(path: Path) -> list[dict[str, str]]:
    if not path.is_file():
        return []
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def _safe_float(value: Any) -> float | None:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    if not math.isfinite(parsed):
        return None
    return parsed


def _mean(values: list[float]) -> float | None:
    return statistics.fmean(values) if values else None


def _expected_problems(path: Path) -> list[dict[str, str]]:
    config = _load_yaml(path)
    return [
        {"benchmark": str(item["benchmark"]), "problem": str(item["problem"])}
        for item in config["selected_problems"]
    ]


def _problem_root(run_root: Path, mode: str, benchmark: str, problem: str) -> Path | None:
    direct = run_root / mode / benchmark / problem
    for summary_name in ("archive_summary.json", f"{problem}_summary.json"):
        if (direct / summary_name).is_file():
            return direct
    for summary_name in ("archive_summary.json", f"{problem}_summary.json"):
        matches = sorted((run_root / mode).rglob(f"{benchmark}/{problem}/{summary_name}"))
        if matches:
            return matches[-1].parent
        matches = sorted((run_root / mode).rglob(f"{problem}/{summary_name}"))
        if matches:
            return matches[-1].parent
    return None


def _problem_summary_path(problem_root: Path, problem: str) -> Path | None:
    direct = problem_root / f"{problem}_summary.json"
    if direct.is_file():
        return direct
    summaries = [
        path
        for path in problem_root.glob("*_summary.json")
        if path.name not in {"archive_summary.json", "global_pareto_summary.json"}
    ]
    return summaries[0] if summaries else None


def _row_average_ppa(row: dict[str, str]) -> float | None:
    values = [
        parsed
        for key in ("g_P", "g_A", "g_T")
        if (parsed := _safe_float(row.get(key))) is not None
    ]
    return _mean(values)


def _summary_average_ppa(summary: dict[str, Any]) -> float | None:
    final_ppa = summary.get("final_population_ppa", {})
    if not isinstance(final_ppa, dict):
        return None
    best_metrics = final_ppa.get("best_metrics", {})
    ref_metrics = summary.get("ref_ppa_metric", {})
    if not isinstance(best_metrics, dict) or not isinstance(ref_metrics, dict):
        return None
    values: list[float] = []
    for key in ("area", "power", "eff_clk_period"):
        best = _safe_float(best_metrics.get(key))
        ref = _safe_float(ref_metrics.get(key))
        if best is None or ref is None or ref == 0.0:
            continue
        values.append((ref - best) / ref)
    return _mean(values)


def _detail_average_ppa(
    detail: dict[str, Any],
    ref_metrics: dict[str, Any],
) -> float | None:
    ppa_metrics = detail.get("ppa_metrics", {})
    if not isinstance(ppa_metrics, dict):
        return None
    values: list[float] = []
    for key in ("area", "power", "eff_clk_period"):
        best = _safe_float(ppa_metrics.get(key))
        ref = _safe_float(ref_metrics.get(key))
        if best is None or ref is None or ref == 0.0:
            continue
        values.append((ref - best) / ref)
    return _mean(values)


def _generation_ppa_details(problem_root: Path) -> list[dict[str, Any]]:
    details: list[dict[str, Any]] = []
    for row in _load_jsonl(problem_root / "generation_log.jsonl"):
        row_details = row.get("population_ppa_details", [])
        if not isinstance(row_details, list):
            continue
        for detail in row_details:
            if isinstance(detail, dict):
                details.append(detail)
    return details


def _collect_problem_metrics(
    *,
    run_root: Path,
    mode: str,
    benchmark: str,
    problem: str,
) -> ProblemMetrics:
    root = _problem_root(run_root, mode, benchmark, problem)
    errors: list[str] = []
    if root is None:
        return ProblemMetrics(
            benchmark=benchmark,
            problem=problem,
            problem_root=None,
            functionality_rate=None,
            synthesis_rate=None,
            valid_ppa_sample_count=0,
            average_quality_score=None,
            average_ppa_improvement=None,
            errors=[f"missing problem root for {mode}"],
        )

    summary_path = _problem_summary_path(root, problem)
    summary: dict[str, Any] = {}
    if summary_path is None:
        errors.append("missing problem summary")
    else:
        summary = _load_json(summary_path)

    rates = summary.get("accumulated_success_rates", {})
    if not isinstance(rates, dict):
        rates = {}
    functionality_rate = _safe_float(rates.get("functionality"))
    synthesis_rate = _safe_float(rates.get("synthesis_ppa"))

    generation_details = _generation_ppa_details(root)
    valid_ppa_sample_count = len(generation_details)
    archive_rows = _csv_rows(root / "archive_cells.csv")
    if archive_rows:
        quality_values = [
            parsed
            for row in archive_rows
            if (parsed := _safe_float(row.get("quality_score"))) is not None
        ]
        ppa_values = [
            parsed
            for row in archive_rows
            if (parsed := _row_average_ppa(row)) is not None
        ]
        return ProblemMetrics(
            benchmark=benchmark,
            problem=problem,
            problem_root=str(root),
            functionality_rate=functionality_rate,
            synthesis_rate=synthesis_rate,
            valid_ppa_sample_count=valid_ppa_sample_count or len(archive_rows),
            average_quality_score=_mean(quality_values),
            average_ppa_improvement=_mean(ppa_values),
            errors=errors,
        )

    if generation_details:
        ref_metrics = summary.get("ref_ppa_metric", {})
        if not isinstance(ref_metrics, dict):
            ref_metrics = {}
        quality_values = [
            parsed
            for detail in generation_details
            if (parsed := _safe_float(detail.get("score"))) is not None
        ]
        ppa_values = [
            parsed
            for detail in generation_details
            if (parsed := _detail_average_ppa(detail, ref_metrics)) is not None
        ]
        return ProblemMetrics(
            benchmark=benchmark,
            problem=problem,
            problem_root=str(root),
            functionality_rate=functionality_rate,
            synthesis_rate=synthesis_rate,
            valid_ppa_sample_count=len(generation_details),
            average_quality_score=_mean(quality_values),
            average_ppa_improvement=_mean(ppa_values),
            errors=errors,
        )

    final_ppa = summary.get("final_population_ppa", {})
    final_details = summary.get("final_population_ppa_details", [])
    valid_count = len(final_details) if isinstance(final_details, list) else 0
    avg_quality = None
    if isinstance(final_ppa, dict):
        avg_quality = _safe_float(final_ppa.get("average_score"))
        if valid_count == 0 and _safe_float(final_ppa.get("best_score")) is not None:
            valid_count = 1
    return ProblemMetrics(
        benchmark=benchmark,
        problem=problem,
        problem_root=str(root),
        functionality_rate=functionality_rate,
        synthesis_rate=synthesis_rate,
        valid_ppa_sample_count=valid_count,
        average_quality_score=avg_quality,
        average_ppa_improvement=_summary_average_ppa(summary),
        errors=errors,
    )


def _parse_manifest(path: Path) -> dict[str, str]:
    if not path.is_file():
        return {}
    payload: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        payload[key.strip()] = value.strip()
    return payload


def _operator_kind(problem_root: Path) -> str | None:
    summary_path = _problem_summary_path(problem_root, problem_root.name)
    if summary_path is None:
        return None
    payload = _load_json(summary_path)
    backend_details = payload.get("backend_details", {})
    if not isinstance(backend_details, dict):
        return None
    qd_config = backend_details.get("qd_config", {})
    if not isinstance(qd_config, dict):
        return None
    operator = qd_config.get("operator", {})
    if not isinstance(operator, dict):
        return None
    kind = operator.get("kind")
    return str(kind) if kind is not None else None


def _extract_context_json(prompt: str) -> dict[str, Any]:
    marker = "CONTEXT_JSON:"
    marker_index = prompt.find(marker)
    if marker_index < 0:
        raise ValueError("prompt snapshot missing CONTEXT_JSON marker")
    start = prompt.find("{", marker_index)
    if start < 0:
        raise ValueError("prompt snapshot missing JSON object")
    decoder = json.JSONDecoder()
    payload, _ = decoder.raw_decode(prompt[start:])
    if not isinstance(payload, dict):
        raise ValueError("CONTEXT_JSON is not an object")
    return payload


def _forbidden_key_paths(value: Any, prefix: str = "$") -> list[str]:
    paths: list[str] = []
    if isinstance(value, dict):
        for key, child in value.items():
            child_path = f"{prefix}.{key}"
            if str(key).lower() in FORBIDDEN_PROMPT_KEYS:
                paths.append(child_path)
            paths.extend(_forbidden_key_paths(child, child_path))
    elif isinstance(value, list):
        for index, child in enumerate(value):
            paths.extend(_forbidden_key_paths(child, f"{prefix}[{index}]"))
    return paths


def _read_if_present(path: Path) -> str | None:
    if not path.is_file():
        return None
    text = path.read_text(encoding="utf-8", errors="ignore").strip()
    return text or None


def _feedback_path_for_code(code_path: Path) -> Path:
    return code_path.with_name(f"{code_path.stem}_feedback.txt")


def _candidate_maps(problem_root: Path) -> tuple[dict[str, dict[str, Any]], dict[str, str]]:
    candidates_by_id: dict[str, dict[str, Any]] = {}
    for row in _load_jsonl(problem_root / "generation_log.jsonl"):
        generated = row.get("generated_candidates", [])
        if not isinstance(generated, list):
            continue
        for candidate in generated:
            if not isinstance(candidate, dict):
                continue
            candidate_id = candidate.get("id")
            if isinstance(candidate_id, str):
                candidates_by_id[candidate_id] = candidate

    cell_by_id: dict[str, str] = {}
    for event_path in problem_root.rglob("qd_archive_event.json"):
        event = _load_json(event_path)
        candidate_id = event.get("candidate_id")
        cell_id = event.get("cell_id")
        if isinstance(candidate_id, str) and isinstance(cell_id, str):
            cell_by_id[candidate_id] = cell_id
    return candidates_by_id, cell_by_id


def _validate_prompt_snapshot(
    *,
    prompt_path: Path,
    candidates_by_id: dict[str, dict[str, Any]],
    cell_by_id: dict[str, str],
) -> tuple[list[str], bool]:
    errors: list[str] = []
    metadata_path = prompt_path.with_name("prompt_snapshot.json")
    metadata = _load_json(metadata_path) if metadata_path.is_file() else {}
    prompt = prompt_path.read_text(encoding="utf-8", errors="ignore")
    try:
        context = _extract_context_json(prompt)
    except ValueError as exc:
        return [f"{prompt_path}: {exc}"], False

    if context.get("task") != SINGLE_OPERATOR:
        errors.append(f"{prompt_path}: context task is not {SINGLE_OPERATOR}")
    forbidden = _forbidden_key_paths(context)
    if forbidden:
        errors.append(f"{prompt_path}: forbidden prompt keys {forbidden}")

    archive_context = context.get("archive_context", [])
    if archive_context:
        if not isinstance(archive_context, list):
            errors.append(f"{prompt_path}: archive_context is not a list")
        else:
            for index, entry in enumerate(archive_context):
                if not isinstance(entry, dict):
                    errors.append(f"{prompt_path}: archive_context[{index}] is not an object")
                    continue
                extra = sorted(set(entry) - ARCHIVE_CONTEXT_KEYS)
                if extra:
                    errors.append(
                        f"{prompt_path}: archive_context[{index}] has extra keys {extra}"
                    )

    parent_ids = metadata.get("parent_ids", [])
    if not isinstance(parent_ids, list):
        parent_ids = []
    for parent_id in parent_ids:
        if not isinstance(parent_id, str):
            continue
        parent_info = candidates_by_id.get(parent_id)
        if not parent_info:
            continue
        code_file_path = parent_info.get("code_file_path")
        if not isinstance(code_file_path, str):
            continue
        code_text = _read_if_present(Path(code_file_path))
        if code_text and len(code_text) >= 20 and code_text in prompt:
            errors.append(f"{prompt_path}: contains parent code for {parent_id}")
        feedback_text = _read_if_present(_feedback_path_for_code(Path(code_file_path)))
        if feedback_text and len(feedback_text) >= 20 and feedback_text in prompt:
            errors.append(f"{prompt_path}: contains parent feedback for {parent_id}")

    same_cell = False
    if len(parent_ids) == 2 and all(isinstance(parent_id, str) for parent_id in parent_ids):
        left_cell = cell_by_id.get(str(parent_ids[0]))
        right_cell = cell_by_id.get(str(parent_ids[1]))
        same_cell = bool(left_cell and left_cell == right_cell)
    return errors, same_cell


def _validate_unified_problem(problem_root: Path) -> dict[str, Any]:
    errors: list[str] = []
    operator_candidate_count = 0
    one_parent_count = 0
    two_parent_count = 0

    log_rows = _load_jsonl(problem_root / "generation_log.jsonl")
    if not log_rows:
        errors.append("missing generation_log.jsonl")
    for row in log_rows:
        generation = int(row.get("generation", -1))
        generated = row.get("generated_candidates", [])
        if generation <= 0 or not isinstance(generated, list):
            continue
        for candidate in generated:
            if not isinstance(candidate, dict):
                continue
            if candidate.get("strategy") == "initial":
                continue
            operator_candidate_count += 1
            if candidate.get("strategy") != SINGLE_OPERATOR:
                errors.append(
                    f"generation {generation} candidate {candidate.get('id')} "
                    f"strategy is {candidate.get('strategy')}"
                )
            parent_count = candidate.get("parent_count")
            requested_parent_count = candidate.get("requested_parent_count", parent_count)
            if parent_count not in {1, 2}:
                errors.append(
                    f"generation {generation} candidate {candidate.get('id')} "
                    f"has parent_count={parent_count}"
                )
            if requested_parent_count not in {1, 2}:
                errors.append(
                    f"generation {generation} candidate {candidate.get('id')} "
                    f"has requested_parent_count={requested_parent_count}"
                )
            if candidate.get("origin_pool") == "fail_pool" and parent_count != 1:
                errors.append(
                    f"generation {generation} fail-pool candidate "
                    f"{candidate.get('id')} has parent_count={parent_count}"
                )
            if candidate.get("origin_pool") == "success_pool":
                if requested_parent_count == 1:
                    one_parent_count += 1
                elif requested_parent_count == 2:
                    two_parent_count += 1

    candidates_by_id, cell_by_id = _candidate_maps(problem_root)
    prompt_paths = sorted(problem_root.rglob("prompt_snapshot.txt"))
    if operator_candidate_count and len(prompt_paths) < operator_candidate_count:
        errors.append(
            f"expected at least {operator_candidate_count} prompt snapshots, "
            f"found {len(prompt_paths)}"
        )

    same_cell_seen = False
    for prompt_path in prompt_paths:
        prompt_errors, same_cell = _validate_prompt_snapshot(
            prompt_path=prompt_path,
            candidates_by_id=candidates_by_id,
            cell_by_id=cell_by_id,
        )
        errors.extend(prompt_errors)
        same_cell_seen = same_cell_seen or same_cell

    return {
        "valid": not errors,
        "errors": errors,
        "operator_candidate_count": operator_candidate_count,
        "prompt_snapshot_count": len(prompt_paths),
        "one_parent_count": one_parent_count,
        "two_parent_count": two_parent_count,
        "same_cell_two_parent_seen": same_cell_seen,
    }


def _paired_gate(
    *,
    name: str,
    unified: dict[str, ProblemMetrics],
    eoh: dict[str, ProblemMetrics],
    field: str,
    floor: float,
) -> dict[str, Any]:
    deltas: list[float] = []
    for key, unified_metrics in unified.items():
        eoh_metrics = eoh.get(key)
        if eoh_metrics is None:
            continue
        unified_value = getattr(unified_metrics, field)
        eoh_value = getattr(eoh_metrics, field)
        if unified_value is None or eoh_value is None:
            continue
        deltas.append(float(unified_value) - float(eoh_value))
    mean_delta = _mean(deltas)
    standard_error = 0.0
    if len(deltas) > 1:
        standard_error = statistics.stdev(deltas) / math.sqrt(len(deltas))
    threshold = floor if len(deltas) < 4 else max(2.0 * standard_error, floor)
    passed = bool(mean_delta is not None and mean_delta >= -threshold)
    return {
        "metric": name,
        "field": field,
        "paired_count": len(deltas),
        "mean_delta": mean_delta,
        "standard_error": standard_error,
        "floor": floor,
        "threshold": threshold,
        "passed": passed,
    }


def _write_report(path: Path, payload: dict[str, Any]) -> None:
    lines = [
        "# Single Thought Operator Validation",
        "",
        f"- valid: `{payload['valid']}`",
        f"- failure_count: `{payload['failure_count']}`",
        f"- problem_invalid_count: `{payload['problem_invalid_count']}`",
        f"- acceptance_error_count: `{payload['acceptance_error_count']}`",
        "",
        "## Paired Gates",
        "",
    ]
    for gate in payload["paired_gates"]:
        lines.append(
            f"- `{gate['metric']}`: enforced={gate.get('enforced', False)}, "
            f"passed={gate['passed']}, "
            f"paired={gate['paired_count']}, mean_delta={gate['mean_delta']}, "
            f"threshold=-{gate['threshold']}"
        )
    lines.extend(["", "## Operator Audit", ""])
    audit = payload["operator_audit"]
    lines.append(
        f"- prompt_snapshots: `{audit['prompt_snapshot_count']}`; "
        f"operator_candidates: `{audit['operator_candidate_count']}`"
    )
    lines.append(
        f"- requested_one_parent_count: `{audit['one_parent_count']}`; "
        f"requested_two_parent_count: `{audit['two_parent_count']}`"
    )
    lines.append(
        f"- same_cell_two_parent_seen: `{audit['same_cell_two_parent_seen']}`"
    )
    if payload["acceptance_errors"]:
        lines.extend(["", "## Acceptance Errors", ""])
        for error in payload["acceptance_errors"]:
            lines.append(f"- {error}")
    path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-root", required=True, type=Path)
    parser.add_argument("--subset-config", required=True, type=Path)
    parser.add_argument("--classic-mode", default="classic")
    parser.add_argument("--eoh-mode", required=True)
    parser.add_argument("--unified-mode", required=True)
    parser.add_argument("--require-full-subset", action="store_true")
    parser.add_argument("--acceptance-hard-subset", action="store_true")
    args = parser.parse_args(argv)

    expected = _expected_problems(args.subset_config)
    if not args.require_full_subset and not args.acceptance_hard_subset:
        observed = [
            item
            for item in expected
            if any(
                _problem_root(
                    args.run_root,
                    mode,
                    item["benchmark"],
                    item["problem"],
                )
                is not None
                for mode in (args.classic_mode, args.eoh_mode, args.unified_mode)
            )
        ]
        if observed:
            expected = observed
    acceptance_errors: list[str] = []
    if args.acceptance_hard_subset and len(expected) != 13:
        acceptance_errors.append(f"expected 13 hard-subset problems, found {len(expected)}")

    manifest = _parse_manifest(args.run_root / "hard_iteration_manifest.txt")
    if args.acceptance_hard_subset:
        total_slots = _safe_float(manifest.get("total_worker_slots"))
        if total_slots is None or total_slots > MAX_ACCEPTANCE_WORKERS:
            acceptance_errors.append(
                f"manifest total_worker_slots must be <= {MAX_ACCEPTANCE_WORKERS}"
            )
        if manifest.get(f"mode.{args.eoh_mode}.qd_operator_kind") != "eoh_strategies":
            acceptance_errors.append("EoH mode manifest qd_operator_kind is not eoh_strategies")
        if manifest.get(f"mode.{args.unified_mode}.qd_operator_kind") != SINGLE_OPERATOR:
            acceptance_errors.append(
                f"unified mode manifest qd_operator_kind is not {SINGLE_OPERATOR}"
            )

    metrics_by_mode: dict[str, dict[str, ProblemMetrics]] = {}
    for mode in (args.classic_mode, args.eoh_mode, args.unified_mode):
        metrics_by_mode[mode] = {}
        for item in expected:
            key = f"{item['benchmark']}/{item['problem']}"
            metrics_by_mode[mode][key] = _collect_problem_metrics(
                run_root=args.run_root,
                mode=mode,
                benchmark=item["benchmark"],
                problem=item["problem"],
            )

    if args.require_full_subset:
        for mode, by_problem in metrics_by_mode.items():
            missing = [
                key
                for key, metrics in by_problem.items()
                if metrics.problem_root is None
            ]
            if missing:
                acceptance_errors.append(f"{mode} missing problems: {', '.join(missing)}")

    unified_metrics = metrics_by_mode[args.unified_mode]
    eoh_metrics = metrics_by_mode[args.eoh_mode]
    classic_metrics = metrics_by_mode[args.classic_mode]
    for key, metrics in unified_metrics.items():
        if args.acceptance_hard_subset:
            if metrics.valid_ppa_sample_count < 1:
                acceptance_errors.append(f"unified mode has no valid PPA sample for {key}")
            if eoh_metrics[key].valid_ppa_sample_count > 0 and metrics.valid_ppa_sample_count < 1:
                acceptance_errors.append(f"EoH had valid PPA but unified did not for {key}")
            if classic_metrics[key].valid_ppa_sample_count > 0 and metrics.valid_ppa_sample_count < 1:
                acceptance_errors.append(f"classic had valid PPA but unified did not for {key}")

    paired_gates = [
        _paired_gate(
            name="functional pass rate",
            unified=unified_metrics,
            eoh=eoh_metrics,
            field="functionality_rate",
            floor=0.03,
        ),
        _paired_gate(
            name="synthesis pass rate",
            unified=unified_metrics,
            eoh=eoh_metrics,
            field="synthesis_rate",
            floor=0.03,
        ),
        _paired_gate(
            name="valid PPA sample count",
            unified=unified_metrics,
            eoh=eoh_metrics,
            field="valid_ppa_sample_count",
            floor=1.0,
        ),
        _paired_gate(
            name="average quality score",
            unified=unified_metrics,
            eoh=eoh_metrics,
            field="average_quality_score",
            floor=0.03,
        ),
        _paired_gate(
            name="average PPA improvement",
            unified=unified_metrics,
            eoh=eoh_metrics,
            field="average_ppa_improvement",
            floor=0.06,
        ),
    ]
    for gate in paired_gates:
        gate["enforced"] = args.acceptance_hard_subset
        if args.acceptance_hard_subset and not gate["passed"]:
            acceptance_errors.append(
                f"{gate['metric']} gate failed: mean_delta={gate['mean_delta']} "
                f"threshold=-{gate['threshold']}"
            )

    operator_problem_audits = []
    for key, metrics in unified_metrics.items():
        if metrics.problem_root is None:
            continue
        root = Path(metrics.problem_root)
        kind = _operator_kind(root)
        if kind != SINGLE_OPERATOR:
            acceptance_errors.append(f"{key} summary operator kind is {kind}")
        audit = _validate_unified_problem(root)
        audit["problem"] = key
        operator_problem_audits.append(audit)
        for error in audit["errors"]:
            acceptance_errors.append(f"{key}: {error}")

    operator_audit = {
        "operator_candidate_count": sum(
            int(item["operator_candidate_count"]) for item in operator_problem_audits
        ),
        "prompt_snapshot_count": sum(
            int(item["prompt_snapshot_count"]) for item in operator_problem_audits
        ),
        "one_parent_count": sum(int(item["one_parent_count"]) for item in operator_problem_audits),
        "two_parent_count": sum(int(item["two_parent_count"]) for item in operator_problem_audits),
        "same_cell_two_parent_seen": any(
            bool(item["same_cell_two_parent_seen"]) for item in operator_problem_audits
        ),
        "problems": operator_problem_audits,
    }
    total_success_parent = (
        int(operator_audit["one_parent_count"]) + int(operator_audit["two_parent_count"])
    )
    if total_success_parent:
        one_parent_fraction = int(operator_audit["one_parent_count"]) / total_success_parent
        operator_audit["empirical_one_parent_fraction"] = one_parent_fraction
        expected_one_parent_fraction = _safe_float(
            manifest.get(f"mode.{args.unified_mode}.qd_operator_one_parent_fraction")
        )
        if expected_one_parent_fraction is None:
            expected_one_parent_fraction = 0.5
        operator_audit["expected_one_parent_fraction"] = expected_one_parent_fraction
        if (
            args.acceptance_hard_subset
            and abs(one_parent_fraction - expected_one_parent_fraction) > 0.10
        ):
            acceptance_errors.append(
                "empirical one-parent fraction outside +/-0.10: "
                f"{one_parent_fraction} versus expected {expected_one_parent_fraction}"
            )
    if args.acceptance_hard_subset and not operator_audit["same_cell_two_parent_seen"]:
        acceptance_errors.append("no same-cell two-parent prompt observed")

    problem_invalid_count = sum(
        1
        for by_mode in metrics_by_mode.values()
        for metrics in by_mode.values()
        if metrics.errors
    )
    problem_error_count = sum(
        len(metrics.errors)
        for by_mode in metrics_by_mode.values()
        for metrics in by_mode.values()
    )
    acceptance_error_count = len(acceptance_errors)
    failure_count = problem_error_count + acceptance_error_count
    payload = {
        "valid": failure_count == 0,
        "failure_count": failure_count,
        "problem_invalid_count": problem_invalid_count,
        "acceptance_error_count": acceptance_error_count,
        "classic_mode": args.classic_mode,
        "eoh_mode": args.eoh_mode,
        "unified_mode": args.unified_mode,
        "problem_count": len(expected),
        "metrics_by_mode": {
            mode: {key: asdict(metrics) for key, metrics in by_problem.items()}
            for mode, by_problem in metrics_by_mode.items()
        },
        "paired_gates": paired_gates,
        "operator_audit": operator_audit,
        "acceptance_errors": acceptance_errors,
    }
    json_path = args.run_root / "single_thought_operator_validation.json"
    report_path = args.run_root / "single_thought_operator_validation.md"
    json_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    _write_report(report_path, payload)
    return 0 if payload["valid"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
