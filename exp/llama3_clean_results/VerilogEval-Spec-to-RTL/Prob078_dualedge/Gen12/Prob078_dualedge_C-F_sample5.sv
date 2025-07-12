module TopModule(
    input clk,
    input d,
    output reg q
);

// Registers to hold the output of positive and negative edge triggered flip-flops
reg pos_edge_q;
reg neg_edge_q;

// Positive edge triggered flip-flop
always @(posedge clk)
    pos_edge_q <= d;

// Negative edge triggered flip-flop
always @(negedge clk)
    neg_edge_q <= d;

// Direct assignment of output 'q' based on clock state
assign q = (clk) ? pos_edge_q : neg_edge_q;

endmodule