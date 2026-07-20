#!/usr/bin/env python3
"""Report descriptive operator yields from REvolution generation logs."""

from __future__ import annotations

import argparse
import csv
import json
from collections import Counter, defaultdict
from pathlib import Path
from typing import Literal


CandidateStatus = Literal[
    "success",
    "failed_format",
    "failed_diff",
    "failed_syntax",
    "failed_functionality",
    "failed_synthesis",
    "failed_synthesis_functionality",
]
OriginPool = Literal["initial", "fail_pool", "success_pool"]

STATUSES: tuple[CandidateStatus, ...] = (
    "success",
    "failed_format",
    "failed_diff",
    "failed_syntax",
    "failed_functionality",
    "failed_synthesis",
    "failed_synthesis_functionality",
)
POOLS: tuple[OriginPool, ...] = ("initial", "fail_pool", "success_pool")
SYNTAX_FAILURES = {"failed_format", "failed_diff", "failed_syntax"}
FUNCTION_FAILURES = SYNTAX_FAILURES | {"failed_functionality"}


def _parse_run(value: str) -> tuple[str, Path]:
    label, separator, raw_path = value.partition("=")
    if not separator:
        raise argparse.ArgumentTypeError(f"Expected LABEL=PATH, got {value!r}")
    assert label and raw_path
    return label, Path(raw_path).expanduser().resolve()


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def generate_operator_evidence_report(
    runs: list[tuple[str, Path]], output_dir: Path
) -> dict[str, object]:
    """Generate exact-status and rewarded-child summaries.

    Args:
        runs: Unique labels paired with completed method roots.
        output_dir: Directory for CSV, JSON, and Markdown outputs.

    Returns:
        JSON-serializable report summary.
    """
    assert runs and len({label for label, _ in runs}) == len(runs)
    counts: Counter[tuple[str, str, str, str]] = Counter()
    arm_totals: Counter[tuple[str, str]] = Counter()
    arm_resources: defaultdict[tuple[str, str], float] = defaultdict(float)
    log_paths: dict[str, list[str]] = {}

    for label, root in runs:
        paths = sorted(root.rglob("generation_log.jsonl"))
        assert paths, root
        log_paths[label] = [str(path) for path in paths]
        arm_totals[label, "logs"] = len(paths)
        for path in paths:
            for line in path.read_text(encoding="utf-8").splitlines():
                generation = json.loads(line)
                assert isinstance(generation, dict)
                candidates = generation["generated_candidates"]
                rewards = generation["strategy_rewards_this_generation"]
                assert isinstance(candidates, list) and isinstance(rewards, dict)
                arm_totals[label, "generations"] += 1
                for key in (
                    "llm_api_calls",
                    "llm_prompt_tokens",
                    "llm_completion_tokens",
                    "runtime_seconds",
                ):
                    value = generation[key]
                    assert isinstance(value, int | float) and value >= 0
                    arm_resources[label, key] += float(value)
                for candidate in candidates:
                    assert isinstance(candidate, dict)
                    status = candidate["status"]
                    pool = candidate["origin_pool"]
                    strategy = candidate["strategy"]
                    assert status in STATUSES
                    assert pool in POOLS
                    assert isinstance(strategy, str)
                    counts[label, pool, strategy, "candidates"] += 1
                    counts[label, pool, strategy, status] += 1
                    arm_totals[label, "candidates"] += 1
                for pool, strategy_rewards in rewards.items():
                    assert pool in {"fail_pool", "success_pool"}
                    assert isinstance(strategy_rewards, dict)
                    for strategy, reward in strategy_rewards.items():
                        assert isinstance(strategy, str)
                        assert isinstance(reward, int | float) and reward >= 0
                        assert float(reward).is_integer()
                        counts[label, pool, strategy, "rewarded"] += int(reward)

    operator_rows: list[dict[str, str]] = []
    operator_keys = sorted({key[:3] for key in counts})
    for label, pool, strategy in operator_keys:
        total = counts[label, pool, strategy, "candidates"]
        assert total > 0
        syntax_pass = total - sum(
            counts[label, pool, strategy, status] for status in SYNTAX_FAILURES
        )
        functional_pass = total - sum(
            counts[label, pool, strategy, status] for status in FUNCTION_FAILURES
        )
        success = counts[label, pool, strategy, "success"]
        rewarded = counts[label, pool, strategy, "rewarded"]
        assert rewarded <= success <= functional_pass <= syntax_pass <= total
        operator_rows.append(
            {
                "arm": label,
                "origin_pool": pool,
                "strategy": strategy,
                "candidate_count": str(total),
                "syntax_pass_count": str(syntax_pass),
                "pre_synthesis_functional_pass_count": str(functional_pass),
                "valid_ppa_success_count": str(success),
                "rewarded_child_count": str(rewarded),
                "syntax_pass_rate": f"{syntax_pass / total:.12g}",
                "pre_synthesis_functional_pass_rate": f"{functional_pass / total:.12g}",
                "valid_ppa_success_rate": f"{success / total:.12g}",
                "rewarded_child_rate": f"{rewarded / total:.12g}",
            }
        )

    status_rows: list[dict[str, str]] = []
    for label, _ in runs:
        for pool in POOLS:
            pool_total = sum(
                counts[arm, row_pool, strategy, "candidates"]
                for arm, row_pool, strategy in operator_keys
                if arm == label and row_pool == pool
            )
            if pool_total == 0:
                continue
            for status in STATUSES:
                count = sum(
                    counts[arm, row_pool, strategy, status]
                    for arm, row_pool, strategy in operator_keys
                    if arm == label and row_pool == pool
                )
                status_rows.append(
                    {
                        "arm": label,
                        "origin_pool": pool,
                        "status": status,
                        "candidate_count": str(count),
                        "pool_fraction": f"{count / pool_total:.12g}",
                    }
                )

    output_dir.mkdir(parents=True, exist_ok=True)
    _write_csv(output_dir / "operator_yield.csv", operator_rows)
    _write_csv(output_dir / "status_distribution.csv", status_rows)
    arms = [
        {
            "arm": label,
            "root": str(root),
            "generation_log_count": arm_totals[label, "logs"],
            "generation_record_count": arm_totals[label, "generations"],
            "candidate_count": arm_totals[label, "candidates"],
            "llm_api_calls": int(arm_resources[label, "llm_api_calls"]),
            "llm_prompt_tokens": int(arm_resources[label, "llm_prompt_tokens"]),
            "llm_completion_tokens": int(
                arm_resources[label, "llm_completion_tokens"]
            ),
            "runtime_seconds": arm_resources[label, "runtime_seconds"],
        }
        for label, root in runs
    ]
    summary: dict[str, object] = {
        "arms": arms,
        "operator_yield_csv": str(output_dir / "operator_yield.csv"),
        "status_distribution_csv": str(output_dir / "status_distribution.csv"),
        "generation_logs": log_paths,
    }
    (output_dir / "summary.json").write_text(
        json.dumps(summary, indent=2), encoding="utf-8"
    )

    report = [
        "# REvolution Operator Evidence",
        "",
        "These are descriptive rates under each arm's adaptive policy. Parent",
        "quality, pool state, and UCB selection are endogenous, so differences do",
        "not identify causal operator effects.",
        "",
        "`failed_synthesis` conflates synthesis and later PPA-flow failures in",
        "the classic logger. The report therefore preserves exact statuses and",
        "does not infer a post-synthesis pass rate.",
        "",
        "| Arm | Pool | Strategy | N | Functional | Valid PPA | Rewarded |",
        "| --- | --- | --- | ---: | ---: | ---: | ---: |",
    ]
    for row in operator_rows:
        report.append(
            f"| {row['arm']} | {row['origin_pool']} | {row['strategy']} | "
            f"{row['candidate_count']} | "
            f"{float(row['pre_synthesis_functional_pass_rate']):.1%} | "
            f"{float(row['valid_ppa_success_rate']):.1%} | "
            f"{float(row['rewarded_child_rate']):.1%} |"
        )
    (output_dir / "report.md").write_text("\n".join(report) + "\n", encoding="utf-8")
    return summary


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Report descriptive operator yields from generation logs."
    )
    parser.add_argument("--run", action="append", type=_parse_run, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)
    generate_operator_evidence_report(args.run, args.output_dir.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
