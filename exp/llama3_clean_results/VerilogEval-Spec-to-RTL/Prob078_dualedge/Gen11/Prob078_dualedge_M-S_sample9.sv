module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal flip-flops for positive and negative edges
reg pos_q, neg_q;

// Positive-edge triggered flip-flop
always @(posedge clk) pos_q <= d;

// Negative-edge triggered flip-flop
always @(negedge clk) neg_q <= d;

// Select output based on clock edge
assign q = clk ? pos_q : neg_q;

endmodule