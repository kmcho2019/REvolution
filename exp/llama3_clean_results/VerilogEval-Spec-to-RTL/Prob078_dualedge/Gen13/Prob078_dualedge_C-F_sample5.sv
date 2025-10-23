module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q;  // Output of positive-edge triggered flip-flop
reg neg_edge_q;  // Output of negative-edge triggered flip-flop

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    pos_edge_q <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    neg_edge_q <= d;
end

// Directly assign the output based on the clock edge, minimizing additional logic
always @(*) begin
    q = (clk) ? pos_edge_q : neg_edge_q;
end

endmodule