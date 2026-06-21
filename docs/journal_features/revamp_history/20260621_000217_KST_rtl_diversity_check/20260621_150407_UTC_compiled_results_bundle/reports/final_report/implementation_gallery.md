# Representative Implementation Gallery

Selection rules are fixed before interpretation: largest style-diversity HV, median Pareto cluster count, lowest valid-PPA rate, and the 20260618 Auto-BD negative-control case.

## best_supported

- Problem: `aspdac2026/llama3_clean_results/RTLLM/Prob050_square_wave`
- Selection rule: largest style-diversity HV
- Style cluster: `register_sequential`
- Fitness: 0.9972
- PPA: area=1, power=2.36e-08, eff_clk_period=0
- Motif signature: ``
- Manual-BD values are unavailable in this historical RTLLM corpus; lexical structural proxy values are shown instead.
- Lexical proxy: assign=0.0, always=2.0, case=0.0, if=0.0, ternary=0.0
- RTL snippet:

```verilog
module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

// Assuming a maximum of 256 different wave patterns
reg [7:0] lut_index;
reg [7:0] wave_pattern [0:255]; // Lookup table

// Initialize the lookup table with pre-computed wave patterns
initial begin
    for (int i = 0; i < 256; i++) begin
        // For simplicity, assume wave_pattern[i] is initialized with a default value
        // In a real implementation, pre-computed wave patterns would be stored here
        wave_pattern[i] = 8'd0;
    end
end

// Frequency encoder to generate the LUT index
always @(posedge clk) begin
    lut_index <= freq;
end

```

## null_or_median

- Problem: `aspdac2026/llama3_clean_results/VerilogEval-Spec-to-RTL/Prob130_circuit5`
- Selection rule: median Pareto cluster count
- Style cluster: `control_case`
- Fitness: 0.1301
- PPA: area=32, power=0.00123, eff_clk_period=0
- Motif signature: ``
- Manual-BD values are unavailable in this historical RTLLM corpus; lexical structural proxy values are shown instead.
- Lexical proxy: assign=0.0, always=1.0, case=1.0, if=1.0, ternary=4.0
- RTL snippet:

```verilog
module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    case (c[1:0])
        2'b00: q = (c == 4'd0) ? b : 4'd15;
        2'b01: q = (c == 4'd1) ? e : 4'd15;
        2'b10: q = (c == 4'd2) ? a : 4'd15;
        2'b11: q = (c == 4'd3) ? d : 4'd15;
    endcase

    if (c[3:2] != 2'b00) begin
        q = 4'd15;
    end
end

endmodule
```

## negative_funnel

- Problem: `aspdac2026/deepseek_clean_results/VerilogEval-Spec-to-RTL/Prob113_2012_q1g`
- Selection rule: lowest valid-PPA rate
- No valid-PPA representative exists for this selected negative-funnel case.
- Interpretation: implementation diversity is not useful for PPA when it does not survive the validity funnel.

## auto_bd_control

- Problem: `20260618 ST-NOD/VQ`
- Selection rule: predeclared negative-control evidence
- Evidence: 20260618 Auto-BD final negative decision.
- Interpretation: ST-NOD/VQ/random/control descriptor arms organized archives without robust valid-PPA uplift.
- Source: `/workspace/docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/auto_bd_final_negative_decision.md`
