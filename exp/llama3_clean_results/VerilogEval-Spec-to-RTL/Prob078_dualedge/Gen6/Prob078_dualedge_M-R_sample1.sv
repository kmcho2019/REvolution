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

// Use assign for output selection
assign q = (clk) ? pos_edge_q : neg_edge_q;

endmodule