module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos; // Output of positive-edge triggered flip-flop
reg q_neg; // Output of negative-edge triggered flip-flop

// Positive-edge triggered flip-flop
always @(posedge clk)
    q_pos <= d;

// Negative-edge triggered flip-flop
always @(negedge clk)
    q_neg <= d;

// Multiplexer to select output based on clock edge
always @(*)
    q <= (clk) ? q_pos : q_neg;

endmodule