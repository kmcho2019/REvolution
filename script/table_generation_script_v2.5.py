import argparse
import json
import pathlib
import csv
import sys
from collections import defaultdict

def calculate_improvement(new_val, ref_val):
    """
    Calculates the percentage improvement. A positive result is an improvement.
    
    Returns:
        A tuple containing:
        - The formatted improvement string (e.g., "25.10").
        - The raw float value of the improvement, or None if not applicable.
    """
    if ref_val is None or new_val is None or ref_val == 0:
        return 'N/A', None
    
    # Formula: ((reference - new) / reference) * 100
    # This means a smaller new value (like area) results in a positive improvement.
    improvement = ((ref_val - new_val) / abs(ref_val)) * 100
    return f"{improvement:.2f}", improvement

def analyze_experiments_to_csv(experiment_path: pathlib.Path, ref_area_cutoff: float):
    """
    Parses experiment summary files, calculates statistics, and generates a CSV report
    that includes both per-problem results and benchmark-level averages.

    Args:
        experiment_path: Path to the root directory of the experiment results.
        ref_area_cutoff: The area cutoff for including a design in PPA analysis.
    """
    if not experiment_path.is_dir():
        print(f"❌ Error: Experiment path not found -> {experiment_path}")
        sys.exit(1)

    model_name = experiment_path.name
    summary_files = sorted(experiment_path.glob('*/*/*_summary.json'))
    if not summary_files:
        print(f"⚠️ No `_summary.json` files found matching the pattern: {experiment_path}/*/*/*_summary.json")
        return

    print(f"Found {len(summary_files)} summary files to process for model '{model_name}'.")

    problem_rows = []
    # This dictionary will store the raw numerical data needed for averaging.
    benchmark_stats = defaultdict(lambda: {
        'area': [], 'power': [], 'clk': [],
        'init_func_pass': [], 'final_func_pass': [],
        'init_func_any_pass': [], 'final_func_any_pass': []
    })

    header = [
        "model", "benchmark_name", "init_func_pass_rate", "final_func_pass_rate",
        "init_func_any_pass_rate", "final_func_any_pass_rate",
        "area_improvement_percentage_compared_to_ref",
        "power_improvement_percentage_compared_to_ref",
        "eff_clk_improvement_percentage_compared_to_ref"
    ]

    for file_path in summary_files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            problem_name = data.get('problem_name', 'UnknownProblem')
            benchmark_name = data.get('benchmark_name', 'UnknownBenchmark')

            # --- Extract Pass Rates ---
            final_func_pass_rate = data.get('accumulated_success_rates', {}).get('functionality', 0.0)
            init_func_pass_rate = 0.0
            gen_log_path = file_path.parent / "generation_log.jsonl"
            if gen_log_path.exists():
                with open(gen_log_path, 'r', encoding='utf-8') as log_f:
                    first_line = log_f.readline()
                    if first_line:
                        first_gen_data = json.loads(first_line)
                        if first_gen_data.get('generation') == 0:
                            init_func_pass_rate = first_gen_data.get('success_rates', {}).get('total_functionality', 0.0)
            
            # For individual problems, "any pass" is binary (1.0 if > 0, else 0.0)
            init_func_any_pass = 1.0 if init_func_pass_rate > 0 else 0.0
            final_func_any_pass = 1.0 if final_func_pass_rate > 0 else 0.0

            # Store all stats for averaging later
            stats = benchmark_stats[benchmark_name]
            stats['init_func_pass'].append(init_func_pass_rate)
            stats['final_func_pass'].append(final_func_pass_rate)
            stats['init_func_any_pass'].append(init_func_any_pass)
            stats['final_func_any_pass'].append(final_func_any_pass)

            # --- PPA Improvement Calculation ---
            ref_ppa = data.get('ref_ppa_metric')
            best_ppa = data.get('final_population_ppa', {}).get('best_metrics')

            area_improv_str, area_improv_val = 'N/A', None
            power_improv_str, power_improv_val = 'N/A', None
            clk_improv_str, clk_improv_val = 'N/A', None

            if not ref_ppa or not best_ppa:
                print(f"  - Skipping PPA for {problem_name}: Reference or Best PPA data not available.")
            elif ref_ppa.get('area') is None or ref_ppa.get('area') < ref_area_cutoff:
                print(f"  - Skipping PPA for {problem_name}: Reference area ({ref_ppa.get('area')}) is below cutoff ({ref_area_cutoff}).")
            else:
                area_improv_str, area_improv_val = calculate_improvement(best_ppa.get('area'), ref_ppa.get('area'))
                power_improv_str, power_improv_val = calculate_improvement(best_ppa.get('power'), ref_ppa.get('power'))
                
                if ref_ppa.get('eff_clk_period') == 0.0:
                    clk_improv_str, clk_improv_val = 'N/A', None
                else:
                    clk_improv_str, clk_improv_val = calculate_improvement(best_ppa.get('eff_clk_period'), ref_ppa.get('eff_clk_period'))

            # Store numerical PPA values for averaging
            if area_improv_val is not None: stats['area'].append(area_improv_val)
            if power_improv_val is not None: stats['power'].append(power_improv_val)
            if clk_improv_val is not None: stats['clk'].append(clk_improv_val)

            # Assemble the row for the individual problem.
            problem_rows.append({
                "model": model_name,
                "benchmark_name": f"{benchmark_name}/{problem_name}",
                "init_func_pass_rate": f"{init_func_pass_rate:.4f}",
                "final_func_pass_rate": f"{final_func_pass_rate:.4f}",
                "init_func_any_pass_rate": f"{init_func_any_pass:.4f}",
                "final_func_any_pass_rate": f"{final_func_any_pass:.4f}",
                "area_improvement_percentage_compared_to_ref": area_improv_str,
                "power_improvement_percentage_compared_to_ref": power_improv_str,
                "eff_clk_improvement_percentage_compared_to_ref": clk_improv_str,
            })

        except (json.JSONDecodeError, KeyError, IndexError, TypeError) as e:
            print(f"⚠️ Could not process file {file_path}: {e} - Skipping.")
            continue

    # --- Generate Summary Rows ---
    summary_rows = []
    for benchmark_name, stats in benchmark_stats.items():
        
        def get_avg(data_list):
            """Calculates average for a list of numbers, ignoring non-numeric values."""
            valid_data = [x for x in data_list if isinstance(x, (int, float))]
            if not valid_data:
                return 'N/A'
            return f"{(sum(valid_data) / len(valid_data)):.4f}"

        summary_rows.append({
            "model": model_name,
            "benchmark_name": benchmark_name, # Use just the benchmark name for the summary row
            "init_func_pass_rate": get_avg(stats['init_func_pass']),
            "final_func_pass_rate": get_avg(stats['final_func_pass']),
            "init_func_any_pass_rate": get_avg(stats['init_func_any_pass']),
            "final_func_any_pass_rate": get_avg(stats['final_func_any_pass']),
            "area_improvement_percentage_compared_to_ref": get_avg(stats['area']),
            "power_improvement_percentage_compared_to_ref": get_avg(stats['power']),
            "eff_clk_improvement_percentage_compared_to_ref": get_avg(stats['clk']),
        })

    # --- Combine, Sort, and Write to CSV ---
    if not problem_rows:
        print("No data was processed. CSV file will not be created.")
        return
        
    all_rows = problem_rows + summary_rows
    # Sort by benchmark name to group related rows together.
    all_rows.sort(key=lambda x: x['benchmark_name'])

    output_file_path = experiment_path / "ppa_summary.csv"
    try:
        with open(output_file_path, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=header)
            writer.writeheader()
            writer.writerows(all_rows)
        print(f"\n✅ Successfully generated CSV report with benchmark averages: {output_file_path}")
    except IOError as e:
        print(f"\n❌ Error saving CSV file: {e}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Generate a PPA summary CSV report from an evolutionary framework experiment.",
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        '--experiment_path', type=pathlib.Path, required=True,
        help="Path to the root directory of a specific model's experiment results.\n"
             "Example: './exp/deepseek-chat/'"
    )
    parser.add_argument(
        '--ref_area_cutoff', type=float, required=True,
        help="If the reference area is smaller than this value, exclude the design\n"
             "from consideration when calculating PPA improvement percentages."
    )

    args = parser.parse_args()
    analyze_experiments_to_csv(args.experiment_path, args.ref_area_cutoff)
