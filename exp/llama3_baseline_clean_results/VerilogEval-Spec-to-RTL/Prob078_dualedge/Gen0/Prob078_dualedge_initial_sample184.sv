module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_pos; // Positive edge flip-flop output
reg q_neg; // Negative edge flip-flop output

// Positive edge flip-flop
always @(posedge clk)
    q_pos <= d;

// Negative edge flip-flop
always @(negedge clk)
    q_neg <= d;

// Combine outputs, preferring the more recently captured value
assign q = (clk)? q_pos : q_neg;

endmodule