#!/usr/bin/env python3
"""LLM budget-parity report for a classic-vs-variant pair.

P1 predeclares that repair and k-code-sample charging must keep the two
arms' charged evaluations within +/-10%; otherwise the comparison is
compute-confounded and the narrative must say so. This report reads the
per-problem ``*_summary.json`` accounting fields from both arm roots and
emits per-problem and aggregate call/token ratios with a parity verdict.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

FIELDS = (
    "total_llm_api_calls",
    "total_llm_prompt_tokens",
    "total_llm_completion_tokens",
)
PARITY_TOLERANCE = 0.10


def collect_problem_totals(run_root: Path) -> dict[str, dict[str, float]]:
    """problem -> accounting fields, from each problem dir's summary json."""

    totals: dict[str, dict[str, float]] = {}
    for summary_path in sorted(run_root.rglob("Prob*_summary.json")):
        payload = json.loads(summary_path.read_text(encoding="utf-8"))
        problem = summary_path.parent.name
        totals[problem] = {field: float(payload[field]) for field in FIELDS}
    assert totals, f"no problem summaries under {run_root}"
    return totals


def build_report(
    classic_root: Path, variant_root: Path
) -> dict[str, object]:
    classic = collect_problem_totals(classic_root)
    variant = collect_problem_totals(variant_root)
    shared = sorted(classic.keys() & variant.keys())
    assert shared, "no shared problems between arms"

    per_problem = {}
    aggregate = {field: {"classic": 0.0, "variant": 0.0} for field in FIELDS}
    for problem in shared:
        entry = {}
        for field in FIELDS:
            c, v = classic[problem][field], variant[problem][field]
            aggregate[field]["classic"] += c
            aggregate[field]["variant"] += v
            entry[field] = {
                "classic": c,
                "variant": v,
                "ratio": (v / c) if c else None,
            }
        per_problem[problem] = entry

    ratios = {}
    for field, sums in aggregate.items():
        ratio = sums["variant"] / sums["classic"] if sums["classic"] else None
        ratios[field] = {
            **sums,
            "ratio": ratio,
            "within_tolerance": (
                ratio is not None and abs(ratio - 1.0) <= PARITY_TOLERANCE
            ),
        }
    return {
        "classic_root": str(classic_root),
        "variant_root": str(variant_root),
        "shared_problems": shared,
        "unpaired_classic": sorted(classic.keys() - variant.keys()),
        "unpaired_variant": sorted(variant.keys() - classic.keys()),
        "parity_tolerance": PARITY_TOLERANCE,
        "aggregate": ratios,
        "per_problem": per_problem,
        "verdict": (
            "PARITY"
            if all(entry["within_tolerance"] for entry in ratios.values())
            else "CONFOUNDED"
        ),
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--classic-root", type=Path, required=True)
    parser.add_argument("--variant-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)

    report = build_report(args.classic_root, args.variant_root)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "budget_parity.json").write_text(
        json.dumps(report, indent=2), encoding="utf-8"
    )
    lines = [
        "# LLM Budget Parity",
        "",
        f"Tolerance +/-{PARITY_TOLERANCE:.0%} on aggregate variant/classic "
        f"ratios over {len(report['shared_problems'])} shared problems. "
        f"Verdict: **{report['verdict']}**.",
        "",
        "| Field | classic | variant | ratio | within |",
        "| --- | --- | --- | --- | --- |",
    ]
    aggregate = report["aggregate"]
    assert isinstance(aggregate, dict)
    for field, entry in aggregate.items():
        lines.append(
            f"| {field} | {entry['classic']:.0f} | {entry['variant']:.0f} | "
            f"{entry['ratio']:.3f} | {entry['within_tolerance']} |"
        )
    lines.append("")
    (args.output_dir / "budget_parity.md").write_text(
        "\n".join(lines), encoding="utf-8"
    )
    for field, entry in aggregate.items():
        print(f"{field}: ratio={entry['ratio']:.3f} within={entry['within_tolerance']}")
    print(f"verdict: {report['verdict']} -> {args.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
