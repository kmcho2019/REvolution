#!/usr/bin/env python3
"""Build the locked RealBench debug subset manifest for the journal revamp.

Selects a deterministic, family-balanced slice of harness-validated RealBench
module tasks (default: 4 tasks per family across sdc/aes/e203_hbirdv2 for a
12-task debug gate) from a generated ``module_manifest.json`` (see
``scripts/build_realbench_manifest.py``). Only tasks whose golden reference
implementation passed strict harness validation are eligible, so debug-gate
failures point at candidates, not harness dialect issues. The locked YAML
embeds the manifest hash so dataset drift is detectable.
"""

from __future__ import annotations

import argparse
import json
import random
import sys
from pathlib import Path
from typing import Any

import yaml

DEFAULT_ROOT = (
    Path(__file__).resolve().parent.parent / "data" / "bench" / "RealBench"
)
DEFAULT_OUTPUT = (
    Path(__file__).resolve().parent.parent
    / "data"
    / "configs"
    / "realbench_debug_subset.yaml"
)


def load_manifest(realbench_root: Path) -> dict[str, Any]:
    manifest_path = realbench_root / "module_manifest.json"
    if not manifest_path.is_file():
        raise FileNotFoundError(
            f"module_manifest.json not found under {realbench_root}; "
            "run scripts/build_realbench_manifest.py first."
        )
    payload = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(payload, dict) or "problems" not in payload:
        raise ValueError(f"Malformed RealBench manifest: {manifest_path}")
    return payload


def eligible_tasks_by_family(
    manifest: dict[str, Any],
    *,
    require_validated: bool = True,
) -> dict[str, list[str]]:
    by_family: dict[str, list[str]] = {}
    for entry in manifest.get("problems", []):
        if not isinstance(entry, dict):
            continue
        if str(entry.get("subset", "module")) != "module":
            continue
        if require_validated and not entry.get("harness_validated", False):
            continue
        family = str(entry.get("family", "unknown"))
        name = str(entry.get("problem_name", "")).strip()
        if name:
            by_family.setdefault(family, []).append(name)
    for names in by_family.values():
        names.sort()
    return by_family


def select_balanced_subset(
    manifest: dict[str, Any],
    *,
    per_family: int,
    seed: int,
    subset_size: int | None = None,
    require_validated: bool = True,
) -> dict[str, list[str]]:
    """Select a deterministic family-balanced sample of eligible tasks.

    Each family contributes up to ``per_family`` tasks from a seeded shuffle.
    If ``subset_size`` is larger than the balanced total (a family pool is
    too small), the shortfall is topped up deterministically: depth by depth,
    in sorted family order, from each family's remaining shuffled tasks.
    """

    by_family = eligible_tasks_by_family(manifest, require_validated=require_validated)
    shuffled_by_family: dict[str, list[str]] = {}
    for family in sorted(by_family):
        eligible = by_family[family]
        if not eligible:
            continue
        rng = random.Random(f"{seed}:{family}")
        shuffled = list(eligible)
        rng.shuffle(shuffled)
        shuffled_by_family[family] = shuffled

    picks: dict[str, list[str]] = {
        family: shuffled[:per_family]
        for family, shuffled in shuffled_by_family.items()
    }
    if subset_size is not None:
        total = sum(len(ids) for ids in picks.values())
        depth = per_family
        while total < subset_size:
            advanced = False
            for family in sorted(shuffled_by_family):
                if total >= subset_size:
                    break
                shuffled = shuffled_by_family[family]
                if depth < len(shuffled):
                    picks[family].append(shuffled[depth])
                    total += 1
                    advanced = True
            if not advanced:
                break
            depth += 1
    return {family: sorted(ids) for family, ids in picks.items() if ids}


def build_subset_payload(
    *,
    manifest: dict[str, Any],
    subset_name: str,
    per_family: int,
    seed: int,
    selection: dict[str, list[str]],
    realbench_root: Path,
) -> dict[str, Any]:
    all_ids = sorted(pid for ids in selection.values() for pid in ids)
    repo_root = Path(__file__).resolve().parent.parent
    try:
        root_display = str(realbench_root.relative_to(repo_root))
    except ValueError:
        root_display = str(realbench_root)
    return {
        "version": 1,
        "subset_name": subset_name,
        "selection": {
            "realbench_root": root_display,
            "manifest_sha256": str(manifest.get("manifest_sha256", "")),
            "require_harness_validated": True,
            "per_family": per_family,
            "seed": seed,
            "rule": (
                "per family: seeded shuffle (random.Random(f'{seed}:{family}')) "
                "over lexicographically sorted harness-validated module tasks, "
                "take first per_family, then top up depth-by-depth in sorted "
                "family order until subset_size; store sorted"
            ),
            "subset_size": len(all_ids),
        },
        "families": {family: list(ids) for family, ids in sorted(selection.items())},
        "benchmarks": {
            "RealBench": {
                "problems": all_ids,
            }
        },
    }


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--realbench-root",
        type=Path,
        default=DEFAULT_ROOT,
        help="Generated RealBench manifest root.",
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
        default="realbench_debug_subset_v1",
        help="Manifest subset_name field.",
    )
    parser.add_argument(
        "--per-family",
        type=int,
        default=4,
        help="Number of tasks selected per family.",
    )
    parser.add_argument(
        "--subset-size",
        type=int,
        default=12,
        help="Total locked subset size; shortfalls against per-family "
        "balance are topped up deterministically from larger families.",
    )
    parser.add_argument("--seed", type=int, default=42, help="Deterministic seed.")
    parser.add_argument(
        "--allow-unvalidated",
        action="store_true",
        help="Permit tasks without harness_validated=true (not recommended).",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    try:
        manifest = load_manifest(args.realbench_root.resolve())
    except (FileNotFoundError, ValueError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    selection = select_balanced_subset(
        manifest,
        per_family=args.per_family,
        seed=args.seed,
        subset_size=args.subset_size,
        require_validated=not args.allow_unvalidated,
    )
    if not selection:
        print("error: no eligible RealBench tasks found", file=sys.stderr)
        return 2

    payload = build_subset_payload(
        manifest=manifest,
        subset_name=args.subset_name,
        per_family=args.per_family,
        seed=args.seed,
        selection=selection,
        realbench_root=args.realbench_root.resolve(),
    )
    args.output_config.parent.mkdir(parents=True, exist_ok=True)
    args.output_config.write_text(
        yaml.safe_dump(payload, sort_keys=False),
        encoding="utf-8",
    )

    total = payload["selection"]["subset_size"]
    print(f"Locked RealBench debug subset: {total} tasks -> {args.output_config}")
    for family, ids in sorted(selection.items()):
        print(f"  {family}: {', '.join(ids)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
