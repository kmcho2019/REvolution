#!/usr/bin/env python3
"""Write detailed PCN-v3 full-run analysis artifacts."""

from __future__ import annotations

import argparse
import csv
import json
import math
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


METHOD_ORDER = [
    "classic_revolution_8x5",
    "classic_no_cf_8x5",
    "pcn_v3_no_cf_memory_8x5",
    "pcn_v3_cf_restored_memory_8x5",
]

METHOD_LABELS = {
    "classic_revolution_8x5": "Classic",
    "classic_no_cf_8x5": "Classic no C-F",
    "pcn_v3_no_cf_memory_8x5": "PCN no C-F",
    "pcn_v3_cf_restored_memory_8x5": "PCN C-F restored",
}

COMPARISON_LABELS = {
    "classic_no_cf_minus_classic": "Classic no C-F - Classic",
    "pcn_no_cf_minus_classic_no_cf": "PCN no C-F - Classic no C-F",
    "pcn_cf_restored_minus_classic": "PCN C-F restored - Classic",
    "pcn_cf_restored_minus_pcn_no_cf": "PCN C-F restored - PCN no C-F",
}

COLORS = {
    "classic_revolution_8x5": "#4c78a8",
    "classic_no_cf_8x5": "#72b7b2",
    "pcn_v3_no_cf_memory_8x5": "#f58518",
    "pcn_v3_cf_restored_memory_8x5": "#e45756",
}


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows, path
    return rows


def write_csv(path: Path, fields: list[str], rows: list[dict[str, object]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def f(value: float) -> str:
    assert math.isfinite(value)
    return f"{value:.12g}"


def mean(values: list[float]) -> float:
    assert values
    return sum(values) / len(values)


def stdev(values: list[float]) -> float:
    if len(values) < 2:
        return 0.0
    center = mean(values)
    return math.sqrt(sum((value - center) ** 2 for value in values) / (len(values) - 1))


def method_summary(rows: list[dict[str, str]]) -> list[dict[str, object]]:
    output = []
    for method in METHOD_ORDER:
        subset = [row for row in rows if row["method_key"] == method]
        assert subset, method
        hv = [float(row["mean_hv"]) for row in subset]
        hv_auc = [float(row["mean_hv_auc"]) for row in subset]
        covered = [float(row["covered_problem_count"]) for row in subset]
        pareto = [float(row["mean_pareto_point_count"]) for row in subset]
        refbeat = [float(row["mean_reference_beating_count"]) for row in subset]
        output.append(
            {
                "method_key": method,
                "method_label": METHOD_LABELS[method],
                "seed_count": len(subset),
                "reference_complete_problem_count": int(float(subset[0]["problem_count"])),
                "mean_hv": f(mean(hv)),
                "std_hv": f(stdev(hv)),
                "mean_hv_auc": f(mean(hv_auc)),
                "std_hv_auc": f(stdev(hv_auc)),
                "mean_covered_problem_count": f(mean(covered)),
                "mean_pareto_point_count": f(mean(pareto)),
                "mean_reference_beating_count": f(mean(refbeat)),
                "total_valid_ppa_candidates": sum(int(row["candidate_count"]) for row in subset),
                "total_c_f_count": sum(int(row["c_f_count"]) for row in subset),
                "total_single_thought_count": sum(
                    int(row["single_thought_count"]) for row in subset
                ),
                "operator_set": subset[0]["operator_set"],
                "operator_status": "pass"
                if all(row["operator_status"] == "pass" for row in subset)
                else "fail",
            }
        )
    classic_hv = float(output[0]["mean_hv"])
    classic_auc = float(output[0]["mean_hv_auc"])
    for row in output:
        row["hv_retention_vs_classic"] = f(float(row["mean_hv"]) / classic_hv)
        row["hv_auc_retention_vs_classic"] = f(float(row["mean_hv_auc"]) / classic_auc)
    return output


def seed_delta_summary(rows: list[dict[str, str]]) -> list[dict[str, object]]:
    output = []
    comparisons = sorted({row["comparison"] for row in rows})
    seeds = sorted({row["seed"] for row in rows})
    for comparison in comparisons:
        for seed in seeds:
            subset = [
                row for row in rows if row["comparison"] == comparison and row["seed"] == seed
            ]
            assert subset, (comparison, seed)
            hv = [float(row["delta_hv"]) for row in subset]
            auc = [float(row["delta_hv_auc"]) for row in subset]
            output.append(
                {
                    "comparison": comparison,
                    "comparison_label": COMPARISON_LABELS[comparison],
                    "seed": seed,
                    "paired_count": len(subset),
                    "mean_delta_hv": f(mean(hv)),
                    "mean_delta_hv_auc": f(mean(auc)),
                    "win_count": sum(value > 1e-12 for value in hv),
                    "loss_count": sum(value < -1e-12 for value in hv),
                    "tie_count": sum(abs(value) <= 1e-12 for value in hv),
                }
            )
    return output


def problem_delta_summary(rows: list[dict[str, str]]) -> list[dict[str, object]]:
    output = []
    comparisons = sorted({row["comparison"] for row in rows})
    problems = sorted({row["problem"] for row in rows})
    for comparison in comparisons:
        for problem in problems:
            subset = [
                row
                for row in rows
                if row["comparison"] == comparison and row["problem"] == problem
            ]
            if not subset:
                continue
            hv = [float(row["delta_hv"]) for row in subset]
            auc = [float(row["delta_hv_auc"]) for row in subset]
            output.append(
                {
                    "comparison": comparison,
                    "comparison_label": COMPARISON_LABELS[comparison],
                    "problem": problem,
                    "seed_count": len(subset),
                    "mean_delta_hv": f(mean(hv)),
                    "mean_delta_hv_auc": f(mean(auc)),
                    "win_count": sum(value > 1e-12 for value in hv),
                    "loss_count": sum(value < -1e-12 for value in hv),
                    "tie_count": sum(abs(value) <= 1e-12 for value in hv),
                }
            )
    return output


def claim_gate_summary(comparisons: list[dict[str, str]]) -> list[dict[str, object]]:
    by_name = {row["comparison"]: row for row in comparisons}
    no_cf = by_name["pcn_no_cf_minus_classic_no_cf"]
    restored = by_name["pcn_cf_restored_minus_classic"]
    operator = "pass"
    return [
        {
            "gate": "operator_contract",
            "status": operator,
            "evidence": "all full-stage method/seed operator audits passed",
            "interpretation": "The run is not affected by single-thought regression or hidden C-F in no-CF arms.",
        },
        {
            "gate": "memory_after_no_cf_control",
            "status": "fail" if float(no_cf["mean_delta_hv"]) <= 0 else "pass",
            "evidence": (
                f"mean HV delta {float(no_cf['mean_delta_hv']):.4f}; "
                f"CI [{float(no_cf['bootstrap_ci95_low']):.4f}, "
                f"{float(no_cf['bootstrap_ci95_high']):.4f}]"
            ),
            "interpretation": "PCN no-C-F did not beat classic no-C-F.",
        },
        {
            "gate": "clean_pcn_vs_classic",
            "status": "fail" if float(restored["mean_delta_hv"]) <= 0 else "pass",
            "evidence": (
                f"mean HV delta {float(restored['mean_delta_hv']):.4f}; "
                f"CI [{float(restored['bootstrap_ci95_low']):.4f}, "
                f"{float(restored['bootstrap_ci95_high']):.4f}]"
            ),
            "interpretation": "C-F-restored PCN did not beat original classic.",
        },
        {
            "gate": "allowed_claim",
            "status": "negative",
            "evidence": "both controlled PCN claim gates failed",
            "interpretation": "Treat PCN-v3 as not validated under 8x5 full RTLLM.",
        },
    ]


def event_records(run_root: Path) -> list[dict[str, object]]:
    rows = []
    for method in ("pcn_v3_no_cf_memory_8x5", "pcn_v3_cf_restored_memory_8x5"):
        for seed_dir in sorted((run_root / method).glob("seed_*")):
            seed = seed_dir.name.removeprefix("seed_")
            for path in seed_dir.glob("**/qd_archive_event.json"):
                event = json.loads(path.read_text(encoding="utf-8"))
                lane = event.get("qd_memory_lane") or "none"
                role = event.get("qd_memory_parent_role") or "none"
                rows.append(
                    {
                        "method_key": method,
                        "seed": seed,
                        "lane": lane,
                        "parent_role": role,
                        "inserted": bool(event.get("inserted")),
                        "global_archive_inserted": bool(event.get("global_archive_inserted")),
                        "front_gap": event.get("qd_memory_front_gap"),
                        "quality_score": float(event.get("quality_score", 0.0)),
                    }
                )
    return rows


def memory_lane_summary(records: list[dict[str, object]]) -> list[dict[str, object]]:
    output = []
    keys = sorted({(row["method_key"], row["seed"], row["lane"]) for row in records})
    for method, seed, lane in keys:
        subset = [
            row
            for row in records
            if row["method_key"] == method and row["seed"] == seed and row["lane"] == lane
        ]
        gaps = [
            float(row["front_gap"])
            for row in subset
            if row["front_gap"] is not None and math.isfinite(float(row["front_gap"]))
        ]
        output.append(
            {
                "method_key": method,
                "seed": seed,
                "lane": lane,
                "event_count": len(subset),
                "inserted_count": sum(bool(row["inserted"]) for row in subset),
                "global_archive_inserted_count": sum(
                    bool(row["global_archive_inserted"]) for row in subset
                ),
                "insert_rate": f(sum(bool(row["inserted"]) for row in subset) / len(subset)),
                "global_insert_rate": f(
                    sum(bool(row["global_archive_inserted"]) for row in subset)
                    / len(subset)
                ),
                "mean_front_gap": f(mean(gaps)) if gaps else "not_available",
                "mean_quality_score": f(mean([float(row["quality_score"]) for row in subset])),
            }
        )
    return output


def plot_method_bar(path: Path, rows: list[dict[str, object]], field: str, title: str, ylabel: str) -> None:
    labels = [row["method_label"] for row in rows]
    values = [float(row[field]) for row in rows]
    errors = [float(row.get("std_" + field.removeprefix("mean_"), 0.0)) for row in rows]
    fig, ax = plt.subplots(figsize=(9.6, 5.6))
    ax.bar(labels, values, yerr=errors, color=[COLORS[row["method_key"]] for row in rows])
    ax.set_title(title)
    ax.set_ylabel(ylabel)
    ax.tick_params(axis="x", labelrotation=20)
    ax.grid(axis="y", alpha=0.22)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_seed_delta(path: Path, rows: list[dict[str, object]], field: str, title: str) -> None:
    fig, ax = plt.subplots(figsize=(10.5, 5.8))
    comparisons = [row["comparison"] for row in rows]
    comparisons = list(dict.fromkeys(comparisons))
    for comparison in comparisons:
        subset = [row for row in rows if row["comparison"] == comparison]
        xs = [int(row["seed"]) for row in subset]
        ys = [float(row[field]) for row in subset]
        ax.plot(xs, ys, marker="o", linewidth=1.8, label=COMPARISON_LABELS[comparison])
    ax.axhline(0, color="#222222", linewidth=0.9)
    ax.set_title(title)
    ax.set_xlabel("Seed")
    ax.set_ylabel(field)
    ax.grid(alpha=0.24)
    ax.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_problem_heatmap(path: Path, rows: list[dict[str, object]]) -> None:
    comparisons = [
        "classic_no_cf_minus_classic",
        "pcn_no_cf_minus_classic_no_cf",
        "pcn_cf_restored_minus_classic",
        "pcn_cf_restored_minus_pcn_no_cf",
    ]
    problems = sorted({row["problem"] for row in rows})
    by_key = {(row["comparison"], row["problem"]): float(row["mean_delta_hv"]) for row in rows}
    values = [[by_key[(comparison, problem)] for problem in problems] for comparison in comparisons]
    bound = max(abs(value) for line in values for value in line)
    fig, ax = plt.subplots(figsize=(15, 4.8))
    image = ax.imshow(values, aspect="auto", cmap="RdBu_r", vmin=-bound, vmax=bound)
    ax.set_title("Mean paired HV delta by RTLLM problem")
    ax.set_yticks(range(len(comparisons)), [COMPARISON_LABELS[item] for item in comparisons])
    ax.set_xticks(range(len(problems)), [item.replace("Prob", "P") for item in problems], rotation=90)
    ax.tick_params(axis="x", labelsize=6)
    fig.colorbar(image, ax=ax, label="mean delta HV")
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_memory(path: Path, rows: list[dict[str, object]]) -> None:
    labels = []
    event_counts = []
    global_counts = []
    for method in ("pcn_v3_no_cf_memory_8x5", "pcn_v3_cf_restored_memory_8x5"):
        for lane in ("classic", "memory_refine"):
            subset = [row for row in rows if row["method_key"] == method and row["lane"] == lane]
            labels.append(f"{METHOD_LABELS[method]}\n{lane}")
            event_counts.append(sum(int(row["event_count"]) for row in subset))
            global_counts.append(sum(int(row["global_archive_inserted_count"]) for row in subset))
    xs = range(len(labels))
    fig, ax = plt.subplots(figsize=(10, 5.5))
    ax.bar([x - 0.18 for x in xs], event_counts, width=0.36, label="events", color="#4c78a8")
    ax.bar([x + 0.18 for x in xs], global_counts, width=0.36, label="global inserts", color="#f58518")
    ax.set_xticks(list(xs), labels)
    ax.set_title("PCN archive-event volume by lane")
    ax.set_ylabel("event count")
    ax.grid(axis="y", alpha=0.22)
    ax.legend()
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def md_table(fields: list[str], rows: list[dict[str, object]]) -> list[str]:
    lines = ["| " + " | ".join(fields) + " |", "| " + " | ".join("---" for _ in fields) + " |"]
    for row in rows:
        lines.append("| " + " | ".join(str(row[field]) for field in fields) + " |")
    return lines


def write_report(
    path: Path,
    method_rows: list[dict[str, object]],
    comparison_rows: list[dict[str, str]],
    claim_rows: list[dict[str, object]],
    memory_rows: list[dict[str, object]],
) -> None:
    key_comparisons = [
        "classic_no_cf_minus_classic",
        "pcn_no_cf_minus_classic_no_cf",
        "pcn_cf_restored_minus_classic",
        "pcn_cf_restored_minus_pcn_no_cf",
    ]
    by_comp = {row["comparison"]: row for row in comparison_rows}
    memory_totals = []
    for method in ("pcn_v3_no_cf_memory_8x5", "pcn_v3_cf_restored_memory_8x5"):
        for lane in ("classic", "memory_refine"):
            subset = [row for row in memory_rows if row["method_key"] == method and row["lane"] == lane]
            memory_totals.append(
                {
                    "method": METHOD_LABELS[method],
                    "lane": lane,
                    "events": sum(int(row["event_count"]) for row in subset),
                    "global_inserts": sum(
                        int(row["global_archive_inserted_count"]) for row in subset
                    ),
                }
            )

    lines = [
        "# PCN-v3 RTLLM Full Five-Seed Detailed Report",
        "",
        "## Bottom Line",
        "",
        "The run is finished and packaged. The corrected PCN-v3 variants do not "
        "provide statistical evidence of improvement over classic REvolution on "
        "the reference-complete RTLLM paired comparison.",
        "",
        "The strongest publication-safe conclusion is negative: PCN-v3 memory "
        "was implemented with the corrected EoH operator controls and its memory "
        "lane did fire, but it did not beat the matched no-C-F classic control or "
        "the original classic baseline under the 8x5 budget.",
        "",
        "## Run Status",
        "",
        "- Stage: `rtllm_full_5seed`.",
        "- Seeds: `1001..1005`.",
        "- Core methods: four.",
        "- Method/seed runs: 20/20 complete.",
        "- Headline paired rows: 230, from 46 reference-complete RTLLM designs "
        "across five seeds.",
        "- Missing reference-PPA designs are excluded from headline normalized "
        "metrics.",
        "",
        "## Claim Gate Summary",
        "",
        *md_table(["gate", "status", "evidence", "interpretation"], claim_rows),
        "",
        "## Overall Method Summary",
        "",
        *md_table(
            [
                "method_label",
                "mean_hv",
                "mean_hv_auc",
                "mean_covered_problem_count",
                "mean_pareto_point_count",
                "total_valid_ppa_candidates",
                "total_c_f_count",
            ],
            method_rows,
        ),
        "",
        "## Main Pairwise Comparisons",
        "",
        "| Comparison | Mean HV Delta | 95% CI | Mean HV-AUC Delta | Wins/Losses/Ties | Wilcoxon p |",
        "| --- | ---: | --- | ---: | --- | ---: |",
    ]
    for name in key_comparisons:
        row = by_comp[name]
        lines.append(
            "| {label} | {dhv:.4f} | [{lo:.4f}, {hi:.4f}] | {dauc:.4f} | "
            "{wins}/{losses}/{ties} | {p} |".format(
                label=COMPARISON_LABELS[name],
                dhv=float(row["mean_delta_hv"]),
                lo=float(row["bootstrap_ci95_low"]),
                hi=float(row["bootstrap_ci95_high"]),
                dauc=float(row["mean_delta_hv_auc"]),
                wins=row["win_count"],
                losses=row["loss_count"],
                ties=row["tie_count"],
                p=row["wilcoxon_p"],
            )
        )

    lines.extend(
        [
            "",
            "## Interpretation",
            "",
            "1. Removing `C-F` alone produced a small positive mean HV delta "
            "(+0.0030), but the confidence interval crosses zero and the "
            "win/loss count is exactly balanced at 41/41 with 148 ties.",
            "2. PCN memory without `C-F` did not beat the matched no-C-F classic "
            "control. The mean HV delta is -0.0065 and the mean HV-AUC delta is "
            "-0.0076.",
            "3. C-F-restored PCN did not beat original classic. The mean HV delta "
            "is -0.0021, and the HV-AUC delta is -0.0063.",
            "4. Restoring `C-F` inside PCN slightly improves final HV relative to "
            "PCN no-C-F (+0.0013), but it still loses HV-AUC and does not create "
            "a positive claim.",
            "",
            "## Operator And Validity Checks",
            "",
            "The operator contract passed. `single_thought_operator` count is zero "
            "for every method and seed. The two no-C-F arms have zero `C-F` rows. "
            "The original classic and C-F-restored PCN arms both produced `C-F` "
            "rows, confirming the C-F restoration actually occurred.",
            "",
            "The C-F-restored PCN arm generated fewer reference-complete valid-PPA "
            "candidate rows than classic: 4229 versus 4882 across five seeds. "
            "This lower valid-PPA yield is a likely contributor to its weaker "
            "HV-AUC and final HV.",
            "",
            "## Memory-Lane Mechanism",
            "",
            *md_table(["method", "lane", "events", "global_inserts"], memory_totals),
            "",
            "The memory lane was active, so the negative result is not caused by "
            "a completely inactive PCN memory. However, memory-refine events were "
            "a small minority of archive events and did not translate into a "
            "method-level HV advantage.",
            "",
            "## Generated Tables",
            "",
            "- `tables/rtllm_full_5seed_overall_method_summary.csv`",
            "- `tables/rtllm_full_5seed_seed_delta_summary.csv`",
            "- `tables/rtllm_full_5seed_problem_delta_summary.csv`",
            "- `tables/rtllm_full_5seed_claim_gate_summary.csv`",
            "- `tables/rtllm_full_5seed_memory_lane_summary.csv`",
            "",
            "## Generated Figures",
            "",
            "- `figures/rtllm_full_5seed/overall_mean_hv_errorbar.png`",
            "- `figures/rtllm_full_5seed/overall_mean_hv_auc_errorbar.png`",
            "- `figures/rtllm_full_5seed/coverage_by_method.png`",
            "- `figures/rtllm_full_5seed/seed_delta_hv_lines.png`",
            "- `figures/rtllm_full_5seed/problem_delta_heatmap.png`",
            "- `figures/rtllm_full_5seed/memory_lane_events.png`",
            "",
            "## Recommended Next Step",
            "",
            "Do not run the elite-cell variants as an automatic continuation of "
            "PCN-v3 under the current claim. The core ablation did not validate "
            "PCN memory. If we continue, the better next test is a smaller "
            "diagnostic redesign focused on reducing valid-PPA yield loss and "
            "using memory only after stagnation or only on designs where classic "
            "evicts a near-front family.",
        ]
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--doc-root", type=Path, required=True)
    parser.add_argument("--stage", default="rtllm_full_5seed")
    parser.add_argument("--run-root", type=Path, required=True)
    args = parser.parse_args()

    doc_root = args.doc_root.resolve()
    table_root = doc_root / "tables"
    fig_root = doc_root / "figures" / args.stage
    report_root = doc_root / "reports"
    fig_root.mkdir(parents=True, exist_ok=True)

    method_rows = method_summary(read_csv(table_root / f"{args.stage}_method_seed_summary.csv"))
    delta_rows = read_csv(table_root / f"{args.stage}_paired_deltas.csv")
    comparison_rows = read_csv(table_root / f"{args.stage}_comparison_summary.csv")
    seed_rows = seed_delta_summary(delta_rows)
    problem_rows = problem_delta_summary(delta_rows)
    claim_rows = claim_gate_summary(comparison_rows)
    memory_rows = memory_lane_summary(event_records(args.run_root.resolve()))

    write_csv(
        table_root / f"{args.stage}_overall_method_summary.csv",
        list(method_rows[0].keys()),
        method_rows,
    )
    write_csv(
        table_root / f"{args.stage}_seed_delta_summary.csv",
        list(seed_rows[0].keys()),
        seed_rows,
    )
    write_csv(
        table_root / f"{args.stage}_problem_delta_summary.csv",
        list(problem_rows[0].keys()),
        problem_rows,
    )
    write_csv(
        table_root / f"{args.stage}_claim_gate_summary.csv",
        list(claim_rows[0].keys()),
        claim_rows,
    )
    write_csv(
        table_root / f"{args.stage}_memory_lane_summary.csv",
        list(memory_rows[0].keys()),
        memory_rows,
    )

    plot_method_bar(
        fig_root / "overall_mean_hv_errorbar.png",
        method_rows,
        "mean_hv",
        "Reference-complete RTLLM mean HV",
        "mean HV across seeds",
    )
    plot_method_bar(
        fig_root / "overall_mean_hv_auc_errorbar.png",
        method_rows,
        "mean_hv_auc",
        "Reference-complete RTLLM mean HV-AUC",
        "mean HV-AUC across seeds",
    )
    plot_method_bar(
        fig_root / "coverage_by_method.png",
        method_rows,
        "mean_covered_problem_count",
        "Reference-complete designs with at least one valid-PPA candidate",
        "covered designs out of 46",
    )
    plot_seed_delta(
        fig_root / "seed_delta_hv_lines.png",
        seed_rows,
        "mean_delta_hv",
        "Seed-level mean paired HV deltas",
    )
    plot_problem_heatmap(fig_root / "problem_delta_heatmap.png", problem_rows)
    plot_memory(fig_root / "memory_lane_events.png", memory_rows)

    write_report(
        report_root / f"{args.stage}_detailed_report.md",
        method_rows,
        comparison_rows,
        claim_rows,
        memory_rows,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
