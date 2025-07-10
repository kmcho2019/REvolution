import os
import json
import argparse
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from pathlib import Path

class Visualizer:
    """
    A class to generate visualizations for the evolutionary coding framework.
    """

    def __init__(self, run_path):
        """
        Initializes the Visualizer with the path to the experiment run.

        Args:
            run_path (str): The path to the model_name_run_name directory.
        """
        self.run_path = Path(run_path)
        if not self.run_path.is_dir():
            raise FileNotFoundError(f"The specified run path does not exist: {run_path}")
        self.output_path = Path(f"{self.run_path.name}_figures")
        self.output_path.mkdir(exist_ok=True)
        self.metrics = ['power', 'area', 'eff_clk_period']

    def run(self):
        """
        Traverses the directory structure and generates all requested plots.
        """
        print(f"🚀 Starting visualization process for {self.run_path.name}")
        print(f"📁 Output will be saved to: {self.output_path}")

        for benchmark_dir in self.run_path.iterdir():
            if not benchmark_dir.is_dir():
                continue

            print(f"\n🔬 Processing benchmark: {benchmark_dir.name}")
            benchmark_output_path = self.output_path / benchmark_dir.name
            benchmark_output_path.mkdir(exist_ok=True)
            
            all_problem_data = {}

            for problem_dir in benchmark_dir.iterdir():
                if not problem_dir.is_dir():
                    continue

                print(f"  - Processing problem: {problem_dir.name}")
                problem_output_path = benchmark_output_path / problem_dir.name
                problem_output_path.mkdir(exist_ok=True)

                try:
                    gen_log_path = problem_dir / 'generation_log.jsonl'
                    summary_path = next(problem_dir.glob('*_summary.json'))
                    
                    problem_data = self._load_problem_data(gen_log_path)
                    summary_data = self._load_summary_data(summary_path)
                    all_problem_data[problem_dir.name] = problem_data


                    # Debug
                    print(f"    Loaded {len(problem_data)} generations from {gen_log_path.name}")
                    print(f"    Summary data keys: {list(summary_data.keys())}")
                    print(f"    Loaded Problem Length: {len(problem_data)}")
                    #print(f"    Loaded Problem Data: {problem_data}")
                    print(f"    Loaded Summary Data: {summary_data}")


                    # Generate plots for each problem
                    self._plot_pareto_evolution(problem_data, summary_data, problem_output_path)
                    self._plot_strategy_probabilities(problem_data, problem_output_path)
                    self._plot_best_score_evolution(problem_data, problem_output_path)
                    
                except (FileNotFoundError, StopIteration) as e:
                    print(f"    [Warning] Skipping problem {problem_dir.name} due to missing files: {e}")
                except Exception as e:
                    print(f"    [Error] An unexpected error occurred while processing {problem_dir.name}: {e}")

            if all_problem_data:
                print(f"\n  📊 Generating benchmark-wide plots for {benchmark_dir.name}")
                self._plot_benchmark_strategy_probabilities(all_problem_data, benchmark_output_path)
        
        print("\n✅ Visualization process completed.")

    def _load_problem_data(self, log_path):
        """Loads and sorts the generation log data from a .jsonl file."""
        with open(log_path, 'r') as f:
            data = [json.loads(line) for line in f]
        return sorted(data, key=lambda x: x['generation'])

    def _load_summary_data(self, summary_path):
        """Loads the summary data from a .json file."""
        with open(summary_path, 'r') as f:
            return json.load(f)

    def _is_pareto_efficient(self, points):
        """
        Finds the Pareto-efficient points.
        A point is Pareto efficient if it is not dominated by any other point.
        We are minimizing all metrics.
        """
        is_efficient = np.ones(points.shape[0], dtype=bool)
        for i, p in enumerate(points):
            if is_efficient[i]:
                is_efficient[is_efficient] = np.any(points[is_efficient] < p, axis=1)
                is_efficient[i] = True
        return is_efficient

    def _plot_pareto_evolution(self, problem_data, summary_data, output_dir):
        """
        Plots the evolution of the Pareto curve for PPA metrics, showing the
        entire population and highlighting the Pareto front.
        """
        ref_ppa = summary_data.get('ref_ppa_metric', {})
        is_combinatorial = ref_ppa.get('wns') == 0.0

        fig = plt.figure(figsize=(12, 10))
        ax = fig.add_subplot(111, projection='3d' if not is_combinatorial else None)
        
        num_generations = len(problem_data)
        colors = plt.cm.viridis(np.linspace(0, 1, num_generations))
        
        for i, gen_data in enumerate(problem_data):
            ppa_details = gen_data.get('population_ppa_details', [])
            if not ppa_details:
                continue

            points = []
            for item in ppa_details:
                metrics = item['ppa_metrics']
                if is_combinatorial:
                    points.append([metrics.get('power'), metrics.get('area')])
                else:
                    points.append([metrics.get('power'), metrics.get('area'), metrics.get('eff_clk_period')])
            
            points = np.array(points)
            if points.size == 0 or any(x is None for x in points.flatten()):
                continue

            # Plot all points in the population with transparency
            if is_combinatorial:
                ax.scatter(points[:, 0], points[:, 1], color=colors[i], s=25, alpha=0.2)
            else:
                ax.scatter(points[:, 0], points[:, 1], points[:, 2], color=colors[i], s=25, alpha=0.2)
            
            # Identify and highlight the Pareto-optimal points
            pareto_mask = self._is_pareto_efficient(points)
            pareto_points = points[pareto_mask]
            
            if is_combinatorial:
                ax.scatter(pareto_points[:, 0], pareto_points[:, 1], color=colors[i], label=f'Gen {i}', s=80, alpha=0.9, edgecolor='w')
            else:
                ax.scatter(pareto_points[:, 0], pareto_points[:, 1], pareto_points[:, 2], color=colors[i], label=f'Gen {i}', s=80, alpha=0.9, edgecolor='w')

        # Plot reference PPA point
        if ref_ppa:
            if is_combinatorial:
                ax.scatter(ref_ppa['power'], ref_ppa['area'], color='red', marker='*', s=300, label='Reference PPA', zorder=5)
                ax.set_xlabel('Power (W)')
                ax.set_ylabel('Area (um^2)')
            else:
                ax.scatter(ref_ppa['power'], ref_ppa['area'], ref_ppa.get('eff_clk_period', 0), color='red', marker='*', s=300, label='Reference PPA', zorder=5)
                ax.set_xlabel('Power (W)')
                ax.set_ylabel('Area (um^2)')
                ax.set_zlabel('Effective Clock Period (ns)')

        ax.set_title('PPA Population and Pareto Front Evolution')
        ax.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
        plt.tight_layout()
        
        filename = output_dir / 'pareto_evolution.png'
        plt.savefig(filename, bbox_inches='tight')
        plt.close()

    def _plot_strategy_probabilities(self, problem_data, output_dir):
        """
        Plots the strategy selection probabilities for success and fail pools.
        """
        generations = [d['generation'] for d in problem_data]
        
        all_success_strategies = set()
        all_fail_strategies = set()
        for d in problem_data:
            success_pool = d.get('average_strategy_probabilities', {}).get('success_pool', {})
            fail_pool = d.get('average_strategy_probabilities', {}).get('fail_pool', {})
            if success_pool: all_success_strategies.update(success_pool.keys())
            if fail_pool: all_fail_strategies.update(fail_pool.keys())

        if all_success_strategies:
            plt.figure(figsize=(12, 7))
            for strategy in sorted(list(all_success_strategies)):
                probs = [d.get('average_strategy_probabilities', {}).get('success_pool', {}).get(strategy) for d in problem_data]
                plt.plot(generations, probs, marker='o', linestyle='-', label=strategy)
            
            plt.title('Success Pool Strategy Probabilities Across Generations')
            plt.xlabel('Generation')
            plt.ylabel('Probability')
            plt.grid(True)
            plt.legend()
            plt.tight_layout()
            plt.savefig(output_dir / 'strategy_prob_success_pool.png')
            plt.close()

        if all_fail_strategies:
            plt.figure(figsize=(12, 7))
            for strategy in sorted(list(all_fail_strategies)):
                probs = [d.get('average_strategy_probabilities', {}).get('fail_pool', {}).get(strategy) for d in problem_data]
                plt.plot(generations, probs, marker='o', linestyle='-', label=strategy)
            
            plt.title('Fail Pool Strategy Probabilities Across Generations')
            plt.xlabel('Generation')
            plt.ylabel('Probability')
            plt.grid(True)
            plt.legend()
            plt.tight_layout()
            plt.savefig(output_dir / 'strategy_prob_fail_pool.png')
            plt.close()

    def _plot_best_score_evolution(self, problem_data, output_dir):
        """
        Plots the best PPA score found so far, ensuring it is monotonically increasing.
        """
        generations = [d['generation'] for d in problem_data]
        best_scores_per_gen = [d.get('generation_ppa', {}).get('best_score') for d in problem_data]
        
        monotonic_best_scores = []
        running_best = -np.inf

        for score in best_scores_per_gen:
            if score is not None and score > running_best:
                running_best = score
            
            current_best_to_plot = running_best if running_best != -np.inf else np.nan
            monotonic_best_scores.append(current_best_to_plot)

        plt.figure(figsize=(10, 6))
        plt.plot(generations, monotonic_best_scores, marker='o', linestyle='-', color='b')
        plt.title('Best PPA Score (Monotonically Improving) Across Generations')
        plt.xlabel('Generation')
        plt.ylabel('Best Score So Far')
        plt.grid(True)
        plt.tight_layout()
        plt.savefig(output_dir / 'best_score_evolution.png')
        plt.close()
        
    def _plot_benchmark_strategy_probabilities(self, all_problem_data, output_dir):
        """
        Plots the averaged strategy probabilities for a benchmark.
        """
        success_df = pd.DataFrame()
        for problem_name, problem_data in all_problem_data.items():
            for gen_data in problem_data:
                probs = gen_data.get('average_strategy_probabilities', {}).get('success_pool', {})
                if probs:
                    row = {'generation': gen_data['generation'], 'problem': problem_name, **probs}
                    success_df = pd.concat([success_df, pd.DataFrame([row])], ignore_index=True)

        if not success_df.empty:
            avg_success_probs = success_df.groupby('generation').mean(numeric_only=True)
            
            plt.figure(figsize=(12, 7))
            for strategy in avg_success_probs.columns:
                if strategy not in ['generation', 'problem']:
                    plt.plot(avg_success_probs.index, avg_success_probs[strategy], marker='o', linestyle='-', label=strategy)
            
            plt.title(f'Benchmark Average Success Pool Strategy Probabilities')
            plt.xlabel('Generation')
            plt.ylabel('Average Probability')
            plt.grid(True)
            plt.legend()
            plt.tight_layout()
            plt.savefig(output_dir / 'benchmark_avg_prob_success_pool.png')
            plt.close()

        fail_df = pd.DataFrame()
        for problem_name, problem_data in all_problem_data.items():
            for gen_data in problem_data:
                probs = gen_data.get('average_strategy_probabilities', {}).get('fail_pool', {})
                if probs:
                    row = {'generation': gen_data['generation'], 'problem': problem_name, **probs}
                    fail_df = pd.concat([fail_df, pd.DataFrame([row])], ignore_index=True)
                    
        if not fail_df.empty:
            avg_fail_probs = fail_df.groupby('generation').mean(numeric_only=True)
            
            plt.figure(figsize=(12, 7))
            for strategy in avg_fail_probs.columns:
                 if strategy not in ['generation', 'problem']:
                    plt.plot(avg_fail_probs.index, avg_fail_probs[strategy], marker='o', linestyle='-', label=strategy)

            plt.title(f'Benchmark Average Fail Pool Strategy Probabilities')
            plt.xlabel('Generation')
            plt.ylabel('Average Probability')
            plt.grid(True)
            plt.legend()
            plt.tight_layout()
            plt.savefig(output_dir / 'benchmark_avg_prob_fail_pool.png')
            plt.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Generate visualizations for RTL code evolution experiments.")
    parser.add_argument("run_path", type=str, help="Path to the model_name_run_name directory.")
    args = parser.parse_args()
    
    visualizer = Visualizer(args.run_path)
    visualizer.run()