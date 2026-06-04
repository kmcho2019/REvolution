#!/usr/bin/env python3
from __future__ import annotations

import argparse
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT / "src") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "src"))

from revolution.prompt_tuning import (  # noqa: E402
    HARD_SUBSET_CONFIG,
    as_jsonable,
    render_validation_markdown,
    validate_optimized_against_baselines,
    write_json,
)


def _parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Validate classic vs baseline thought-only vs GEPA-optimized thought-only runs."
    )
    parser.add_argument("--classic-root", type=Path, required=True)
    parser.add_argument("--baseline-thought-root", type=Path, required=True)
    parser.add_argument("--optimized-thought-root", type=Path, required=True)
    parser.add_argument("--subset-config", type=Path, default=HARD_SUBSET_CONFIG)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--min-improvement-pp", type=float, default=1.0)
    parser.add_argument(
        "--require-full-subset",
        action=argparse.BooleanOptionalAction,
        default=True,
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(argv)
    result = validate_optimized_against_baselines(
        classic_root=args.classic_root.resolve(),
        baseline_root=args.baseline_thought_root.resolve(),
        optimized_root=args.optimized_thought_root.resolve(),
        subset_config=args.subset_config.resolve(),
        min_improvement_pp=args.min_improvement_pp,
        require_full_subset=args.require_full_subset,
    )
    payload = as_jsonable(result)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    json_path = args.output_dir / "gepa_prompt_tuning_validation.json"
    report_path = args.output_dir / "gepa_prompt_tuning_validation.md"
    write_json(json_path, payload)
    report_path.write_text(render_validation_markdown(payload), encoding="utf-8")
    print(f"Wrote {json_path}")
    print(f"Wrote {report_path}")
    return 0 if result.passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
