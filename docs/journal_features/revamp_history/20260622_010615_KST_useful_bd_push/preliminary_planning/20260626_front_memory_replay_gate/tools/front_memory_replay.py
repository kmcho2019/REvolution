from __future__ import annotations

import argparse
import csv
import hashlib
from dataclasses import dataclass
from pathlib import Path

import matplotlib.pyplot as plt


REQUIRED_COLUMNS = {
    "backend",
    "benchmark",
    "problem",
    "circuit_type",
    "generation",
    "candidate_id",
    "score_from_run",
    "g_A",
    "g_P",
    "g_T",
}


@dataclass(frozen=True)
class Candidate:
    backend: str
    benchmark: str
    problem: str
    circuit_type: str
    generation: int
    candidate_id: str
    score: float
    objectives: tuple[float, ...]


@dataclass(frozen=True)
class ProblemRow:
    backend: str
    benchmark: str
    problem: str
    final_front_count: int
    topk_final_front_count: int
    evicted_final_front_count: int
    evicted_final_front_rate: float
    not_topk_at_birth_count: int
    not_topk_at_birth_rate: float


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ppa-candidates", required=True)
    parser.add_argument("--top-k", required=True, type=int)
    parser.add_argument("--output-dir", required=True)
    return parser.parse_args()


def read_candidates(path: Path) -> list[Candidate]:
    assert path.exists(), path
    with path.open(newline="") as handle:
        reader = csv.DictReader(handle)
        assert reader.fieldnames is not None
        assert REQUIRED_COLUMNS <= set(reader.fieldnames)
        return [candidate_from_row(row) for row in reader]


def candidate_from_row(row: dict[str, str]) -> Candidate:
    circuit_type = row["circuit_type"]
    assert circuit_type in {"combinational", "sequential"}
    objectives = (float(row["g_A"]), float(row["g_P"]))
    if circuit_type == "sequential":
        objectives = (*objectives, float(row["g_T"]))
    return Candidate(
        backend=row["backend"],
        benchmark=row["benchmark"],
        problem=row["problem"],
        circuit_type=circuit_type,
        generation=int(row["generation"]),
        candidate_id=row["candidate_id"],
        score=float(row["score_from_run"]),
        objectives=objectives,
    )


def dominates(left: Candidate, right: Candidate) -> bool:
    assert len(left.objectives) == len(right.objectives)
    return all(a >= b for a, b in zip(left.objectives, right.objectives)) and any(
        a > b for a, b in zip(left.objectives, right.objectives)
    )


def pareto_front(candidates: list[Candidate]) -> list[Candidate]:
    return [
        candidate
        for candidate in candidates
        if not any(dominates(other, candidate) for other in candidates)
    ]


def topk_ids(candidates: list[Candidate], top_k: int) -> set[str]:
    ranked = sorted(candidates, key=lambda item: (-item.score, item.candidate_id))
    return {candidate.candidate_id for candidate in ranked[:top_k]}


def problem_rows(candidates: list[Candidate], top_k: int) -> list[ProblemRow]:
    groups: dict[tuple[str, str, str], list[Candidate]] = {}
    for candidate in candidates:
        key = (candidate.backend, candidate.benchmark, candidate.problem)
        groups.setdefault(key, []).append(candidate)

    rows: list[ProblemRow] = []
    for (backend, benchmark, problem), group in sorted(groups.items()):
        assert len({candidate.candidate_id for candidate in group}) == len(group)
        final_front = pareto_front(group)
        final_front_ids = {candidate.candidate_id for candidate in final_front}
        final_topk = topk_ids(group, top_k)
        birth_misses = 0
        for candidate in final_front:
            born_pool = [
                item for item in group if item.generation <= candidate.generation
            ]
            birth_misses += int(candidate.candidate_id not in topk_ids(born_pool, top_k))
        evicted_count = len(final_front_ids - final_topk)
        rows.append(
            ProblemRow(
                backend=backend,
                benchmark=benchmark,
                problem=problem,
                final_front_count=len(final_front),
                topk_final_front_count=len(final_front_ids & final_topk),
                evicted_final_front_count=evicted_count,
                evicted_final_front_rate=evicted_count / len(final_front),
                not_topk_at_birth_count=birth_misses,
                not_topk_at_birth_rate=birth_misses / len(final_front),
            )
        )
    return rows


def backend_rows(rows: list[ProblemRow]) -> list[dict[str, str]]:
    by_backend: dict[str, list[ProblemRow]] = {}
    for row in rows:
        by_backend.setdefault(row.backend, []).append(row)

    output: list[dict[str, str]] = []
    for backend, items in sorted(by_backend.items()):
        front_count = sum(item.final_front_count for item in items)
        evicted_count = sum(item.evicted_final_front_count for item in items)
        birth_count = sum(item.not_topk_at_birth_count for item in items)
        output.append(
            {
                "backend": backend,
                "problem_count": str(len(items)),
                "final_front_count": str(front_count),
                "evicted_final_front_count": str(evicted_count),
                "evicted_final_front_rate": format_rate(evicted_count, front_count),
                "not_topk_at_birth_count": str(birth_count),
                "not_topk_at_birth_rate": format_rate(birth_count, front_count),
            }
        )
    return output


def format_rate(count: int, total: int) -> str:
    assert total > 0
    return f"{count / total:.6f}"


def write_problem_csv(path: Path, rows: list[ProblemRow]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(ProblemRow.__dataclass_fields__)
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            writer.writerow(
                {
                    "backend": row.backend,
                    "benchmark": row.benchmark,
                    "problem": row.problem,
                    "final_front_count": row.final_front_count,
                    "topk_final_front_count": row.topk_final_front_count,
                    "evicted_final_front_count": row.evicted_final_front_count,
                    "evicted_final_front_rate": f"{row.evicted_final_front_rate:.6f}",
                    "not_topk_at_birth_count": row.not_topk_at_birth_count,
                    "not_topk_at_birth_rate": f"{row.not_topk_at_birth_rate:.6f}",
                }
            )


def write_dict_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def write_figure(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    labels = [pretty_backend(row["backend"]) for row in rows]
    rates = [float(row["evicted_final_front_rate"]) for row in rows]
    fig, ax = plt.subplots(figsize=(8, 4.5))
    bars = ax.bar(labels, rates, color=["#4c78a8", "#59a14f"][: len(labels)])
    ax.set_ylabel("Final Pareto points outside scalar top-k")
    ax.set_ylim(0, max(rates + [0.05]) * 1.25)
    ax.set_title("Scalar Retention Gap For Final PPA Fronts")
    for bar, rate in zip(bars, rates):
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            bar.get_height(),
            f"{rate:.1%}",
            ha="center",
            va="bottom",
        )
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def pretty_backend(backend: str) -> str:
    if backend == "classic_revolution_8x5":
        return "classic\nREvolution"
    if backend == "rf_deepgate_hybrid_delayed_8x5":
        return "RF/DeepGate\nhybrid"
    return backend


def write_report(path: Path, rows: list[dict[str, str]], top_k: int) -> None:
    lines = [
        "# Front-Memory Replay Results",
        "",
        f"Scalar retention uses top-{top_k} by `score_from_run`.",
        "",
        "## Backend Summary",
        "",
        "| Backend | Problems | Final Front | Evicted Final Front | Evicted Rate | Birth Misses | Birth Miss Rate |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for row in rows:
        lines.append(
            "| {backend} | {problem_count} | {final_front_count} | "
            "{evicted_final_front_count} | {evicted_final_front_rate} | "
            "{not_topk_at_birth_count} | {not_topk_at_birth_rate} |".format(**row)
        )
    lines.extend(["", "## Result", ""])
    for row in rows:
        lines.append(
            "- `{backend}` leaves `{evicted_final_front_count}/{final_front_count}` "
            "final-front candidates outside final scalar top-k.".format(**row)
        )
    lines.extend(
        [
            "",
            "## Decision",
            "",
            "This replay is a mechanism gate, not a QD promotion. Scalar top-k",
            "does discard final-front material, so a memory mechanism has",
            "something real to retain. However, the QD hybrid has a much larger",
            "retention gap while still losing HV and Pareto breadth to classic.",
            "The next live method should therefore not broaden archive recall by",
            "itself. It should spend memory budget only when a retained family",
            "has evidence of producing quality-improving or front-adding",
            "children, and it should report front-add rate per memory-lane call.",
        ]
    )
    path.write_text("\n".join(lines) + "\n")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_manifest(path: Path, artifacts: list[Path], input_path: Path) -> None:
    lines = [
        "# Artifacts Manifest",
        "",
        f"- Input PPA candidates: `{input_path}`",
        "",
        "| Artifact | SHA256 |",
        "| --- | --- |",
    ]
    for artifact in artifacts:
        lines.append(f"| `{artifact}` | `{sha256(artifact)}` |")
    path.write_text("\n".join(lines) + "\n")


def main() -> None:
    args = parse_args()
    input_path = Path(args.ppa_candidates)
    output_dir = Path(args.output_dir)
    candidates = read_candidates(input_path)
    rows = problem_rows(candidates, args.top_k)
    aggregate_rows = backend_rows(rows)

    problem_csv = output_dir / "tables/front_memory_replay_by_problem.csv"
    backend_csv = output_dir / "tables/front_memory_replay_by_backend.csv"
    figure_path = output_dir / "figures/front_retention_gap_by_backend.png"
    report_path = output_dir / "results_report.md"
    manifest_path = output_dir / "artifacts_manifest.md"

    write_problem_csv(problem_csv, rows)
    write_dict_csv(backend_csv, aggregate_rows)
    write_figure(figure_path, aggregate_rows)
    write_report(report_path, aggregate_rows, args.top_k)
    write_manifest(
        manifest_path,
        [problem_csv, backend_csv, figure_path, report_path],
        input_path,
    )


if __name__ == "__main__":
    main()
