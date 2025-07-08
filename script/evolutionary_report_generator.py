import argparse
import json
import pathlib
import re
from collections import defaultdict
import numpy as np

def parse_run_arguments(model_path: pathlib.Path) -> dict:
    """Parses the _run_log.txt file to extract the script arguments."""
    log_file = model_path / f"{model_path.name}_run_log.txt"
    if not log_file.exists():
        return {"Error": "Run log file not found."}
    try:
        with open(log_file, 'r', encoding='utf-8') as f:
            content = f.read()
        # Find the line with "Arguments:" and extract the dictionary string
        match = re.search(r"Arguments: ({.*})", content)
        if match:
            # The extracted string might be a literal representation, use ast.literal_eval
            import ast
            return ast.literal_eval(match.group(1))
    except (IOError, SyntaxError) as e:
        return {"Error": f"Failed to parse run log: {e}"}
    return {"Info": "No arguments dictionary found in run log."}

def format_ppa_metrics(metrics: dict) -> str:
    """Formats PPA metrics dictionary into a readable string."""
    if not metrics:
        return "N/A"
    keys = ['area', 'power', 'eff_clk_period', 'wns', 'tns']
    return ", ".join(f"{key.capitalize()}: {metrics.get(key, 'N/A')}" for key in keys)

def format_percentage_improvement(new_val, ref_val):
    """Calculates and formats the percentage improvement with emojis."""
    if ref_val is None or new_val is None or ref_val == 0:
        return "N/A"
    improvement = ((ref_val - new_val) / ref_val) * 100
    emoji = "🔼" if improvement > 0 else "🔽" if improvement < 0 else "⏺️"
    return f"{improvement:+.2f}% {emoji}"

def generate_overall_report(model_path: pathlib.Path, all_stats: dict, run_args: dict, save_markdown: bool):
    """Generates and prints a summary report for the entire run across all benchmarks."""
    
    # --- Build Console and Markdown Content ---
    report_content = [
        f"# 🚀 Evolutionary Framework Run Report: {model_path.name}\n",
        "## 📝 Run Configuration",
        "```json",
        json.dumps(run_args, indent=4),
        "```\n",
        "## 📊 Overall Benchmark Summary"
    ]
    
    headers = [
        "Benchmark", "Problems", "Avg. Initial Func Pass", "Avg. Final Func Pass", "PPA Improved Problems", "Avg. PPA Improv."
    ]
    report_content.append("| " + " | ".join(headers) + " |")
    report_content.append("|" + ":---|" * len(headers))
    
    # --- Overall Aggregation ---
    grand_total_problems = 0
    grand_total_initial_func_pass = []
    grand_total_final_func_pass = []
    grand_total_ppa_improvements = []
    grand_total_ppa_improved_count = 0

    for name, stats in all_stats.items():
        total = stats['total_problems']
        if total == 0:
            continue
        
        avg_initial_func = np.mean(stats['initial_rates']['func']) * 100
        avg_final_func = np.mean(stats['final_rates']['func']) * 100
        
        # Filter out 'N/A' before calculating mean
        valid_ppa_improv = [p for p in stats['ppa_improvements']['avg'] if isinstance(p, float)]
        avg_ppa_improv = np.mean(valid_ppa_improv) if valid_ppa_improv else 'N/A'
        
        ppa_improved_count = stats['ppa_improved_count']
        
        # For overall average calculation
        grand_total_problems += total
        grand_total_initial_func_pass.extend(stats['initial_rates']['func'])
        grand_total_final_func_pass.extend(stats['final_rates']['func'])
        grand_total_ppa_improvements.extend(valid_ppa_improv)
        grand_total_ppa_improved_count += ppa_improved_count

        row = [
            name,
            str(total),
            f"{avg_initial_func:.2f}%",
            f"{avg_final_func:.2f}%",
            f"{ppa_improved_count}/{total}",
            f"{avg_ppa_improv:.2f}%" if isinstance(avg_ppa_improv, float) else "N/A"
        ]
        report_content.append("| " + " | ".join(row) + " |")

    # --- Add Grand Total Row ---
    overall_avg_initial_func = np.mean(grand_total_initial_func_pass) * 100
    overall_avg_final_func = np.mean(grand_total_final_func_pass) * 100
    overall_avg_ppa_improv = np.mean(grand_total_ppa_improvements) if grand_total_ppa_improvements else 'N/A'

    total_row = [
        "**OVERALL**",
        f"**{grand_total_problems}**",
        f"**{overall_avg_initial_func:.2f}%**",
        f"**{overall_avg_final_func:.2f}%**",
        f"**{grand_total_ppa_improved_count}/{grand_total_problems}**",
        f"**{overall_avg_ppa_improv:.2f}%**" if isinstance(overall_avg_ppa_improv, float) else "**N/A**"
    ]
    report_content.append("| " + " | ".join(total_row) + " |")
    
    # --- Finalize and Output ---
    final_report_str = "\n".join(report_content)
    print("\n" + "="*80)
    print("🚀 OVERALL RUN SUMMARY")
    print("="*80)
    print(final_report_str)

    if save_markdown:
        output_file_path = model_path / "OVERALL_EVOLUTIONARY_REPORT.md"
        try:
            with open(output_file_path, 'w', encoding='utf-8') as f:
                f.write(final_report_str)
            print(f"\n📄 Overall Markdown report saved to: {output_file_path}")
        except IOError as e:
            print(f"\n❌ Error saving overall markdown file: {e}")


def generate_benchmark_report(model_path: pathlib.Path, benchmark_name: str, stats: dict, save_markdown: bool):
    """Generates a detailed report for a single benchmark."""
    total = stats['total_problems']
    if total == 0:
        print(f"\nNo valid problems found for benchmark: {benchmark_name}")
        return

    # --- Calculate Final Metrics ---
    avg_initial_syntax = np.mean(stats['initial_rates']['syntax']) * 100
    avg_final_syntax = np.mean(stats['final_rates']['syntax']) * 100
    avg_initial_func = np.mean(stats['initial_rates']['func']) * 100
    avg_final_func = np.mean(stats['final_rates']['func']) * 100
    avg_initial_synth = np.mean(stats['initial_rates']['synth']) * 100
    avg_final_synth = np.mean(stats['final_rates']['synth']) * 100
    
    valid_ppa_improv = [p for p in stats['ppa_improvements']['avg'] if isinstance(p, float)]
    avg_ppa_improvement = np.mean(valid_ppa_improv) if valid_ppa_improv else 'N/A'

    # --- Build Markdown Content ---
    md_content = [
        f"# 📊 BENCHMARK EVOLUTION REPORT: {benchmark_name}\n",
        "## 📈 Overall Summary",
        f"- **Total Problems Analyzed:** {total}",
        f"- **Average Runtime per Problem:** {np.mean(stats['runtimes']):.2f}s",
        f"- **Average LLM API Calls per Problem:** {np.mean(stats['api_calls']):.1f}\n",

        "### Pass Rate Improvement (Initial vs. Final)",
        "| Metric        | Initial (Gen 0) | Final          | Change         |",
        "|:--------------|:----------------|:---------------|:---------------|",
        f"| **Syntax** | {avg_initial_syntax:.2f}%         | {avg_final_syntax:.2f}%        | **{avg_final_syntax - avg_initial_syntax:+.2f}%** |",
        f"| **Functionality** | {avg_initial_func:.2f}%         | {avg_final_func:.2f}%        | **{avg_final_func - avg_initial_func:+.2f}%** |",
        f"| **Synthesis** | {avg_initial_synth:.2f}%         | {avg_final_synth:.2f}%        | **{avg_final_synth - avg_initial_synth:+.2f}%** |\n",

        "### PPA Optimization Summary",
        f"- **Problems with PPA Improvement:** {stats['ppa_improved_count']} / {total}",
        f"- **Average PPA Metric Improvement:** {avg_ppa_improvement:.2f}%" if isinstance(avg_ppa_improvement, float) else "N/A",
    ]

    # --- Strategy Analysis Section ---
    md_content.extend([
        "\n## 🧬 Strategy Analysis",
        "Shows how often each strategy was used and its success rate.",
        "| Strategy | Times Used | Success Count | Success Rate |",
        "|:---------|:-----------|:--------------|:-------------|"
    ])
    total_counts = sum(stats['strategy_counts'].values())
    for strategy, count in sorted(stats['strategy_counts'].items(), key=lambda x: x[1], reverse=True):
        rewards = stats['strategy_rewards'].get(strategy, 0)
        success_rate = (rewards / count * 100) if count > 0 else 0
        md_content.append(f"| `{strategy}` | {count} ({count/total_counts:.1%}) | {rewards} | {success_rate:.1f}% |")
    
    # --- Detailed Problem Results Table ---
    md_content.extend([
        "\n## 📋 Detailed Problem Results",
    ])
    
    headers = ["Problem", "Initial Pass (S/F/P)", "Final Pass (S/F/P)", "Best PPA Improv. (A/P/T)", "Runtime (s)", "API Calls"]
    md_content.append("| " + " | ".join(headers) + " |")
    md_content.append("|" + ":---|" * len(headers))

    for res in sorted(stats['problem_results'], key=lambda x: x['Problem']):
        row = [
            res['Problem'],
            res['Initial Pass Rate'],
            res['Final Pass Rate'],
            res['PPA Improvement'],
            f"{res['Runtime']:.2f}",
            str(res['API Calls'])
        ]
        md_content.append("| " + " | ".join(row) + " |")

    # --- Finalize and Output ---
    report_str = "\n".join(md_content)
    print("\n" + "="*80)
    print(f"📊 BENCHMARK REPORT: {benchmark_name}")
    print("="*80)
    # Abridged console output for brevity
    print("\n".join(md_content[:12])) # Print summary table
    print(f"\n... (Full details in Markdown file) ...")


    if save_markdown:
        output_file_path = model_path / f"{benchmark_name}_evolutionary_report.md"
        try:
            with open(output_file_path, 'w', encoding='utf-8') as f:
                f.write(report_str)
            print(f"\n📄 Markdown report saved to: {output_file_path}")
        except IOError as e:
            print(f"\n❌ Error saving markdown file: {e}")
    
    return stats

def analyze_experiments(experiment_path: pathlib.Path, save_markdown: bool):
    """
    Parses all experiment summary files, prints reports, and optionally saves them.
    """
    if not experiment_path.is_dir():
        print(f"❌ Error: Path not found -> {experiment_path}")
        return

    # --- Get Run Arguments ---
    run_args = parse_run_arguments(experiment_path)

    # --- Data Structure for Aggregation ---
    benchmark_data = defaultdict(lambda: {
        'total_problems': 0, 'ppa_improved_count': 0,
        'initial_rates': {'syntax': [], 'func': [], 'synth': []},
        'final_rates': {'syntax': [], 'func': [], 'synth': []},
        'ppa_improvements': {'area': [], 'power': [], 'period': [], 'avg': []},
        'runtimes': [], 'api_calls': [], 'problem_results': [],
        'strategy_counts': defaultdict(int), 'strategy_rewards': defaultdict(int)
    })

    summary_files = sorted(experiment_path.glob('*/*/*_summary.json'))
    if not summary_files:
        print(f"⚠️ No `_summary.json` files found in the specified directory structure.")
        return

    # --- Data Aggregation Loop ---
    for file_path in summary_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            problem_name = data['problem_name']
            benchmark_name = data['benchmark_name']
            stats = benchmark_data[benchmark_name]

            # --- Extract Final Metrics ---
            final_rates = data.get('accumulated_success_rates', {})
            stats['final_rates']['syntax'].append(final_rates.get('syntax', 0.0))
            stats['final_rates']['func'].append(final_rates.get('functionality', 0.0))
            stats['final_rates']['synth'].append(final_rates.get('synthesis_ppa', 0.0))
            
            stats['runtimes'].append(data.get('total_runtime_seconds', 0))
            stats['api_calls'].append(data.get('total_llm_api_calls', 0))

            # --- Extract Initial Metrics from generation_log.jsonl ---
            gen_log_path = file_path.parent / "generation_log.jsonl"
            initial_rates = {'syntax': 0.0, 'functionality': 0.0, 'synthesis_ppa': 0.0}
            if gen_log_path.exists():
                with open(gen_log_path, 'r', encoding='utf-8') as log_f:
                    first_gen_data = json.loads(log_f.readline()) # Read first line for Gen 0
                    if first_gen_data.get('generation') == 0:
                        initial_rates = first_gen_data.get('success_rates', initial_rates)
            
            stats['initial_rates']['syntax'].append(initial_rates.get('total_syntax', 0.0))
            stats['initial_rates']['func'].append(initial_rates.get('total_functionality', 0.0))
            stats['initial_rates']['synth'].append(initial_rates.get('total_synthesis_ppa', 0.0))
            
            # --- PPA Improvement Calculation ---
            ref_ppa = data.get('ref_ppa_metric', {})
            best_ppa = data.get('final_population_ppa', {}).get('best_metrics', {})
            
            area_improv = format_percentage_improvement(best_ppa.get('area'), ref_ppa.get('area'))
            power_improv = format_percentage_improvement(best_ppa.get('power'), ref_ppa.get('power'))
            period_improv = format_percentage_improvement(best_ppa.get('eff_clk_period'), ref_ppa.get('eff_clk_period'))
            
            problem_ppa_improvements = []
            if isinstance(best_ppa.get('area'), (int, float)):
                stats['ppa_improvements']['area'].append(float(area_improv.split('%')[0]))
                problem_ppa_improvements.append(float(area_improv.split('%')[0]))
            if isinstance(best_ppa.get('power'), (int, float)):
                stats['ppa_improvements']['power'].append(float(power_improv.split('%')[0]))
                problem_ppa_improvements.append(float(power_improv.split('%')[0]))
            if isinstance(best_ppa.get('eff_clk_period'), (int, float)):
                stats['ppa_improvements']['period'].append(float(period_improv.split('%')[0]))
                problem_ppa_improvements.append(float(period_improv.split('%')[0]))
            
            avg_problem_improv = np.mean(problem_ppa_improvements) if problem_ppa_improvements else 'N/A'
            stats['ppa_improvements']['avg'].append(avg_problem_improv)
            if isinstance(avg_problem_improv, float) and avg_problem_improv > 0:
                stats['ppa_improved_count'] += 1
                
            # --- Strategy Aggregation ---
            for strategy, count in data.get('accumulated_strategy_counts:', {}).items():
                stats['strategy_counts'][strategy] += count
            # Assuming rewards are per-problem. This might need adjustment based on logic.
            # Simplified: counting any reward entry as a success.
            for pool in data.get('accumulated_strategy_rewards', {}).values():
                for strategy in pool.keys():
                    stats['strategy_rewards'][strategy] += 1

            # --- Store Formatted Problem-Level Results ---
            stats['total_problems'] += 1
            stats['problem_results'].append({
                'Problem': problem_name,
                'Initial Pass Rate': f"{initial_rates.get('total_syntax', 0)*100:.0f}/{initial_rates.get('total_functionality', 0)*100:.0f}/{initial_rates.get('total_synthesis_ppa', 0)*100:.0f}%",
                'Final Pass Rate': f"{final_rates.get('syntax', 0)*100:.0f}/{final_rates.get('functionality', 0)*100:.0f}/{final_rates.get('synthesis_ppa', 0)*100:.0f}%",
                'PPA Improvement': f"{area_improv} / {power_improv} / {period_improv}",
                'Runtime': data.get('total_runtime_seconds', 0),
                'API Calls': data.get('total_llm_api_calls', 0)
            })

        except (json.JSONDecodeError, KeyError, IndexError) as e:
            print(f"⚠️ Could not process file {file_path}: {e}")
            continue
            
    # --- Report Generation ---
    all_benchmark_stats = {}
    for benchmark, stats in benchmark_data.items():
        all_benchmark_stats[benchmark] = generate_benchmark_report(experiment_path, benchmark, stats, save_markdown)
    
    # --- Generate the final overall report ---
    if len(all_benchmark_stats) > 0:
        generate_overall_report(experiment_path, all_benchmark_stats, run_args, save_markdown)

    print("\n" + "="*80)
    print("✅ Report generation complete.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Generate a summary report from an evolutionary Verilog framework experiment.",
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        '--experiment_path',
        type=pathlib.Path,
        required=True,
        help="Path to the root directory of a specific model's experiment results.\n"
             "Example: './exp/deepseek-chat/'"
    )
    parser.add_argument(
        '--save_markdown',
        action='store_true',
        help="Save the detailed reports as Markdown files in the experiment path."
    )

    args = parser.parse_args()
    analyze_experiments(args.experiment_path, args.save_markdown)