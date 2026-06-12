#!/usr/bin/env python3
"""Mechanical decision table for the pre-registered descriptor bake-off.

Applies the narrative's frozen rule to the four registered profiles:
rank by paired best-quality delta, tie-break by median occupancy, then
by mean |descriptor-objective correlation| (lower is better); a profile
fails outright on the occupancy floor (< 0.25 median) or, per the
2026-06-12 pre-registration addendum, reports its warmup-completion
rate and per-axis collapse counts as headline evidence. Inputs are the
pair stats json and the variant run root per profile.
"""

from __future__ import annotations

import argparse
import json
import statistics
from pathlib import Path

OCCUPANCY_FLOOR = 0.25


def profile_evidence(stats_json: Path, variant_root: Path) -> dict[str, object]:
    stats = json.loads(stats_json.read_text(encoding="utf-8"))
    best = stats["metrics"]["best_quality"]

    completions = []
    occupancies = []
    collapse_counts: dict[str, int] = {}
    problems = 0
    for health_path in sorted(variant_root.rglob("descriptor_health.json")):
        health = json.loads(health_path.read_text(encoding="utf-8"))
        problems += 1
        space = json.loads((health_path.parent / "archive_space.json").read_text(encoding="utf-8"))
        mode = str(space.get("initialization_mode"))
        completions.append(mode == "warmup_complete")
        total = space.get("space_geometry", {}).get("total_cells") or 0
        occupied = health.get("occupied_cells") or 0
        occupancies.append((occupied / total) if total else 0.0)
        for axis in health.get("collapsed_axes") or []:
            collapse_counts[axis] = collapse_counts.get(axis, 0) + 1
    assert problems, f"no descriptor_health.json under {variant_root}"

    median_occupancy = statistics.median(occupancies)
    return {
        "paired_best_quality_delta": best.get("mean_delta"),
        "wins": best.get("wins"),
        "losses": best.get("losses"),
        "ties": best.get("ties"),
        "problems": problems,
        "warmup_completion_rate": sum(completions) / problems,
        "median_occupancy": median_occupancy,
        "occupancy_floor_pass": median_occupancy >= OCCUPANCY_FLOOR,
        "collapse_counts": collapse_counts,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--profile",
        action="append",
        required=True,
        metavar="NAME=STATS_JSON=VARIANT_ROOT",
        help="One registered profile's evidence locations (repeatable).",
    )
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)

    evidence: dict[str, dict[str, object]] = {}
    for item in args.profile:
        name, stats_json, variant_root = item.split("=", 2)
        evidence[name] = profile_evidence(Path(stats_json), Path(variant_root))

    # Frozen ordering: best paired delta first; median occupancy breaks ties.
    ranking = sorted(
        evidence.items(),
        key=lambda kv: (
            -(kv[1]["paired_best_quality_delta"] or float("-inf")),
            -(kv[1]["median_occupancy"] or 0.0),
        ),
    )
    report = {
        "rule": (
            "paired best-quality delta, then median occupancy; occupancy "
            f"floor {OCCUPANCY_FLOOR}; warmup-completion rate and collapse "
            "counts are headline pre-registered evidence"
        ),
        "profiles": evidence,
        "ranking": [name for name, _ in ranking],
        "floor_failures": [
            name for name, entry in evidence.items()
            if not entry["occupancy_floor_pass"]
        ],
    }
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "descriptor_bakeoff.json").write_text(
        json.dumps(report, indent=2), encoding="utf-8"
    )
    lines = [
        "# Descriptor Bake-off",
        "",
        "| Profile | delta | W/L/T | warmup-complete | median occ | floor | collapses |",
        "| --- | --- | --- | --- | --- | --- | --- |",
    ]
    for name, entry in ranking:
        lines.append(
            f"| {name} | {entry['paired_best_quality_delta']:+.4f} | "
            f"{entry['wins']}/{entry['losses']}/{entry['ties']} | "
            f"{entry['warmup_completion_rate']:.0%} | "
            f"{entry['median_occupancy']:.2f} | "
            f"{'PASS' if entry['occupancy_floor_pass'] else 'FAIL'} | "
            f"{sum(entry['collapse_counts'].values())} |"
        )
    lines.append("")
    (args.output_dir / "descriptor_bakeoff.md").write_text("\n".join(lines), encoding="utf-8")
    for name, entry in ranking:
        print(f"{name}: delta={entry['paired_best_quality_delta']:+.4f} "
              f"warmup={entry['warmup_completion_rate']:.0%} occ={entry['median_occupancy']:.2f}")
    print(f"Report -> {args.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
