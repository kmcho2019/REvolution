import json
import os
import argparse
import re

def parse_module_name_from_prompt(prompt_file_path):
    """
    Parses a _prompt.txt file to find the specified module name.

    Args:
        prompt_file_path (str): The full path to the prompt file.

    Returns:
        str: The found module name, or None if not found.
    """
    if not os.path.exists(prompt_file_path):
        print(f"Warning: Prompt file not found: {prompt_file_path}")
        return None

    try:
        with open(prompt_file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # Use regex to find "Module name:" and capture the following word.
            # This is robust against varying whitespace and newlines.
            # re.DOTALL allows . to match newlines
            # re.IGNORECASE makes the search case-insensitive
            match = re.search(
                r"Module name:\s*(\w+)", 
                content, 
                re.IGNORECASE | re.DOTALL
            )
            
            if match:
                # The first captured group is the module name
                return match.group(1).strip()
            else:
                print(f"Warning: 'Module name:' not found in {prompt_file_path}")
                return None

    except Exception as e:
        print(f"Error reading or parsing {prompt_file_path}: {e}")
        return None


def create_dynamic_mapping(problems_file_path, output_filename):
    """
    Reads problem names, finds their module names from corresponding prompt
    files, and creates a JSON mapping.

    Args:
        problems_file_path (str): The full path to the problems.txt file.
        output_filename (str): The name of the output JSON file.
    """
    # The directory containing problems.txt is where the _prompt.txt files are
    base_dir = os.path.dirname(problems_file_path)

    if not os.path.exists(problems_file_path):
        print(f"Error: The file '{problems_file_path}' was not found.")
        return

    problem_map = {}
    
    try:
        with open(problems_file_path, 'r', encoding='utf-8') as f:
            for line in f:
                problem_name = line.strip()
                if not problem_name:
                    continue
                
                # Construct the path to the corresponding prompt file
                prompt_file = os.path.join(base_dir, f"{problem_name}_prompt.txt")
                
                # Parse the module name from that file
                module_name = parse_module_name_from_prompt(prompt_file)
                
                if module_name:
                    problem_map[problem_name] = module_name
                else:
                    # Fallback or skip if module name couldn't be found
                    problem_map[problem_name] = "PARSE_ERROR"

    except Exception as e:
        print(f"An error occurred while reading the problems file: {e}")
        return

    # Write the resulting dictionary to a JSON file
    try:
        with open(output_filename, 'w', encoding='utf-8') as f:
            json.dump(problem_map, f, indent=4)
        print(f"Successfully created dynamic mapping at '{output_filename}'")
        print(f"Total problems mapped: {len(problem_map)}")
    except Exception as e:
        print(f"An error occurred while writing the JSON file: {e}")


if __name__ == "__main__":
    # Set up command-line argument parsing
    parser = argparse.ArgumentParser(
        description='Create a JSON file mapping problem names to module names parsed from prompt files.'
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
    create_dynamic_mapping(args.problems_path, args.output)

    # --- Example Usage ---
    # python your_script_name.py --problems_path /path/to/your/bench/RTLLM/problems.txt --output /path/to/your/bench/RTLLM/synthesis_top_module_names.json
