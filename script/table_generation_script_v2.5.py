import argparse
import json
import pathlib
import csv
import sys
from collections import defaultdict

def load_gate_count_references(csv_paths: list[pathlib.Path]) -> dict[str, int]:
    """
    Loads reference gate counts from a list of CSV files.

    Args:
        csv_paths: A list of paths to the reference CSV files.

    Returns:
        A dictionary mapping problem names to their reference gate counts.
    """
    gate_count_data = {}
    print("Attempting to load reference gate counts...")
    for path in csv_paths:
        if not path.exists():
            print(f"⚠️ Reference CSV not found: {path}. Skipping.")
            continue
        try:
            with open(path, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                # Assuming column names are 'Problem' and 'Reference Gate Count'
                # These might need to be adjusted if the CSVs have different headers.
                problem_col = next((col for col in reader.fieldnames if 'problem' in col.lower()), None)
                gate_count_col = next((col for col in reader.fieldnames if 'gate count' in col.lower()), None)

                if not problem_col or not gate_count_col:
                    print(f"⚠️ Could not find 'Problem' or 'Reference Gate Count' columns in {path}. Skipping.")
                    continue
                
                count = 0
                for row in reader:
                    try:
                        problem_name = row[problem_col]
                        gate_count = int(float(row[gate_count_col]))
                        gate_count_data[problem_name] = gate_count
                        count += 1
                    except (ValueError, TypeError):
                        # Handle cases where gate count is not a valid number
                        continue
                print(f"✅ Loaded {count} gate count entries from {path}.")
        except Exception as e:
            print(f"❌ Error reading {path}: {e}")
            
    if not gate_count_data:
        print("⚠️ No reference gate count data was loaded. PPA calculations might be skipped.")
        
    return gate_count_data

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

# Updated function signature to accept new arguments
def analyze_experiments_to_csv(
    experiment_path: pathlib.Path, 
    ref_area_cutoff: float, 
    ref_gate_count_cutoff: int,
    gate_count_data: dict
):
    """
    Parses experiment summary files, calculates statistics, and generates a CSV report
    that includes both per-problem results and benchmark-level averages.

    Args:
        experiment_path: Path to the root directory of the experiment results.
        ref_area_cutoff: The area cutoff for including a design in PPA analysis.
        ref_gate_count_cutoff: The gate count cutoff for PPA analysis. Takes priority.
        gate_count_data: Dictionary mapping problem names to reference gate counts.
    """
    if not experiment_path.is_dir():
        print(f"❌ Error: Experiment path not found -> {experiment_path}")
        sys.exit(1)

    model_name = experiment_path.name
    summary_files = sorted(experiment_path.glob('*/*/*_summary.json'))
    if not summary_files:
        print(f"⚠️ No `_summary.json` files found matching the pattern: {experiment_path}/*/*/*_summary.json")
        return

    print(f"\nFound {len(summary_files)} summary files to process for model '{model_name}'.")

    problem_rows = []
    # This dictionary will store the raw numerical data needed for averaging.
    benchmark_stats = defaultdict(lambda: {
        'area': [], 'power': [], 'clk': [],
        'init_func_pass': [], 'final_func_pass': [],
        'init_func_any_pass': [], 'final_func_any_pass': [],
        'runtimes': []
    })

    header = [
        "model", "benchmark_name", "init_func_pass_rate", "final_func_pass_rate",
        "init_func_any_pass_rate", "final_func_any_pass_rate",
        "area_improvement_percentage_compared_to_ref",
        "power_improvement_percentage_compared_to_ref",
        "eff_clk_improvement_percentage_compared_to_ref",
        "avg_runtime_seconds"
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
            
            init_func_any_pass = 1.0 if init_func_pass_rate > 0 else 0.0
            final_func_any_pass = 1.0 if final_func_pass_rate > 0 else 0.0
            runtime = data.get('total_runtime_seconds', 0.0)

            # Store all stats for averaging later
            stats = benchmark_stats[benchmark_name]
            stats['init_func_pass'].append(init_func_pass_rate)
            stats['final_func_pass'].append(final_func_pass_rate)
            stats['init_func_any_pass'].append(init_func_any_pass)
            stats['final_func_any_pass'].append(final_func_any_pass)
            stats['runtimes'].append(runtime)

            # --- PPA Improvement Calculation ---
            ref_ppa = data.get('ref_ppa_metric')
            best_ppa = data.get('final_population_ppa', {}).get('best_metrics')
            

            # New logic to determine if PPA calculation should be skipped
            ref_gate_count = gate_count_data.get(problem_name)
            skip_reason = None

            if not ref_ppa or not best_ppa:
                skip_reason = "Reference or Best PPA data not available"
            elif ref_ppa.get('area') is None:
                skip_reason = "Reference area is not available in summary"
            elif ref_gate_count is None:
                skip_reason = f"Reference gate count for '{problem_name}' not found in provided CSVs"
            elif ref_gate_count == -1:
                skip_reason = "Reference gate count is -1, excluding from PPA analysis"
            else:
                # Prioritize gate count cutoff if active
                if ref_gate_count_cutoff > -1:
                    if ref_gate_count < ref_gate_count_cutoff:
                        skip_reason = f"Reference gate count ({ref_gate_count}) is below cutoff ({ref_gate_count_cutoff})"
                # Fallback to area cutoff if active and gate cutoff was not
                elif ref_area_cutoff > -1.0:
                    if ref_ppa.get('area') < ref_area_cutoff:
                        skip_reason = f"Reference area ({ref_ppa.get('area')}) is below cutoff ({ref_area_cutoff})"

            area_improv_str, area_improv_val = 'N/A', None
            power_improv_str, power_improv_val = 'N/A', None
            clk_improv_str, clk_improv_val = 'N/A', None
            
            if skip_reason:
                print(f"  - Skipping PPA for {problem_name}: {skip_reason}.")
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
                "avg_runtime_seconds": f"{runtime:.2f}"
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
            "benchmark_name": benchmark_name,
            "init_func_pass_rate": get_avg(stats['init_func_pass']),
            "final_func_pass_rate": get_avg(stats['final_func_pass']),
            "init_func_any_pass_rate": get_avg(stats['init_func_any_pass']),
            "final_func_any_pass_rate": get_avg(stats['final_func_any_pass']),
            "area_improvement_percentage_compared_to_ref": get_avg(stats['area']),
            "power_improvement_percentage_compared_to_ref": get_avg(stats['power']),
            "eff_clk_improvement_percentage_compared_to_ref": get_avg(stats['clk']),
            "avg_runtime_seconds": get_avg(stats['runtimes']),
        })

    # --- Combine, Sort, and Write to CSV ---
    if not problem_rows:
        print("No data was processed. CSV file will not be created.")
        return
        
    all_rows = problem_rows + summary_rows
    all_rows.sort(key=lambda x: x['benchmark_name'])


    # Create a dynamic filename based on which cutoff is active
    cutoff_str = "no_cutoff"
    if ref_gate_count_cutoff > -1:
        cutoff_str = f"gate_cutoff_{ref_gate_count_cutoff}"
    elif ref_area_cutoff > -1.0:
        cutoff_str = f"area_cutoff_{ref_area_cutoff:.0f}"
        
    full_output_path = experiment_path / f"ppa_summary_{cutoff_str}.csv"
    abridged_output_path = experiment_path / f"ppa_summary_{cutoff_str}_abridged.csv"

    # Write the full CSV report
    try:
        with open(full_output_path, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=header)
            writer.writeheader()
            writer.writerows(all_rows)
        print(f"\n✅ Successfully generated full CSV report: {full_output_path}")
    except IOError as e:
        print(f"\n❌ Error saving full CSV file: {e}")

    # Write the abridged CSV report
    if summary_rows:
        summary_rows.sort(key=lambda x: x['benchmark_name'])
        try:
            with open(abridged_output_path, 'w', newline='', encoding='utf-8') as csvfile:
                writer = csv.DictWriter(csvfile, fieldnames=header)
                writer.writeheader()
                writer.writerows(summary_rows)
            print(f"✅ Successfully generated abridged CSV report: {abridged_output_path}")
        except IOError as e:
            print(f"\n❌ Error saving abridged CSV file: {e}")
    else:
        print("\n⚠️ No summary data available to create an abridged report.")


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
    # Added new argument for gate count cutoff and updated help text.
    # Set defaults to -1 to indicate they are inactive by default.
    parser.add_argument(
        '--ref_gate_count_cutoff', type=int, default=-1,
        help="If the reference gate count is smaller than this value, exclude the design\n"
             "from PPA calculations. This cutoff takes priority over the area cutoff.\n"
             "(Default: -1, disabled)"
    )
    parser.add_argument(
        '--ref_area_cutoff', type=float, default=-1.0,
        help="If the reference area is smaller than this value, exclude the design\n"
             "from PPA calculations. This is only used if --ref_gate_count_cutoff is not set.\n"
             "(Default: -1.0, disabled)"
    )

    args = parser.parse_args()
    
    # Load reference gate count data from the specified CSV files.
    # Assumes the CSVs are in the same directory as the script.
    script_dir = pathlib.Path(__file__).parent
    ref_csv_paths = [
        script_dir / "RTLLM.csv",
        script_dir / "VerilogEval-Spec-to-RTL.csv"
    ]
    gate_count_data = load_gate_count_references(ref_csv_paths)
    
    analyze_experiments_to_csv(
        args.experiment_path, 
        args.ref_area_cutoff, 
        args.ref_gate_count_cutoff,
        gate_count_data
    )
