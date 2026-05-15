#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import statistics
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

import yaml


MAX_WORKERS = 16


@dataclass
class ValidationResult:
    errors: list[str]
    warnings: list[str]
    thought_evaluation_count: int
    thought_only_modes: list[str]
    metric_pairs_checked: list[str]


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _manifest(path: Path) -> dict[str, str]:
    manifest_path = path / "hard_iteration_manifest.txt"
    if not manifest_path.is_file():
        return {}
    values: dict[str, str] = {}
    for line in manifest_path.read_text(encoding="utf-8").splitlines():
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip()
    return values


def _expected_problems(path: Path) -> list[dict[str, str]]:
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return [
        {"benchmark": str(item["benchmark"]), "problem": str(item["problem"])}
        for item in payload["selected_problems"]
    ]


def _problem_root(run_root: Path, mode: str, benchmark: str, problem: str) -> Path | None:
    direct = run_root / mode / benchmark / problem
    if direct.is_dir():
        return direct
    matches = sorted((run_root / mode).rglob(f"{benchmark}/{problem}"))
    return matches[-1] if matches else None


def _problem_summary(root: Path, problem: str) -> tuple[Path, dict[str, Any]]:
    direct = root / f"{problem}_summary.json"
    if direct.is_file():
        return direct, _load_json(direct)
    summaries = [
        path
        for path in root.glob("*_summary.json")
        if path.name not in {"archive_summary.json", "global_pareto_summary.json"}
    ]
    if summaries:
        return summaries[0], _load_json(summaries[0])
    return direct, {}


def _safe_float(value: Any) -> float | None:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    return parsed


def _load_generation_ppa_details(summary_path: Path) -> list[dict[str, Any]]:
    details: list[dict[str, Any]] = []
    generation_log_path = summary_path.parent / "generation_log.jsonl"
    if not generation_log_path.is_file():
        return details
    for line in generation_log_path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        payload = json.loads(line)
        assert isinstance(payload, dict)
        row_details = payload.get("population_ppa_details", [])
        assert isinstance(row_details, list)
        details.extend(detail for detail in row_details if isinstance(detail, dict))
    return details


def _best_ppa_detail(details: list[dict[str, Any]]) -> dict[str, Any] | None:
    scored_details: list[tuple[float, dict[str, Any]]] = []
    for detail in details:
        score = _safe_float(detail.get("score"))
        if score is not None:
            scored_details.append((score, detail))
    if not scored_details:
        return None
    return max(scored_details, key=lambda item: item[0])[1]


def _mean_improvement(
    *,
    best_metrics: dict[str, Any],
    ref_metrics: dict[str, Any],
) -> float | None:
    if not best_metrics or not ref_metrics:
        return None
    gains: list[float] = []
    for key in ("area", "power", "eff_clk_period"):
        best = _safe_float(best_metrics.get(key))
        ref = _safe_float(ref_metrics.get(key))
        if best is not None and ref is not None and ref != 0.0:
            gains.append((ref - best) / ref)
    return statistics.fmean(gains) if gains else None


def _empty_metrics() -> dict[str, float | None]:
    return {
        "valid_design_count": 0.0,
        "valid_representative_count": 0.0,
        "functional_pass_rate": None,
        "synthesis_ppa_pass_rate": None,
        "average_quality_score": None,
        "average_ppa_improvement": None,
    }


def _summary_metrics(
    *,
    summary: dict[str, Any],
    summary_path: Path,
) -> dict[str, float | None]:
    rates = summary.get("accumulated_success_rates", {})
    if not isinstance(rates, dict):
        rates = {}
    final_ppa = summary.get("final_population_ppa", {})
    if not isinstance(final_ppa, dict):
        final_ppa = {}
    generation_details = _load_generation_ppa_details(summary_path)
    details = summary.get("final_population_ppa_details", [])
    if not isinstance(details, list):
        details = []
    ppa_details = generation_details or [
        detail for detail in details if isinstance(detail, dict)
    ]
    best_metrics = final_ppa.get("best_metrics", {})
    if not isinstance(best_metrics, dict):
        best_metrics = {}
    best_detail = _best_ppa_detail(ppa_details)
    if best_detail is not None and not best_metrics:
        detail_metrics = best_detail.get("ppa_metrics", {})
        assert isinstance(detail_metrics, dict)
        best_metrics = detail_metrics
    quality_scores = [
        score
        for detail in ppa_details
        if (score := _safe_float(detail.get("score"))) is not None
    ]
    average_quality = _safe_float(final_ppa.get("average_score"))
    if average_quality is None and quality_scores:
        average_quality = statistics.fmean(quality_scores)
    ref_metrics = summary.get("ref_ppa_metric", {})
    if not isinstance(ref_metrics, dict):
        ref_metrics = {}
    return {
        "valid_design_count": 1.0 if ppa_details else 0.0,
        "valid_representative_count": float(len(ppa_details)),
        "functional_pass_rate": _safe_float(rates.get("functionality")),
        "synthesis_ppa_pass_rate": _safe_float(rates.get("synthesis_ppa")),
        "average_quality_score": average_quality,
        "average_ppa_improvement": _mean_improvement(
            best_metrics=best_metrics,
            ref_metrics=ref_metrics,
        ),
    }


def _validate_manifest(
    *,
    values: dict[str, str],
    thought_only_modes: list[str],
    errors: list[str],
) -> None:
    for key in ("total_worker_slots", "max_active_problems", "max_workers_per_problem"):
        raw = values.get(key)
        if raw is None:
            errors.append(f"manifest missing {key}")
            continue
        if int(raw) > MAX_WORKERS:
            errors.append(f"{key}={raw} exceeds {MAX_WORKERS}")

    for mode in thought_only_modes:
        prefix = f"mode.{mode}"
        if values.get(f"{prefix}.representation.kind") != "thought_only":
            errors.append(f"manifest missing thought_only representation for {mode}")
        if values.get(f"{prefix}.representation.code_samples_per_thought") != "4":
            errors.append(f"manifest missing k=4 for {mode}")


def _validate_summary(
    *,
    summary: dict[str, Any],
    mode: str,
    errors: list[str],
) -> None:
    qd_config = summary.get("backend_details", {}).get("qd_config", {})
    if not isinstance(qd_config, dict):
        errors.append(f"{mode}: missing qd_config")
        return
    representation = qd_config.get("representation", {})
    if not isinstance(representation, dict):
        errors.append(f"{mode}: missing representation config")
        return
    if representation.get("kind") != "thought_only":
        errors.append(f"{mode}: representation.kind is not thought_only")
    if representation.get("code_samples_per_thought") != 4:
        errors.append(f"{mode}: code_samples_per_thought is not 4")
    repair = qd_config.get("repair", {})
    if isinstance(repair, dict) and repair.get("kind") == "none":
        if repair.get("max_attempts_per_sample") != 0:
            errors.append(f"{mode}: repair disabled but per-sample cap is nonzero")
        if repair.get("max_attempts_per_thought") != 0:
            errors.append(f"{mode}: repair disabled but per-thought cap is nonzero")


def _validate_thought_evaluation(
    *,
    path: Path,
    errors: list[str],
) -> None:
    payload = _load_json(path)
    thought_id = payload.get("thought_id", path.parent.name)
    k = payload.get("code_samples_per_thought")
    if k != 4:
        errors.append(f"{thought_id}: code_samples_per_thought is {k}, expected 4")
    aggregate_status = payload.get("aggregate_status")
    sample_records = payload.get("sample_records", [])
    if not isinstance(sample_records, list):
        errors.append(f"{thought_id}: sample_records is not a list")
        return
    sample_ids = payload.get("sample_ids", [])
    if aggregate_status == "invalid_thought":
        if sample_records or sample_ids:
            errors.append(f"{thought_id}: invalid thought has code samples")
        if payload.get("representative_sample_id") is not None:
            errors.append(f"{thought_id}: invalid thought has a representative")
        return
    if len(sample_records) != 4:
        errors.append(f"{thought_id}: expected 4 sample records")
    if len(sample_ids) != 4:
        errors.append(f"{thought_id}: expected 4 sample IDs")
    success_count = int(payload.get("success_count", 0))
    if success_count > 0 and not payload.get("representative_sample_id"):
        errors.append(f"{thought_id}: successful thought has no representative")
    if success_count == 0 and payload.get("representative_sample_id"):
        errors.append(f"{thought_id}: all-fail thought has a representative")


def _validate_metric_regression(
    *,
    metrics_by_mode: dict[str, list[dict[str, float | None]]],
    target_mode: str,
    control_mode: str,
    errors: list[str],
    warnings: list[str],
) -> list[str]:
    floors = {
        "valid_design_count": 1.0,
        "functional_pass_rate": 0.10,
        "synthesis_ppa_pass_rate": 0.10,
        "average_quality_score": 0.05,
        "average_ppa_improvement": 0.05,
    }
    checked: list[str] = []
    target_rows = metrics_by_mode.get(target_mode, [])
    control_rows = metrics_by_mode.get(control_mode, [])
    for metric_name, floor in floors.items():
        deltas: list[float] = []
        for target_row, control_row in zip(target_rows, control_rows, strict=False):
            target_value = target_row.get(metric_name)
            control_value = control_row.get(metric_name)
            if target_value is None or control_value is None:
                continue
            deltas.append(float(target_value) - float(control_value))
        if not deltas:
            warnings.append(f"no paired values for {metric_name}")
            continue
        checked.append(metric_name)
        mean_delta = statistics.fmean(deltas)
        if len(deltas) > 1:
            stdev = statistics.stdev(deltas)
            standard_error = stdev / (len(deltas) ** 0.5)
            tolerance = max(2 * standard_error, floor)
        else:
            tolerance = floor
        if mean_delta < -tolerance:
            errors.append(
                f"{target_mode} regressed vs {control_mode} on {metric_name}: "
                f"mean_delta={mean_delta:.4f}, tolerance={tolerance:.4f}"
            )
    return checked


def _validate_per_problem_acceptance(
    *,
    expected: list[dict[str, str]],
    metrics_by_mode: dict[str, list[dict[str, float | None]]],
    target_mode: str,
    control_mode: str,
    errors: list[str],
) -> None:
    target_rows = metrics_by_mode.get(target_mode, [])
    control_rows = metrics_by_mode.get(control_mode, [])
    for item, target_row, control_row in zip(
        expected, target_rows, control_rows, strict=False
    ):
        problem = item["problem"]
        hard_gates = (
            ("valid_design_count", "valid designs"),
            ("functional_pass_rate", "functional pass rate"),
            ("synthesis_ppa_pass_rate", "synthesis/PPA pass rate"),
        )
        for metric_name, label in hard_gates:
            control_value = control_row.get(metric_name)
            target_value = target_row.get(metric_name)
            if control_value is None or float(control_value) <= 0.0:
                continue
            if target_value is None or float(target_value) <= 0.0:
                errors.append(
                    f"{target_mode} collapsed to zero {label} on {problem} "
                    f"while {control_mode} had {control_value:.4f}"
                )
        for metric_name, label in (
            ("average_quality_score", "average quality score"),
            ("average_ppa_improvement", "average PPA improvement"),
        ):
            control_value = control_row.get(metric_name)
            target_value = target_row.get(metric_name)
            if control_value is not None and target_value is None:
                errors.append(
                    f"{target_mode} is missing {label} on {problem} while "
                    f"{control_mode} had {control_value:.4f}"
                )


def validate(args: argparse.Namespace) -> ValidationResult:
    run_root = Path(args.run_root)
    expected = _expected_problems(Path(args.subset_config))
    thought_only_modes = [args.eoh_thought_only_mode, args.thought_only_mode]
    all_modes = [
        args.classic_mode,
        args.eoh_control_mode,
        args.unified_control_mode,
        args.eoh_thought_only_mode,
        args.thought_only_mode,
    ]
    errors: list[str] = []
    warnings: list[str] = []
    manifest = _manifest(run_root)
    if manifest:
        _validate_manifest(
            values=manifest,
            thought_only_modes=thought_only_modes,
            errors=errors,
        )
    else:
        warnings.append("missing hard_iteration_manifest.txt")

    metrics_by_mode: dict[str, list[dict[str, float | None]]] = {
        mode: [] for mode in all_modes
    }
    thought_eval_count = 0
    for mode in all_modes:
        for item in expected:
            root = _problem_root(run_root, mode, item["benchmark"], item["problem"])
            if root is None:
                errors.append(f"{mode}: missing problem root for {item['problem']}")
                metrics_by_mode[mode].append(_empty_metrics())
                continue
            summary_path, summary = _problem_summary(root, item["problem"])
            metrics_by_mode[mode].append(
                _summary_metrics(summary=summary, summary_path=summary_path)
            )
            if mode not in thought_only_modes:
                continue
            _validate_summary(
                summary=summary,
                mode=mode,
                errors=errors,
            )
            thought_files = sorted(root.rglob("thought_evaluation.json"))
            if not thought_files:
                errors.append(f"{mode}: missing thought_evaluation.json files for {item['problem']}")
            for thought_path in thought_files:
                thought_eval_count += 1
                _validate_thought_evaluation(path=thought_path, errors=errors)
    checked = _validate_metric_regression(
        metrics_by_mode=metrics_by_mode,
        target_mode=args.thought_only_mode,
        control_mode=args.unified_control_mode,
        errors=errors,
        warnings=warnings,
    )
    _validate_per_problem_acceptance(
        expected=expected,
        metrics_by_mode=metrics_by_mode,
        target_mode=args.thought_only_mode,
        control_mode=args.unified_control_mode,
        errors=errors,
    )

    return ValidationResult(
        errors=errors,
        warnings=warnings,
        thought_evaluation_count=thought_eval_count,
        thought_only_modes=thought_only_modes,
        metric_pairs_checked=checked,
    )


def _write_outputs(run_root: Path, result: ValidationResult) -> None:
    json_path = run_root / "thought_only_k_code_validation.json"
    md_path = run_root / "thought_only_k_code_validation.md"
    json_path.write_text(json.dumps(asdict(result), indent=2), encoding="utf-8")
    lines = [
        "# Thought-Only k-Code Validation",
        "",
        f"- thought_evaluation_count: `{result.thought_evaluation_count}`",
        f"- error_count: `{len(result.errors)}`",
        f"- warning_count: `{len(result.warnings)}`",
        "",
    ]
    if result.errors:
        lines.append("## Errors")
        lines.extend(f"- {error}" for error in result.errors)
        lines.append("")
    if result.warnings:
        lines.append("## Warnings")
        lines.extend(f"- {warning}" for warning in result.warnings)
        lines.append("")
    md_path.write_text("\n".join(lines), encoding="utf-8")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-root", required=True)
    parser.add_argument("--subset-config", required=True)
    parser.add_argument("--classic-mode", required=True)
    parser.add_argument("--eoh-control-mode", required=True)
    parser.add_argument("--unified-control-mode", required=True)
    parser.add_argument("--eoh-thought-only-mode", required=True)
    parser.add_argument("--thought-only-mode", required=True)
    parser.add_argument("--require-full-subset", action="store_true")
    parser.add_argument("--acceptance-hard-subset", action="store_true")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    result = validate(args)
    _write_outputs(Path(args.run_root), result)
    return 1 if result.errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
