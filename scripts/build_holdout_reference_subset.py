#!/usr/bin/env python3
"""Build the locked held-out reference-PPA EVIDENCE subset.

Final-gate evidence for the reference-PPA suites must be disjoint from
every tuning artifact (narrative contamination rules). This builder
selects a stratified, seeded sample from the one-shot problem pool:

- excludes the hard-iteration subset and every fast-iteration-instrument
  problem (all versions), read from their locked configs;
- requires reference gate count >= 50 (the paper's PPA-meaningfulness
  threshold) and a known circuit type;
- applies NO functionality filter: an evidence set biased toward easy
  problems would inflate both arms, and the penalized missing-as-loss
  statistics handle hard problems honestly;
- stratifies proportionally over (benchmark x circuit_type) buckets with
  largest-remainder rounding, seeded shuffle inside each bucket.

The locked YAML embeds the source-CSV sha256 and the full exclusion list
so drift or contamination is mechanically detectable.
"""

from __future__ import annotations

import argparse
import hashlib
import random
import sys
from pathlib import Path
from typing import Any

import yaml

REPO = Path(__file__).resolve().parent.parent
DEFAULT_CSV = REPO / "baselines" / "hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv"
DEFAULT_EXCLUDE_CONFIGS = (
    REPO / "data" / "configs" / "hard_iteration_subset.yaml",
    REPO / "data" / "configs" / "fast_iteration_subset.yaml",
    REPO / "data" / "configs" / "fast_iteration_subset_v2.yaml",
    REPO / "data" / "configs" / "fast_iteration_subset_v3.yaml",
)
DEFAULT_OUTPUT = REPO / "data" / "configs" / "holdout_reference_subset.yaml"


def load_pool(csv_path: Path) -> list[dict[str, Any]]:
    import csv as csv_mod

    pool = []
    with csv_path.open("r", encoding="utf-8") as handle:
        for row in csv_mod.DictReader(handle):
            try:
                pool.append(
                    {
                        "benchmark": row["benchmark"],
                        "problem": row["problem"],
                        "gates": float(row["reference_gate_count"] or 0),
                        "circuit_type": row["circuit_type"] or "unknown",
                    }
                )
            except (KeyError, ValueError):
                continue
    return pool


def load_exclusions(configs: list[Path]) -> set[str]:
    excluded: set[str] = set()
    for config in configs:
        if not config.is_file():
            continue
        payload = yaml.safe_load(config.read_text(encoding="utf-8"))
        for body in (payload.get("benchmarks", {}) or {}).values():
            for problem in (body or {}).get("problems", []) or []:
                excluded.add(str(problem))
    return excluded


def select_holdout(
    pool: list[dict[str, Any]],
    *,
    excluded: set[str],
    subset_size: int,
    seed: int,
    min_gates: float = 50.0,
) -> list[dict[str, Any]]:
    eligible = [
        entry
        for entry in pool
        if entry["problem"] not in excluded
        and entry["gates"] >= min_gates
        and entry["circuit_type"] in ("sequential", "combinational")
    ]
    buckets: dict[tuple[str, str], list[dict[str, Any]]] = {}
    for entry in eligible:
        buckets.setdefault((entry["benchmark"], entry["circuit_type"]), []).append(entry)

    # Proportional allocation with largest-remainder rounding.
    total = len(eligible)
    assert total >= subset_size, f"only {total} eligible problems"
    exact = {key: subset_size * len(items) / total for key, items in buckets.items()}
    counts = {key: int(value) for key, value in exact.items()}
    remainders = sorted(
        exact, key=lambda key: exact[key] - counts[key], reverse=True
    )
    for key in remainders:
        if sum(counts.values()) >= subset_size:
            break
        counts[key] += 1

    selected: list[dict[str, Any]] = []
    for key in sorted(buckets):
        items = sorted(buckets[key], key=lambda entry: entry["problem"])
        rng = random.Random(f"{seed}:{key[0]}:{key[1]}")
        rng.shuffle(items)
        selected.extend(items[: counts.get(key, 0)])
    return selected


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-csv", type=Path, default=DEFAULT_CSV)
    parser.add_argument(
        "--exclude-config", type=Path, action="append", default=None
    )
    parser.add_argument("--output-config", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--subset-size", type=int, default=20)
    parser.add_argument("--seed", type=int, default=7777)
    args = parser.parse_args(argv)

    if not args.source_csv.is_file():
        print(f"error: source CSV not found: {args.source_csv}", file=sys.stderr)
        return 2
    exclude_configs = (
        args.exclude_config
        if args.exclude_config is not None
        else list(DEFAULT_EXCLUDE_CONFIGS)
    )
    excluded = load_exclusions(exclude_configs)
    pool = load_pool(args.source_csv)
    selected = select_holdout(
        pool, excluded=excluded, subset_size=args.subset_size, seed=args.seed
    )
    assert len(selected) == args.subset_size

    benchmarks: dict[str, dict[str, list[str]]] = {}
    for entry in sorted(selected, key=lambda e: (e["benchmark"], e["problem"])):
        benchmarks.setdefault(entry["benchmark"], {"problems": []})["problems"].append(
            entry["problem"]
        )
    payload = {
        "version": 1,
        "subset_name": "holdout_reference_subset_v1",
        "purpose": (
            "held-out reference-PPA EVIDENCE set for final gates; disjoint "
            "from all tuning artifacts (hard subset, fast-iteration "
            "instrument all versions, debug slices); never used for repair, "
            "screening, or descriptor selection"
        ),
        "selection": {
            "source_csv": str(args.source_csv.relative_to(REPO)),
            "source_csv_sha256": hashlib.sha256(args.source_csv.read_bytes()).hexdigest(),
            "seed": args.seed,
            "min_gates": 50,
            "functionality_filter": "none (evidence sets must not bias easy)",
            "rule": (
                "stratified proportional over (benchmark x circuit_type) with "
                "largest-remainder rounding; seeded shuffle per bucket "
                "(random.Random(f'{seed}:{benchmark}:{type}'))"
            ),
            "excluded_problems": sorted(excluded),
            "subset_size": len(selected),
        },
        "benchmarks": benchmarks,
    }
    args.output_config.parent.mkdir(parents=True, exist_ok=True)
    args.output_config.write_text(yaml.safe_dump(payload, sort_keys=False), encoding="utf-8")
    print(f"Locked held-out reference subset: {len(selected)} problems -> {args.output_config}")
    for entry in sorted(selected, key=lambda e: (e["benchmark"], e["problem"])):
        print(f"  {entry['benchmark']:25s} {entry['problem']:32s} gates={entry['gates']:.0f} {entry['circuit_type']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
