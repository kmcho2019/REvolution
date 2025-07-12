module TopModule(
    input clk,
    input d,
    output reg q
);

// Use descriptive variable names for clarity
reg pos_edge_output;  // Output of positive-edge triggered flip-flop
reg neg_edge_output;  // Output of negative-edge triggered flip-flop

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    pos_edge_output <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    neg_edge_output <= d;
end

// Directly assign the output based on the clock edge, minimizing additional logic
assign q = (clk) ? pos_edge_output : neg_edge_output;

endmodule