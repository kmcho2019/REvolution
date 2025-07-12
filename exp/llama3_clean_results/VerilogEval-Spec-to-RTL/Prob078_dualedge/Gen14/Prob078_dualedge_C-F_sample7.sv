module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q;  // Positive-edge flip-flop output
reg neg_edge_q;  // Negative-edge flip-flop output

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    pos_edge_q <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    neg_edge_q <= d;
end

// Select output based on clock edge using continuous assignment
assign q = (clk) ? pos_edge_q : neg_edge_q;

endmodule