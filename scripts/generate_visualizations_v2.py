import os
import json
import argparse
from collections import defaultdict
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import plotly.graph_objects as go
from matplotlib import cm

# --- Helper Functions ---

def find_pareto_front(points, objectives=['power', 'area', 'eff_clk_period']):
    """
    Finds the Pareto front for a set of points, assuming minimization for all objectives.

    Args:
        points (list of dicts): A list of PPA metric dictionaries.
        objectives (list of str): The keys for the objectives to consider.

    Returns:
        pd.DataFrame: A DataFrame containing only the points on the Pareto front.
    """
    df = pd.DataFrame(points)
    if df.empty or not all(obj in df.columns for obj in objectives):
        return pd.DataFrame(columns=objectives)

    df_objectives = df[objectives].astype(float)

    is_pareto = np.ones(df_objectives.shape[0], dtype=bool)
    for i, row in enumerate(df_objectives.values):
        if is_pareto[i]:
            # Check if any other point dominates this one
            # A point is dominated if another point is better or equal on all objectives
            # and strictly better on at least one.
            is_dominated = np.any(np.all(df_objectives.values[is_pareto] <= row, axis=1) & np.any(df_objectives.values[is_pareto] < row, axis=1))
            if is_dominated:
                is_pareto[i] = False

    return df.loc[is_pareto]

# --- Plotting Functions ---

def plot_pareto_evolution(gen_ppa_data, ref_ppa, output_path, is_3d):
    """
    Plots the evolution of the Pareto front across generations.
    """
    if is_3d:
        fig = go.Figure()
        objectives = ['power', 'area', 'eff_clk_period']
        axis_labels = {'x': 'Power (W)', 'y': 'Area (um^2)', 'z': 'Effective Clock Period (ns)'}
    else:
        fig = go.Figure()
        objectives = ['power', 'area']
        axis_labels = {'x': 'Power (W)', 'y': 'Area (um^2)'}

    num_generations = len(gen_ppa_data)
    colorscale = plt.cm.viridis

    for gen_idx, ppa_list in enumerate(gen_ppa_data):
        if not ppa_list:
            continue

        pareto_front_df = find_pareto_front(ppa_list, objectives)
        if pareto_front_df.empty:
            continue

        color = f'rgb{tuple(np.array(colorscale(gen_idx / max(1, num_generations - 1)))[:3] * 255)}'

        plot_args = {
            'x': pareto_front_df['power'],
            'y': pareto_front_df['area'],
            'mode': 'lines+markers',
            'name': f'Gen {gen_idx}',
            'line': {'color': color, 'width': 3},
            'marker': {'color': color, 'size': 8}
        }

        if is_3d:
            plot_args['z'] = pareto_front_df['eff_clk_period']
            fig.add_trace(go.Scatter3d(**plot_args))
        else:
            fig.add_trace(go.Scatter(**plot_args))

    # Add Reference PPA point
    ref_plot_args = {
        'x': [ref_ppa['power']],
        'y': [ref_ppa['area']],
        'mode': 'markers',
        'name': 'Reference PPA',
        'marker': {'color': 'red', 'size': 12, 'symbol': 'star'}
    }
    if is_3d:
        ref_plot_args['z'] = [ref_ppa['eff_clk_period']]
        fig.add_trace(go.Scatter3d(**ref_plot_args))
    else:
        fig.add_trace(go.Scatter(**ref_plot_args))

    title = '3D Pareto Front Evolution' if is_3d else '2D Pareto Front Evolution'
    layout_args = {
        'title': title,
        'scene': {'xaxis_title': axis_labels['x'], 'yaxis_title': axis_labels['y']}
    } if is_3d else {
        'xaxis_title': axis_labels['x'],
        'yaxis_title': axis_labels['y']
    }

    if is_3d:
        layout_args['scene']['zaxis_title'] = axis_labels['z']

    fig.update_layout(**layout_args)
    fig.write_image(f"{output_path}/1_pareto_front_evolution.png", width=1200, height=900)


def plot_population_evolution(gen_ppa_data, gen_best_metrics, ref_ppa, output_path, is_3d):
    """
    Plots the entire population distribution's evolution across generations.
    """
    if is_3d:
        fig = go.Figure()
        objectives = ['power', 'area', 'eff_clk_period']
        axis_labels = {'x': 'Power (W)', 'y': 'Area (um^2)', 'z': 'Effective Clock Period (ns)'}
    else:
        fig = go.Figure()
        objectives = ['power', 'area']
        axis_labels = {'x': 'Power (W)', 'y': 'Area (um^2)'}

    num_generations = len(gen_ppa_data)
    colorscale = plt.cm.plasma

    for gen_idx, ppa_list in enumerate(gen_ppa_data):
        if not ppa_list:
            continue

        df = pd.DataFrame(ppa_list)
        color = f'rgb{tuple(np.array(colorscale(gen_idx / max(1, num_generations - 1)))[:3] * 255)}'

        plot_args = {
            'x': df['power'],
            'y': df['area'],
            'mode': 'markers',
            'name': f'Gen {gen_idx} Population',
            'marker': {'color': color, 'size': 5, 'opacity': 0.6}
        }

        if is_3d:
            plot_args['z'] = df['eff_clk_period']
            fig.add_trace(go.Scatter3d(**plot_args))
        else:
            fig.add_trace(go.Scatter(**plot_args))

    # Plot best points of each generation
    best_df = pd.DataFrame([m for m in gen_best_metrics if m])
    if not best_df.empty:
        best_plot_args = {
            'x': best_df['power'],
            'y': best_df['area'],
            'mode': 'markers',
            'name': 'Generation Best',
            'marker': {'color': 'black', 'size': 8, 'symbol': 'diamond', 'line': {'width': 2, 'color': 'white'}}
        }
        if is_3d and 'eff_clk_period' in best_df.columns:
            best_plot_args['z'] = best_df['eff_clk_period']
            fig.add_trace(go.Scatter3d(**best_plot_args))
        elif not is_3d:
             fig.add_trace(go.Scatter(**best_plot_args))

    # Add Reference PPA point
    ref_plot_args = {
        'x': [ref_ppa['power']],
        'y': [ref_ppa['area']],
        'mode': 'markers',
        'name': 'Reference PPA',
        'marker': {'color': 'red', 'size': 12, 'symbol': 'star'}
    }
    if is_3d:
        ref_plot_args['z'] = [ref_ppa['eff_clk_period']]
        fig.add_trace(go.Scatter3d(**ref_plot_args))
    else:
        fig.add_trace(go.Scatter(**ref_plot_args))

    title = '3D Population Evolution' if is_3d else '2D Population Evolution'
    layout_args = {
        'title': title,
        'legend_title_text': 'Legend'
    }

    if is_3d:
        layout_args['scene'] = {'xaxis_title': axis_labels['x'], 'yaxis_title': axis_labels['y'], 'zaxis_title': axis_labels['z']}
    else:
        layout_args['xaxis_title'] = axis_labels['x']
        layout_args['yaxis_title'] = axis_labels['y']

    fig.update_layout(**layout_args)
    fig.write_image(f"{output_path}/1-1_population_evolution.png", width=1200, height=900)

def plot_strategy_probabilities(prob_data, output_path, title_prefix):
    """
    Plots the evolution of strategy probabilities for a given pool.
    """
    if not prob_data:
        return

    df = pd.DataFrame(prob_data).fillna(0)
    if df.empty:
        return

    plt.style.use('seaborn-v0_8-whitegrid')
    fig, ax = plt.subplots(figsize=(12, 7))

    df.plot(kind='line', ax=ax, marker='o', linestyle='-')

    ax.set_title(f'{title_prefix}: Strategy Probability Evolution')
    ax.set_xlabel('Generation')
    ax.set_ylabel('Probability')
    ax.legend(title='Strategy')
    ax.grid(True, which='both', linestyle='--', linewidth=0.5)
    plt.tight_layout()
    plt.savefig(output_path)
    plt.close(fig)

def plot_best_score_evolution(best_scores, output_path):
    """
    Plots the best PPA score over generations.
    """
    if not best_scores:
        return

    scores = pd.Series(best_scores, name="Best Score").replace({None: np.nan})

    plt.style.use('seaborn-v0_8-whitegrid')
    fig, ax = plt.subplots(figsize=(12, 7))

    scores.plot(kind='line', ax=ax, marker='o', linestyle='-', label='Best Score per Generation')

    ax.set_title('Best PPA Score Across Generations')
    ax.set_xlabel('Generation')
    ax.set_ylabel('Best PPA Score (Higher is Better)')
    ax.legend()
    ax.grid(True, which='both', linestyle='--', linewidth=0.5)
    plt.tight_layout()
    plt.savefig(output_path)
    plt.close(fig)

# --- Main Processing Logic ---

def process_problem(problem_path, problem_output_dir):
    """
    Processes a single problem directory to generate all its plots.
    """
    print(f"  Processing problem: {os.path.basename(problem_path)}")
    log_file = os.path.join(problem_path, 'generation_log.jsonl')
    summary_file = [os.path.join(problem_path, f) for f in os.listdir(problem_path) if f.endswith('_summary.json')]

    if not os.path.exists(log_file) or not summary_file:
        print(f"    - Skipping: Missing log or summary file.")
        return None

    summary_file = summary_file[0]

    with open(summary_file, 'r') as f:
        summary_data = json.load(f)

    ref_ppa = summary_data.get('ref_ppa_metric', {})
    is_3d = ref_ppa.get('wns', -1) != 0.0 and ref_ppa.get('eff_clk_period', -1) != 0.0

    gen_data = []
    with open(log_file, 'r') as f:
        for line in f:
            try:
                gen_data.append(json.loads(line))
            except json.JSONDecodeError:
                continue

    # Sort by generation just in case
    gen_data.sort(key=lambda x: x['generation'])

    # 1. Extract PPA Data
    all_gen_ppa = [gen.get('population_ppa_details', []) for gen in gen_data]
    gen_ppa_metrics = [[item['ppa_metrics'] for item in gen_list if 'ppa_metrics' in item] for gen_list in all_gen_ppa]
    gen_best_metrics = [gen.get('generation_ppa', {}).get('best_metrics', {}) for gen in gen_data]

    # 2. Extract Strategy Probabilities
    gen_success_probs = [gen.get('average_strategy_probabilities', {}).get('success_pool', {}) for gen in gen_data]
    gen_fail_probs = [gen.get('average_strategy_probabilities', {}).get('fail_pool', {}) for gen in gen_data]

    # 3. Extract Best Scores
    gen_best_scores = [gen.get('generation_ppa', {}).get('best_score') for gen in gen_data]

    # Generate Plots for the problem
    plot_pareto_evolution(gen_ppa_metrics, ref_ppa, problem_output_dir, is_3d)
    plot_population_evolution(gen_ppa_metrics, gen_best_metrics, ref_ppa, problem_output_dir, is_3d)
    plot_strategy_probabilities(gen_success_probs, f"{problem_output_dir}/2_success_pool_strategy_probs.png", "Success Pool")
    plot_strategy_probabilities(gen_fail_probs, f"{problem_output_dir}/2_fail_pool_strategy_probs.png", "Fail Pool")
    plot_best_score_evolution(gen_best_scores, f"{problem_output_dir}/3_best_score_evolution.png")

    print(f"    + Plots saved to {problem_output_dir}")

    # Return data for benchmark-wide aggregation
    return {'success_probs': gen_success_probs, 'fail_probs': gen_fail_probs}


def process_benchmark(benchmark_path, benchmark_output_dir):
    """
    Processes a benchmark directory, handling all sub-problems and generating aggregated plots.
    """
    print(f"\nProcessing benchmark: {os.path.basename(benchmark_path)}")

    # Data for benchmark-wide averaging
    benchmark_success_probs = defaultdict(lambda: defaultdict(list))
    benchmark_fail_probs = defaultdict(lambda: defaultdict(list))

    problem_dirs = [d.path for d in os.scandir(benchmark_path) if d.is_dir() and 'Prob' in d.name]

    for problem_path in problem_dirs:
        problem_name = os.path.basename(problem_path)
        problem_output_dir = os.path.join(benchmark_output_dir, problem_name)
        os.makedirs(problem_output_dir, exist_ok=True)

        problem_data = process_problem(problem_path, problem_output_dir)

        if problem_data:
            # Aggregate success probabilities, excluding zeros
            for gen_idx, gen_probs in enumerate(problem_data['success_probs']):
                for strategy, prob in gen_probs.items():
                    if prob > 0:
                        benchmark_success_probs[gen_idx][strategy].append(prob)

            # Aggregate fail probabilities, excluding zeros
            for gen_idx, gen_probs in enumerate(problem_data['fail_probs']):
                for strategy, prob in gen_probs.items():
                    if prob > 0:
                        benchmark_fail_probs[gen_idx][strategy].append(prob)

    # Calculate and plot benchmark-wide averaged probabilities
    # Success Pool
    avg_success_data = []
    for gen_idx in sorted(benchmark_success_probs.keys()):
        avg_gen_probs = {}
        for strategy, probs_list in benchmark_success_probs[gen_idx].items():
            avg_gen_probs[strategy] = np.mean(probs_list)
        avg_success_data.append(avg_gen_probs)

    if avg_success_data:
        plot_strategy_probabilities(avg_success_data, f"{benchmark_output_dir}/4_benchmark_avg_success_probs.png", "Benchmark Average Success Pool")
        print(f"\n+ Benchmark average success probability plot saved to {benchmark_output_dir}")

    # Fail Pool
    avg_fail_data = []
    for gen_idx in sorted(benchmark_fail_probs.keys()):
        avg_gen_probs = {}
        for strategy, probs_list in benchmark_fail_probs[gen_idx].items():
            avg_gen_probs[strategy] = np.mean(probs_list)
        avg_fail_data.append(avg_gen_probs)

    if avg_fail_data:
        plot_strategy_probabilities(avg_fail_data, f"{benchmark_output_dir}/4_benchmark_avg_fail_probs.png", "Benchmark Average Fail Pool")
        print(f"+ Benchmark average fail probability plot saved to {benchmark_output_dir}")


def main():
    """
    Main function to parse arguments and orchestrate the visualization generation.
    """
    parser = argparse.ArgumentParser(description="Generate visualizations for RTL code evolution experiments.")
    parser.add_argument("run_path", type=str, help="Path to the model_name_run_name directory.")
    args = parser.parse_args()

    if not os.path.isdir(args.run_path):
        print(f"Error: Directory not found at '{args.run_path}'")
        return

    # Create the main output directory
    output_root_dir = f"{os.path.basename(args.run_path)}_figures"
    os.makedirs(output_root_dir, exist_ok=True)
    print(f"Output will be saved to: {output_root_dir}")

    benchmark_dirs = [d.path for d in os.scandir(args.run_path) if d.is_dir()]

    for benchmark_path in benchmark_dirs:
        benchmark_name = os.path.basename(benchmark_path)
        benchmark_output_dir = os.path.join(output_root_dir, benchmark_name)
        os.makedirs(benchmark_output_dir, exist_ok=True)
        process_benchmark(benchmark_path, benchmark_output_dir)

if __name__ == '__main__':
    main()
