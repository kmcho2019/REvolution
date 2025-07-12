module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Positive-edge flip-flop output
reg q_neg;  // Negative-edge flip-flop output

always @(posedge clk) q_pos <= d;
always @(negedge clk) q_neg <= d;

// Directly assign q based on the values of q_pos and q_neg, 
// which are updated on their respective clock edges.
assign q = clk ? q_pos : q_neg;

endmodule