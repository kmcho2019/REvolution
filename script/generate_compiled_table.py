import csv
import argparse
import os
from collections import defaultdict

def generate_markdown_table(csv_files, output_file):
    """
    Reads data from multiple CSV files, processes it, and generates a
    Markdown table, grouping results by model name.

    Args:
        csv_files (list): A list of paths to the input CSV files.
        output_file (str): The path for the output Markdown file.
    """
    # The header for the final Markdown table.
    markdown_header = [
        "model name",
        "benchmark",
        "init_any_pass_rate", # Initial functionality pass rate, if any of the initial generation pass for a problem
        "final_any_pass_rate", # Final functionality pass rate, if any of the final generation pass for a problem
        "area_improvement", # compared to reference
        "power_improvement", # compared to reference
        "eff_clk_improvement", # compared to reference
        "avg_runtime_sec" # Average runtime in seconds
    ]

    # Indices of the columns to extract from the source CSV files.
    # Corresponds to the order in markdown_header.
    # model (0), benchmark_name (1), init_func_any_pass_rate (4),
    # final_func_any_pass_rate (5), area... (6), power... (7),
    # eff_clk... (8), avg_runtime_seconds (9)
    column_indices = [0, 1, 4, 5, 6, 7, 8, 9]

    # A dictionary to group rows by model name.
    # e.g., {'gpt-4.1-mini...': [row_for_rtllm, row_for_verilogeval]}
    model_data = defaultdict(list)

    print(f"Processing {len(csv_files)} CSV file(s)...")

    # --- Step 1: Read and parse all CSV files, grouping by model ---
    for file_path in csv_files:
        try:
            with open(file_path, mode='r', encoding='utf-8') as infile:
                reader = csv.reader(infile)
                header = next(reader)  # Skip the header row

                for row in reader:
                    if not row:  # Skip empty rows
                        continue
                    
                    # Extract the model name to use as a key for grouping
                    model_name = row[0]
                    
                    # Extract only the required columns using the specified indices
                    extracted_row = [row[i] for i in column_indices]
                    model_data[model_name].append(extracted_row)

        except FileNotFoundError:
            print(f"Error: File not found at {file_path}. Skipping.")
        except Exception as e:
            print(f"An error occurred while processing {file_path}: {e}")

    if not model_data:
        print("No data was processed. Exiting.")
        return

    # --- Step 2: Write the collected data to the Markdown file ---
    try:
        with open(output_file, 'w', encoding='utf-8') as md_file:
            # Write the Markdown table header
            md_file.write("| " + " | ".join(markdown_header) + " |\n")
            
            # Write the separator line
            md_file.write("|" + "---|"*len(markdown_header) + "\n")

            # Sort models alphabetically for consistent output order
            sorted_models = sorted(model_data.keys())

            # Write the data rows, grouped by model
            for model_name in sorted_models:
                # Get all rows for the current model and sort them by benchmark name (column 1)
                rows_for_model = sorted(model_data[model_name], key=lambda x: x[1])
                
                is_first_row_for_model = True
                for row_data in rows_for_model:
                    if is_first_row_for_model:
                        # The first row for this model prints the model name
                        md_file.write("| " + " | ".join(map(str, row_data)) + " |\n")
                        is_first_row_for_model = False
                    else:
                        # Subsequent rows for the same model have an empty model name cell
                        modified_row = list(row_data)
                        modified_row[0] = '' # Blank out the model name
                        md_file.write("| " + " | ".join(map(str, modified_row)) + " |\n")
        
        print(f"\nSuccessfully generated Markdown table at: {output_file}")

    except Exception as e:
        print(f"An error occurred while writing to {output_file}: {e}")


def main():
    """
    Main function to parse command-line arguments and run the script.
    """
    parser = argparse.ArgumentParser(
        description="Generate a Markdown table from benchmark result CSV files.",
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        '--csv_files',
        metavar='FILE',
        nargs='+',
        help="One or more paths to the input CSV files."
    )
    parser.add_argument(
        '-o', '--output',
        default='compile_results.md',
        help="Name of the output Markdown file (default: compile_results.md)."
    )
    
    args = parser.parse_args()
    
    generate_markdown_table(args.csv_files, args.output)

if __name__ == '__main__':
    # --- How to run this script ---
    #
    # 1. Save this script as a Python file (e.g., `generate_report.py`).
    # 2. Place your CSV files in the same directory or provide their paths.
    # 3. Open your terminal or command prompt.
    # 4. Run the script, passing the CSV file names as arguments.
    #
    # Example:
    # python generate_report.py model1_results.csv model2_results.csv
    #
    # To specify a different output file name:
    # python generate_report.py *.csv --output my_custom_report.md
    #
    main()
