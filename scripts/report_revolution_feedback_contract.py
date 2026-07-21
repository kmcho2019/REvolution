#!/usr/bin/env python3
"""Audit classic REvolution critic feedback against terminal status."""

from __future__ import annotations

import argparse
import csv
import json
from collections import Counter
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
ContractClass = Literal["compliant", "mismatch", "undefined"]

STATUSES: tuple[CandidateStatus, ...] = (
    "success",
    "failed_format",
    "failed_diff",
    "failed_syntax",
    "failed_functionality",
    "failed_synthesis",
    "failed_synthesis_functionality",
)
CONTRACT_CLASSES: tuple[ContractClass, ...] = (
    "compliant",
    "mismatch",
    "undefined",
)


def _parse_run(value: str) -> tuple[str, Path]:
    label, separator, raw_path = value.partition("=")
    if not separator:
        raise argparse.ArgumentTypeError(f"Expected LABEL=PATH, got {value!r}")
    assert label and raw_path
    return label, Path(raw_path).expanduser().resolve()


def _classify(status: CandidateStatus, score: int) -> ContractClass:
    match status:
        case "success":
            return "compliant" if score == 10 else "mismatch"
        case "failed_format" | "failed_syntax":
            return "compliant" if score == 0 else "mismatch"
        case "failed_functionality":
            return "compliant" if 1 <= score <= 9 else "mismatch"
        case "failed_diff" | "failed_synthesis" | "failed_synthesis_functionality":
            return "undefined"


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def generate_feedback_contract_report(
    runs: list[tuple[str, Path]], output_dir: Path
) -> dict[str, object]:
    """Generate critic/status contract and failed-parent outcome summaries.

    Args:
        runs: Unique labels paired with completed classic run roots.
        output_dir: Directory for CSV, JSON, and Markdown outputs.

    Returns:
        JSON-serializable report summary.
    """
    assert runs and len({label for label, _ in runs}) == len(runs)
    candidate_rows: list[dict[str, str]] = []
    status_counts: Counter[tuple[str, str, str]] = Counter()
    outcome_counts: Counter[tuple[str, str, str]] = Counter()

    for label, root in runs:
        logs = sorted(root.rglob("generation_log.jsonl"))
        assert logs, root
        candidates_by_id: dict[str, dict[str, str]] = {}
        post_gen_children: list[dict[str, object]] = []

        for log_path in logs:
            problem = log_path.parent.name
            for line in log_path.read_text(encoding="utf-8").splitlines():
                generation = json.loads(line)
                assert isinstance(generation, dict)
                generation_index = generation["generation"]
                generated = generation["generated_candidates"]
                assert isinstance(generation_index, int) and generation_index >= 0
                assert isinstance(generated, list)

                for candidate in generated:
                    assert isinstance(candidate, dict)
                    candidate_id = candidate["id"]
                    status = candidate["status"]
                    code_file_path = candidate["code_file_path"]
                    assert isinstance(candidate_id, str) and candidate_id
                    assert status in STATUSES
                    assert isinstance(code_file_path, str) and code_file_path
                    feedback_path = Path(code_file_path).with_name("code_feedback.txt")
                    lines = feedback_path.read_text(encoding="utf-8").splitlines()
                    assert lines and lines[0].startswith("Score: "), feedback_path
                    score = int(lines[0].removeprefix("Score: "))
                    assert 0 <= score <= 10
                    contract_class = _classify(status, score)
                    row = {
                        "run": label,
                        "problem": problem,
                        "generation": str(generation_index),
                        "candidate_id": candidate_id,
                        "status": status,
                        "critic_score": str(score),
                        "contract_class": contract_class,
                        "false_score_10": str(int(status != "success" and score == 10)),
                        "feedback_path": str(feedback_path.relative_to(root)),
                    }
                    candidate_rows.append(row)
                    assert candidate_id not in candidates_by_id
                    candidates_by_id[candidate_id] = row
                    status_counts[label, status, contract_class] += 1

                    if generation_index > 0:
                        post_gen_children.append(candidate)

        for child in post_gen_children:
            if child["origin_pool"] != "fail_pool":
                continue
            parent_ids = child["parent_ids"]
            child_status = child["status"]
            assert isinstance(parent_ids, list) and len(parent_ids) == 1
            assert isinstance(parent_ids[0], str)
            assert child_status in STATUSES
            parent = candidates_by_id[parent_ids[0]]
            parent_class = parent["contract_class"]
            assert parent_class in CONTRACT_CLASSES
            outcome_counts[label, parent_class, "children"] += 1
            outcome_counts[label, parent_class, "valid_ppa"] += int(
                child_status == "success"
            )

    status_rows: list[dict[str, str]] = []
    for label, _ in runs:
        for status in STATUSES:
            total = sum(
                status_counts[label, status, contract_class]
                for contract_class in CONTRACT_CLASSES
            )
            if total == 0:
                continue
            for contract_class in CONTRACT_CLASSES:
                count = status_counts[label, status, contract_class]
                status_rows.append(
                    {
                        "run": label,
                        "status": status,
                        "contract_class": contract_class,
                        "candidate_count": str(count),
                        "status_fraction": f"{count / total:.12g}",
                    }
                )

    outcome_rows: list[dict[str, str]] = []
    for label, _ in runs:
        for contract_class in CONTRACT_CLASSES:
            child_count = outcome_counts[label, contract_class, "children"]
            if child_count == 0:
                continue
            valid_ppa = outcome_counts[label, contract_class, "valid_ppa"]
            outcome_rows.append(
                {
                    "run": label,
                    "parent_contract_class": contract_class,
                    "fail_origin_children": str(child_count),
                    "valid_ppa_children": str(valid_ppa),
                    "valid_ppa_rate": f"{valid_ppa / child_count:.12g}",
                }
            )

    summary_runs: list[dict[str, object]] = []
    for label, root in runs:
        rows = [row for row in candidate_rows if row["run"] == label]
        mismatch = sum(row["contract_class"] == "mismatch" for row in rows)
        undefined = sum(row["contract_class"] == "undefined" for row in rows)
        summary_runs.append(
            {
                "run": label,
                "root": str(root),
                "candidate_count": len(rows),
                "mismatch_count": mismatch,
                "undefined_count": undefined,
                "false_score_10_count": sum(
                    row["false_score_10"] == "1" for row in rows
                ),
            }
        )

    summary: dict[str, object] = {
        "runs": summary_runs,
        "candidate_count": len(candidate_rows),
        "contract": {
            "success": "score == 10",
            "failed_format": "score == 0",
            "failed_syntax": "score == 0",
            "failed_functionality": "1 <= score <= 9",
            "undefined": [
                "failed_diff",
                "failed_synthesis",
                "failed_synthesis_functionality",
            ],
        },
    }

    output_dir.mkdir(parents=True, exist_ok=True)
    _write_csv(output_dir / "candidate_feedback.csv", candidate_rows)
    _write_csv(output_dir / "status_contract.csv", status_rows)
    _write_csv(output_dir / "fail_parent_outcomes.csv", outcome_rows)
    (output_dir / "summary.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )

    pooled = Counter[tuple[str, str]]()
    for row in candidate_rows:
        pooled[row["status"], row["contract_class"]] += 1
    clear_failure_statuses = (
        "failed_format",
        "failed_syntax",
        "failed_functionality",
    )
    clear_failure_total = sum(
        pooled[status, contract_class]
        for status in clear_failure_statuses
        for contract_class in CONTRACT_CLASSES
    )
    clear_failure_mismatch = sum(
        pooled[status, "mismatch"] for status in clear_failure_statuses
    )
    false_functionality_tens = sum(
        row["status"] == "failed_functionality" and row["critic_score"] == "10"
        for row in candidate_rows
    )
    false_all_tens = sum(row["false_score_10"] == "1" for row in candidate_rows)
    markdown = [
        "# Classic Feedback Contract Audit",
        "",
        f"This audit covers {len(candidate_rows):,} candidates from "
        f"{sum(len(list(root.rglob('generation_log.jsonl'))) for _, root in runs)} "
        "fresh classic full-suite logs.",
        "",
        "## Contract Results",
        "",
        "| Status | Compliant | Mismatch | Undefined |",
        "| --- | ---: | ---: | ---: |",
    ]
    for status in STATUSES:
        total = sum(pooled[status, item] for item in CONTRACT_CLASSES)
        if total:
            markdown.append(
                f"| `{status}` | {pooled[status, 'compliant']} | "
                f"{pooled[status, 'mismatch']} | {pooled[status, 'undefined']} |"
            )
    markdown.extend(
        [
            "",
            f"The clear failure statuses disagree with the critic score contract in "
            f"{clear_failure_mismatch}/{clear_failure_total} cases "
            f"({clear_failure_mismatch / clear_failure_total:.2%}). Functional "
            f"failures include {false_functionality_tens} false score-10 records. "
            f"Success disagrees in {pooled['success', 'mismatch']}/"
            f"{sum(pooled['success', item] for item in CONTRACT_CLASSES)} cases.",
            f"The `summary.json` `false_score_10_count` spans every non-success "
            f"status: {false_all_tens} equals {false_functionality_tens} "
            "functional failures plus one format failure.",
            "",
            "## Selected Failed Parents",
            "",
            "| Run | Parent contract | Children | Valid PPA | Rate |",
            "| --- | --- | ---: | ---: | ---: |",
            *[
                f"| {row['run']} | {row['parent_contract_class']} | "
                f"{row['fail_origin_children']} | {row['valid_ppa_children']} | "
                f"{float(row['valid_ppa_rate']):.2%} |"
                for row in outcome_rows
            ],
            "",
            "Contract disagreement is premise evidence only. It is not a causal",
            "estimate of repair quality, and the critic score is not consumed by",
            "classic parent prompts.",
            "",
            "## Reproduction",
            "",
            "```bash",
            "uv run python scripts/report_revolution_feedback_contract.py \\",
            *[f"  --run {label}={root} \\" for label, root in runs],
            f"  --output-dir {output_dir}",
            "```",
            "",
        ]
    )
    (output_dir / "README.md").write_text("\n".join(markdown), encoding="utf-8")
    return summary


def main(argv: list[str] | None = None) -> int:
    """Run the feedback contract audit CLI."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--run",
        action="append",
        type=_parse_run,
        required=True,
        help="Completed classic run as LABEL=PATH; repeat for each seed.",
    )
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args(argv)
    generate_feedback_contract_report(args.run, args.output_dir.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
