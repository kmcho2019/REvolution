import argparse
import json
import pathlib
import re
from collections import defaultdict
import numpy as np

def parse_run_arguments(model_path: pathlib.Path) -> dict:
    """Parses the _run_log.txt file to extract the script arguments."""
    log_file = next(model_path.glob('*_run_log.txt'), None)
    if not log_file:
        return {"Error": "Run log file not found in the root directory."}
    try:
        with open(log_file, 'r', encoding='utf-8') as f:
            content = f.read()
        match = re.search(r"Arguments: ({.*})", content)
        if match:
            import ast
            return ast.literal_eval(match.group(1))
    except (IOError, SyntaxError) as e:
        return {"Error": f"Failed to parse run log: {e}"}
    return {"Info": "No arguments dictionary found in run log."}

def format_ppa_metrics(metrics: dict) -> str:
    """Formats PPA metrics dictionary into a readable string for tables."""
    if not metrics or not isinstance(metrics, dict):
        return "N/A"
    keys = ['area', 'power', 'eff_clk_period']
    return (f"Area: {metrics.get('area', 'N/A'):.2f}, "
            f"Power: {metrics.get('power', 'N/A'):.4f}, "
            f"Period: {metrics.get('eff_clk_period', 'N/A'):.2f}")

def format_percentage_improvement(new_val, ref_val):
    """Calculates and formats the percentage improvement. Lower is better."""
    if ref_val is None or new_val is None or ref_val == 0:
        return "N/A", 0.0
    
    improvement = ((ref_val - new_val) / abs(ref_val)) * 100
    
    if improvement > 0.01:
        emoji = "✅" # Improvement
    elif improvement < -0.01:
        emoji = "❌" # Regression
    else:
        emoji = "➖" # No change

    return f"{improvement:+.2f}% {emoji}", improvement

def generate_overall_report(model_path: pathlib.Path, all_stats: dict, run_args: dict, save_markdown: bool):
    """Generates and prints a summary report for the entire run across all benchmarks."""
    
    grand_total_problems = 0
    grand_total_ppa_improved_count = 0
    grand_total_initial_func_pass = []
    grand_total_final_func_pass = []
    grand_total_ppa_improvements = defaultdict(list)

    for stats in all_stats.values():
        grand_total_problems += stats['total_problems']
        grand_total_ppa_improved_count += stats['ppa_improved_count']
        grand_total_initial_func_pass.extend(stats['initial_rates']['func'])
        grand_total_final_func_pass.extend(stats['final_rates']['func'])
        for key in ['area', 'power', 'period', 'avg']:
            valid_improvements = [p for p in stats['ppa_improvements'][key] if isinstance(p, float)]
            grand_total_ppa_improvements[key].extend(valid_improvements)

    report_content = [
        f"# 🚀 Evolutionary Framework Run Report: {model_path.name}\n",
        "## 📝 Run Configuration",
        "```json",
        json.dumps(run_args, indent=4),
        "```\n",
        "## 📊 Overall Benchmark Summary",
    ]
    
    headers = [
        "Benchmark", "Problems", "Func Pass (Initial → Final)", "PPA Improved", 
        "Avg Area Improv.", "Avg Power Improv.", "Avg Period Improv."
    ]
    report_content.append("| " + " | ".join(headers) + " |")
    report_content.append("|" + ":---|" * len(headers))
    
    for name, stats in all_stats.items():
        total = stats['total_problems']
        if total == 0: continue
        
        avg_initial_func = np.mean(stats['initial_rates']['func']) * 100
        avg_final_func = np.mean(stats['final_rates']['func']) * 100
        
        avg_area_improv = np.mean([p for p in stats['ppa_improvements']['area'] if p is not None])
        avg_power_improv = np.mean([p for p in stats['ppa_improvements']['power'] if p is not None])
        avg_period_improv = np.mean([p for p in stats['ppa_improvements']['period'] if p is not None])

        row = [
            f"**{name}**", str(total), f"{avg_initial_func:.1f}% → {avg_final_func:.1f}%",
            f"{stats['ppa_improved_count']}/{total}",
            f"{avg_area_improv:+.2f}%" if not np.isnan(avg_area_improv) else "N/A",
            f"{avg_power_improv:+.2f}%" if not np.isnan(avg_power_improv) else "N/A",
            f"{avg_period_improv:+.2f}%" if not np.isnan(avg_period_improv) else "N/A",
        ]
        report_content.append("| " + " | ".join(row) + " |")

    if grand_total_problems > 0:
        overall_avg_initial_func = np.mean(grand_total_initial_func_pass) * 100
        overall_avg_final_func = np.mean(grand_total_final_func_pass) * 100
        
        overall_avg_area = np.mean(grand_total_ppa_improvements['area'])
        overall_avg_power = np.mean(grand_total_ppa_improvements['power'])
        overall_avg_period = np.mean(grand_total_ppa_improvements['period'])

        total_row = [
            "**🏁 OVERALL**", f"**{grand_total_problems}**",
            f"**{overall_avg_initial_func:.1f}% → {overall_avg_final_func:.1f}%**",
            f"**{grand_total_ppa_improved_count}/{grand_total_problems}**",
            f"**{overall_avg_area:+.2f}%**" if not np.isnan(overall_avg_area) else "**N/A**",
            f"**{overall_avg_power:+.2f}%**" if not np.isnan(overall_avg_power) else "**N/A**",
            f"**{overall_avg_period:+.2f}%**" if not np.isnan(overall_avg_period) else "**N/A**",
        ]
        report_content.append("| " + " | ".join(total_row) + " |")
    
    final_report_str = "\n".join(report_content)
    print("\n" + "="*100)
    print("🚀 OVERALL RUN SUMMARY")
    print("="*100)
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

    def calc_rate(key):
        return (stats[key] / total) * 100 if total > 0 else 0

    any_pass_syntax = calc_rate('any_pass_syntax_count')
    any_pass_func = calc_rate('any_pass_func_count')
    any_pass_synth = calc_rate('any_pass_synth_count')

    avg_area = np.mean([p for p in stats['ppa_improvements']['area'] if p is not None])
    avg_power = np.mean([p for p in stats['ppa_improvements']['power'] if p is not None])
    avg_period = np.mean([p for p in stats['ppa_improvements']['period'] if p is not None])

    md_content = [
        f"# 🧬 BENCHMARK EVOLUTION REPORT: {benchmark_name}\n",
        "## 📈 Summary",
        f"- **Total Problems Analyzed:** {total}",
        f"- **Average Runtime per Problem:** {np.mean(stats['runtimes']):.2f}s",
        f"- **Average LLM API Calls per Problem:** {np.mean(stats['api_calls']):.1f}\n",

        "### ✅ Pass Rate Analysis",
        "| Metric | Any Passing Gen | Initial Pass@1 | Final Pass@1 | Change |",
        "|:---|:---|:---|:---|:---|",
        f"| **Syntax** | {any_pass_syntax:.1f}% ({stats['any_pass_syntax_count']}/{total}) | {np.mean(stats['initial_rates']['syntax'])*100:.1f}% | {np.mean(stats['final_rates']['syntax'])*100:.1f}% | **{np.mean(stats['final_rates']['syntax'])*100 - np.mean(stats['initial_rates']['syntax'])*100:+.1f}%** |",
        f"| **Functionality** | {any_pass_func:.1f}% ({stats['any_pass_func_count']}/{total}) | {np.mean(stats['initial_rates']['func'])*100:.1f}% | {np.mean(stats['final_rates']['func'])*100:.1f}% | **{np.mean(stats['final_rates']['func'])*100 - np.mean(stats['initial_rates']['func'])*100:+.1f}%** |",
        f"| **Synthesis** | {any_pass_synth:.1f}% ({stats['any_pass_synth_count']}/{total}) | {np.mean(stats['initial_rates']['synth'])*100:.1f}% | {np.mean(stats['final_rates']['synth'])*100:.1f}% | **{np.mean(stats['final_rates']['synth'])*100 - np.mean(stats['initial_rates']['synth'])*100:+.1f}%** |\n",

        "### ⚡ PPA Optimization Summary",
        f"- **Problems with PPA Improvement (Compared to Reference):** {stats['ppa_improved_count']} / {total} ({calc_rate('ppa_improved_count'):.1f}%)",
    ]
    
    # --- Correctly build the PPA summary table ---
    md_content.append("")
    md_content.append("| PPA Metric | Average Improvement |")
    md_content.append("|:-----------|:--------------------|")
    md_content.append(f"| **Area** | {avg_area:+.2f}%" if not np.isnan(avg_area) else "N/A |")
    md_content.append(f"| **Power** | {avg_power:+.2f}%" if not np.isnan(avg_power) else "N/A |")
    md_content.append(f"| **Performance (Period)** | {avg_period:+.2f}%" if not np.isnan(avg_period) else "N/A |")
    
    # --- Strategy Analysis Section ---
    md_content.extend([
        "\n## 🧬 Strategy Analysis",
        "Shows how often each strategy was used and its success rate (rewarded).",
        "| Strategy | Times Used | Success Count | Success Rate |",
        "|:---------|:-----------|:--------------|:-------------|"
    ])
    total_counts = sum(stats['strategy_counts'].values())
    for strategy, count in sorted(stats['strategy_counts'].items(), key=lambda x: x[1], reverse=True):
        rewards = stats['strategy_rewards'].get(strategy, 0)
        success_rate = (rewards / count * 100) if count > 0 else 0
        usage_percent = (count / total_counts * 100) if total_counts > 0 else 0
        md_content.append(f"| `{strategy}` | {count} ({usage_percent:.1f}%) | {rewards} | {success_rate:.1f}% |")

    # --- Detailed Problem Results Table ---
    md_content.extend([
        "\n## 📋 Detailed Problem-by-Problem Analysis",
        "| Problem | Status | Best Score | Reference PPA | Best Evo. PPA | PPA % Improv. (A/P/T) | Runtime (s) | API Calls |",
        "|:---|:---|:---:|:---|:---|:---|:---:|:---:|"
    ])

    for res in sorted(stats['problem_results'], key=lambda x: x['Problem']):
        status_emoji = "✅" if res['Final Pass Rate'] > 0 else "❌"
        row = [
            res['Problem'], f"{status_emoji} (Func: {res['Final Pass Rate']:.0f}%)",
            res['Best Score'], f"`{res['Reference PPA']}`", f"`{res['Best PPA']}`",
            res['PPA Improvement'], f"{res['Runtime']:.1f}", str(res['API Calls'])
        ]
        md_content.append("| " + " | ".join(row) + " |")

    report_str = "\n".join(md_content)
    print("\n" + "="*100)
    print(f"📊 BENCHMARK REPORT: {benchmark_name}")
    print("="*100)
    print(report_str)

    if save_markdown:
        output_file_path = model_path / f"{benchmark_name}_evolutionary_report.md"
        try:
            with open(output_file_path, 'w', encoding='utf-8') as f:
                f.write(report_str)
            print(f"\n📄 Markdown report saved to: {output_file_path}")
        except IOError as e:
            print(f"\n❌ Error saving markdown file for {benchmark_name}: {e}")
    
    return stats

def analyze_experiments(experiment_path: pathlib.Path, save_markdown: bool):
    """Parses all experiment summary files, generates reports, and optionally saves them."""
    if not experiment_path.is_dir():
        print(f"❌ Error: Path not found -> {experiment_path}")
        return

    run_args = parse_run_arguments(experiment_path)

    benchmark_data = defaultdict(lambda: {
        'total_problems': 0, 'ppa_improved_count': 0,
        'any_pass_syntax_count': 0, 'any_pass_func_count': 0, 'any_pass_synth_count': 0,
        'initial_rates': {'syntax': [], 'func': [], 'synth': []},
        'final_rates': {'syntax': [], 'func': [], 'synth': []},
        'ppa_improvements': {'area': [], 'power': [], 'period': [], 'avg': []},
        'runtimes': [], 'api_calls': [], 'problem_results': [],
        'strategy_counts': defaultdict(int), 'strategy_rewards': defaultdict(int)
    })

    summary_files = sorted(experiment_path.glob('*/*/*_summary.json'))
    if not summary_files:
        print(f"⚠️ No `_summary.json` files found: {experiment_path}/*/*/*_summary.json")
        return

    for file_path in summary_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            problem_name = data['problem_name']
            benchmark_name = data['benchmark_name']
            stats = benchmark_data[benchmark_name]

            final_rates = data.get('accumulated_success_rates', {})
            stats['final_rates']['syntax'].append(final_rates.get('syntax', 0.0))
            stats['final_rates']['func'].append(final_rates.get('functionality', 0.0))
            stats['final_rates']['synth'].append(final_rates.get('synthesis_ppa', 0.0))

            if final_rates.get('syntax', 0.0) > 0: stats['any_pass_syntax_count'] += 1
            if final_rates.get('functionality', 0.0) > 0: stats['any_pass_func_count'] += 1
            if final_rates.get('synthesis_ppa', 0.0) > 0: stats['any_pass_synth_count'] += 1

            stats['runtimes'].append(data.get('total_runtime_seconds', 0))
            stats['api_calls'].append(data.get('total_llm_api_calls', 0))

            gen_log_path = file_path.parent / "generation_log.jsonl"
            initial_rates = {'total_syntax': 0.0, 'total_functionality': 0.0, 'total_synthesis_ppa': 0.0}
            if gen_log_path.exists():
                with open(gen_log_path, 'r', encoding='utf-8') as log_f:
                    first_gen_data = json.loads(log_f.readline())
                    if first_gen_data.get('generation') == 0:
                        initial_rates = first_gen_data.get('success_rates', initial_rates)
            
            stats['initial_rates']['syntax'].append(initial_rates.get('total_syntax', 0.0))
            stats['initial_rates']['func'].append(initial_rates.get('total_functionality', 0.0))
            stats['initial_rates']['synth'].append(initial_rates.get('total_synthesis_ppa', 0.0))
            
            ref_ppa = data.get('ref_ppa_metric', {})
            best_ppa = data.get('final_population_ppa', {}).get('best_metrics', {})
            best_score = data.get('final_population_ppa', {}).get('best_score')

            area_improv_str, area_improv_val = format_percentage_improvement(best_ppa.get('area'), ref_ppa.get('area'))
            power_improv_str, power_improv_val = format_percentage_improvement(best_ppa.get('power'), ref_ppa.get('power'))
            period_improv_str, period_improv_val = format_percentage_improvement(best_ppa.get('eff_clk_period'), ref_ppa.get('eff_clk_period'))
            
            problem_ppa_improvements = []
            if 'N/A' not in area_improv_str:
                stats['ppa_improvements']['area'].append(area_improv_val)
                problem_ppa_improvements.append(area_improv_val)
            if 'N/A' not in power_improv_str:
                stats['ppa_improvements']['power'].append(power_improv_val)
                problem_ppa_improvements.append(power_improv_val)
            if 'N/A' not in period_improv_str:
                stats['ppa_improvements']['period'].append(period_improv_val)
                problem_ppa_improvements.append(period_improv_val)
            
            avg_problem_improv = np.mean(problem_ppa_improvements) if problem_ppa_improvements else 'N/A'
            stats['ppa_improvements']['avg'].append(avg_problem_improv)
            if isinstance(avg_problem_improv, float) and avg_problem_improv > 0:
                stats['ppa_improved_count'] += 1
            
            for strategy, count in data.get('accumulated_strategy_counts:', {}).items():
                stats['strategy_counts'][strategy] += count
            for pool in data.get('accumulated_strategy_rewards', {}).values():
                for strategy, reward in pool.items():
                    # Assuming any reward value indicates a "success" for that strategy
                    if reward is not None:
                         stats['strategy_rewards'][strategy] += 1
            
            stats['total_problems'] += 1
            stats['problem_results'].append({
                'Problem': problem_name,
                'Final Pass Rate': final_rates.get('functionality', 0.0) * 100,
                'Best Score': f"{best_score:.4f}" if best_score is not None else "N/A",
                'Reference PPA': format_ppa_metrics(ref_ppa),
                'Best PPA': format_ppa_metrics(best_ppa),
                'PPA Improvement': f"{area_improv_str} / {power_improv_str} / {period_improv_str}",
                'Runtime': data.get('total_runtime_seconds', 0),
                'API Calls': data.get('total_llm_api_calls', 0)
            })

        except (json.JSONDecodeError, KeyError, IndexError, TypeError) as e:
            print(f"⚠️ Could not process file {file_path}: {e} - Skipping.")
            continue
            
    all_benchmark_stats = {}
    for benchmark, stats in sorted(benchmark_data.items()):
        all_benchmark_stats[benchmark] = generate_benchmark_report(experiment_path, benchmark, stats, save_markdown)
    
    if len(all_benchmark_stats) > 0:
        generate_overall_report(experiment_path, all_benchmark_stats, run_args, save_markdown)

    print("\n" + "="*100)
    print("✅ Report generation complete.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Generate a comprehensive summary report from an evolutionary Verilog framework experiment.",
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        '--experiment_path', type=pathlib.Path, required=True,
        help="Path to the root directory of a specific model's experiment results.\n"
             "Example: './exp/deepseek-chat/'"
    )
    parser.add_argument(
        '--save_markdown', action='store_true',
        help="Save the detailed reports as Markdown files in the experiment path."
    )

    args = parser.parse_args()
    analyze_experiments(args.experiment_path, args.save_markdown)