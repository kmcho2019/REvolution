module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output of the dual-edge triggered flip-flop
);

reg pos_edge_q, neg_edge_q;

always @(posedge clk) pos_edge_q <= d;
always @(negedge clk) neg_edge_q <= d;
assign q = clk ? pos_edge_q : neg_edge_q;

endmodule