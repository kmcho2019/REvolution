import json
import argparse
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from matplotlib.colors import Normalize
from matplotlib.cm import ScalarMappable
import os

def calculate_score(power, area, ref_power, ref_area):
    """
    Calculates the improvement score for a given individual based on its PPA
    metrics relative to a reference. The score is negated improvement, so a
    higher score is better.

    Args:
        power (float): The individual's power consumption.
        area (float): The individual's area.
        ref_power (float): The reference power consumption.
        ref_area (float): The reference area.

    Returns:
        float: The calculated score.
    """
    # Avoid division by zero, return a neutral score if reference values are zero.
    if ref_power == 0 or ref_area == 0:
        return 0
    
    power_improvement = (power - ref_power) / ref_power
    area_improvement = (area - ref_area) / ref_area
    
    # For a combinatorial circuit, improvement is the average of power and area improvements.
    total_improvement = (power_improvement + area_improvement) / 2
    
    # The final score is the negative of the total improvement.
    # A positive score means the design is better than the reference.
    score = -total_improvement
    return score

def load_generation_data(jsonl_file):
    """Loads and parses the generation data from a JSONL file."""
    all_data = []
    max_gen = 0
    try:
        with open(jsonl_file, 'r') as f:
            for line in f:
                try:
                    gen_data = json.loads(line)
                    gen = gen_data.get('generation', 0)
                    max_gen = max(gen, max_gen)
                    for individual in gen_data.get('population_ppa_details', []):
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
    except FileNotFoundError:
        print(f"Error: The file {jsonl_file} was not found.")
        return [], 0
    return all_data, max_gen + 1

def load_reference_data(summary_file):
    """Loads the reference PPA data from the summary JSON file."""
    try:
        with open(summary_file, 'r') as f:
            summary_data = json.load(f)
            ref_ppa = summary_data.get('ref_ppa_metric', {})
            return ref_ppa.get('power'), ref_ppa.get('area')
    except (FileNotFoundError, json.JSONDecodeError):
        print(f"Error: Could not read or parse the summary file {summary_file}.")
        return None, None

def get_pareto_front(points):
    """Calculates the Pareto front for a set of 2D points (minimization)."""
    if not points:
        return []
    sorted_points = sorted(points, key=lambda p: (p['area'], p['power']))
    pareto_front = []
    min_power_so_far = float('inf')
    for point in sorted_points:
        if point['power'] < min_power_so_far:
            pareto_front.append(point)
            min_power_so_far = point['power']
    return pareto_front

def apply_axis_limits(ax, max_area, max_power):
    """Applies user-defined axis limits to a plot."""
    if max_area is not None:
        ax.set_xlim(right=max_area)
    if max_power is not None:
        ax.set_ylim(top=max_power)

def plot_all_individuals(all_data, ref_power, ref_area, num_generations, cmap, output_dir, max_area=None, max_power=None, name=None):
    """Plot 1: Scatter plot of all individuals from all generations."""
    plt.figure(figsize=(12, 8))
    ax = plt.gca()
    generations = [p['generation'] for p in all_data]
    areas = [p['area'] for p in all_data]
    powers = [p['power'] for p in all_data]
    sns.scatterplot(x=areas, y=powers, hue=generations, palette=cmap, s=50, legend=False, ax=ax)
    if ref_area is not None and ref_power is not None:
        ax.scatter(ref_area, ref_power, marker='*', s=300, color='gold', edgecolor='black', zorder=5, label='Reference PPA')
    norm = Normalize(vmin=0, vmax=num_generations - 1)
    sm = ScalarMappable(cmap=cmap, norm=norm)
    ticks = np.linspace(0, num_generations - 1, min(11, num_generations), dtype=int)
    cbar = plt.colorbar(sm, ticks=ticks, ax=ax)
    cbar.set_label('Generation')
    ax.set_xlabel('Area'); ax.set_ylabel('Power'); ax.set_title('PPA Improvement Over Generations: All Individuals')
    ax.legend(); ax.grid(True, linestyle='--')
    apply_axis_limits(ax, max_area, max_power)
    plt.tight_layout(); 
    
    if not name:
        file_name = "plot1_all_individuals.png"
    else:
        file_name = f"plot1_all_individuals_{name}.png"
    plt.savefig(os.path.join(output_dir, file_name), dpi=300)
    print(f"Generated {os.path.join(output_dir, file_name)}")

def plot_generational_pareto_fronts(all_data, ref_power, ref_area, num_generations, cmap, output_dir,max_area=None, max_power=None):
    """Plot 2: Plot Pareto front for each generation."""
    plt.figure(figsize=(12, 8))
    ax = plt.gca()
    cmap_func = plt.get_cmap(cmap.name, num_generations)
    for gen in range(num_generations):
        gen_points = [p for p in all_data if p['generation'] == gen]
        if not gen_points: continue
        pareto_front = get_pareto_front(gen_points)
        ax.scatter([p['area'] for p in gen_points], [p['power'] for p in gen_points], color=cmap_func(gen), alpha=0.1, s=30)
        if pareto_front:
            ax.plot([p['area'] for p in pareto_front], [p['power'] for p in pareto_front], marker='o', linestyle='-', color=cmap_func(gen), label=f'Gen {gen}' if num_generations <= 10 else None)
    if ref_area is not None and ref_power is not None:
        ax.scatter(ref_area, ref_power, marker='*', s=300, color='gold', edgecolor='black', zorder=5, label='Reference PPA')
    norm = Normalize(vmin=0, vmax=num_generations - 1)
    sm = ScalarMappable(cmap=cmap, norm=norm)
    ticks = np.linspace(0, num_generations - 1, min(11, num_generations), dtype=int)
    cbar = plt.colorbar(sm, ticks=ticks, ax=ax); cbar.set_label('Generation')
    ax.set_xlabel('Area'); ax.set_ylabel('Power'); ax.set_title('Pareto Front Advancement by Generation')
    if num_generations <= 10: ax.legend()
    ax.grid(True, linestyle='--')
    apply_axis_limits(ax, max_area, max_power)
    plt.tight_layout(); plt.savefig(os.path.join(output_dir, "plot2_generational_fronts.png"), dpi=300)
    print(f"Generated {os.path.join(output_dir, 'plot2_generational_fronts.png')}")

def plot_grouped_pareto_fronts(all_data, ref_power, ref_area, groups, group_labels, title, filename, output_dir, max_area=None, max_power=None, cmap_name='viridis'):
    """Generic function to plot grouped Pareto fronts (for plots 3 and 4)."""
    plt.figure(figsize=(12, 8))
    ax = plt.gca()
    cmap = plt.get_cmap(cmap_name, len(groups))
    for i, (group_range, group_label) in enumerate(zip(groups, group_labels)):
        group_points = [p for p in all_data if group_range[0] <= p['generation'] <= group_range[1]]
        if not group_points: continue
        pareto_front = get_pareto_front(group_points)
        ax.scatter([p['area'] for p in group_points], [p['power'] for p in group_points], color=cmap(i), alpha=0.08, s=30)
        if pareto_front:
            ax.plot([p['area'] for p in pareto_front], [p['power'] for p in pareto_front], marker='o', linestyle='-', color=cmap(i), label=group_label)
    if ref_area is not None and ref_power is not None:
        ax.scatter(ref_area, ref_power, marker='*', s=300, color='gold', edgecolor='black', zorder=5, label='Reference PPA')
    ax.set_xlabel('Area'); ax.set_ylabel('Power'); ax.set_title(title)
    ax.legend(); ax.grid(True, linestyle='--')
    apply_axis_limits(ax, max_area, max_power)
    plt.tight_layout(); plt.savefig(os.path.join(output_dir, filename), dpi=300)
    print(f"Generated {os.path.join(output_dir, filename)}")

def plot_highlighted_top_scorers(all_data, ref_power, ref_area, groups, group_labels, title, filename, output_dir, max_area=None, max_power=None, cmap_name='magma'):
    """Plots grouped data, highlighting the top 5 unique-scoring individuals in each group."""
    plt.figure(figsize=(12, 6))
    ax = plt.gca()
    cmap = plt.get_cmap(cmap_name, len(groups))
    for i, (group_range, group_label) in enumerate(zip(groups, group_labels)):
        group_points = [p for p in all_data if group_range[0] <= p['generation'] <= group_range[1]]
        if not group_points: continue
        
        # Find top 5 unique scorers
        sorted_by_score = sorted(group_points, key=lambda p: p.get('score', -float('inf')), reverse=True)
        top_scorers = []
        seen_coords = set()
        for point in sorted_by_score:
            coords = (point['power'], point['area'])
            if coords not in seen_coords:
                top_scorers.append(point)
                seen_coords.add(coords)
            if len(top_scorers) >= 5:
                break
        
        # Plot all points in the group lightly
        ax.scatter([p['area'] for p in group_points], [p['power'] for p in group_points], color=cmap(i), alpha=0.5, s=250, label=f'{group_label} (all)')
        
        # Highlight top 5 scorers
        if top_scorers:
            top_areas = [p['area'] for p in top_scorers]
            top_powers = [p['power'] for p in top_scorers]
            ax.scatter(top_areas, top_powers, marker='D', s=350, color=cmap(i), edgecolor='white', linewidth=1, zorder=4, label=f'{group_label} (Top 5)')

    if ref_area is not None and ref_power is not None:
        ax.scatter(ref_area, ref_power, marker='*', s=500, color='gold', edgecolor='black', zorder=5, label='Reference PPA')
    ax.set_xlabel(r'Area ($\mu$m$^2$)'); ax.set_ylabel('Power (W)'); ax.set_title(title)
    ax.legend(markerscale=0.85, labelspacing=1.2); ax.grid(True, linestyle='--')
    apply_axis_limits(ax, max_area, max_power)
    plt.tight_layout(); plt.savefig(os.path.join(output_dir, filename), dpi=450)
    print(f"Generated {os.path.join(output_dir, filename)}")

def plot_highlighted_top_scorers_alt(all_data, ref_power, ref_area, groups, group_labels, title, filename, output_dir, max_area=None, max_power=None, cmap_name='magma'):
    """(ALT) Plots top scorers with the legend placed outside the plot area."""
    fig, ax = plt.subplots(figsize=(12, 6)) # Use fig, ax for better control
    cmap = plt.get_cmap(cmap_name, len(groups))
    for i, (group_range, group_label) in enumerate(zip(groups, group_labels)):
        group_points = [p for p in all_data if group_range[0] <= p['generation'] <= group_range[1]]
        if not group_points: continue
        
        sorted_by_score = sorted(group_points, key=lambda p: p.get('score', -float('inf')), reverse=True)
        top_scorers = []
        seen_coords = set()
        for point in sorted_by_score:
            coords = (point['power'], point['area'])
            if coords not in seen_coords:
                top_scorers.append(point)
                seen_coords.add(coords)
            if len(top_scorers) >= 5:
                break
        
        ax.scatter([p['area'] for p in group_points], [p['power'] for p in group_points], color=cmap(i), alpha=0.5, s=250, label=f'{group_label} (all)')
        
        if top_scorers:
            top_areas = [p['area'] for p in top_scorers]
            top_powers = [p['power'] for p in top_scorers]
            ax.scatter(top_areas, top_powers, marker='D', s=350, color=cmap(i), edgecolor='white', linewidth=1, zorder=4, label=f'{group_label} (Top 5)')

    if ref_area is not None and ref_power is not None:
        ax.scatter(ref_area, ref_power, marker='*', s=500, color='gold', edgecolor='black', zorder=5, label='Reference PPA')
    
    ax.set_xlabel(r'Area ($\mu$m$^2$)'); ax.set_ylabel('Power (W)'); ax.set_title(title)
    ax.grid(True, linestyle='--')
    apply_axis_limits(ax, max_area, max_power)
    
    # --- EXTERNAL LEGEND PLACEMENT ---
    ax.legend(loc='center left', bbox_to_anchor=(1.02, 0.5), markerscale=0.85, labelspacing=1.2, frameon=False)
    
    # --- SAVE FIGURE ---
    # Use bbox_inches='tight' to ensure the external legend is included in the saved file.
    plt.savefig(os.path.join(output_dir, filename), dpi=450, bbox_inches='tight')
    print(f"Generated {os.path.join(output_dir, filename)}")

def main():
    parser = argparse.ArgumentParser(description="Generate Pareto front and scoring diagrams for evolutionary coding algorithm results.")
    parser.add_argument("--generation_log", default='./exp/deepseek_clean_results/VerilogEval-Spec-to-RTL/Prob033_ece241_2014_q1c/generation_log.jsonl', help="Path to the generation_log.jsonl file.")
    parser.add_argument("--summary_json", default='./exp/deepseek_clean_results/VerilogEval-Spec-to-RTL/Prob033_ece241_2014_q1c/Prob033_ece241_2014_q1c_summary.json', help="Path to the summary JSON file (*_summary.json).")
    parser.add_argument("--max_area", type=float, default=60, help="Set the maximum x-axis (Area) cutoff for all plots.")
    parser.add_argument("--max_power", type=float, default=0.0035, help="Set the maximum y-axis (Power) cutoff for all plots.")
    parser.add_argument("--output_dir", default='VerilogEval_Prob033_ece241_2014_q1c_plots', help="Directory to save the output plots.")

    args = parser.parse_args()


    # --- Create output directory if it doesn't exist ---
    output_dir = args.output_dir
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print(f"Created output directory: {output_dir}")

    all_data, num_generations = load_generation_data(args.generation_log)
    ref_power, ref_area = load_reference_data(args.summary_json)

    if not all_data:
        print("No data loaded from generation log. Exiting."); return
    if ref_power is None or ref_area is None:
        print("Could not load reference PPA. Score-based plots will be skipped."); return
    
    # Calculate score for each data point
    for point in all_data:
        point['score'] = calculate_score(point['power'], point['area'], ref_power, ref_area)

    cmap_generations = plt.get_cmap('viridis')
    
    # --- Original Plots ---
    plot_all_individuals(all_data, ref_power, ref_area, num_generations, cmap_generations, output_dir, args.max_area, args.max_power)
    plot_all_individuals(all_data, ref_power, ref_area, num_generations, cmap_generations, output_dir, name='unbounded')
    plot_generational_pareto_fronts(all_data, ref_power, ref_area, num_generations, cmap_generations, output_dir, args.max_area, args.max_power)

    if num_generations > 4:
        splits = np.linspace(0, num_generations, 5, dtype=int)
        groups = [(splits[i], splits[i+1]-1) for i in range(4)]
        groups[-1] = (groups[-1][0], num_generations - 1)
        group_labels = [f'Gens {g[0]}-{g[1]}' for g in groups]
        plot_grouped_pareto_fronts(all_data, ref_power, ref_area, groups, group_labels, 'Pareto Fronts (4 Equal Groups)', 'plot3_equal_groups.png', output_dir, args.max_area, args.max_power, 'plasma')
        # --- NEW PLOT 5 ---
        plot_highlighted_top_scorers(all_data, ref_power, ref_area, groups, group_labels, 'Top 5 Scorers (4 Equal Groups)', 'plot5_top5_equal_groups.png', output_dir, args.max_area, args.max_power, 'magma')

    if num_generations > 13:
        groups_4 = [(0, 0), (1, 4), (5, 11), (12, num_generations - 1)]
        labels_4 = [f'Gen {g[0]}' if g[0]==g[1] else f'Gens {g[0]}-{g[1]}' for g in groups_4]
        plot_grouped_pareto_fronts(all_data, ref_power, ref_area, groups_4, labels_4, 'Pareto Fronts (Custom Groups 1)', 'plot4_custom_groups1.png', output_dir, args.max_area, args.max_power, 'cividis')
        # --- NEW PLOT 6 ---
        plot_highlighted_top_scorers(all_data, ref_power, ref_area, groups_4, labels_4, 'Top 5 Scorers (Custom Groups 1)', 'plot6_top5_custom_groups1.png', output_dir, args.max_area, args.max_power, 'inferno')

    if num_generations > 12:
        # Define the lists of colormaps to iterate through based on your recommendations
        perceptual_cmaps = ['viridis', 'plasma', 'inferno', 'magma', 'cividis']
        single_hue_cmaps = ['Blues', 'Greens', 'Reds', 'Purples', 'Oranges', 'Greys']
        multi_hue_cmaps = ['YlGnBu', 'YlOrRd', 'PuBuGn', 'BuPu', 'GnBu']
        qualitative_cmaps = ['tab10', 'Paired', 'Set1', 'Set2', 'Set3', 'Pastel1', 'Accent']
        
        # Combine all colormaps into a single list
        cmaps_to_generate = perceptual_cmaps + single_hue_cmaps + multi_hue_cmaps + qualitative_cmaps

        groups_3 = [(0, 4), (5, 11), (12, num_generations - 1)]
        labels_3 = [f'Gens {g[0]}-{g[1]}' for g in groups_3]
        title = 'Top 5 Scorers (VerilogEval-Prob033_ece241_2014_q1c)'
        
        # Loop through the list of colormaps and generate a plot for each one.
        for cmap in cmaps_to_generate:
            # Generate the standard plot with the current colormap
            base_filename = f"plot7_top5_custom_groups2_{cmap}.png"
            plot_highlighted_top_scorers(
                all_data, ref_power, ref_area, groups_3, labels_3, 
                title, base_filename, output_dir, 
                args.max_area, args.max_power, cmap_name=cmap
            )

            # Generate the alternative layout plot with the current colormap
            alt_filename = f"plot7_1_top5_custom_groups2_alt_{cmap}.png"
            plot_highlighted_top_scorers_alt(
                all_data, ref_power, ref_area, groups_3, labels_3, 
                title, alt_filename, output_dir, 
                args.max_area, args.max_power, cmap_name=cmap
            )
if __name__ == "__main__":
    main()