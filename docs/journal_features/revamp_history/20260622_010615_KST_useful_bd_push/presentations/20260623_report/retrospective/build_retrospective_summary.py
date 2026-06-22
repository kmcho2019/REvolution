from __future__ import annotations

from pathlib import Path

import matplotlib
import pandas as pd

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

PACKAGE = Path(__file__).resolve().parent
REVAMP_HISTORY = PACKAGE.parents[3]
SOURCE = REVAMP_HISTORY / "20260621_000217_KST_rtl_diversity_check" / "20260621_150407_UTC_compiled_results_bundle"
RAW = SOURCE / "raw_data" / "final_report"
STAGES = SOURCE / "stage_results"
AUDIT = Path("exp/diversity_check/restarted_report_20260621_075346_UTC/candidate_audit.parquet")

CORPUS_LABELS = {
    "aspdac2026_release": "ASP-DAC release",
    "auto_bd_standard_results": "Auto-BD controls",
    "rtllm_gen20": "RTLLM gen-20",
}

GATE_LABELS = {
    "D1 early_predictive": "D1 early diversity predicts final PPA",
    "D2 multi_cluster_front": "D2 clusters explain PPA front",
    "D3 replay_retention": "D3 diversity replay beats fitness",
    "D4 prospective_moderate_diversity": "D4 live intervention",
    "D5 real_beats_random": "D5 descriptors beat controls",
    "D6 interpretable_regions": "D6 interpretable regions",
}

POLICY_LABELS = {
    "oracle_motif_diversity": "Motif diversity oracle",
    "oracle_style_diversity": "Style diversity oracle",
    "oracle_lexical_diversity": "Lexical diversity oracle",
    "oracle_best_fitness": "Best-fitness oracle",
    "online_best_fitness": "Online best fitness",
    "random_mean": "Random mean",
}

QWEN_LABELS = {
    "qwen_identifier_farthest": "Qwen identifier-normalized",
    "fitness_top": "Fitness top-half",
    "lexical_farthest": "Lexical farthest",
    "qwen_raw_farthest": "Qwen raw",
    "random": "Random",
}


def write_table(frame: pd.DataFrame, name: str) -> None:
    out = PACKAGE / "tables" / name
    out.parent.mkdir(parents=True, exist_ok=True)
    frame.to_csv(out, index=False)


def savefig(name: str) -> None:
    out = PACKAGE / "figures" / name
    out.parent.mkdir(parents=True, exist_ok=True)
    plt.tight_layout()
    plt.savefig(out, dpi=180)
    plt.close()


def source_coverage() -> pd.DataFrame:
    coverage = pd.read_csv(RAW / "corpus_coverage.csv")
    keep = coverage[["corpus", "candidate_count", "code_artifacts", "netlist_artifacts", "ppa_artifacts"]].copy()
    for column in ["candidate_count", "code_artifacts", "netlist_artifacts", "ppa_artifacts"]:
        keep[column] = pd.to_numeric(keep[column], errors="coerce")
    table = keep.groupby("corpus", as_index=False).sum(numeric_only=True)
    table = table.sort_values("candidate_count", ascending=False)
    write_table(table, "retrospective_source_coverage.csv")

    plot = table.assign(label=table["corpus"].map(CORPUS_LABELS)).set_index("label")[["candidate_count", "ppa_artifacts"]]
    ax = plot.plot(kind="bar", figsize=(8.4, 4.7), color=["#4C78A8", "#F58518"])
    ax.set_title("Retrospective source coverage")
    ax.set_ylabel("Count")
    ax.set_xlabel("")
    ax.legend(["Candidate rows", "Valid PPA artifacts"], frameon=False)
    ax.tick_params(axis="x", rotation=20)
    savefig("retrospective_source_coverage.png")
    return table


def gate_summary() -> pd.DataFrame:
    table = pd.read_csv(RAW / "d_gate_matrix.csv")
    d3 = table["gate"] == "D3 replay_retention"
    table.loc[d3, "evidence"] = (
        "best diversity oracle HV gain over best-fitness retention=1.35%; "
        "10% threshold required"
    )
    write_table(table, "retrospective_gate_summary.csv")

    colors = {"PASS": "#54A24B", "FAIL": "#E45756", "NOT_RUN": "#B279A2"}
    labels = table["gate"].map(GATE_LABELS)
    y = range(len(table))
    plt.figure(figsize=(8.7, 4.7))
    plt.barh(y, table["problem_count"], color=[colors[x] for x in table["status"]])
    plt.yticks(y, labels)
    plt.xlabel("Problem groups covered; bar length is not severity")
    plt.title("Retrospective utility gates")
    for y_pos, (_, row) in enumerate(table.iterrows()):
        plt.text(row["problem_count"] + 8, y_pos, row["status"], va="center", fontsize=9)
    plt.gca().invert_yaxis()
    savefig("retrospective_gate_status.png")
    return table


def replay_summary() -> pd.DataFrame:
    replay = pd.read_csv(RAW / "counterfactual_replay.csv")
    table = replay.groupby("policy", as_index=False).agg(
        mean_hypervolume=("hypervolume", "mean"),
        mean_best_fitness=("best_fitness", "mean"),
        mean_style_clusters=("unique_style_clusters", "mean"),
        rows=("problem_id", "count"),
    )
    table = table.sort_values("mean_hypervolume", ascending=False)
    write_table(table, "retrospective_counterfactual_replay.csv")

    random_mean = table[table["policy"].str.startswith("random_seed_")].mean(numeric_only=True)
    table = pd.concat(
        [
            table,
            pd.DataFrame([{"policy": "random_mean", **random_mean.to_dict()}]),
        ],
        ignore_index=True,
    )
    policies = [
        "oracle_motif_diversity",
        "oracle_style_diversity",
        "oracle_lexical_diversity",
        "oracle_best_fitness",
        "online_best_fitness",
        "random_mean",
    ]
    plot = table[table["policy"].isin(policies)].copy()
    plot["policy"] = pd.Categorical(plot["policy"], policies, ordered=True)
    plot = plot.sort_values("policy")
    plot["label"] = plot["policy"].map(POLICY_LABELS)

    fig, axes = plt.subplots(1, 2, figsize=(10.4, 4.2))
    axes[0].barh(plot["label"], plot["mean_hypervolume"], color="#4C78A8")
    axes[0].set_title("Replay HV")
    axes[0].set_xlabel("Mean hypervolume")
    axes[1].barh(plot["label"], plot["mean_style_clusters"], color="#72B7B2")
    axes[1].set_title("Retained style clusters")
    axes[1].set_xlabel("Mean clusters")
    for ax in axes:
        ax.tick_params(axis="y", labelsize=8)
    savefig("retrospective_replay_tradeoff.png")
    return table


def encoder_summary() -> pd.DataFrame:
    encoder = pd.read_csv(RAW / "encoder_leaderboard.csv")
    table = encoder[["family", "non_collapse", "replay_signal", "verdict"]]
    write_table(table, "retrospective_encoder_summary.csv")

    qwen = pd.read_csv(STAGES / "wp1_qwen" / "qwen_common_audit_aggregate.csv")
    qwen = qwen[["representation", "vs_lexical_hv_gain_fraction"]].copy()
    qwen = qwen[qwen["representation"].str.contains("qwen|lexical|fitness|random", regex=True)]
    qwen = qwen.sort_values("vs_lexical_hv_gain_fraction")
    qwen["label"] = qwen["representation"].map(QWEN_LABELS)
    colors = ["#54A24B" if x > 0 else "#E45756" if x < 0 else "#9D9D9D" for x in qwen["vs_lexical_hv_gain_fraction"]]
    plt.figure(figsize=(8.8, 4.4))
    plt.barh(qwen["label"], qwen["vs_lexical_hv_gain_fraction"] * 100, color=colors)
    plt.axvline(0, color="#333333", linewidth=1)
    plt.title("Frozen Qwen replay: HV delta vs lexical farthest")
    plt.xlabel("HV delta (%)")
    savefig("retrospective_qwen_replay_delta.png")
    return table


def early_diversity() -> pd.DataFrame:
    table = pd.read_csv(RAW / "early_diversity.csv")
    table = table[table["final_hypervolume"].notna()].copy()
    rho = table["early_mean_lexical_distance"].corr(table["final_hypervolume"], method="spearman")

    plt.figure(figsize=(8.4, 4.9))
    plt.scatter(
        table["early_mean_lexical_distance"],
        table["final_hypervolume"],
        s=22,
        alpha=0.7,
        color="#4C78A8",
        edgecolors="none",
    )
    plt.title("Early lexical diversity weakly tracks final PPA HV")
    plt.xlabel("Early mean lexical distance")
    plt.ylabel("Final hypervolume")
    plt.text(0.98, 0.92, f"Spearman rho = {rho:.3f}", transform=plt.gca().transAxes, ha="right")
    savefig("retrospective_early_diversity_vs_final_hv.png")
    return table


def cluster_case_study() -> pd.DataFrame:
    columns = ["problem_id", "area", "power", "valid_ppa", "pareto_member", "style_cluster"]
    audit = pd.read_parquet(AUDIT, columns=columns)
    audit = audit[audit["valid_ppa"]].dropna(subset=["area", "power", "style_cluster"]).copy()

    grouped = audit.groupby("problem_id").agg(
        valid_ppa=("problem_id", "count"),
        style_count=("style_cluster", "nunique"),
        pareto_count=("pareto_member", "sum"),
        area_min=("area", "min"),
        area_max=("area", "max"),
        power_min=("power", "min"),
        power_max=("power", "max"),
    )
    front_styles = audit[audit["pareto_member"]].groupby("problem_id")["style_cluster"].nunique()
    grouped["front_style_count"] = front_styles
    grouped = grouped.fillna({"front_style_count": 0})
    grouped["area_span"] = grouped["area_max"] - grouped["area_min"]
    grouped["power_span"] = grouped["power_max"] - grouped["power_min"]
    style_max_share = audit.groupby("problem_id")["style_cluster"].value_counts(normalize=True).groupby("problem_id").max()
    front_max_share = (
        audit[audit["pareto_member"]]
        .groupby("problem_id")["style_cluster"]
        .value_counts(normalize=True)
        .groupby("problem_id")
        .max()
    )
    grouped["style_max_share"] = style_max_share
    grouped["front_max_share"] = front_max_share
    front_area_span = audit[audit["pareto_member"]].groupby("problem_id")["area"].agg(lambda x: x.max() - x.min())
    front_power_span = audit[audit["pareto_member"]].groupby("problem_id")["power"].agg(lambda x: x.max() - x.min())
    grouped["front_area_span"] = front_area_span
    grouped["front_power_span"] = front_power_span
    eligible = grouped[
        grouped.index.str.contains("/RTLLM/")
        & (grouped["valid_ppa"] >= 30)
        & (grouped["style_count"] >= 3)
        & (grouped["front_style_count"] >= 2)
        & (grouped["front_area_span"] > 0)
        & (grouped["front_power_span"] > 0)
        & (grouped["style_max_share"] < 0.80)
        & (grouped["front_max_share"] < 0.90)
    ]
    eligible = eligible.sort_values(
        ["front_area_span", "front_power_span", "front_style_count", "style_count", "valid_ppa"],
        ascending=False,
    )
    problem_id = eligible.index[0]

    rows = audit[audit["problem_id"] == problem_id].copy()
    summary = rows.groupby("style_cluster", as_index=False).agg(
        valid_ppa=("style_cluster", "count"),
        pareto_count=("pareto_member", "sum"),
        best_area=("area", "min"),
        best_power=("power", "min"),
    )
    summary.insert(0, "problem_id", problem_id)
    write_table(summary, "retrospective_cluster_case_study.csv")

    clusters = sorted(rows["style_cluster"].unique())
    cmap = plt.get_cmap("tab10")
    plt.figure(figsize=(8.4, 5.0))
    background = rows[~rows["pareto_member"]]
    plt.scatter(background["area"], background["power"], s=20, alpha=0.18, color="#9D9D9D", label="Non-front candidates")
    area_offset = max(rows["area"].max() - rows["area"].min(), 1.0) * 0.003
    center = (len(clusters) - 1) / 2
    for i, cluster in enumerate(clusters):
        sub = rows[(rows["style_cluster"] == cluster) & (rows["pareto_member"])]
        if len(sub) == 0:
            continue
        offset = i - center
        plt.scatter(
            sub["area"] + offset * area_offset,
            sub["power"] * (1 + offset * 0.012),
            s=58,
            alpha=0.78,
            color=cmap(i),
            edgecolors="#111111",
            linewidths=0.8,
            label=f"Front: {cluster.replace('_', ' ')}",
        )
    plt.title(f"2D PPA-front projection by style: {problem_id.split('/')[-1]}")
    plt.xlabel("Area")
    plt.ylabel("Power, log scale")
    plt.yscale("log")
    plt.legend(frameon=False, fontsize=8, loc="best")
    savefig("retrospective_cluster_case_study.png")
    return summary


def main() -> None:
    source_coverage()
    gate_summary()
    replay_summary()
    encoder_summary()
    early_diversity()
    cluster_case_study()


if __name__ == "__main__":
    main()
