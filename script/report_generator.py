import argparse
import json
import pathlib
from collections import defaultdict

def format_ppa_metrics(metrics: dict) -> str:
    """Formats PPA metrics dictionary into a readable string."""
    if not metrics:
        return "N/A"
    # Order keys for consistent output
    keys = ['area', 'power', 'eff_clk_period', 'wns', 'tns']
    return ", ".join(f"{key.capitalize()}: {metrics.get(key, 'N/A')}" for key in keys)

def generate_markdown_report(benchmark_name: str, stats: dict) -> str:
    """Generates the full report content as a Markdown formatted string."""
    total = stats['total_problems']
    pass_rate_syntax = (stats['syntax_passes'] / total) * 100
    pass_rate_func = (stats['func_passes'] / total) * 100
    pass_rate_synth = (stats['synth_passes'] / total) * 100

    # Using a list of strings and joining is more efficient
    md_content = [
        f"# 📊 BENCHMARK REPORT: {benchmark_name}\n",
        "## 📈 Overall Summary",
        f"- **Total Problems Analyzed:** {total}",
        f"- **Syntax Pass@1 Rate:** {pass_rate_syntax:.2f}% ({stats['syntax_passes']}/{total})",
        f"- **Functionality Pass@1 Rate:** {pass_rate_func:.2f}% ({stats['func_passes']}/{total})",
        f"- **Synthesis Pass@1 Rate:** {pass_rate_synth:.2f}% ({stats['synth_passes']}/{total})\n",
        "## 📋 Detailed Problem Results"
    ]

    # Markdown Table
    headers = ["Problem", "Syntax", "Functionality", "Synthesis", "Best Score", "Best PPA Metrics", "Reference PPA Metrics"]
    md_content.append("| " + " | ".join(headers) + " |")
    md_content.append("|" + ":---|" * len(headers))

    for res in stats['problem_results']:
        row = [
            res['name'],
            res['pass_syntax'],
            res['pass_func'],
            res['pass_synth'],
            res['best_score'],
            f"`{res['best_ppa']}`",
            f"`{res['ref_ppa']}`"
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

    benchmark_data = defaultdict(lambda: {
        'total_problems': 0,
        'syntax_passes': 0,
        'func_passes': 0,
        'synth_passes': 0,
        'problem_results': []
    })

    summary_files = sorted(experiment_path.glob('*/*/*_summary.json'))
    if not summary_files:
        print(f"⚠️ No `_summary.json` files found in the specified directory structure.")
        return

    for file_path in summary_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            benchmark_name = data.get('benchmark_name', 'Unknown Benchmark')
            problem_name = data.get('problem_name', 'Unknown Problem')

            rates = data.get('accumulated_success_rates', {})
            syntax_pass = rates.get('syntax', 0.0)
            func_pass = rates.get('functionality', 0.0)
            synth_pass = rates.get('synthesis_ppa', 0.0)

            final_ppa = data.get('final_population_ppa', {})
            best_score = final_ppa.get('best_score')
            ref_ppa = data.get('ref_ppa_metric', {})
            best_ppa = final_ppa.get('best_metrics', {})

            stats = benchmark_data[benchmark_name]
            stats['total_problems'] += 1
            if syntax_pass > 0: stats['syntax_passes'] += 1
            if func_pass > 0: stats['func_passes'] += 1
            if synth_pass > 0: stats['synth_passes'] += 1
            
            stats['problem_results'].append({
                'name': problem_name,
                'pass_syntax': "✅ Pass" if syntax_pass > 0 else "❌ Fail",
                'pass_func': "✅ Pass" if func_pass > 0 else "❌ Fail",
                'pass_synth': "✅ Pass" if synth_pass > 0 else "❌ Fail",
                'best_score': f"{best_score:.4f}" if best_score is not None else "N/A",
                'ref_ppa': format_ppa_metrics(ref_ppa),
                'best_ppa': format_ppa_metrics(best_ppa)
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

        pass_rate_syntax = (stats['syntax_passes'] / total) * 100
        pass_rate_func = (stats['func_passes'] / total) * 100
        pass_rate_synth = (stats['synth_passes'] / total) * 100

        print("\n📈 Overall Summary:")
        print(f"  - Total Problems Analyzed: {total}")
        print(f"  - Syntax Pass@1 Rate:      {pass_rate_syntax:.2f}% ({stats['syntax_passes']}/{total})")
        print(f"  - Functionality Pass@1 Rate: {pass_rate_func:.2f}% ({stats['func_passes']}/{total})")
        print(f"  - Synthesis Pass@1 Rate:     {pass_rate_synth:.2f}% ({stats['synth_passes']}/{total})")

        print("\n📋 Detailed Problem Results:")
        headers = ["Problem", "Syntax", "Functionality", "Synthesis", "Best Score", "Best PPA Metrics", "Reference PPA Metrics"]
        col_widths = {h: len(h) for h in headers}
        for res in stats['problem_results']:
            col_widths['Problem'] = max(col_widths['Problem'], len(res['name']))
            col_widths['Best PPA Metrics'] = max(col_widths['Best PPA Metrics'], len(res['best_ppa']))
            col_widths['Reference PPA Metrics'] = max(col_widths['Reference PPA Metrics'], len(res['ref_ppa']))
        
        header_line = (f"{headers[0]:<{col_widths['Problem']}} | "
                       f"{headers[1]:<13} | {headers[2]:<13} | {headers[3]:<11} | "
                       f"{headers[4]:<12} | {headers[5]:<{col_widths['Best PPA Metrics']}} | "
                       f"{headers[6]:<{col_widths['Reference PPA Metrics']}}")
        print(header_line)
        print("-" * len(header_line))

        for res in stats['problem_results']:
            row_line = (f"{res['name']:<{col_widths['Problem']}} | "
                        f"{res['pass_syntax']:<13} | {res['pass_func']:<13} | {res['pass_synth']:<11} | "
                        f"{res['best_score']:<12} | {res['best_ppa']:<{col_widths['Best PPA Metrics']}} | "
                        f"{res['ref_ppa']:<{col_widths['Reference PPA Metrics']}}")
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
        description="Generate a summary report from experiment result files.",
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        '--experiment_result_path',
        type=pathlib.Path,
        required=True,
        help="Path to the root directory containing experiment results."
    )
    parser.add_argument(
        '--save_markdown',
        action='store_true',
        help="Save the report as a Markdown file in the experiment result path.\n"
             "Filename will be {benchmark_name}_report.md."
    )

    args = parser.parse_args()
    generate_report(args.experiment_result_path, args.save_markdown)