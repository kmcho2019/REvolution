#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Any

SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))
SRC_ROOT = os.path.join(REPO_ROOT, "src")
if REPO_ROOT not in sys.path:
    sys.path.insert(0, REPO_ROOT)
if SRC_ROOT not in sys.path:
    sys.path.insert(0, SRC_ROOT)

from revolution.graph_descriptor_evaluator import GraphDescriptorEvaluator  # noqa: E402
from scripts.qd_theory_descriptor_probe import (  # noqa: E402
    compare_rent_metrics,
    load_rentcon_reference,
)


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Evaluate a manifest of RTL cases, extract repo-native Rent metrics, "
            "and optionally compare them against stored RentCon outputs."
        ),
    )
    parser.add_argument(
        "--manifest",
        required=True,
        help="Path to a JSON manifest with a top-level 'cases' list.",
    )
    parser.add_argument(
        "--output_json",
        default=None,
        help="Optional path to save the machine-readable calibration report.",
    )
    parser.add_argument(
        "--output_md",
        default=None,
        help="Optional path to save a markdown summary report.",
    )
    return parser


def _resolve_path(raw_path: str, *, base_dir: Path) -> Path:
    path = Path(raw_path)
    if path.is_absolute():
        return path
    return (base_dir / path).resolve()


def load_manifest(path: str | Path) -> dict[str, Any]:
    manifest_path = Path(path)
    payload = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict):
        raise ValueError("Manifest must decode to a JSON object.")
    cases = payload.get("cases")
    if not isinstance(cases, list):
        raise ValueError("Manifest must contain a top-level 'cases' list.")
    return payload


def evaluate_case(case: dict[str, Any], *, base_dir: Path) -> dict[str, Any]:
    name = case.get("name")
    rtl = case.get("rtl")
    if not isinstance(name, str) or not name:
        raise ValueError("Each case requires a non-empty string 'name'.")
    if not isinstance(rtl, str) or not rtl:
        raise ValueError(f"Case '{name}' requires a non-empty string 'rtl'.")

    top = case.get("top")
    if top is not None and not isinstance(top, str):
        raise ValueError(f"Case '{name}' has a non-string 'top'.")

    raw_references = case.get("rentcon_reference", [])
    if not isinstance(raw_references, list) or not all(
        isinstance(item, str) for item in raw_references
    ):
        raise ValueError(f"Case '{name}' has an invalid 'rentcon_reference' list.")

    rtl_path = _resolve_path(rtl, base_dir=base_dir)
    reference_paths = [
        str(_resolve_path(reference_path, base_dir=base_dir))
        for reference_path in raw_references
    ]

    graph_metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=rtl_path,
        top_module_name=top,
    )
    rentcon_payload = load_rentcon_reference(reference_paths)
    rent_comparison = compare_rent_metrics(graph_metrics, rentcon_payload)

    return {
        "name": name,
        "rtl": str(rtl_path),
        "top_module": top,
        "graph_metrics": graph_metrics,
        "rentcon_reference": rentcon_payload,
        "rent_comparison": rent_comparison,
    }


def evaluate_manifest(path: str | Path) -> dict[str, Any]:
    manifest_path = Path(path).resolve()
    payload = load_manifest(manifest_path)
    base_dir = manifest_path.parent
    cases = payload["cases"]
    case_results = [evaluate_case(case, base_dir=base_dir) for case in cases]
    return {
        "manifest": str(manifest_path),
        "case_count": len(case_results),
        "cases": case_results,
        "summary": summarize_case_results(case_results),
    }


def summarize_case_results(case_results: list[dict[str, Any]]) -> dict[str, Any]:
    exponent_deltas: list[float] = []
    k_deltas: list[float] = []
    r2_deltas: list[float] = []
    matched_cases = 0

    for case in case_results:
        comparison = case.get("rent_comparison")
        if not isinstance(comparison, dict):
            continue
        comparisons = comparison.get("comparisons")
        if not isinstance(comparisons, list) or not comparisons:
            continue
        matched_cases += 1
        for item in comparisons:
            if not isinstance(item, dict):
                continue
            delta = item.get("delta")
            if not isinstance(delta, dict):
                continue
            if isinstance(delta.get("rent_exponent_delta"), (int, float)):
                exponent_deltas.append(abs(float(delta["rent_exponent_delta"])))
            if isinstance(delta.get("rent_k_delta"), (int, float)):
                k_deltas.append(abs(float(delta["rent_k_delta"])))
            if isinstance(delta.get("rent_r2_delta"), (int, float)):
                r2_deltas.append(abs(float(delta["rent_r2_delta"])))

    return {
        "cases_with_comparable_rentcon_metrics": matched_cases,
        "mean_abs_rent_exponent_delta": _mean_or_none(exponent_deltas),
        "mean_abs_rent_k_delta": _mean_or_none(k_deltas),
        "mean_abs_rent_r2_delta": _mean_or_none(r2_deltas),
    }


def _mean_or_none(values: list[float]) -> float | None:
    if not values:
        return None
    return sum(values) / len(values)


def render_markdown_report(report: dict[str, Any]) -> str:
    lines = [
        "# QD Rent Calibration Report",
        "",
        f"- manifest: `{report['manifest']}`",
        f"- case_count: `{report['case_count']}`",
        f"- cases_with_comparable_rentcon_metrics: "
        f"`{report['summary']['cases_with_comparable_rentcon_metrics']}`",
        f"- mean_abs_rent_exponent_delta: "
        f"`{report['summary']['mean_abs_rent_exponent_delta']}`",
        "",
        "| Case | Repo Rent Exponent | Repo R2 | RentCon Exponent | Delta | Notes |",
        "| --- | ---: | ---: | ---: | ---: | --- |",
    ]

    for case in report["cases"]:
        graph_metrics = case.get("graph_metrics", {})
        repo_exponent = _format_metric(graph_metrics.get("rent_exponent"))
        repo_r2 = _format_metric(graph_metrics.get("rent_r2"))
        comparison = case.get("rent_comparison")

        reference_exponent = "-"
        delta = "-"
        notes = ""
        if isinstance(comparison, dict) and isinstance(comparison.get("comparisons"), list):
            comparisons = comparison["comparisons"]
            if comparisons:
                first = comparisons[0]
                rentcon_metrics = first.get("rentcon_metrics", {})
                reference_exponent = _format_metric(rentcon_metrics.get("rent_exponent"))
                delta = _format_metric(first.get("delta", {}).get("rent_exponent_delta"))
                notes = str(first.get("source", ""))
        elif isinstance(comparison, dict) and isinstance(comparison.get("note"), str):
            notes = comparison["note"]

        lines.append(
            f"| {case['name']} | {repo_exponent} | {repo_r2} | "
            f"{reference_exponent} | {delta} | {notes} |"
        )

    lines.append("")
    return "\n".join(lines)


def _format_metric(value: Any) -> str:
    if not isinstance(value, (int, float)):
        return "-"
    return f"{float(value):.6f}"


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)
    report = evaluate_manifest(args.manifest)
    report_json = json.dumps(report, indent=2, sort_keys=True)

    if args.output_json:
        output_json = Path(args.output_json)
        output_json.parent.mkdir(parents=True, exist_ok=True)
        output_json.write_text(report_json + "\n", encoding="utf-8")

    markdown_report = render_markdown_report(report)
    if args.output_md:
        output_md = Path(args.output_md)
        output_md.parent.mkdir(parents=True, exist_ok=True)
        output_md.write_text(markdown_report, encoding="utf-8")

    print(report_json)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
