import argparse
import json
import pathlib
from collections import defaultdict

def format_ppa_metrics(metrics: dict) -> str:
    """
    Formats PPA metrics dictionary into a readable string.
    
    Args:
        metrics: A dictionary containing PPA metrics.
        
    Returns:
        A formatted string of key-value pairs.
    """
    if not metrics:
        return "N/A"
    # Order keys for consistent output
    keys = ['area', 'power', 'eff_clk_period', 'wns', 'tns']
    return ", ".join(f"{key.capitalize()}: {metrics.get(key, 'N/A')}" for key in keys)

def generate_markdown_report(benchmark_name: str, stats: dict) -> str:
    """
    Generates the full report content as a Markdown formatted string.

    Args:
        benchmark_name: The name of the benchmark.
        stats: The aggregated statistics for the benchmark.

    Returns:
        A string containing the report in Markdown format.
    """
    total = stats['total_problems']
    if total == 0:
        return f"# 📊 BENCHMARK REPORT: {benchmark_name}\n\nNo valid problems found for this benchmark."

    # --- Calculate Final Metrics ---
    generations_per_problem = stats.get('total_generations_per_problem', 'N/A')
    
    pass_at_1_syntax = (stats['sum_pass_rate_syntax'] / total) * 100
    pass_at_1_func = (stats['sum_pass_rate_func'] / total) * 100
    pass_at_1_synth = (stats['sum_pass_rate_synth'] / total) * 100

    any_pass_rate_syntax = (stats['problems_any_pass_syntax'] / total) * 100
    any_pass_rate_func = (stats['problems_any_pass_func'] / total) * 100
    any_pass_rate_synth = (stats['problems_any_pass_synth'] / total) * 100

    # --- Build Markdown Content ---
    md_content = [
        f"# 📊 BENCHMARK REPORT: {benchmark_name}\n",
        "## 📈 Overall Summary",
        f"- **Total Problems Analyzed:** {total}",
        f"- **Generations per Problem:** {generations_per_problem}\n",
        
        "### Pass@1 Rates (Average success rate across all problems)",
        f"- **Syntax Pass@1 Rate:** {pass_at_1_syntax:.2f}%",
        f"- **Functionality Pass@1 Rate:** {pass_at_1_func:.2f}%",
        f"- **Synthesis Pass@1 Rate:** {pass_at_1_synth:.2f}%\n",

        "### Problems with at Least One Passing Generation",
        f"- **Syntax:** {any_pass_rate_syntax:.2f}% ({stats['problems_any_pass_syntax']}/{total})",
        f"- **Functionality:** {any_pass_rate_func:.2f}% ({stats['problems_any_pass_func']}/{total})",
        f"- **Synthesis:** {any_pass_rate_synth:.2f}% ({stats['problems_any_pass_synth']}/{total})\n",
        
        "## 📋 Detailed Problem Results"
    ]

    # Markdown Table
    headers = ["Problem", "Syntax", "Functionality", "Synthesis", "Best Score", "Best PPA Metrics", "Reference PPA Metrics"]
    md_content.append("| " + " | ".join(headers) + " |")
    md_content.append("|" + ":---|" * len(headers))

    for res in stats['problem_results']:
        row = [
            res['Problem'],
            res['Syntax'],
            res['Functionality'],
            res['Synthesis'],
            res['Best Score'],
            f"`{res['Best PPA Metrics']}`",
            f"`{res['Reference PPA Metrics']}`"
        ]
        md_content.append("| " + " | ".join(row) + " |")

    return "\n".join(md_content)

def generate_report(experiment_path: pathlib.Path, save_markdown: bool = False):
    """
    Parses experiment summary files, prints a report, and optionally saves it.

    Args:
        experiment_path: The root path of the experiment results.
        save_markdown: If True, saves the report as a Markdown file.
    """
    if not experiment_path.is_dir():
        print(f"❌ Error: Path not found -> {experiment_path}")
        return

    # Updated data structure to handle multi-generation stats
    benchmark_data = defaultdict(lambda: {
        'total_problems': 0,
        'total_generations_per_problem': None,
        'problems_any_pass_syntax': 0,
        'problems_any_pass_func': 0,
        'problems_any_pass_synth': 0,
        'sum_pass_rate_syntax': 0.0,
        'sum_pass_rate_func': 0.0,
        'sum_pass_rate_synth': 0.0,
        'problem_results': []
    })

    summary_files = sorted(experiment_path.glob('*/*/*_summary.json'))
    if not summary_files:
        print(f"⚠️ No `_summary.json` files found in the specified directory structure.")
        return

    # --- Data Aggregation ---
    for file_path in summary_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            benchmark_name = data.get('benchmark_name', 'Unknown Benchmark')
            problem_name = data.get('problem_name', 'Unknown Problem')
            stats = benchmark_data[benchmark_name]

            # Get generations per problem and check for consistency
            generations = data.get('total_candidates_generated', 1)
            if stats['total_generations_per_problem'] is None:
                stats['total_generations_per_problem'] = generations
            elif stats['total_generations_per_problem'] != generations:
                print(f"⚠️ Warning: Inconsistent number of generations for benchmark {benchmark_name}. "
                      f"Found {generations} for {problem_name}, expected {stats['total_generations_per_problem']}.")

            rates = data.get('accumulated_success_rates', {})
            syntax_pass_rate = rates.get('syntax', 0.0)
            func_pass_rate = rates.get('functionality', 0.0)
            synth_pass_rate = rates.get('synthesis_ppa', 0.0)

            final_ppa = data.get('final_population_ppa', {})
            best_score = final_ppa.get('best_score')
            ref_ppa = data.get('ref_ppa_metric', {})
            best_ppa = final_ppa.get('best_metrics', {})

            # Update aggregate stats
            stats['total_problems'] += 1
            stats['sum_pass_rate_syntax'] += syntax_pass_rate
            stats['sum_pass_rate_func'] += func_pass_rate
            stats['sum_pass_rate_synth'] += synth_pass_rate

            # Update count of problems with at least one successful generation
            if syntax_pass_rate > 0: stats['problems_any_pass_syntax'] += 1
            if func_pass_rate > 0: stats['problems_any_pass_func'] += 1
            if synth_pass_rate > 0: stats['problems_any_pass_synth'] += 1
            
            # Format detailed results for the table with pass rate percentages
            def format_pass_fail_with_rate(rate: float) -> str:
                if rate > 0:
                    return f"✅ Pass ({rate * 100:.1f}%)"
                return "❌ Fail (0.0%)"

            # Using keys that match the headers to avoid KeyErrors later
            stats['problem_results'].append({
                'Problem': problem_name,
                'Syntax': format_pass_fail_with_rate(syntax_pass_rate),
                'Functionality': format_pass_fail_with_rate(func_pass_rate),
                'Synthesis': format_pass_fail_with_rate(synth_pass_rate),
                'Best Score': f"{best_score:.4f}" if best_score is not None else "N/A",
                'Best PPA Metrics': format_ppa_metrics(best_ppa),
                'Reference PPA Metrics': format_ppa_metrics(ref_ppa)
            })

        except (json.JSONDecodeError, KeyError) as e:
            print(f"⚠️ Could not process file {file_path}: {e}")
            continue

    # --- Report Generation ---
    for benchmark, stats in benchmark_data.items():
        print("\n" + "="*80)
        print(f"📊 BENCHMARK REPORT: {benchmark}")
        print("="*80)

        total = stats['total_problems']
        if total == 0:
            print("No valid problems found for this benchmark.")
            continue

        # --- Calculate Final Metrics ---
        generations_per_problem = stats.get('total_generations_per_problem', 'N/A')
        pass_at_1_syntax = (stats['sum_pass_rate_syntax'] / total) * 100
        pass_at_1_func = (stats['sum_pass_rate_func'] / total) * 100
        pass_at_1_synth = (stats['sum_pass_rate_synth'] / total) * 100
        any_pass_rate_syntax = (stats['problems_any_pass_syntax'] / total) * 100
        any_pass_rate_func = (stats['problems_any_pass_func'] / total) * 100
        any_pass_rate_synth = (stats['problems_any_pass_synth'] / total) * 100

        # --- Print Console Summary ---
        print("\n📈 Overall Summary:")
        print(f"  - Total Problems Analyzed:      {total}")
        print(f"  - Generations per Problem:      {generations_per_problem}\n")
        print("  --- Pass@1 Rates (Average success rate across all problems) ---")
        print(f"  - Syntax Pass@1 Rate:           {pass_at_1_syntax:.2f}%")
        print(f"  - Functionality Pass@1 Rate:    {pass_at_1_func:.2f}%")
        print(f"  - Synthesis Pass@1 Rate:        {pass_at_1_synth:.2f}%\n")
        print("  --- Problems with at Least One Passing Generation ---")
        print(f"  - Syntax:                       {any_pass_rate_syntax:.2f}% ({stats['problems_any_pass_syntax']}/{total})")
        print(f"  - Functionality:                {any_pass_rate_func:.2f}% ({stats['problems_any_pass_func']}/{total})")
        print(f"  - Synthesis:                    {any_pass_rate_synth:.2f}% ({stats['problems_any_pass_synth']}/{total})")

        # --- Print Console Detailed Table ---
        print("\n📋 Detailed Problem Results:")
        headers = ["Problem", "Syntax", "Functionality", "Synthesis", "Best Score", "Best PPA Metrics", "Reference PPA Metrics"]
        
        # Determine column widths dynamically for a clean table layout
        col_widths = {h: len(h) for h in headers}
        for res in stats['problem_results']:
            for key, value in res.items():
                if key in col_widths:
                    col_widths[key] = max(col_widths[key], len(str(value)))
        
        # Print header
        header_line = " | ".join(f"{h:<{col_widths[h]}}" for h in headers)
        print(header_line)
        print("-" * len(header_line))

        # Print rows
        for res in stats['problem_results']:
            row_line = " | ".join(f"{str(res[key]):<{col_widths[key]}}" for key in headers)
            print(row_line)

        # --- Markdown File Saving ---
        if save_markdown:
            markdown_content = generate_markdown_report(benchmark, stats)
            output_file_path = experiment_path / f"{benchmark}_report.md"
            try:
                with open(output_file_path, 'w', encoding='utf-8') as f:
                    f.write(markdown_content)
                print(f"\n📄 Markdown report saved to: {output_file_path}")
            except IOError as e:
                print(f"\n❌ Error saving markdown file: {e}")

    print("\n" + "="*80)
    print("Report generation complete.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Generate a summary report from Verilog benchmark experiment result files.",
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        '--experiment_result_path',
        type=pathlib.Path,
        required=True,
        help="Path to the root directory containing experiment results.\n"
             "The script expects a structure like: .../{benchmark_name}/{problem_name}/{problem_name}_summary.json"
    )
    parser.add_argument(
        '--save_markdown',
        action='store_true',
        help="Save the report as a Markdown file in the experiment result path.\n"
             "Filename will be {benchmark_name}_report.md."
    )

    args = parser.parse_args()
    generate_report(args.experiment_result_path, args.save_markdown)
