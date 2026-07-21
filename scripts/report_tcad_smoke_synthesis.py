#!/usr/bin/env python3
"""Record smoke synthesis starts from raw REvolution generation logs."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any


def _read_arm(root: Path) -> dict[str, Any]:
    paths = sorted(root.rglob("generation_log.jsonl"))
    assert len(paths) == 3
    candidates = []
    sources = []
    for path in paths:
        records = [json.loads(line) for line in path.read_text().splitlines()]
        assert [record["generation"] for record in records] == [0, 1]
        assert all(len(record["generated_candidates"]) == 8 for record in records)
        candidates.extend(
            candidate
            for record in records
            for candidate in record["generated_candidates"]
        )
        sources.append(
            {
                "problem": path.parent.name,
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
        )
    assert all(type(candidate["rtl_simulation_success"]) is bool for candidate in candidates)
    return {
        "candidate_count": len(candidates),
        "synthesis_starts": sum(candidate["rtl_simulation_success"] for candidate in candidates),
        "generation_logs": sources,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--classic-root", type=Path, required=True)
    parser.add_argument("--treatment-root", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    result = {
        "definition": "generated_candidates_with_rtl_simulation_success",
        "classic": _read_arm(args.classic_root),
        "treatment": _read_arm(args.treatment_root),
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
