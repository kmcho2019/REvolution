# /// script
# dependencies = ["numpy", "pandas", "matplotlib", "seaborn"]
# ///
import json
import argparse
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from matplotlib.colors import Normalize
from matplotlib.cm import ScalarMappable

def load_generation_data(jsonl_file):
    """
    Loads and parses the generation data from a JSONL file.

    Args:
        jsonl_file (str): Path to the generation_log.jsonl file.

    Returns:
        tuple: A tuple containing a list of all data points and the total number of generations.
               Each data point is a dictionary with 'generation', 'power', and 'area'.
    """
    all_data = []
    max_gen = 0
    try:
        with open(jsonl_file, 'r') as f:
            for line in f:
                try:
                    gen_data = json.loads(line)
                    gen = gen_data.get('generation', 0)
                    if gen > max_gen:
                        max_gen = gen
                    population_details = gen_data.get('population_ppa_details', [])
                    for individual in population_details:
                        ppa_metrics = individual.get('ppa_metrics', {})
                        power = ppa_metrics.get('power')
                        area = ppa_metrics.get('area')
                        if power is not None and area is not None:
                            all_data.append({
                                'generation': gen,
                                'power': power,
                                'area': area
                            })
                except json.JSONDecodeError:
                    print(f"Warning: Could not decode a line in {jsonl_file}")
                    continue
    except FileNotFoundError:
        print(f"Error: The file {jsonl_file} was not found.")
        return [], 0
    except Exception as e:
        print(f"An unexpected error occurred while reading {jsonl_file}: {e}")
        return [], 0

    num_generations = max_gen + 1
    return all_data, num_generations

def load_reference_data(summary_file):
    """
    Loads the reference PPA data from the summary JSON file.

    Args:
        summary_file (str): Path to the *_summary.json file.

    Returns:
        tuple: A tuple containing the reference power and reference area.
    """
    try:
        with open(summary_file, 'r') as f:
            summary_data = json.load(f)
            ref_ppa = summary_data.get('ref_ppa_metric', {})
            ref_power = ref_ppa.get('power')
            ref_area = ref_ppa.get('area')
            return ref_power, ref_area
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error: Could not read or parse the summary file {summary_file}: {e}")
        return None, None
    except Exception as e:
        print(f"An unexpected error occurred while reading {summary_file}: {e}")
        return None, None

def get_pareto_front(points):
    """
    Calculates the Pareto front for a set of 2D points (minimization of power and area).

    Args:
        points (list): A list of dictionaries, each with 'area' and 'power' keys.

    Returns:
        list: A sorted list of points on the Pareto front.
    """
    if not points:
        return []

    # Sort points by the first objective (area) to begin
    sorted_points = sorted(points, key=lambda p: (p['area'], p['power']))
    pareto_front = []
    
    for point in sorted_points:
        # A point is on the Pareto front if no other point dominates it.
        # Since we sorted, a new point is non-dominated if its power is lower than the last point added to the front.
        if not pareto_front or point['power'] < pareto_front[-1]['power']:
            pareto_front.append(point)

    return pareto_front

def plot_all_individuals(all_data, ref_power, ref_area, num_generations, cmap):
    """Plot 1: Scatter plot of all individuals from all generations."""
    plt.figure(figsize=(12, 8))
    ax = plt.gca() # Get current axes

    generations = [p['generation'] for p in all_data]
    areas = [p['area'] for p in all_data]
    powers = [p['power'] for p in all_data]

    sns.scatterplot(x=areas, y=powers, hue=generations, palette=cmap, s=50, legend=False, ax=ax)
    
    if ref_area is not None and ref_power is not None:
        ax.scatter(ref_area, ref_power, marker='*', s=300, color='gold', edgecolor='black', zorder=5, label='Reference PPA')

    # Create a colorbar
    norm = Normalize(vmin=0, vmax=num_generations - 1)
    sm = ScalarMappable(cmap=cmap, norm=norm)
    sm.set_array([])
    
    # *** FIX: Associate the colorbar with the correct axes (ax) ***
    ticks = np.linspace(0, num_generations - 1, min(11, num_generations))
    cbar = plt.colorbar(sm, ticks=ticks, ax=ax)
    cbar.set_label('Generation', size=12)

    ax.set_xlabel('Area')
    ax.set_ylabel('Power')
    ax.set_title('PPA Improvement Over Generations: All Individuals')
    ax.legend()
    ax.grid(True, which='both', linestyle='--', linewidth=0.5)
    plt.tight_layout()
    plt.savefig("plot1_all_individuals.png", dpi=300)
    print("Generated plot1_all_individuals.png")

def plot_generational_pareto_fronts(all_data, ref_power, ref_area, num_generations, cmap):
    """Plot 2: Plot Pareto front for each generation."""
    plt.figure(figsize=(12, 8))
    ax = plt.gca() # Get current axes
    
    for gen in range(num_generations):
        gen_points = [p for p in all_data if p['generation'] == gen]
        if not gen_points:
            continue
            
        pareto_front = get_pareto_front(gen_points)

        # Plot all points for the generation with low alpha
        areas = [p['area'] for p in gen_points]
        powers = [p['power'] for p in gen_points]
        ax.scatter(areas, powers, color=cmap(gen), alpha=0.1, s=30)
        
        if pareto_front:
            pareto_areas = [p['area'] for p in pareto_front]
            pareto_powers = [p['power'] for p in pareto_front]
            ax.plot(pareto_areas, pareto_powers, marker='o', linestyle='-', color=cmap(gen), label=f'Gen {gen}' if num_generations <= 10 else None)

    if ref_area is not None and ref_power is not None:
        ax.scatter(ref_area, ref_power, marker='*', s=300, color='gold', edgecolor='black', zorder=5, label='Reference PPA')

    # Create a colorbar
    norm = Normalize(vmin=0, vmax=num_generations - 1)
    sm = ScalarMappable(cmap=cmap, norm=norm)
    sm.set_array([])

    # *** FIX: Associate the colorbar with the correct axes (ax) ***
    ticks = np.linspace(0, num_generations - 1, min(11, num_generations))
    cbar = plt.colorbar(sm, ticks=ticks, ax=ax)
    cbar.set_label('Generation', size=12)

    ax.set_xlabel('Area')
    ax.set_ylabel('Power')
    ax.set_title('Pareto Front Advancement by Generation')
    if num_generations <= 10:
        ax.legend()
    ax.grid(True, which='both', linestyle='--', linewidth=0.5)
    plt.tight_layout()
    plt.savefig("plot2_generational_fronts.png", dpi=300)
    print("Generated plot2_generational_fronts.png")

def plot_grouped_pareto_fronts(all_data, ref_power, ref_area, groups, group_labels, title, filename, cmap_name='viridis'):
    """Generic function to plot grouped Pareto fronts (for plots 3 and 4)."""
    plt.figure(figsize=(12, 8))
    ax = plt.gca() # Get current axes
    num_groups = len(groups)
    cmap = plt.get_cmap(cmap_name, num_groups)

    for i, (group_range, group_label) in enumerate(zip(groups, group_labels)):
        start_gen, end_gen = group_range
        group_points = [p for p in all_data if start_gen <= p['generation'] <= end_gen]
        if not group_points:
            continue
            
        pareto_front = get_pareto_front(group_points)

        # Filter out very distant points for cleaner visualization
        if pareto_front:
            max_area_front = max(p['area'] for p in pareto_front)
            max_power_front = max(p['power'] for p in pareto_front)
            display_points = [
                p for p in group_points 
                if p['area'] < max_area_front * 2.5 and p['power'] < max_power_front * 2.5
            ]
        else:
            display_points = group_points
        
        areas = [p['area'] for p in display_points]
        powers = [p['power'] for p in display_points]
        ax.scatter(areas, powers, color=cmap(i), alpha=0.08, s=30)
        
        if pareto_front:
            pareto_areas = [p['area'] for p in pareto_front]
            pareto_powers = [p['power'] for p in pareto_front]
            ax.plot(pareto_areas, pareto_powers, marker='o', linestyle='-', color=cmap(i), label=group_label)

    if ref_area is not None and ref_power is not None:
        ax.scatter(ref_area, ref_power, marker='*', s=300, color='gold', edgecolor='black', zorder=5, label='Reference PPA')

    ax.set_xlabel('Area')
    ax.set_ylabel('Power')
    ax.set_title(title)
    ax.legend()
    ax.grid(True, which='both', linestyle='--', linewidth=0.5)
    plt.tight_layout()
    plt.savefig(filename, dpi=300)
    print(f"Generated {filename}")

def main():
    parser = argparse.ArgumentParser(description="Generate Pareto front diagrams for evolutionary coding algorithm results.")
    # *** FIX: Changed to named arguments to match your command ***
    parser.add_argument("--generation_log", required=True, help="Path to the generation_log.jsonl file.")
    parser.add_argument("--summary_json", required=True, help="Path to the summary JSON file (e.g., *_summary.json).")
    args = parser.parse_args()

    all_data, num_generations = load_generation_data(args.generation_log)
    ref_power, ref_area = load_reference_data(args.summary_json)

    if not all_data:
        print("No data loaded. Exiting.")
        return

    # Use a continuous colormap
    cmap_generations = plt.get_cmap('viridis')
    
    # --- Plot 1: All Individuals ---
    plot_all_individuals(all_data, ref_power, ref_area, num_generations, cmap_generations)

    # --- Plot 2: Generational Pareto Fronts ---
    # Create a new cmap function for this plot to map generation index to color
    cmap_gen_func = plt.get_cmap('viridis', num_generations)
    plot_generational_pareto_fronts(all_data, ref_power, ref_area, num_generations, cmap_gen_func)

    # --- Plot 3: Equally Spaced Grouped Pareto Fronts ---
    if num_generations > 4:
        # Ensure groups are disjoint and cover all generations
        group_splits = np.linspace(0, num_generations, 5, dtype=int)
        groups = [
            (group_splits[0], group_splits[1]-1),
            (group_splits[1], group_splits[2]-1),
            (group_splits[2], group_splits[3]-1),
            (group_splits[3], group_splits[4]-1 if group_splits[4] > group_splits[3] else group_splits[4])
        ]
        # Adjust the last group to include the last generation
        groups[-1] = (groups[-1][0], num_generations - 1)

        group_labels = [f'Gens {g[0]}-{g[1]}' for g in groups]
        plot_grouped_pareto_fronts(all_data, ref_power, ref_area, groups, group_labels, 
                                   'Pareto Fronts by Generation Group (4 Equal Groups)', 'plot3_equal_groups.png', 'plasma')

    # --- Plot 4: Custom Grouped Pareto Fronts ---
    if num_generations > 13:
        groups = [
            (0, 0),
            (1, 4),
            (5, 11),
            (12, num_generations - 1)
        ]
        group_labels = [f'Gen {g[0]}' if g[0]==g[1] else f'Gens {g[0]}-{g[1]}' for g in groups]
        plot_grouped_pareto_fronts(all_data, ref_power, ref_area, groups, group_labels, 
                                   'Pareto Fronts by Generation Group (Custom Groups)', 'plot4_custom_groups.png', 'cividis')

    # plt.show() # This can be commented out for non-interactive environments

if __name__ == "__main__":
    main()