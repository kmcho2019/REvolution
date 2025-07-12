module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output of the dual-edge triggered flip-flop
);

reg pos_edge_q, neg_edge_q;

// Capture data on positive and negative edges of the clock
always @(posedge clk) pos_edge_q <= d;
always @(negedge clk) neg_edge_q <= d;

// Select output based on clock state, using a simple conditional statement
assign q = (clk == 1'b1) ? pos_edge_q : neg_edge_q;

endmodule