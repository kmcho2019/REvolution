"""Rebuild the RTL diversity compiled-results bundle.

Run from the repository root with:

    uv run python docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check/20260621_150407_UTC_compiled_results_bundle/scripts/rebuild_bundle.py
"""

from __future__ import annotations

import csv
import hashlib
import json
import shutil
from statistics import mean
from pathlib import Path
from typing import Any


BUNDLE = Path(__file__).resolve().parents[1]
FINAL_REPORT = Path("exp/diversity_check/restarted_report_20260621_075346_UTC")
REVAMP_DIR = Path(
    "docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check"
)
DERAILED_REPORT = REVAMP_DIR / "20260620_183839_UTC_derailed_initial_report"


def find_repo_root() -> Path:
    """Return the nearest ancestor that looks like this repository root."""

    path = Path(__file__).resolve()
    for parent in path.parents:
        if (parent / "AGENTS.md").exists() and (parent / "README.md").exists():
            return parent
    raise AssertionError("could not locate repository root")


REPO = find_repo_root()


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def manifest_row(
    source: str,
    bundled: Path,
    description: str,
    rows: int | None = None,
) -> dict[str, str]:
    rel_bundled = bundled.relative_to(BUNDLE).as_posix()
    row = {
        "bundled_path": rel_bundled,
        "source_path": source,
        "bytes": str(bundled.stat().st_size),
        "sha256": sha256(bundled),
        "description": description,
    }
    if rows is not None:
        row["rows"] = str(rows)
    return row


def reset_generated_dirs() -> None:
    for dirname in [
        "figures",
        "raw_data",
        "reports",
        "scripts/processing",
        "stage_results",
    ]:
        path = BUNDLE / dirname
        if path.exists():
            shutil.rmtree(path)
        path.mkdir(parents=True, exist_ok=True)


def copy_file(
    manifest: list[dict[str, str]],
    source: Path,
    dest: Path,
    description: str,
) -> None:
    src = REPO / source
    assert src.exists(), source
    out = BUNDLE / dest
    out.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, out)
    manifest.append(manifest_row(source.as_posix(), out, description))


def copy_tree(
    manifest: list[dict[str, str]],
    source_dir: Path,
    dest_dir: Path,
    description: str,
) -> None:
    src_dir = REPO / source_dir
    assert src_dir.exists(), source_dir
    for src in sorted(path for path in src_dir.rglob("*") if path.is_file()):
        rel = src.relative_to(src_dir)
        copy_file(manifest, src.relative_to(REPO), dest_dir / rel, description)


def sample_csv(
    manifest: list[dict[str, str]],
    source: Path,
    dest: Path,
    description: str,
    limit: int,
) -> None:
    src = REPO / source
    assert src.exists(), source
    out = BUNDLE / dest
    out.parent.mkdir(parents=True, exist_ok=True)
    rows = 0
    with src.open(newline="", encoding="utf-8", errors="replace") as in_handle:
        reader = csv.DictReader(in_handle)
        assert reader.fieldnames is not None, source
        with out.open("w", newline="", encoding="utf-8") as out_handle:
            writer = csv.DictWriter(
                out_handle,
                fieldnames=reader.fieldnames,
                lineterminator="\n",
            )
            writer.writeheader()
            for row in reader:
                writer.writerow(row)
                rows += 1
                if rows >= limit:
                    break
    manifest.append(manifest_row(source.as_posix(), out, description, rows))


def read_csv_rows(path: Path) -> list[dict[str, str]]:
    with (REPO / path).open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def read_json(path: Path) -> dict[str, Any]:
    with (REPO / path).open(encoding="utf-8") as handle:
        data = json.load(handle)
    assert isinstance(data, dict), path
    return data


def write_csv(
    manifest: list[dict[str, str]],
    dest: Path,
    rows: list[dict[str, Any]],
    description: str,
) -> None:
    assert rows, dest
    out = BUNDLE / dest
    out.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0].keys())
    with out.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    manifest.append(manifest_row("generated from bundled source summaries", out, description, len(rows)))


def copy_final_report(manifest: list[dict[str, str]]) -> None:
    report_files = [
        "diversity_necessity_report.md",
        "diversity_necessity_report.json",
        "implementation_gallery.md",
    ]
    for name in report_files:
        copy_file(manifest, FINAL_REPORT / name, Path("reports/final_report") / name, "final validated report")

    final_tables = [
        "case_studies.csv",
        "claim_levels.csv",
        "cluster_summary.csv",
        "common_audit_metrics.csv",
        "corpus_coverage.csv",
        "counterfactual_replay.csv",
        "deepgate3_diagnostic_card.json",
        "d_gate_matrix.csv",
        "early_diversity.csv",
        "encoder_leaderboard.csv",
        "problem_metrics.csv",
        "qwen_dry_run_coverage.csv",
        "wp0_replay_summary.csv",
    ]
    for name in final_tables:
        copy_file(manifest, FINAL_REPORT / name, Path("raw_data/final_report") / name, "final report table or card")

    sample_csv(
        manifest,
        FINAL_REPORT / "candidate_audit.csv",
        Path("raw_data/final_report/candidate_audit_sample_1000.csv"),
        "first 1000 rows of the 203944-row candidate audit; full CSV/parquet stays in exp/",
        1000,
    )
    copy_tree(manifest, FINAL_REPORT / "figures", Path("figures/final_report"), "final report figure")


def copy_derailed_report(manifest: list[dict[str, str]]) -> None:
    copy_tree(
        manifest,
        DERAILED_REPORT,
        Path("reports/derailed_initial_report"),
        "archived preliminary report and figures judged too shallow",
    )


def copy_project_docs(manifest: list[dict[str, str]]) -> None:
    docs = [
        "goal_template.md",
        "rtl_diversity_check_adversarial_prompt.md",
        "rtl_diversity_check_encoder_escalation_plan.md",
        "rtl_diversity_check_encoder_method_cards.md",
        "rtl_diversity_check_implementation_history.md",
        "rtl_diversity_check_implementation_todo.md",
        "rtl_diversity_check_plan.md",
        "rtl_diversity_check_subagent_validation_report.md",
    ]
    for name in docs:
        copy_file(manifest, REVAMP_DIR / name, Path("reports/project_docs") / name, "project contract, log, or validation doc")


def copy_stage_results(manifest: list[dict[str, str]]) -> None:
    copy_specs = {
        "wp0_stnod_sr_reconstruction": [
            ("exp/diversity_check/wp0_stnod_sr_reconstruction_20260621_040536_UTC", [
                "wp0_budget_curves.csv",
                "wp0_operator_yield.csv",
                "wp0_reconstruction_summary.json",
            ])
        ],
        "wp0_quality_gated_novelty": [
            ("exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC", [
                "wp0_budget_curves.csv",
                "wp0_duplicate_suppression.csv",
                "wp0_operator_yield.csv",
                "wp0_quality_gated_novelty.csv",
                "wp0_reconstruction_summary.json",
            ])
        ],
        "wp0_lineage": [
            ("exp/diversity_check/wp0_lineage_source_audit_20260621_055941_UTC", [
                "lineage_source_audit.md",
                "lineage_source_roots.csv",
                "lineage_source_summary.json",
            ]),
            ("exp/diversity_check/wp0_lineage_descendant_yield_20260621_060447_UTC", [
                "lineage_aggregate.csv",
                "lineage_parent_yield.csv",
                "lineage_yield_report.md",
                "lineage_yield_summary.json",
            ]),
        ],
        "wp0_budget_funnels": [
            ("exp/diversity_check/wp0_budget_funnel_curves_20260621_062414_UTC", [
                "budget_funnel_aggregate.csv",
                "budget_funnel_report.md",
                "budget_funnel_summary.json",
            ])
        ],
        "wp1_qwen": [
            ("exp/diversity_check/qwen3_probe_20260621_032811_UTC", [
                "qwen3_probe_candidates.csv",
                "qwen3_probe_raw_nearest.csv",
                "qwen3_probe_summary.json",
                "qwen3_probe_variant_stability.csv",
            ]),
            ("exp/diversity_check/qwen3_yosys_probe_20260621_033323_UTC", [
                "qwen3_yosys_stability.csv",
                "qwen3_yosys_summary.json",
            ]),
            ("exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC", [
                "qwen_common_audit_aggregate.csv",
                "qwen_common_audit_card.md",
                "qwen_common_audit_nearest.csv",
                "qwen_common_audit_replay.csv",
                "qwen_common_audit_stability.csv",
                "qwen_common_audit_summary.json",
            ]),
        ],
        "wp1_deepgate3": [
            ("exp/diversity_check/deepgate3_aig_probe_20260621_034421_UTC", [
                "deepgate3_aig_export.csv",
                "deepgate3_aig_summary.json",
                "deepgate3_graphs_latch_free.npz",
            ]),
            ("exp/diversity_check/deepgate3_tokenizer_probe_20260621_034921_UTC", [
                "deepgate3_tokenizer_rows.csv",
                "deepgate3_tokenizer_summary.json",
            ]),
        ],
        "wp2_near_motif": [
            ("exp/diversity_check/wp2_near_motif_suppression_20260621_072816_UTC", [
                "near_motif_suppression.csv",
                "near_motif_suppression_aggregate.csv",
                "near_motif_suppression_report.md",
                "near_motif_suppression_summary.json",
            ])
        ],
    }

    for stage, specs in copy_specs.items():
        for source_dir, filenames in specs:
            for filename in filenames:
                copy_file(
                    manifest,
                    Path(source_dir) / filename,
                    Path("stage_results") / stage / filename,
                    f"{stage} stage result",
                )

    learned_specs = [
        ("dim2_fixed", "exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim2_fixed"),
        ("dim3_fixed", "exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim3_fixed"),
        ("rich_encoder", "exp/diversity_check/wp3_rich_encoder_20260621_070533_UTC"),
    ]
    for label, source_dir in learned_specs:
        for src in sorted((REPO / source_dir).glob("*")):
            if src.suffix == ".parquet":
                continue
            copy_file(
                manifest,
                src.relative_to(REPO),
                Path("stage_results/wp3_learned_encoders") / label / src.name,
                "wp3 learned-encoder stage result",
            )

    sample_specs = [
        (
            "exp/diversity_check/wp0_stnod_sr_reconstruction_20260621_040536_UTC/wp0_descriptor_rows.csv",
            "stage_results/wp0_stnod_sr_reconstruction/wp0_descriptor_rows_sample_1000.csv",
            "ST-NOD/SR descriptor-row sample",
        ),
        (
            "exp/diversity_check/wp0_quality_gated_novelty_20260621_041500_UTC/wp0_qd_events.csv",
            "stage_results/wp0_quality_gated_novelty/wp0_qd_events_sample_1000.csv",
            "quality-gated novelty event sample",
        ),
        (
            "exp/diversity_check/wp0_lineage_source_audit_20260621_055941_UTC/lineage_source_files.csv",
            "stage_results/wp0_lineage/lineage_source_files_sample_1000.csv",
            "lineage source-file sample",
        ),
        (
            "exp/diversity_check/wp0_lineage_descendant_yield_20260621_060447_UTC/lineage_edges.csv",
            "stage_results/wp0_lineage/lineage_edges_sample_1000.csv",
            "lineage edge sample",
        ),
        (
            "exp/diversity_check/wp0_budget_funnel_curves_20260621_062414_UTC/budget_funnel_curves.csv",
            "stage_results/wp0_budget_funnels/budget_funnel_curves_sample_1000.csv",
            "budget-funnel curve sample",
        ),
        (
            "exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_candidates.csv",
            "stage_results/wp1_qwen/qwen_common_audit_candidates_sample_1000.csv",
            "Qwen common-audit candidate sample",
        ),
    ]
    for source, dest, description in sample_specs:
        sample_csv(manifest, Path(source), Path(dest), description, 1000)


def copy_processing_scripts(manifest: list[dict[str, str]]) -> None:
    scripts = [
        "scripts/report_rtl_diversity_check.py",
        "scripts/reconstruct_rtl_diversity_wp0.py",
        "scripts/analyze_rtl_diversity_budget_funnels.py",
        "scripts/audit_rtl_diversity_lineage_sources.py",
        "scripts/analyze_rtl_diversity_lineage_yield.py",
        "scripts/run_rtl_diversity_wp3_learned_encoder.py",
        "scripts/run_rtl_diversity_wp3_rich_encoder.py",
        "scripts/analyze_rtl_diversity_near_motif_suppression.py",
        "scripts/run_rtl_diversity_wp1_qwen_common_audit.py",
    ]
    for script in scripts:
        copy_file(
            manifest,
            Path(script),
            Path("scripts/processing") / Path(script).name,
            "processing script used to generate diversity-check artifacts",
        )


def use_figure_style(plt: Any) -> None:
    plt.rcParams.update(
        {
            "figure.facecolor": "white",
            "axes.facecolor": "white",
            "axes.edgecolor": "#333333",
            "axes.labelcolor": "#222222",
            "axes.titleweight": "bold",
            "font.size": 11,
            "savefig.bbox": "tight",
            "savefig.dpi": 180,
        }
    )


def save_generated_figure(
    manifest: list[dict[str, str]],
    fig: Any,
    dest: Path,
    description: str,
) -> None:
    out = BUNDLE / dest
    out.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(out)
    manifest.append(manifest_row("generated by scripts/rebuild_bundle.py", out, description))


def as_float(value: str) -> float:
    if value == "":
        return 0.0
    return float(value)


def figure_gate_status(manifest: list[dict[str, str]], plt: Any) -> None:
    rows = read_csv_rows(FINAL_REPORT / "d_gate_matrix.csv")
    statuses = [row["status"] for row in rows]
    colors = {"PASS": "#2e7d32", "FAIL": "#b23a48", "NOT_RUN": "#8a8f98"}
    fig, ax = plt.subplots(figsize=(10.5, 4.8))
    y = list(range(len(rows)))
    ax.barh(y, [1] * len(rows), color=[colors.get(s, "#8a8f98") for s in statuses], height=0.62)
    for index, row in enumerate(rows):
        ax.text(0.03, index, row["gate"], va="center", ha="left", color="white", weight="bold")
        ax.text(0.98, index, row["status"], va="center", ha="right", color="white", weight="bold")
    ax.set_yticks([])
    ax.set_xticks([])
    ax.set_xlim(0, 1)
    ax.set_title("D-Gate Status: Only Interpretability Passed")
    ax.text(
        0,
        -0.85,
        "Utility gates D1, D3, D5 failed; D4 was not run because offline utility was below threshold.",
        fontsize=10,
        color="#444444",
    )
    for spine in ax.spines.values():
        spine.set_visible(False)
    save_generated_figure(manifest, fig, Path("figures/generated/gate_status_summary.png"), "generated D1-D6 gate status summary")
    plt.close(fig)


def figure_utility_margins(manifest: list[dict[str, str]], plt: Any) -> None:
    counterfactual = read_csv_rows(FINAL_REPORT / "counterfactual_replay.csv")
    policy_hvs: dict[str, list[float]] = {}
    for row in counterfactual:
        policy_hvs.setdefault(row["policy"], []).append(as_float(row["hypervolume"]))
    hv_by_policy = {policy: mean(values) for policy, values in policy_hvs.items()}
    d3_gain = (hv_by_policy["oracle_motif_diversity"] - hv_by_policy["oracle_best_fitness"]) / hv_by_policy["oracle_best_fitness"]

    qwen = read_csv_rows(Path("exp/diversity_check/wp1_qwen_common_audit_20260621_075031_UTC/qwen_common_audit_aggregate.csv"))
    qwen_gain = {row["representation"]: as_float(row["vs_lexical_hv_gain_fraction"]) for row in qwen}

    rich = read_json(Path("exp/diversity_check/wp3_rich_encoder_20260621_070533_UTC/wp3_rich_encoder_summary.json"))
    rich_gain = {
        row["representation"]: float(row["hypervolume_gain_fraction"])
        for row in rich["comparison"]["comparisons"]
    }

    near = read_csv_rows(Path("exp/diversity_check/wp2_near_motif_suppression_20260621_072816_UTC/near_motif_suppression_aggregate.csv"))
    best_near = max(as_float(row["hypervolume_gain_fraction"]) for row in near)

    bars = [
        ("Final D3\nmotif replay", d3_gain * 100),
        ("Qwen raw\nvs lexical", qwen_gain["qwen_raw_farthest"] * 100),
        ("Qwen id-norm\nvs lexical", qwen_gain["qwen_identifier_farthest"] * 100),
        ("Rich AE8\nvs impl-z", rich_gain["rich_ae8"] * 100),
        ("Rich AE16\nvs impl-z", rich_gain["rich_ae16"] * 100),
        ("Near motif\nbest threshold", best_near * 100),
    ]
    colors = ["#c77d24" if value > 0 else "#b23a48" for _, value in bars]
    fig, ax = plt.subplots(figsize=(11, 5.4))
    ax.bar([label for label, _ in bars], [value for _, value in bars], color=colors, width=0.62)
    ax.axhline(10, color="#2e7d32", linewidth=2, linestyle="--")
    ax.axhline(0, color="#444444", linewidth=1)
    for index, (_, value) in enumerate(bars):
        va = "bottom" if value >= 0 else "top"
        y = value + (0.35 if value >= 0 else -0.35)
        ax.text(index, y, f"{value:.2f}%", ha="center", va=va, fontsize=10)
    ax.set_ylabel("Hypervolume gain")
    ax.set_title("Replay Utility Margins Stayed Below the Proceed Threshold")
    ax.text(len(bars) - 0.4, 10.18, "D3 utility threshold (10%)", ha="right", va="bottom", fontsize=10)
    ax.set_ylim(min(-2.0, min(value for _, value in bars) - 0.8), 10.9)
    ax.grid(axis="y", color="#dddddd", linewidth=0.8)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    save_generated_figure(manifest, fig, Path("figures/generated/utility_gate_margins.png"), "generated replay utility-margin comparison")
    plt.close(fig)


def figure_corpus_coverage(manifest: list[dict[str, str]], plt: Any) -> None:
    report = read_json(FINAL_REPORT / "diversity_necessity_report.json")
    totals = {
        "ASPDAC release": int(report["aspdac_candidate_count"]),
        "Auto-BD controls": int(report["auto_bd_candidate_count"]),
        "Legacy RTLLM": int(report["rtllm_candidate_count"]),
    }
    order = list(totals)
    colors = ["#2563a6", "#2a9d8f", "#8d6e63", "#6c757d"]
    fig, ax = plt.subplots(figsize=(9.5, 5.2))
    ax.bar(order, [totals[name] for name in order], color=colors[: len(order)], width=0.58)
    for index, name in enumerate(order):
        ax.text(index, totals[name], f"{totals[name]:,}", ha="center", va="bottom", fontsize=10)
    ax.set_ylabel("Candidates")
    ax.set_title("Corpus Scale Behind the Final Audit")
    ax.tick_params(axis="x", rotation=18)
    ax.grid(axis="y", color="#dddddd", linewidth=0.8)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    save_generated_figure(manifest, fig, Path("figures/generated/corpus_coverage_overview.png"), "generated corpus coverage overview")
    plt.close(fig)


def figure_claim_ladder(manifest: list[dict[str, str]], plt: Any) -> None:
    rows = read_csv_rows(FINAL_REPORT / "claim_levels.csv")
    labels = [row["level"].replace(" ", "\n", 1) for row in rows]
    supported = [1 if row["status"] == "SUPPORTED" else 0 for row in rows]
    colors = ["#2e7d32" if value else "#a0a6ad" for value in supported]
    status_labels = {"SUPPORTED": "YES", "NOT_SUPPORTED": "NO", "NOT_RUN": "NOT RUN"}
    fig, ax = plt.subplots(figsize=(10.5, 4.8))
    ax.bar(labels, [1] * len(labels), color=colors, width=0.62)
    for index, row in enumerate(rows):
        ax.text(
            index,
            0.5,
            status_labels.get(row["status"], row["status"]),
            ha="center",
            va="center",
            color="white",
            weight="bold",
            fontsize=10,
        )
    ax.set_ylim(0, 1.15)
    ax.set_yticks([])
    ax.set_title("Claim Ladder: Supported Evidence Stops at L0")
    ax.text(
        0,
        1.08,
        "Descriptive regions exist, but reconstructive, predictive, mechanistic, active, and method claims did not pass.",
        fontsize=10,
        color="#444444",
    )
    for spine in ax.spines.values():
        spine.set_visible(False)
    save_generated_figure(manifest, fig, Path("figures/generated/claim_level_ladder.png"), "generated claim-level ladder")
    plt.close(fig)


def generate_figures(manifest: list[dict[str, str]]) -> None:
    import matplotlib.pyplot as plt

    use_figure_style(plt)
    figure_gate_status(manifest, plt)
    figure_utility_margins(manifest, plt)
    figure_corpus_coverage(manifest, plt)
    figure_claim_ladder(manifest, plt)


def normalize_text_outputs() -> None:
    for path in BUNDLE.rglob("*"):
        if not path.is_file() or path.suffix not in {".csv", ".json", ".md", ".py"}:
            continue
        data = path.read_bytes()
        normalized = data.replace(b"\r\n", b"\n")
        if normalized != data:
            path.write_bytes(normalized)


def write_manifest(manifest: list[dict[str, str]]) -> None:
    out = BUNDLE / "MANIFEST.csv"
    fieldnames = ["bundled_path", "source_path", "bytes", "sha256", "description", "rows"]
    with out.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        for row in sorted(manifest, key=lambda item: item["bundled_path"]):
            writer.writerow({name: row.get(name, "") for name in fieldnames})

    md = BUNDLE / "MANIFEST.md"
    with md.open("w", encoding="utf-8") as handle:
        handle.write("# Bundle Manifest\n\n")
        handle.write("Regenerate with `uv run python scripts/rebuild_bundle.py` from this directory's repository root.\n\n")
        handle.write("| bundled_path | source_path | bytes | description |\n")
        handle.write("| --- | --- | ---: | --- |\n")
        for row in sorted(manifest, key=lambda item: item["bundled_path"]):
            handle.write(
                f"| `{row['bundled_path']}` | `{row['source_path']}` | {row['bytes']} | {row['description']} |\n"
            )


def write_summary_tables(manifest: list[dict[str, str]]) -> None:
    report = read_json(FINAL_REPORT / "diversity_necessity_report.json")
    summary_rows = [
        {"metric": "final_verdict", "value": report["verdict"]},
        {"metric": "candidate_count", "value": report["candidate_count"]},
        {"metric": "evolution_candidate_count", "value": report["evolution_candidate_count"]},
        {"metric": "aspdac_candidate_count", "value": report["aspdac_candidate_count"]},
        {"metric": "rtllm_candidate_count", "value": report["rtllm_candidate_count"]},
        {"metric": "auto_bd_candidate_count", "value": report["auto_bd_candidate_count"]},
        {"metric": "problem_count", "value": report["problem_count"]},
    ]
    write_csv(manifest, Path("raw_data/final_report/audit_scale_summary.csv"), summary_rows, "generated final audit scale summary")


def main() -> None:
    manifest: list[dict[str, str]] = []
    reset_generated_dirs()
    for local_doc in ["README.md", "CONCLUSION.md"]:
        path = BUNDLE / local_doc
        if path.exists():
            manifest.append(manifest_row("bundle-local documentation", path, "bundle narrative documentation"))
    manifest.append(
        manifest_row(
            "bundle-local scripts/rebuild_bundle.py",
            Path(__file__).resolve(),
            "bundle regeneration script",
        )
    )
    copy_final_report(manifest)
    copy_derailed_report(manifest)
    copy_project_docs(manifest)
    copy_stage_results(manifest)
    copy_processing_scripts(manifest)
    write_summary_tables(manifest)
    generate_figures(manifest)
    normalize_text_outputs()
    write_manifest(manifest)
    print(f"wrote {len(manifest)} bundled artifacts under {BUNDLE.relative_to(REPO)}")


if __name__ == "__main__":
    main()
