module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q; // Output of positive-edge triggered flip-flop
reg neg_edge_q; // Output of the latch for negative edge

// Positive-edge triggered flip-flop
always @(posedge clk)
    pos_edge_q <= d;

// Latch for negative edge
always @(negedge clk or posedge d)
    if (~clk)
        neg_edge_q <= d;

// Use continuous assignment to select the output based on the clock edge
assign q = (clk) ? pos_edge_q : neg_edge_q;

endmodule