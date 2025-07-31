#!/bin/bash

# =============================================================================
#
# Script Name: generate_cutoff_compile_result_variants.sh
# Description: This script automates the process of generating tables and
#              compiling results based on a specified cutoff type and value.
#              It supports both area and gate count cutoffs, aligning with
#              the updated table generation script. It also handles the
#              special 'no_cutoff' case when the value is < 0.
#
# Usage:       ./script/generate_cutoff_compile_result_variants.sh <type> <value>
#
# Example:     ./script/generate_cutoff_compile_result_variants.sh --area 1000
#              ./script/generate_cutoff_compile_result_variants.sh --gate 500
#              ./script/generate_cutoff_compile_result_variants.sh --gate -1  # For no cutoff
#
# =============================================================================

# --- Configuration ---
# Exit immediately if a command exits with a non-zero status.
set -e

# --- Input Validation ---
# Check if the user has provided exactly two arguments.
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <type> <value>"
    echo "Error: You must provide a type (--area or --gate) and a cutoff value."
    echo "Example: $0 --gate 50"
    exit 1
fi

# --- Argument Parsing ---
cutoff_type_flag=$1
cutoff_value=$2
python_arg_name=""

if [ "$cutoff_type_flag" == "--area" ]; then
    python_arg_name="--ref_area_cutoff"
elif [ "$cutoff_type_flag" == "--gate" ]; then
    python_arg_name="--ref_gate_count_cutoff"
else
    echo "Error: Invalid cutoff type '${cutoff_type_flag}'. Use --area or --gate."
    exit 1
fi

# --- Filename Logic ---
# Determine the string to use for filenames, replicating the Python script's logic.
filename_identifier=""

# Check for the 'no_cutoff' case first. This happens if the user provides a negative value.
if [[ "$cutoff_value" == -* ]]; then
    filename_identifier="no_cutoff"
else
    if [ "$cutoff_type_flag" == "--gate" ]; then
        # The python script uses the integer value directly in the filename.
        filename_identifier="gate_cutoff_${cutoff_value}"
    elif [ "$cutoff_type_flag" == "--area" ]; then
        # The python script rounds the area value to 0 decimal places for the filename.
        rounded_value=$(printf "%.0f" "${cutoff_value}")
        filename_identifier="area_cutoff_${rounded_value}"
    fi
fi

# --- Script Body ---
echo "Starting script with ${cutoff_type_flag} cutoff value: ${cutoff_value}"
if [ "$filename_identifier" == "no_cutoff" ]; then
    echo "Detected 'no_cutoff' scenario. Using 'no_cutoff' in filenames."
fi
echo "--------------------------------------------------"

# Define experiment paths in an array to avoid repetition and improve maintainability.
declare -a experiment_paths=(
    "./exp/gpt-4.1-mini_clean_results/"
    "./exp/deepseek_clean_results/"
    "./exp/llama3_clean_results/"
    "./exp/llama3_baseline_clean_results/"
)

# --- Steps 1-3: Generate tables for all models in a loop ---
for path in "${experiment_paths[@]}"; do
    echo "Generating table for ${path}..."
    # Call the python script with the appropriate cutoff argument and value.
    python3 script/table_generation_script_v2.5.py \
        "${python_arg_name}" "${cutoff_value}" \
        --experiment_path "${path}"
    echo "Done."
    echo ""
done

# --- Step 4: Compile all generated tables ---
echo "Compiling results into a single markdown file..."

# Construct the paths to the generated CSV files dynamically using the identifier.
csv_file_1="./exp/gpt-4.1-mini_clean_results/ppa_summary_${filename_identifier}_abridged.csv"
csv_file_2="./exp/deepseek_clean_results/ppa_summary_${filename_identifier}_abridged.csv"
csv_file_3="./exp/llama3_clean_results/ppa_summary_${filename_identifier}_abridged.csv"
csv_file_4="./exp/llama3_baseline_clean_results/ppa_summary_${filename_identifier}_abridged.csv"
output_file="compile_results_${filename_identifier}.md"

python script/generate_compiled_table.py \
    --csv_files "${csv_file_1}" "${csv_file_2}" "${csv_file_3}" "${csv_file_4}" \
    --output "${output_file}"
echo "Done."
echo ""

# --- Completion ---
echo "--------------------------------------------------"
echo "Script finished successfully."
echo "Compiled results are available in: ${output_file}"
