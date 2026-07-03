from __future__ import annotations

from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
DERIVED = ROOT / "data" / "derived"
FIG = ROOT / "figures" / "generated"
CONCEPT = ROOT / "figures" / "concepts"


METHOD_LABELS = {
    "classic_revolution_8x5": "Classic",
    "qwen_canonical_rtl_pca3_8x5": "Qwen3",
    "qwen_canonical_rtl_pca3_eoh_8x5": "Qwen3 EoH",
    "masterrtl_rf_leafid_structural_delayed_8x5": "MasterRTL RF",
    "masterrtl_archive_activation_eoh_8x5": "MasterRTL archive",
    "deepgate_delayed_high_exploit_8x5": "DeepGate",
    "deepgate_high_exploit_eoh_8x5": "DeepGate EoH",
    "rf_deepgate_hybrid_delayed_8x5": "RF+DeepGate",
    "aurora_raw_impl_compact_delayed_8x5": "AURORA raw",
    "masterrtl_delayed_archive_activation_8x5": "MasterRTL archive",
    "fg_qdm_rf_leafid_front_credit_8x5": "FG-QDM",
    "pcn_v3_rf_stagnation_memory_8x5": "PCN-v3",
    "classic_no_cf_8x5": "Classic no C-F",
    "pcn_v3_no_cf_memory_8x5": "PCN no C-F",
    "pcn_v3_cf_restored_memory_8x5": "PCN C-F restored",
}


COLORS = {
    "Classic": "#3b4cc0",
    "Classic no C-F": "#6b8fd6",
    "PCN-v3": "#0f8b8d",
    "PCN no C-F": "#45a29e",
    "PCN C-F restored": "#00a878",
    "Qwen3": "#b65fcf",
    "Qwen3 EoH": "#b65fcf",
    "DeepGate": "#e88c30",
    "DeepGate EoH": "#e88c30",
    "RF+DeepGate": "#d95f02",
    "MasterRTL RF": "#5b8c5a",
    "MasterRTL archive": "#5b8c5a",
    "AURORA raw": "#8c6d31",
    "FG-QDM": "#8c564b",
}


def main() -> None:
    for path in [DERIVED, FIG, CONCEPT]:
        path.mkdir(parents=True, exist_ok=True)

    s29 = load_summary("20260629_full_suite_method_summary.csv")
    s30 = load_summary("20260630_full_suite_method_summary.csv")
    smoke = load_csv("20260701_rtllm_smoke_method_seed_summary.csv")
    smoke_cmp = load_csv("20260701_rtllm_smoke_comparison_summary.csv")
    op30 = load_csv("20260630_operator_contract.csv")
    op_smoke = load_csv("20260701_rtllm_smoke_operator_contract.csv")
    pcn = load_csv("20260630_pcn_memory_mechanism_summary.csv")

    write_selected_tables(s29, s30, smoke, smoke_cmp, op30, op_smoke, pcn)

    plot_method_family_matrix()
    plot_20260630_operator_audit(op30)
    plot_20260629_retention(s29)
    plot_20260629_descriptor_rank(s29)
    plot_20260629_coverage(s29)
    plot_20260630_retention(s30)
    plot_20260630_win_loss(s30)
    plot_qwen_comparison(s29, s30)
    plot_corrected_encoder_comparison(s30)
    plot_pcn_memory_mechanism(pcn)
    plot_20260701_cf_audit(op_smoke)
    plot_20260701_smoke_comparison(smoke_cmp)
    plot_20260701_smoke_hv(smoke)

    draw_timeline()
    draw_scalar_vs_pareto()
    draw_hv_hv_auc()
    draw_classic_pipeline()
    draw_qd_grid()
    draw_appendix_classic_revolution()
    draw_appendix_generic_qd()
    draw_appendix_pcn_v3()
    draw_operator_mismatch()
    draw_replacement_vs_memory()
    draw_pcn_architecture()
    draw_cf_ablation_design()
    draw_recommended_algorithm()
    draw_claim_gates()
    draw_experiment_ladder()
    draw_discussion_map()
    draw_lessons()


def load_csv(name: str) -> pd.DataFrame:
    path = RAW / name
    assert path.exists(), path
    return pd.read_csv(path)


def load_summary(name: str) -> pd.DataFrame:
    df = load_csv(name)
    assert "method_key" in df.columns
    assert "mean_hv_retention_pct" in df.columns
    return df


def label_methods(df: pd.DataFrame) -> pd.DataFrame:
    out = df.copy()
    out["label"] = out["method_key"].map(METHOD_LABELS).fillna(out["method_key"])
    return out


def finished(df: pd.DataFrame) -> pd.DataFrame:
    if "completion_status" not in df.columns:
        return df.copy()
    return df[df["completion_status"] == "done"].copy()


def write_selected_tables(
    s29: pd.DataFrame,
    s30: pd.DataFrame,
    smoke: pd.DataFrame,
    smoke_cmp: pd.DataFrame,
    op30: pd.DataFrame,
    op_smoke: pd.DataFrame,
    pcn: pd.DataFrame,
) -> None:
    cols = [
        "method_key",
        "family",
        "covered_problem_count",
        "headline_problem_count",
        "mean_hv",
        "mean_hv_auc",
        "mean_hv_retention_pct",
        "classic_hv_win_count",
        "classic_hv_loss_count",
        "classic_hv_tie_count",
    ]
    finished(s29)[cols].to_csv(DERIVED / "20260629_selected_methods.csv", index=False)
    finished(s30)[cols].to_csv(DERIVED / "20260630_selected_methods.csv", index=False)
    smoke.to_csv(DERIVED / "20260701_smoke_summary.csv", index=False)
    smoke_cmp.to_csv(DERIVED / "20260701_smoke_comparisons.csv", index=False)
    op30.to_csv(DERIVED / "20260630_operator_audit.csv", index=False)
    op_smoke.to_csv(DERIVED / "20260701_smoke_operator_audit.csv", index=False)
    pcn.sum(numeric_only=True).to_frame("total").to_csv(
        DERIVED / "20260630_pcn_memory_totals.csv"
    )


def save(fig: plt.Figure, path: Path) -> None:
    fig.savefig(path, dpi=220, bbox_inches="tight")
    plt.close(fig)


def style_axis(ax: plt.Axes, title: str, xlabel: str = "", ylabel: str = "") -> None:
    ax.set_title(title, fontsize=16, weight="bold", pad=12)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.grid(axis="x", color="#d8d8d8", linewidth=0.7)
    ax.set_axisbelow(True)


def plot_20260629_retention(df: pd.DataFrame) -> None:
    data = label_methods(finished(df)).sort_values("mean_hv_retention_pct")
    fig, ax = plt.subplots(figsize=(10, 5.5))
    colors = [COLORS.get(x, "#777777") for x in data["label"]]
    ax.barh(data["label"], data["mean_hv_retention_pct"], color=colors)
    ax.axvline(100, color="#222222", linewidth=1, linestyle="--")
    style_axis(ax, "20260629: straightforward QD did not catch classic", "Mean HV retention vs classic (%)")
    for row in data.itertuples():
        ax.text(row.mean_hv_retention_pct + 1, row.label, f"{row.mean_hv_retention_pct:.1f}%", va="center")
    save(fig, FIG / "20260629_method_retention.png")


def plot_20260629_descriptor_rank(df: pd.DataFrame) -> None:
    keys = [
        "qwen_canonical_rtl_pca3_8x5",
        "masterrtl_delayed_archive_activation_8x5",
        "masterrtl_rf_leafid_structural_delayed_8x5",
        "rf_deepgate_hybrid_delayed_8x5",
    ]
    data = label_methods(finished(df).set_index("method_key").loc[keys].reset_index())
    data = data.sort_values("mean_hv_retention_pct")
    fig, ax = plt.subplots(figsize=(8.8, 4.8))
    colors = [COLORS.get(x, "#777777") for x in data["label"]]
    ax.barh(data["label"], data["mean_hv_retention_pct"], color=colors)
    ax.axvline(100, color="#222222", linewidth=1, linestyle="--")
    style_axis(ax, "20260629 descriptor families: all trail classic", "Mean HV retention (%)")
    for row in data.itertuples():
        note = f"{row.mean_hv_retention_pct:.1f}%  |  {int(row.covered_problem_count)}/46"
        ax.text(row.mean_hv_retention_pct + 1.0, row.label, note, va="center", fontsize=10)
    save(fig, FIG / "20260629_descriptor_family_rank.png")


def plot_method_family_matrix() -> None:
    rows = [
        ("Qwen3", "pretrained RTL text embedding", "weak alone"),
        ("MasterRTL/RF", "source-aligned RTL state", "less weak"),
        ("DeepGate", "netlist graph descriptor", "mixed"),
        ("RF+DeepGate", "hybrid graph + RTL state", "best 20260629 QD"),
        ("AURORA raw", "compact implementation features", "diagnostic"),
        ("FG-QDM / PCN", "guarded QD memory", "best after EoH fix"),
    ]
    fig, ax = plt.subplots(figsize=(10, 5))
    ax.set_axis_off()
    ax.set_title("Descriptor families tested across the RTLLM suites", fontsize=16, weight="bold", pad=12)
    headers = ["Family", "Descriptor idea", "Current read"]
    xs = [0.16, 0.52, 0.84]
    for x, h in zip(xs, headers):
        ax.text(x, 0.92, h, ha="center", va="center", fontsize=12, weight="bold")
    for i, row in enumerate(rows):
        y = 0.80 - i * 0.12
        color = "#eef4ff" if i % 2 == 0 else "#f7f7f7"
        ax.add_patch(plt.Rectangle((0.04, y - 0.045), 0.92, 0.085, fc=color, ec="#dddddd"))
        for x, cell in zip(xs, row):
            ax.text(x, y, cell, ha="center", va="center", fontsize=11)
    save(fig, FIG / "method_family_matrix.png")


def plot_20260630_operator_audit(df: pd.DataFrame) -> None:
    data = label_methods(df[df["candidate_count"] > 0]).sort_values("candidate_count")
    fig, ax = plt.subplots(figsize=(9.5, 4.8))
    y = range(len(data))
    ax.barh(y, data["candidate_count"], color="#dce9ff", label="candidate rows")
    ax.barh(y, data["eoh_strategy_count"], color="#3b4cc0", alpha=0.85, label="EoH strategy rows")
    ax.set_yticks(list(y))
    ax.set_yticklabels(data["label"])
    ax.legend(frameon=False, loc="lower right")
    style_axis(ax, "20260630 operator audit: no completed arm used single-thought", "Candidate rows")
    for i, row in enumerate(data.itertuples()):
        ax.text(row.candidate_count + 12, i, "single-thought = 0", va="center", fontsize=9)
    save(fig, FIG / "20260630_operator_audit.png")


def plot_20260629_coverage(df: pd.DataFrame) -> None:
    data = label_methods(finished(df))
    fig, ax = plt.subplots(figsize=(7.5, 5.5))
    ax.scatter(
        data["coverage_pct"],
        data["mean_hv_retention_pct"],
        s=140,
        c=[COLORS.get(x, "#777777") for x in data["label"]],
        edgecolor="#222222",
    )
    for row in data.itertuples():
        ax.text(row.coverage_pct + 0.6, row.mean_hv_retention_pct + 1, row.label, fontsize=9)
    ax.axhline(100, color="#222222", linewidth=1, linestyle="--")
    ax.set_xlim(52, 76)
    ax.set_ylim(35, 108)
    style_axis(ax, "20260629: coverage loss and HV loss moved together", "Valid-PPA coverage (%)", "Mean HV retention (%)")
    save(fig, FIG / "20260629_coverage_vs_hv_retention.png")


def plot_20260630_retention(df: pd.DataFrame) -> None:
    data = label_methods(finished(df)).sort_values("mean_hv_retention_pct")
    fig, ax = plt.subplots(figsize=(9, 4.8))
    ax.barh(data["label"], data["mean_hv_retention_pct"], color=[COLORS.get(x, "#777777") for x in data["label"]])
    ax.axvline(100, color="#222222", linewidth=1, linestyle="--")
    style_axis(ax, "20260630: EoH-preserving rerun changes the picture", "Mean HV retention vs classic (%)")
    for row in data.itertuples():
        ax.text(row.mean_hv_retention_pct + 0.8, row.label, f"{row.mean_hv_retention_pct:.1f}%", va="center")
    save(fig, FIG / "20260630_method_retention.png")


def plot_20260630_win_loss(df: pd.DataFrame) -> None:
    data = finished(df)
    row = data[data["method_key"] == "pcn_v3_rf_stagnation_memory_8x5"].iloc[0]
    labels = ["Wins", "Losses", "Ties"]
    values = [
        int(row.classic_hv_win_count),
        int(row.classic_hv_loss_count),
        int(row.classic_hv_tie_count),
    ]
    fig, ax = plt.subplots(figsize=(7.5, 4.5))
    ax.bar(labels, values, color=["#00a878", "#d95f02", "#9aa3ad"])
    style_axis(ax, "PCN-v3 vs classic: small positive one-seed signal", "", "Problem count")
    for i, value in enumerate(values):
        ax.text(i, value + 0.8, str(value), ha="center", weight="bold")
    save(fig, FIG / "20260630_pcn_win_loss.png")


def plot_qwen_comparison(s29: pd.DataFrame, s30: pd.DataFrame) -> None:
    rows = [
        ("20260629\nsingle-thought QD", float(s29.loc[s29["method_key"] == "qwen_canonical_rtl_pca3_8x5", "mean_hv_retention_pct"].iloc[0])),
        ("20260630\nEoH corrected", float(s30.loc[s30["method_key"] == "qwen_canonical_rtl_pca3_eoh_8x5", "mean_hv_retention_pct"].iloc[0])),
    ]
    fig, ax = plt.subplots(figsize=(6, 4.2))
    ax.bar([x for x, _ in rows], [y for _, y in rows], color=["#9b59b6", "#b65fcf"])
    ax.axhline(100, color="#222222", linestyle="--", linewidth=1)
    style_axis(ax, "Qwen3 improved after operator correction, but still trails", "", "Mean HV retention (%)")
    for i, (_, value) in enumerate(rows):
        ax.text(i, value + 2, f"{value:.1f}%", ha="center", weight="bold")
    save(fig, FIG / "qwen_operator_correction.png")


def plot_corrected_encoder_comparison(df: pd.DataFrame) -> None:
    keys = [
        "pcn_v3_rf_stagnation_memory_8x5",
        "classic_revolution_8x5",
        "deepgate_high_exploit_eoh_8x5",
        "masterrtl_archive_activation_eoh_8x5",
        "qwen_canonical_rtl_pca3_eoh_8x5",
    ]
    data = label_methods(finished(df).set_index("method_key").loc[keys].reset_index())
    fig, ax = plt.subplots(figsize=(8.5, 4.5))
    ax.bar(data["label"], data["mean_hv_retention_pct"], color=[COLORS.get(x, "#777777") for x in data["label"]])
    ax.axhline(100, color="#222222", linestyle="--", linewidth=1)
    ax.tick_params(axis="x", rotation=25)
    style_axis(ax, "Corrected 20260630 method comparison", "", "Mean HV retention (%)")
    for i, row in enumerate(data.itertuples()):
        ax.text(i, row.mean_hv_retention_pct + 1.5, f"{row.mean_hv_retention_pct:.1f}%", ha="center", fontsize=9)
    save(fig, FIG / "20260630_corrected_method_comparison.png")


def plot_pcn_memory_mechanism(df: pd.DataFrame) -> None:
    totals = df.sum(numeric_only=True)
    labels = ["Memory\nrefine", "Valid\nPPA", "Local front\nadds", "Global front\nadds"]
    values = [
        int(totals["memory_refine_generated"]),
        int(totals["memory_refine_valid_ppa"]),
        int(totals["memory_refine_local_front_adds"]),
        int(totals["memory_refine_global_front_adds"]),
    ]
    fig, ax = plt.subplots(figsize=(7.5, 4.5))
    ax.bar(labels, values, color=["#0f8b8d", "#00a878", "#6abf69", "#2c7fb8"])
    style_axis(ax, "PCN memory lane was active in 20260630", "", "Count")
    for i, value in enumerate(values):
        ax.text(i, value + max(values) * 0.03, str(value), ha="center", weight="bold")
    save(fig, FIG / "pcn_memory_mechanism.png")


def plot_20260701_cf_audit(df: pd.DataFrame) -> None:
    data = label_methods(df[df["candidate_count"] > 0])
    x = range(len(data))
    fig, ax = plt.subplots(figsize=(9.5, 4.8))
    ax.bar([i - 0.18 for i in x], data["c_f_count"], width=0.36, label="C-F count", color="#3b4cc0")
    ax.bar([i + 0.18 for i in x], data["single_thought_count"], width=0.36, label="Single-thought count", color="#d95f02")
    ax.set_xticks(list(x))
    ax.set_xticklabels(data["label"], rotation=20, ha="right")
    ax.legend(frameon=False)
    style_axis(ax, "20260701 smoke: operator contract is visible", "", "Candidate count")
    for i, row in enumerate(data.itertuples()):
        ax.text(i - 0.18, row.c_f_count + 0.7, str(int(row.c_f_count)), ha="center", fontsize=9)
        ax.text(i + 0.18, row.single_thought_count + 0.7, str(int(row.single_thought_count)), ha="center", fontsize=9)
    save(fig, FIG / "20260701_smoke_cf_audit.png")


def plot_20260701_smoke_comparison(df: pd.DataFrame) -> None:
    data = df.copy()
    labels = [
        "No C-F\nclassic effect",
        "PCN memory\nno-C-F control",
        "PCN C-F restored\nvs classic",
    ]
    rows = [
        "classic_no_cf_minus_classic",
        "pcn_no_cf_minus_classic_no_cf",
        "pcn_cf_restored_minus_classic",
    ]
    vals = [float(data.loc[data["comparison"] == row, "mean_delta_hv"].iloc[0]) for row in rows]
    lows = [float(data.loc[data["comparison"] == row, "bootstrap_ci95_low"].iloc[0]) for row in rows]
    highs = [float(data.loc[data["comparison"] == row, "bootstrap_ci95_high"].iloc[0]) for row in rows]
    lower_err = [value - low for value, low in zip(vals, lows)]
    upper_err = [high - value for value, high in zip(vals, highs)]
    fig, ax = plt.subplots(figsize=(8, 4.8))
    ax.bar(labels, vals, color=["#6b8fd6", "#45a29e", "#00a878"])
    ax.errorbar(labels, vals, yerr=[lower_err, upper_err], fmt="none", ecolor="#222222", capsize=5, linewidth=1.2)
    ax.axhline(0, color="#222222", linewidth=1)
    style_axis(ax, "20260701 smoke HV deltas with bootstrap CI (n=3)", "", "Mean HV delta")
    for i, value in enumerate(vals):
        ax.text(i, value + 0.01, f"{value:.3f}", ha="center", weight="bold")
    save(fig, FIG / "20260701_smoke_comparison.png")


def plot_20260701_smoke_hv(df: pd.DataFrame) -> None:
    data = label_methods(df).sort_values("mean_hv")
    fig, ax = plt.subplots(figsize=(8.5, 4.6))
    ax.barh(data["label"], data["mean_hv"], color=[COLORS.get(x, "#777777") for x in data["label"]])
    style_axis(ax, "20260701 smoke: C-F-restored PCN is strongest on n=3", "Mean HV")
    for row in data.itertuples():
        ax.text(row.mean_hv + 0.01, row.label, f"{row.mean_hv:.3f}", va="center")
    save(fig, FIG / "20260701_smoke_mean_hv.png")


def clear(ax: plt.Axes, title: str) -> None:
    ax.set_title(title, fontsize=16, weight="bold", pad=12)
    ax.set_axis_off()


def box(ax: plt.Axes, xy: tuple[float, float], text: str, color: str = "#f7f7f7") -> None:
    ax.text(
        xy[0],
        xy[1],
        text,
        ha="center",
        va="center",
        fontsize=11,
        bbox={"boxstyle": "round,pad=0.5", "fc": color, "ec": "#333333", "lw": 1.2},
    )


def arrow(ax: plt.Axes, a: tuple[float, float], b: tuple[float, float]) -> None:
    ax.annotate("", xy=b, xytext=a, arrowprops={"arrowstyle": "->", "lw": 1.5, "color": "#333333"})


def rect_box(
    ax: plt.Axes,
    xy: tuple[float, float],
    size: tuple[float, float],
    text: str,
    color: str,
    fontsize: int = 11,
) -> None:
    x, y = xy
    w, h = size
    ax.add_patch(
        plt.Rectangle(
            (x - w / 2, y - h / 2),
            w,
            h,
            fc=color,
            ec="#333333",
            lw=1.3,
        )
    )
    ax.text(x, y, text, ha="center", va="center", fontsize=fontsize)


def draw_timeline() -> None:
    fig, ax = plt.subplots(figsize=(10, 3.2))
    clear(ax, "Evidence timeline")
    xs = [0.18, 0.5, 0.82]
    labels = [
        "20260629\nFull RTLLM\nQD loses badly",
        "20260630\nEoH corrected\nPCN reaches 103.4%",
        "20260701\nSmoke ablation\nC-F confound tested",
    ]
    for x, text in zip(xs, labels):
        box(ax, (x, 0.55), text, "#eef4ff")
    arrow(ax, (0.31, 0.55), (0.39, 0.55))
    arrow(ax, (0.63, 0.55), (0.71, 0.55))
    ax.text(0.5, 0.18, "Current status: strong hypothesis, not final multi-seed proof", ha="center", fontsize=12)
    save(fig, CONCEPT / "timeline_story.png")


def draw_scalar_vs_pareto() -> None:
    fig, ax = plt.subplots(figsize=(7, 5))
    area = [0.10, 0.22, 0.35, 0.48, 0.62, 0.76]
    power = [0.80, 0.62, 0.48, 0.36, 0.25, 0.18]
    ax.scatter(area, power, s=120, color="#3b4cc0")
    ax.plot(area, power, color="#3b4cc0", alpha=0.4)
    ax.scatter([0.62], [0.25], s=230, color="#d95f02", label="scalar-fitness pick")
    ax.annotate("Weighted score\nchooses one bias", xy=(0.62, 0.25), xytext=(0.48, 0.58), arrowprops={"arrowstyle": "->"})
    ax.set_xlabel("Area improvement")
    ax.set_ylabel("Power improvement")
    ax.set_title("Scalar fitness can hide Pareto tradeoffs", fontsize=16, weight="bold")
    ax.grid(color="#d8d8d8")
    ax.legend(frameon=False)
    save(fig, CONCEPT / "scalar_fitness_vs_pareto.png")


def draw_hv_hv_auc() -> None:
    fig, axes = plt.subplots(1, 2, figsize=(10, 4))
    ax = axes[0]
    ax.set_title("Final HV", fontsize=14, weight="bold")
    ax.fill_between([0.15, 0.72], [0.15, 0.15], [0.75, 0.75], color="#b3d9ff", alpha=0.75)
    ax.scatter([0.25, 0.45, 0.70], [0.70, 0.52, 0.30], color="#3b4cc0", s=90)
    ax.set_xlabel("Area gain")
    ax.set_ylabel("Power gain")
    ax.grid(color="#dddddd")
    ax = axes[1]
    gens = [0, 1, 2, 3, 4, 5]
    hv = [0.02, 0.08, 0.15, 0.19, 0.24, 0.27]
    ax.set_title("HV-AUC", fontsize=14, weight="bold")
    ax.plot(gens, hv, color="#0f8b8d", marker="o")
    ax.fill_between(gens, hv, color="#b7e4d2", alpha=0.8)
    ax.set_xlabel("Generation")
    ax.set_ylabel("HV")
    ax.grid(color="#dddddd")
    fig.suptitle("HV asks where the final front landed; HV-AUC asks how fast it got there", fontsize=15, weight="bold")
    save(fig, CONCEPT / "hv_hv_auc_explainer.png")


def draw_classic_pipeline() -> None:
    fig, ax = plt.subplots(figsize=(11, 3.4))
    clear(ax, "Classic REvolution is a compact hill climber")
    labels = ["Initial RTL\npopulation", "Evaluate\nfunction + PPA", "Success pool\ntop valid RTL", "EoH improve\nthought/code/feedback", "Next gen"]
    xs = [0.10, 0.30, 0.50, 0.72, 0.91]
    for x, text in zip(xs, labels):
        box(ax, (x, 0.55), text, "#eef4ff")
    for a, b in zip(xs[:-1], xs[1:]):
        arrow(ax, (a + 0.07, 0.36), (b - 0.07, 0.36))
    save(fig, CONCEPT / "classic_pipeline.png")


def draw_qd_grid() -> None:
    fig, ax = plt.subplots(figsize=(6, 5.2))
    ax.set_title("MAP-Elites intuition", fontsize=16, weight="bold")
    for i in range(5):
        for j in range(5):
            color = "#f5f5f5"
            if (i + j) % 3 == 0:
                color = "#cfe8ff"
            if (i, j) in [(1, 3), (3, 1), (4, 4)]:
                color = "#00a878"
            ax.add_patch(plt.Rectangle((i, j), 1, 1, fc=color, ec="#555555", lw=1))
    ax.text(2.5, -0.55, "Descriptor axis 1", ha="center")
    ax.text(-0.6, 2.5, "Descriptor axis 2", va="center", rotation=90)
    ax.text(2.5, 5.35, "Keep high-quality candidates across behavior cells", ha="center", fontsize=11)
    ax.set_xlim(0, 5)
    ax.set_ylim(0, 5)
    ax.set_aspect("equal")
    ax.set_axis_off()
    save(fig, CONCEPT / "qd_grid_concept.png")


def draw_appendix_classic_revolution() -> None:
    fig, ax = plt.subplots(figsize=(11, 4.2))
    clear(ax, "Classic REvolution: greedy EoH hill climbing")
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    items = [
        (0.10, 0.62, 0.15, "Initial RTL\npopulation"),
        (0.29, 0.62, 0.16, "Evaluate\nfunction + PPA"),
        (0.48, 0.62, 0.18, "Success pool\nvalid high-score RTL"),
        (0.70, 0.62, 0.18, "EoH improve\nM-S M-E M-R M-I C-F"),
        (0.90, 0.62, 0.13, "Next\ngeneration"),
    ]
    for x, y, w, label in items:
        rect_box(ax, (x, y), (w, 0.16), label, "#edf2ff", fontsize=10)
    for (x1, y1, w1, _), (x2, y2, w2, _) in zip(items[:-1], items[1:]):
        arrow(ax, (x1 + w1 / 2 + 0.01, y1), (x2 - w2 / 2 - 0.01, y2))
    rect_box(ax, (0.29, 0.28), (0.22, 0.15), "Invalid / weak\ncandidates drop out", "#f2f2f2", fontsize=10)
    arrow(ax, (0.29, 0.54), (0.29, 0.36))
    ax.text(
        0.5,
        0.08,
        "No descriptor archive: most budget refines candidates already known to work.",
        ha="center",
        fontsize=12,
        weight="bold",
    )
    save(fig, CONCEPT / "classic_revolution_methodology_clean.png")


def draw_appendix_generic_qd() -> None:
    fig, axes = plt.subplots(1, 2, figsize=(11, 4.4), width_ratios=[1.1, 1])
    fig.suptitle("Generic QD / MAP-Elites: descriptor archive drives search", fontsize=16, weight="bold")
    ax = axes[0]
    ax.set_axis_off()
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    flow = [
        (0.18, 0.72, 0.20, "Candidate\nRTL"),
        (0.50, 0.72, 0.22, "Descriptor\nextractor"),
        (0.82, 0.72, 0.18, "Archive\ncell"),
        (0.50, 0.30, 0.22, "Sample\nparents\nfrom cells"),
    ]
    for x, y, w, label in flow:
        rect_box(ax, (x, y), (w, 0.16), label, "#fff7e6", fontsize=10)
    arrow(ax, (0.29, 0.72), (0.38, 0.72))
    arrow(ax, (0.61, 0.72), (0.72, 0.72))
    arrow(ax, (0.82, 0.63), (0.59, 0.39))
    arrow(ax, (0.42, 0.39), (0.20, 0.63))
    ax.text(0.5, 0.08, "Risk: scarce calls chase coverage before cells prove PPA value.", ha="center", fontsize=11, weight="bold")

    ax = axes[1]
    ax.set_title("Archive grid", fontsize=13, weight="bold")
    for i in range(5):
        for j in range(4):
            color = "#ffffff"
            if (i + 2 * j) % 4 == 0:
                color = "#d9ecff"
            if (i, j) in [(1, 2), (3, 1), (4, 3)]:
                color = "#c7f0d8"
            if (i, j) in [(0, 0), (2, 3)]:
                color = "#f2f2f2"
            ax.add_patch(plt.Rectangle((i, j), 1, 1, fc=color, ec="#333333", lw=1))
    ax.text(2.5, -0.45, "BD axis 1", ha="center", fontsize=11)
    ax.text(-0.45, 2.0, "BD axis 2", va="center", rotation=90, fontsize=11)
    ax.set_xlim(-0.7, 5)
    ax.set_ylim(-0.7, 4.3)
    ax.set_aspect("equal")
    ax.set_axis_off()
    save(fig, CONCEPT / "generic_qd_map_elites_methodology_clean.png")


def draw_appendix_pcn_v3() -> None:
    fig, ax = plt.subplots(figsize=(11, 4.6))
    clear(ax, "PCN-v3: classic loop plus small guarded memory")
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    main = [
        (0.12, 0.66, 0.17, "Classic\nsuccess pool"),
        (0.36, 0.66, 0.24, "EoH improve\nthought/code/feedback"),
        (0.59, 0.66, 0.17, "Evaluate\nfunction + PPA"),
        (0.80, 0.66, 0.17, "Update\nclassic pool"),
    ]
    for x, y, w, label in main:
        rect_box(ax, (x, y), (w, 0.15), label, "#edf2ff", fontsize=10)
    for (x1, y1, w1, _), (x2, y2, w2, _) in zip(main[:-1], main[1:]):
        arrow(ax, (x1 + w1 / 2 + 0.01, y1), (x2 - w2 / 2 - 0.01, y2))
    arrow(ax, (0.885, 0.75), (0.035, 0.75))

    rect_box(ax, (0.59, 0.36), (0.18, 0.14), "Passive insert\nvalid-PPA only", "#e8f7ee", fontsize=10)
    rect_box(ax, (0.36, 0.36), (0.22, 0.14), "QD memory cells\ncredit + stagnation gate", "#d4f1df", fontsize=10)
    arrow(ax, (0.59, 0.58), (0.59, 0.43))
    arrow(ax, (0.50, 0.36), (0.47, 0.36))
    arrow(ax, (0.36, 0.43), (0.36, 0.58))

    rect_box(ax, (0.84, 0.19), (0.25, 0.14), "No empty-cell fill\nNo descriptor targeting\nNo QD fusion", "#f2f2f2", fontsize=10)
    ax.text(
        0.30,
        0.10,
        "Most calls stay classic; memory recalls only PPA-relevant alternatives.",
        ha="center",
        fontsize=12,
        weight="bold",
    )
    save(fig, CONCEPT / "pcn_v3_methodology_clean.png")


def draw_operator_mismatch() -> None:
    fig, ax = plt.subplots(figsize=(10, 4))
    clear(ax, "20260629 compared QD plus a weaker operator path")
    box(ax, (0.25, 0.72), "Classic\nEoH strategy stack\nthought/code/feedback", "#eef4ff")
    box(ax, (0.25, 0.32), "Strong hill-climb\nprimary success pool", "#dce9ff")
    box(ax, (0.73, 0.72), "QD arms\nsingle_thought_operator", "#fff0e6")
    box(ax, (0.73, 0.32), "Descriptor archive\nless exploitation pressure", "#ffe2cc")
    arrow(ax, (0.25, 0.62), (0.25, 0.42))
    arrow(ax, (0.73, 0.62), (0.73, 0.42))
    ax.text(0.5, 0.08, "Corrected 20260630 rerun restores EoH before judging QD", ha="center", fontsize=12, weight="bold")
    save(fig, CONCEPT / "operator_mismatch_diagram.png")


def draw_replacement_vs_memory() -> None:
    fig, ax = plt.subplots(figsize=(10, 4))
    clear(ax, "The algorithmic lesson")
    box(ax, (0.24, 0.62), "Replace success pool\nwith QD archive", "#ffe2cc")
    box(ax, (0.24, 0.32), "Lower valid yield\nand weaker hill climbing", "#fff0e6")
    box(ax, (0.74, 0.62), "Keep classic pool\nadd guarded memory", "#d8f3dc")
    box(ax, (0.74, 0.32), "Preserve exploitation\nrecall near-front families", "#b7e4c7")
    arrow(ax, (0.24, 0.52), (0.24, 0.42))
    arrow(ax, (0.74, 0.52), (0.74, 0.42))
    save(fig, CONCEPT / "replacement_vs_memory.png")


def draw_pcn_architecture() -> None:
    fig, ax = plt.subplots(figsize=(10, 4.2))
    clear(ax, "PCN-v3: QD as guarded memory")
    box(ax, (0.12, 0.62), "Classic\nprimary pool", "#eef4ff")
    box(ax, (0.36, 0.62), "EoH\nimprovement", "#dce9ff")
    box(ax, (0.60, 0.62), "Evaluate\nfunction + PPA", "#f7f7f7")
    box(ax, (0.84, 0.62), "Update\nclassic pool", "#eef4ff")
    box(ax, (0.60, 0.25), "PCN memory\nnear-front descriptor cells", "#d8f3dc")
    arrow(ax, (0.19, 0.62), (0.29, 0.62))
    arrow(ax, (0.43, 0.62), (0.53, 0.62))
    arrow(ax, (0.67, 0.62), (0.77, 0.62))
    arrow(ax, (0.60, 0.52), (0.60, 0.35))
    arrow(ax, (0.52, 0.25), (0.36, 0.52))
    ax.text(0.48, 0.10, "Most calls stay classic; memory-refine spends a small gated fraction", ha="center", fontsize=11)
    save(fig, CONCEPT / "pcn_architecture.png")


def draw_cf_ablation_design() -> None:
    fig, ax = plt.subplots(figsize=(10, 4.4))
    clear(ax, "C-F ablation isolates operator-set versus memory effects")
    rows = [
        ("Classic", "C-F on", "No PCN memory", 0.78, "#eef4ff"),
        ("Classic no C-F", "C-F off", "No PCN memory", 0.58, "#f7f7f7"),
        ("PCN no C-F", "C-F off", "PCN memory on", 0.38, "#d8f3dc"),
        ("PCN C-F restored", "C-F on", "PCN memory on", 0.18, "#b7e4c7"),
    ]
    for name, cf, memory, y, color in rows:
        ax.add_patch(plt.Rectangle((0.06, y - 0.055), 0.88, 0.095, fc=color, ec="#dddddd"))
        ax.text(0.22, y, name, ha="center", va="center", fontsize=12, weight="bold")
        ax.text(0.50, y, cf, ha="center", va="center", fontsize=12)
        ax.text(0.78, y, memory, ha="center", va="center", fontsize=12)
    ax.text(0.22, 0.91, "Arm", ha="center", fontsize=12, weight="bold")
    ax.text(0.50, 0.91, "Operator set", ha="center", fontsize=12, weight="bold")
    ax.text(0.78, 0.91, "Memory", ha="center", fontsize=12, weight="bold")
    save(fig, CONCEPT / "cf_ablation_design.png")


def draw_recommended_algorithm() -> None:
    fig, ax = plt.subplots(figsize=(10, 4.2))
    clear(ax, "Recommended QD shape after failures")
    labels = [
        ("80-90%\nclassic EoH calls", 0.15, "#eef4ff"),
        ("Passive memory\nvalid-PPA only", 0.38, "#d8f3dc"),
        ("Front guard\nnear-Pareto cells", 0.61, "#b7e4c7"),
        ("Small memory-refine\nlane", 0.84, "#95d5b2"),
    ]
    for text, x, color in labels:
        box(ax, (x, 0.55), text, color)
    for a, b in [(0.23, 0.30), (0.46, 0.53), (0.69, 0.76)]:
        arrow(ax, (a, 0.55), (b, 0.55))
    ax.text(0.5, 0.17, "Do not reward descriptor novelty unless the candidate remains PPA-competitive", ha="center", fontsize=12, weight="bold")
    save(fig, CONCEPT / "recommended_algorithm_shape.png")


def draw_claim_gates() -> None:
    fig, ax = plt.subplots(figsize=(9, 4.8))
    clear(ax, "Claim gates before saying PCN works")
    gates = [
        ("Operator audit\nno single-thought", 0.78),
        ("Reference-complete\npaired RTLLM", 0.58),
        ("Beat matched\noperator control", 0.38),
        ("No coverage\ncollapse", 0.18),
    ]
    for text, y in gates:
        box(ax, (0.50, y), text, "#eef4ff")
    for y1, y2 in [(0.70, 0.64), (0.50, 0.44), (0.30, 0.24)]:
        arrow(ax, (0.50, y1), (0.50, y2))
    save(fig, CONCEPT / "claim_gate_checklist.png")


def draw_experiment_ladder() -> None:
    fig, ax = plt.subplots(figsize=(10, 3.8))
    clear(ax, "Next experiment ladder")
    steps = [
        ("20260701\n5-seed RTLLM", 0.14),
        ("C-F\nablation", 0.36),
        ("Elite-cell\nvariants", 0.58),
        ("VerilogEval\nholdout", 0.80),
    ]
    for text, x in steps:
        box(ax, (x, 0.55), text, "#eef4ff")
    for a, b in [(0.22, 0.28), (0.44, 0.50), (0.66, 0.72)]:
        arrow(ax, (a, 0.55), (b, 0.55))
    ax.text(0.5, 0.18, "Do not spend follow-up budget unless the matched control survives", ha="center", fontsize=12)
    save(fig, CONCEPT / "experiment_ladder.png")


def draw_discussion_map() -> None:
    fig, ax = plt.subplots(figsize=(10, 4.6))
    clear(ax, "Discussion questions should map to evidence")
    rows = [
        ("Mechanism\nor confound?", "20260701\nC-F ablation", 0.78, "#eef4ff"),
        ("Which descriptors\nmatter?", "Encoder ranking\n20260629 -> 20260630", 0.52, "#f7f7f7"),
        ("Fair QD\nbudget shape?", "Coverage + memory\ncontribution counters", 0.26, "#d8f3dc"),
    ]
    for question, evidence, y, color in rows:
        box(ax, (0.27, y), question, color)
        box(ax, (0.72, y), evidence, "#ffffff")
        arrow(ax, (0.39, y), (0.60, y))
    ax.text(0.27, 0.93, "Question", ha="center", fontsize=12, weight="bold")
    ax.text(0.72, 0.93, "Evidence to inspect", ha="center", fontsize=12, weight="bold")
    save(fig, CONCEPT / "discussion_question_map.png")


def draw_lessons() -> None:
    fig, ax = plt.subplots(figsize=(10, 4))
    clear(ax, "Current takeaways")
    box(ax, (0.18, 0.55), "Generic diversity\nis not enough", "#fff0e6")
    box(ax, (0.50, 0.55), "Classic exploitation\nis the anchor", "#eef4ff")
    box(ax, (0.82, 0.55), "Guarded memory\nis the live hypothesis", "#d8f3dc")
    save(fig, CONCEPT / "lessons_summary.png")


if __name__ == "__main__":
    main()
