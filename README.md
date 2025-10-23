
-----

# REvolution: An Evolutionary Framework for RTL Generation driven by Large Language Models


**Authors**  
Kyungjun Min\*, Kyumin Cho\*, Junhwan Jang, and Seokhyeong Kang

**Affiliation**  
Department of Electrical Engineering, Pohang University of Science and Technology (POSTECH)  
Pohang, Republic of Korea  
{kj.min, kmcho, jhjang17, shkang}@postech.ac.kr

**Laboratory**  
CAD & SoC Design Lab. (Advisor: Seokhyeong Kang), POSTECH, Republic of Korea  
<http://csdl.postech.ac.kr/>

\* These authors contributed equally to this work.

**Acknowledgments**  
This research was supported by the nanomaterials development program through the National Research Foundation of Korea (NRF) (2022M3H4A1A04096496) funded by the Ministry of Science and ICT, Korea, and by LX Semicon.

-----

## 📜 Abstract


Large Language Models (LLMs) are used for Register-Transfer Level (RTL) code generation, but they face two main challenges: functional correctness and Power, Performance, and Area (PPA) optimization. 
Iterative, feedback-based methods partially address these, but they are limited to local search, hindering the discovery of a global optimum.
This paper introduces REvolution, a framework that combines Evolutionary Computation (EC) with LLMs for automatic RTL generation and optimization. 
REvolution evolves a population of candidates in parallel, each defined by a design strategy, RTL implementation, and evaluation feedback. 
The framework includes a dual-population algorithm that divides candidates into Fail and Success groups for bug fixing and PPA optimization, respectively.
An adaptive mechanism further improves search efficiency by dynamically adjusting the selection probability of each prompt strategy according to its success rate.
Experiments on the VerilogEval and RTLLM benchmarks show that REvolution increased the initial pass rate of various LLMs by up to 24.0 percentage points. 
The DeepSeekV3 model achieved a final pass rate of 95.5\%, comparable to state-of-the-art results, without the need for separate training or domain-specific tools. 
Additionally, the generated RTL designs showed significant PPA improvements over reference designs. 
This work introduces a new RTL design approach by combining LLMs' generative capabilities with EC's broad search power, overcoming the local-search limitations of previous methods.

-----

## 📂 Repository Structure

The repository is organized as follows:

  - `src/revolution/`: The core Python package containing the **REvolution** framework.
    - `algorithm.py`: Implements the main evolutionary engine, including population management, selection, and the dual-pool strategy.
    - `evaluation.py`: Contains the `VerilogEvaluator` (for Icarus Verilog simulation) and `SynthesisEvaluator` (for Yosys/OpenROAD PPA analysis).
    - `llm.py`: Provides a unified `LLMInterface` for interacting with various LLM backends (OpenAI, OpenRouter, etc.).
    - `logging.py`:  Manages detailed generation-by-generation logging and final summary reports.
  - `scripts/`: Contains executable scripts for running experiments and generating reports.
    - `run_evolution.py`: The main entry point to run the REvolution framework.
    - `evolutionary_report_generator.py`: Generates detailed reports from experiment logs.
  - `data/`: Contains benchmark problems (`bench/`) and the Process Design Kit (`pdk/`).
  - `exp/`: The default output directory for experimental results and logs.
      - `./exp/llama3_clean_results/`: Results from the REvolution run using Llama-3.3-70B.
      - `./exp/llama3_baseline_clean_results/`: Baseline results for Llama-3.3-70B (pass@200) without the evolutionary framework.
      - `./exp/gpt-4.1-mini_clean_results/`: Results from the REvolution run using GPT-4.1-mini.
      - `./exp/deepseek_clean_results/`: Results from the REvolution run using DeepSeek-V3-0324.
-----

---

## ⚙️ Setup with Docker (Recommended)

To ensure a consistent and reproducible environment, we recommend using Docker. The provided `Dockerfile` automates the installation of all specific tool versions and dependencies.

### 1. Prerequisites

Make sure you have **Docker** installed on your system. You can find installation instructions on the [official Docker website](https://docs.docker.com/get-docker/).



### 2. Build the Docker Image

Navigate to the root directory of this repository (where the `Dockerfile` is located) and run the following command to build the Docker image. This process will take some time as it compiles all the necessary EDA tools from the source.

```bash
docker build -t revolution-env .
```

After the build completes, you'll have a Docker image named `revolution-env` with all the required dependencies.

### 3. Run the Docker Container

To start an interactive session inside the container, use the command below. This command mounts your current project directory into the container's `/workspace` and passes your LLM API keys as environment variables.

```bash
docker run --rm -it \
  -e OPENAI_API_KEY="your-key-for-openai" \
  -e DEEPSEEK_API_KEY="your-key-for-deepseek" \
  -e OPENROUTER_API_KEY="your-key-for-openrouter" \
  revolution-env
```

You are now inside the container's shell, with the Python environment activated and all tools ready to use.

---

## ⚙️ Setup and Installation

Follow these steps to set up the required environment.

### 1\. System Dependencies

First, ensure you have the following tools installed and available in your system's `PATH`. The versions used in our experiments are specified below:

  - **Yosys**: `0.54+29`
  - **Icarus Verilog**: `v12_0`
  - **OpenROAD**: `v2.0-22560-gb571c4b471`

### 2\. Python Environment

The Python environment is managed using `uv`.

1.  **Install uv**: If you don't have `uv`, install it by following the official instructions.
2.  **Create Virtual Environment**: Run the following command in the repository root to create and sync the virtual environment using the provided lock file.
    ```bash
    uv sync
    ```
3.  **Activate Environment**: Activate the newly created environment.
    ```bash
    source .venv/bin/activate
    ```

### 3\. LLM API Configuration

The framework supports multiple LLM backends.

  - **External APIs (OpenAI, DeepSeek, OpenRouter)**: Set the appropriate environment variable with your API key.
    ```bash
    # For OpenAI
    export OPENAI_API_KEY="your-key-here"

    # For DeepSeek
    export DEEPSEEK_API_KEY="your-key-here"

    # For OpenRouter
    export OPENROUTER_API_KEY="your-key-here"
    ```
  - **Local vLLM Server**: If you're using a local vLLM instance, ensure it's running and accessible at `http://localhost:8000/v1`. No API key is needed for this setup.

-----

## 🚀 Running Experiments

The following commands can be used to reproduce the experiments presented in the paper. Adjust the `--num_workers` argument based on your available computing resources.

### Baseline Run (Llama-3.3-70B)

This command runs the baseline experiment without the evolutionary framework to calculate pass@200.

```bash
python3 scripts/run_evolution.py \
    --strategy_selection ucb \
    --api_backend openrouter \
    --model_name meta-llama/llama-3.3-70b-instruct \
    --num_workers 32 \
    --num_generations 0 \
    --benchmarks VerilogEval-Spec-to-RTL RTLLM \
    --max_tokens 4096 \
    --temperature 1.0 \
    --top_p 0.95 \
    --population_size 200
```

### REvolution Runs

These commands execute the REvolution framework for different models.

**Llama-3.3-70B-Instruct**

```bash
python3 scripts/run_evolution.py \
    --strategy_selection ucb \
    --api_backend openrouter \
    --model_name meta-llama/llama-3.3-70b-instruct \
    --num_workers 48 \
    --num_generations 20 \
    --benchmarks VerilogEval-Spec-to-RTL \
    --max_tokens 4096 \
    --temperature 1.0 \
    --top_p 0.95 \
    --population_size 10
```

**DeepSeek-V3-0324**

```bash
python3 scripts/run_evolution.py \
    --strategy_selection ucb \
    --api_backend deepseek \
    --model_name deepseek-chat \
    --num_workers 20 \
    --num_generations 20 \
    --benchmarks RTLLM VerilogEval-Spec-to-RTL \
    --max_tokens 4096 \
    --temperature 1.0 \
    --top_p 0.95 \
    --population_size 10
```

**GPT-4.1-mini**

```bash
python3 scripts/run_evolution.py \
    --strategy_selection ucb \
    --model_name gpt-4.1-mini \
    --num_workers 32 \
    --num_generations 20 \
    --benchmarks RTLLM VerilogEval-Spec-to-RTL \
    --max_tokens 4096 \
    --temperature 1.0 \
    --top_p 0.95 \
    --population_size 10
```

-----

## 📊 Generating Reports

After running the experiments, you can generate reports to view the results.

### Individual Run Report

To generate a detailed markdown report for a specific experimental run, use the `evolutionary_report_generator.py` script. This report includes PPA metrics but does **not** apply the gate-level cutoff used in the paper.

```bash
python scripts/evolutionary_report_generator.py \
    --experiment_path ./exp/deepseek_clean_results \
    --save_markdown
```

This will save a report named `(benchmark_name)_evolutionary_report.md` inside the specified experiment directory.

### Final Paper Results

To generate the final, PPA-filtered results as reported in our paper, run the following shell script. It applies a gate count (50) cutoff to filter the results.

```bash
./scripts/generate_cutoff_compile_result_variants.sh --gate 50
```

This will create a `compile_results_gate_cutoff_50.md` file in the base directory, containing the table of results presented in the paper.

### PPA Scatterplot

To recreate the PPA scatterplot for the `VerilogEval-Spec-to-RTL/Prob033_ece241_2014_q1c` problem, run the following script:

```bash
python3 scripts/plot_problem_pareto.py
```

This script will generate the plots and save them in a newly created directory named `VerilogEval_Prob033_ece241_2014_q1c_plots`.

### 📚 Cite this work
```bibtex
@inproceedings{min2026revolution,
  title        = {REvolution: An Evolutionary Framework for RTL Generation driven by Large Language Models},
  author       = {Kyungjun Min, Kyumin Cho, Junhwan Jang, and Seokhyeong Kang},
  booktitle    = {31st Asia and South Pacific Design Automation Conference (ASP-DAC 2026)},
  year         = {2026}
}