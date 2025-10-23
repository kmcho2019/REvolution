module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q;
reg neg_edge_q;

// Positive edge triggered flip-flop
always @(posedge clk)
    pos_edge_q <= d;

// Negative edge triggered flip-flop
always @(negedge clk)
    neg_edge_q <= d;

// Select output based on clock edge
always @(*)
    q = (clk)? pos_edge_q : neg_edge_q;

endmodule