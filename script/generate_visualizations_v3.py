# /// script
# dependencies = ["numpy", "pandas", "matplotlib", "seaborn", "tqdm", "scipy", "jsonlines"]
# ///
"""
Generate evolution plots for an RTL-LLM experiment.

Usage
-----
python generate_evolution_figures.py  /abs/path/to/<model_name_run_name>

A directory   <model_name_run_name>_figures   is created next to the
input folder.  Inside it the original hierarchy

    benchmark / problem / <png files>

is replicated.

For each problem the script produces

  1.  pareto_<problem>.png
  1a. pareto_cloud_<problem>.png
  2.  strategy_prob_success_<problem>.png
      strategy_prob_fail_<problem>.png
  3.  best_score_<problem>.png

For every benchmark it additionally produces

      avg_strategy_prob_success.png
      avg_strategy_prob_fail.png

See the long description in the paper / prompt for the exact semantics.
"""
import os
import json
import jsonlines
import glob
from pathlib import Path
from collections import defaultdict, Counter

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D          # pylint: disable=unused-import
import seaborn as sns
from tqdm import tqdm
from scipy.spatial import ConvexHull

ROOT_KEY_REF = "ref_ppa_metric"          # helper constants
C_FIG = "_figures"                       # suffix for output directory


# ---------------------------------------------------------------------------
# generic helpers
# ---------------------------------------------------------------------------
def mkdir(p: Path):
    p.mkdir(parents=True, exist_ok=True)
    return p


def is_combational(ref_dict):
    """
    A problem is combinational when its reference WNS is 0 (=> no register),
    hence effective clock is meaningless.
    """
    return abs(ref_dict.get("wns", 0)) < 1e-12 or ref_dict.get("eff_clk_period", 0.0) == 0.0


def pareto_front(points, minimisation_dims):
    """
    Return indices of Pareto efficient points.

    'points'         : (N, D) numpy array
    minimisation_dims: list of column indices that must be minimised
                       (the remaining ones are maximised).
    """
    # Convert the task so that “larger is better” for *all* objectives
    _pts = points.copy()
    for d in minimisation_dims:
        _pts[:, d] = -_pts[:, d]

    is_efficient = np.ones(_pts.shape[0], dtype=bool)
    for i, p in enumerate(_pts):
        if is_efficient[i]:
            is_efficient[is_efficient] = np.any(_pts[is_efficient] > p, axis=1)  # keep any strictly better
            is_efficient[i] = True  # and keep self
    return np.where(is_efficient)[0]


def load_json(path):
    with open(path, "r") as fd:
        return json.load(fd)


def load_generation_logs(problem_dir: Path):
    """
    Returns a list (indexed by generation) with the parsed Generation JSON
    as dictionaries.  Missing generations (never happened) produce 'None'.
    """
    log_path = problem_dir / "generation_log.jsonl"
    if not log_path.exists():
        return []

    generations = []
    with jsonlines.Reader(open(log_path, "r")) as reader:
        for line in reader:
            g = line["generation"]
            # pad if necessary
            while len(generations) <= g:
                generations.append(None)
            generations[g] = line
    return generations


# ---------------------------------------------------------------------------
# Drawing helpers
# ---------------------------------------------------------------------------
def plot_pareto_evolution(problem_out_dir: Path,
                          generations,
                          ref_ppa,
                          combinational):
    """
    Two plots:

      pareto_<problem>.png       : only Pareto-fronts per generation
      pareto_cloud_<problem>.png : complete cloud + best
    """
    if combinational:
        dims = ["power", "area"]            # minimise both
        label_xyz = ("Power (W)", "Area (µm²)")
    else:
        dims = ["power", "area", "eff_clk_period"]
        label_xyz = ("Power (W)", "Area (µm²)", "Eff-clk-period (ns)")

    # collect all generations as ndarray list
    all_points = []
    best_points = []
    for gen in generations:
        if gen is None or not gen["population_ppa_details"]:
            all_points.append(None)
            best_points.append(None)
            continue
        rows = []
        for cand in gen["population_ppa_details"]:
            p = cand["ppa_metrics"]
            rows.append([p[d] for d in dims])
        pts = np.asarray(rows, float)
        all_points.append(pts)

        # best point = the one having min(normalised score) already in log
        best_points.append([pts[np.argmin(cand["score"])]] if pts.size else None)

    cmap = cm.get_cmap("viridis", max(1, len(generations)))
    gen_ids = [g for g in range(len(generations)) if generations[g] is not None]

    # Debug
    # print(f"All points collected: {len(all_points)} generations")
    # print(f"All points: {all_points}")
    # print(f"Best points: {best_points}")

    # 1) Pareto only
    fig = plt.figure(figsize=(8, 6))
    ax = fig.add_subplot(111, projection=None if combinational else '3d')
    for g in gen_ids:
        pts = all_points[g]
        if pts is None or len(pts) == 0:
            continue
        pareto_idx = pareto_front(pts, minimisation_dims=range(pts.shape[1]))
        front = pts[pareto_idx]
        c = cmap(g / max(gen_ids))
        if combinational:
            ax.plot(front[:, 0], front[:, 1], marker='o', linestyle='-', color=c,
                    label=f"G{g}")
        else:
            ax.plot(front[:, 0], front[:, 1], front[:, 2],
                    marker='o', linestyle='-', color=c, label=f"G{g}")
    # reference star
    ref_vals = [ref_ppa[d] for d in dims]
    if combinational:
        ax.scatter(*ref_vals, marker='*', s=200, c='black', label='Ref')
        ax.set_xlabel(label_xyz[0]); ax.set_ylabel(label_xyz[1])
    else:
        ax.scatter(*ref_vals, marker='*', s=200, c='black', label='Ref')
        ax.set_xlabel(label_xyz[0]); ax.set_ylabel(label_xyz[1]); ax.set_zlabel(label_xyz[2])
    ax.set_title("Pareto fronts by generation")
    ax.legend(fontsize='small', ncol=3)
    fig.tight_layout()
    fig.savefig(problem_out_dir / "pareto.png", dpi=300)
    plt.close(fig)

    # 1-1) Cloud + best
    fig = plt.figure(figsize=(8, 6))
    ax = fig.add_subplot(111, projection=None if combinational else '3d')
    for g in gen_ids:
        pts = all_points[g]
        if pts is None:     # skip
            continue
        c = cmap(g / max(gen_ids))
        if combinational:
            ax.scatter(pts[:, 0], pts[:, 1], color=c, alpha=0.3, s=8)
        else:
            ax.scatter(pts[:, 0], pts[:, 1], pts[:, 2], color=c, alpha=0.3, s=8)

        # best dot (lowest score) – use information stored in generation
        gen = generations[g]
        best_m = gen["generation_ppa"]["best_metrics"]
        if best_m:
            bp = np.asarray([best_m[d] for d in dims])
            if combinational:
                ax.scatter(bp[0], bp[1], color=c, edgecolor='k', marker='o', s=60)
            else:
                ax.scatter(bp[0], bp[1], bp[2], color=c, edgecolor='k', marker='o', s=60)

    if combinational:
        ax.scatter(*ref_vals, marker='*', s=200, c='black', label='Ref')
        ax.set_xlabel(label_xyz[0]); ax.set_ylabel(label_xyz[1])
    else:
        ax.scatter(*ref_vals, marker='*', s=200, c='black', label='Ref')
        ax.set_xlabel(label_xyz[0]); ax.set_ylabel(label_xyz[1]); ax.set_zlabel(label_xyz[2])
    ax.set_title("Population cloud by generation")
    fig.tight_layout()
    fig.savefig(problem_out_dir / "pareto_cloud.png", dpi=300)
    plt.close(fig)


def plot_strategy_probabilities(problem_out_dir: Path, generations):
    """
    Two stacked-area plots (success / fail pools) – one figure each.
    """
    # collect pool->strategy->[gen] probability
    pools = {"success_pool": defaultdict(list), "fail_pool": defaultdict(list)}
    for gen in generations:
        for pool in pools:
            if gen is None:
                for s in pools[pool]:
                    pools[pool][s].append(0.0)
                continue
            probs = gen.get("average_strategy_probabilities", {})
            if isinstance(probs.get(pool, None), dict):
                this = probs[pool]
            else:
                # old format or pool absent
                this = {}
            # normalise keys
            all_keys = set(this).union(pools[pool].keys())
            for k in all_keys:
                pools[pool][k].append(this.get(k, 0.0))

    for pool_name, data in pools.items():
        if not data:
            continue
        df = pd.DataFrame(data)
        df.index.name = "Generation"
        fig, ax = plt.subplots(figsize=(10, 4))
        df.plot.area(ax=ax, colormap='tab20')
        ax.set_ylim(0, 1)
        ax.set_title(f"{pool_name.replace('_', ' ').title()} – strategy probabilities")
        ax.set_xlabel("Generation")
        ax.set_ylabel("Probability")
        fig.tight_layout()
        fig.savefig(problem_out_dir / f"strategy_prob_{pool_name}.png", dpi=300)
        plt.close(fig)


def plot_best_score(problem_out_dir: Path, generations):
    """
    Line plot of best_score per generation.
    """
    best = [gen["generation_ppa"]["best_score"] if gen else None
            for gen in generations]
    
    # This list will be empty if no generation had a valid score.
    valid_points = [(i, v) for i, v in enumerate(best) if v is not None]


    # If there are no valid scores at all, skip creating the plot.
    if not valid_points:
        return



    xs, ys = zip(*valid_points)

    plt.figure(figsize=(8, 4))
    plt.plot(xs, ys, marker='o')
    plt.axhline(0, color='k', linewidth=0.8)
    plt.title("Best score per generation")
    plt.xlabel("Generation")
    plt.ylabel("Best score (higher is better)")
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    plt.savefig(problem_out_dir / "best_score.png", dpi=300)
    plt.close()

def plot_best_score_monotonous(problem_out_dir: Path, generations):

    """

    Line plot of best_score per generation, ensuring monotonicity.

    If the score for a generation drops, the previous best is kept.

    Also plots the score distribution for each generation and marks the

    actual best score for that generation.

    """

    if not any(generations):

        return



    # --- Data Collection ---

    generation_indices = []

    monotonous_scores = []

    actual_best_scores = []

    score_distributions = []



    last_best_score = -np.inf  # Initialize with a very small number



    for i, gen in enumerate(generations):

        # Skip generation if it's missing or has no population data

        if gen is None or not gen.get("population_ppa_details"):

            # If we have previous scores, carry the last best score forward for the monotonic line

            if monotonous_scores:

                generation_indices.append(i)

                monotonous_scores.append(last_best_score)

                actual_best_scores.append(None)

                score_distributions.append([])

            continue



        # Extract all scores for the distribution plot

        scores = [p["score"] for p in gen["population_ppa_details"]]

        if not scores:

            if monotonous_scores:

                generation_indices.append(i)

                monotonous_scores.append(last_best_score)

                actual_best_scores.append(None)

                score_distributions.append([])

            continue
        # Get the actual best score for the current generation
        actual_best = gen["generation_ppa"]["best_score"]
        # Proceed only if there's a valid score for the generation
        if actual_best is not None:
            generation_indices.append(i)
            score_distributions.append(scores)
            actual_best_scores.append(actual_best)
            # Update and store the monotonic best score

            current_best = max(actual_best, last_best_score)

            monotonous_scores.append(current_best)

            last_best_score = current_best


    # If after checking all generations, no valid scores were found,

    # there's nothing to plot.

    if not generation_indices:

        return


    # --- Plotting ---

    fig, ax = plt.subplots(figsize=(12, 7))



    # Plot the score distributions as a background element

    # Use a placeholder scatter for the legend entry

    ax.scatter([], [], alpha=0.2, color='coral', label='Score Distribution')

    for i, gen_idx in enumerate(generation_indices):

        scores_dist = score_distributions[i]

        if scores_dist:

            # Add a small amount of horizontal jitter for better visibility

            jitter = np.random.normal(0, 0.05, size=len(scores_dist))

            ax.scatter(gen_idx + jitter, scores_dist, alpha=0.2, s=20, color='coral')



    # Plot the monotonically increasing best score line

    ax.plot(generation_indices, monotonous_scores, marker='o', markersize=5,

            linestyle='-', color='firebrick', label='Monotonic Best Score')



    # Mark the actual best score for each generation to show fluctuations

    valid_indices = [idx for idx, score in zip(generation_indices, actual_best_scores) if score is not None]

    valid_scores = [score for score in actual_best_scores if score is not None]

    ax.scatter(valid_indices, valid_scores, marker='x', color='darkblue', s=60,

               zorder=5, label='Actual Best Score of Generation')



    ax.axhline(0, color='k', linewidth=0.8, linestyle='--')

    ax.set_title("Monotonic Best Score and Score Distribution per Generation")

    ax.set_xlabel("Generation")

    ax.set_ylabel("Score (higher is better)")

    ax.set_ylim(-1.1, 1.1)  # Set Y-axis limits based on expected score range

    ax.legend()

    ax.grid(True, which='both', linestyle='--', linewidth=0.5, alpha=0.5)

    fig.tight_layout()

    fig.savefig(problem_out_dir / "best_score_monotonous.png", dpi=300)

    plt.close(fig)


def accumulate_strategy_avgs(per_problem_generations):
    """
    Build per-benchmark average of strategy probabilities across all problems.
    For a given generation/strategy the average excludes zeros
    ( “missing” is ignored so we do not skew towards 0 ).
    """
    aggr = {"success_pool": defaultdict(list), "fail_pool": defaultdict(list)}
    max_gen = max(len(g) for g in per_problem_generations)
    for gen_idx in range(max_gen):
        # collect dict(strategy -> list[prob])  for every pool
        pool_tmp = {"success_pool": defaultdict(list), "fail_pool": defaultdict(list)}
        for gens in per_problem_generations:
            if gen_idx >= len(gens) or gens[gen_idx] is None:
                continue
            probs = gens[gen_idx].get("average_strategy_probabilities", {})
            for pool in pool_tmp.keys():
                p_dict = probs.get(pool, {}) if isinstance(probs.get(pool, {}), dict) else {}
                for s, v in p_dict.items():
                    if v != 0:
                        pool_tmp[pool][s].append(v)
        # now compute mean
        for pool in pool_tmp:
            for s in pool_tmp[pool]:
                mean_val = np.mean(pool_tmp[pool][s])
                aggr[pool].setdefault(s, []).append((gen_idx, mean_val))
    return aggr


def plot_benchmark_strategy_average(out_dir: Path, aggr, pool_name):
    """
    From aggr dict build dataframe & stacked area
    """
    if not aggr[pool_name]:
        return
    # build frame of shape (gens x strategies) filled with NAN then fillna(0)
    rows = defaultdict(dict)
    for s, lst in aggr[pool_name].items():
        for gen_idx, val in lst:
            rows[gen_idx][s] = val
    df = pd.DataFrame.from_dict(rows, orient='index').sort_index().fillna(0.0)
    fig, ax = plt.subplots(figsize=(10, 4))
    df.plot.area(ax=ax, colormap='tab20')
    ax.set_ylim(0, 1)
    ax.set_xlabel("Generation")
    ax.set_ylabel("Average probability")
    ax.set_title(f"Benchmark-wide {pool_name.replace('_', ' ')} strategy probability")
    fig.tight_layout()
    fig.savefig(out_dir / f"avg_strategy_prob_{pool_name}.png", dpi=300)
    plt.close(fig)


# ---------------------------------------------------------------------------
# Main work-flow
# ---------------------------------------------------------------------------
def handle_problem(problem_dir: Path, problem_out_dir: Path):
    summary_path = next(problem_dir.glob("*_summary.json"), None)
    if summary_path is None:
        print(f"   ⚠️  no summary for {problem_dir}")
        return None

    summary = load_json(summary_path)
    generations = load_generation_logs(problem_dir)

    # Check for valid reference PPA data before proceeding.

    # This prevents crashes if the reference data is missing or empty.

    ref_ppa = summary.get(ROOT_KEY_REF)

    if not ref_ppa:  # This will be true for None or an empty dictionary {}

        print(f"   ⚠️  Skipping {problem_dir.name}: `ref_ppa_metric` is missing or empty in summary.json.")

        return None


    mkdir(problem_out_dir)

    combinational = is_combational(summary[ROOT_KEY_REF])

    # 1 & 1-1
    plot_pareto_evolution(problem_out_dir,
                          generations,
                          summary[ROOT_KEY_REF],
                          combinational)

    # 2
    plot_strategy_probabilities(problem_out_dir, generations)

    # 3
    plot_best_score(problem_out_dir, generations)
    
    # 3a
    plot_best_score_monotonous(problem_out_dir, generations)

    return generations   # needed later for benchmark-wide average


def main(exp_root: Path):
    if not exp_root.exists():
        raise FileNotFoundError(exp_root)

    out_root = exp_root.parent / f"{exp_root.name}{C_FIG}"
    mkdir(out_root)

    benchmark_generations = defaultdict(list)   # bench -> list[list[generation]]
    for benchmark_dir in sorted(exp_root.glob("*")):
        if not benchmark_dir.is_dir():
            continue
        bench_out = mkdir(out_root / benchmark_dir.name)
        print(f"Benchmark: {benchmark_dir.name}")

        for problem_dir in tqdm(sorted(benchmark_dir.glob("*"))):
            if not problem_dir.is_dir():
                continue
            p_out = mkdir(bench_out / problem_dir.name)
            gens = handle_problem(problem_dir, p_out)
            if gens is not None:
                benchmark_generations[benchmark_dir.name].append(gens)

        # after all problems of one benchmark  : benchmark-wide plots
        if benchmark_generations[benchmark_dir.name]:
            aggr = accumulate_strategy_avgs(benchmark_generations[benchmark_dir.name])
            for pool in ("success_pool", "fail_pool"):
                plot_benchmark_strategy_average(bench_out, aggr, pool)

    print(f"\n✅  All figures written under  {out_root}")


# ---------------------------------------------------------------------------
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Generate evolution figures.")
    parser.add_argument("run_dir", type=str,
                        help="path to <model_name_run_name> directory")
    args = parser.parse_args()
    main(Path(args.run_dir).resolve())
