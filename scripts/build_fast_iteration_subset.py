#!/usr/bin/env python3
"""Build the locked fast-iteration validation subset for quick comparisons.

Selects a small, PPA-discriminative problem set for fast classic-vs-journal
iteration (minutes, not hours). Selection criteria, predeclared:

- high one-shot functionality rate (default >= 0.6) so both arms produce
  valid-PPA samples quickly (the hard subset deliberately uses the opposite
  regime and is too slow for tight loops);
- reference gate count in a headroom band (default 150-3000): large enough
  that PPA optimization has real margin, small enough that synthesis stays
  fast;
- excludes the hard-iteration subset problems so the two tuning artifacts
  stay independent;
- deterministic bucket rule: within each (benchmark x circuit_type) bucket
  rank by gate count descending and take the top problem, then top up to
  the subset size by overall gate count with a per-benchmark cap.

The output config embeds the recommended fast budget (population 10,
3 generations) and is a TUNING/DEV artifact only: it must never be used as
publication evidence, and the future held-out final set must exclude these
problems (recorded in the config provenance).
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import sys
from pathlib import Path
from typing import Any

import yaml

DEFAULT_CSV = (
    Path(__file__).resolve().parent.parent
    / "baselines"
    / "hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv"
)
DEFAULT_HARD_SUBSET = (
    Path(__file__).resolve().parent.parent
    / "data"
    / "configs"
    / "hard_iteration_subset.yaml"
)
DEFAULT_OUTPUT = (
    Path(__file__).resolve().parent.parent
    / "data"
    / "configs"
    / "fast_iteration_subset.yaml"
)


def load_problem_pool(csv_path: Path) -> list[dict[str, Any]]:
    with csv_path.open("r", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    pool: list[dict[str, Any]] = []
    for row in rows:
        try:
            pool.append(
                {
                    "benchmark": row["benchmark"],
                    "problem": row["problem"],
                    "reference_gate_count": float(row["reference_gate_count"] or 0),
                    "circuit_type": row["circuit_type"] or "unknown",
                    "functionality_rate": float(row["functionality_rate"] or 0),
                }
            )
        except (KeyError, ValueError):
            continue
    return pool


def load_excluded_problems(hard_subset_config: Path | None) -> set[str]:
    if hard_subset_config is None or not hard_subset_config.is_file():
        return set()
    payload = yaml.safe_load(hard_subset_config.read_text(encoding="utf-8"))
    excluded: set[str] = set()
    for body in (payload.get("benchmarks", {}) or {}).values():
        for problem in (body or {}).get("problems", []) or []:
            excluded.add(str(problem))
    return excluded


def select_fast_subset(
    pool: list[dict[str, Any]],
    *,
    excluded: set[str],
    min_functionality: float = 0.6,
    min_gates: float = 150.0,
    max_gates: float = 3000.0,
    subset_size: int = 6,
    per_benchmark_cap: int = 3,
) -> list[dict[str, Any]]:
    candidates = [
        entry
        for entry in pool
        if entry["problem"] not in excluded
        and entry["functionality_rate"] >= min_functionality
        and min_gates <= entry["reference_gate_count"] <= max_gates
        and entry["circuit_type"] in ("sequential", "combinational")
    ]
    candidates.sort(
        key=lambda entry: (-entry["reference_gate_count"], entry["problem"])
    )

    selected: list[dict[str, Any]] = []
    selected_names: set[str] = set()
    buckets: set[tuple[str, str]] = set()
    # Stage 1: best problem per (benchmark, circuit_type) bucket.
    for entry in candidates:
        bucket = (entry["benchmark"], entry["circuit_type"])
        if bucket in buckets:
            continue
        buckets.add(bucket)
        selected.append({**entry, "selection_stage": "bucket_top"})
        selected_names.add(entry["problem"])
        if len(selected) >= subset_size:
            break
    # Stage 2: top up by gate count with a per-benchmark cap.
    if len(selected) < subset_size:
        for entry in candidates:
            if entry["problem"] in selected_names:
                continue
            benchmark_count = sum(
                1 for item in selected if item["benchmark"] == entry["benchmark"]
            )
            if benchmark_count >= per_benchmark_cap:
                continue
            selected.append({**entry, "selection_stage": "gate_count_top_up"})
            selected_names.add(entry["problem"])
            if len(selected) >= subset_size:
                break
    return selected


def build_config_payload(
    *,
    csv_path: Path,
    selected: list[dict[str, Any]],
    params: dict[str, Any],
) -> dict[str, Any]:
    repo_root = Path(__file__).resolve().parent.parent
    try:
        csv_display = str(csv_path.relative_to(repo_root))
    except ValueError:
        csv_display = str(csv_path)
    benchmarks: dict[str, dict[str, list[str]]] = {}
    for entry in sorted(selected, key=lambda e: (e["benchmark"], e["problem"])):
        benchmarks.setdefault(entry["benchmark"], {"problems": []})["problems"].append(
            entry["problem"]
        )
    return {
        "version": 1,
        "subset_name": "fast_iteration_subset_v1",
        "purpose": (
            "fast classic-vs-journal-variant validation loop; TUNING/DEV "
            "artifact only — never publication evidence; the held-out final "
            "problem set must exclude these problems"
        ),
        "selection": {
            "source_csv": csv_display,
            "source_csv_sha256": hashlib.sha256(csv_path.read_bytes()).hexdigest(),
            **params,
            "rule": (
                "filter by functionality/gate band, exclude hard subset; "
                "top gate-count problem per (benchmark x circuit_type) "
                "bucket, then top up by gate count with per-benchmark cap"
            ),
            "subset_size": len(selected),
        },
        "recommended_budget": {
            "population_size": 10,
            "num_generations": 3,
            "code_samples_per_thought": 4,
            "max_tokens": 128000,
            "diff_max_tokens": 128000,
            "total_worker_slots": 12,
            "max_active_problems": 6,
            "max_workers_per_problem": 4,
            "evaluation_mode": "strict_ablation",
            "notes": (
                "~240 candidate evaluations total (6 problems x (10 init + "
                "3x10 offspring)) vs ~1560 for the 13-problem 20x5 hard-subset "
                "matrix; high functionality keeps valid-PPA sample flow high "
                "so paired PPA deltas are populated"
            ),
        },
        "problems_detail": [
            {
                "benchmark": entry["benchmark"],
                "problem": entry["problem"],
                "reference_gate_count": entry["reference_gate_count"],
                "circuit_type": entry["circuit_type"],
                "one_shot_functionality_rate": entry["functionality_rate"],
                "selection_stage": entry["selection_stage"],
            }
            for entry in sorted(
                selected, key=lambda e: -e["reference_gate_count"]
            )
        ],
        "benchmarks": benchmarks,
    }


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-csv", type=Path, default=DEFAULT_CSV)
    parser.add_argument(
        "--hard-subset-config", type=Path, default=DEFAULT_HARD_SUBSET
    )
    parser.add_argument("--output-config", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--min-functionality", type=float, default=0.6)
    parser.add_argument("--min-gates", type=float, default=150.0)
    parser.add_argument("--max-gates", type=float, default=3000.0)
    parser.add_argument("--subset-size", type=int, default=6)
    parser.add_argument("--per-benchmark-cap", type=int, default=3)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    if not args.source_csv.is_file():
        print(f"error: source CSV not found: {args.source_csv}", file=sys.stderr)
        return 2
    pool = load_problem_pool(args.source_csv)
    excluded = load_excluded_problems(args.hard_subset_config)
    selected = select_fast_subset(
        pool,
        excluded=excluded,
        min_functionality=args.min_functionality,
        min_gates=args.min_gates,
        max_gates=args.max_gates,
        subset_size=args.subset_size,
        per_benchmark_cap=args.per_benchmark_cap,
    )
    if len(selected) < args.subset_size:
        print(
            f"error: only {len(selected)} problems matched the filters "
            f"(requested {args.subset_size})",
            file=sys.stderr,
        )
        return 2
    payload = build_config_payload(
        csv_path=args.source_csv,
        selected=selected,
        params={
            "min_functionality": args.min_functionality,
            "min_gates": args.min_gates,
            "max_gates": args.max_gates,
            "per_benchmark_cap": args.per_benchmark_cap,
            "excluded_hard_subset_problems": len(excluded),
        },
    )
    args.output_config.parent.mkdir(parents=True, exist_ok=True)
    args.output_config.write_text(
        yaml.safe_dump(payload, sort_keys=False), encoding="utf-8"
    )
    print(f"Locked fast-iteration subset: {len(selected)} problems -> {args.output_config}")
    for entry in payload["problems_detail"]:
        print(
            f"  {entry['benchmark']:25s} {entry['problem']:30s} "
            f"gates={entry['reference_gate_count']:.0f} "
            f"func={entry['one_shot_functionality_rate']:.1f} "
            f"{entry['circuit_type']} ({entry['selection_stage']})"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
