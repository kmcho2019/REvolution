# REvolution: An Evolutionary Framework for RTL Generation driven by Large Language Models

Kyungjun Min $ ^{*} $, Kyumin Cho $ ^{*} $, Junhwan Jang, and Seokhyeong Kang

Department of Electrical Engineering, Pohang University of Science and Technology

Pohang, Republic of Korea

{kj.min, kmcho, jhjang17, shkang}@postech.ac.kr

Abstract—Large Language Models (LLMs) are used for Register-Transfer Level (RTL) code generation, but they face two main challenges: functional correctness and Power, Performance, and Area (PPA) optimization. Iterative, feedback-based methods partially address these, but they are limited to local search, hindering the discovery of a global optimum. This paper introduces REvolution, a framework that combines Evolutionary Computation (EC) with LLMs for automatic RTL generation and optimization. REvolution evolves a population of candidates in parallel, each defined by a design strategy, RTL implementation, and evaluation feedback. The framework includes a dual-population algorithm that divides candidates into Fail and Success groups for bug fixing and PPA optimization, respectively. An adaptive mechanism further improves search efficiency by dynamically adjusting the selection probability of each prompt strategy according to its success rate. Experiments on the VerilogEval and RTLLM benchmarks show that REvolution increased the initial pass rate of various LLMs by up to 24.0 percentage points. The DeepSeek-V3 model achieved a final pass rate of 95.5%, comparable to state-of-the-art results, without the need for separate training or domain-specific tools. Additionally, the generated RTL designs showed significant PPA improvements over reference designs. This work introduces a new RTL design approach by combining LLMs' generative capabilities with EC's broad search power, overcoming the local-search limitations of previous methods.

## I. INTRODUCTION

The growing complexity of modern integrated circuits has made manual Register-Transfer Level (RTL) design a significant bottleneck, prone to increased time, cost, and errors  $ [1] $. In response, Large Language Models (LLMs) have recently been explored within Electronic Design Automation (EDA) research to generate Hardware Description Language (HDL) directly from natural-language specifications  $ [2] $.

However, directly applying LLMs to RTL design presents two key challenges. First, functional correctness remains a major hurdle. LLMs are predominantly trained on sequential software code, and thus struggle with the concurrent nature of HDL [3]. This creates a performance ceiling: on the VerilogEval-Human benchmark [4], state-of-the-art models such as Claude3.7-Sonnet, OpenAI o3, and DeepSeek-R1 attain only  $ \sim80\% $ pass@1 accuracy [5]. Second, standard LLMs lack awareness of post-synthesis metrics. This results from their training being confined to HDL source code, excluding post-synthesis reports on Power, Performance, and Area (PPA) [6]. As a result, the generated designs are often PPA-suboptimal, necessitating numerous, inefficient design and synthesis iterations to meet specific targets.

To address these challenges, recent studies have introduced several promising approaches. Frameworks such as MAGE [7] and AIVRIL2 [8] employ iterative, agent-based workflows with EDA tool feedback to automatically correct functional errors. Similarly, to address PPA, approaches like PPA-RTL [6] and VeriPPA [9] incorporate post-synthesis metrics as feedback. PPA-RTL, for instance, uses Reinforcement Learning (RL) to guide this optimization. However, these feedback-driven, iterative methods share a common limitation: they perform a local search of the design space. Their focus on refining an initial design candidate makes the final output's quality highly dependent on the starting point. Consequently, if the initial implementation strategy is suboptimal, these methods risk getting trapped in a local optimum, failing to discover globally superior design alternatives. This necessitates a methodology capable of exploring a broad space of implementations, rather than merely refining a few design candidates.

To overcome these limitations, this paper proposes REvolution, a framework that integrates Evolutionary Computation (EC) with LLMs for automatic RTL code generation. At its core, REvolution evolves a population of design candidates, where each is defined by a design strategy (Thought), its corresponding RTL implementation (Code), and evaluation feedback. To guide this evolutionary process efficiently, the framework employs two key approaches. First, a dual-population algorithm segregates candidates into 'Fail' and 'Success' populations, applying tailored strategies for bug fixing and PPA optimization, respectively. Second, an adaptive selection mechanism dynamically updates the probability of each prompt strategy based on its success, ensuring computational resources are prioritized effectively. Using these approaches, REvolution can systematically explore the design space, moving beyond the local-search limitations of prior work to find functionally correct and PPA-optimized RTL code. The contributions of this work are summarized as follows:

• Evolutionary Framework for RTL Generation and Optimization: We introduce REvolution, the first framework to our knowledge that integrates the generative capabilities of LLMs with EC for RTL design. This approach moves beyond the local-search limitations of prior methods by enabling a parallel exploration of the design space for functionally correct and PPA-optimized RTL.

• Dual-Population Algorithm: We propose a dual-population algorithm that segregates candidates into Success and Fail populations based on their functional correctness. This approach enhances search efficiency by applying heterogeneous evolutionary strategies tailored to the distinct goals of each population: bug fixing for the Fail population and PPA optimization for the Success population.

• Adaptive Prompt Strategy Selection: We introduce a self-adaptive mechanism where the selection probability of each prompt strategy is dynamically updated based on its success. This allows REvolution to intelligently allocate computational resources by prioritizing more effective prompt strategies, significantly enhancing overall search efficiency.

The remainder of this paper is organized as follows. Section II covers the background. Section III details the REvolution framework. Section IV presents the experimental results. Finally, Section V concludes the paper.

## II. BACKGROUND

### A. LLMs for RTL Generation

Research on RTL code generation using LLMs can be broadly categorized into four key areas: data generation and augmentation [1], [10]–[17], model and fine-tuning optimization [1], [3], [5], [6], [10], [12], [15], prompt engineering [3], [5], [18], and framework development [7]–[9], [11], [19], [20]. Each of these areas addresses different challenges in improving the quality and efficiency of RTL generation.

A major challenge in this field is the lack of high-quality, domain-specific datasets. To address this, OriGen [11] proposes a “Code-to-Code” augmentation technique that refines open-source code using a teacher LLM based on newly generated descriptions. VeriLogos [15] modifies the Abstract Syntax Tree (AST) of the code to create new synthetic data. In addition to dataset enhancement, optimizing the model and fine-tuning it to embed a deeper understanding of hardware-specific characteristics is crucial. PPA-RTL [6] uses RL to directly optimize the model for post-synthesis PPA metrics. BetterV [1] combines a generative model with a discriminator that guides the output to optimize for specific EDA tasks.

Prompt engineering is crucial for enhancing an LLM’s reasoning without the need for expensive retraining. Abstractions-of-Thought [18] introduces a structured three-stage prompting framework ('classification - intermediate representation - pseudocode') to guide the LLM’s reasoning hierarchically. ReasoningV [3] uses an adaptive reasoning mechanism that adjusts the inference depth based on problem complexity to improve efficiency. Finally, framework development enhances RTL generation through systematic methods such as multiagent or iterative feedback loops. MAGE [7] employs a multiagent system where specialized agents handle RTL generation, testbench creation, and debugging. VeriPPA [9] uses a multiround feedback loop that incorporates outputs from simulators and PPA reports into the next prompt, iteratively refining the code until it meets the target.

These approaches have improved the accuracy of LLM-based RTL generation, with some even advancing to PPA optimization. However, they lack a methodology for exploring a broad design space. Fine-tuned models may be biased toward specific answers, and feedback-based frameworks focus on refining a few solutions rather than exploring many alternatives. To address this gap, REvolution combines LLMs and EC to efficiently explore the design space for functionally correct and PPA-optimal RTL designs.

### B. Integrating LLMs and Evolutionary Computation

Recently, combining LLM code generation with EC search methods has become a key research area  $ [21]-[23] $. This approach focuses on discovering verifiable algorithms that are challenging for standalone LLMs to generate, by searching

<div style="text-align: center;">TABLE I: Summary of Terminology and Hyperparameter</div>



<table border=1 style='margin: auto; word-wrap: break-word;'><tr><td style='text-align: center; word-wrap: break-word;'>Term/Symbol</td><td style='text-align: center; word-wrap: break-word;'>Description</td></tr><tr><td colspan="2">Core Concepts</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Population</td><td style='text-align: center; word-wrap: break-word;'>Set of individuals representing design candidates.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Individual</td><td style='text-align: center; word-wrap: break-word;'>Single design candidate, represented as a (Thought, Code, Feedback) tuple.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Fitness</td><td style='text-align: center; word-wrap: break-word;'>Score measuring an individual&#x27;s quality.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Offspring</td><td style='text-align: center; word-wrap: break-word;'>New individual created from selected parents.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Parent(s)</td><td style='text-align: center; word-wrap: break-word;'>Selected individuals from the current population that produce offspring.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Thought</td><td style='text-align: center; word-wrap: break-word;'>High-level design strategy in natural language.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Code</td><td style='text-align: center; word-wrap: break-word;'>Verilog RTL implementation of a Thought.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Feedback</td><td style='text-align: center; word-wrap: break-word;'>LLM-generated analysis of Code&#x27;s evaluation results.</td></tr><tr><td colspan="2">Evolutionary Algorithm</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>N</td><td style='text-align: center; word-wrap: break-word;'>Total number of individuals in the population.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>$ \lambda $</td><td style='text-align: center; word-wrap: break-word;'>Number of offspring generated per generation.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>n</td><td style='text-align: center; word-wrap: break-word;'>Number of elite individuals preserved per PPA metric.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>G</td><td style='text-align: center; word-wrap: break-word;'>Maximum number of generations for termination.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>$ \alpha, \beta, \gamma $</td><td style='text-align: center; word-wrap: break-word;'>Weights for the PPA objectives in the fitness function.</td></tr><tr><td colspan="2">Adaptive Strategy Selection</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>R</td><td style='text-align: center; word-wrap: break-word;'>Reward for a given prompt strategy.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Q(i)</td><td style='text-align: center; word-wrap: break-word;'>Average reward (action-value) for strategy i.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>c</td><td style='text-align: center; word-wrap: break-word;'>Exploration parameter for the UCB algorithm.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>$ \tau $</td><td style='text-align: center; word-wrap: break-word;'>Softmax selection temperature.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>T</td><td style='text-align: center; word-wrap: break-word;'>Total number of prompt strategy selections.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>k_i</td><td style='text-align: center; word-wrap: break-word;'>Selection count for a specific strategy i.</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>M</td><td style='text-align: center; word-wrap: break-word;'>Number of available prompt strategies.</td></tr></table>

for programs (or functions) that produce solutions, rather than the solutions themselves. FunSearch [21] evolves a specific function within a program skeleton. AlphaEvolve [22] extends this by evolving entire code files, enabling the modification of complex algorithms. In contrast, EoH [23] evolves not only code but also ‘Thoughts’ (natural language descriptions of heuristic ideas). This dual representation, combined with systematic prompt strategies, aims to generate high-performance heuristics more efficiently.

However, the direct application of these approaches to the RTL generation domain faces distinct challenges. Whereas a typical heuristic search is evaluated on a single-objective score, RTL generation is a multi-objective optimization problem that requires satisfying functional correctness while considering the complex trade-offs between PPA. Therefore, to address this research gap, REvolution enhances search efficiency by employing a dual-population strategy that separates individuals based on their functional correctness. Furthermore, it directly utilizes evaluation feedback in the evolutionary process to effectively guide the exploration of the design space.

## III. METHODOLOGY

### A. Overview

Revolution integrates LLMs with EC to automatically generate functionally correct and PPA-optimized RTL code. Exploring and evolving a population of design candidates in parallel reduces dependency on the initial design, mitigating the risk of local optima and enabling efficient exploration of a broader design space. Figure 1 illustrates the overall flow of the framework. The process begins with an Initialization, where an LLM creates an initial population of diverse design candidates. This is followed by the Evolutionary Loop, which evolves the design candidates by evaluating them, generating offspring through prompt strategies, and selecting the fittest for the next generation. This cycle repeats until a termination condition is met, and the framework returns the best RTL code.

<div style="text-align: center;"><img src="https://pplines-online.bj.bcebos.com/deploy/official/paddleocr/pp-ocr-vl-15//24803451-fe0b-4382-a84b-403b0643802e/markdown_2/imgs/img_in_image_box_125_148_1003_530.jpg?authorization=bce-auth-v1%2FALTAKzReLNvew3ySINYJ0fuAMN%2F2026-02-02T13%3A24%3A55Z%2F-1%2F%2F6f71cf21e2c4eb489a63c7e93720d7ca6bc43ba61ca0cc0af8068a7acfe843f2" alt="Image" width="73%" /></div>


<div style="text-align: center;">Fig. 1: Overall framework of the REvolution. The framework initializes a population from a specification (functional description) and refines it through an evolutionary loop of offspring generation, evaluation, and survivor selection until termination.</div>


<div style="text-align: center;"><img src="https://pplines-online.bj.bcebos.com/deploy/official/paddleocr/pp-ocr-vl-15//24803451-fe0b-4382-a84b-403b0643802e/markdown_2/imgs/img_in_image_box_98_625_558_839.jpg?authorization=bce-auth-v1%2FALTAKzReLNvew3ySINYJ0fuAMN%2F2026-02-02T13%3A24%3A55Z%2F-1%2F%2Ff5ca56af8bdd0456f6fcc3d7e53a57ef2c772f378587a6522d6d49e20300958c" alt="Image" width="38%" /></div>


<div style="text-align: center;">Fig. 2: Structure of Individual. Individual is a (Thought, Code, Feedback) tuple, with Feedback generated based on the Code’s functional correctness.</div>


found. The terminology and hyperparameters of our framework are summarized in Table I. The following sections detail the core components of our framework, including the evolutionary representation III-B, the dual-population algorithm III-C, prompt strategies III-D, and adaptive prompt strategy selection III-E, before concluding with a description of the complete REvolution algorithm III-F.

### B. Evolutionary Representation

The fundamental unit of evolution is the individual, which is defined as a (Thought, Code, Feedback) tuple (Figure 2). The Thought is a natural language description representing the high-level design strategy. The Code is the Verilog RTL implementation derived from the Thought. The Feedback is a natural language summary dynamically generated by an LLM that analyzes the Code's evaluation results. If the Code fails simulation, the LLM analyzes error logs to generate bug-fixing feedback. If the Code is correct, the LLM reviews PPA reports and suggests possible improvements.

Furthermore, to quantitatively evaluate each individual, we define a fitness score. Functionally incorrect individuals are assigned a uniform score of  $ -\infty $, ensuring they are always ranked below any successful candidate during survivor selection. Conversely, for functionally correct individuals, the fitness score is calculated as follows:

 $$ \mathrm{F}_{g e n}=\alpha\left(\frac{P_{r e f}-P_{g e n}}{P_{r e f}}\right)+\beta\left(\frac{A_{r e f}-A_{g e n}}{A_{r e f}}\right)+\gamma\left(\frac{T_{r e f}-T_{g e n}}{T_{r e f}}\right) $$ 

The variables P, A, and T represent power, area, and effective clock period for the generated (gen) and reference (ref) designs, with each objective weighted by the user-defined coefficients  $ \alpha $,  $ \beta $, and  $ \gamma $.

### C. Dual-Population Algorithm

In each generation, the dual-population algorithm divides the population into two sub-populations: the Fail population (functionally incorrect individuals) and the Success population (functionally correct individuals). By segregating the population, we apply heterogeneous strategies (detailed in Section III-D and III-E) to target the distinct goals of each sub-population: functional correctness for the Fail population and PPA optimization for the Success population. The dual-population algorithm adjusts offspring generation based on sub-population size, directing more effort to the larger subpopulation to address the pressing challenge. The number of offspring is directly proportional to the relative size of each subpopulation in the current generation. For example, with  $ \lambda $ total offspring and a 7:3 Fail-to-Success ratio, the Fail and Success populations will generate  $ 0.7\lambda $ and  $ 0.3\lambda $ offspring, respectively.

### D. Prompt Strategies

The generation of new individuals is driven by a series of prompts that serve as the genetic operators for our framework. These prompts are categorized into two types. The Initial Prompt, containing only the user-provided functional description, is used just once during the Initialization stage to generate the initial population. In contrast, the Evolutionary Prompts are used repeatedly within the Evolutionary Loop to create new offspring from existing individuals. Each Evolutionary Prompt combines the objective, functional description, and the (Thought, Code, Feedback) from selected parents to instruct the LLM to generate a new Thought and Code pair for a new individual (Figure 3). The following are descriptions of six prompt strategies:

• Fix: Corrects functional errors in a single parent’s Thought and Code based on the provided Feedback.

• Simplify: Reduces the complexity of a single parent's Thought and Code to escape from complex or erroneous design states.

- Explore: Generates a completely new and different Thought and its corresponding Code from a single parent to enhance the diversity of the population.

• Refactor: Maintains the original Thought from a single parent but re-implements the Code in a structurally different way.

• Improve: Makes general enhancements to a single parent’s Thought and Code to improve its overall quality and performance.

• Fusion: Merges the Thoughts and Codes of two successful parent individuals, aiming to create a new offspring that inherits the strengths of both.

These prompt strategies are applied heterogeneously to the Fail and Success populations. Both groups utilize Simplify, Explore, Refactor, and Improve. However, the Fail population additionally uses the Fix operator to correct errors, while the Success population instead uses the Fusion operator to combine proven, successful designs.

### E. Adaptive Prompt Strategy Selection

The prompt strategy selection is based on a multi-armed bandit problem, where each strategy represents an “arm” [24]. Reward  $ (R) $ is given for generating a functionally correct design (Fail population) or improving fitness score (Success population). The Upper Confidence Bound (UCB) algorithm calculates the strategy score for each strategy i as follows:

 $$ \mathbf{S core}(i)=Q(i)+c\sqrt{\frac{\ln T}{k_{i}}} $$ 

Here,  $ Q(i) $ is the average reward for strategy i,  $ k_i $ is its selection count, T is the total number of selections, and c is the exploration parameter. After the  $ k_i $-th use of a strategy, its action-value  $ Q(i) $ is updated with an incremental average:

 $$ Q_{k_{i}+1}(i)=Q_{k_{i}}(i)+\frac{1}{k_{i}}[R_{k_{i}}-Q_{k_{i}}(i)] $$ 

where  $ R_{k_i} $ is the reward received for the k-th use of the strategy i. To prevent premature convergence, we use the scores to generate a probability distribution via the softmax function:

 $$ P(i)=\frac{\exp(\mathbf{Score}(i)/\tau)}{\sum_{j=1}^{M}\exp(\mathbf{Score}(j)/\tau)} $$ 

where  $ \tau $ is the temperature parameter and M is the number of available prompt strategies. This hybrid UCB-Softmax approach facilitates both adaptive learning and effective exploration.

### F. The REvolution Algorithm

The REvolution framework consists of three main stages: Initialization, the Evolutionary Loop, and Termination (Figure 1).

In the Initialization stage, an initial population of size N is generated using the Initial Prompt. Each individual is then evaluated through simulation and synthesis. Based on the simulation result, individuals are classified into either a Success population or a Fail population. In this process, the fitness score and feedback for each individual are also computed and stored.

<div style="text-align: center;"><img src="https://pplines-online.bj.bcebos.com/deploy/official/paddleocr/pp-ocr-vl-15//24803451-fe0b-4382-a84b-403b0643802e/markdown_3/imgs/img_in_image_box_632_142_1089_406.jpg?authorization=bce-auth-v1%2FALTAKzReLNvew3ySINYJ0fuAMN%2F2026-02-02T13%3A24%3A55Z%2F-1%2F%2F2b4abeed8b1d2128eeb92a44927fb015d879f043580a329221353bccd5af0d2a" alt="Image" width="38%" /></div>


<div style="text-align: center;">Fig. 3: Example of an Evolutionary Prompt. The available prompt strategies vary depending on the population, and each prompt is constructed from a general template.</div>


Following initialization, the framework evolves the population by iterating through the Evolutionary Loop. This loop comprises three steps: offspring generation, offspring evaluation, and survivor selection. The first step, offspring generation, produces  $ \lambda $ new individuals. A prompt strategy is initially selected via an adaptive mechanism. Subsequently, parents are chosen from their respective sub-populations. For the Fail population, where individuals have identical fitness scores, parents are selected randomly. For the Success population, however, roulette wheel selection is employed, making an individual's selection probability proportional to its fitness. In the second step, offspring evaluation, each new offspring is assessed to compute its fitness score and feedback. This evaluation measures the success of the applied prompt strategy, updating its selection probability for future generations. The final step, survivor selection, determines the N individuals for the succeeding generation. Initially, the top n individuals for each of the three PPA metrics from the parent population are preserved. The remaining  $ N - 3n $ slots are then populated by the fittest individuals from a combined population of parents and offspring. The new population is re-segregated into Fail and Success sub-populations based on functional correctness for the next iteration.

The Termination stage is reached after a predefined number of generations (G). Finally, the framework outputs the Thought, Code, and PPA results of the individual with the highest fitness score recorded across all generations.

## IV. EXPERIMENTAL RESULTS

### A. Experimental Setup

We evaluated our framework using GPT-4.1-mini (2025-04-14) [25], DeepSeek-V3 (0324) [26], and Llama-3.3-70B [27], all accessed via API with a temperature of 1.0 and top-p of 0.95. The hyperparameters were configured as follows: a population size (N) of 10, an offspring count (λ) of 10 per generation, a maximum of 20 generations (G)¹, an elite count (n) of 1, a reward (R) of 1, and exploration hyperparameters (c, τ) set to (2.0, 1.0). Fitness weights (α, β, γ) were set to (1/2, 1/2, 0) for combinational circuits and (1/3, 1/3, 1/3) for sequential ones. The experiments were conducted on the VerilogEvalV2 (Spec-to-RTL) [28] and RTLLM-2.0 benchmarks [29]. We used Icarus Verilog (iverilog) [30] for simulation and Yosys [31]

<div style="text-align: center;">TABLE II: Performance Comparison of REvolution and Baselines</div>



<table border=1 style='margin: auto; word-wrap: break-word;'><tr><td rowspan="2">Model</td><td rowspan="2">Benchmark</td><td colspan="3">Pass Rate (%)</td><td colspan="3">Avg PPA Improv. (%)</td><td rowspan="2">Avg Runtime (s)</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>Init*</td><td style='text-align: center; word-wrap: break-word;'>Final</td><td style='text-align: center; word-wrap: break-word;'>( $ \Delta $)</td><td style='text-align: center; word-wrap: break-word;'>Area</td><td style='text-align: center; word-wrap: break-word;'>Power</td><td style='text-align: center; word-wrap: break-word;'>Eff. Clk</td></tr><tr><td rowspan="2">REvolution (DeepSeek-V3)</td><td style='text-align: center; word-wrap: break-word;'>RTLLM</td><td style='text-align: center; word-wrap: break-word;'>64.0</td><td style='text-align: center; word-wrap: break-word;'>88.0</td><td style='text-align: center; word-wrap: break-word;'>+24.0</td><td style='text-align: center; word-wrap: break-word;'>27.9</td><td style='text-align: center; word-wrap: break-word;'>51.4</td><td style='text-align: center; word-wrap: break-word;'>23.6</td><td style='text-align: center; word-wrap: break-word;'>1990</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>VerilogEval</td><td style='text-align: center; word-wrap: break-word;'>83.3</td><td style='text-align: center; word-wrap: break-word;'>95.5</td><td style='text-align: center; word-wrap: break-word;'>+12.2</td><td style='text-align: center; word-wrap: break-word;'>5.4</td><td style='text-align: center; word-wrap: break-word;'>24.5</td><td style='text-align: center; word-wrap: break-word;'>13.6</td><td style='text-align: center; word-wrap: break-word;'>1515</td></tr><tr><td rowspan="2">REvolution (GPT-4.1-mini)</td><td style='text-align: center; word-wrap: break-word;'>RTLLM</td><td style='text-align: center; word-wrap: break-word;'>70.0</td><td style='text-align: center; word-wrap: break-word;'>86.0</td><td style='text-align: center; word-wrap: break-word;'>+16.0</td><td style='text-align: center; word-wrap: break-word;'>26.5</td><td style='text-align: center; word-wrap: break-word;'>44.2</td><td style='text-align: center; word-wrap: break-word;'>15.3</td><td style='text-align: center; word-wrap: break-word;'>1165</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>VerilogEval</td><td style='text-align: center; word-wrap: break-word;'>82.1</td><td style='text-align: center; word-wrap: break-word;'>94.2</td><td style='text-align: center; word-wrap: break-word;'>+12.1</td><td style='text-align: center; word-wrap: break-word;'>6.0</td><td style='text-align: center; word-wrap: break-word;'>45.6</td><td style='text-align: center; word-wrap: break-word;'>17.1</td><td style='text-align: center; word-wrap: break-word;'>785</td></tr><tr><td rowspan="2">REvolution (Llama-3.3-70B)</td><td style='text-align: center; word-wrap: break-word;'>RTLLM</td><td style='text-align: center; word-wrap: break-word;'>60.0</td><td style='text-align: center; word-wrap: break-word;'>84.0</td><td style='text-align: center; word-wrap: break-word;'>+24.0</td><td style='text-align: center; word-wrap: break-word;'>28.7</td><td style='text-align: center; word-wrap: break-word;'>67.0</td><td style='text-align: center; word-wrap: break-word;'>13.2</td><td style='text-align: center; word-wrap: break-word;'>1605</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>VerilogEval</td><td style='text-align: center; word-wrap: break-word;'>67.3</td><td style='text-align: center; word-wrap: break-word;'>88.5</td><td style='text-align: center; word-wrap: break-word;'>+21.2</td><td style='text-align: center; word-wrap: break-word;'>4.3</td><td style='text-align: center; word-wrap: break-word;'>47.3</td><td style='text-align: center; word-wrap: break-word;'>48.2</td><td style='text-align: center; word-wrap: break-word;'>1459</td></tr><tr><td rowspan="2">Baseline (Llama-3.3-70B)</td><td style='text-align: center; word-wrap: break-word;'>RTLLM</td><td style='text-align: center; word-wrap: break-word;'>70.0</td><td style='text-align: center; word-wrap: break-word;'>-</td><td style='text-align: center; word-wrap: break-word;'>-</td><td style='text-align: center; word-wrap: break-word;'>15.9</td><td style='text-align: center; word-wrap: break-word;'>37.3</td><td style='text-align: center; word-wrap: break-word;'>2.4</td><td style='text-align: center; word-wrap: break-word;'>386</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>VerilogEval</td><td style='text-align: center; word-wrap: break-word;'>79.5</td><td style='text-align: center; word-wrap: break-word;'>-</td><td style='text-align: center; word-wrap: break-word;'>-</td><td style='text-align: center; word-wrap: break-word;'>3.4</td><td style='text-align: center; word-wrap: break-word;'>7.7</td><td style='text-align: center; word-wrap: break-word;'>2.3</td><td style='text-align: center; word-wrap: break-word;'>658</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>VerilogCoder [34] (Llama-3-70B)</td><td style='text-align: center; word-wrap: break-word;'>VerilogEval</td><td style='text-align: center; word-wrap: break-word;'>N/A</td><td style='text-align: center; word-wrap: break-word;'>67.3</td><td style='text-align: center; word-wrap: break-word;'>-</td><td style='text-align: center; word-wrap: break-word;'>N/A</td><td style='text-align: center; word-wrap: break-word;'>N/A</td><td style='text-align: center; word-wrap: break-word;'>N/A</td><td style='text-align: center; word-wrap: break-word;'>N/A</td></tr><tr><td style='text-align: center; word-wrap: break-word;'>VerilogCoder [34] (GPT-4-Turbo)</td><td style='text-align: center; word-wrap: break-word;'>VerilogEval</td><td style='text-align: center; word-wrap: break-word;'>N/A</td><td style='text-align: center; word-wrap: break-word;'>94.2</td><td style='text-align: center; word-wrap: break-word;'>-</td><td style='text-align: center; word-wrap: break-word;'>N/A</td><td style='text-align: center; word-wrap: break-word;'>N/A</td><td style='text-align: center; word-wrap: break-word;'>N/A</td><td style='text-align: center; word-wrap: break-word;'>N/A</td></tr></table>

 $ ^{*} $Init refers to the pass rate of the initial population generated before the evolutionary loop begins.

with the Nangate 45nm PDK [32] for synthesis, applying a uniform 0.01 ns clock period to all designs. Performance was measured by Pass Rate and PPA Improvement. The Pass Rate indicates the functional correctness of the final design. The PPA Improvement measures the PPA gain over the reference design, reported only for designs with over 50 gates $ ^{234} $. To ensure reproducibility, all scripts, logs, and results are publicly available at our repository [33].

### B. Performance Analysis and Comparison

In this section, we quantitatively analyze the performance of the REvolution framework with various LLMs and compare it against state-of-the-art baseline method. As shown in Table II, our evolutionary approach demonstrates significant effectiveness. REvolution with DeepSeek-V3 achieves the highest final Pass Rate of 95.5% on the VerilogEval benchmark. Notably, the evolutionary loop consistently improves the initial Pass Rate across all models and benchmarks. For instance, with Llama-3.3-70B on the RTLLM benchmark, the Pass Rate increased from 60.0% to 84.0%, a substantial improvement of 24.0 percentage points. Functionally correct designs also showed considerable average PPA improvements. The high improvement rates, such as the 67.0% power reduction with Llama-3.3-70B on RTLLM, are attributable to the non-PPA-optimized nature of the reference designs; for transparency, all detailed synthesis reports and logs are available in our public repository. The average runtime generally correlates with the size and API response speed of the underlying LLM.

We chose VerilogCoder [34] as the primary SOTA baseline for comparison because it reports a final Pass Rate from a single framework execution, which aligns with our methodology, unlike methods that use pass@k metrics. VerilogCoder (GPT-4-Turbo) achieves a notable 94.2% Pass Rate on VerilogEval, a performance that is comparable to our best result of 95.5% with REvolution (DeepSeek-V3). On the Llama architecture, however, a significant performance gap is observed: while VerilogCoder (Llama-3-70B) reaches a 67.3% Pass Rate, our REvolution (Llama-3.3-70B) elevates this to 88.5% on the same benchmark, demonstrating how our approach enhances the base model's capability. This performance difference stems from the distinct methodologies employed. VerilogCoder uses a task and circuit relation graph for planning and a custom AST-based waveform tracing tool for debugging. In contrast, REvolution achieves its results without such specialized tools, instead using a more general and flexible evolutionary approach guided solely by prompt strategies. This highlights a key advantage of our framework: it reduces the need for intricate, domain-specific tool development while still achieving state-of-the-art results.

### C. Case Study: 8-bit Signed Adder

This section presents a case study to provide a detailed, step-by-step illustration of how the REvolution framework operates. We analyze the results for the VerilogEval Prob033 problem, which specifies an 8-bit 2's complement adder with overflow detection, using DeepSeek-V3. The evolutionary process and its results are summarized in Figure 4 (Evolutionary Trajectory) and Figure 5 (PPA Distribution $ ^{5} $).

The process started with a functionally correct design, but with a negative fitness score of -0.046, indicating inferior PPA compared to the reference design. The first successful improvement strategy targeted the overflow detection logic. The LLM's Thought process identified a more efficient XOR-based method, improving the fitness score to 0.0. The next improvement step guided the LLM to implement a structural carry-lookahead architecture. This demonstrates that REvolution can shift a design from behavioral to structural modeling, leading to a significant fitness increase to 0.293. Finally, a Fusion strategy was applied to refine the design further, combining hierarchical carry computation ideas to create a balanced 2-bit block structure, achieving a peak fitness of 0.384. The final evolved design uses a structural carry-lookahead adder, contrasting with the reference design's high-level behavioral implementation.

Beyond the trajectory of a single design, the PPA scatter plot illustrates the broader design space explored by the evolutionary loop. The plot, with designs categorized into three

<div style="text-align: center;"><img src="https://pplines-online.bj.bcebos.com/deploy/official/paddleocr/pp-ocr-vl-15//24803451-fe0b-4382-a84b-403b0643802e/markdown_5/imgs/img_in_chart_box_187_152_1011_489.jpg?authorization=bce-auth-v1%2FALTAKzReLNvew3ySINYJ0fuAMN%2F2026-02-02T13%3A24%3A57Z%2F-1%2F%2Fdc4a35eac941c742a9b85362a0e1beb3d535cd4ff433d2c5e53938bfa727809c" alt="Image" width="69%" /></div>


<div style="text-align: center;">Fig. 4: Evolutionary Trajectory of DeepSeek-V3 on VerilogEval Prob033 problem.</div>


generation groups (Generations 0-4, 5-11, and 12-20), shows a clear trend of PPA optimization. As generations progress, the centroid of the population moves towards the lower-left corner, indicating simultaneous improvements in both power and area. Furthermore, the distribution of all individuals versus the 'Top 5' shows that while the framework maintains diversity, the selection process converges towards superior solutions. In summary, this case study shows that REvolution can optimize logic and implement fundamental design changes, guiding the population towards PPA-optimized regions of the design space.

### D. Ablation Study: Impact of the Evolutionary Loop

To assess whether the framework’s performance gains are attributable to the evolutionary process or simply to an increased volume of design generation, we conducted an ablation study. We compared REvolution against a baseline (“Baseline (Llama-3.3-70B)” in Table II) that generates 200 designs using an Initial Prompt. This number matches the total quantity of designs in a standard REvolution run (10 offspring × 20 generations), ensuring an identical computational budget for LLM calls between the two experiments.

The results show a distinct advantage for the evolutionary method in both functional correctness and PPA optimization. As detailed in Table II, REvolution (Llama-3.3-70B) achieved higher final Pass Rates on both RTLLM (84.0% vs. 70.0%) and VerilogEval (88.5% vs. 79.5%) compared to the baseline. The performance gap is also evident in the PPA metrics. For instance, REvolution yielded a 67.0% power reduction on RTLLM, substantially higher than the baseline's 37.3%. Similarly, its power and clock improvements on VerilogEval (47.3% and 48.2%) significantly exceeded the baseline results (7.7% and 2.3%). In conclusion, this study confirms that REvolution's performance stems from its structured, iterative evolution process, not merely from high-volume sampling. The framework's effectiveness is twofold: the higher Pass Rate demonstrates that the guided prompt strategies systematically correct functional errors, achieving valid solutions beyond the reach of random chance. Concurrently, the superior PPA metrics indicate that the fitness-driven selection process actively steers the design population towards optimal regions of the PPA space. The evolutionary loop is, therefore, the key mechanism enabling these systematic enhancements, yielding results not achievable through an equivalent volume of independent sampling.

<div style="text-align: center;"><img src="https://pplines-online.bj.bcebos.com/deploy/official/paddleocr/pp-ocr-vl-15//24803451-fe0b-4382-a84b-403b0643802e/markdown_5/imgs/img_in_chart_box_638_558_1091_796.jpg?authorization=bce-auth-v1%2FALTAKzReLNvew3ySINYJ0fuAMN%2F2026-02-02T13%3A24%3A57Z%2F-1%2F%2F51ac0a1a5e0790757bcf7300f85845331072abbc0b6a09471f99eb5ad5d1a8e6" alt="Image" width="38%" /></div>


<div style="text-align: center;">Fig. 5: Power-area distribution of design candidates in the evolutionary process of DeepSeek-V3 on VerilogEval Prob033.</div>


## V. Conclusion

This paper addresses the key challenges in LLM-based RTL generation: functional correctness and PPA optimization. To overcome these, we introduced REvolution, a novel framework that combines the generative power of LLMs with the robust search capabilities of EC. Our approach evolves a population of design candidates, each comprising a Thought, Code, and Feedback, using a dual-population algorithm to apply specialized strategies for bug fixing and PPA improvement. The efficiency of this evolutionary process is further enhanced by an adaptive prompt strategy selection mechanism.

Our experimental results demonstrate the effectiveness of the REvolution framework. On the VerilogEval and RTLLM benchmarks, REvolution significantly improved the initial pass rates of various LLMs by up to 24.0 percentage points, achieving a final pass rate of 95.5% that is competitive with state-of-the-art methods. Critically, these results were achieved without domain-specific model fine-tuning or complex external tools, highlighting the architectural advantage of our approach. Moreover, the evolved designs showed significant PPA improvements over the reference designs, confirming REvolution's ability to optimize both functional correctness and hardware efficiency. In conclusion, REvolution offers a new approach for automated RTL design, enabling the discovery of highly optimized hardware solutions through the parallel evolution of multiple candidates.

[1] Z. Pei, H. Zhen, M. Yuan, et al., "BetterV: Controlled Verilog Generation with Discriminative Guidance", Proc. ICML, 2024, pp. 40145-40153.

[2] R. Zhong, X. Du, S. Kai, et al., “LLM4EDA: Emerging Progress in Large Language Models for Electronic Design Automation”, arXiv, 2023, pp. 1-15.

[3] H. Qin, Z. Xie, J. Li, et al., “ReasoningV: Efficient Verilog Code Generation with Adaptive Hybrid Reasoning Model”, arXiv, 2025, pp. 1-9.

[4] M. Liu, N. Pinckney, B. Khailany, et al., “Invited Paper: VerilogEval: Evaluating Large Language Models for Verilog Code Generation”, Proc. ICCAD, 2023, pp. 1-8.

[5] C. Deng, Y.-D. Tsai, G.-T. Liu, et al., “ScaleRTL: Scaling LLMs with Reasoning Data and Test-Time Compute for Accurate RTL Code Generation”, arXiv, 2025, pp. 1-9.

[6] Y. Zhao, W. Fu, S. Li, et al., “Hardware Generation with High Flexibility using Reinforcement Learning Enhanced LLMs”, Proc. DAC, 2025, pp. 1-7.

[7] Y. Zhao, H. Zhang, H. Huang, et al., “MAGE: A Multi-Agent Engine for Automated RTL Code Generation”, arXiv, 2024, pp. 1-7.

[8] M. U. Islam, H. Sami, P.-E. Gaillardon, et al., “EDA-Aware RTL Generation with Large Language Models”, Proc. DATE, 2025, pp. 1-6.

[9] K. Thorat, J. Zhao, Y. Liu, et al., “Advanced Large Language Model (LLM)-Driven Verilog Development: Enhancing Power, Performance, and Area Optimization in Code Synthesis”, arXiv, 2023, pp. 1-8.

[10] Y. Zhao, D. Huang, C. Li, et al., “CodeV: Empowering LLMs with HDL Generation through Multi-Level Summarization”, arXiv, 2024, pp. 1-13.

[11] F. Cui, C. Yin, K. Zhou, et al., "OriGen: Enhancing RTL Code Generation with Code-to-Code Augmentation and Self-Reflection", Proc. ICCAD, 2024, pp. 1-9.

[12] S. Liu, W. Fang, Y. Lu, et al., "RTLCoder: Fully Open-Source and Efficient LLM-Assisted RTL Code Generation Technique", IEEE Trans. CAD, vol. 44, no. 4, 2024, pp. 1448–1461.

[13] K. Chang, K. Wang, N. Yang, et al., "Data is all you need: Finetuning LLMs for chip design via an automated design-data augmentation framework", Proc. DAC, 2024, pp. 1-6.

[14] M. Akyash, K. Azar, and H. Kamali, “RTL++: Graph-enhanced LLM for RTL Code Generation”, arXiv, 2024, pp. 1-7.

[15] K. Min, S. Park, H. Park, et al., “Improving LLM-based Verilog Code Generation with Data Augmentation and RL”, Proc. DATE, 2025, pp. 1-7.

[16] S. Thakur, B. Ahmad, H. Pearce, et al., "VeriGen: A Large Language Model for Verilog Code Generation", ACM Trans. Des. Autom. Electron. Syst., vol. 29, no. 3, 2024, pp. 1–31.

[17] M. Liu, Y.-D. Tsai, W. Zhou, et al., "CraftRTL: High-quality Synthetic Data Generation for Verilog Code Models with Correct-by-Construction Non-Textual Representations and Targeted Code Repair", Proc. ICLR, 2025, pp. 1-46.

[18] M. DeLorenzo, K. Tieu, P. Jana, et al., “Abstractions-of-Thought: Intermediate Representations for LLM Reasoning in Hardware Design”, arXiv, 2025, pp. 1-26.

[19] K. Chang, H. Ren, M. Wang, et al., “Improving Large Language Model Hardware Generating Quality through Post-LLM Search”, Proc. NeurIPS, 2023, pp. 1-13.

[20] J. Zuo, J. Liu, X. Wang, et al., “ComplexVCoder: An LLM-Driven Framework for Systematic Generation of Complex Verilog Code”, arXiv, 2025, pp. 1-9.

[21] B. Romera-Paredes, M. Barekatain, A. Novikov, et al., "Mathematical discoveries from program search with large language models", Nature, vol. 625, no. 7995, 2024, pp. 468–475.

[22] A. Novikov, N. Vũ, M. Eisenberger, et al., “AlphaEvolve: A coding agent for scientific and algorithmic discovery”, arXiv, 2025, pp. 1–44.

[23] F. Liu, X. Tong, M. Yuan, et al., “Evolution of Heuristics: Towards Efficient Automatic Algorithm Design Using Large Language Model”, Proc. ICML, 2024, pp. 32201 - 32223.

[24] R. S. Sutton and A. G. Barto, Reinforcement Learning: An Introduction, Cambridge, MA: MIT Press, 1998.

[25] GPT-4.1-mini, https://platform.openai.com/docs/models/gpt-4.1-mini

[26] DeenSeek-AI "DeenSeek-V3 Technical Report" arXiv 2024 1–53

[26] DeepSeek-AI, "DeepSeek-V3 Technical Report", arXiv, 2024, pp. 1–53.

[27] Llama Team, "The Llama 3 Herd of Models", arXiv, 2024, pp. 1–92.

[28] N. Pinckney, C. Batten, M. Liu, et al., “Revisiting VerilogEval: A Year of Improvements in Large-Language Models for Hardware Code Generation”, arXiv, 2024, pp. 1–21.

[29] S. Liu, Y. Lu, W. Fang, et al., “OpenLLM-RTL: Open Dataset and Benchmark for LLM-Aided Design RTL Generation”, Proc. ICCAD, 2024, pp. 1-9.

[30] Iverilog, https://github.com/steveicarus/iverilog

[31] Yosys, https://github.com/YosysHQ/yosys

[32] Nangate45 PDK, https://eda.ncsu.edu/freepdk/freepdk45/

[33] REvolution, https://github.com/kmcho2019/REvolution/releases/tag/aspdac2026-submission

[34] C.-T. Ho, H. Ren, and B. Khailany, “VerilogCoder: Autonomous Verilog Coding Agents with Graph-based Planning and Abstract Syntax Tree (AST)-based Waveform Tracing Tool”, Proc. AAAI, 2025, pp. 1 - 8.

