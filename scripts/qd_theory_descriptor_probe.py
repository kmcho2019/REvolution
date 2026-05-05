#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import re
import sys
import tarfile
from pathlib import Path
from typing import Any

sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from revolution.graph_descriptor_evaluator import GraphDescriptorEvaluator  # noqa: E402
from revolution.qd.descriptors import (  # noqa: E402
    extract_descriptor_values,
    resolve_descriptor_axes,
)
from revolution.rtl_descriptor_evaluator import RTLDescriptorEvaluator  # noqa: E402

_RENTCON_PATTERNS = {
    "rent_exponent": [
        re.compile(r"rent(?:'s)?(?:\s+(?:parameter|exponent))?\s*[:=]\s*([0-9]*\.?[0-9]+)", re.I),
        re.compile(r"\bexponent\b\s*[:=]\s*([0-9]*\.?[0-9]+)", re.I),
    ],
    "rent_k": [
        re.compile(r"\brent[_\s-]*k\b\s*[:=]\s*([0-9]*\.?[0-9]+)", re.I),
        re.compile(r"\bcoefficient\b\s*[:=]\s*([0-9]*\.?[0-9]+)", re.I),
    ],
    "rent_r2": [
        re.compile(r"\br\^?2\b\s*[:=]\s*([0-9]*\.?[0-9]+)", re.I),
        re.compile(r"\brsq\b\s*[:=]\s*([0-9]*\.?[0-9]+)", re.I),
    ],
}


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Probe the theory-grounded QD descriptor family on one RTL file and "
            "optionally compare repo-native Rent metrics against RentCon reports."
        ),
    )
    parser.add_argument("--rtl", required=True, help="Path to the RTL file to inspect.")
    parser.add_argument("--top", default=None, help="Top module name for Yosys graph extraction.")
    parser.add_argument(
        "--profile",
        default="theory_grounded_full_20d",
        help="Descriptor profile to project onto.",
    )
    parser.add_argument(
        "--archive_type",
        default="cvt",
        choices=["grid", "cvt", "grid_quantile"],
        help="Archive type used for descriptor-axis resolution.",
    )
    parser.add_argument(
        "--circuit_type",
        default="sequential",
        choices=["sequential", "combinational", "unknown"],
        help="Circuit type used for descriptor-axis resolution.",
    )
    parser.add_argument(
        "--rentcon_reference",
        action="append",
        default=[],
        help=(
            "Optional RentCon output file, extracted result directory, or archive "
            "path to inspect for comparison metrics. Repeatable."
        ),
    )
    return parser


def _iter_text_candidates(path: Path) -> list[tuple[str, str]]:
    if not path.exists():
        return []
    if path.is_file() and tarfile.is_tarfile(path):
        candidates: list[tuple[str, str]] = []
        with tarfile.open(path, "r:*") as archive:
            for member in archive.getmembers():
                if not member.isfile():
                    continue
                name = member.name.lower()
                if not any(token in name for token in ("rent", "rpt", "report", "result", "out", "log", "txt", "csv")):
                    continue
                extracted = archive.extractfile(member)
                if extracted is None:
                    continue
                try:
                    text = extracted.read().decode("utf-8", errors="ignore")
                except OSError:
                    continue
                candidates.append((member.name, text))
        return candidates
    if path.is_file():
        try:
            return [(str(path), path.read_text(encoding="utf-8", errors="ignore"))]
        except OSError:
            return []

    candidates = []
    for child in sorted(path.rglob("*")):
        if not child.is_file():
            continue
        lowered = child.name.lower()
        if not any(token in lowered for token in ("rent", "rpt", "report", "result", "out", "log", "txt", "csv")):
            continue
        try:
            candidates.append((str(child), child.read_text(encoding="utf-8", errors="ignore")))
        except OSError:
            continue
    return candidates


def _extract_rentcon_metrics_from_text(text: str) -> dict[str, float]:
    metrics: dict[str, float] = {}
    for key, patterns in _RENTCON_PATTERNS.items():
        for pattern in patterns:
            match = pattern.search(text)
            if match is None:
                continue
            metrics[key] = float(match.group(1))
            break
    return metrics


def load_rentcon_reference(reference_paths: list[str]) -> dict[str, Any] | None:
    if not reference_paths:
        return None

    findings: list[dict[str, Any]] = []
    for raw_path in reference_paths:
        path = Path(raw_path)
        source_findings: list[dict[str, Any]] = []
        for candidate_name, text in _iter_text_candidates(path):
            metrics = _extract_rentcon_metrics_from_text(text)
            if not metrics:
                continue
            source_findings.append(
                {
                    "source": candidate_name,
                    "metrics": metrics,
                }
            )
        findings.append(
            {
                "reference_path": str(path),
                "matches": source_findings,
                "note": (
                    "No parseable RentCon result metrics were found in this path."
                    if not source_findings
                    else None
                ),
            }
        )
    return {"references": findings}


def compare_rent_metrics(
    repo_metrics: dict[str, float],
    rentcon_payload: dict[str, Any] | None,
) -> dict[str, Any] | None:
    if not rentcon_payload:
        return None

    comparisons: list[dict[str, Any]] = []
    repo_subset = {
        "rent_exponent": float(repo_metrics.get("rent_exponent", 0.0)),
        "rent_k": float(repo_metrics.get("rent_k", 0.0)),
        "rent_r2": float(repo_metrics.get("rent_r2", 0.0)),
    }
    for reference in rentcon_payload.get("references", []):
        for match in reference.get("matches", []):
            metrics = match.get("metrics", {})
            delta: dict[str, float] = {}
            for key, repo_value in repo_subset.items():
                if key in metrics:
                    delta[f"{key}_delta"] = repo_value - float(metrics[key])
            comparisons.append(
                {
                    "reference_path": reference.get("reference_path"),
                    "source": match.get("source"),
                    "rentcon_metrics": metrics,
                    "repo_metrics": repo_subset,
                    "delta": delta,
                }
            )
    if not comparisons:
        return {
            "references": rentcon_payload.get("references", []),
            "note": "RentCon references were inspected, but no comparable metrics were parsed.",
        }
    return {"comparisons": comparisons}


def build_payload(args: argparse.Namespace) -> dict[str, Any]:
    rtl_path = Path(args.rtl)
    code_text = rtl_path.read_text(encoding="utf-8")
    rtl_metrics = RTLDescriptorEvaluator().extract_metrics(
        code_text=code_text,
        code_file_path=rtl_path,
        mapped_cell_count=None,
    )
    graph_metrics = GraphDescriptorEvaluator().extract_metrics(
        code_file_path=rtl_path,
        top_module_name=args.top,
    )
    axes = resolve_descriptor_axes(
        profile_name=args.profile,
        explicit_axes=None,
        descriptor_file=None,
        archive_type=args.archive_type,
        circuit_type=args.circuit_type,
    )
    combined_metrics = {**rtl_metrics, **graph_metrics}
    rentcon_payload = load_rentcon_reference(args.rentcon_reference)
    return {
        "rtl": str(rtl_path),
        "top_module": args.top,
        "profile": args.profile,
        "archive_type": args.archive_type,
        "circuit_type": args.circuit_type,
        "descriptor_axes": axes,
        "descriptor_values": extract_descriptor_values(combined_metrics, axes),
        "rtl_metrics": rtl_metrics,
        "graph_metrics": graph_metrics,
        "rentcon_reference": rentcon_payload,
        "rent_comparison": compare_rent_metrics(graph_metrics, rentcon_payload),
    }


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)
    payload = build_payload(args)
    print(json.dumps(payload, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
