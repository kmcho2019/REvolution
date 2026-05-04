#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Any

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "src"))
)

from scripts.backend_comparison_report import (  # noqa: E402
    generate_backend_comparison_report,
)
from scripts.report_evolutionary_run import generate_evolutionary_reports  # noqa: E402
from scripts.report_hard_iteration_analysis import (  # noqa: E402
    generate_hard_iteration_analysis,
)
from scripts.report_design_space_analysis import (  # noqa: E402
    generate_design_space_analysis,
)
from scripts.report_pareto_analysis import generate_pareto_analysis_report  # noqa: E402
from scripts.report_ppa_distribution import generate_ppa_distribution_report  # noqa: E402
from scripts.report_qd_feature_space import (  # noqa: E402
    generate_qd_feature_space_analysis,
)


RESERVED_DIR_NAMES = {
    "analysis",
    "feature_analysis",
    "hard_iteration_analysis",
    "pareto_analysis",
    "evolutionary_reports",
    "design_space_analysis",
    "final_analysis",
}


def _discover_backend_runs(run_root: Path) -> list[tuple[str, Path]]:
    backend_runs: list[tuple[str, Path]] = []
    for child in sorted(run_root.iterdir()):
        if not child.is_dir() or child.name in RESERVED_DIR_NAMES:
            continue
        if not any(path.name.endswith("_summary.json") for path in child.rglob("*_summary.json")):
            continue
        backend_runs.append((child.name, child.resolve()))
    if not backend_runs:
        raise ValueError(f"No backend run directories found under {run_root}")
    return backend_runs


def _parse_backend_runs(mappings: list[str]) -> list[tuple[str, Path]]:
    backend_runs: list[tuple[str, Path]] = []
    for mapping in mappings:
        if "=" not in mapping:
            raise ValueError(
                f"Invalid --backend_run '{mapping}'. Expected format <backend>=<path>."
            )
        backend, path_str = mapping.split("=", 1)
        root = Path(path_str).expanduser().resolve()
        if not root.is_dir():
            raise FileNotFoundError(f"Experiment path not found: {root}")
        backend_runs.append((backend, root))
    if not backend_runs:
        raise ValueError("At least one --backend_run mapping is required.")
    return backend_runs


def _has_qd_backend(backend_runs: list[tuple[str, Path]]) -> bool:
    for _, root in backend_runs:
        if any(root.rglob("qd_archive_event.json")) or any(root.rglob("archive_summary.json")):
            return True
    return False


def _write_top_level_report(
    *,
    output_dir: Path,
    backend_runs: list[tuple[str, Path]],
    sections: dict[str, str],
    skipped_sections: list[dict[str, str]],
    recommendations: dict[str, Any],
) -> None:
    lines = [
        "# Final Analysis Bundle",
        "",
        f"- backend_count: `{len(backend_runs)}`",
        f"- backends: `{', '.join(backend for backend, _ in backend_runs)}`",
        "",
        "## Sections",
        "",
        f"- backend comparison: [backend_comparison.md]({sections['backend_comparison']})",
        f"- hard iteration analysis: [report.md]({sections['hard_iteration_analysis_report']})",
        f"- pareto analysis: [report.md]({sections['pareto_analysis_report']})",
        f"- evolutionary reports: [report.md]({sections['evolutionary_reports_report']})",
        f"- PPA distribution: [report.md]({sections['ppa_distribution_report']})",
        f"- design-space analysis: [report.md]({sections['design_space_analysis_report']})",
    ]
    if "feature_analysis_report" in sections:
        lines.append(f"- feature analysis: [report.md]({sections['feature_analysis_report']})")
    if skipped_sections:
        lines.extend(
            [
                "",
                "## Skipped Sections",
                "",
            ]
        )
        for item in skipped_sections:
            lines.append(f"- `{item['section']}`: {item['reason']}")
    lines.extend(
        [
            "",
            "## Recommendations",
            "",
            f"- overall: `{recommendations.get('overall') or 'N/A'}`",
            f"- score_qd: `{recommendations.get('score_qd') or 'N/A'}`",
            f"- archive_qd: `{recommendations.get('archive_qd') or 'N/A'}`",
            f"- multi_objective: `{recommendations.get('multi_objective') or 'N/A'}`",
            f"- pareto winner: `{recommendations.get('pareto_overall') or 'N/A'}`",
        ]
    )
    if recommendations.get("recommended_profile_path"):
        lines.append(
            f"- recommended profile: [recommended_profile.json]({recommendations['recommended_profile_path']})"
        )
    if recommendations.get("design_space_profile_path"):
        lines.append(
            "- design-space profile: "
            f"[recommended_profile.json]({recommendations['design_space_profile_path']})"
        )
    lines.append("")
    (output_dir / "report.md").write_text("\n".join(lines), encoding="utf-8")


def generate_final_analysis_bundle(
    *,
    run_root: Path | None,
    subset_config: Path,
    output_dir: Path | None = None,
    min_profile_features: int = 7,
    backend_runs: list[tuple[str, Path]] | None = None,
) -> dict[str, Any]:
    subset_config = subset_config.resolve()
    resolved_run_root = run_root.resolve() if run_root is not None else None
    resolved_backend_runs = backend_runs
    if resolved_backend_runs is None:
        if resolved_run_root is None:
            raise ValueError("run_root is required when backend_runs are not provided.")
        resolved_backend_runs = _discover_backend_runs(resolved_run_root)

    if output_dir is None:
        if resolved_run_root is None:
            raise ValueError("output_dir is required when backend_runs are provided directly.")
        resolved_output_dir = (resolved_run_root / "final_analysis").resolve()
    else:
        resolved_output_dir = output_dir.resolve()

    output_dir = resolved_output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    backend_comparison_path = output_dir / "backend_comparison.md"
    generate_backend_comparison_report(resolved_backend_runs, output_path=backend_comparison_path)

    hard_iteration_result = generate_hard_iteration_analysis(
        subset_config=subset_config,
        backend_runs=resolved_backend_runs,
        output_dir=output_dir / "hard_iteration_analysis",
    )
    pareto_result = generate_pareto_analysis_report(
        backend_runs=resolved_backend_runs,
        output_dir=output_dir / "pareto_analysis",
        subset_config=subset_config,
    )
    evolutionary_result = generate_evolutionary_reports(
        subset_config=subset_config,
        backend_runs=resolved_backend_runs,
        output_dir=output_dir / "evolutionary_reports",
    )
    ppa_distribution_result = generate_ppa_distribution_report(
        subset_config=subset_config,
        backend_runs=resolved_backend_runs,
        output_dir=output_dir / "ppa_distribution",
    )
    design_space_result = generate_design_space_analysis(
        subset_config=subset_config,
        backend_runs=resolved_backend_runs,
        output_dir=output_dir / "design_space_analysis",
        min_profile_features=min_profile_features,
    )

    skipped_sections: list[dict[str, str]] = []
    sections = {
        "backend_comparison": "backend_comparison.md",
        "hard_iteration_analysis_report": "hard_iteration_analysis/report.md",
        "hard_iteration_analysis_summary": "hard_iteration_analysis/summary.json",
        "pareto_analysis_report": "pareto_analysis/report.md",
        "pareto_analysis_summary": "pareto_analysis/summary.json",
        "evolutionary_reports_report": "evolutionary_reports/report.md",
        "ppa_distribution_report": "ppa_distribution/report.md",
        "ppa_distribution_summary": "ppa_distribution/summary.json",
        "design_space_analysis_report": "design_space_analysis/report.md",
        "design_space_analysis_summary": "design_space_analysis/summary.json",
    }
    recommendations = dict(hard_iteration_result["payload"]["recommendations"])
    recommendations["pareto_overall"] = pareto_result["summary"].get("overall_multi_objective_winner")
    recommendations["design_space_profile_path"] = "design_space_analysis/recommended_profile.json"

    if _has_qd_backend(resolved_backend_runs):
        generate_qd_feature_space_analysis(
            subset_config=subset_config,
            backend_roots={backend: root for backend, root in resolved_backend_runs},
            output_dir=output_dir / "feature_analysis",
            min_profile_features=min_profile_features,
        )
        sections["feature_analysis_report"] = "feature_analysis/report.md"
        sections["feature_analysis_summary"] = "feature_analysis/summary.json"
        recommendations["recommended_profile_path"] = "feature_analysis/recommended_profile.json"
    else:
        skipped_sections.append(
            {
                "section": "feature_analysis",
                "reason": "No QD backend artifacts were found under the discovered backend roots.",
            }
        )

    _write_top_level_report(
        output_dir=output_dir,
        backend_runs=resolved_backend_runs,
        sections=sections,
        skipped_sections=skipped_sections,
        recommendations=recommendations,
    )

    summary = {
        "run_root": str(resolved_run_root) if resolved_run_root is not None else None,
        "subset_config": str(subset_config),
        "output_dir": str(output_dir),
        "backend_runs": [
            {"backend": backend, "root": str(root)}
            for backend, root in resolved_backend_runs
        ],
        "sections": sections,
        "skipped_sections": skipped_sections,
        "recommendations": recommendations,
        "hard_iteration_summary_path": hard_iteration_result["summary_path"],
        "pareto_summary_path": pareto_result["summary_path"],
        "evolutionary_report_path": evolutionary_result["report_path"],
        "ppa_distribution_report_path": ppa_distribution_result["report_path"],
        "ppa_distribution_summary_path": ppa_distribution_result["summary_path"],
        "design_space_report_path": design_space_result["report_path"],
    }
    summary_path = output_dir / "summary.json"
    summary_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    return summary


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Generate the full final_analysis bundle from either a finished hard-iteration "
            "run root or an explicit list of backend run directories."
        )
    )
    parser.add_argument(
        "--run-root",
        type=Path,
        default=None,
        help="Finished comparison run root containing backend subdirectories.",
    )
    parser.add_argument(
        "--backend_run",
        action="append",
        default=[],
        help="Backend mapping in the form <name>=<experiment_path>. Repeat for multiple backends.",
    )
    parser.add_argument(
        "--subset-config",
        type=Path,
        required=True,
        help="Frozen hard-subset config used for the run.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=None,
        help="Optional output directory. Defaults to <run-root>/final_analysis.",
    )
    parser.add_argument(
        "--min-profile-features",
        type=int,
        default=7,
        help="Minimum non-target features to keep in the recommended feature profile.",
    )
    args = parser.parse_args()
    has_run_root = args.run_root is not None
    has_backend_runs = bool(args.backend_run)
    if has_run_root == has_backend_runs:
        parser.error("Provide exactly one of --run-root or --backend_run.")

    summary = generate_final_analysis_bundle(
        run_root=args.run_root,
        subset_config=args.subset_config,
        output_dir=args.output_dir,
        min_profile_features=args.min_profile_features,
        backend_runs=_parse_backend_runs(args.backend_run) if has_backend_runs else None,
    )
    print(json.dumps(summary, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
