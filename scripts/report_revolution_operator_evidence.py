#!/usr/bin/env python3
"""Report descriptive operator yields from REvolution generation logs."""

from __future__ import annotations

import argparse
import csv
import json
import math
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
    fail_policy_units: list[dict[str, str]] = []
    policy_totals: Counter[tuple[str, int, str]] = Counter()
    policy_sums: defaultdict[tuple[str, int, str], float] = defaultdict(float)
    policy_operator_sets: dict[tuple[str, int], tuple[str, ...]] = {}

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
                pool_counts = generation["strategy_counts_for_each_origin_pool"]
                pool_probabilities = generation["average_strategy_probabilities"]
                assert isinstance(pool_counts, dict)
                assert isinstance(pool_probabilities, dict)
                fail_counts = pool_counts["fail_pool"]
                assert isinstance(fail_counts, dict)
                if fail_counts:
                    fail_probabilities = pool_probabilities["fail_pool"]
                    assert isinstance(fail_probabilities, dict)
                    generation_index = generation["generation"]
                    assert isinstance(generation_index, int) and generation_index > 0
                    assert "M-F" in fail_probabilities
                    assert set(fail_counts) <= set(fail_probabilities)
                    assert all(
                        isinstance(value, int) and value >= 0
                        for value in fail_counts.values()
                    )
                    assert all(
                        isinstance(value, int | float) and value >= 0
                        for value in fail_probabilities.values()
                    )
                    assert abs(sum(fail_probabilities.values()) - 1.0) < 1e-9
                    request_count = sum(fail_counts.values())
                    assert request_count > 0
                    operators = tuple(sorted(fail_probabilities))
                    group = (label, generation_index)
                    if group in policy_operator_sets:
                        assert policy_operator_sets[group] == operators
                    policy_operator_sets[group] = operators
                    uniform_probability = 1.0 / len(operators)
                    total_variation = 0.5 * sum(
                        abs(fail_probabilities[operator] - uniform_probability)
                        for operator in operators
                    )
                    normalized_entropy = 1.0
                    if len(operators) > 1:
                        normalized_entropy = -sum(
                            probability * math.log(probability)
                            for probability in fail_probabilities.values()
                            if probability > 0
                        ) / math.log(len(operators))
                    mf_requests = fail_counts.get("M-F", 0)
                    mf_is_max = fail_probabilities["M-F"] == max(
                        fail_probabilities.values()
                    )
                    fail_policy_units.append(
                        {
                            "arm": label,
                            "generation": str(generation_index),
                            "generation_log": str(path.relative_to(root)),
                            "operator_set": ";".join(operators),
                            "fail_parent_requests": str(request_count),
                            "m_f_requests": str(mf_requests),
                            "m_f_request_fraction": f"{mf_requests / request_count:.12g}",
                            "m_f_probability": f"{fail_probabilities['M-F']:.12g}",
                            "m_f_is_max": str(int(mf_is_max)),
                            "normalized_entropy": f"{normalized_entropy:.12g}",
                            "total_variation_from_uniform": f"{total_variation:.12g}",
                        }
                    )
                    policy_totals[label, generation_index, "units"] += 1
                    policy_totals[label, generation_index, "requests"] += request_count
                    policy_totals[label, generation_index, "m_f_requests"] += (
                        mf_requests
                    )
                    policy_totals[label, generation_index, "m_f_is_max"] += int(
                        mf_is_max
                    )
                    policy_sums[label, generation_index, "m_f_probability"] += float(
                        fail_probabilities["M-F"]
                    )
                    policy_sums[label, generation_index, "normalized_entropy"] += (
                        normalized_entropy
                    )
                    policy_sums[label, generation_index, "total_variation"] += (
                        total_variation
                    )
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
    _write_csv(output_dir / "fail_policy_units.csv", fail_policy_units)
    fail_policy_rows: list[dict[str, str]] = []
    for label, generation_index in sorted(policy_operator_sets):
        units = policy_totals[label, generation_index, "units"]
        requests = policy_totals[label, generation_index, "requests"]
        mf_requests = policy_totals[label, generation_index, "m_f_requests"]
        assert units > 0 and requests > 0
        fail_policy_rows.append(
            {
                "arm": label,
                "generation": str(generation_index),
                "operator_set": ";".join(policy_operator_sets[label, generation_index]),
                "active_problem_seed_count": str(units),
                "fail_parent_requests": str(requests),
                "m_f_requests": str(mf_requests),
                "m_f_request_fraction": f"{mf_requests / requests:.12g}",
                "mean_m_f_probability": f"{policy_sums[label, generation_index, 'm_f_probability'] / units:.12g}",
                "m_f_is_max_fraction": f"{policy_totals[label, generation_index, 'm_f_is_max'] / units:.12g}",
                "mean_normalized_entropy": f"{policy_sums[label, generation_index, 'normalized_entropy'] / units:.12g}",
                "mean_total_variation_from_uniform": f"{policy_sums[label, generation_index, 'total_variation'] / units:.12g}",
            }
        )
    _write_csv(output_dir / "fail_policy_by_generation.csv", fail_policy_rows)
    arms = [
        {
            "arm": label,
            "root": str(root),
            "generation_log_count": arm_totals[label, "logs"],
            "generation_record_count": arm_totals[label, "generations"],
            "candidate_count": arm_totals[label, "candidates"],
            "llm_api_calls": int(arm_resources[label, "llm_api_calls"]),
            "llm_prompt_tokens": int(arm_resources[label, "llm_prompt_tokens"]),
            "llm_completion_tokens": int(arm_resources[label, "llm_completion_tokens"]),
            "runtime_seconds": arm_resources[label, "runtime_seconds"],
        }
        for label, root in runs
    ]
    summary: dict[str, object] = {
        "arms": arms,
        "operator_yield_csv": str(output_dir / "operator_yield.csv"),
        "status_distribution_csv": str(output_dir / "status_distribution.csv"),
        "fail_policy_units_csv": str(output_dir / "fail_policy_units.csv"),
        "fail_policy_by_generation_csv": str(
            output_dir / "fail_policy_by_generation.csv"
        ),
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
        "| Arm | Pool | Strategy | N | RTL-sim functional | Valid PPA | Rewarded |",
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
    report.extend(
        [
            "",
            "## Failed-Parent Allocation By Generation",
            "",
            "M-F-is-max includes ties. Total variation compares the logged",
            "selection probabilities with a uniform policy over the active",
            "failed-parent operator set.",
            "",
            "| Arm | Gen | Active units | Requests | M-F share | Mean M-F p | Mean TV |",
            "| --- | ---: | ---: | ---: | ---: | ---: | ---: |",
        ]
    )
    for row in fail_policy_rows:
        report.append(
            f"| {row['arm']} | {row['generation']} | "
            f"{row['active_problem_seed_count']} | {row['fail_parent_requests']} | "
            f"{float(row['m_f_request_fraction']):.1%} | "
            f"{float(row['mean_m_f_probability']):.1%} | "
            f"{float(row['mean_total_variation_from_uniform']):.1%} |"
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
