module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q; // Output of positive-edge triggered flip-flop
reg neg_edge_q; // Output of negative-edge triggered flip-flop

// Positive-edge triggered flip-flop
always @(posedge clk)
    pos_edge_q <= d;

// Negative-edge triggered flip-flop
always @(negedge clk)
    neg_edge_q <= d;

// Use a multiplexer to select the output based on the clock edge
always @(*)
    q = (clk) ? pos_edge_q : neg_edge_q;

endmodule