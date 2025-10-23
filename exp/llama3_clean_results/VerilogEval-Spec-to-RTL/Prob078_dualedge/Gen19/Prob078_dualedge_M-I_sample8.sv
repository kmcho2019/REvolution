module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Positive-edge flip-flop output
reg q_neg;  // Negative-edge flip-flop output

// Using always blocks for sequential logic
always @(posedge clk) q_pos <= d;
always @(negedge clk) q_neg <= d;

// Output selection based on clock edge, maintaining simplicity
assign q = (clk)? q_pos : q_neg;

// Area optimization: Considering the design's simplicity, significant area reductions might be challenging.
// However, applying synthesis directives for area optimization can guide the synthesis tool:
// synthesis attribute area_opt of TopModule is "high";

endmodule