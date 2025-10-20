"""
Generate a concise report for Gen0 runs that mirrors the structure of
``scripts/evolutionary_report_generator.py`` but focuses on the best candidate
snapshot produced when ``--gen0_evaluate_best`` is enabled.

The script inspects every ``Gen0/best_candidate`` directory under the provided
experiment path, extracts metadata about syntax, simulation functionality, and
PPA metrics, and renders both a console summary and an optional Markdown file.
"""

from __future__ import annotations

import argparse
import json
import pathlib
from dataclasses import dataclass
from typing import Any, Iterable


@dataclass(frozen=True)
class CandidateSummary:
    """Container for a single best-candidate evaluation result."""

    benchmark: str
    problem: str
    score: float | None
    metadata_path: pathlib.Path
    evaluation_status: str
    syntax_status: str
    functionality_status: str
    synthesis_status: str
    area: float | None
    power: float | None
    eff_clk_period: float | None
    notes: str | None

    @property
    def best_candidate_dir(self) -> pathlib.Path:
        return self.metadata_path.parent


def discover_best_candidate_metadata(root: pathlib.Path) -> Iterable[pathlib.Path]:
    """
    Yield metadata paths for every ``Gen0/best_candidate`` directory under ``root``.

    The glob is intentionally narrow to avoid scanning unrelated artefacts. All
    downstream consumers work with absolute ``Path`` objects.
    """

    pattern = "**/Gen0/best_candidate/best_candidate_metadata.json"
    return sorted(root.glob(pattern))


def _extract_simulation_states(sim_status: str | None) -> tuple[str, str]:
    """
    Map the raw simulator status to high-level syntax and functionality outcomes.

    Syntax passes whenever compilation completes; functionality requires the
    simulator to terminate cleanly. The mapping keeps three buckets so the
    report can distinguish "not run" from explicit failures.
    """

    if sim_status is None:
        return "not_run", "not_run"

    sim_status = sim_status.lower()
    if sim_status == "success":
        return "pass", "pass"
    if sim_status in {"compilation_error", "file_error"}:
        return "fail", "not_run"
    if sim_status in {"simulation_error", "simulation_timeout"}:
        return "pass", "fail"
    return "unknown", "unknown"


def _normalise_float(value: Any) -> float | None:
    """Convert arbitrary JSON value into ``float`` while guarding against noise."""

    if value in (None, "", "nan", "NaN"):
        return None
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _load_ppa_from_file(best_candidate_dir: pathlib.Path) -> dict[str, float | None]:
    """
    Fallback reader for ``best_candidate_synthesis_report.ppa`` when the metadata
    does not embed PPA metrics (e.g. older runs).
    """

    csv_path = best_candidate_dir / "best_candidate_synthesis_report.ppa"
    if not csv_path.is_file():
        return {}

    try:
        lines = csv_path.read_text(encoding="utf-8").strip().splitlines()
    except OSError:
        return {}

    if len(lines) < 2:
        return {}

    header = [col.strip() for col in lines[0].split(",")]
    values = [val.strip() for val in lines[1].split(",")]

    metrics: dict[str, float | None] = {}
    for key, raw in zip(header, values, strict=False):
        metrics[key] = _normalise_float(raw)
    return metrics


def _parse_candidate_metadata(meta_path: pathlib.Path) -> CandidateSummary | None:
    """Parse a single metadata file and convert it into ``CandidateSummary``."""

    try:
        data = json.loads(meta_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        return CandidateSummary(
            benchmark="unknown",
            problem="unknown",
            score=None,
            metadata_path=meta_path,
            evaluation_status="metadata_error",
            syntax_status="unknown",
            functionality_status="unknown",
            synthesis_status="unknown",
            area=None,
            power=None,
            eff_clk_period=None,
            notes=f"Failed to parse metadata: {exc}",
        )

    try:
        problem_dir = meta_path.parent.parent.parent
        benchmark_dir = problem_dir.parent
        problem_name = problem_dir.name
        benchmark_name = benchmark_dir.name
    except Exception:  # pragma: no cover - defensive
        benchmark_name = "unknown"
        problem_name = "unknown"

    evaluation: dict[str, Any] = data.get("evaluation") or {}
    evaluation_status = evaluation.get("status", "not_run")
    notes = evaluation.get("reason")

    simulation = evaluation.get("simulation") or {}
    syntax_status, functionality_status = _extract_simulation_states(
        simulation.get("status")
    )

    synthesis = evaluation.get("synthesis") or {}
    if not synthesis:
        synthesis_status = "not_run"
    else:
        synth_success = all(
            synthesis.get(key) for key in ("synthesis_success", "ppa_success")
        )
        func_success = synthesis.get("synthesis_functionality_success")
        synthesis_status = "pass" if synth_success and func_success else "fail"

    metrics = evaluation.get("ppa_metrics") or {}
    if not metrics:
        metrics = _load_ppa_from_file(meta_path.parent)

    summary = CandidateSummary(
        benchmark=benchmark_name,
        problem=problem_name,
        score=_normalise_float(data.get("score")),
        metadata_path=meta_path,
        evaluation_status=evaluation_status,
        syntax_status=syntax_status,
        functionality_status=functionality_status,
        synthesis_status=synthesis_status,
        area=_normalise_float(metrics.get("area")),
        power=_normalise_float(metrics.get("power")),
        eff_clk_period=_normalise_float(
            metrics.get("eff_clk_period") or metrics.get("period")
        ),
        notes=notes,
    )
    return summary


def collate_summaries(root: pathlib.Path) -> list[CandidateSummary]:
    """Collect summaries for every best candidate under ``root``."""

    summaries: list[CandidateSummary] = []
    for meta_path in discover_best_candidate_metadata(root):
        summary = _parse_candidate_metadata(meta_path)
        if summary is not None:
            summaries.append(summary)
    return sorted(summaries, key=lambda s: (s.benchmark, s.problem))


def _format_status(stat: str) -> str:
    """Return a human-friendly string/icon for status values."""

    mapping = {
        "pass": "✅ pass",
        "fail": "❌ fail",
        "not_run": "⚪ not run",
        "unknown": "❓ unknown",
        "metadata_error": "🚨 metadata error",
    }
    return mapping.get(stat, stat)


def _render_console_summary(summaries: list[CandidateSummary]) -> None:
    """Print a textual summary to stdout."""

    if not summaries:
        print("⚠️ No Gen0 best-candidate metadata found under the provided path.")
        return

    total = len(summaries)
    syntax_pass = sum(s.syntax_status == "pass" for s in summaries)
    func_pass = sum(s.functionality_status == "pass" for s in summaries)
    synth_pass = sum(s.synthesis_status == "pass" for s in summaries)

    print("=" * 100)
    print("Gen0 Best-Candidate Evaluation Summary")
    print("=" * 100)
    print(f"Total best candidates analysed : {total}")
    print(f"Syntax checks passed           : {syntax_pass}/{total}")
    print(f"Functional simulations passed  : {func_pass}/{total}")
    print(f"Synthesis + PPA passed         : {synth_pass}/{total}")
    print("-" * 100)

    header = (
        "Benchmark",
        "Problem",
        "Score",
        "Evaluation",
        "Syntax",
        "Functionality",
        "Synthesis",
        "PPA (Area | Power | Period)",
    )
    print(f"{header[0]:<28} {header[1]:<28} {header[2]:>7} {header[3]:<18} {header[4]:<14} {header[5]:<20} {header[6]:<14} {header[7]}")
    print("-" * 100)

    for summary in summaries:
        area = f"{summary.area:.2f}" if summary.area is not None else "N/A"
        power = f"{summary.power:.3g}" if summary.power is not None else "N/A"
        period = (
            f"{summary.eff_clk_period:.2f}"
            if summary.eff_clk_period is not None
            else "N/A"
        )

        print(
            f"{summary.benchmark:<28} "
            f"{summary.problem:<28} "
            f"{summary.score or 0:7.2f} "
            f"{summary.evaluation_status:<18} "
            f"{_format_status(summary.syntax_status):<14} "
            f"{_format_status(summary.functionality_status):<20} "
            f"{_format_status(summary.synthesis_status):<14} "
            f"{area} | {power} | {period}"
        )

    print("-" * 100)
    print("Notes: Scores default to 0.00 when missing. Period refers to `eff_clk_period`.")


def _render_markdown(summaries: list[CandidateSummary], output_path: pathlib.Path) -> None:
    """Write a Markdown report mirroring the console output."""

    lines = [
        "# 🧬 Gen0 Best-Candidate Report",
        "",
        "| Benchmark | Problem | Score | Evaluation Status | Syntax | Functionality | Synthesis | Area | Power | Period | Notes |",
        "|:--|:--|:--:|:--|:--|:--|:--|:--:|:--:|:--:|:--|",
    ]

    for summary in summaries:
        area = f"{summary.area:.2f}" if summary.area is not None else "N/A"
        power = f"{summary.power:.3g}" if summary.power is not None else "N/A"
        period = (
            f"{summary.eff_clk_period:.2f}"
            if summary.eff_clk_period is not None
            else "N/A"
        )
        notes = summary.notes or ""
        lines.append(
            f"| `{summary.benchmark}` | `{summary.problem}` | "
            f"{summary.score if summary.score is not None else 'N/A'} | "
            f"{summary.evaluation_status} | "
            f"{_format_status(summary.syntax_status)} | "
            f"{_format_status(summary.functionality_status)} | "
            f"{_format_status(summary.synthesis_status)} | "
            f"{area} | {power} | {period} | {notes} |"
        )

    try:
        output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
        print(f"📄 Markdown report written to {output_path}")
    except OSError as exc:
        print(f"❌ Failed to write Markdown report: {exc}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Summarise the Gen0 best-candidate evaluations for a completed run. "
            "Point the script at the experiment directory that contains the "
            "model/benchmark outputs."
        )
    )
    parser.add_argument(
        "--experiment_path",
        type=pathlib.Path,
        required=True,
        help="Directory containing the Gen0 experiment artefacts.",
    )
    parser.add_argument(
        "--save_markdown",
        action="store_true",
        help="Save a Markdown version of the report alongside console output.",
    )
    parser.add_argument(
        "--markdown_path",
        type=pathlib.Path,
        default=None,
        help="Optional explicit path for the Markdown output.",
    )

    args = parser.parse_args()
    experiment_path = args.experiment_path.expanduser().resolve()
    if not experiment_path.exists():
        raise SystemExit(f"❌ Experiment path does not exist: {experiment_path}")

    summaries = collate_summaries(experiment_path)
    _render_console_summary(summaries)

    if args.save_markdown and summaries:
        output_path = args.markdown_path
        if output_path is None:
            output_path = experiment_path / "GEN0_BEST_CANDIDATE_REPORT.md"
        else:
            output_path = output_path.expanduser().resolve()
        _render_markdown(summaries, output_path)


if __name__ == "__main__":
    main()

