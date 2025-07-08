import json
import os
import argparse

def create_static_mapping(problems_file_path, output_filename):
    """
    Reads problem names from a file and maps each to "TopModule".

    Args:
        problems_file_path (str): The full path to the problems.txt file.
        output_filename (str): The name of the output JSON file.
    """
    # Ensure the input file exists
    if not os.path.exists(problems_file_path):
        print(f"Error: The file '{problems_file_path}' was not found.")
        return

    problem_map = {}
    
    try:
        with open(problems_file_path, 'r', encoding='utf-8') as f:
            for line in f:
                # Remove whitespace and newline characters
                problem_name = line.strip()
                if problem_name:  # Ensure the line is not empty
                    problem_map[problem_name] = "TopModule"
    except Exception as e:
        print(f"An error occurred while reading the file: {e}")
        return

    # Write the resulting dictionary to a JSON file
    try:
        with open(output_filename, 'w', encoding='utf-8') as f:
            json.dump(problem_map, f, indent=4)
        print(f"Successfully created static mapping at '{output_filename}'")
        print(f"Total problems mapped: {len(problem_map)}")
    except Exception as e:
        print(f"An error occurred while writing the JSON file: {e}")


if __name__ == "__main__":
    # Set up command-line argument parsing
    parser = argparse.ArgumentParser(
        description='Create a JSON file mapping problem names to "TopModule".'
    )
    parser.add_argument(
        '--problems_path',
        type=str,
        help='Path to the problems.txt file.'
    )
    parser.add_argument(
        '--output',
        type=str,
        default='synthesis_top_module_names.json',
        help='Name for the output JSON file (default: synthesis_top_module_names.json).'
    )

    args = parser.parse_args()
    
    # Run the main function
    create_static_mapping(args.problems_path, args.output)

    # --- Example Usage ---
    # python your_script_name.py --problems_path /path/to/your/bench/VerilogEval-Code-Complete/problems.txt --output /path/to/your/bench/VerilogEval-Code-Complete/synthesis_top_module_names.json
