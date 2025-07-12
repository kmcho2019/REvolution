module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;

always @(posedge clk) q_pos <= d;
always @(negedge clk) q_neg <= d;

// Using a multiplexer for output selection
assign q = (clk == 1'b1) ? q_pos : q_neg;

// Alternatively, to make it more explicit and potentially more efficient:
// assign q = ~clk ? q_neg : q_pos;

endmodule