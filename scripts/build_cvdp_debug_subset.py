#!/usr/bin/env python3
"""Build the locked CVDP debug subset manifest for the journal revamp.

Selects a deterministic, category-balanced slice of CVDP non-agentic tasks
(default: 2 medium tasks per challenge category) and writes a locked YAML
manifest in the same shape as ``data/configs/hard_iteration_subset.yaml``.
Selection uses a seeded shuffle over lexicographically sorted ids per
category, so the same dataset, seed, and parameters always reproduce the
same subset. The manifest records dataset provenance (path and sha256) so
later runs can detect dataset drift.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import random
import sys
from pathlib import Path
from typing import Any

import yaml

DEFAULT_DATASET = (
    Path(__file__).resolve().parent.parent
    / "data"
    / "bench"
    / "cvdp"
    / "cvdp_v1.0.2_nonagentic_code_generation_no_commercial.jsonl"
)
DEFAULT_OUTPUT = (
    Path(__file__).resolve().parent.parent
    / "data"
    / "configs"
    / "cvdp_debug_subset.yaml"
)


def load_cvdp_category_index(jsonl_path: Path) -> dict[str, list[str]]:
    """Map challenge category (cidNNN) -> sorted ids, filtered later by difficulty."""

    index: dict[str, list[str]] = {}
    with jsonl_path.open("r", encoding="utf-8") as handle:
        for line in handle:
            text = line.strip()
            if not text:
                continue
            try:
                payload = json.loads(text)
            except json.JSONDecodeError:
                continue
            record_id = payload.get("id")
            if not isinstance(record_id, str) or not record_id:
                continue
            categories = [str(c).lower() for c in payload.get("categories", [])]
            cid = next((c for c in categories if c.startswith("cid")), None)
            if cid is None:
                continue
            index.setdefault(cid, []).append(record_id)
    for ids in index.values():
        ids.sort()
    return index


def load_cvdp_difficulty_map(jsonl_path: Path) -> dict[str, str]:
    """Map record id -> difficulty label (non-cid category), default 'unknown'."""

    difficulty: dict[str, str] = {}
    with jsonl_path.open("r", encoding="utf-8") as handle:
        for line in handle:
            text = line.strip()
            if not text:
                continue
            try:
                payload = json.loads(text)
            except json.JSONDecodeError:
                continue
            record_id = payload.get("id")
            if not isinstance(record_id, str) or not record_id:
                continue
            categories = [str(c).lower() for c in payload.get("categories", [])]
            label = next((c for c in categories if not c.startswith("cid")), "unknown")
            difficulty[record_id] = label
    return difficulty


def load_excluded_ids(config_paths: list[Path]) -> frozenset[str]:
    """Collect benchmark ids from locked subset manifests for exclusion."""

    excluded: set[str] = set()
    for path in config_paths:
        payload = yaml.safe_load(path.read_text(encoding="utf-8"))
        benchmarks = payload["benchmarks"]
        assert isinstance(benchmarks, dict), f"malformed manifest: {path}"
        for entry in benchmarks.values():
            excluded.update(str(pid) for pid in entry["problems"])
    return frozenset(excluded)


def select_balanced_subset(
    *,
    jsonl_path: Path,
    difficulty: str,
    per_category: int,
    seed: int,
    exclude_ids: frozenset[str] = frozenset(),
) -> dict[str, list[str]]:
    """Select a deterministic per-category sample at the requested difficulty."""

    category_index = load_cvdp_category_index(jsonl_path)
    difficulty_map = load_cvdp_difficulty_map(jsonl_path)
    selection: dict[str, list[str]] = {}
    for cid in sorted(category_index):
        eligible = [
            record_id
            for record_id in category_index[cid]
            if difficulty_map.get(record_id) == difficulty.lower()
            and record_id not in exclude_ids
        ]
        if not eligible:
            continue
        rng = random.Random(f"{seed}:{cid}")
        shuffled = list(eligible)
        rng.shuffle(shuffled)
        selection[cid] = sorted(shuffled[:per_category])
    return selection


def build_manifest_payload(
    *,
    jsonl_path: Path,
    subset_name: str,
    difficulty: str,
    per_category: int,
    seed: int,
    selection: dict[str, list[str]],
    exclude_configs: list[Path],
    exclude_ids: frozenset[str],
) -> dict[str, Any]:
    all_ids = sorted(pid for ids in selection.values() for pid in ids)
    dataset_sha256 = hashlib.sha256(jsonl_path.read_bytes()).hexdigest()
    repo_root = Path(__file__).resolve().parent.parent
    try:
        dataset_display = str(jsonl_path.relative_to(repo_root))
    except ValueError:
        dataset_display = str(jsonl_path)
    return {
        "version": 1,
        "subset_name": subset_name,
        "selection": {
            "dataset": dataset_display,
            "dataset_sha256": dataset_sha256,
            "difficulty": difficulty,
            "per_category": per_category,
            "seed": seed,
            "rule": (
                "per challenge category (cidNNN): seeded shuffle "
                "(random.Random(f'{seed}:{cid}')) over lexicographically sorted "
                "eligible ids, take first per_category, store sorted"
            ),
            "subset_size": len(all_ids),
            "excluded_configs": [str(path) for path in exclude_configs],
            "excluded_id_count": len(exclude_ids),
        },
        "categories": {cid: list(ids) for cid, ids in sorted(selection.items())},
        "benchmarks": {
            "cvdp": {
                "problems": all_ids,
            }
        },
    }


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--cvdp_jsonl",
        type=Path,
        default=DEFAULT_DATASET,
        help="Path to the CVDP non-agentic JSONL dataset.",
    )
    parser.add_argument(
        "--output-config",
        type=Path,
        default=DEFAULT_OUTPUT,
        help="Locked subset manifest output path (YAML).",
    )
    parser.add_argument(
        "--subset-name",
        type=str,
        default="cvdp_debug_subset_v1",
        help="Manifest subset_name field.",
    )
    parser.add_argument(
        "--difficulty",
        type=str,
        default="medium",
        help="Difficulty label that selected tasks must carry.",
    )
    parser.add_argument(
        "--per-category",
        type=int,
        default=2,
        help="Number of tasks selected per challenge category.",
    )
    parser.add_argument("--seed", type=int, default=42, help="Deterministic seed.")
    parser.add_argument(
        "--exclude-config",
        type=Path,
        action="append",
        default=[],
        help="Locked subset manifest whose benchmark ids are excluded "
        "(repeatable; predeclared rule for fresh final slices).",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    jsonl_path = args.cvdp_jsonl.resolve()
    if not jsonl_path.is_file():
        print(f"error: dataset not found: {jsonl_path}", file=sys.stderr)
        return 2

    exclude_ids = load_excluded_ids(args.exclude_config)
    selection = select_balanced_subset(
        jsonl_path=jsonl_path,
        difficulty=args.difficulty,
        per_category=args.per_category,
        seed=args.seed,
        exclude_ids=exclude_ids,
    )
    if not selection:
        print(
            f"error: no tasks matched difficulty '{args.difficulty}'",
            file=sys.stderr,
        )
        return 2

    payload = build_manifest_payload(
        jsonl_path=jsonl_path,
        subset_name=args.subset_name,
        difficulty=args.difficulty,
        per_category=args.per_category,
        seed=args.seed,
        selection=selection,
        exclude_configs=list(args.exclude_config),
        exclude_ids=exclude_ids,
    )
    args.output_config.parent.mkdir(parents=True, exist_ok=True)
    args.output_config.write_text(
        yaml.safe_dump(payload, sort_keys=False),
        encoding="utf-8",
    )

    total = payload["selection"]["subset_size"]
    print(f"Locked CVDP debug subset: {total} tasks -> {args.output_config}")
    for cid, ids in sorted(selection.items()):
        print(f"  {cid}: {', '.join(ids)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
