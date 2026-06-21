# Representative Implementation Gallery

Selection rules are fixed before interpretation: largest style-diversity HV, median Pareto cluster count, lowest valid-PPA rate, and the 20260618 Auto-BD negative-control case.

## best_supported

- Problem: `RTLLM/Prob003_adder_32bit`
- Selection rule: largest style-diversity HV
- Style cluster: `wire_assign`
- Fitness: 0.5579
- PPA: area=137, power=7.97e-05, eff_clk_period=0
- Motif signature: `70f9d2b5c145a8ebef9aea6b03505da49a9143d59bae66f5c374c06fad2476ef`
- Manual-BD values are unavailable in this historical RTLLM corpus; lexical structural proxy values are shown instead.
- Lexical proxy: assign=4.0, always=0.0, case=0.0, if=0.0, ternary=0.0
- RTL snippet:

```verilog
module cla16 (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    // Propagate and generate for each bit
    wire [15:0] p = A ^ B;   // propagate
    wire [15:0] g = A & B;   // generate

    // Carry vector (17 bits: c0..c16)
    wire [16:0] c;
    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // Sum bits
    assign S = p ^ c[15:0];
```

## null_or_median

- Problem: `RTLLM/Prob048_pe`
- Selection rule: median Pareto cluster count
- Style cluster: `register_sequential`
- Fitness: 0.1234
- PPA: area=3682, power=0.475, eff_clk_period=0.8
- Motif signature: `33498abb3ca45fd54ec4e794cac74a7bea0dbc11f7e326954806a822a82b98c3`
- Manual-BD values are unavailable in this historical RTLLM corpus; lexical structural proxy values are shown instead.
- Lexical proxy: assign=1.0, always=1.0, case=0.0, if=2.0, ternary=0.0
- RTL snippet:

```verilog
module pe #(
    parameter WIDTH = 32
) (
    input  wire               clk,
    input  wire               rst, // active-high synchronous reset
    input  wire [WIDTH-1:0]   a,
    input  wire [WIDTH-1:0]   b,
    output reg  [WIDTH-1:0]   c
);

    // ---------------------------------------------------------------------
    // Signed multiplication (WIDTH‑by‑WIDTH) producing a 2*WIDTH product.
    // Only the lower WIDTH bits are accumulated, matching the original
    // 32‑bit accumulator specification.
    // ---------------------------------------------------------------------
    wire signed [2*WIDTH-1:0] prod;
    assign prod = $signed(a) * $signed(b);

    // ---------------------------------------------------------------------
    // Enable signal: avoid unnecessary toggling when the lower part of the
    // product is zero (helps dynamic power).
    // ---------------------------------------------------------------------
    wire prod_nonzero = |prod[WIDTH-1:0];

```

## negative_funnel

- Problem: `RTLLM/Prob006_adder_pipe_64bit`
- Selection rule: lowest valid-PPA rate
- No valid-PPA representative exists for this selected negative-funnel case.
- Interpretation: implementation diversity is not useful for PPA when it does not survive the validity funnel.

## auto_bd_control

- Problem: `20260618 ST-NOD/VQ`
- Selection rule: predeclared negative-control evidence
- Evidence: 20260618 Auto-BD final negative decision.
- Interpretation: ST-NOD/VQ/random/control descriptor arms organized archives without robust valid-PPA uplift.
- Source: `/workspace/docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_final_negative_decision.md`
