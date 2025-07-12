module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q;  // Output of the positive-edge triggered flip-flop
reg neg_edge_q;  // Output of the negative-edge triggered flip-flop

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    pos_edge_q <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    neg_edge_q <= d;
end

// Select output based on clock edge using continuous assignment for efficiency
assign q = (clk) ? pos_edge_q : neg_edge_q;

endmodule